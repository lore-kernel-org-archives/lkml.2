Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab2IEPsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:48:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38771 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2IEPsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:48:01 -0400
Date: Wed, 5 Sep 2012 10:47:53 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] security: allow Yama to be unconditionally stacked
Message-ID: <20120905154753.GE14225@amd1>
References: <20120904203213.GA3617@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904203213.GA3617@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> Unconditionally call Yama when CONFIG_SECURITY_YAMA_STACKED is selected,
> no matter what LSM module is primary.
> 
> Ubuntu and Chrome OS already carry patches to do this, and Fedora
> has voiced interest in doing this as well. Instead of having multiple
> distributions (or LSM authors) carrying these patches, just allow Yama
> to be called unconditionally when selected by the new CONFIG.

I don't really like having both the STACKED and non-stacked paths. But
I don't have a good alternative.

> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>

> ---
>  include/linux/security.h |   31 +++++++++++++++++++++++++++++++
>  security/security.c      |   21 +++++++++++++++++++++
>  security/yama/Kconfig    |    8 ++++++++
>  security/yama/yama_lsm.c |   14 ++++++++++----
>  4 files changed, 70 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 3dea6a9..01ef030 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -3021,5 +3021,36 @@ static inline void free_secdata(void *secdata)
>  { }
>  #endif /* CONFIG_SECURITY */
>  
> +#ifdef CONFIG_SECURITY_YAMA
> +extern int yama_ptrace_access_check(struct task_struct *child,
> +				    unsigned int mode);
> +extern int yama_ptrace_traceme(struct task_struct *parent);
> +extern void yama_task_free(struct task_struct *task);
> +extern int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
> +			   unsigned long arg4, unsigned long arg5);
> +#else
> +static inline int yama_ptrace_access_check(struct task_struct *child,
> +					   unsigned int mode)
> +{
> +	return 0;
> +}
> +
> +static inline int yama_ptrace_traceme(struct task_struct *parent)
> +{
> +	return 0;
> +}
> +
> +static inline void yama_task_free(struct task_struct *task)
> +{
> +}
> +
> +static inline int yama_task_prctl(int option, unsigned long arg2,
> +				  unsigned long arg3, unsigned long arg4,
> +				  unsigned long arg5)
> +{
> +	return -ENOSYS;
> +}
> +#endif /* CONFIG_SECURITY_YAMA */
> +
>  #endif /* ! __LINUX_SECURITY_H */
>  
> diff --git a/security/security.c b/security/security.c
> index 860aeb3..68c1b9b 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -136,11 +136,23 @@ int __init register_security(struct security_operations *ops)
>  
>  int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
>  {
> +#ifdef CONFIG_SECURITY_YAMA_STACKED
> +	int rc;
> +	rc = yama_ptrace_access_check(child, mode);
> +	if (rc)
> +		return rc;
> +#endif
>  	return security_ops->ptrace_access_check(child, mode);
>  }
>  
>  int security_ptrace_traceme(struct task_struct *parent)
>  {
> +#ifdef CONFIG_SECURITY_YAMA_STACKED
> +	int rc;
> +	rc = yama_ptrace_traceme(parent);
> +	if (rc)
> +		return rc;
> +#endif
>  	return security_ops->ptrace_traceme(parent);
>  }
>  
> @@ -761,6 +773,9 @@ int security_task_create(unsigned long clone_flags)
>  
>  void security_task_free(struct task_struct *task)
>  {
> +#ifdef CONFIG_SECURITY_YAMA_STACKED
> +	yama_task_free(task);
> +#endif
>  	security_ops->task_free(task);
>  }
>  
> @@ -876,6 +891,12 @@ int security_task_wait(struct task_struct *p)
>  int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  			 unsigned long arg4, unsigned long arg5)
>  {
> +#ifdef CONFIG_SECURITY_YAMA_STACKED
> +	int rc;
> +	rc = yama_task_prctl(option, arg2, arg3, arg4, arg5);
> +	if (rc != -ENOSYS)
> +		return rc;
> +#endif
>  	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
>  }
>  
> diff --git a/security/yama/Kconfig b/security/yama/Kconfig
> index 51d6709..20ef514 100644
> --- a/security/yama/Kconfig
> +++ b/security/yama/Kconfig
> @@ -11,3 +11,11 @@ config SECURITY_YAMA
>  	  Further information can be found in Documentation/security/Yama.txt.
>  
>  	  If you are unsure how to answer this question, answer N.
> +
> +config SECURITY_YAMA_STACKED
> +	bool "Yama stacked with other LSMs"
> +	depends on SECURITY_YAMA
> +	default n
> +	help
> +	  When Yama is built into the kernel, force it to stack with the
> +	  selected primary LSM.
> diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
> index dcd6178..b4c2984 100644
> --- a/security/yama/yama_lsm.c
> +++ b/security/yama/yama_lsm.c
> @@ -100,7 +100,7 @@ static void yama_ptracer_del(struct task_struct *tracer,
>   * yama_task_free - check for task_pid to remove from exception list
>   * @task: task being removed
>   */
> -static void yama_task_free(struct task_struct *task)
> +void yama_task_free(struct task_struct *task)
>  {
>  	yama_ptracer_del(task, task);
>  }
> @@ -116,7 +116,7 @@ static void yama_task_free(struct task_struct *task)
>   * Return 0 on success, -ve on error.  -ENOSYS is returned when Yama
>   * does not handle the given option.
>   */
> -static int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
> +int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  			   unsigned long arg4, unsigned long arg5)
>  {
>  	int rc;
> @@ -243,7 +243,7 @@ static int ptracer_exception_found(struct task_struct *tracer,
>   *
>   * Returns 0 if following the ptrace is allowed, -ve on error.
>   */
> -static int yama_ptrace_access_check(struct task_struct *child,
> +int yama_ptrace_access_check(struct task_struct *child,
>  				    unsigned int mode)
>  {
>  	int rc;
> @@ -293,7 +293,7 @@ static int yama_ptrace_access_check(struct task_struct *child,
>   *
>   * Returns 0 if following the ptrace is allowed, -ve on error.
>   */
> -static int yama_ptrace_traceme(struct task_struct *parent)
> +int yama_ptrace_traceme(struct task_struct *parent)
>  {
>  	int rc;
>  
> @@ -324,6 +324,7 @@ static int yama_ptrace_traceme(struct task_struct *parent)
>  	return rc;
>  }
>  
> +#ifndef CONFIG_SECURITY_YAMA_STACKED
>  static struct security_operations yama_ops = {
>  	.name =			"yama",
>  
> @@ -332,6 +333,7 @@ static struct security_operations yama_ops = {
>  	.task_prctl =		yama_task_prctl,
>  	.task_free =		yama_task_free,
>  };
> +#endif
>  
>  #ifdef CONFIG_SYSCTL
>  static int yama_dointvec_minmax(struct ctl_table *table, int write,
> @@ -378,13 +380,17 @@ static struct ctl_table yama_sysctl_table[] = {
>  
>  static __init int yama_init(void)
>  {
> +#ifndef CONFIG_SECURITY_YAMA_STACKED
>  	if (!security_module_enable(&yama_ops))
>  		return 0;
> +#endif
>  
>  	printk(KERN_INFO "Yama: becoming mindful.\n");
>  
> +#ifndef CONFIG_SECURITY_YAMA_STACKED
>  	if (register_security(&yama_ops))
>  		panic("Yama: kernel registration failed.\n");
> +#endif
>  
>  #ifdef CONFIG_SYSCTL
>  	if (!register_sysctl_paths(yama_sysctl_path, yama_sysctl_table))
> -- 
> 1.7.0.4
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
