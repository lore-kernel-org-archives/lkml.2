Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab1EYUlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:41:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34556 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab1EYUlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:41:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qcC8Hu0bLpSJ4OhSnHNlTjL7aRq86kmCYQzyfAnAH1Yl0MO0iepj1MF/SMCg4pQIUN
         /DnLZtYQMCpaTTwi3+KaH6PB8HyMeRNAVq5Our2TJP0dRLrB4aQSEoIWRmqoNFsyDbLE
         waVooGBrr9BlLLkXmUTGi/gTAp7hzVT/8Db10=
MIME-Version: 1.0
In-Reply-To: <1303825011-6345-1-git-send-email-yxlraid@gmail.com>
References: <mvsas-support-task-collector-mode>
	<1303825011-6345-1-git-send-email-yxlraid@gmail.com>
Date: Wed, 25 May 2011 13:41:47 -0700
X-Google-Sender-Auth: vl65GSlmtKrJKyF7-hjHAUb6CNg
Message-ID: <BANLkTi=xZnK6--p0gp+MAH1aRRJsPw9=Lg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mvsas: add support for Task collector mode and fixed
 relative bugs
From: Dan Williams <dan.j.williams@intel.com>
To: yxlraid@gmail.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 6:36 AM,  <yxlraid@gmail.com> wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
>
> 1.Add support for Task collector mode.
> 2.Fixed relative collector mode bug:
> - I/O failed when disks is on two ports
> - system hang when hotplug disk
> - system hang when unplug disk during run IO
> 3.Unlock ap->lock within .lldd_execute_task for direct mode to improve performance

Can you share more details about the performance impact?  Seems like
this should be made generic across all libsas drivers... see below.

[..]
> +static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
> +                               struct completion *completion, int is_tmf,
> +                               struct mvs_tmf_task *tmf)
> +{
> +       struct domain_device *dev = task->dev;
> +       struct mvs_info *mvi = NULL;
> +       u32 rc = 0;
> +       u32 pass = 0;
> +       unsigned long flags = 0;
> +
> +       mvi = ((struct mvs_device *)task->dev->lldd_dev)->mvi_info;
> +
> +       if ((dev->dev_type == SATA_DEV) && (dev->sata_dev.ap != NULL))
> +               spin_unlock_irq(dev->sata_dev.ap->lock);
> +
> +       spin_lock_irqsave(&mvi->lock, flags);

This is fine in current code, but isn't it dangerous to assume that
libata is the only agent that might have interrupts disabled?
Especially confusing since this code turns around and uses
spin_lock_irqsave() as the very next step, which leaves a casual
reader wondering what the appropriate lock level is.

Any objections to unifying this lock management in libsas to relieve
drivers of implementing this differently/incorrectly?  I'll send a
patch.

Also, we have seen the dev->sata_dev.ap == NULL problem as well.  Have
not fully tracked it down (are we issuing i/o before
sas_ata_init_host_and_port?).  But again, shouldn't libsas be making
guarantees about the state of the sata device?  At least pm8001 and
current isci still get this wrong.  And it would be better to fix it
once for all drivers.

--
Dan
