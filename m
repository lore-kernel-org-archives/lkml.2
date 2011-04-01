Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab1DAPnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:43:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64948 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1DAPnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wYxKtc+fF/gSNcdRVxIYywuHNsF0Y1Ij5dVUTk85hCf2U8R2iyCtsMiVMDNdmeTagR
         rvnJzJM3DWAXztXicPuSmpObv7hoTXZ+fk9eH3Aj8efODN2GUI1jren4vF2Ecn1f/a8M
         LszLNXRXbJCuVsORrdD1ji48IUOcOymziA3xY=
Date: Fri, 1 Apr 2011 17:43:27 +0200
From: Tejun Heo <tj@kernel.org>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
Message-ID: <20110401154327.GA6593@mtj.dyndns.org>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 31, 2011 at 11:50:04PM +0530, Amit Shah wrote:
> After the first GET_EVENT_STATUS_NOTIFICATION command, any new media
> notification is reset by the device.  The following is then noticed:
> 
> 1. insert a CD of a particular size
> 2. mount it
> 3. note /sys/block/sr0/size
> 4. unmount cd
> 5. replace cd with a size greater than previous one
> 6. mount it
> 7. /sys/block/sr0/size isn't updated
> 8. copy all files from cd to somewhere; IO errors will pop up where the
>    files lie beyond previous CD's geometry
> 
> The cause is:
> 
>  cdrom_open()
>      open_for_data()
>          cdo->drive_status() = sr_drive_status()
>              cdrom_get_media_event()
>              --> GPCMD_GET_EVENT_STATUS_NOTIFICATION
>          --> med.media_present is true, return CDS_DISK_OK
>      (success)
>  check_disk_change()
>     ... -> 2nd call to GPCMD_GET_EVENT_STATUS_NOTIFICATION
> 
> at this point the device has already reset the new media event and the
> call to revalidate_disk() in check_disk_change() is never made.

Hmm... I see.  That's something I didn't expect.

> All of this is noticed in a qemu-kvm virtual machine where two CD images
> are created from two files different in size.
...
> diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
> index 8be3055..0651448 100644
> --- a/drivers/scsi/sr_ioctl.c
> +++ b/drivers/scsi/sr_ioctl.c
> @@ -316,12 +316,19 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
>  		return CDS_DRIVE_NOT_READY;
>  
>  	if (!cdrom_get_media_event(cdi, &med)) {
> -		if (med.media_present)
> +		if (med.media_present) {
> +			/*
> +			 * New media was inserted; ensure disk data is
> +			 * revalidated.
> +			 */
> +			if (cdi->disk->fops->revalidate_disk)
> +				cdi->disk->fops->revalidate_disk(cdi->disk);
>  			return CDS_DISC_OK;
> -		else if (med.door_open)
> +		} else if (med.door_open) {
>  			return CDS_TRAY_OPEN;
> -		else
> +		} else {
>  			return CDS_NO_DISC;
> +		}
>  	}

But I don't think this is the correct place to do it.  The problem
happens because block layer consumes the event but doesn't remember it
when the time for revalidation comes.  It should be done by block
layer, not sr.  Hmmm... looking at the code, the new disk event code
should handle this correctly.  Was 2.6.38 showing the problem too?

Thanks.

-- 
tejun
