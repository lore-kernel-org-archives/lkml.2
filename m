Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab2GDHhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:37:38 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:32955 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab2GDHhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:37:36 -0400
Message-ID: <4FF3F2B6.5040909@parallels.com>
Date: Wed, 04 Jul 2012 11:37:26 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [rfc 2/7] procfs: Convert /proc/pid/fdinfo/ handling routines
 to seq-file
References: <20120627110116.201735815@openvz.org> <20120627110512.485189390@openvz.org>
In-Reply-To: <20120627110512.485189390@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -130,7 +159,31 @@ static const struct dentry_operations ti
>  
>  static int proc_fd_link(struct dentry *dentry, struct path *path)
>  {
> -	return proc_fd_info(dentry->d_inode, path, NULL);
> +       struct inode *inode = dentry->d_inode;
> +       struct task_struct *task = get_proc_task(inode);
> +       struct files_struct *files = NULL;
> +       int fd = proc_fd(inode);
> +       struct file *file;
> +       int err = -ENOENT;
> +
> +       if (task) {
> +	       files = get_files_struct(task);
> +	       put_task_struct(task);
> +       }
> +
> +       if (files) {
> +	       spin_lock(&files->file_lock);
> +	       file = fcheck_files(files, fd);
> +	       if (file) {
> +		       *path = file->f_path;
> +		       path_get(&file->f_path);
> +	       }
> +	       spin_unlock(&files->file_lock);
> +	       put_files_struct(files);
> +	       err = 0;
> +       }
> +
> +       return err;
>  }
>  
>  static struct dentry *
> @@ -245,22 +298,6 @@ out_no_task:
>  	return retval;
>  }
>  
> -static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
> -				size_t len, loff_t *ppos)
> -{
> -	char tmp[PROC_FDINFO_MAX];
> -	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, tmp);
> -	if (!err)
> -		err = simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
> -	return err;
> -}
> -

I believe we can still have the proc_fdinfo_read and proc_fd_link code non-splitted.
Just push a callback pointer ino the proc_fd_info (as usual -- we an opaque void *argument).

Thanks,
Pavel

