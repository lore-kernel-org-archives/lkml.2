Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1LSUZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:25:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1LSUZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:25:34 -0500
Date: Mon, 19 Dec 2011 15:25:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: joe@perches.com, kzak@redhat.com, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Message-ID: <20111219202527.GF7175@redhat.com>
References: <4EE6990A.9010202@cfl.rr.com>
 <1323735382-5972-1-git-send-email-psusi@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323735382-5972-1-git-send-email-psusi@cfl.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 07:16:21PM -0500, Phillip Susi wrote:

[..]
> +		case BLKPG_RESIZE_PARTITION:
> +			start = p.start >> 9;
> +			length = p.length >> 9;
> +			/* check for fit in a hd_struct */
> +			if (sizeof(sector_t) == sizeof(long) &&
> +			    sizeof(long long) > sizeof(long)) {
> +				long pstart = start, plength = length;
> +				if (pstart != start || plength != length
> +				    || pstart < 0 || plength < 0)
> +					return -EINVAL;
> +			}
> +
> +			mutex_lock(&bdev->bd_mutex);
> +
> +			/* overlap? */
> +			disk_part_iter_init(&piter, disk,
> +					    DISK_PITER_INCL_EMPTY);
> +			while ((part = disk_part_iter_next(&piter))) {
> +				if (part->partno != partno && !(start + length <= part->start_sect ||
> +				      start >= part->start_sect + part->nr_sects)) {
> +					disk_part_iter_exit(&piter);
> +					mutex_unlock(&bdev->bd_mutex);
> +					return -EBUSY;
> +				}
> +			}
> +			disk_part_iter_exit(&piter);
> +			part = disk_get_part(disk, partno);
> +			if (!part)
> +			{
> +				mutex_unlock(&bdev->bd_mutex);
> +				return -ENXIO;
> +			}
> +			if (start != part->start_sect)
> +			{
> +				mutex_unlock(&bdev->bd_mutex);
> +				disk_put_part(part);
> +				return -EINVAL;
> +			}
> +			part->nr_sects = length;
> +			bdevp = bdget(part_devt(part));
> +			mutex_lock(&bdevp->bd_mutex);

Are there any restrictions on order of partition bdev and disk bdev
locking.

I see that DEL_PARTITION ioctl first takes partition mutex and then 
disk mutex using mutex_lock_nested().

In your implementation you take disk mutex first and the partition 
bdev mutex. 

- Is that a problem from deadlock point of view? Two threads calling
  ioctl on same fd.

- Is it an issue from lock validator point of view. I am not familiar
  with mutex_lock_nested(). So thought of asking.

Thanks
Vivek
