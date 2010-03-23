Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0CWVrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 17:47:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab0CWVry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 17:47:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC 01/15] FS: libfs, implement simple_write_to_buffer
Date: Tue, 23 Mar 2010 22:51:01 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: jirislaby@gmail.com, pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003232251.01273.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010, Jiri Slaby wrote:
> It will be used in suspend code and serves as an easy wrap around
> copy_from_user. Similar to simple_read_from_buffer, it takes care
> of transfers with proper lengths depending on available and count
> parameters and advances ppos appropriately.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nigel Cunningham <ncunningham@crca.org.au>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org

Thanks for doing this job, I really appreciate it.

I'll do my best to review the patches in detail later today or tomorrow.

Best,
Rafael


> ---
>  fs/libfs.c         |   35 +++++++++++++++++++++++++++++++++++
>  include/linux/fs.h |    2 ++
>  2 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 9e50bcf..fda73b3 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -546,6 +546,40 @@ ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
>  }
>  
>  /**
> + * simple_write_to_buffer - copy data from user space to the buffer
> + * @to: the buffer to write to
> + * @available: the size of the buffer
> + * @ppos: the current position in the buffer
> + * @from: the user space buffer to read from
> + * @count: the maximum number of bytes to read
> + *
> + * The simple_write_to_buffer() function reads up to @count bytes from the user
> + * space address starting at @from into the buffer @to at offset @ppos.
> + *
> + * On success, the number of bytes written is returned and the offset @ppos is
> + * advanced by this number, or negative value is returned on error.
> + **/
> +ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
> +		const void __user *from, size_t count)
> +{
> +	loff_t pos = *ppos;
> +	size_t ret;
> +
> +	if (pos < 0)
> +		return -EINVAL;
> +	if (pos >= available || !count)
> +		return 0;
> +	if (count > available - pos)
> +		count = available - pos;
> +	ret = copy_from_user(to + pos, from, count);
> +	if (ret == count)
> +		return -EFAULT;
> +	count -= ret;
> +	*ppos = pos + count;
> +	return count;
> +}
> +
> +/**
>   * memory_read_from_buffer - copy data from the buffer
>   * @to: the kernel space buffer to read to
>   * @count: the maximum number of bytes to read
> @@ -863,6 +897,7 @@ EXPORT_SYMBOL(simple_statfs);
>  EXPORT_SYMBOL(simple_sync_file);
>  EXPORT_SYMBOL(simple_unlink);
>  EXPORT_SYMBOL(simple_read_from_buffer);
> +EXPORT_SYMBOL(simple_write_to_buffer);
>  EXPORT_SYMBOL(memory_read_from_buffer);
>  EXPORT_SYMBOL(simple_transaction_set);
>  EXPORT_SYMBOL(simple_transaction_get);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a4636b6..0f751b6 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2370,6 +2370,8 @@ extern void simple_release_fs(struct vfsmount **mount, int *count);
>  
>  extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
>  			loff_t *ppos, const void *from, size_t available);
> +extern ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
> +		const void __user *from, size_t count);
>  
>  extern int simple_fsync(struct file *, struct dentry *, int);
>  
> 

