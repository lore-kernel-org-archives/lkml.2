Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2BEJSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 04:18:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47213 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2BEJSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 04:18:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAKYAXd9k5i2_SuD8YSJeG25CBpK0b4jQGJstc-Ef1jD20cph1Q@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
 <1328158649-4137-5-git-send-email-vinholikatti@gmail.com> <CAKYAXd9k5i2_SuD8YSJeG25CBpK0b4jQGJstc-Ef1jD20cph1Q@mail.gmail.com>
From: Santosh Y <santoshsy@gmail.com>
Date: Sun, 5 Feb 2012 14:47:46 +0530
Message-ID: <CALMYJDtpdFcVs_b-ePBnVHi-xkPc0NUST1_9WhpHsjoLaVnpUQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] [SCSI] ufshcd: SCSI error handling
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>,
        James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org,
        arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org,
        vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 1:07 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
>> +
>> +/**
>> + * ufshcd_abort - abort a specific command
>> + * @cmd: SCSI command pointer
>> + *
>> + * Returns 0 on success, non-zero value on failure
>> + */
>> +static int ufshcd_abort(struct scsi_cmnd *cmd)
>> +{
>> +       struct Scsi_Host *host;
>> +       struct ufs_hba *hba;
>> +       unsigned long flags;
>> +       unsigned int tag;
>> +       unsigned int pos;
>> +       int err;
>> +
>> +       host = cmd->device->host;
>> +       hba = (struct ufs_hba *) host->hostdata;
>> +       tag = cmd->request->tag;
>> +
>> +       spin_lock_irqsave(host->host_lock, flags);
>> +       pos = (1 << tag);
>> +
>> +       /* check if command is still pending */
>> +       if (!(hba->outstanding_reqs & pos)) {
>> +               err = -1;
>> +               spin_unlock_irqrestore(host->host_lock, flags);
>> +               goto out;
>> +       }
>> +
>> +       err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_ABORT_TASK);
> Hi.
> You called spin_lock_irqsave in ufshcd_issue_tm_cmd() without
> spin_unlock_irqrestore.

Thanks for reviewing the code. We'll correct it.
Please let us know your comments on the other patches too.

>
>> +       if (!err) {
>> +               spin_lock_irqsave(host->host_lock, flags);
> This case is same also.
> Thanks.
>> +               scsi_dma_unmap(cmd);
>> +
>> +               /* clear the respective UTRLCLR bit */
>> +               writel(~pos,
>> +                       (UFSHCD_MMIO_BASE +
>> +                        REG_UTP_TRANSFER_REQ_LIST_CLEAR));
>> +               hba->outstanding_reqs &= ~pos;
>> +               hba->lrb[tag].cmd = NULL;
>> +               spin_unlock_irqrestore(host->host_lock, flags);
>> +       }
>> +out:
>> +       return err;
>> +}
>> +

-- 
~Santosh
