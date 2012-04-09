Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2DIQun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:50:43 -0400
Received: from relay.parallels.com ([195.214.232.42]:40004 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DIQum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 12:50:42 -0400
X-Greylist: delayed 752 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Apr 2012 12:50:42 EDT
Message-ID: <4F831103.3050704@parallels.com>
Date: Mon, 9 Apr 2012 20:40:35 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "kzak@redhat.com" <kzak@redhat.com>,
        "psusi@ubuntu.com" <psusi@ubuntu.com>,
        "psusi@cfl.rr.com" <psusi@cfl.rr.com>,
        "maxim.patlasov@gmail.com" <maxim.patlasov@gmail.com>
Subject: Re: [PATCH 1/2] block: add partition resize function to blkpg ioctl
References: <1329251991-22468-1-git-send-email-vgoyal@redhat.com> <1329251991-22468-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1329251991-22468-2-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

See please inline comments below...

On 02/15/2012 12:39 AM, Vivek Goyal wrote:
> ...
> @@ -765,8 +765,8 @@ void __init printk_all_partitions(void)
>
>   			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
>   			       bdevt_str(part_devt(part), devt_buf),
> -			       (unsigned long long)part->nr_sects>>  1,
> -			       disk_name(disk, part->partno, name_buf), uuid);
> +			       (unsigned long long)part_nr_sects_read(part)>>  1
> +			       , disk_name(disk, part->partno, name_buf), uuid);

A line starting from comma looks unusual. Is it what you intended?

> diff --git a/block/ioctl.c b/block/ioctl.c
> index ba15b2d..ddbc649 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> ...
> @@ -92,6 +92,57 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
>   			bdput(bdevp);
>
>   			return 0;
> +		case BLKPG_RESIZE_PARTITION:
> +			start = p.start>>  9;
> +			/* new length of partition in bytes */
> +			length = p.length>>  9;
> +			/* check for fit in a hd_struct */
> +			if (sizeof(sector_t) == sizeof(long)&&
> +			    sizeof(long long)>  sizeof(long)) {
> +				long pstart = start, plength = length;
> +				if (pstart != start || plength != length
> +				    || pstart<  0 || plength<  0)
> +					return -EINVAL;
> +			}
> +			part = disk_get_part(disk, partno);
> +			if (!part)
> +				return -ENXIO;
> +			bdevp = bdget(part_devt(part));
> +			if (!bdevp) {
> +				disk_put_part(part);
> +				return -ENOMEM;
> +			}
> +			mutex_lock(&bdevp->bd_mutex);
> +			mutex_lock_nested(&bdev->bd_mutex, 1);
> +			if (start != part->start_sect) {
> +				mutex_unlock(&bdevp->bd_mutex);
> +				mutex_unlock(&bdev->bd_mutex);
> +				disk_put_part(part);
> +				return -EINVAL;

bdput(bdevp) missed?


> +			}
> +			/* overlap? */
> +			disk_part_iter_init(&piter, disk,
> +					    DISK_PITER_INCL_EMPTY);
> +			while ((lpart = disk_part_iter_next(&piter))) {
> +				if (lpart->partno != partno&&
> +				   !(start + length<= lpart->start_sect ||
> +				   start>= lpart->start_sect + lpart->nr_sects)
> +				   ) {
> +					disk_part_iter_exit(&piter);
> +					mutex_unlock(&bdevp->bd_mutex);
> +					mutex_unlock(&bdev->bd_mutex);
> +					disk_put_part(part);
> +					return -EBUSY;

bdput(bdevp) missed?

> +				}
> +			}
> +			disk_part_iter_exit(&piter);
> +			part_nr_sects_write(part, (sector_t)length);
> +			i_size_write(bdevp->bd_inode, p.length);
> +			mutex_unlock(&bdevp->bd_mutex);
> +			mutex_unlock(&bdev->bd_mutex);
> +			bdput(bdevp);
> +			disk_put_part(part);
> +			return 0;
>   		default:
>   			return -EINVAL;
>   	}

Thanks,
Maxim
