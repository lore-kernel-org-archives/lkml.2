Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2IUMow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:44:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35138 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab2IUMov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:44:51 -0400
Message-ID: <1348231376.2278.40.camel@falcor.watson.ibm.com>
Subject: Re: [PATCH 2/4] security: introduce kernel_module_from_file hook
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Date: Fri, 21 Sep 2012 08:42:56 -0400
In-Reply-To: <1348179300-11653-2-git-send-email-keescook@chromium.org>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
	 <1348179300-11653-2-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092112-2398-0000-0000-00000B3AFD81
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00176025; UDB=6.00039858; UTC=2012-09-21
 12:44:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 15:14 -0700, Kees Cook wrote:
> Now that kernel module origins can be reasoned about, provide a hook to
> the LSMs to make policy decisions about the module file. This will let
> Chrome OS enforce that loadable kernel modules can only come from its
> read-only hash-verified root filesystem. Other LSMs can, for example,
> read extended attributes for signatures, etc.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> Acked-by: Eric Paris <eparis@redhat.com>

Thanks, please include my
Acked-by: Mimi Zohar <zohar@us.ibm.com>

> ---
>  include/linux/security.h |   13 +++++++++++++
>  kernel/module.c          |    9 +++++++++
>  security/capability.c    |    6 ++++++
>  security/security.c      |    5 +++++
>  4 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 3dea6a9..368e539 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -693,6 +693,12 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	userspace to load a kernel module with the given name.
>   *	@kmod_name name of the module requested by the kernel
>   *	Return 0 if successful.
> + * @kernel_module_from_file:
> + *	Load a kernel module from userspace.
> + *	@file contains the file structure pointing to the file containing
> + *	the kernel module to load. If the module is being loaded from a blob,
> + *	this argument will be NULL.
> + *	Return 0 if permission is granted.
>   * @task_fix_setuid:
>   *	Update the module's state after setting one or more of the user
>   *	identity attributes of the current process.  The @flags parameter
> @@ -1507,6 +1513,7 @@ struct security_operations {
>  	int (*kernel_act_as)(struct cred *new, u32 secid);
>  	int (*kernel_create_files_as)(struct cred *new, struct inode *inode);
>  	int (*kernel_module_request)(char *kmod_name);
> +	int (*kernel_module_from_file)(struct file *file);
>  	int (*task_fix_setuid) (struct cred *new, const struct cred *old,
>  				int flags);
>  	int (*task_setpgid) (struct task_struct *p, pid_t pgid);
> @@ -1764,6 +1771,7 @@ void security_transfer_creds(struct cred *new, const struct cred *old);
>  int security_kernel_act_as(struct cred *new, u32 secid);
>  int security_kernel_create_files_as(struct cred *new, struct inode *inode);
>  int security_kernel_module_request(char *kmod_name);
> +int security_kernel_module_from_file(struct file *file);
>  int security_task_fix_setuid(struct cred *new, const struct cred *old,
>  			     int flags);
>  int security_task_setpgid(struct task_struct *p, pid_t pgid);
> @@ -2277,6 +2285,11 @@ static inline int security_kernel_module_request(char *kmod_name)
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
> index afe2f69..511b8e9 100644
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
> @@ -2430,6 +2431,10 @@ static int copy_module_from_user(const void __user *umod, unsigned long len,
>  	if (info->len < sizeof(*(info->hdr)))
>  		return -ENOEXEC;
> 
> +	err = security_kernel_module_from_file(NULL);
> +	if (err)
> +		return err;
> +
>  	/* Suck in entire file: we'll want most of it. */
>  	info->hdr = vmalloc(info->len);
>  	if (!info->hdr)
> @@ -2464,6 +2469,10 @@ static int copy_module_from_fd(int fd, struct load_info *info)
>  	if (!file)
>  		return -ENOEXEC;
> 
> +	err = security_kernel_module_from_file(file);
> +	if (err)
> +		goto out;
> +
>  	err = vfs_getattr(file->f_vfsmnt, file->f_dentry, &stat);
>  	if (err)
>  		goto out;
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


