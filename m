Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3ABUeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:34:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab3ABUeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:34:10 -0500
Message-ID: <50E49A06.4060901@redhat.com>
Date: Wed, 02 Jan 2013 15:35:18 -0500
From: Brian Foster <bfoster@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Maxim Patlasov <mpatlasov@parallels.com>
CC: miklos@szeredi.hu, dev@parallels.com, xemul@parallels.com,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org, anand.avati@gmail.com
Subject: Re: [PATCH 3/5] fuse: wait for end of IO on release
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru> <20121220123144.4101.84499.stgit@maximpc.sw.ru>
In-Reply-To: <20121220123144.4101.84499.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 07:31 AM, Maxim Patlasov wrote:
> There are two types of I/O activity that can be "in progress" at the time
> of fuse_release() execution: asynchronous read-ahead and write-back. The
> patch ensures that they are completed before fuse_release_common sends
> FUSE_RELEASE to userspace.
> 
> So far as fuse_release() waits for end of async I/O, its callbacks
> (fuse_readpages_end and fuse_writepage_finish) calling fuse_file_put cannot
> be the last holders of fuse file anymore. To emphasize the fact, the patch
> replaces fuse_file_put with __fuse_file_put there.
> 
> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
> ---
>  fs/fuse/file.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 52 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 4f23134..aed9be2 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -137,6 +137,12 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
>  	}
>  }
>  
> +static void __fuse_file_put(struct fuse_file *ff)
> +{
> +	if (atomic_dec_and_test(&ff->count))
> +		BUG();
> +}
> +

I think a comment in or before this function to explain the reasoning
for the BUG would be helpful.

>  int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
>  		 bool isdir)
>  {
> @@ -260,7 +266,12 @@ void fuse_release_common(struct file *file, int opcode)
>  	 * Make the release synchronous if this is a fuseblk mount,
>  	 * synchronous RELEASE is allowed (and desirable) in this case
>  	 * because the server can be trusted not to screw up.
> +	 *
> +	 * We might wait for them (asynchronous READ or WRITE requests), so:
>  	 */
> +	if (ff->fc->close_wait)
> +		BUG_ON(atomic_read(&ff->count) != 1);
> +

It might be cleaner to pull the new part of the comment and the BUG_ON()
check to before the existing comment and fuse_file_put (e.g., create a
new comment).

>  	fuse_file_put(ff, ff->fc->destroy_req != NULL);
>  }
>  
> @@ -271,6 +282,31 @@ static int fuse_open(struct inode *inode, struct file *file)
>  
>  static int fuse_release(struct inode *inode, struct file *file)
>  {
> +	struct fuse_file *ff = file->private_data;
> +
> +	if (ff->fc->close_wait) {
> +		struct fuse_inode *fi = get_fuse_inode(inode);
> +
> +		/*
> +		 * Must remove file from write list. Otherwise it is possible
> +		 * this file will get more writeback from another files
> +		 * rerouted via write_files.
> +		 */
> +		spin_lock(&ff->fc->lock);
> +		list_del_init(&ff->write_entry);
> +		spin_unlock(&ff->fc->lock);
> +
> +		wait_event(fi->page_waitq, atomic_read(&ff->count) == 1);
> +
> +		/*
> +		 * Wait for threads just released ff to leave their critical
> +		 * sections. Taking spinlock is the first thing
> +		 * fuse_release_common does, so that this is unnecessary, but
> +		 * it is still good to emphasize right here, that we need this.
> +		 */
> +		spin_unlock_wait(&ff->fc->lock);

I'm all for clarity, but if the wait is unnecessary, perhaps just leave
the comment..? Just my .02.

Aside from the few nits here, the set looks pretty good to me.

Brian

> +	}
> +
>  	fuse_release_common(file, FUSE_RELEASE);
>  
>  	/* return value is ignored by VFS */
> @@ -610,8 +646,17 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
>  		unlock_page(page);
>  		page_cache_release(page);
>  	}
> -	if (req->ff)
> -		fuse_file_put(req->ff, false);
> +	if (req->ff) {
> +		if (fc->close_wait) {
> +			struct fuse_inode *fi = get_fuse_inode(req->inode);
> +
> +			spin_lock(&fc->lock);
> +			__fuse_file_put(req->ff);
> +			wake_up(&fi->page_waitq);
> +			spin_unlock(&fc->lock);
> +		} else
> +			fuse_file_put(req->ff, false);
> +	}
>  }
>  
>  struct fuse_fill_data {
> @@ -637,6 +682,7 @@ static void fuse_send_readpages(struct fuse_fill_data *data)
>  	if (fc->async_read) {
>  		req->ff = fuse_file_get(ff);
>  		req->end = fuse_readpages_end;
> +		req->inode = data->inode;
>  		fuse_request_send_background(fc, req);
>  	} else {
>  		fuse_request_send(fc, req);
> @@ -1178,7 +1224,8 @@ static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
>  static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
>  {
>  	__free_page(req->pages[0]);
> -	fuse_file_put(req->ff, false);
> +	if (!fc->close_wait)
> +		fuse_file_put(req->ff, false);
>  }
>  
>  static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
> @@ -1191,6 +1238,8 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
>  	dec_bdi_stat(bdi, BDI_WRITEBACK);
>  	dec_zone_page_state(req->pages[0], NR_WRITEBACK_TEMP);
>  	bdi_writeout_inc(bdi);
> +	if (fc->close_wait)
> +		__fuse_file_put(req->ff);
>  	wake_up(&fi->page_waitq);
>  }
>  
> 

