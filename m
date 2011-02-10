Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab1BJW3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:29:04 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29029 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab1BJW3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:29:01 -0500
Date: Thu, 10 Feb 2011 23:27:51 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Charles Manning <cdhmanning@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ryan@bluewatersys.com, akpm@linux-foundation.org
Subject: Re: [PATCH 03/10] Add yaffs2 file system: checkpoint streaming
In-Reply-To: <1297221968-6747-4-git-send-email-cdhmanning@gmail.com>
Message-ID: <alpine.LNX.2.00.1102102324530.8012@swampdragon.chaosbits.net>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <1297221968-6747-4-git-send-email-cdhmanning@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, Charles Manning wrote:

> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> ---
>  fs/yaffs2/yaffs_checkptrw.c |  408 +++++++++++++++++++++++++++++++++++++++++++
>  fs/yaffs2/yaffs_checkptrw.h |   33 ++++
>  2 files changed, 441 insertions(+), 0 deletions(-)
>  create mode 100644 fs/yaffs2/yaffs_checkptrw.c
>  create mode 100644 fs/yaffs2/yaffs_checkptrw.h
> 
> diff --git a/fs/yaffs2/yaffs_checkptrw.c b/fs/yaffs2/yaffs_checkptrw.c
> new file mode 100644
> index 0000000..997a618
> --- /dev/null
> +++ b/fs/yaffs2/yaffs_checkptrw.c
> @@ -0,0 +1,408 @@
> +/*
> + * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
> + *
> + * Copyright (C) 2002-2011 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Charles Manning <charles@aleph1.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "yaffs_checkptrw.h"
> +#include "yaffs_getblockinfo.h"
> +
> +static int yaffs2_checkpt_space_ok(struct yaffs_dev *dev)
> +{
> +	int blocks_avail = dev->n_erased_blocks - dev->param.n_reserved_blocks;
> +
> +	yaffs_trace(YAFFS_TRACE_CHECKPOINT,
> +		"checkpt blocks_avail = %d", blocks_avail);
> +
> +	return (blocks_avail <= 0) ? 0 : 1;
> +}
> +
> +static int yaffs_checkpt_erase(struct yaffs_dev *dev)
> +{
> +	int i;
> +
> +	if (!dev->param.erase_fn)
> +		return 0;
> +	yaffs_trace(YAFFS_TRACE_CHECKPOINT,
> +		"checking blocks %d to %d",
> +		dev->internal_start_block, dev->internal_end_block);
> +
> +	for (i = dev->internal_start_block; i <= dev->internal_end_block; i++) {

Why does 'i' need 'function scope'? can't it just have 'for scope'?

     for (int i = dev->internal_start_block; i <= dev->internal_end_block; i++) {


> +static void yaffs2_checkpt_find_erased_block(struct yaffs_dev *dev)
> +{
> +	int i;
> +	int blocks_avail = dev->n_erased_blocks - dev->param.n_reserved_blocks;
> +
> +	yaffs_trace(YAFFS_TRACE_CHECKPOINT,
> +		"allocating checkpt block: erased %d reserved %d avail %d next %d ",
> +		dev->n_erased_blocks, dev->param.n_reserved_blocks,
> +		blocks_avail, dev->checkpt_next_block);
> +
> +	if (dev->checkpt_next_block >= 0 &&
> +	    dev->checkpt_next_block <= dev->internal_end_block &&
> +	    blocks_avail > 0) {
> +
> +		for (i = dev->checkpt_next_block; i <= dev->internal_end_block;

'for scope' ?

> +static void yaffs2_checkpt_find_block(struct yaffs_dev *dev)
> +{
> +	int i;
> +	struct yaffs_ext_tags tags;
> +
> +	yaffs_trace(YAFFS_TRACE_CHECKPOINT,
> +		"find next checkpt block: start:  blocks %d next %d",
> +		dev->blocks_in_checkpt, dev->checkpt_next_block);
> +
> +	if (dev->blocks_in_checkpt < dev->checkpt_max_blocks)
> +		for (i = dev->checkpt_next_block; i <= dev->internal_end_block;

and here and elsewhere (can't be bothered to point out every one)...

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

