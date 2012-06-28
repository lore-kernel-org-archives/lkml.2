Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2F1PEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 11:04:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab2F1PEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 11:04:12 -0400
Subject: Re: [Cluster-devel] [PATCH] Fixing double brelse'ing bh allocated
 in gfs2_meta_read when EIO occurs
From: Steven Whitehouse <swhiteho@redhat.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <20120618.163131.350454467360099988.yamato@redhat.com>
References: <20120618.163131.350454467360099988.yamato@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 28 Jun 2012 16:02:56 +0100
Message-ID: <1340895776.2770.17.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Many thanks for the patch. I've added it to the -nmw git tree. Sorry for
the delay, just getting back up to speed after my holiday,

Steve.

On Mon, 2012-06-18 at 16:31 +0900, Masatake YAMATO wrote:
> This patch fixes buffer_head double free in following code path:
> 
> gfs2_block_map
> => gfs2_meta_inode_buffer
>  => gfs2_meta_indirect_buffer
>   => gfs2_meta_read
> => release_metapath
> 
> 
> gfs2_block_map calls gfs2_meta_inode_buffer with &mp.mp_bh[0]
> as an argument. mp.mp_bh are filled with zero at the beginning
> of gfs2_block_map.
> 
> If gfs2_meta_inode_buffer returns non-zero value, gfs2_block_map
> calls release_metapath to free buffers chained to mp.mp_bh.
> release_metapath checks each slot of mp.mp_bh[i] and 
> free(with brelse) unless the slot is filled with NULL.
> 
> 
> &mp.mp_bh[0] passed to gfs2_meta_inode_buffer is filled at
> gfs2_meta_read. gfs2_meta_read is filled a buffer allocated with
> gfs2_getbuf even if EIO occurs. When EIO occurs, the allocated buffer
> is brelse'ed though the pointer(wrong poiner) points the brelse'ed is
> passed back to caller via an argument bhp.
> 
> gfs2_meta_indirect_buffer, the caller also pass the wrong pointer
> to its caller with EIO. Finally gfs2_block_map gets both EIO and
> &mp.mp_bh[0] filled with the wrong pointer. release_metapath
> calls brelse again on the wrong pointer.
> 
> Signed-off-by: Masatake YAMATO<yamato@redhat.com>
> 
> diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
> index 6c1e5d1..3a56c8d 100644
> --- a/fs/gfs2/meta_io.c
> +++ b/fs/gfs2/meta_io.c
> @@ -213,8 +213,10 @@ int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno, int flags,
>  	struct gfs2_sbd *sdp = gl->gl_sbd;
>  	struct buffer_head *bh;
>  
> -	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
> +	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) {
> +		*bhp = NULL;
>  		return -EIO;
> +	}
>  
>  	*bhp = bh = gfs2_getbuf(gl, blkno, CREATE);
>  
> @@ -235,6 +237,7 @@ int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno, int flags,
>  		if (tr && tr->tr_touched)
>  			gfs2_io_error_bh(sdp, bh);
>  		brelse(bh);
> +		*bhp = NULL;
>  		return -EIO;
>  	}
>  
> 


