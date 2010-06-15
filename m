Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0FOTDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:03:00 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41704 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189Ab0FOTC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:02:57 -0400
Date: Tue, 15 Jun 2010 12:02:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, ltt-dev@lists.casi.polymtl.ca,
       Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, linux-arm-kernel@lists.infradead.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: Userspace helpers at static addresses on ARM [was: Re: [PATCH]
 fix the "unknown" case]
Message-ID: <20100615190254.GH2304@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100614220600.GA15130@linux.vnet.ibm.com>
 <OF014FB97C.3968191D-ONC1257743.0043E356-C1257743.004525C9@de.ibm.com>
 <20100615150727.GC2304@linux.vnet.ibm.com>
 <OFCD1BC564.0035E292-ONC1257743.0057CB53-C1257743.0058903F@de.ibm.com>
 <20100615170001.GG2304@linux.vnet.ibm.com>
 <20100615170315.GA7835@Krystal>
 <OFC507BE7B.F11411B7-ONC1257743.005F924F-C1257743.00605E5E@de.ibm.com>
 <20100615182919.GB11394@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100615182919.GB11394@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 02:29:19PM -0400, Mathieu Desnoyers wrote:
> * Ulrich Weigand (Ulrich.Weigand@de.ibm.com) wrote:
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote on 06/15/2010
> > 07:03:15 PM:
> > 
> > > I wonder starting with which Linux kernel version __kernel_dmb appeared.
> > > Tying ourself directly to a Linux kernel ABI might complicate things.
> > >
> > > Is this ABI presented in a vDSO or userland have to go through a system
> > call ?
> > > Is there any way to probe for its availability ?
> > 
> > This looks sort-of like a vDSO, except without the DSO part :-)
> > 
> > The kernel simply makes the code available at a fixed address that is
> > directly callable by user space.  See the comments in
> > linux/arch/arm/kernel/entry-armv.S:
> > 
> 
> Hrm, statically addressed shared objects. The security guys should be freaking
> out here. This can sadly make stack overflow exploitation much, much, easier
> because of lack of randomization of addresses where the code is located. :-/
> 
> About the original topic of our discussion:
> Thanks for the explanation below. I think making urcu test for the kernel
> feature at library load seems like the best portable solution so far. We can
> directly use the specific memory barriers when armv7+ is specified, and check
> at runtime if the kernel feature is there for "generic" arm build. For generic
> ARM build where we discover that the kernel lacks the proper features, we could
> rely on Paul's double-fake-mutex scheme (assuming we audit glibc pthreads to
> ensure the proper memory barriers are there). If we find out that even pthreads
> mutexes got the barriers wrong there, then we should refuse to load the library
> altogether.

OK.  The gcc patches were for __sync_sychronize(), which I have replaced
with a "dmb" asm, and for __sync_lock_release(), which I do not use.
If I understand Paolo and Uli correctly (a dubious assumption, to be
sure), then the memory barriers and atomicity should be supplied by
the libraries and/or kernel for the other __sync_ primitives.

So for ARMv7, my prior patch should suffice.  (Or am I still missing
something?)

Additional patches are no doubt required for other ARM flavors, and
perhaps also for older compilers and kernels.

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> > /*
> >  * User helpers.
> >  *
> >  * These are segment of kernel provided user code reachable from user space
> >  * at a fixed address in kernel memory.  This is used to provide user space
> >  * with some operations which require kernel help because of unimplemented
> >  * native feature and/or instructions in many ARM CPUs. The idea is for
> >  * this code to be executed directly in user mode for best efficiency but
> >  * which is too intimate with the kernel counter part to be left to user
> >  * libraries.  In fact this code might even differ from one CPU to another
> >  * depending on the available  instruction set and restrictions like on
> >  * SMP systems.  In other words, the kernel reserves the right to change
> >  * this code as needed without warning. Only the entry points and their
> >  * results are guaranteed to be stable.
> >  *
> >  * Each segment is 32-byte aligned and will be moved to the top of the high
> >  * vector page.  New segments (if ever needed) must be added in front of
> >  * existing ones.  This mechanism should be used only for things that are
> >  * really small and justified, and not be abused freely.
> >  *
> >  * User space is expected to implement those things inline when optimizing
> >  * for a processor that has the necessary native support, but only if such
> >  * resulting binaries are already to be incompatible with earlier ARM
> >  * processors due to the use of unsupported instructions other than what
> >  * is provided here.  In other words don't make binaries unable to run on
> >  * earlier processors just for the sake of not using these kernel helpers
> >  * if your compiled code is not going to use the new instructions for other
> >  * purpose.
> >  */
> > 
> > 
> > /*
> >  * Reference prototype:
> >  *
> >  *           void __kernel_memory_barrier(void)
> >  *
> >  * Input:
> >  *
> >  *           lr = return address
> >  *
> >  * Output:
> >  *
> >  *           none
> >  *
> >  * Clobbered:
> >  *
> >  *           none
> >  *
> >  * Definition and user space usage example:
> >  *
> >  *           typedef void (__kernel_dmb_t)(void);
> >  *           #define __kernel_dmb (*(__kernel_dmb_t *)0xffff0fa0)
> >  *
> >  * Apply any needed memory barrier to preserve consistency with data
> > modified
> >  * manually and __kuser_cmpxchg usage.
> >  *
> >  * This could be used as follows:
> >  *
> >  * #define __kernel_dmb() \
> >  *         asm volatile ( "mov r0, #0xffff0fff; mov lr, pc; sub pc, r0,
> > #95" \
> >  *		         : : : "r0", "lr","cc" )
> >  */
> > 
> > 
> > As far as I can see, the only provision to check whether a feature is
> > available
> > is this one:
> > 
> > /*
> >  * Reference declaration:
> >  *
> >  *           extern unsigned int __kernel_helper_version;
> >  *
> >  * Definition and user space usage example:
> >  *
> >  *           #define __kernel_helper_version (*(unsigned int *)0xffff0ffc)
> >  *
> >  * User space may read this to determine the curent number of helpers
> >  * available.
> >  */
> > 
> > However, note that libgcc code does not perform this check, it simply
> > assumes
> > the above routine to be present.
> > 
> > The __kernel_dmb (which is the most recently added helper available in
> > current
> > mainline) seems to have been available since kernel 2.6.15, so presumably
> > code
> > using any of the GCC sync primitives would simply fail on any older kernel,
> > unless I'm missing something here ...
> > 
> > 
> > Mit freundlichen Gruessen / Best Regards
> > 
> > Ulrich Weigand
> > 
> > --
> >   Dr. Ulrich Weigand | Phone: +49-7031/16-3727
> >   STSM, GNU compiler and toolchain for Linux on System z and Cell/B.E.
> >   IBM Deutschland Research & Development GmbH
> >   Vorsitzender des Aufsichtsrats: Martin Jetter | Geschäftsführung: Dirk
> > Wittkopp
> >   Sitz der Gesellschaft: Böblingen | Registergericht: Amtsgericht
> > Stuttgart, HRB 243294
> > 
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
