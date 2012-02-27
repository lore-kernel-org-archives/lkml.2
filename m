Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2B0GVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:21:21 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57583 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2B0GVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:21:19 -0500
MIME-Version: 1.0
In-Reply-To: <4F493238.4020907@cs.wisc.edu>
References: <1330067945-9128-1-git-send-email-santoshsy@gmail.com>
 <1330067945-9128-3-git-send-email-santoshsy@gmail.com> <4F493238.4020907@cs.wisc.edu>
From: Santosh Y <santoshsy@gmail.com>
Date: Mon, 27 Feb 2012 11:50:56 +0530
Message-ID: <CALMYJDv1mPPMBSviHkKF09JOdvVz=sEMj6HuVk_TR0Zr+iFKjg@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] [SCSI] ufshcd: UFS UTP Transfer requests handling
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, arnd@linaro.org,
        girish.shivananjappa@linaro.org, saugata.das@linaro.org,
        vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com,
        yejin.moon@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com,
        nala.la@samsung.com, stephen.doel@linaro.org, sreekumar.c@samsung.com,
        Vinayak Holikatti <vinholikatti@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  #include "ufs.h"
>> @@ -75,6 +76,8 @@ enum {
>>       UFSHCD_MAX_CHANNEL      = 0,
>>       UFSHCD_MAX_ID           = 1,
>>       UFSHCD_MAX_LUNS         = 8,
>> +     UFSHCD_CMD_PER_LUN      = 32,
>> +     UFSHCD_CAN_QUEUE        = 32,
>
>
> Is the can queue right, or are you working around a issue in the shared
> tag map code, or is this due to how you are tracking outstanding reqs
> (just a unsigned long so limited by that)?
>
> Can you support multiple luns per host? If so, this seems low for normal
> HBAs. Is this low due to the hw or something? If you have multiple luns
> then you are going to get a burst of 32 IOs and the host will work on
> them, then when those are done we will send IO to the next device, then
> repeat. For normal HBAs we would have can_queue = cmd_per_lun * X, so we
> can do IO on X devices at the same time.
>

The host can support multiple LUNS, but the UFS host controller can
support only 32 outstanding commands.
So can queue is set to 32.

>> + *
>> + * Returns 0 for success, non-zero in case of failure
>> + */
>> +static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>> +{
>> +     struct ufshcd_lrb *lrbp;
>> +     struct ufs_hba *hba;
>> +     unsigned long flags;
>> +     int tag;
>> +     int err = 0;
>> +
>> +     hba = (struct ufs_hba *) &host->hostdata[0];
>
>
> Use shost_priv instead of accessing hostdata. Check the rest of the
> driver for this.
>

ok, will use shost_priv.

>> +
>> +/**
>> + * ufshcd_adjust_lun_qdepth - Update LUN queue depth if device responds with
>> + *                         SAM_STAT_TASK_SET_FULL SCSI command status.
>> + * @cmd: pointer to SCSI command
>> + */
>> +static void ufshcd_adjust_lun_qdepth(struct scsi_cmnd *cmd)
>> +{
>> +     struct ufs_hba *hba;
>> +     int i;
>> +     int lun_qdepth = 0;
>> +
>> +     hba = (struct ufs_hba *) cmd->device->host->hostdata;
>> +
>> +     /*
>> +      * LUN queue depth can be obtained by counting outstanding commands
>> +      * on the LUN.
>> +      */
>> +     for (i = 0; i < hba->nutrs; i++) {
>> +             if (test_bit(i, &hba->outstanding_reqs)) {
>> +
>> +                     /*
>> +                      * Check if the outstanding command belongs
>> +                      * to the LUN which reported SAM_STAT_TASK_SET_FULL.
>> +                      */
>> +                     if (cmd->device->lun == hba->lrb[i].lun)
>> +                             lun_qdepth++;
>> +             }
>> +     }
>> +
>> +     /*
>> +      * LUN queue depth will be total outstanding commands, except the
>> +      * command for which the LUN reported SAM_STAT_TASK_SET_FULL.
>> +      */
>> +     scsi_adjust_queue_depth(cmd->device, MSG_SIMPLE_TAG, lun_qdepth - 1);
>> +}
>> +
>> +/**
>> + * ufshcd_scsi_cmd_status - Update SCSI command result based on SCSI status
>> + * @lrb: pointer to local reference block of completed command
>> + * @scsi_status: SCSI command status
>> + *
>> + * Returns value base on SCSI command status
>> + */
>> +static inline int
>> +ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
>> +{
>> +     int result = 0;
>> +
>> +     switch (scsi_status) {
>> +     case SAM_STAT_GOOD:
>> +             result |= DID_OK << 16 |
>> +                       COMMAND_COMPLETE << 8 |
>> +                       SAM_STAT_GOOD;
>> +             break;
>> +     case SAM_STAT_CHECK_CONDITION:
>> +             result |= DRIVER_SENSE << 24 |
>
> scsi ml will set the driver sense bit for you when it completes the
> command in scsi_finish_command. No need for the driver to touch this.
>

ok, i'll change it.

>
>> +                       DRIVER_OK << 16 |
>> +                       COMMAND_COMPLETE << 8 |
>> +                       SAM_STAT_CHECK_CONDITION;
>> +             ufshcd_copy_sense_data(lrbp);
>> +             break;
>> +     case SAM_STAT_BUSY:
>> +             result |= DID_BUS_BUSY << 16 |
>> +                       SAM_STAT_BUSY;
>
> If you got sam stat busy just set that. You do not need to set the host
> byte and you do not want to, because the scsi_error.c handling will be
> incorrect. Instead of retrying until sam stat busy is no longer returned
> (or until cmd->retries * cmd->timeout) you only get 5 retries.
>

Ok, I'll change it.

>
>> +             break;
>> +     case SAM_STAT_TASK_SET_FULL:
>> +
>> +             /*
>> +              * If a LUN reports SAM_STAT_TASK_SET_FULL, then the LUN queue
>> +              * depth needs to be adjusted to the exact number of
>> +              * outstanding commands the LUN can handle at any given time.
>> +              */
>> +             ufshcd_adjust_lun_qdepth(lrbp->cmd);
>> +             result |= DID_SOFT_ERROR << 16 |
>> +                       SAM_STAT_TASK_SET_FULL;
>
>
> Same here. Just set the sam stat part.
>
>
>> +             break;
>> +     case SAM_STAT_TASK_ABORTED:
>> +             result |=  DID_ABORT << 16 |
>> +                        ABORT_TASK << 8 |
>> +                        SAM_STAT_TASK_ABORTED;
>
> Same.
>

ok.

>> +             break;
>> +     default:
>> +             result |= DID_ERROR << 16;
>> +             break;
>> +     } /* end of switch */
>> +
>> +     return result;
>> +}
>> +
>> +/**
>>  /**
>> @@ -809,7 +1295,13 @@ static struct scsi_host_template ufshcd_driver_template = {
>>       .module                 = THIS_MODULE,
>>       .name                   = UFSHCD,
>>       .proc_name              = UFSHCD,
>> +     .queuecommand           = ufshcd_queuecommand,
>> +     .slave_alloc            = ufshcd_slave_alloc,
>> +     .slave_destroy          = ufshcd_slave_destroy,
>>       .this_id                = -1,
>> +     .sg_tablesize           = SG_ALL,
>> +     .cmd_per_lun            = UFSHCD_CMD_PER_LUN,
>> +     .can_queue              = UFSHCD_CAN_QUEUE,
>
> Did you want a  change_queue_depth callout?
>
>>  };
>>

No, command per LUN is set to maximum outstanding commands UFS
controller can support.
In case of queue full, the queue depth for a LUN will be calculated
and set in ufshcd_adjust_lun_qdepth.
So I don't think change_queue_depth will be necessary.

Thanks for reviewing, please let me know if you find any issues in
other patches as well.

-- 
~Santosh
