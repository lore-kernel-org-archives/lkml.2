Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab0LBTr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:47:58 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:36794 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757253Ab0LBTr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:47:57 -0500
Message-ID: <4CF7F83E.9080306@bluewatersys.com>
Date: Fri, 03 Dec 2010 08:49:18 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Charles Manning <cdhmanning@gmail.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] Add yaffs2 file system: allocator, attribs, bitmap
 code
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <1291154254-22533-2-git-send-email-cdhmanning@gmail.com>
In-Reply-To: <1291154254-22533-2-git-send-email-cdhmanning@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2010 10:57 AM, Charles Manning wrote:
> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> ---
>  fs/yaffs2/yaffs_allocator.c |  397 +++++++++++++++++++++++++++++++++++++++++++
>  fs/yaffs2/yaffs_allocator.h |   30 ++++
>  fs/yaffs2/yaffs_attribs.c   |  124 ++++++++++++++
>  fs/yaffs2/yaffs_attribs.h   |   28 +++
>  fs/yaffs2/yaffs_bitmap.c    |  104 +++++++++++
>  fs/yaffs2/yaffs_bitmap.h    |   33 ++++
>  6 files changed, 716 insertions(+), 0 deletions(-)
>  create mode 100644 fs/yaffs2/yaffs_allocator.c
>  create mode 100644 fs/yaffs2/yaffs_allocator.h
>  create mode 100644 fs/yaffs2/yaffs_attribs.c
>  create mode 100644 fs/yaffs2/yaffs_attribs.h
>  create mode 100644 fs/yaffs2/yaffs_bitmap.c
>  create mode 100644 fs/yaffs2/yaffs_bitmap.h
> 
> diff --git a/fs/yaffs2/yaffs_allocator.c b/fs/yaffs2/yaffs_allocator.c
> new file mode 100644
> index 0000000..b9fe31e
> --- /dev/null
> +++ b/fs/yaffs2/yaffs_allocator.c
> @@ -0,0 +1,397 @@
> +/*
> + * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
> + *
> + * Copyright (C) 2002-2010 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Charles Manning <charles@aleph1.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "yaffs_allocator.h"
> +#include "yaffs_guts.h"
> +#include "yaffs_trace.h"
> +#include "yportenv.h"
> +
> +#ifdef CONFIG_YAFFS_YMALLOC_ALLOCATOR

This doesn't appear to be defined anywhere and is not in Kconfig. Is
this just a wrapper for support on other operating systems or does it
can it be used on Linux for debugging? In the former case it should
probably removed and in the latter it should probably have a comment
explaining why you would want to define it.

<snip>

> +
> +#include "yaffs_bitmap.h"
> +#include "yaffs_trace.h"
> +/*
> + * Chunk bitmap manipulations
> + */
> +
> +static Y_INLINE u8 *yaffs_block_bits(struct yaffs_dev *dev, int blk)

Should just use inline.

<snip>

> +
> +int yaffs_still_some_chunks(struct yaffs_dev *dev, int blk)
> +{
> +	u8 *blk_bits = yaffs_block_bits(dev, blk);
> +	int i;
> +	for (i = 0; i < dev->chunk_bit_stride; i++) {

Nitpick: You should have a blank line between variable declarations and
start of code.

<snip>

> +int yaffs_count_chunk_bits(struct yaffs_dev *dev, int blk)
> +{
> +	u8 *blk_bits = yaffs_block_bits(dev, blk);
> +	int i;
> +	int n = 0;
> +	for (i = 0; i < dev->chunk_bit_stride; i++) {
> +		u8 x = *blk_bits;
> +		while (x) {
> +			if (x & 1)
> +				n++;
> +			x >>= 1;
> +		}
> +
> +		blk_bits++;
> +	}
> +	return n;
> +}


This is possibly more concise as a for loop. Also moving the definitions
all to the top of the file and combining same types definitions on one
line reduces this function to:

int yaffs_count_chunk_bits(struct yaffs_dev *dev, int blk)
{
	u8 x, *blk_bits = yaffs_block_bits(dev, blk);
	int i, n = 0;

	for (i = 0; i < dev->chunk_bit_stride; i++, blk_bits++)
		for (x = *blk_bits; x; x >>= 1)
			if (x & 1)
				n++;
	
	return n;
}

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
