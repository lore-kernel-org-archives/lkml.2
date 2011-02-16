Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1BPX20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:28:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34200 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab1BPX2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:28:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q1LUhIBBcnAFWe+LAD1cTpZidUKUYQcgwbdpEW4zktBvHRSg+fckF6eeyHG+XJup7h
         wYTNj8BeiSi8iGgzTPN35Zk8PSpEzlvHNWhYUqnwqi+z69OgEOGfZhH1bFe9kEV0FgID
         +1rnIMMtBGth85kWAKdmNo8EQWYy0WHPLLnHM=
Date: Thu, 17 Feb 2011 00:28:16 +0100
From: Tejun Heo <tj@kernel.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>
Subject: Re: [Patch v2] block: revert block_dev read-only check
Message-ID: <20110216232816.GH29600@atj.dyndns.org>
References: <20110216181153.5b8f81d5@katamari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216181153.5b8f81d5@katamari>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 06:11:53PM -0500, Chuck Ebbert wrote:
> This reverts commit 75f1dc0d076d1c1168f2115f1941ea627d38bd5a
> ("block: check bdev_read_only() from blkdev_get()"). That commit added
> stricter checking to make sure devices that were being used read-only
> were actually opened in that mode.
> 
> It turns out that the change breaks a bunch of kernel code that opens
> block devices. Affected systems include dm, md, and the loop device.
> Because strict checking for read-only opens of block devices was not
> done before this, the code that opens the devices was opening them
> read-write even if they were being used read-only. Auditing all that
> code will take time, and new userspace packages for dm, mdadm, etc.
> will also be required.

The problem is slightly more complex than that.  Block layer has never
enforced the read only flag during open or actual IOs and those
stacking block drivers and filesystems can open a device marked RO and
then write to it, which is a pretty bad idea (especially in data
rescue/forensic scenarios).

The commit was part of effort to enforce the ro flag.  It at least
makes sure that a device can't be opened RW if marked RO.  loop and dm
showed some problems but fixing the in-kernel part isn't difficult
(fixes pending).

IIUC, the problematic part is dm userland, which reportedly opens
member devices RW even when building a RO device.  The problem is when
a user is trying to build RO dm device from RO member devices.  dm
userland tries to open the member devices RW, which block layer
rejects now thus failing dm assembly.

> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1215,12 +1215,6 @@ int blkdev_get(struct block_device *bdev
>  
>  	res = __blkdev_get(bdev, mode, 0);
>  
> -	/* __blkdev_get() may alter read only status, check it afterwards */
> -	if (!res && (mode & FMODE_WRITE) && bdev_read_only(bdev)) {
> -		__blkdev_put(bdev, mode, 0);
> -		res = -EACCES;
> -	}
> -
>  	if (whole) {
>  		/* finish claiming */
>  		mutex_lock(&bdev->bd_mutex);
> @@ -1298,6 +1292,11 @@ struct block_device *blkdev_get_by_path(
>  	if (err)
>  		return ERR_PTR(err);
>  
> +	if ((mode & FMODE_WRITE) && bdev_read_only(bdev)) {
> +		blkdev_put(bdev, mode);
> +		return ERR_PTR(-EACCES);
> +	}
> +
>  	return bdev;
>  }
>  EXPORT_SYMBOL(blkdev_get_by_path);

Shouldn't the changes to drivers/usb/gadget/storage_common.c reverted
too?

Thanks.

--
tejun
