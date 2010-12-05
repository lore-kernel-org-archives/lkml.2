Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0LEWtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 17:49:31 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17005 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab0LEWta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 17:49:30 -0500
Date: Sun, 5 Dec 2010 23:42:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Charles Manning <cdhmanning@gmail.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] Add yaffs2 file system: mtd and flash handling
 code
In-Reply-To: <1291154254-22533-6-git-send-email-cdhmanning@gmail.com>
Message-ID: <alpine.LNX.2.00.1012052330210.16078@swampdragon.chaosbits.net>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <1291154254-22533-6-git-send-email-cdhmanning@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Charles Manning wrote:

> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
> ---
[...]
> +#include "yportenv.h"
> +
> +#include "yaffs_mtdif.h"
> +
> +#include "linux/mtd/mtd.h"
> +#include "linux/types.h"
> +#include "linux/time.h"
> +#include "linux/mtd/nand.h"
> +
> +#include "yaffs_linux.h"

Small thing, but why these blank lines between includes?


> +
> +int nandmtd_erase_block(struct yaffs_dev *dev, int block_no)
> +{
> +	struct mtd_info *mtd = yaffs_dev_to_mtd(dev);
> +	u32 addr =
> +	    ((loff_t) block_no) * dev->param.total_bytes_per_chunk
> +	    * dev->param.chunks_per_block;
> +	struct erase_info ei;
> +
> +	int retval = 0;

Why not kill the blank line before "int retval = 0;" ?


> +
> +	ei.mtd = mtd;
> +	ei.addr = addr;
> +	ei.len = dev->param.total_bytes_per_chunk * dev->param.chunks_per_block;
> +	ei.time = 1000;
> +	ei.retries = 2;
> +	ei.callback = NULL;
> +	ei.priv = (u_long) dev;
> +
> +	retval = mtd->erase(mtd, &ei);
> +
> +	if (retval == 0)
> +		return YAFFS_OK;
> +	else
> +		return YAFFS_FAIL;

Personal preference thing I guess, but I couldn't help thinking 

  return mtd->erase(mtd, &ei) ? YAFFS_FAIL : YAFFS_OK;



[...]
> +	retval = mtd->block_markbad(mtd, (loff_t) blocksize * block_no);
> +	return (retval) ? YAFFS_FAIL : YAFFS_OK;

Pointless parenthesis.


[...]
> +
> +/* mtd interface for YAFFS2 */
> +
> +#include "yportenv.h"
> +#include "yaffs_trace.h"
> +
> +#include "yaffs_mtdif2.h"
> +
> +#include "linux/mtd/mtd.h"
> +#include "linux/types.h"
> +#include "linux/time.h"
> +
> +#include "yaffs_packedtags2.h"
> +
> +#include "yaffs_linux.h"
> +

Again the blank lines between includes - why?
I can see grouping the "linux/..." includes and the rest and then put a 
blank line between the two, but the above just looks like a waste of 
vertical screen space to me.


[...]
> +		yaffs_pack_tags2_tags_only(pt2tp, tags);
> +	} else {
> +		yaffs_pack_tags2(&pt, tags, !dev->param.no_tags_ecc);
> +        }
spaces used for indentation where tabs should have been.


[...]
> +int yaffs_erase_block(struct yaffs_dev *dev, int flash_block)
> +{
> +	int result;
> +
> +	flash_block -= dev->block_offset;
> +
> +	dev->n_erasures++;
> +
> +	result = dev->param.erase_fn(dev, flash_block);
> +
> +	return result;
> +}

How about 

int yaffs_erase_block(struct yaffs_dev *dev, int flash_block)
{
     flash_block -= dev->block_offset;
     dev->n_erasures++;
     return dev->param.erase_fn(dev, flash_block);
}



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

