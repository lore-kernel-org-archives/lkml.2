Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2LDNLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:11:00 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:48800 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753282Ab2LDNK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:10:58 -0500
Message-ID: <50BDF654.8090903@tao.ma>
Date: Tue, 04 Dec 2012 21:10:44 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tao Ma <boyu.mt@taobao.com>,
        Joel Becker <jlbec@evilplan.org>
Subject: Re: linux-next: build failure after merge of the final tree (ext4
 tree related)
References: <20121204171313.119c931c616ff2a782ab1bac@canb.auug.org.au>
In-Reply-To: <20121204171313.119c931c616ff2a782ab1bac@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 124.65.207.217 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,
	Thanks for the report.

	the corresponding fix is already sent to Ted in the patch named "ext4:
Fix inline data build warning found by kernel build testing.", but it
seems that Ted hasn't pushed it into ext4dev yet.

Thanks
Tao
On 12/04/2012 02:13 PM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> fs/ocfs2/built-in.o: In function `.walk_page_buffers':
> (.text+0x2c104): multiple definition of `.walk_page_buffers'
> fs/ext4/built-in.o:(.text+0x10c1c): first defined here
> fs/ocfs2/built-in.o: In function `walk_page_buffers':
> (.opd+0x1020): multiple definition of `walk_page_buffers'
> fs/ext4/built-in.o:(.opd+0xa68): first defined here
> 
> Caused by commit c99dcc3889f5 ("ext4: add normal write support for inline
> data") from the ext4 tree.  Who would have thought that a generic name
> like that would clash? ;-(
> 
> Grep is your friend ...
> 
> I have added this patch for today (ocfs2 might like to apply something
> similar):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 4 Dec 2012 17:06:30 +1100
> Subject: [PATCH] ext4: use a less generic version of the name walk_page_buffers
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/ext4/ext4.h   |    2 +-
>  fs/ext4/inline.c |    2 +-
>  fs/ext4/inode.c  |   20 ++++++++++----------
>  3 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 9e30958..b1a169a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2057,7 +2057,7 @@ int ext4_get_block(struct inode *inode, sector_t iblock,
>  				struct buffer_head *bh_result, int create);
>  int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>  			   struct buffer_head *bh, int create);
> -int walk_page_buffers(handle_t *handle,
> +int ext4_walk_page_buffers(handle_t *handle,
>  			     struct buffer_head *head,
>  			     unsigned from,
>  			     unsigned to,
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 811457e..1fe0cc4 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -583,7 +583,7 @@ retry:
>  		ret = __block_write_begin(page, from, to, ext4_get_block);
>  
>  	if (!ret && ext4_should_journal_data(inode)) {
> -		ret = walk_page_buffers(handle, page_buffers(page),
> +		ret = ext4_walk_page_buffers(handle, page_buffers(page),
>  				from, to, NULL, do_journal_get_write_access);
>  	}
>  
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f92bd69..1a190e0 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -770,7 +770,7 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
>  	return NULL;
>  }
>  
> -int walk_page_buffers(handle_t *handle,
> +int ext4_walk_page_buffers(handle_t *handle,
>  			     struct buffer_head *head,
>  			     unsigned from,
>  			     unsigned to,
> @@ -911,7 +911,7 @@ retry:
>  		ret = __block_write_begin(page, pos, len, ext4_get_block);
>  
>  	if (!ret && ext4_should_journal_data(inode)) {
> -		ret = walk_page_buffers(handle, page_buffers(page),
> +		ret = ext4_walk_page_buffers(handle, page_buffers(page),
>  				from, to, NULL, do_journal_get_write_access);
>  	}
>  
> @@ -1133,7 +1133,7 @@ static int ext4_journalled_write_end(struct file *file,
>  			page_zero_new_buffers(page, from+copied, to);
>  		}
>  
> -		ret = walk_page_buffers(handle, page_buffers(page), from,
> +		ret = ext4_walk_page_buffers(handle, page_buffers(page), from,
>  					to, &partial, write_end_fn);
>  		if (!partial)
>  			SetPageUptodate(page);
> @@ -1942,7 +1942,7 @@ static int __ext4_journalled_writepage(struct page *page,
>  	} else {
>  		page_bufs = page_buffers(page);
>  		BUG_ON(!page_bufs);
> -		walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
> +		ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
>  	}
>  	/* As soon as we unlock the page, it can go away, but we have
>  	 * references to buffers so we are safe */
> @@ -1962,10 +1962,10 @@ static int __ext4_journalled_writepage(struct page *page,
>  		err = ext4_handle_dirty_metadata(handle, inode, inode_bh);
>  
>  	} else {
> -		ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
> +		ret = ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL,
>  					do_journal_get_write_access);
>  
> -		err = walk_page_buffers(handle, page_bufs, 0, len, NULL,
> +		err = ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL,
>  					write_end_fn);
>  	}
>  
> @@ -1977,7 +1977,7 @@ static int __ext4_journalled_writepage(struct page *page,
>  		ret = err;
>  
>  	if (!ext4_has_inline_data(inode))
> -		walk_page_buffers(handle, page_bufs, 0, len, NULL, bput_one);
> +		ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL, bput_one);
>  	ext4_set_inode_state(inode, EXT4_STATE_JDATA);
>  out:
>  	brelse(inode_bh);
> @@ -2057,7 +2057,7 @@ static int ext4_writepage(struct page *page,
>  		commit_write = 1;
>  	}
>  	page_bufs = page_buffers(page);
> -	if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
> +	if (ext4_walk_page_buffers(NULL, page_bufs, 0, len, NULL,
>  			      ext4_bh_delay_or_unwritten)) {
>  		/*
>  		 * We don't want to do block allocation, so redirty
> @@ -4888,7 +4888,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	 * journal_start/journal_stop which can block and take a long time
>  	 */
>  	if (page_has_buffers(page)) {
> -		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> +		if (!ext4_walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
>  					ext4_bh_unmapped)) {
>  			/* Wait so that we don't change page under IO */
>  			wait_on_page_writeback(page);
> @@ -4910,7 +4910,7 @@ retry_alloc:
>  	}
>  	ret = __block_page_mkwrite(vma, vmf, get_block);
>  	if (!ret && ext4_should_journal_data(inode)) {
> -		if (walk_page_buffers(handle, page_buffers(page), 0,
> +		if (ext4_walk_page_buffers(handle, page_buffers(page), 0,
>  			  PAGE_CACHE_SIZE, NULL, do_journal_get_write_access)) {
>  			unlock_page(page);
>  			ret = VM_FAULT_SIGBUS;
> 

