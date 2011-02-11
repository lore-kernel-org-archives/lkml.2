Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab1BKXCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 18:02:08 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:18505 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758412Ab1BKXCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 18:02:06 -0500
Message-ID: <4D55BFCC.3080609@bluewatersys.com>
Date: Sat, 12 Feb 2011 12:01:32 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Charles Manning <cdhmanning@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 06/10] Add yaffs2 file system: tracing and verification
 handling
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <1297221968-6747-7-git-send-email-cdhmanning@gmail.com>
In-Reply-To: <1297221968-6747-7-git-send-email-cdhmanning@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/11 16:26, Charles Manning wrote:
> Signed-off-by: Charles Manning <cdhmanning@gmail.com>

Hi Charles,

A few comments below.

~Ryan

> ---
>  fs/yaffs2/yaffs_trace.h  |   57 +++++
>  fs/yaffs2/yaffs_verify.c |  525 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/yaffs2/yaffs_verify.h |   43 ++++
>  3 files changed, 625 insertions(+), 0 deletions(-)
>  create mode 100644 fs/yaffs2/yaffs_trace.h
>  create mode 100644 fs/yaffs2/yaffs_verify.c
>  create mode 100644 fs/yaffs2/yaffs_verify.h
> 
> diff --git a/fs/yaffs2/yaffs_trace.h b/fs/yaffs2/yaffs_trace.h
> new file mode 100644
> index 0000000..fd26054
> --- /dev/null
> +++ b/fs/yaffs2/yaffs_trace.h
> @@ -0,0 +1,57 @@
> +/*
> + * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
> + *
> + * Copyright (C) 2002-2011 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Charles Manning <charles@aleph1.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU Lesser General Public License version 2.1 as
> + * published by the Free Software Foundation.
> + *
> + * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
> + */
> +
> +#ifndef __YTRACE_H__
> +#define __YTRACE_H__
> +
> +extern unsigned int yaffs_trace_mask;
> +extern unsigned int yaffs_wr_attempts;
> +
> +/*
> + * Tracing flags.
> + * The flags masked in YAFFS_TRACE_ALWAYS are always traced.
> + */
> +
> +#define YAFFS_TRACE_OS			0x00000002
> +#define YAFFS_TRACE_ALLOCATE		0x00000004
> +#define YAFFS_TRACE_SCAN		0x00000008
> +#define YAFFS_TRACE_BAD_BLOCKS		0x00000010
> +#define YAFFS_TRACE_ERASE		0x00000020
> +#define YAFFS_TRACE_GC			0x00000040
> +#define YAFFS_TRACE_WRITE		0x00000080
> +#define YAFFS_TRACE_TRACING		0x00000100
> +#define YAFFS_TRACE_DELETION		0x00000200
> +#define YAFFS_TRACE_BUFFERS		0x00000400
> +#define YAFFS_TRACE_NANDACCESS		0x00000800
> +#define YAFFS_TRACE_GC_DETAIL		0x00001000
> +#define YAFFS_TRACE_SCAN_DEBUG		0x00002000
> +#define YAFFS_TRACE_MTD			0x00004000
> +#define YAFFS_TRACE_CHECKPOINT		0x00008000
> +
> +#define YAFFS_TRACE_VERIFY		0x00010000
> +#define YAFFS_TRACE_VERIFY_NAND		0x00020000
> +#define YAFFS_TRACE_VERIFY_FULL		0x00040000
> +#define YAFFS_TRACE_VERIFY_ALL		0x000f0000
> +
> +#define YAFFS_TRACE_SYNC		0x00100000
> +#define YAFFS_TRACE_BACKGROUND		0x00200000
> +#define YAFFS_TRACE_LOCK		0x00400000
> +#define YAFFS_TRACE_MOUNT		0x00800000
> +
> +#define YAFFS_TRACE_ERROR		0x40000000
> +#define YAFFS_TRACE_BUG			0x80000000
> +#define YAFFS_TRACE_ALWAYS		0xf0000000
> +
> +#endif
> diff --git a/fs/yaffs2/yaffs_verify.c b/fs/yaffs2/yaffs_verify.c
> new file mode 100644
> index 0000000..27d3695
> --- /dev/null
> +++ b/fs/yaffs2/yaffs_verify.c
> @@ -0,0 +1,525 @@
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

I think it would be useful to have a Kconfig option called YAFFS_DEBUG
which enables debugging (use pr_debug) and verification code (i.e.
includes this file). This would allow smaller kernel builds for people
who do not need the trace/verification functionality.

> +#include "yaffs_verify.h"
> +#include "yaffs_trace.h"
> +#include "yaffs_bitmap.h"
> +#include "yaffs_getblockinfo.h"
> +#include "yaffs_nand.h"
> +
> +int yaffs_skip_verification(struct yaffs_dev *dev)
> +{
> +	dev = dev;

Delete this line, or even better, remove the unused function argument
completely. Same goes for other functions.

> +	return !(yaffs_trace_mask &
> +		 (YAFFS_TRACE_VERIFY | YAFFS_TRACE_VERIFY_FULL));
> +}
> +
> +static int yaffs_skip_full_verification(struct yaffs_dev *dev)
> +{
> +	dev = dev;
> +	return !(yaffs_trace_mask & (YAFFS_TRACE_VERIFY_FULL));
> +}
> +
> +static int yaffs_skip_nand_verification(struct yaffs_dev *dev)
> +{
> +	dev = dev;
> +	return !(yaffs_trace_mask & (YAFFS_TRACE_VERIFY_NAND));
> +}
> +
> +static const char * const block_state_name[] = {
> +	"Unknown",
> +	"Needs scan",
> +	"Scanning",
> +	"Empty",
> +	"Allocating",
> +	"Full",
> +	"Dirty",
> +	"Checkpoint",
> +	"Collecting",
> +	"Dead"
> +};
> +
> +void yaffs_verify_blk(struct yaffs_dev *dev, struct yaffs_block_info *bi, int n)
> +{
> +	int actually_used;
> +	int in_use;
> +
> +	if (yaffs_skip_verification(dev))
> +		return;
> +
> +	/* Report illegal runtime states */
> +	if (bi->block_state >= YAFFS_NUMBER_OF_BLOCK_STATES)
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Block %d has undefined state %d",
> +			n, bi->block_state);
> +
> +	switch (bi->block_state) {
> +	case YAFFS_BLOCK_STATE_UNKNOWN:
> +	case YAFFS_BLOCK_STATE_SCANNING:
> +	case YAFFS_BLOCK_STATE_NEEDS_SCAN:
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Block %d has bad run-state %s",
> +			n, block_state_name[bi->block_state]);
> +	}
> +
> +	/* Check pages in use and soft deletions are legal */
> +
> +	actually_used = bi->pages_in_use - bi->soft_del_pages;
> +
> +	if (bi->pages_in_use < 0 ||
> +	    bi->pages_in_use > dev->param.chunks_per_block ||
> +	    bi->soft_del_pages < 0 ||
> +	    bi->soft_del_pages > dev->param.chunks_per_block ||
> +	    actually_used < 0 || actually_used > dev->param.chunks_per_block)
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Block %d has illegal values pages_in_used %d soft_del_pages %d",
> +			n, bi->pages_in_use, bi->soft_del_pages);
> +
> +	/* Check chunk bitmap legal */
> +	in_use = yaffs_count_chunk_bits(dev, n);
> +	if (in_use != bi->pages_in_use)
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Block %d has inconsistent values pages_in_use %d counted chunk bits %d",
> +			n, bi->pages_in_use, in_use);
> +}
> +
> +void yaffs_verify_collected_blk(struct yaffs_dev *dev,
> +				struct yaffs_block_info *bi, int n)
> +{
> +	yaffs_verify_blk(dev, bi, n);
> +
> +	/* After collection the block should be in the erased state */
> +
> +	if (bi->block_state != YAFFS_BLOCK_STATE_COLLECTING &&
> +	    bi->block_state != YAFFS_BLOCK_STATE_EMPTY) {
> +		yaffs_trace(YAFFS_TRACE_ERROR,
> +			"Block %d is in state %d after gc, should be erased",
> +			n, bi->block_state);
> +	}
> +}
> +
> +void yaffs_verify_blocks(struct yaffs_dev *dev)
> +{
> +	int i;
> +	int state_count[YAFFS_NUMBER_OF_BLOCK_STATES];
> +	int illegal_states = 0;
> +
> +	if (yaffs_skip_verification(dev))
> +		return;
> +
> +	memset(state_count, 0, sizeof(state_count));

You could just assign it to {0} above and drop this memset.

> +
> +	for (i = dev->internal_start_block; i <= dev->internal_end_block; i++) {
> +		struct yaffs_block_info *bi = yaffs_get_block_info(dev, i);
> +		yaffs_verify_blk(dev, bi, i);
> +
> +		if (bi->block_state < YAFFS_NUMBER_OF_BLOCK_STATES)
> +			state_count[bi->block_state]++;
> +		else
> +			illegal_states++;
> +	}
> +
> +	yaffs_trace(YAFFS_TRACE_VERIFY,	"Block summary");
> +
> +	yaffs_trace(YAFFS_TRACE_VERIFY,
> +		"%d blocks have illegal states",
> +		illegal_states);
> +	if (state_count[YAFFS_BLOCK_STATE_ALLOCATING] > 1)
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Too many allocating blocks");
> +
> +	for (i = 0; i < YAFFS_NUMBER_OF_BLOCK_STATES; i++)
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"%s %d blocks",
> +			block_state_name[i], state_count[i]);
> +
> +	if (dev->blocks_in_checkpt != state_count[YAFFS_BLOCK_STATE_CHECKPOINT])
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Checkpoint block count wrong dev %d count %d",
> +			dev->blocks_in_checkpt,
> +			state_count[YAFFS_BLOCK_STATE_CHECKPOINT]);
> +
> +	if (dev->n_erased_blocks != state_count[YAFFS_BLOCK_STATE_EMPTY])
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Erased block count wrong dev %d count %d",
> +			dev->n_erased_blocks,
> +			state_count[YAFFS_BLOCK_STATE_EMPTY]);
> +
> +	if (state_count[YAFFS_BLOCK_STATE_COLLECTING] > 1)
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Too many collecting blocks %d (max is 1)",
> +			state_count[YAFFS_BLOCK_STATE_COLLECTING]);
> +}
> +
> +/*
> + * Verify the object header. oh must be valid, but obj and tags may be NULL in
> + * which case those tests will not be performed.
> + */
> +void yaffs_verify_oh(struct yaffs_obj *obj, struct yaffs_obj_hdr *oh,
> +		     struct yaffs_ext_tags *tags, int parent_check)
> +{
> +	if (obj && yaffs_skip_verification(obj->my_dev))
> +		return;
> +
> +	if (!(tags && obj && oh)) {
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Verifying object header tags %p obj %p oh %p",
> +			tags, obj, oh);
> +		return;
> +	}
> +
> +	if (oh->type <= YAFFS_OBJECT_TYPE_UNKNOWN ||
> +	    oh->type > YAFFS_OBJECT_TYPE_MAX)
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Obj %d header type is illegal value 0x%x",
> +			tags->obj_id, oh->type);
> +
> +	if (tags->obj_id != obj->obj_id)
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Obj %d header mismatch obj_id %d",
> +			tags->obj_id, obj->obj_id);
> +
> +	/*
> +	 * Check that the object's parent ids match if parent_check requested.
> +	 *
> +	 * Tests do not apply to the root object.
> +	 */
> +
> +	if (parent_check && tags->obj_id > 1 && !obj->parent)
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Obj %d header mismatch parent_id %d obj->parent is NULL",
> +			tags->obj_id, oh->parent_obj_id);
> +
> +	if (parent_check && obj->parent &&
> +	    oh->parent_obj_id != obj->parent->obj_id &&
> +	    (oh->parent_obj_id != YAFFS_OBJECTID_UNLINKED ||
> +	     obj->parent->obj_id != YAFFS_OBJECTID_DELETED))
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Obj %d header mismatch parent_id %d parent_obj_id %d",
> +			tags->obj_id, oh->parent_obj_id,
> +			obj->parent->obj_id);
> +
> +	if (tags->obj_id > 1 && oh->name[0] == 0)	/* Null name */
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Obj %d header name is NULL",
> +			obj->obj_id);
> +
> +	if (tags->obj_id > 1 && ((u8) (oh->name[0])) == 0xff)	/* Junk name */
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Obj %d header name is 0xff",
> +			obj->obj_id);
> +}
> +
> +void yaffs_verify_file(struct yaffs_obj *obj)

Should be static, since it is only called from this file. Same probably
applies to some other functions.

> +{
> +	int required_depth;
> +	int actual_depth;
> +	u32 last_chunk;
> +	u32 the_chunk;
> +	u32 x;
> +	u32 i;

Put commonly typed variable declarations on one line.

> +	struct yaffs_dev *dev;
> +	struct yaffs_ext_tags tags;
> +	struct yaffs_tnode *tn;
> +	u32 obj_id;
> +
> +	if (!obj)
> +		return;
> +
> +	if (yaffs_skip_verification(obj->my_dev))
> +		return;
> +
> +	dev = obj->my_dev;
> +	obj_id = obj->obj_id;
> +
> +	/* Check file size is consistent with tnode depth */
> +	last_chunk =
> +	    obj->variant.file_variant.file_size / dev->data_bytes_per_chunk + 1;
> +	x = last_chunk >> YAFFS_TNODES_LEVEL0_BITS;
> +	required_depth = 0;
> +	while (x > 0) {
> +		x >>= YAFFS_TNODES_INTERNAL_BITS;
> +		required_depth++;
> +	}
> +
> +	actual_depth = obj->variant.file_variant.top_level;
> +
> +	/* Check that the chunks in the tnode tree are all correct.
> +	 * We do this by scanning through the tnode tree and
> +	 * checking the tags for every chunk match.
> +	 */
> +
> +	if (yaffs_skip_nand_verification(dev))
> +		return;
> +
> +	for (i = 1; i <= last_chunk; i++) {
> +		tn = yaffs_find_tnode_0(dev, &obj->variant.file_variant, i);
> +
> +		if (!tn)
> +			continue;
> +
> +		the_chunk = yaffs_get_group_base(dev, tn, i);
> +		if (the_chunk > 0) {
> +			yaffs_rd_chunk_tags_nand(dev, the_chunk, NULL,
> +						 &tags);
> +			if (tags.obj_id != obj_id || tags.chunk_id != i)
> +				yaffs_trace(YAFFS_TRACE_VERIFY,
> +					"Object %d chunk_id %d NAND mismatch chunk %d tags (%d:%d)",
> +					obj_id, i, the_chunk,
> +					tags.obj_id, tags.chunk_id);
> +		}
> +	}
> +}
> +
> +void yaffs_verify_link(struct yaffs_obj *obj)
> +{
> +	if (obj && yaffs_skip_verification(obj->my_dev))
> +		return;
> +
> +	/* Verify sane equivalent object */

This function does nothing. Get rid of it.

> +}
> +
> +void yaffs_verify_symlink(struct yaffs_obj *obj)
> +{
> +	if (obj && yaffs_skip_verification(obj->my_dev))
> +		return;
> +
> +	/* Verify symlink string */

Same here.

> +}
> +
> +void yaffs_verify_special(struct yaffs_obj *obj)
> +{
> +	if (obj && yaffs_skip_verification(obj->my_dev))
> +		return;

and here.

> +}
> +
> +void yaffs_verify_obj(struct yaffs_obj *obj)

Should be static.

> +{
> +	struct yaffs_dev *dev;
> +	u32 chunk_min;
> +	u32 chunk_max;
> +	u32 chunk_id_ok;
> +	u32 chunk_in_range;
> +	u32 chunk_wrongly_deleted;
> +	u32 chunk_valid;

Can all go on one line.

> +
> +	if (!obj)
> +		return;

Should this just be left to oops, or is it valid to try and verify a
NULL object?

> +	if (obj->being_created)
> +		return;
> +
> +	dev = obj->my_dev;
> +
> +	if (yaffs_skip_verification(dev))
> +		return;
> +
> +	/* Check sane object header chunk */
> +
> +	chunk_min = dev->internal_start_block * dev->param.chunks_per_block;
> +	chunk_max =
> +	    (dev->internal_end_block + 1) * dev->param.chunks_per_block - 1;
> +
> +	chunk_in_range = (((unsigned)(obj->hdr_chunk)) >= chunk_min &&
> +			  ((unsigned)(obj->hdr_chunk)) <= chunk_max);
> +	chunk_id_ok = chunk_in_range || (obj->hdr_chunk == 0);
> +	chunk_valid = chunk_in_range &&
> +	    yaffs_check_chunk_bit(dev,
> +				  obj->hdr_chunk / dev->param.chunks_per_block,
> +				  obj->hdr_chunk % dev->param.chunks_per_block);
> +	chunk_wrongly_deleted = chunk_in_range && !chunk_valid;
> +
> +	if (!obj->fake && (!chunk_id_ok || chunk_wrongly_deleted))
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Obj %d has chunk_id %d %s %s",
> +			obj->obj_id, obj->hdr_chunk,
> +			chunk_id_ok ? "" : ",out of range",
> +			chunk_wrongly_deleted ? ",marked as deleted" : "");
> +
> +	if (chunk_valid && !yaffs_skip_nand_verification(dev)) {
> +		struct yaffs_ext_tags tags;
> +		struct yaffs_obj_hdr *oh;
> +		u8 *buffer = yaffs_get_temp_buffer(dev, __LINE__);
> +
> +		oh = (struct yaffs_obj_hdr *)buffer;
> +
> +		yaffs_rd_chunk_tags_nand(dev, obj->hdr_chunk, buffer, &tags);
> +
> +		yaffs_verify_oh(obj, oh, &tags, 1);
> +
> +		yaffs_release_temp_buffer(dev, buffer, __LINE__);

The verification code shouldn't be performance critical, so there
shouldn't be any need to use the temporary buffer pool. You also have no
error management if the temporary buffer allocation fails so you will
just explode when you try and dereference buffer/oh. Why not:

	oh = kzalloc(sizeof(struct yaffs_obj_hdr), GFP_NOFS);
	if (!oh) {
		pr_err("Failed to allocate memory for object verify\n");
		return;
	}

	yaffs_rd_chunk_tags_nand(dev, obj->hdr_chunk, (u8 *)oh, &tags);
	yaffs_verify_oh(obj, oh, &tags, 1);
	kfree(oh);

Similiar applies elsewhere.

> +	}
> +
> +	/* Verify it has a parent */
> +	if (obj && !obj->fake && (!obj->parent || obj->parent->my_dev != dev)) {
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Obj %d has parent pointer %p which does not look like an object",
> +			obj->obj_id, obj->parent);
> +	}
> +
> +	/* Verify parent is a directory */
> +	if (obj->parent &&
> +	    obj->parent->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Obj %d's parent is not a directory (type %d)",
> +			obj->obj_id, obj->parent->variant_type);
> +	}
> +
> +	switch (obj->variant_type) {
> +	case YAFFS_OBJECT_TYPE_FILE:
> +		yaffs_verify_file(obj);
> +		break;
> +	case YAFFS_OBJECT_TYPE_SYMLINK:
> +		yaffs_verify_symlink(obj);
> +		break;
> +	case YAFFS_OBJECT_TYPE_DIRECTORY:
> +		yaffs_verify_dir(obj);
> +		break;
> +	case YAFFS_OBJECT_TYPE_HARDLINK:
> +		yaffs_verify_link(obj);
> +		break;
> +	case YAFFS_OBJECT_TYPE_SPECIAL:
> +		yaffs_verify_special(obj);
> +		break;
> +	case YAFFS_OBJECT_TYPE_UNKNOWN:
> +	default:
> +		yaffs_trace(YAFFS_TRACE_VERIFY,
> +			"Obj %d has illegaltype %d",
> +		   obj->obj_id, obj->variant_type);
> +		break;
> +	}
> +}
> +
> +void yaffs_verify_objects(struct yaffs_dev *dev)
> +{
> +	struct yaffs_obj *obj;
> +	int i;
> +	struct list_head *lh;
> +
> +	if (yaffs_skip_verification(dev))
> +		return;
> +
> +	/* Iterate through the objects in each hash entry */
> +
> +	for (i = 0; i < YAFFS_NOBJECT_BUCKETS; i++) {
> +		list_for_each(lh, &dev->obj_bucket[i].list) {
> +			obj = list_entry(lh, struct yaffs_obj, hash_link);

list_for_each_entry

> +			yaffs_verify_obj(obj);
> +		}
> +	}
> +}
> +
> +void yaffs_verify_obj_in_dir(struct yaffs_obj *obj)
> +{
> +	struct list_head *lh;
> +	struct yaffs_obj *list_obj;
> +	int count = 0;
> +
> +	if (!obj) {
> +		yaffs_trace(YAFFS_TRACE_ALWAYS, "No object to verify");
> +		BUG();
> +		return;
> +	}
> +
> +	if (yaffs_skip_verification(obj->my_dev))
> +		return;
> +
> +	if (!obj->parent) {
> +		yaffs_trace(YAFFS_TRACE_ALWAYS, "Object does not have parent");
> +		BUG();
> +		return;
> +	}
> +
> +	if (obj->parent->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
> +		yaffs_trace(YAFFS_TRACE_ALWAYS, "Parent is not directory");
> +		BUG();

return?

> +	}
> +
> +	/* Iterate through the objects in each hash entry */
> +
> +	list_for_each(lh, &obj->parent->variant.dir_variant.children) {
> +		list_obj = list_entry(lh, struct yaffs_obj, siblings);

list_for_each_entry

> +		yaffs_verify_obj(list_obj);
> +		if (obj == list_obj)
> +			count++;
> +	}
> +
> +	if (count != 1) {
> +		yaffs_trace(YAFFS_TRACE_ALWAYS,
> +			"Object in directory %d times",
> +			count);
> +		BUG();
> +	}
> +}
> +
> +void yaffs_verify_dir(struct yaffs_obj *directory)
> +{
> +	struct list_head *lh;
> +	struct yaffs_obj *list_obj;
> +
> +	if (!directory) {
> +		BUG();
> +		return;
> +	}
> +
> +	if (yaffs_skip_full_verification(directory->my_dev))
> +		return;
> +
> +	if (directory->variant_type != YAFFS_OBJECT_TYPE_DIRECTORY) {
> +		yaffs_trace(YAFFS_TRACE_ALWAYS,
> +			"Directory has wrong type: %d",
> +			directory->variant_type);
> +		BUG();
> +	}
> +
> +	/* Iterate through the objects in each hash entry */
> +
> +	list_for_each(lh, &directory->variant.dir_variant.children) {
> +		list_obj = list_entry(lh, struct yaffs_obj, siblings);

list_for_each_entry

> +		if (list_obj->parent != directory) {
> +			yaffs_trace(YAFFS_TRACE_ALWAYS,
> +				"Object in directory list has wrong parent %p",
> +				list_obj->parent);
> +			BUG();
> +		}
> +		yaffs_verify_obj_in_dir(list_obj);
> +	}
> +}
> +
> +static int yaffs_free_verification_failures;
> +
> +void yaffs_verify_free_chunks(struct yaffs_dev *dev)
> +{
> +	int counted;
> +	int difference;
> +
> +	if (yaffs_skip_verification(dev))
> +		return;
> +
> +	counted = yaffs_count_free_chunks(dev);
> +
> +	difference = dev->n_free_chunks - counted;
> +
> +	if (difference) {
> +		yaffs_trace(YAFFS_TRACE_ALWAYS,
> +			"Freechunks verification failure %d %d %d",
> +			dev->n_free_chunks, counted, difference);
> +		yaffs_free_verification_failures++;
> +	}
> +}
> +
> +int yaffs_verify_file_sane(struct yaffs_obj *in)
> +{
> +	in = in;
> +	return YAFFS_OK;

This does nothing. Remove it.

> +}
> diff --git a/fs/yaffs2/yaffs_verify.h b/fs/yaffs2/yaffs_verify.h
> new file mode 100644
> index 0000000..4f4af8d
> --- /dev/null
> +++ b/fs/yaffs2/yaffs_verify.h
> @@ -0,0 +1,43 @@
> +/*
> + * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
> + *
> + * Copyright (C) 2002-2011 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Charles Manning <charles@aleph1.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU Lesser General Public License version 2.1 as
> + * published by the Free Software Foundation.
> + *
> + * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
> + */
> +
> +#ifndef __YAFFS_VERIFY_H__
> +#define __YAFFS_VERIFY_H__
> +
> +#include "yaffs_guts.h"
> +
> +void yaffs_verify_blk(struct yaffs_dev *dev, struct yaffs_block_info *bi,
> +		      int n);
> +void yaffs_verify_collected_blk(struct yaffs_dev *dev,
> +				struct yaffs_block_info *bi, int n);
> +void yaffs_verify_blocks(struct yaffs_dev *dev);
> +
> +void yaffs_verify_oh(struct yaffs_obj *obj, struct yaffs_obj_hdr *oh,
> +		     struct yaffs_ext_tags *tags, int parent_check);
> +void yaffs_verify_file(struct yaffs_obj *obj);
> +void yaffs_verify_link(struct yaffs_obj *obj);
> +void yaffs_verify_symlink(struct yaffs_obj *obj);
> +void yaffs_verify_special(struct yaffs_obj *obj);
> +void yaffs_verify_obj(struct yaffs_obj *obj);
> +void yaffs_verify_objects(struct yaffs_dev *dev);
> +void yaffs_verify_obj_in_dir(struct yaffs_obj *obj);
> +void yaffs_verify_dir(struct yaffs_obj *directory);
> +void yaffs_verify_free_chunks(struct yaffs_dev *dev);
> +
> +int yaffs_verify_file_sane(struct yaffs_obj *obj);
> +
> +int yaffs_skip_verification(struct yaffs_dev *dev);
> +
> +#endif

Many of these are local to yaffs_verify.c and should be made static and
removed from the header file.

~Ryan
