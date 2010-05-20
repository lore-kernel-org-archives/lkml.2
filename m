Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0ETIdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:33:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58552 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab0ETIdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:33:31 -0400
To: Jens Axboe <jens.axboe@oracle.com>
CC: torvalds@linux-foundation.org, miklos@szeredi.hu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-reply-to: <20100519190510.GZ25951@kernel.dk> (message from Jens Axboe on
	Wed, 19 May 2010 21:05:11 +0200)
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org> <20100519180554.GY25951@kernel.dk> <20100519190510.GZ25951@kernel.dk>
Message-Id: <E1OF1C0-0007mV-VZ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 20 May 2010 10:33:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, Jens Axboe wrote:
> On Wed, May 19 2010, Jens Axboe wrote:
> > On Wed, May 19 2010, Linus Torvalds wrote:
> > > 
> > > 
> > > On Wed, 19 May 2010, Miklos Szeredi wrote:
> > > > 
> > > > One issue I see is that it's possible to grow pipes indefinitely.
> > > > Should this be restricted to privileged users?
> > > 
> > > Yes. But perhaps only if it grows past the default (or perhaps "default*2" 
> > > or similar). That way a normal user could shrink the pipe buffers, and 
> > > then grow them again if he wants to.
> > 
> > That's still a bit arbitrary, I don't think allowing default*2 only for
> > non-root is going to be hugely interesting. But limiting makes sense,
> > but lets at least allow a larger max limit for the normal user. I'm
> > suspecting that the media application that wants to use this will not be
> > running as root, and we don't make the feature properly available to the
> > ones that want to use it, then we may as well not do it.
> > 
> > Or we could expose a sysctl for instance that holds the max non-root
> > size. And make that default to default*16 or something. How does that
> > sound?
> > 
> > > Oh, and I think you need to also require that there be at least two 
> > > buffers. Otherwise we can't guarantee POSIX behavior, I think.
> > 
> > Good point, and at least that part is easily doable :-)
> 
> So I updated the patch, that branch was pretty ancient... The fcntl pipe
> numbers were also screwed up, so got that fixed. New patch is here:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=23dcb845246946aeda5a5e398c6911381ad28365

Not sure why you didn't take my updated patch.  Yours misses
conversion of kernel/trace/trace.c as well as some hunks below (that
renaming the "pages" and "partial" arrays and a compile test would
have revealed).

Thanks,
Miklos

> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Wed, 19 May 2010 18:47:30 +0000 (+0200)
> Subject: pipe: add support for shrinking and growing pipes
> X-Git-Url: http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff_plain;h=23dcb845246946aeda5a5e398c6911381ad28365
> 
> pipe: add support for shrinking and growing pipes
> 
> This patch adds F_GETPIPE_SZ and F_SETPIPE_SZ fcntl() actions for
> growing and shrinking the size of a pipe and adjusts pipe.c and splice.c
> (and relay and network splice) usage to work with these larger (or smaller)
> pipes.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 452d02f..bcba960 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -14,6 +14,7 @@
>  #include <linux/dnotify.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> +#include <linux/pipe_fs_i.h>
>  #include <linux/security.h>
>  #include <linux/ptrace.h>
>  #include <linux/signal.h>
> @@ -412,6 +413,10 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
>  	case F_NOTIFY:
>  		err = fcntl_dirnotify(fd, filp, arg);
>  		break;
> +	case F_SETPIPE_SZ:
> +	case F_GETPIPE_SZ:
> +		err = pipe_fcntl(filp, cmd, arg);
> +		break;
>  	default:
>  		break;
>  	}
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 37ba29f..054b8a6 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -11,6 +11,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/fs.h>
> +#include <linux/log2.h>
>  #include <linux/mount.h>
>  #include <linux/pipe_fs_i.h>
>  #include <linux/uio.h>
> @@ -390,7 +391,7 @@ redo:
>  			if (!buf->len) {
>  				buf->ops = NULL;
>  				ops->release(pipe, buf);
> -				curbuf = (curbuf + 1) & (PIPE_BUFFERS-1);
> +				curbuf = (curbuf + 1) & (pipe->buffers - 1);
>  				pipe->curbuf = curbuf;
>  				pipe->nrbufs = --bufs;
>  				do_wakeup = 1;
> @@ -472,7 +473,7 @@ pipe_write(struct kiocb *iocb, const struct iovec *_iov,
>  	chars = total_len & (PAGE_SIZE-1); /* size of the last buffer */
>  	if (pipe->nrbufs && chars != 0) {
>  		int lastbuf = (pipe->curbuf + pipe->nrbufs - 1) &
> -							(PIPE_BUFFERS-1);
> +							(pipe->buffers - 1);
>  		struct pipe_buffer *buf = pipe->bufs + lastbuf;
>  		const struct pipe_buf_operations *ops = buf->ops;
>  		int offset = buf->offset + buf->len;
> @@ -518,8 +519,8 @@ redo1:
>  			break;
>  		}
>  		bufs = pipe->nrbufs;
> -		if (bufs < PIPE_BUFFERS) {
> -			int newbuf = (pipe->curbuf + bufs) & (PIPE_BUFFERS-1);
> +		if (bufs < pipe->buffers) {
> +			int newbuf = (pipe->curbuf + bufs) & (pipe->buffers-1);
>  			struct pipe_buffer *buf = pipe->bufs + newbuf;
>  			struct page *page = pipe->tmp_page;
>  			char *src;
> @@ -580,7 +581,7 @@ redo2:
>  			if (!total_len)
>  				break;
>  		}
> -		if (bufs < PIPE_BUFFERS)
> +		if (bufs < pipe->buffers)
>  			continue;
>  		if (filp->f_flags & O_NONBLOCK) {
>  			if (!ret)
> @@ -640,7 +641,7 @@ static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  			nrbufs = pipe->nrbufs;
>  			while (--nrbufs >= 0) {
>  				count += pipe->bufs[buf].len;
> -				buf = (buf+1) & (PIPE_BUFFERS-1);
> +				buf = (buf+1) & (pipe->buffers - 1);
>  			}
>  			mutex_unlock(&inode->i_mutex);
>  
> @@ -671,7 +672,7 @@ pipe_poll(struct file *filp, poll_table *wait)
>  	}
>  
>  	if (filp->f_mode & FMODE_WRITE) {
> -		mask |= (nrbufs < PIPE_BUFFERS) ? POLLOUT | POLLWRNORM : 0;
> +		mask |= (nrbufs < pipe->buffers) ? POLLOUT | POLLWRNORM : 0;
>  		/*
>  		 * Most Unices do not set POLLERR for FIFOs but on Linux they
>  		 * behave exactly like pipes for poll().
> @@ -877,25 +878,32 @@ struct pipe_inode_info * alloc_pipe_info(struct inode *inode)
>  
>  	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL);
>  	if (pipe) {
> -		init_waitqueue_head(&pipe->wait);
> -		pipe->r_counter = pipe->w_counter = 1;
> -		pipe->inode = inode;
> +		pipe->bufs = kzalloc(sizeof(struct pipe_buffer) * PIPE_DEF_BUFFERS, GFP_KERNEL);
> +		if (pipe->bufs) {
> +			init_waitqueue_head(&pipe->wait);
> +			pipe->r_counter = pipe->w_counter = 1;
> +			pipe->inode = inode;
> +			pipe->buffers = PIPE_DEF_BUFFERS;
> +			return pipe;
> +		}
> +		kfree(pipe);
>  	}
>  
> -	return pipe;
> +	return NULL;
>  }
>  
>  void __free_pipe_info(struct pipe_inode_info *pipe)
>  {
>  	int i;
>  
> -	for (i = 0; i < PIPE_BUFFERS; i++) {
> +	for (i = 0; i < pipe->buffers; i++) {
>  		struct pipe_buffer *buf = pipe->bufs + i;
>  		if (buf->ops)
>  			buf->ops->release(pipe, buf);
>  	}
>  	if (pipe->tmp_page)
>  		__free_page(pipe->tmp_page);
> +	kfree(pipe->bufs);
>  	kfree(pipe);
>  }
>  
> @@ -1094,6 +1102,81 @@ SYSCALL_DEFINE1(pipe, int __user *, fildes)
>  }
>  
>  /*
> + * Allocate a new array of pipe buffers and copy the info over. Returns the
> + * pipe size if successful, or return -ERROR on error.
> + */
> +static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
> +{
> +	struct pipe_buffer *bufs;
> +
> +	/*
> +	 * Must be a power-of-2 currently
> +	 */
> +	if (!is_power_of_2(arg))
> +		return -EINVAL;
> +
> +	/*
> +	 * We can shrink the pipe, if arg >= pipe->nrbufs. Since we don't
> +	 * expect a lot of shrink+grow operations, just free and allocate
> +	 * again like we would do for growing. If the pipe currently
> +	 * contains more buffers than arg, then return busy.
> +	 */
> +	if (arg < pipe->nrbufs)
> +		return -EBUSY;
> +
> +	bufs = kcalloc(arg, sizeof(struct pipe_buffer), GFP_KERNEL);
> +	if (unlikely(!bufs))
> +		return -ENOMEM;
> +
> +	/*
> +	 * The pipe array wraps around, so just start the new one at zero
> +	 * and adjust the indexes.
> +	 */
> +	if (pipe->nrbufs) {
> +		const unsigned int tail = pipe->nrbufs & (pipe->buffers - 1);
> +		const unsigned int head = pipe->nrbufs - tail;
> +
> +		if (head)
> +			memcpy(bufs, pipe->bufs + pipe->curbuf, head * sizeof(struct pipe_buffer));
> +		if (tail)
> +			memcpy(bufs + head, pipe->bufs + pipe->curbuf, tail * sizeof(struct pipe_buffer));
> +	}
> +
> +	pipe->curbuf = 0;
> +	kfree(pipe->bufs);
> +	pipe->bufs = bufs;
> +	pipe->buffers = arg;
> +	return arg;
> +}
> +
> +long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct pipe_inode_info *pipe;
> +	long ret;
> +
> +	pipe = file->f_path.dentry->d_inode->i_pipe;
> +	if (!pipe)
> +		return -EBADF;
> +
> +	mutex_lock(&pipe->inode->i_mutex);
> +
> +	switch (cmd) {
> +	case F_SETPIPE_SZ:
> +		ret = pipe_set_size(pipe, arg);
> +		break;
> +	case F_GETPIPE_SZ:
> +		ret = pipe->buffers;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	mutex_unlock(&pipe->inode->i_mutex);
> +	return ret;
> +}
> +
> +/*
>   * pipefs should _never_ be mounted by userland - too much of security hassle,
>   * no real gain from having the whole whorehouse mounted. So we don't need
>   * any operations on the root directory. However, we need a non-trivial
> diff --git a/fs/splice.c b/fs/splice.c
> index 9313b61..39f907d 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -193,8 +193,8 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
>  			break;
>  		}
>  
> -		if (pipe->nrbufs < PIPE_BUFFERS) {
> -			int newbuf = (pipe->curbuf + pipe->nrbufs) & (PIPE_BUFFERS - 1);
> +		if (pipe->nrbufs < pipe->buffers) {
> +			int newbuf = (pipe->curbuf + pipe->nrbufs) & (pipe->buffers - 1);
>  			struct pipe_buffer *buf = pipe->bufs + newbuf;
>  
>  			buf->page = spd->pages[page_nr];
> @@ -214,7 +214,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
>  
>  			if (!--spd->nr_pages)
>  				break;
> -			if (pipe->nrbufs < PIPE_BUFFERS)
> +			if (pipe->nrbufs < pipe->buffers)
>  				continue;
>  
>  			break;
> @@ -265,6 +265,36 @@ static void spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
>  	page_cache_release(spd->pages[i]);
>  }
>  
> +/*
> + * Check if we need to grow the arrays holding pages and partial page
> + * descriptions.
> + */
> +int splice_grow_spd(struct pipe_inode_info *pipe, struct splice_pipe_desc *spd)
> +{
> +	if (pipe->buffers <= PIPE_DEF_BUFFERS)
> +		return 0;
> +
> +	spd->pages = kmalloc(pipe->buffers * sizeof(struct page *), GFP_KERNEL);
> +	spd->partial = kmalloc(pipe->buffers * sizeof(struct partial_page), GFP_KERNEL);
> +
> +	if (spd->pages && spd->partial)
> +		return 0;
> +
> +	kfree(spd->pages);
> +	kfree(spd->partial);
> +	return -ENOMEM;
> +}
> +
> +void splice_shrink_spd(struct pipe_inode_info *pipe,
> +		       struct splice_pipe_desc *spd)
> +{
> +	if (pipe->buffers <= PIPE_DEF_BUFFERS)
> +		return;
> +
> +	kfree(spd->pages);
> +	kfree(spd->partial);
> +}
> +
>  static int
>  __generic_file_splice_read(struct file *in, loff_t *ppos,
>  			   struct pipe_inode_info *pipe, size_t len,
> @@ -272,8 +302,8 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
>  {
>  	struct address_space *mapping = in->f_mapping;
>  	unsigned int loff, nr_pages, req_pages;
> -	struct page *pages[PIPE_BUFFERS];
> -	struct partial_page partial[PIPE_BUFFERS];
> +	struct page *pages[PIPE_DEF_BUFFERS];
> +	struct partial_page partial[PIPE_DEF_BUFFERS];
>  	struct page *page;
>  	pgoff_t index, end_index;
>  	loff_t isize;
> @@ -286,15 +316,18 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
>  		.spd_release = spd_release_page,
>  	};
>  
> +	if (splice_grow_spd(pipe, &spd))
> +		return -ENOMEM;
> +
>  	index = *ppos >> PAGE_CACHE_SHIFT;
>  	loff = *ppos & ~PAGE_CACHE_MASK;
>  	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
> -	nr_pages = min(req_pages, (unsigned)PIPE_BUFFERS);
> +	nr_pages = min(req_pages, pipe->buffers);
>  
>  	/*
>  	 * Lookup the (hopefully) full range of pages we need.
>  	 */
> -	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, pages);
> +	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, spd.pages);
>  	index += spd.nr_pages;
>  
>  	/*
> @@ -335,7 +368,7 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
>  			unlock_page(page);
>  		}
>  
> -		pages[spd.nr_pages++] = page;
> +		spd.pages[spd.nr_pages++] = page;
>  		index++;
>  	}
>  
> @@ -356,7 +389,7 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
>  		 * this_len is the max we'll use from this page
>  		 */
>  		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
> -		page = pages[page_nr];
> +		page = spd.pages[page_nr];
>  
>  		if (PageReadahead(page))
>  			page_cache_async_readahead(mapping, &in->f_ra, in,

missing a hunk here:

@@ -393,8 +426,8 @@ __generic_file_splice_read(struct file *
 					error = -ENOMEM;
 					break;
 				}
-				page_cache_release(pages[page_nr]);
-				pages[page_nr] = page;
+				page_cache_release(spd.pages[page_nr]);
+				spd.pages[page_nr] = page;
 			}
 			/*
 			 * page was already under io and is now done, great



> @@ -451,8 +484,8 @@ fill_it:
>  			len = this_len;
>  		}
>  
> -		partial[page_nr].offset = loff;
> -		partial[page_nr].len = this_len;
> +		spd.partial[page_nr].offset = loff;
> +		spd.partial[page_nr].len = this_len;
>  		len -= this_len;
>  		loff = 0;
>  		spd.nr_pages++;
> @@ -464,12 +497,13 @@ fill_it:
>  	 * we got, 'nr_pages' is how many pages are in the map.
>  	 */
>  	while (page_nr < nr_pages)
> -		page_cache_release(pages[page_nr++]);
> +		page_cache_release(spd.pages[page_nr++]);
>  	in->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
>  
>  	if (spd.nr_pages)
> -		return splice_to_pipe(pipe, &spd);
> +		error = splice_to_pipe(pipe, &spd);
>  
> +	splice_shrink_spd(pipe, &spd);
>  	return error;
>  }
>  
> @@ -560,9 +594,9 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
>  	unsigned int nr_pages;
>  	unsigned int nr_freed;
>  	size_t offset;
> -	struct page *pages[PIPE_BUFFERS];
> -	struct partial_page partial[PIPE_BUFFERS];
> -	struct iovec vec[PIPE_BUFFERS];
> +	struct page *pages[PIPE_DEF_BUFFERS];
> +	struct partial_page partial[PIPE_DEF_BUFFERS];
> +	struct iovec *vec, __vec[PIPE_DEF_BUFFERS];
>  	pgoff_t index;
>  	ssize_t res;
>  	size_t this_len;
> @@ -576,11 +610,22 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
>  		.spd_release = spd_release_page,
>  	};
>  
> +	if (splice_grow_spd(pipe, &spd))
> +		return -ENOMEM;
> +
> +	res = -ENOMEM;
> +	vec = __vec;
> +	if (pipe->buffers > PIPE_DEF_BUFFERS) {
> +		vec = kmalloc(pipe->buffers * sizeof(struct iovec), GFP_KERNEL);
> +		if (!vec)
> +			goto shrink_ret;
> +	}
> +
>  	index = *ppos >> PAGE_CACHE_SHIFT;
>  	offset = *ppos & ~PAGE_CACHE_MASK;
>  	nr_pages = (len + offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
>  
> -	for (i = 0; i < nr_pages && i < PIPE_BUFFERS && len; i++) {
> +	for (i = 0; i < nr_pages && i < pipe->buffers && len; i++) {
>  		struct page *page;
>  
>  		page = alloc_page(GFP_USER);

and another two:

@@ -591,7 +634,7 @@ ssize_t default_file_splice_read(struct
 		this_len = min_t(size_t, len, PAGE_CACHE_SIZE - offset);
 		vec[i].iov_base = (void __user *) page_address(page);
 		vec[i].iov_len = this_len;
-		pages[i] = page;
+		spd.pages[i] = page;
 		spd.nr_pages++;
 		len -= this_len;
 		offset = 0;
@@ -610,11 +653,11 @@ ssize_t default_file_splice_read(struct
 	nr_freed = 0;
 	for (i = 0; i < spd.nr_pages; i++) {
 		this_len = min_t(size_t, vec[i].iov_len, res);
-		partial[i].offset = 0;
-		partial[i].len = this_len;
+		spd.partial[i].offset = 0;
+		spd.partial[i].len = this_len;
 		if (!this_len) {
-			__free_page(pages[i]);
-			pages[i] = NULL;
+			__free_page(spd.pages[i]);
+			spd.pages[i] = NULL;
 			nr_freed++;
 		}
 		res -= this_len;



> @@ -625,13 +670,18 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
>  	if (res > 0)
>  		*ppos += res;
>  
> +shrink_ret:
> +	if (vec != __vec)
> +		kfree(vec);
> +	splice_shrink_spd(pipe, &spd);
>  	return res;
>  
>  err:
>  	for (i = 0; i < spd.nr_pages; i++)
>  		__free_page(pages[i]);
>  
> -	return error;
> +	res = error;
> +	goto shrink_ret;
>  }
>  EXPORT_SYMBOL(default_file_splice_read);
>  
> @@ -784,7 +834,7 @@ int splice_from_pipe_feed(struct pipe_inode_info *pipe, struct splice_desc *sd,
>  		if (!buf->len) {
>  			buf->ops = NULL;
>  			ops->release(pipe, buf);
> -			pipe->curbuf = (pipe->curbuf + 1) & (PIPE_BUFFERS - 1);
> +			pipe->curbuf = (pipe->curbuf + 1) & (pipe->buffers - 1);
>  			pipe->nrbufs--;
>  			if (pipe->inode)
>  				sd->need_wakeup = true;
> @@ -1211,7 +1261,7 @@ out_release:
>  	 * If we did an incomplete transfer we must release
>  	 * the pipe buffers in question:
>  	 */
> -	for (i = 0; i < PIPE_BUFFERS; i++) {
> +	for (i = 0; i < pipe->buffers; i++) {
>  		struct pipe_buffer *buf = pipe->bufs + i;
>  
>  		if (buf->ops) {
> @@ -1371,7 +1421,8 @@ static long do_splice(struct file *in, loff_t __user *off_in,
>   */
>  static int get_iovec_page_array(const struct iovec __user *iov,
>  				unsigned int nr_vecs, struct page **pages,
> -				struct partial_page *partial, int aligned)
> +				struct partial_page *partial, int aligned,
> +				unsigned int pipe_buffers)
>  {
>  	int buffers = 0, error = 0;
>  
> @@ -1414,8 +1465,8 @@ static int get_iovec_page_array(const struct iovec __user *iov,
>  			break;
>  
>  		npages = (off + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -		if (npages > PIPE_BUFFERS - buffers)
> -			npages = PIPE_BUFFERS - buffers;
> +		if (npages > pipe_buffers - buffers)
> +			npages = pipe_buffers - buffers;
>  
>  		error = get_user_pages_fast((unsigned long)base, npages,
>  					0, &pages[buffers]);
> @@ -1450,7 +1501,7 @@ static int get_iovec_page_array(const struct iovec __user *iov,
>  		 * or if we mapped the max number of pages that we have
>  		 * room for.
>  		 */
> -		if (error < npages || buffers == PIPE_BUFFERS)
> +		if (error < npages || buffers == pipe_buffers)
>  			break;
>  
>  		nr_vecs--;
> @@ -1593,8 +1644,8 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
>  			     unsigned long nr_segs, unsigned int flags)
>  {
>  	struct pipe_inode_info *pipe;
> -	struct page *pages[PIPE_BUFFERS];
> -	struct partial_page partial[PIPE_BUFFERS];
> +	struct page *pages[PIPE_DEF_BUFFERS];
> +	struct partial_page partial[PIPE_DEF_BUFFERS];
>  	struct splice_pipe_desc spd = {
>  		.pages = pages,
>  		.partial = partial,
> @@ -1602,17 +1653,25 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
>  		.ops = &user_page_pipe_buf_ops,
>  		.spd_release = spd_release_page,
>  	};
> +	long ret;
>  
>  	pipe = pipe_info(file->f_path.dentry->d_inode);
>  	if (!pipe)
>  		return -EBADF;
>  
> -	spd.nr_pages = get_iovec_page_array(iov, nr_segs, pages, partial,
> -					    flags & SPLICE_F_GIFT);
> +	if (splice_grow_spd(pipe, &spd))
> +		return -ENOMEM;
> +
> +	spd.nr_pages = get_iovec_page_array(iov, nr_segs, spd.pages,
> +					    spd.partial, flags & SPLICE_F_GIFT,
> +					    pipe->buffers);
>  	if (spd.nr_pages <= 0)
> -		return spd.nr_pages;
> +		ret = spd.nr_pages;
> +	else
> +		ret = splice_to_pipe(pipe, &spd);
>  
> -	return splice_to_pipe(pipe, &spd);
> +	splice_shrink_spd(pipe, &spd);
> +	return ret;
>  }
>  
>  /*
> @@ -1738,13 +1797,13 @@ static int opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
>  	 * Check ->nrbufs without the inode lock first. This function
>  	 * is speculative anyways, so missing one is ok.
>  	 */
> -	if (pipe->nrbufs < PIPE_BUFFERS)
> +	if (pipe->nrbufs < pipe->buffers)
>  		return 0;
>  
>  	ret = 0;
>  	pipe_lock(pipe);
>  
> -	while (pipe->nrbufs >= PIPE_BUFFERS) {
> +	while (pipe->nrbufs >= pipe->buffers) {
>  		if (!pipe->readers) {
>  			send_sig(SIGPIPE, current, 0);
>  			ret = -EPIPE;
> @@ -1810,7 +1869,7 @@ retry:
>  		 * Cannot make any progress, because either the input
>  		 * pipe is empty or the output pipe is full.
>  		 */
> -		if (!ipipe->nrbufs || opipe->nrbufs >= PIPE_BUFFERS) {
> +		if (!ipipe->nrbufs || opipe->nrbufs >= opipe->buffers) {
>  			/* Already processed some buffers, break */
>  			if (ret)
>  				break;
> @@ -1831,7 +1890,7 @@ retry:
>  		}
>  
>  		ibuf = ipipe->bufs + ipipe->curbuf;
> -		nbuf = (opipe->curbuf + opipe->nrbufs) % PIPE_BUFFERS;
> +		nbuf = (opipe->curbuf + opipe->nrbufs) & (opipe->buffers - 1);
>  		obuf = opipe->bufs + nbuf;
>  
>  		if (len >= ibuf->len) {
> @@ -1841,7 +1900,7 @@ retry:
>  			*obuf = *ibuf;
>  			ibuf->ops = NULL;
>  			opipe->nrbufs++;
> -			ipipe->curbuf = (ipipe->curbuf + 1) % PIPE_BUFFERS;
> +			ipipe->curbuf = (ipipe->curbuf + 1) & (ipipe->buffers - 1);
>  			ipipe->nrbufs--;
>  			input_wakeup = true;
>  		} else {
> @@ -1914,11 +1973,11 @@ static int link_pipe(struct pipe_inode_info *ipipe,
>  		 * If we have iterated all input buffers or ran out of
>  		 * output room, break.
>  		 */
> -		if (i >= ipipe->nrbufs || opipe->nrbufs >= PIPE_BUFFERS)
> +		if (i >= ipipe->nrbufs || opipe->nrbufs >= opipe->buffers)
>  			break;
>  
> -		ibuf = ipipe->bufs + ((ipipe->curbuf + i) & (PIPE_BUFFERS - 1));
> -		nbuf = (opipe->curbuf + opipe->nrbufs) & (PIPE_BUFFERS - 1);
> +		ibuf = ipipe->bufs + ((ipipe->curbuf + i) & (ipipe->buffers-1));
> +		nbuf = (opipe->curbuf + opipe->nrbufs) & (opipe->buffers - 1);
>  
>  		/*
>  		 * Get a reference to this pipe buffer,
> diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
> index 8603740..afc00af 100644
> --- a/include/linux/fcntl.h
> +++ b/include/linux/fcntl.h
> @@ -22,6 +22,12 @@
>  #define F_NOTIFY	(F_LINUX_SPECIFIC_BASE+2)
>  
>  /*
> + * Set and get of pipe page size array
> + */
> +#define F_SETPIPE_SZ	(F_LINUX_SPECIFIC_BASE + 7)
> +#define F_GETPIPE_SZ	(F_LINUX_SPECIFIC_BASE + 8)
> +
> +/*
>   * Types of directory notifications that may be requested.
>   */
>  #define DN_ACCESS	0x00000001	/* File accessed */
> diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
> index b43a9e0..65f4282 100644
> --- a/include/linux/pipe_fs_i.h
> +++ b/include/linux/pipe_fs_i.h
> @@ -3,7 +3,7 @@
>  
>  #define PIPEFS_MAGIC 0x50495045
>  
> -#define PIPE_BUFFERS (16)
> +#define PIPE_DEF_BUFFERS	16
>  
>  #define PIPE_BUF_FLAG_LRU	0x01	/* page is on the LRU */
>  #define PIPE_BUF_FLAG_ATOMIC	0x02	/* was atomically mapped */
> @@ -44,17 +44,17 @@ struct pipe_buffer {
>   **/
>  struct pipe_inode_info {
>  	wait_queue_head_t wait;
> -	unsigned int nrbufs, curbuf;
> -	struct page *tmp_page;
> +	unsigned int nrbufs, curbuf, buffers;
>  	unsigned int readers;
>  	unsigned int writers;
>  	unsigned int waiting_writers;
>  	unsigned int r_counter;
>  	unsigned int w_counter;
> +	struct page *tmp_page;
>  	struct fasync_struct *fasync_readers;
>  	struct fasync_struct *fasync_writers;
>  	struct inode *inode;
> -	struct pipe_buffer bufs[PIPE_BUFFERS];
> +	struct pipe_buffer *bufs;
>  };
>  
>  /*
> @@ -154,4 +154,7 @@ int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
>  int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
>  void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
>  
> +/* for F_SETPIPE_SZ and F_GETPIPE_SZ */
> +long pipe_fcntl(struct file *, unsigned int, unsigned long arg);
> +
>  #endif
> diff --git a/include/linux/splice.h b/include/linux/splice.h
> index 18e7c7c..997c3b4 100644
> --- a/include/linux/splice.h
> +++ b/include/linux/splice.h
> @@ -82,4 +82,11 @@ extern ssize_t splice_to_pipe(struct pipe_inode_info *,
>  extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
>  				      splice_direct_actor *);
>  
> +/*
> + * for dynamic pipe sizing
> + */
> +extern int splice_grow_spd(struct pipe_inode_info *, struct splice_pipe_desc *);
> +extern void splice_shrink_spd(struct pipe_inode_info *,
> +				struct splice_pipe_desc *);
> +
>  #endif
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 3d97f28..4268287 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -1231,8 +1231,8 @@ static ssize_t subbuf_splice_actor(struct file *in,
>  	size_t read_subbuf = read_start / subbuf_size;
>  	size_t padding = rbuf->padding[read_subbuf];
>  	size_t nonpad_end = read_subbuf * subbuf_size + subbuf_size - padding;
> -	struct page *pages[PIPE_BUFFERS];
> -	struct partial_page partial[PIPE_BUFFERS];
> +	struct page *pages[PIPE_DEF_BUFFERS];
> +	struct partial_page partial[PIPE_DEF_BUFFERS];
>  	struct splice_pipe_desc spd = {
>  		.pages = pages,
>  		.nr_pages = 0,
> @@ -1245,6 +1245,8 @@ static ssize_t subbuf_splice_actor(struct file *in,
>  
>  	if (rbuf->subbufs_produced == rbuf->subbufs_consumed)
>  		return 0;
> +	if (splice_grow_spd(pipe, &spd))
> +		return -ENOMEM;
>  
>  	/*
>  	 * Adjust read len, if longer than what is available
> @@ -1255,7 +1257,7 @@ static ssize_t subbuf_splice_actor(struct file *in,
>  	subbuf_pages = rbuf->chan->alloc_size >> PAGE_SHIFT;
>  	pidx = (read_start / PAGE_SIZE) % subbuf_pages;
>  	poff = read_start & ~PAGE_MASK;
> -	nr_pages = min_t(unsigned int, subbuf_pages, PIPE_BUFFERS);
> +	nr_pages = min_t(unsigned int, subbuf_pages, pipe->buffers);
>  
>  	for (total_len = 0; spd.nr_pages < nr_pages; spd.nr_pages++) {
>  		unsigned int this_len, this_end, private;
> @@ -1289,16 +1291,19 @@ static ssize_t subbuf_splice_actor(struct file *in,
>  		}
>  	}
>  
> +	ret = 0;
>  	if (!spd.nr_pages)
> -		return 0;
> +		goto out;
>  
>  	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
>  	if (ret < 0 || ret < total_len)
> -		return ret;
> +		goto out;
>  
>          if (read_start + ret == nonpad_end)
>                  ret += padding;
>  
> +out:
> +	splice_shrink_spd(pipe, &spd);
>          return ret;
>  }
>  
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 93c4e06..9319817 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1417,12 +1417,13 @@ new_page:
>  /*
>   * Fill page/offset/length into spd, if it can hold more pages.
>   */
> -static inline int spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
> +static inline int spd_fill_page(struct splice_pipe_desc *spd,
> +				struct pipe_inode_info *pipe, struct page *page,
>  				unsigned int *len, unsigned int offset,
>  				struct sk_buff *skb, int linear,
>  				struct sock *sk)
>  {
> -	if (unlikely(spd->nr_pages == PIPE_BUFFERS))
> +	if (unlikely(spd->nr_pages == pipe->buffers))
>  		return 1;
>  
>  	if (linear) {
> @@ -1458,7 +1459,8 @@ static inline int __splice_segment(struct page *page, unsigned int poff,
>  				   unsigned int plen, unsigned int *off,
>  				   unsigned int *len, struct sk_buff *skb,
>  				   struct splice_pipe_desc *spd, int linear,
> -				   struct sock *sk)
> +				   struct sock *sk,
> +				   struct pipe_inode_info *pipe)
>  {
>  	if (!*len)
>  		return 1;
> @@ -1481,7 +1483,7 @@ static inline int __splice_segment(struct page *page, unsigned int poff,
>  		/* the linear region may spread across several pages  */
>  		flen = min_t(unsigned int, flen, PAGE_SIZE - poff);
>  
> -		if (spd_fill_page(spd, page, &flen, poff, skb, linear, sk))
> +		if (spd_fill_page(spd, pipe, page, &flen, poff, skb, linear, sk))
>  			return 1;
>  
>  		__segment_seek(&page, &poff, &plen, flen);
> @@ -1496,9 +1498,9 @@ static inline int __splice_segment(struct page *page, unsigned int poff,
>   * Map linear and fragment data from the skb to spd. It reports failure if the
>   * pipe is full or if we already spliced the requested length.
>   */
> -static int __skb_splice_bits(struct sk_buff *skb, unsigned int *offset,
> -			     unsigned int *len, struct splice_pipe_desc *spd,
> -			     struct sock *sk)
> +static int __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
> +			     unsigned int *offset, unsigned int *len,
> +			     struct splice_pipe_desc *spd, struct sock *sk)
>  {
>  	int seg;
>  
> @@ -1508,7 +1510,7 @@ static int __skb_splice_bits(struct sk_buff *skb, unsigned int *offset,
>  	if (__splice_segment(virt_to_page(skb->data),
>  			     (unsigned long) skb->data & (PAGE_SIZE - 1),
>  			     skb_headlen(skb),
> -			     offset, len, skb, spd, 1, sk))
> +			     offset, len, skb, spd, 1, sk, pipe))
>  		return 1;
>  
>  	/*
> @@ -1518,7 +1520,7 @@ static int __skb_splice_bits(struct sk_buff *skb, unsigned int *offset,
>  		const skb_frag_t *f = &skb_shinfo(skb)->frags[seg];
>  
>  		if (__splice_segment(f->page, f->page_offset, f->size,
> -				     offset, len, skb, spd, 0, sk))
> +				     offset, len, skb, spd, 0, sk, pipe))
>  			return 1;
>  	}
>  
> @@ -1535,8 +1537,8 @@ int skb_splice_bits(struct sk_buff *skb, unsigned int offset,
>  		    struct pipe_inode_info *pipe, unsigned int tlen,
>  		    unsigned int flags)
>  {
> -	struct partial_page partial[PIPE_BUFFERS];
> -	struct page *pages[PIPE_BUFFERS];
> +	struct partial_page partial[PIPE_DEF_BUFFERS];
> +	struct page *pages[PIPE_DEF_BUFFERS];
>  	struct splice_pipe_desc spd = {
>  		.pages = pages,
>  		.partial = partial,
> @@ -1546,12 +1548,16 @@ int skb_splice_bits(struct sk_buff *skb, unsigned int offset,
>  	};
>  	struct sk_buff *frag_iter;
>  	struct sock *sk = skb->sk;
> +	int ret = 0;
> +
> +	if (splice_grow_spd(pipe, &spd))
> +		return -ENOMEM;
>  
>  	/*
>  	 * __skb_splice_bits() only fails if the output has no room left,
>  	 * so no point in going over the frag_list for the error case.
>  	 */
> -	if (__skb_splice_bits(skb, &offset, &tlen, &spd, sk))
> +	if (__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk))
>  		goto done;
>  	else if (!tlen)
>  		goto done;
> @@ -1562,14 +1568,12 @@ int skb_splice_bits(struct sk_buff *skb, unsigned int offset,
>  	skb_walk_frags(skb, frag_iter) {
>  		if (!tlen)
>  			break;
> -		if (__skb_splice_bits(frag_iter, &offset, &tlen, &spd, sk))
> +		if (__skb_splice_bits(frag_iter, pipe, &offset, &tlen, &spd, sk))
>  			break;
>  	}
>  
>  done:
>  	if (spd.nr_pages) {
> -		int ret;
> -
>  		/*
>  		 * Drop the socket lock, otherwise we have reverse
>  		 * locking dependencies between sk_lock and i_mutex
> @@ -1582,10 +1586,10 @@ done:
>  		release_sock(sk);
>  		ret = splice_to_pipe(pipe, &spd);
>  		lock_sock(sk);
> -		return ret;
>  	}
>  
> -	return 0;
> +	splice_shrink_spd(pipe, &spd);
> +	return ret;
>  }
>  
>  /**
