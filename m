Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2HaODw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:03:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46569 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab2HaODt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:03:49 -0400
Date: Fri, 31 Aug 2012 09:03:43 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/2] security: introduce kernel_module_from_file hook
Message-ID: <20120831140343.GC24262@amd1>
References: <1346275747-8936-1-git-send-email-keescook@chromium.org>
 <1346275747-8936-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346275747-8936-2-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> Now that kernel module origins can be reasoned about, provide a hook to
> the LSMs to make policy decisions about the module file.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>

> ---
>  include/linux/security.h |   11 +++++++++++
>  kernel/module.c          |    7 +++++++
>  security/capability.c    |    6 ++++++
>  security/security.c      |    5 +++++
>  4 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 3dea6a9..634d09a 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -693,6 +693,10 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	userspace to load a kernel module with the given name.
>   *	@kmod_name name of the module requested by the kernel
>   *	Return 0 if successful.
> + * @kernel_module_from_file:
> + *	Load a new kernel module from a file.
> + *	@file contains the file structure being loaded as a kernel module.
> + *	Return 0 if permission is granted.
>   * @task_fix_setuid:
>   *	Update the module's state after setting one or more of the user
>   *	identity attributes of the current process.  The @flags parameter
> @@ -1507,6 +1511,7 @@ struct security_operations {
>  	int (*kernel_act_as)(struct cred *new, u32 secid);
>  	int (*kernel_create_files_as)(struct cred *new, struct inode *inode);
>  	int (*kernel_module_request)(char *kmod_name);
> +	int (*kernel_module_from_file)(struct file *file);
>  	int (*task_fix_setuid) (struct cred *new, const struct cred *old,
>  				int flags);
>  	int (*task_setpgid) (struct task_struct *p, pid_t pgid);
> @@ -1764,6 +1769,7 @@ void security_transfer_creds(struct cred *new, const struct cred *old);
>  int security_kernel_act_as(struct cred *new, u32 secid);
>  int security_kernel_create_files_as(struct cred *new, struct inode *inode);
>  int security_kernel_module_request(char *kmod_name);
> +int security_kernel_module_from_file(struct file *file);
>  int security_task_fix_setuid(struct cred *new, const struct cred *old,
>  			     int flags);
>  int security_task_setpgid(struct task_struct *p, pid_t pgid);
> @@ -2277,6 +2283,11 @@ static inline int security_kernel_module_request(char *kmod_name)
>  	return 0;
>  }
>  
> +static inline int security_kernel_module_from_file(struct file *file)
> +{
> +	return 0;
> +}
> +
>  static inline int security_task_fix_setuid(struct cred *new,
>  					   const struct cred *old,
>  					   int flags)
> diff --git a/kernel/module.c b/kernel/module.c
> index 0be8c11..1fcc63f 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -29,6 +29,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/elf.h>
>  #include <linux/proc_fs.h>
> +#include <linux/security.h>
>  #include <linux/seq_file.h>
>  #include <linux/syscalls.h>
>  #include <linux/fcntl.h>
> @@ -2447,6 +2448,12 @@ static Elf_Ehdr *copy_module_from_fd(unsigned int fd, unsigned long *len)
>  	}
>  	size = stat.size;
>  
> +	err = security_kernel_module_from_file(file);
> +	if (err) {
> +		hdr = ERR_PTR(err);
> +		goto out;
> +	}
> +
>  	hdr = vmalloc(size);
>  	if (!hdr) {
>  		hdr = ERR_PTR(-ENOMEM);
> diff --git a/security/capability.c b/security/capability.c
> index 61095df..8acb304 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -395,6 +395,11 @@ static int cap_kernel_module_request(char *kmod_name)
>  	return 0;
>  }
>  
> +static int cap_kernel_module_from_file(struct file *file)
> +{
> +	return 0;
> +}
> +
>  static int cap_task_setpgid(struct task_struct *p, pid_t pgid)
>  {
>  	return 0;
> @@ -967,6 +972,7 @@ void __init security_fixup_ops(struct security_operations *ops)
>  	set_to_cap_if_null(ops, kernel_act_as);
>  	set_to_cap_if_null(ops, kernel_create_files_as);
>  	set_to_cap_if_null(ops, kernel_module_request);
> +	set_to_cap_if_null(ops, kernel_module_from_file);
>  	set_to_cap_if_null(ops, task_fix_setuid);
>  	set_to_cap_if_null(ops, task_setpgid);
>  	set_to_cap_if_null(ops, task_getpgid);
> diff --git a/security/security.c b/security/security.c
> index 860aeb3..f7f8695 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -799,6 +799,11 @@ int security_kernel_module_request(char *kmod_name)
>  	return security_ops->kernel_module_request(kmod_name);
>  }
>  
> +int security_kernel_module_from_file(struct file *file)
> +{
> +	return security_ops->kernel_module_from_file(file);
> +}
> +
>  int security_task_fix_setuid(struct cred *new, const struct cred *old,
>  			     int flags)
>  {
> -- 
> 1.7.0.4
> 
