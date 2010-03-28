Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0C1AZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 20:25:42 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39234 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab0C1AZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 20:25:41 -0400
Date: Sat, 27 Mar 2010 17:25:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       adobriyan@gmail.com, rusty@rustcorp.co.au
Subject: Re: [RFC patch] extable and module add object is static
Message-ID: <20100328002533.GN2343@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100327153233.993367557@efficios.com>
 <20100327224606.GK2343@linux.vnet.ibm.com>
 <20100327231421.GA4685@Krystal>
 <20100327232024.GB4685@Krystal>
 <20100327234314.GL2343@linux.vnet.ibm.com>
 <20100328000234.GA4924@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100328000234.GA4924@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 08:02:34PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Sat, Mar 27, 2010 at 07:20:24PM -0400, Mathieu Desnoyers wrote:
> [...]
> > > Something close to "object_is_static()" would be "kernel_text_address()", but it
> > > only considers the text section addresses. I'd need something that would be
> > > broader than that, containing all core kernel and module bss and data sections.
> > > 
> > > Still looking...
> > 
> > I was actually feeling pretty good about remembering object_is_on_stack()
> > and finding it again.  ;-)
> > 
> > I am not seeing anything the identifies data or bss, and in any case,
> > other situations such as per-CPU, __read_mostly, and who knows what all
> > else would also need to be handled.  So in the short term, my guess would
> > be that it would be best to provide the three functions (possibly renaming
> > them as noted above), but to leave the responsibility for figuring out
> > which to invoke with the caller.  Always happy to be proven wrong, of
> > course!
> > 
> > 							Thanx, Paul
> 
> I think I found a neat way to do object_is_static(), which is all we need here.
> Can you have a look at the following patch ? If you think it's right, I'll add
> it to the patchset for the next submission.

Looks plausible to me!

Rusty, any thoughts?

							Thanx, Paul

> extable and module add object is static
> 
> Adds an API to extable.c to check if an object is statically defined. This
> permits, along with object_is_on_stack(), to figure out is an object is either
> statically defined (object_is_static()) or allocated on the stack
> (object_is_on_stack()).
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: akpm@linux-foundation.org
> CC: mingo@elte.hu
> CC: laijs@cn.fujitsu.com
> CC: dipankar@in.ibm.com
> CC: josh@joshtriplett.org
> CC: dvhltc@us.ibm.com
> CC: niv@us.ibm.com
> CC: tglx@linutronix.de
> CC: peterz@infradead.org
> CC: rostedt@goodmis.org
> CC: Valdis.Kletnieks@vt.edu
> CC: dhowells@redhat.com
> CC: eric.dumazet@gmail.com
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>  include/linux/kernel.h |    2 +
>  kernel/extable.c       |   52 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> Index: linux.trees.git/include/linux/kernel.h
> ===================================================================
> --- linux.trees.git.orig/include/linux/kernel.h	2010-03-27 19:27:02.000000000 -0400
> +++ linux.trees.git/include/linux/kernel.h	2010-03-27 19:28:02.000000000 -0400
> @@ -218,6 +218,8 @@ extern int __kernel_text_address(unsigne
>  extern int kernel_text_address(unsigned long addr);
>  extern int func_ptr_is_kernel_text(void *ptr);
> 
> +extern int object_is_static(void *obj);
> +
>  struct pid;
>  extern struct pid *session_of_pgrp(struct pid *pgrp);
> 
> Index: linux.trees.git/kernel/extable.c
> ===================================================================
> --- linux.trees.git.orig/kernel/extable.c	2010-03-27 19:28:06.000000000 -0400
> +++ linux.trees.git/kernel/extable.c	2010-03-27 19:54:40.000000000 -0400
> @@ -60,6 +60,14 @@ static inline int init_kernel_text(unsig
>  	return 0;
>  }
> 
> +static inline int init_kernel_text_or_data(unsigned long addr)
> +{
> +	if (addr >= (unsigned long)__init_begin &&
> +	    addr <= (unsigned long)__init_end)
> +		return 1;
> +	return 0;
> +}
> +
>  int core_kernel_text(unsigned long addr)
>  {
>  	if (addr >= (unsigned long)_stext &&
> @@ -113,3 +121,47 @@ int func_ptr_is_kernel_text(void *ptr)
>  		return 1;
>  	return is_module_text_address(addr);
>  }
> +
> +/*
> + * Taking the safe approach to refer to each section individually rather than
> + * just taking a range between _stext and _end, just in case an architecture
> + * would decide to override the standard linker scripts and put a section
> + * outside of this range.
> + *
> + * Should be kept in sync with linux/section.h and asm-generic/vmlinux.lds.h.
> + */
> +static int core_object_is_static(void *obj)
> +{
> +	unsigned long addr = (unsigned long) obj;
> +
> +	if (addr >= (unsigned long)_sdata &&
> +	    addr <= (unsigned long)_edata)
> +		return 1;
> +	if (addr >= (unsigned long)__bss_start &&
> +	    addr <= (unsigned long)__bss_stop)
> +		return 1;
> +	if (addr >= (unsigned long)__per_cpu_start &&
> +	    addr <= (unsigned long)__per_cpu_end)
> +		return 1;
> +	if (addr >= (unsigned long)__start_rodata &&
> +	    addr <= (unsigned long)__end_rodata)
> +		return 1;
> +	if (system_state == SYSTEM_BOOTING &&
> +	    init_kernel_text_or_data(addr))
> +		return 1;
> +	if (core_kernel_text(addr))
> +		return 1;
> +	return 0;
> +}
> +
> +/*
> + * object_is_static - returns true is an object is statically defined
> + */
> +int object_is_static(void *obj)
> +{
> +	if (core_object_is_static(obj))
> +		return 1;
> +	if (is_module_address((unsigned long) obj))
> +		return 1;
> +	return 0;
> +}
> 
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
