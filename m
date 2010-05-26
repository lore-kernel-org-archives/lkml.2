Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280Ab0EZKsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:48:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55825 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0EZKsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:48:53 -0400
To: Changli Gao <xiaosuo@gmail.com>
CC: viro@zeniv.linux.org.uk, matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xiaosuo@gmail.com
In-reply-to: <1274867803-3050-1-git-send-email-xiaosuo@gmail.com> (message
	from Changli Gao on Wed, 26 May 2010 17:56:43 +0800)
Subject: Re: [PATCH 3/3] sendfile: fix sendfile
References: <1274867803-3050-1-git-send-email-xiaosuo@gmail.com>
Message-Id: <E1OHEA9-0000Mv-8r@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 May 2010 12:48:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Changli Gao wrote:
> fix sendfile
> 
> the flags parameter of splice() doesn't mean non-block read of in file, but
> non-block read/write of pipe. As the reader and writer of process internal
> pipe is the process itself, we don't need this flags.

Sounds good.

> 
> If output file is in non-block mode, in file should be seekable to avoid data
> losing.

Like the previous patch, I don't agree.

> 
> do_splice_from() shouldn't use sd->pos, as sd->pos is for file reading,
> file->f_pos should be used instead.

This sounds sane.

These changes look like three cadidates for separate patches.  Could
you please split this patch up, and submit the first and last change
as a separate patch?

Thanks,
Miklos

> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
>  fs/read_write.c    |   23 ++++++++---------------
>  fs/splice.c        |   22 +++++-----------------
>  include/linux/fs.h |    2 +-
>  3 files changed, 14 insertions(+), 33 deletions(-)
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 113386d..a844e2c 100644
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
> @@ -808,11 +808,15 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
>  	if (!(in_file->f_mode & FMODE_READ))
>  		goto fput_in;
>  	retval = -ESPIPE;
> -	if (!ppos)
> +	if (!ppos) {
>  		ppos = &in_file->f_pos;
> -	else
> +		if ((out_file->f_flags & O_NONBLOCK) &&
> +		    !(in_file->f_mode & FMODE_PREAD))
> +			goto fput_in;
> +	} else {
>  		if (!(in_file->f_mode & FMODE_PREAD))
>  			goto fput_in;
> +	}
>  	retval = rw_verify_area(READ, in_file, ppos, count);
>  	if (retval < 0)
>  		goto fput_in;
> @@ -846,18 +850,7 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
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
> index 8137e23..e921d72 100644
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
> @@ -1232,7 +1221,8 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
>  {
>  	struct file *file = sd->u.file;
>  
> -	return do_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
> +	return do_splice_from(pipe, file, &file->f_pos, sd->total_len,
> +			      sd->flags);
>  }
>  
>  /**
> @@ -1241,7 +1231,6 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
>   * @ppos:	input file offset
>   * @out:	file to splice to
>   * @len:	number of bytes to splice
> - * @flags:	splice modifier flags
>   *
>   * Description:
>   *    For use by do_sendfile(). splice can easily emulate sendfile, but
> @@ -1251,12 +1240,11 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
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
