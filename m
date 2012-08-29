Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab2H2KSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 06:18:14 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:60146 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911Ab2H2KSM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 06:18:12 -0400
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldv-project@ispras.ru" <ldv-project@ispras.ru>
Date: Wed, 29 Aug 2012 15:48:06 +0530
Subject: RE: [PATCH v2] [SCSI] mpt2sas: fix double mutex lock in
 NON_BLOCKING state
Thread-Topic: [PATCH v2] [SCSI] mpt2sas: fix double mutex lock in
 NON_BLOCKING state
Thread-Index: Ac2FKtMHyxffe1K1QlCjJx26zrKENgApFAAA
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E20ADBF8@inbmail02.lsi.com>
References: <1346164683-9315-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1346164683-9315-1-git-send-email-khoroshilov@ispras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

This patch seem to be fine. Please consider this patch as Acked-by: "Sreekanth Reddy" <sreekanth.reddy@lsi.com>

Regards,
Sreekanth.

> -----Original Message-----
> From: Alexey Khoroshilov [mailto:khoroshilov@ispras.ru]
> Sent: Tuesday, August 28, 2012 8:08 PM
> To: James E.J. Bottomley
> Cc: Alexey Khoroshilov; linux-scsi@vger.kernel.org; Nandigama,
> Nagalakshmi; Reddy, Sreekanth; linux-kernel@vger.kernel.org; ldv-
> project@ispras.ru
> Subject: [PATCH v2] [SCSI] mpt2sas: fix double mutex lock in
> NON_BLOCKING state
> 
> If state is NON_BLOCKING and mutex_trylock is succeed,
> the control flow goes to mutex_lock_interruptible() that is a deadlock.
> 
> The previous version of the patch becomes obsolete after
> code movement in commit 913809f6.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_ctl.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> index 49bdd2d..d29ea56 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> @@ -2181,8 +2181,10 @@ _ctl_ioctl_main(struct file *file, unsigned int
> cmd, void __user *arg,
>  		return -EAGAIN;
> 
>  	state = (file->f_flags & O_NONBLOCK) ? NON_BLOCKING : BLOCKING;
> -	if (state == NON_BLOCKING && !mutex_trylock(&ioc-
> >ctl_cmds.mutex))
> -		return -EAGAIN;
> +	if (state == NON_BLOCKING) {
> +		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
> +			return -EAGAIN;
> +	}
>  	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
>  		return -ERESTARTSYS;
> 
> --
> 1.7.9.5

