Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab2KHRnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:43:14 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:48786 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2KHRnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:43:11 -0500
Subject: Re: How does atomic operation work on smp
From: anish kumar <anish198519851985@gmail.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Hendrik Visage <hvjunk@gmail.com>, Jimmy Pan <dspjmt@gmail.com>,
        linux-newbie@vger.kernel.org, linux-c-programming@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20121107164507.GA3571@opentech.at>
References: <20121108070121.GA7492@gmail.com>
	 <CADtGFvkoVX-CCEPRE7swRFiTeBo2wFiQx_8S5woKp_ts8XsUUA@mail.gmail.com>
	 <20121107164507.GA3571@opentech.at>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Nov 2012 02:42:46 +0900
Message-ID: <1352396566.4822.73.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-07 at 17:45 +0100, Nicholas Mc Guire wrote:
> On Wed, 07 Nov 2012, Hendrik Visage wrote:
> 
> > On Thu, Nov 8, 2012 at 9:01 AM, Jimmy Pan <dspjmt@gmail.com> wrote:
> > > I understand how atomic operation work on unary core processors, I think it just disables the interrupt and dominate the cpu until it finished.
> 
> Atomic operations do not need to disable interrupts - a test-and-set operation does not disable interrupts. Locking primitives like spin-locks that allow you to get consistent access to non-atomic critical sections may disable interrupts.
> 
> It seems to me that you are identifying atomic operations with critical sections, which is not really the same thing - but maybe I missunderstood you.
> 
> > > While, how do we implement this on multi processor computers?
> > > Suppose cpu A is performing an atomic operation on variable a. At the same time, cpu B is also performing the operation on a. In such the result may be overwritten.
> > > Of course we can use spinlocks, but on the atomic operation's behalf, how does it gurantee to prevent such case?
> > > Can anyone explain the crux of it? Thanks.
> > 
> > Basically you make use of machine specific instructions that will  do
> > that for you.
> > In other words, get the datasheets of the specific system you intent
> > to code on/for (I assume here you are refering to assembler level
> > codes, as higher up you make use of the relevant libraries that does
> > that for you).
> >
> 
> More or less any (sane) architecture will provide some very basic atoicity
Architecture provides minimum atomicity in the form of assembly
instructions.So below is the code of how in arm atomic_add() is
implemented which is SMP safe,
/*
 * ARMv6 UP and SMP safe atomic ops.  We use load exclusive and
 * store exclusive to ensure that these are atomic.  We may loop
 * to ensure that the update happens.
 */
static inline void atomic_add(int i, atomic_t *v)
{
         __asm__ __volatile__("@ atomic_add\n"
"1:     ldrex   %0, [%3]\n"
"       add     %0, %0, %4\n"
"       strex   %1, %0, [%3]\n"
"       teq     %1, #0\n"
"       bne     1b"
        : "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
        : "r" (&v->counter), "Ir" (i)
        : "cc");
}

Above function is SMP safe(but sometimes this also needs memory barrier
(/Documentation/memory-barriers.txt-ATOMIC OPERATIONS) and be careful
with the name of the functions as atomic in the function name doesn't
guaranty anything as below:
        CPU 1                        CPU 2
        ===============           ===============
	x = 0;                       y = x;
       atomic_add_return(x)  

what do you think would be the value of y in CPU2?Legally it can have
any value i.e. 0 or 1 as CPU1 can reorder the instructions any time(when
does it see fit to reorder?).However if atomic_add_return is implemented
with explicit memory barriers then it wouldn't happen and you will see a
correct result as below:
        CPU 1                        CPU 2
        ===============           ===============
	x = 0;                       
       atomic_add_return(x)  
				    y  = x;	//x will be 1 here

>From arch/arm/include/asm/atomic.h 
static inline int atomic_add_return(int i, atomic_t *v)
{
        smp_mb();  <BARRIER HERE>
        __asm__ __volatile__("@ atomic_add_return\n"
"1:     ldrex   %0, [%3]\n"
"       add     %0, %0, %4\n"
"       strex   %1, %0, [%3]\n"
"       teq     %1, #0\n"
"       bne     1b"
        : "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
        : "r" (&v->counter), "Ir" (i)
        : "cc");

        smp_mb(); <BARRIER HERE>
}
so atomic variable is just like any other variable except it comes with
some set of operations which combined with barriers make it really
_atomic_.
> capabilities. a 32bit (or 64bit on 64bit boxes) data object is guaranteed
> to be consistent (that is you will never be able to get half of the old and
> half of the new value if there were a concurrent read and write). Some form
> of Compare and Swap (CAS) / Test and Set bit assembler instructuion will be
> provided that can overcome the lowest level race that would be incured by
> setting and then testing in separate steps. And finally low level
> mechanisms are provided to ensure consistency over cores by load/store
> fences (memory barriers). 
> 
> In the above case where you have a concurrent reader and writer of variable
> "a" you do not need any lock provided the data object is only a single 32/64
> bit object - if it is say a struct then you need locking to ensure consistency
> of the retrieved data. The atomic instructions are then actually only needed
> for the locks (but note that locks here are pure advisory locks not enforced
> in any way by HW). 
> 
> so if you have a writer updating a variable and a reader reading it concurently
> then the reader is guaranteed to always read a consistent 32bit (or 64bit) 
> entity - but it is not guaranteed of course that you actually read all 
> intermediate values (that is completness is not guaranteed). If the variable
> is more than a primitive data object then you need to protect it by associating
> a lock with the data object (always lock data not code...)
> 
> 
> thx!
> hofrat
> --
> To unsubscribe from this list: send the line "unsubscribe linux-c-programming" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


