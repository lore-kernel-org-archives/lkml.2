Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2HaN6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:58:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab2HaN6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:58:34 -0400
Date: Fri, 31 Aug 2012 08:58:25 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] module: allow loading module from fd
Message-ID: <20120831135825.GB24262@amd1>
References: <1346275747-8936-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346275747-8936-1-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> Instead of (or in addition to) kernel module signing, being able to reason
> about the origin of a kernel module would be valuable in situations
> where an OS already trusts a specific file system, file, etc, due to
> things like security labels or an existing root of trust to a partition
> through things like dm-verity.
> 
> This changes the init_module syscall so that when the first argument
> (blob address) is NULL, the second argument is used as a file descriptor
> to the module (instead of length). The third argument (module arguments)
> remains unchanged.
> 
> Some alternatives to overloading the existing syscall are:
>  - write a new syscall (seemed unnecessary)
>  - add an fd ioctl (awful)
>  - enhance the ELF binfmt loader (complex)
> 
> It seemed most sensible to avoid introducing new or crazy interfaces
> or further complicating the ELF loader. Instead, just use the existing
> syscall in a new way. Tools using the fd argument style can trivially
> downgrade to the blob argument style when they see an EFAULT error.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/module.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 87 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 4edbd9c..0be8c11 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -21,6 +21,7 @@
>  #include <linux/ftrace_event.h>
>  #include <linux/init.h>
>  #include <linux/kallsyms.h>
> +#include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/sysfs.h>
>  #include <linux/kernel.h>
> @@ -2399,23 +2400,99 @@ static inline void kmemleak_load_module(const struct module *mod,
>  }
>  #endif
>  
> -/* Sets info->hdr and info->len. */
> -static int copy_and_check(struct load_info *info,
> -			  const void __user *umod, unsigned long len,
> -			  const char __user *uargs)
> +static Elf_Ehdr *copy_module_from_user(const void __user *umod,
> +				       unsigned long len)
>  {
> -	int err;
>  	Elf_Ehdr *hdr;
>  
>  	if (len < sizeof(*hdr))
> -		return -ENOEXEC;
> +		return ERR_PTR(-ENOEXEC);
>  
>  	/* Suck in entire file: we'll want most of it. */
> -	if ((hdr = vmalloc(len)) == NULL)
> -		return -ENOMEM;
> +	hdr = vmalloc(len);
> +	if (!hdr)
> +		return ERR_PTR(-ENOMEM);
>  
>  	if (copy_from_user(hdr, umod, len) != 0) {
> -		err = -EFAULT;
> +		vfree(hdr);
> +		return ERR_PTR(-EFAULT);
> +	}
> +
> +	return hdr;
> +}
> +
> +static Elf_Ehdr *copy_module_from_fd(unsigned int fd, unsigned long *len)
> +{
> +	struct file *file;
> +	int err;
> +	Elf_Ehdr *hdr;
> +	struct kstat stat;
> +	unsigned long size;
> +	off_t pos;
> +	ssize_t bytes = 0;
> +
> +	file = fget(fd);
> +	if (!file)
> +		return ERR_PTR(-ENOEXEC);
> +
> +	err = vfs_getattr(file->f_vfsmnt, file->f_dentry, &stat);
> +	if (err) {
> +		hdr = ERR_PTR(err);
> +		goto out;
> +	}
> +
> +	if (stat.size > INT_MAX) {
> +		hdr = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +	size = stat.size;
> +
> +	hdr = vmalloc(size);
> +	if (!hdr) {
> +		hdr = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +
> +	pos = 0;
> +	while (pos < size) {
> +		bytes = kernel_read(file, pos, (char *)hdr + pos, size - pos);
> +		if (bytes < 0) {
> +			vfree(hdr);
> +			hdr = ERR_PTR(bytes);
> +			goto out;
> +		}
> +		if (bytes == 0)
> +			break;
> +		pos += bytes;
> +	}
> +	*len = pos;
> +
> +out:
> +	fput(file);
> +	return hdr;
> +}
> +
> +/* Sets info->hdr and info->len. */
> +static int copy_and_check(struct load_info *info,
> +			  const void __user *umod, unsigned long len)
> +{
> +	int err;
> +	Elf_Ehdr *hdr;
> +
> +	if (umod == NULL) {
> +		unsigned int fd;
> +
> +		if (len < 0 || len > INT_MAX)
> +			return -ENOEXEC;
> +		fd = len;
> +
> +		hdr = copy_module_from_fd(fd, &len);
> +	} else
> +		hdr = copy_module_from_user(umod, len);
> +	if (IS_ERR(hdr))
> +		return PTR_ERR(hdr);
> +	if (len < sizeof(*hdr)) {
> +		err = -ENOEXEC;
>  		goto free_hdr;
>  	}
>  
> @@ -2875,7 +2952,7 @@ static struct module *load_module(void __user *umod,
>  	       umod, len, uargs);
>  
>  	/* Copy in the blobs from userspace, check they are vaguely sane. */
> -	err = copy_and_check(&info, umod, len, uargs);
> +	err = copy_and_check(&info, umod, len);
>  	if (err)
>  		return ERR_PTR(err);
>  
> -- 
> 1.7.0.4
> 
