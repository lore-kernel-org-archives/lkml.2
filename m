Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab2ITU3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 16:29:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2ITU3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 16:29:06 -0400
Date: Thu, 20 Sep 2012 13:29:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/2] security: introduce kernel_module_from_file hook
Message-Id: <20120920132903.437434aa.akpm@linux-foundation.org>
In-Reply-To: <1347043094-11120-2-git-send-email-keescook@chromium.org>
References: <1347043094-11120-1-git-send-email-keescook@chromium.org>
	<1347043094-11120-2-git-send-email-keescook@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Sep 2012 11:38:13 -0700
Kees Cook <keescook@chromium.org> wrote:

> Instead of (or in addition to) kernel module signing, being able to reason
> about the origin of a kernel module would be valuable in situations
> where an OS already trusts a specific file system, file, etc, due to
> things like security labels or an existing root of trust to a partition
> through things like dm-verity.

<scratches head>

This is a really sketchy rationale and I would like to see a *lot* more
about the reasoning behind this.  Who will use the feature?  How will
they use it?  What value will they obtain from using it?  This
description should be pitched at kernel literate non-security people
who lack mind-reading powers, please.

We'll need a manpage for this, and I'd suggest that preparing it sooner
rather than later will help with the review of your proposal.

> This introduces a new syscall (currently only on x86), similar to
> init_module, that has only two arguments. The first argument is used as
> a file descriptor to the module and the second argument is a pointer to
> the NULL terminated string of module arguments.
> 
>
> ...
>
> -static int copy_and_check(struct load_info *info,
> -			  const void __user *umod, unsigned long len,
> -			  const char __user *uargs)
> +int copy_module_from_user(const void __user *umod, unsigned long len,
> +			  struct load_info *info)

can be made static, methinks.

`len' should have type size_t?

>  {
>  	int err;
> -	Elf_Ehdr *hdr;
>  
> -	if (len < sizeof(*hdr))
> +	info->len = len;
> +	if (info->len < sizeof(*(info->hdr)))
>  		return -ENOEXEC;
>  
>  	/* Suck in entire file: we'll want most of it. */
> -	if ((hdr = vmalloc(len)) == NULL)
> +	info->hdr = vmalloc(info->len);
> +	if (!info->hdr)
>  		return -ENOMEM;
>  
> -	if (copy_from_user(hdr, umod, len) != 0) {
> -		err = -EFAULT;
> +	err = copy_from_user(info->hdr, umod, info->len);
> +	if (err)
>  		goto free_hdr;
> -	}
>  
> -	/* Sanity checks against insmoding binaries or wrong arch,
> -	   weird elf version */
> -	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
> -	    || hdr->e_type != ET_REL
> -	    || !elf_check_arch(hdr)
> -	    || hdr->e_shentsize != sizeof(Elf_Shdr)) {
> -		err = -ENOEXEC;
> +	err = check_info(info);
> +	if (err)
>  		goto free_hdr;
> +
> +	return err;
> +
> +free_hdr:
> +	vfree(info->hdr);
> +	return err;
> +}
> +
> +/* Sets info->hdr and info->len. */
> +int copy_module_from_fd(int fd, struct load_info *info)

static

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
> +	size = stat.size;

kstat.size had type loff_t.  Here it gets trucated to 32 bits on 32-bit
machines.  Harmless I guess, but sloppy.

> +	info->hdr = vmalloc(size);
> +	if (!info->hdr) {
> +		err = -ENOMEM;
> +		goto out;
>  	}
>  
> -	if (hdr->e_shoff >= len ||
> -	    hdr->e_shnum * sizeof(Elf_Shdr) > len - hdr->e_shoff) {
> -		err = -ENOEXEC;
> -		goto free_hdr;
> +	pos = 0;
> +	while (pos < size) {

`pos' should be loff_t as well.

> +		bytes = kernel_read(file, pos, (char *)(info->hdr) + pos,
> +				    size - pos);
> +		if (bytes < 0) {
> +			vfree(info->hdr);
> +			err = bytes;
> +			goto out;
> +		}
> +		if (bytes == 0)
> +			break;
> +		pos += bytes;
>  	}
> +	info->len = pos;
> -	info->hdr = hdr;
> -	info->len = len;
> -	return 0;
> +	err = check_info(info);
> +	if (err)
> +		vfree(info->hdr);
>  
> -free_hdr:
> -	vfree(hdr);
> +out:
> +	fput(file);
>  	return err;
>  }
>  
> @@ -2861,26 +2916,17 @@ static int post_relocation(struct module *mod, const struct load_info *info)
>  	return module_finalize(info->hdr, info->sechdrs, mod);
>  }
>  
> +static int do_init_module(struct module *mod);

I wonder if do_init_module() could have been moved to avoid the forward
declaration.

>  /* Allocate and load the module: note that size of section 0 is always
>     zero, and we rely on this for optional sections. */
> -static struct module *load_module(void __user *umod,
> -				  unsigned long len,
> -				  const char __user *uargs)
> +static int load_module(struct load_info *info, const char __user *uargs)
>  {
> -	struct load_info info = { NULL, };
>  	struct module *mod;
>  	long err;
>  
>
> ...
>
> @@ -3091,6 +3127,56 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
>  	return 0;
>  }
>  
> +static int init_module_permission(void)

"init_module_permission" -> initialises a module's permission.

IOW, the name is poor.

> +{
> +	/* Must have permission */

The world wouldn't end if this comment was omitted ;)

> +	if (!capable(CAP_SYS_MODULE) || modules_disabled)
> +		return -EPERM;
> +
> +	return 0;
> +}
> +
> +SYSCALL_DEFINE2(init_module_fd, int, fd, const char __user *, uargs)
> +{
> +	int err;
> +	struct load_info info = { };
> +
> +	err = init_module_permission();
> +	if (err)
> +		return err;
> +
> +	pr_debug("init_module_fd: fd=%d, uargs=%p\n", fd, uargs);
> +
> +	if (fd < 0)
> +		return -ENOEXEC;

hm, why?  Surely copy_module_from_fd()'s fget() will fail on a -ve fd?

> +	err = copy_module_from_fd(fd, &info);
> +	if (err)
> +		return err;
> +
> +	return load_module(&info, uargs);
> +}
> +
>
> ...
>

