Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab0E1JlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:41:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53474 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab0E1JlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:41:09 -0400
To: Changli Gao <xiaosuo@gmail.com>
CC: axboe@kernel.dk, viro@zeniv.linux.org.uk, matthew@wil.cx, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xiaosuo@gmail.com
In-reply-to: <1274885054-15698-1-git-send-email-xiaosuo@gmail.com> (message
	from Changli Gao on Wed, 26 May 2010 22:44:14 +0800)
Subject: Re: [PATCH v2 3/4]: sendfile: remove flags paramter of do_splice_direct()
References: <1274885054-15698-1-git-send-email-xiaosuo@gmail.com>
Message-Id: <E1OHw3d-0001yr-Ag@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 May 2010 11:40:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Changli Gao wrote:
> remove flags paramter of do_splice_direct().
> 
> the flags parameter of do_splice_direct() doesn't mean non-block read of
> in file,

Actually, it does.  Look at the SPLICE_F_NONBLOCK usage in
__generic_splice_file_read().

>  but non-block read/write of pipe. As the reader and writer of process
> internal pipe is the process itself, we don't need this flags.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
>  fs/read_write.c    |   15 ++-------------
>  fs/splice.c        |   19 +++----------------
>  include/linux/fs.h |    2 +-
>  3 files changed, 6 insertions(+), 30 deletions(-)
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 113386d..0688e05 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -796,7 +796,7 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
>  	struct inode * in_inode, * out_inode;
>  	loff_t pos;
>  	ssize_t retval;
> -	int fput_needed_in, fput_needed_out, fl;
> +	int fput_needed_in, fput_needed_out;
>  
>  	/*
>  	 * Get input file, and verify that it is ok..
> @@ -846,18 +846,7 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
>  		count = max - pos;
>  	}
>  
> -	fl = 0;
> -#if 0
> -	/*
> -	 * We need to debate whether we can enable this or not. The
> -	 * man page documents EAGAIN return for the output at least,
> -	 * and the application is arguably buggy if it doesn't expect
> -	 * EAGAIN on a non-blocking file descriptor.
> -	 */
> -	if (in_file->f_flags & O_NONBLOCK)
> -		fl = SPLICE_F_NONBLOCK;
> -#endif
> -	retval = do_splice_direct(in_file, ppos, out_file, count, fl);
> +	retval = do_splice_direct(in_file, ppos, out_file, count);
>  
>  	if (retval > 0) {
>  		add_rchar(current, retval);
> diff --git a/fs/splice.c b/fs/splice.c
> index eb602cb..57172ca 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1125,7 +1125,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
>  	long ret, bytes;
>  	umode_t i_mode;
>  	size_t len;
> -	int i, flags;
> +	int i;
>  
>  	/*
>  	 * We require the input being a regular file, as we don't want to
> @@ -1162,29 +1162,18 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
>  	ret = 0;
>  	bytes = 0;
>  	len = sd->total_len;
> -	flags = sd->flags;
> -
> -	/*
> -	 * Don't block on output, we have to drain the direct pipe.
> -	 */
> -	sd->flags &= ~SPLICE_F_NONBLOCK;
>  
>  	while (len) {
>  		size_t read_len;
>  		loff_t pos = sd->pos, prev_pos = pos;
>  
> -		ret = do_splice_to(in, &pos, pipe, len, flags);
> +		ret = do_splice_to(in, &pos, pipe, len, 0);
>  		if (unlikely(ret <= 0))
>  			goto out_release;
>  
>  		read_len = ret;
>  		sd->total_len = read_len;
>  
> -		/*
> -		 * NOTE: nonblocking mode only applies to the input. We
> -		 * must not do the output in nonblocking mode as then we
> -		 * could get stuck data in the internal pipe:
> -		 */
>  		ret = actor(pipe, sd);
>  		if (unlikely(ret <= 0)) {
>  			sd->pos = prev_pos;
> @@ -1242,7 +1231,6 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
>   * @ppos:	input file offset
>   * @out:	file to splice to
>   * @len:	number of bytes to splice
> - * @flags:	splice modifier flags
>   *
>   * Description:
>   *    For use by do_sendfile(). splice can easily emulate sendfile, but
> @@ -1252,12 +1240,11 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
>   *
>   */
>  long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
> -		      size_t len, unsigned int flags)
> +		      size_t len)
>  {
>  	struct splice_desc sd = {
>  		.len		= len,
>  		.total_len	= len,
> -		.flags		= flags,
>  		.pos		= *ppos,
>  		.u.file		= out,
>  	};
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 4079ef9..eb86433 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2224,7 +2224,7 @@ extern ssize_t generic_file_splice_write(struct pipe_inode_info *,
>  extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
>  		struct file *out, loff_t *, size_t len, unsigned int flags);
>  extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
> -		size_t len, unsigned int flags);
> +		size_t len);
>  
>  extern void
>  file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
