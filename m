Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0LISWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:22:20 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:40491 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab0LISWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:22:18 -0500
Message-ID: <4D011E05.5030205@ru.mvista.com>
Date: Thu, 09 Dec 2010 21:20:53 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kay.sievers@vrfy.org, jack@suse.cz,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 5/8] scsi: fix TUR error handling in sr_media_change()
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <1291838262-21274-6-git-send-email-tj@kernel.org>
In-Reply-To: <1291838262-21274-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Tejun Heo wrote:

> sr_test_unit_ready() returns 0 iff TUR succeeded - IOW, when media is
> present and the device is actually ready, so the return value wouldn't
> be zero when TUR ends with sense data. sr_media_change() incorrectly
> tests (retval || (scsi_sense_valid(sshdr)...)) when it tries to test
> whether TUR failed without sense data or with sense data indicating
> media-not-present.

> Fix the test using scsi_status_is_good() and update comments.

> Signed-off-by: Tejun Heo <tj@kernel.org>
[...]

> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index d7b383c..deb24f0 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -214,13 +214,17 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
>  
>  	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
>  	retval = sr_test_unit_ready(cd->device, sshdr);
> -	if (retval || (scsi_sense_valid(sshdr) &&
> -		       /* 0x3a is medium not present */
> -		       sshdr->asc == 0x3a)) {
> -		/* Media not present or unable to test, unit probably not
> -		 * ready. This usually means there is no disc in the drive.
> -		 * Mark as changed, and we will figure it out later once
> -		 * the drive is available again.
> +	/*
> +	 * Media is considered to be present if TUR succeeds or fails with
> +	 * sense data indicating something other than media-not-present
> +	 * (ASC 0x3a).
> +	 */
> +	if (!scsi_status_is_good(retval) &&
> +	    (!scsi_sense_valid(sshdr) || sshdr->asc == 0x3a)) {
> +		/*
> +		 * Probably not media in the device.  Mark as changed, and

    s/not/no/

WBR, Sergei

