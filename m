Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2FDNoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:44:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab2FDNoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:44:11 -0400
Date: Mon, 4 Jun 2012 15:44:09 +0200
From: Jan Kara <jack@suse.cz>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jan Kara <jack@suse.cz>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] udf: stop using s_dirt
Message-ID: <20120604134409.GB11010@quack.suse.cz>
References: <1338810384-26437-1-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338810384-26437-1-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 04-06-12 14:46:24, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> The UDF file-system does not need the 's_dirt' superblock flag because it does
> not define the 'write_super()' method. This flag was set to 1 in few places and
> set to 0 in '->sync_fs()' and was basically useless. Stop using it because it
> is on its way out.
  Thanks. I've merged the patch to my tree.

									Honza

> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  fs/udf/super.c   |    6 ------
>  fs/udf/udfdecl.h |    1 -
>  2 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index ac8a348..34e6b87 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1948,7 +1948,6 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
>  	sb->s_op = &udf_sb_ops;
>  	sb->s_export_op = &udf_export_ops;
>  
> -	sb->s_dirt = 0;
>  	sb->s_magic = UDF_SUPER_MAGIC;
>  	sb->s_time_gran = 1000;
>  
> @@ -2070,10 +2069,6 @@ void _udf_err(struct super_block *sb, const char *function,
>  	struct va_format vaf;
>  	va_list args;
>  
> -	/* mark sb error */
> -	if (!(sb->s_flags & MS_RDONLY))
> -		sb->s_dirt = 1;
> -
>  	va_start(args, fmt);
>  
>  	vaf.fmt = fmt;
> @@ -2135,7 +2130,6 @@ static int udf_sync_fs(struct super_block *sb, int wait)
>  		 * the buffer for IO
>  		 */
>  		mark_buffer_dirty(sbi->s_lvid_bh);
> -		sb->s_dirt = 0;
>  		sbi->s_lvid_dirty = 0;
>  	}
>  	mutex_unlock(&sbi->s_alloc_mutex);
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> index ebe1031..de038da 100644
> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -129,7 +129,6 @@ static inline void udf_updated_lvid(struct super_block *sb)
>  	WARN_ON_ONCE(((struct logicalVolIntegrityDesc *)
>  		     bh->b_data)->integrityType !=
>  		     cpu_to_le32(LVID_INTEGRITY_TYPE_OPEN));
> -	sb->s_dirt = 1;
>  	UDF_SB(sb)->s_lvid_dirty = 1;
>  }
>  extern u64 lvid_get_unique_id(struct super_block *sb);
> -- 
> 1.7.7.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
