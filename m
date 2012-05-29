Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2E2RyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:54:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab2E2RyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:54:07 -0400
Date: Tue, 29 May 2012 13:53:53 -0400
From: Don Zickus <dzickus@redhat.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] x86: Avoid intermixing cpu dump_stack output on
 multi-processor systems
Message-ID: <20120529175352.GA31524@redhat.com>
References: <20120524144229.GA27713@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524144229.GA27713@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 09:42:29AM -0500, Russ Anderson wrote:
> When multiple cpus on a multi-processor system call dump_stack()
> at the same time, the backtrace lines get intermixed, making 
> the output worthless.  Add a lock so each cpu stack dump comes
> out as a coherent set.
> 
> For example, when a multi-processor system is NMIed, all of the
> cpus call dump_stack() at the same time, resulting in output for
> all of cpus getting intermixed, making it impossible to tell what
> any individual cpu was doing.  With this patch each cpu prints
> its stack lines as a coherent set, so one can see what each cpu
> was doing.

For this particular test case, it sounds like you are doing what
trigger_all_cpu_backtrace() is doing?  It doesn't solve the general
problem, but probably your particular usage?

Cheers,
Don

> 
> It has been tested on a 4069 cpu system.
> 
> Signed-off-by: Russ Anderson <rja@sgi.com>
> 
> ---
>  arch/x86/kernel/dumpstack.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux/arch/x86/kernel/dumpstack.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/dumpstack.c	2012-05-03 14:31:13.602345805 -0500
> +++ linux/arch/x86/kernel/dumpstack.c	2012-05-03 14:51:43.805197563 -0500
> @@ -186,7 +186,9 @@ void dump_stack(void)
>  {
>  	unsigned long bp;
>  	unsigned long stack;
> +	static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
>  
> +	spin_lock(&lock);
>  	bp = stack_frame(current, NULL);
>  	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
>  		current->pid, current->comm, print_tainted(),
> @@ -194,6 +196,7 @@ void dump_stack(void)
>  		(int)strcspn(init_utsname()->version, " "),
>  		init_utsname()->version);
>  	show_trace(NULL, NULL, &stack, bp);
> +	spin_unlock(&lock);
>  }
>  EXPORT_SYMBOL(dump_stack);
>  
> -- 
> Russ Anderson, OS RAS/Partitioning Project Lead  
> SGI - Silicon Graphics Inc          rja@sgi.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
