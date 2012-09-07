Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2IGAql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:46:41 -0400
Received: from ozlabs.org ([203.10.76.45]:46960 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab2IGAqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:46:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] module: add syscall to load module from fd
In-Reply-To: <1346955201-8926-1-git-send-email-keescook@chromium.org>
References: <1346955201-8926-1-git-send-email-keescook@chromium.org>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 07 Sep 2012 09:45:08 +0930
Message-ID: <87ipbqhenn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> Instead of (or in addition to) kernel module signing, being able to reason
> about the origin of a kernel module would be valuable in situations
> where an OS already trusts a specific file system, file, etc, due to
> things like security labels or an existing root of trust to a partition
> through things like dm-verity.
>
> This introduces a new syscall (currently only on x86), similar to
> init_module, that has only two arguments. The first argument is used as
> a file descriptor to the module and the second argument is a pointer to
> the NULL terminated string of module arguments.

Thanks.  Minor comments follow:

> +350	i386	init_module_from_fd	sys_init_module_from_fd

The from_ seems redundant.

> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 19439c7..5386629 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -860,4 +860,5 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
>  
>  asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
>  			 unsigned long idx1, unsigned long idx2);
> +asmlinkage long sys_init_module_from_fd(int len, const char __user *uargs);
>  #endif

You mean, "int fd"?

> diff --git a/kernel/module.c b/kernel/module.c
> index 4edbd9c..b080cf8 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
...
> +/* Sets info->hdr and info->len. */
> +int copy_module_from_fd(int fd, struct load_info *info)
> +{
> +	struct file *file;
> +	int err;
> +	struct kstat stat;
> +	unsigned long size;
> +	off_t pos;
> +	ssize_t bytes = 0;
> +
> +	file = fget(fd);
> +	if (!file)
> +		return -ENOEXEC;
> +
> +	err = vfs_getattr(file->f_vfsmnt, file->f_dentry, &stat);
> +	if (err)
> +		goto out;
> +
> +	if (stat.size > INT_MAX) {
> +		err = -ENOMEM;
> +		goto out;
>  	}
> +	size = stat.size;
>  
> -	if (hdr->e_shoff >= len ||
> -	    hdr->e_shnum * sizeof(Elf_Shdr) > len - hdr->e_shoff) {
> -		err = -ENOEXEC;
> -		goto free_hdr;
> +	info->hdr = vmalloc(size);
> +	if (!info->hdr) {
> +		err = -ENOMEM;
> +		goto out;

The stat.size > INT_MAX is redundant: vmalloc is quite careful on its
checking of the size param.

(We removed a similar test from the module.c code a few years ago).

Cheers,
Rusty.
