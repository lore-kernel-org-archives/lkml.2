Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1KUWwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:52:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab1KUWwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:52:49 -0500
Date: Mon, 21 Nov 2011 14:52:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, Li Shaohua <shaohua.li@intel.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jens Axboe <jens.axboe@oracle.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/8] block: limit default readahead size for small
 devices
Message-Id: <20111121145247.0e37dc36.akpm@linux-foundation.org>
In-Reply-To: <20111121093846.121502745@intel.com>
References: <20111121091819.394895091@intel.com>
	<20111121093846.121502745@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 17:18:20 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Linus reports a _really_ small & slow (505kB, 15kB/s) USB device,
> on which blkid runs unpleasantly slow. He manages to optimize the blkid
> reads down to 1kB+16kB, but still kernel read-ahead turns it into 48kB.
> 
>      lseek 0,    read 1024   => readahead 4 pages (start of file)

I'm disturbed that the code did a 4 page (16kbyte?) readahead after an
lseek.  Given the high probability that the next read will occur after
a second lseek, that's a mistake.

Was an lseek to offset 0 special-cased?

>      lseek 1536, read 16384  => readahead 8 pages (page contiguous)
> 
> The readahead heuristics involved here are reasonable ones in general.
> So it's good to fix blkid with fadvise(RANDOM), as Linus already did.
> 
> For the kernel part, Linus suggests:
>   So maybe we could be less aggressive about read-ahead when the size of
>   the device is small? Turning a 16kB read into a 64kB one is a big deal,
>   when it's about 15% of the whole device!
> 
> This looks reasonable: smaller device tend to be slower (USB sticks as
> well as micro/mobile/old hard disks).

Spose so.  Obviously there are other characteristics which should be
considered when choosing a readaahead size, but one of them can be disk
size and that's what this change does.

In a better world, userspace would run a
work-out-what-readahead-size-to-use script each time a distro is
installed and when new storage devices are added/detected.  Userspace
would then remember that readahead size for subsequent bootups.

In the real world, we shovel guaranteed-to-be-wrong guesswork into the
kernel and everyone just uses the results.  Sigh.

> --- linux-next.orig/block/genhd.c	2011-10-31 00:13:51.000000000 +0800
> +++ linux-next/block/genhd.c	2011-11-18 11:27:08.000000000 +0800
> @@ -623,6 +623,26 @@ void add_disk(struct gendisk *disk)
>  	WARN_ON(retval);
>  
>  	disk_add_events(disk);
> +
> +	/*
> +	 * Limit default readahead size for small devices.
> +	 *        disk size    readahead size
> +	 *               1M                8k
> +	 *               4M               16k
> +	 *              16M               32k
> +	 *              64M               64k
> +	 *             256M              128k
> +	 *               1G              256k
> +	 *               4G              512k
> +	 *              16G             1024k
> +	 *              64G             2048k
> +	 *             256G             4096k
> +	 */
> +	if (get_capacity(disk)) {
> +		unsigned long size = get_capacity(disk) >> 9;

get_capacity() returns sector_t.  This expression will overflow with a
2T disk.  I'm not sure if we successfully support 2T disks on 32-bit
machines, but changes like this will guarantee that we don't :)

> +		size = 1UL << (ilog2(size) / 2);

I think there's a rounddown_pow_of_two() hiding in that expression?

> +		bdi->ra_pages = min(bdi->ra_pages, size);

I don't have a clue why that min() is in there.  It needs a comment,
please.

> +	}


