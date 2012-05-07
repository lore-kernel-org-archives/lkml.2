Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab2EGEfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 00:35:23 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47463 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2EGEem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 00:34:42 -0400
Date: Sun, 6 May 2012 21:34:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 03/18] fork: Move thread info gfp flags to header
Message-ID: <20120507043401.GA5406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120505150007.543515803@linutronix.de>
 <20120505150141.428211694@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120505150141.428211694@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050704-6148-0000-0000-0000059E5F7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 03:05:41PM -0000, Thomas Gleixner wrote:
> These flags can be useful for extra allocations outside of the core
> code.
> 
> Add __GFP_NOTRACE to them, so the archs which have kmemcheck do
> not have to provide extra allocators just for that reason.

This breaks powerpc builds due to __GFP_NOTRACE not being defined.
I restarted the test after removing the __GFP_NOTRACE as a testing-only
hack, and will let you know how it goes.  Also looking into why this
builds on 32-bit x86 but not on powerpc.

							Thanx, Paul

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/thread_info.h |    6 ++++++
>  kernel/fork.c               |    8 ++------
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> Index: tip/include/linux/thread_info.h
> ===================================================================
> --- tip.orig/include/linux/thread_info.h
> +++ tip/include/linux/thread_info.h
> @@ -54,6 +54,12 @@ extern long do_no_restart_syscall(struct
> 
>  #ifdef __KERNEL__
> 
> +#ifdef CONFIG_DEBUG_STACK_USAGE
> +# define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACE | __GFP_ZERO)
> +#else
> +# define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACE)
> +#endif
> +
>  /*
>   * flag set/clear/test wrappers
>   * - pass TIF_xxxx constants to these functions
> Index: tip/kernel/fork.c
> ===================================================================
> --- tip.orig/kernel/fork.c
> +++ tip/kernel/fork.c
> @@ -135,12 +135,8 @@ void __weak arch_release_thread_info(str
>  static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
>  						  int node)
>  {
> -#ifdef CONFIG_DEBUG_STACK_USAGE
> -	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
> -#else
> -	gfp_t mask = GFP_KERNEL;
> -#endif
> -	struct page *page = alloc_pages_node(node, mask, THREAD_SIZE_ORDER);
> +	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
> +					     THREAD_SIZE_ORDER);
> 
>  	return page ? page_address(page) : NULL;
>  }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

