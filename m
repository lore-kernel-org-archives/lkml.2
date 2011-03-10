Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1CJRFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:05:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:47556 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab1CJRFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:05:24 -0500
Date: Thu, 10 Mar 2011 08:25:01 -0800
From: Greg KH <gregkh@suse.de>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sysfs: add more info to the oops dump
Message-ID: <20110310162501.GB23989@suse.de>
References: <1299772388-15439-1-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299772388-15439-1-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 05:53:08PM +0200, Phil Carmody wrote:
> If we're going to remember which file we accessed, we might as well
> also remember whether it was a read or a write, and if the latter,
> some indication of what was written.
> 
> e.g.
> $ echo 1 > /sys/kernel/slab/:at-0000064/sanity_checks
> $ echo c > /proc/sysrq-trigger
> ...
> [  112.457580] last sysfs file (w): /sys/kernel/slab/:at-0000064/sanity_checks
> [  112.464569]   written: 1

Has this actually helped you out?  I've been thinking of removing this
line in the dmesg entirely as I haven't seen it help in a very long time
to track anything down.

> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> ---
>  fs/sysfs/file.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index da3fefe..281e4dd 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -26,9 +26,18 @@
>  
>  /* used in crash dumps to help with debugging */
>  static char last_sysfs_file[PATH_MAX];
> +static char last_sysfs_write[16];
> +static int last_sysfs_write_len; /* magic value < 0 => read */
>  void sysfs_printk_last_file(void)
>  {
> -	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
> +	printk(KERN_EMERG "last sysfs file (%c): %s\n",
> +	       (last_sysfs_write_len < 0) ? 'r' : 'w',
> +	       last_sysfs_file);
> +	if (last_sysfs_write_len >= sizeof(last_sysfs_write))
> +		printk(KERN_EMERG "  written: %s...(%d chars)\n",
> +		       last_sysfs_write, last_sysfs_write_len);
> +	else if (last_sysfs_write_len > 0)
> +		printk(KERN_EMERG "  written: %s\n", last_sysfs_write);
>  }
>  
>  /*
> @@ -200,12 +209,19 @@ flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t
>  	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
>  	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
>  	const struct sysfs_ops * ops = buffer->ops;
> +	int copylen = min(count, sizeof(last_sysfs_write) - 1);
>  	int rc;
>  
>  	/* need attr_sd for attr and ops, its parent for kobj */
>  	if (!sysfs_get_active(attr_sd))
>  		return -ENODEV;
>  
> +	while (copylen > 0 && buffer->page[copylen-1] == '\n')
> +		--copylen; /* never print trailing \n's */
> +	memcpy(last_sysfs_write, buffer->page, copylen);
> +	last_sysfs_write[copylen] = '\0';
> +	last_sysfs_write_len = count;
> +
>  	rc = ops->store(kobj, attr_sd->s_attr.attr, buffer->page, count);
>  
>  	sysfs_put_active(attr_sd);
> @@ -363,6 +379,9 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
>  	if (file->f_mode & FMODE_WRITE) {
>  		if (!(inode->i_mode & S_IWUGO) || !ops->store)
>  			goto err_out;
> +		last_sysfs_write_len = 0;
> +	} else {
> +		last_sysfs_write_len = -1; /* magic value */

"magic" values are bad, please use a #define or something else that
makes more sense to those looking at the code in 5 years.

thanks,

greg k-h
