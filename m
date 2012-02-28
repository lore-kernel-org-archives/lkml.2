Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030394Ab2B1UnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:43:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965001Ab2B1UnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:43:20 -0500
Date: Tue, 28 Feb 2012 12:43:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Rusty Russell <rusty.russell@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [RFC PATCH] module: debugging check for runaway kthreads
Message-Id: <20120228124318.6ed21b02.akpm@linux-foundation.org>
In-Reply-To: <1330419863-3508-1-git-send-email-dmitry.antipov@linaro.org>
References: <1330419863-3508-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 13:04:23 +0400
Dmitry Antipov <dmitry.antipov@linaro.org> wrote:

> Debugging option CONFIG_MODULE_KTHREAD_CHECK provides a way to check
> whether all kernel threads created by the module and have used module
> code as a thread worker function are really exited when the module is
> unloaded. The following pseudo-code contains example of an error which
> is likely to be catched with this debugging check:
> 
> static struct task_struct *tsk;
> static DECLARE_COMPLETION(done);
> 
> static void *func(void *unused)
> {
>         while (!kthread_should_stop())
>               real_work();
>         complete(&done);
> }
> 
> static int __init modinit(void)
> {
>         tsk = kthread_run(func, NULL, "func");
>         return IS_ERR(tsk) ? PTR_ERR(tsk) : 0;
> }
> 
> static void __exit modexit(void)
> {
>         wait_for_completion(&done);
> }

Might be a little bit useful.  But I don't recall us having this bug in
quite a long time.

> index 0714b24..33897c3 100644
> --- a/include/linux/kthread.h
> +++ b/include/linux/kthread.h
> @@ -13,6 +13,11 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
>  #define kthread_create(threadfn, data, namefmt, arg...) \
>  	kthread_create_on_node(threadfn, data, -1, namefmt, ##arg)
>  
> +#ifdef CONFIG_MODULE_KTHREAD_CHECK
> +unsigned long get_kthread_func(struct task_struct *tsk);
> +#else
> +#define get_kthread_func(tsk, addr, mod) (0)
> +#endif

This won't compile if CONFIG_MODULE_KTHREAD_CHECK=n.

Please make the stub function a proper C function, not a macro.  It
provides type checking, can prevent compile warnings and is generally
easier on the eyes.

> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1397,6 +1397,15 @@ config MODULE_FORCE_UNLOAD
>  	  rmmod).  This is mainly for kernel developers and desperate users.
>  	  If unsure, say N.
>  
> +config MODULE_KTHREAD_CHECK
> +	bool "Check for runaway kernel threads at module unload"
> +	depends on MODULE_UNLOAD && EXPERIMENTAL && DEBUG_KERNEL
> +	help
> +	  This option allows you to check whether all kernel threads created
> +	  by the module and have used module code as a thread worker function
> +	  are really exited when the module is unloaded. This is mainly for
> +	  module developers. If insure, say N.

I think this should be under the kernel hacking menu, dependent on
CONFIG_DEBUG_KERNEL, in lib/Kconfig.debug.

>  config MODVERSIONS
>  	bool "Module versioning support"
>  	help
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 3d3de63..5c53817 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -38,6 +38,9 @@ struct kthread_create_info
>  
>  struct kthread {
>  	int should_stop;
> +#ifdef CONFIG_MODULE_KTHREAD_CHECK
> +	void *fn;
> +#endif

A little comment describing what this field is for would be nice.

>  	void *data;
>  	struct completion exited;
>  };
> @@ -45,6 +48,24 @@ struct kthread {
>  #define to_kthread(tsk)	\
>  	container_of((tsk)->vfork_done, struct kthread, exited)
>  
> +#ifdef CONFIG_MODULE_KTHREAD_CHECK
> +
> +unsigned long get_kthread_func(struct task_struct *tsk)
> +{
> +	struct kthread *kt;
> +	unsigned long addr;
> +
> +	get_task_struct(tsk);
> +	BUG_ON(!(tsk->flags & PF_KTHREAD));
> +	kt = to_kthread(tsk);
> +	barrier();
> +	addr = tsk->vfork_done ? (unsigned long)kt->fn : 0UL;
> +	put_task_struct(tsk);
> +	return addr;
> +}

gack, I hadn't noticed the kthread ab^wre^wuse of vfork_done before. 
Kooky.  Undocumented, too.

> +#endif /* CONFIG_MODULE_KTHREAD_CHECK */
> +
>  /**
>   * kthread_should_stop - should this kthread return now?
>   *
> @@ -106,6 +127,9 @@ static int kthread(void *_create)
>  	int ret;
>  
>  	self.should_stop = 0;
> +#ifdef CONFIG_MODULE_KTHREAD_CHECK
> +	self.fn = threadfn;
> +#endif
>  	self.data = data;
>  	init_completion(&self.exited);
>  	current->vfork_done = &self.exited;
> diff --git a/kernel/module.c b/kernel/module.c
> index 2c93276..fe6637b 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -45,6 +45,7 @@
>  #include <linux/string.h>
>  #include <linux/mutex.h>
>  #include <linux/rculist.h>
> +#include <linux/kthread.h>
>  #include <asm/uaccess.h>
>  #include <asm/cacheflush.h>
>  #include <asm/mmu_context.h>
> @@ -764,6 +765,49 @@ static void wait_for_zero_refcount(struct module *mod)
>  	mutex_lock(&module_mutex);
>  }
>  
> +#ifdef CONFIG_KALLSYMS
> +static const char *get_ksymbol(struct module *mod, unsigned long addr,
> +			       unsigned long *size, unsigned long *offset);
> +#else
> +#define get_ksymbol(mod, addr, size, offset) NULL
> +#endif

Can this code block be moved to after the get_ksymbol() definition so
the forward declaration is unneeded?

Did we really need to use the internal get_ksymbol(), rather than an
official kallsyms interface function?

The CONFIG_KALLSYMS=n stub should be written in C.  Make it return
"<unknown>" and the ?: in check_kthreads() can be done away with.

> +#ifdef CONFIG_MODULE_KTHREAD_CHECK
> +
> +static void check_kthreads(struct module *mod)
> +{
> +	unsigned long flags;
> +	struct task_struct *g, *p;
> +
> +	read_lock_irqsave(&tasklist_lock, flags);
> +	do_each_thread(g, p) {
> +		const char *name;
> +		unsigned long addr, offset, size;
> +
> +		/* Note kthreadd is special. Other kthreads should
> +		   have their 'struct kthread' on the stack until
> +		   do_exit() calls schedule() for the last time. */
> +		if (p->mm || p == kthreadd_task)
> +			continue;
> +
> +		addr = get_kthread_func(p);
> +		if (__module_text_address(addr) == mod) {
> +			name = get_ksymbol(mod, addr, &size, &offset);
> +			printk(KERN_WARNING "kthread %p[%s:%d] running "
> +			       "0x%lx(%s) is still alive, fix module %s, "
> +			       "crash possible\n", p, p->comm, p->pid, addr,
> +			       (name ? name : "<unknown>"), mod->name);
> +		}
> +	} while_each_thread(g, p);
> +	read_unlock_irqrestore(&tasklist_lock, flags);
> +}
> +
> +#else
> +
> +#define check_kthreads(mod) do { } while (0)

In C, please.

> +#endif /* CONFIG_MODULE_KTHREAD_CHECK */
> +
>  SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  		unsigned int, flags)
>  {
> @@ -831,6 +875,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  	blocking_notifier_call_chain(&module_notify_list,
>  				     MODULE_STATE_GOING, mod);
>  	async_synchronize_full();
> +	check_kthreads(mod);
>  
>  	/* Store the name of the last unloaded module for diagnostic purposes */
>  	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));

