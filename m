Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0KMGBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 01:01:43 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64769 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab0KMGBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 01:01:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=COFS4tcaDxrTjNHxprut561JT4w4UOqUU8WWnPd4SSj11YaI0AdLKgoMVYelaxpuuX
         zdgWGXAeqR5ggxMaJg/7U1ICdVZuciG35VikwpxYJycxiYSSS5bsBx3LXNoWt+kmmsEl
         0q3QUJmbS5pkqyh1KFxJ2y3QOTmJDFIM9CmL0=
Message-ID: <4CDE29C2.5040206@garzik.org>
Date: Sat, 13 Nov 2010 01:01:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        James Bottomley <James.Bottomley@suse.de>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] SCSI host lock push-down
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com> <20101113051635.GA11613@havoc.gtf.org>
In-Reply-To: <20101113051635.GA11613@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2010 12:16 AM, Jeff Garzik wrote:
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index 9e71ac6..f9581a3 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -2198,7 +2198,7 @@ no_command:
>    * Returns: 0 on success, else error.
>    * Notes: io_request_lock is held, interrupts are disabled.
>    */
> -int fas216_queue_command(struct scsi_cmnd *SCpnt,
> +static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
>   			 void (*done)(struct scsi_cmnd *))
>   {
>   	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
> @@ -2240,6 +2240,8 @@ int fas216_queue_command(struct scsi_cmnd *SCpnt,
>   	return result;
>   }
>
> +DEF_SCSI_QCMD(fas216_queue_command)
> +
>   /**
>    * fas216_internal_done - trigger restart of a waiting thread in fas216_noqueue_command
>    * @SCpnt: Command to wake
> @@ -2263,7 +2265,7 @@ static void fas216_internal_done(struct scsi_cmnd *SCpnt)
>    * Returns: scsi result code.
>    * Notes: io_request_lock is held, interrupts are disabled.
>    */
> -int fas216_noqueue_command(struct scsi_cmnd *SCpnt,
> +static int fas216_noqueue_command_lck(struct scsi_cmnd *SCpnt,
>   			   void (*done)(struct scsi_cmnd *))
>   {
>   	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
> @@ -2277,7 +2279,7 @@ int fas216_noqueue_command(struct scsi_cmnd *SCpnt,
>   	BUG_ON(info->scsi.irq != NO_IRQ);
>
>   	info->internal_done = 0;
> -	fas216_queue_command(SCpnt, fas216_internal_done);
> +	fas216_queue_command(SCpnt->device->host, SCpnt, fas216_internal_done);
>
>   	/*
>   	 * This wastes time, since we can't return until the command is


hmmmm.

Linus's suggestion to add Scsi_Host to queuecommand seems to have had a 
helpful side effect, exposing a minor bug present in nab's (v1), Andi's 
(v2), my v3 and v4 push-down patches:

A few odd ducks, such as fas16 or ancient megaraid, call their own 
->queuecommand directly.  None of the major SCSI drivers do this, 
thankfully.

The host lock push-down patch should be calling the _lck function in 
those rare cases, otherwise we've created a deadlock.

Time for v5...

	Jeff



