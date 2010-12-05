Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0LEWCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 17:02:05 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16317 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0LEWCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 17:02:04 -0500
Date: Sun, 5 Dec 2010 22:55:07 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Charles Manning <cdhmanning@gmail.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Add yaffs2 file system: checkpoint and ecc code
In-Reply-To: <1291154254-22533-3-git-send-email-cdhmanning@gmail.com>
Message-ID: <alpine.LNX.2.00.1012052242130.16078@swampdragon.chaosbits.net>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <1291154254-22533-3-git-send-email-cdhmanning@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Charles Manning wrote:

> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> ---
>  fs/yaffs2/yaffs_checkptrw.c |  420 +++++++++++++++++++++++++++++++++++++++++++
>  fs/yaffs2/yaffs_checkptrw.h |   33 ++++
>  fs/yaffs2/yaffs_ecc.c       |  298 ++++++++++++++++++++++++++++++
>  fs/yaffs2/yaffs_ecc.h       |   44 +++++
>  4 files changed, 795 insertions(+), 0 deletions(-)
>  create mode 100644 fs/yaffs2/yaffs_checkptrw.c
>  create mode 100644 fs/yaffs2/yaffs_checkptrw.h
>  create mode 100644 fs/yaffs2/yaffs_ecc.c
>  create mode 100644 fs/yaffs2/yaffs_ecc.h
> 

Just a few small comments below.


[...]
> +int yaffs2_get_checkpt_sum(struct yaffs_dev *dev, u32 * sum)
> +{
> +	u32 composite_sum;
> +	composite_sum = (dev->checkpt_sum << 8) | (dev->checkpt_xor & 0xFF);
> +	*sum = composite_sum;
> +	return 1;
> +}

Why not get rid of the redundant local variable and simply do

  *sum = (dev->checkpt_sum << 8) | (dev->checkpt_xor & 0xFF);

??


[...]
> +int yaffs2_checkpt_wr(struct yaffs_dev *dev, const void *data, int n_bytes)
> +{
> +	int i = 0;
> +	int ok = 1;
> +
> +	u8 *data_bytes = (u8 *) data;

'data' is a 'const void *' and this casts away const. Probably fine, just 
makes my toes curl.


[...]
> +int yaffs2_checkpt_rd(struct yaffs_dev *dev, void *data, int n_bytes)
> +{
> +	int i = 0;
> +	int ok = 1;
> +	struct yaffs_ext_tags tags;
> +
> +	int chunk;
> +	int realigned_chunk;
> +
> +	u8 *data_bytes = (u8 *) data;

here you are not casting away const, but since 'data' is a void pointer 
the cast is just completely superfluous and should just go away.


[...]
> +			if (dev->checkpt_cur_block < 0)
> +				ok = 0;
> +			else {

Nitpicking, but this should be 

  if (dev->checkpt_cur_block < 0) {
    ok = 0;
  } else {
  ...

curly brace on both branches since it's used on one of them (according to 
CodingStyle).


[...]
> +int yaffs_checkpt_close(struct yaffs_dev *dev)
> +{
> +
> +	if (dev->checkpt_open_write) {
> +		if (dev->checkpt_byte_offs != 0)
> +			yaffs2_checkpt_flush_buffer(dev);
> +	} else if (dev->checkpt_block_list) {
> +		int i;
> +		for (i = 0;
> +		     i < dev->blocks_in_checkpt
> +		     && dev->checkpt_block_list[i] >= 0; i++) {
> +			int blk = dev->checkpt_block_list[i];
> +			struct yaffs_block_info *bi = NULL;
> +			if (dev->internal_start_block <= blk
> +			    && blk <= dev->internal_end_block)
> +				bi = yaffs_get_block_info(dev, blk);
> +			if (bi && bi->block_state == YAFFS_BLOCK_STATE_EMPTY)
> +				bi->block_state = YAFFS_BLOCK_STATE_CHECKPOINT;
> +			else {
> +				/* Todo this looks odd... */
> +			}

1) nitpicking about curly braces again (see above).
2) try grep'ing the source for "todo", "xxx", "fixme" and similar, then 
check the age of those comments. If things like this are not addressed (by 
other than a "todo" comment) on initial commit they stand a good chance of 
never getting addressed...


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

