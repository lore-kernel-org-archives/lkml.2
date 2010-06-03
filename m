Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab0FCQGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:06:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36780 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0FCQGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:06:23 -0400
To: Jens Axboe <jaxboe@fusionio.com>
CC: miklos@szeredi.hu, mtk.manpages@gmail.com, linux-kernel@vger.kernel.org
In-reply-to: <4C0793F6.4070107@fusionio.com> (message from Jens Axboe on Thu,
	03 Jun 2010 13:37:26 +0200)
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
References: <20100524070552.GR23411@kernel.dk> <AANLkTikogQtGpO9c94A7YSmP8zdyM8dZBrwJf1nwlR4j@mail.gmail.com> 	<20100524173551.GU23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> 	<20100524175649.GV23411@kernel.dk> <AANLkTim_yrRZG6v1tMPgefeaaI-nUa35Q-mLQpuXWJ1p@mail.gmail.com> 	<20100601074534.GL1660@kernel.dk> <AANLkTinGfonivZvofBkMzv53IJZeKbFAEMVpv96BiJ30@mail.gmail.com> 	<20100603061039.GD3564@kernel.dk> <AANLkTint7OJvmTn7d7bqTJzsCxV-VlVT46PQWVH-m73g@mail.gmail.com> 	<20100603070126.GJ3564@kernel.dk> <AANLkTilwyuE-HiY0vX5askTNi1KoeuKIldmE85WrfIqU@mail.gmail.com> 	<AANLkTin2b7qE1zo0fQWIhYIzdV26zNBjHRcNAOELpUfK@mail.gmail.com> 	<4C078610.6020901@fusionio.com> <AANLkTinhO5oRDPXyXaeAOZU3i55eBKsx4iFMOzwm98na@mail.gmail.com> <AANLkTin_8MU3AbJ_KeXr2uTxtRFJ5ABmBAyigU6m-C6u@mail.gmail.com> <4C078E2B.7090107@fusionio.com> <E1OK8fK-0007Wa-BU@pomaz-ex.szeredi.hu> <4C0793F6.4070107@fusionio.com>
Message-Id: <E1OKCvz-0008DG-9g@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Jun 2010 18:06:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jun 2010, Jens Axboe wrote:
> On 2010-06-03 13:32, Miklos Szeredi wrote:
> > On Thu, 03 Jun 2010, Jens Axboe wrote:
> >> I looked at that when I did the original pipe-max-pages, but it seems
> >> we're not consistent in this regard. Anyway, here's what I came up with.
> >> Not tested yet, and I hope thunderbird doesn't fsck up the patch.
> > 
> > Unfortunately it did (line wrap damage).
> 
> I suspected it might. This better?
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index f98fae3..f7f62f3 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -26,9 +26,14 @@
> 
>  /*
>   * The max size that a non-root user is allowed to grow the pipe. Can
> - * be set by root in /proc/sys/fs/pipe-max-pages
> + * be set by root in /proc/sys/fs/pipe_max_size
>   */
> -unsigned int pipe_max_pages = PIPE_DEF_BUFFERS * 16;
> +unsigned int pipe_max_size = 1048576;
> +
> +/*
> + * Minimum pipe size, as required by POSIX
> + */
> +unsigned int pipe_min_size = PAGE_SIZE;
> 
>  /*
>   * We use a start+len construction, which provides full use of the
> @@ -1156,6 +1161,35 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long nr_pages)
>  	return nr_pages * PAGE_SIZE;
>  }
> 
> +/*
> + * Currently we rely on the pipe array holding a power-of-2 number
> + * of pages.
> + */
> +static inline unsigned int round_pipe_size(unsigned int size)
> +{
> +	unsigned long nr_pages;
> +
> +	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	return roundup_pow_of_two(nr_pages) << PAGE_SHIFT;
> +}
> +
> +/*
> + * This should work even if CONFIG_PROC_FS isn't set, as proc_dointvec_minmax
> + * will return an error.
> + */
> +int pipe_proc_fn(struct ctl_table *table, int write, void __user *buf,
> +		 size_t *lenp, loff_t *ppos)
> +{
> +	int ret;
> +
> +	ret = proc_dointvec_minmax(table, write, buf, lenp, ppos);
> +	if (ret < 0 || !write)
> +		return ret;
> +
> +	pipe_max_size = round_pipe_size(pipe_max_size);
> +	return ret;
> +}
> +
>  long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	struct pipe_inode_info *pipe;
> @@ -1169,23 +1203,19 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
> 
>  	switch (cmd) {
>  	case F_SETPIPE_SZ: {
> -		unsigned long nr_pages;
> +		unsigned int size, nr_pages;
> 
> -		/*
> -		 * Currently the array must be a power-of-2 size, so adjust
> -		 * upwards if needed.
> -		 */
> -		nr_pages = (arg + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -		nr_pages = roundup_pow_of_two(nr_pages);
> +		size = round_pipe_size(arg);
> +		nr_pages = size >> PAGE_SHIFT;
> 
> -		if (!capable(CAP_SYS_RESOURCE) && nr_pages > pipe_max_pages) {
> +		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
>  			ret = -EPERM;
>  			goto out;
> -		} else if (nr_pages < 1) {
> +		} else if (nr_pages < PAGE_SIZE) {

This should either be "nr_pages < 1" or  "size < PAGE_SIZE".

Miklos


>  			ret = -EINVAL;
>  			goto out;
>  		}
> -		ret = pipe_set_size(pipe, arg);
> +		ret = pipe_set_size(pipe, nr_pages);
>  		break;
>  		}
>  	case F_GETPIPE_SZ:
> diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
> index 16de393..4457969 100644
> --- a/include/linux/pipe_fs_i.h
> +++ b/include/linux/pipe_fs_i.h
> @@ -139,7 +139,9 @@ void pipe_lock(struct pipe_inode_info *);
>  void pipe_unlock(struct pipe_inode_info *);
>  void pipe_double_lock(struct pipe_inode_info *, struct pipe_inode_info *);
> 
> -extern unsigned int pipe_max_pages;
> +extern unsigned int pipe_max_size, pipe_min_size;
> +int pipe_proc_fn(struct ctl_table *, int, void __user *, size_t *, loff_t *);
> +
> 
>  /* Drop the inode semaphore and wait for a pipe event, atomically */
>  void pipe_wait(struct pipe_inode_info *pipe);
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 997080f..2f9b3a6 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1471,12 +1471,12 @@ static struct ctl_table fs_table[] = {
>  	},
>  #endif
>  	{
> -		.procname	= "pipe-max-pages",
> -		.data		= &pipe_max_pages,
> +		.procname	= "pipe_max_size",
> +		.data		= &pipe_max_size,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
> -		.proc_handler	= &proc_dointvec_minmax,
> -		.extra1		= &two,
> +		.proc_handler	= &pipe_proc_fn,
> +		.extra1		= &pipe_min_size,
>  	},
>  /*
>   * NOTE: do not add new entries to this table unless you have read
> 
> -- 
> Jens Axboe
> 
> 
