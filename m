Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1AaKMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:12:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36831 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1AaKMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:12:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PeKCZ2buqK4gvbwBjHBVvKrbTqVGJn73CJqEEYPIslFhLVYmcCDTeK5ZJ4dvP88DLU
         F/RfC8QZ58eZ/4AiPcgJQNVlp7vsy0Suifbr/RMdhYuZdDaww8FE3p3LHcJyHnql5F9r
         kZbVPEAm8ddYhb457v+8OBDPqwvs7O1K2fBFY=
Date: Mon, 31 Jan 2011 11:12:44 +0100
From: Tejun Heo <tj@kernel.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: axboe@kernel.dk, jeff@garzik.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kay.sievers@vrfy.org, jack@suse.cz,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH] cdrom: support devices that have check_events but not
 media_changed
Message-ID: <20110131101244.GA7459@htj.dyndns.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
 <1291838262-21274-8-git-send-email-tj@kernel.org>
 <4D44BE3E.5080107@simon.arlott.org.uk>
 <4D44BF64.4060205@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D44BF64.4060205@simon.arlott.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jan 30, 2011 at 01:31:16AM +0000, Simon Arlott wrote:
> 93aae17af1172c40c6f74b7294e93a90c3cfaa5d replaced the media_changed op
> with the check_events op in drivers/scsi/sr.c
> 
> All users that check for the CDC_MEDIA_CHANGED capability try both
> the check_events op and the media_changed op, but register_cdrom()
> was requiring media_changed.
> 
> This patch fixes the capability checking and removes a redundant
> check that media_changed != NULL.
> 
> The cdrom_select_disc ioctl is also using the two operations, so
> they should be required for CDC_SELECT_DISC too.

First of all, thanks a lot for fixing this.  Just minor nits below.

> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 14033a3..4716d76 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -409,7 +409,9 @@ int register_cdrom(struct cdrom_device_info *cdi)
>  	}
>  
>  	ENSURE(drive_status, CDC_DRIVE_STATUS );
> -	ENSURE(media_changed, CDC_MEDIA_CHANGED);
> +	if (cdo->check_events == NULL && cdo->media_changed == NULL) {
> +		*change_capability = ~(CDC_MEDIA_CHANGED | CDC_SELECT_DISC);
> +	}

Can we lose the unnecessary {}?

>  	ENSURE(tray_move, CDC_CLOSE_TRAY | CDC_OPEN_TRAY);
>  	ENSURE(lock_door, CDC_LOCK);
>  	ENSURE(select_speed, CDC_SELECT_SPEED);
> @@ -1471,7 +1473,7 @@ int cdrom_media_changed(struct cdrom_device_info *cdi)
>  	/* This talks to the VFS, which doesn't like errors - just 1 or 0.  
>  	 * Returning "0" is always safe (media hasn't been changed). Do that 
>  	 * if the low-level cdrom driver dosn't support media changed. */ 
> -	if (cdi == NULL || cdi->ops->media_changed == NULL)
> +	if (cdi == NULL)

This change is probably not necessary as cdrom_media_changed() is only
called from drivers which implement media_changed.  I don't think it's
gonna break anything but the whole media_changed stuff is scheduled
for removal anyway, so I think it would be better to keep the changes
minimal.

Thank you.

-- 
tejun
