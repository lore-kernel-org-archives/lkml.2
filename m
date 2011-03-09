Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab1CIRuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:50:54 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61118 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1CIRux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:50:53 -0500
MIME-Version: 1.0
In-Reply-To: <20110309112550.GA3050@google.com>
References: <20110307021127.GB31188@google.com>
	<alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
	<20110309112550.GA3050@google.com>
Date: Wed, 9 Mar 2011 09:50:51 -0800
X-Google-Sender-Auth: -UNXlMNR_YH9uvF5EqEOCEJpHjw
Message-ID: <AANLkTim8u870b5+23rM3hE72yK+aoWrSgvPdN9BKu+Ns@mail.gmail.com>
Subject: Re: [PATCH] futex: cmpxchg_futex_value_locked API change
From: Darren Hart <darren@dvhart.com>
To: Michel Lespinasse <walken@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 3:25 AM, Michel Lespinasse <walken@google.com> wrote:
> On Tue, Mar 08, 2011 at 09:17:11PM +0100, Thomas Gleixner wrote:
>> On Sun, 6 Mar 2011, Michel Lespinasse wrote:
>> > The cmpxchg_futex_value_locked API was funny in that it returned either
>> > the original, user-exposed futex value OR an error code such as -EFAULT.
>> > This was confusing at best, and could be a source of livelocks in places
>> > that retry the cmpxchg_futex_value_locked after trying to fix the issue
>> > by running fault_in_user_writeable().
>> >
>> > This change makes the cmpxchg_futex_value_locked API more similar to the
>> > get_futex_value_locked one, returning an error code and updating the
>> > original value through a reference argument.
>>
>> Ack.
>>
>> >  static inline int
>> > -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
>> > +futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
>> > +                         int oldval, int newval)
>>
>> Can we please change the arguments to u32 while at it? The futex core
>> code uses u32 all over the place so those inlines should do the same.
>
> All right. Attaching updated version of the diff. I also fixed the s390
> issue reported by Martin Schwidefsky.
>
> What's the proper path to check this in, could you send it towards
> the -next tree so it gets more testing ?
>
> --------------------------------------8<-------------------------------
>
> The cmpxchg_futex_value_locked API was funny in that it returned either
> the original, user-exposed futex value OR an error code such as -EFAULT.
> This was confusing at best, and could be a source of livelocks in places
> that retry the cmpxchg_futex_value_locked after trying to fix the issue
> by running fault_in_user_writeable().
>
> This change makes the cmpxchg_futex_value_locked API more similar to the
> get_futex_value_locked one, returning an error code and updating the
> original value through a reference argument.
>
> Additionally, the futex pointer types have been changed to u32 * in both
> futex_atomic_cmpxchg_inatomic and futex_atomic_op_inuser internal APIs
> as suggested by Thomas Gleixner.
>

Hi Michel, have you run the patches through futextest? Particularly
the functional tests (you can comment out the requeue pi tests as they
are known to be failing atm).

No objections from me, but I'd like to see things like this run
through futextest to help avoid subtle issues.

--
Darren

> Signed-off-by: Michel Lespinasse <walken@google.com>
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>  (for tile)
> Acked-by: Tony Luck <tony.luck@intel.com>  (for ia64)
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Michal Simek <monstr@monstr.eu>  (for microblaze)
>
> ---
>  arch/alpha/include/asm/futex.h      |   29 ++++++++++++----------
>  arch/arm/include/asm/futex.h        |   30 ++++++++++++----------
>  arch/frv/include/asm/futex.h        |    5 ++-
>  arch/frv/kernel/futex.c             |   14 +++++-----
>  arch/ia64/include/asm/futex.h       |   15 +++++++----
>  arch/microblaze/include/asm/futex.h |   31 +++++++++++++----------
>  arch/mips/include/asm/futex.h       |   39 ++++++++++++++++-------------
>  arch/parisc/include/asm/futex.h     |   24 +++++++++---------
>  arch/powerpc/include/asm/futex.h    |   27 +++++++++++---------
>  arch/s390/include/asm/futex.h       |   12 ++++----
>  arch/s390/include/asm/uaccess.h     |    4 +-
>  arch/s390/lib/uaccess.h             |    8 +++---
>  arch/s390/lib/uaccess_pt.c          |   17 +++++++-----
>  arch/s390/lib/uaccess_std.c         |    8 ++++--
>  arch/sh/include/asm/futex-irq.h     |   24 +++++++++---------
>  arch/sh/include/asm/futex.h         |   11 ++++----
>  arch/sparc/include/asm/futex_64.h   |   20 +++++++++------
>  arch/tile/include/asm/futex.h       |   27 ++++++++++----------
>  arch/x86/include/asm/futex.h        |   22 +++++++++-------
>  include/asm-generic/futex.h         |    7 +++--
>  kernel/futex.c                      |   46 ++++++++++++----------------------
>  21 files changed, 219 insertions(+), 201 deletions(-)
>
> diff --git a/arch/alpha/include/asm/futex.h b/arch/alpha/include/asm/futex.h
> index 945de22..e8a761a 100644
> --- a/arch/alpha/include/asm/futex.h
> +++ b/arch/alpha/include/asm/futex.h
> @@ -29,7 +29,7 @@
>        :       "r" (uaddr), "r"(oparg)                         \
>        :       "memory")
>
> -static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
> +static inline int futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -39,7 +39,7 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();
> @@ -81,21 +81,23 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>  }
>
>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
>  {
> -       int prev, cmp;
> +       int ret = 0, cmp;
> +       u32 prev;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        __asm__ __volatile__ (
>                __ASM_SMP_MB
> -       "1:     ldl_l   %0,0(%2)\n"
> -       "       cmpeq   %0,%3,%1\n"
> -       "       beq     %1,3f\n"
> -       "       mov     %4,%1\n"
> -       "2:     stl_c   %1,0(%2)\n"
> -       "       beq     %1,4f\n"
> +       "1:     ldl_l   %1,0(%3)\n"
> +       "       cmpeq   %1,%4,%2\n"
> +       "       beq     %2,3f\n"
> +       "       mov     %5,%2\n"
> +       "2:     stl_c   %2,0(%3)\n"
> +       "       beq     %2,4f\n"
>        "3:     .subsection 2\n"
>        "4:     br      1b\n"
>        "       .previous\n"
> @@ -105,11 +107,12 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
>        "       .long   2b-.\n"
>        "       lda     $31,3b-2b(%0)\n"
>        "       .previous\n"
> -       :       "=&r"(prev), "=&r"(cmp)
> +       :       "+r"(ret), "=&r"(prev), "=&r"(cmp)
>        :       "r"(uaddr), "r"((long)oldval), "r"(newval)
>        :       "memory");
>
> -       return prev;
> +       *uval = prev;
> +       return ret;
>  }
>
>  #endif /* __KERNEL__ */
> diff --git a/arch/arm/include/asm/futex.h b/arch/arm/include/asm/futex.h
> index b33fe70..0e29d8e 100644
> --- a/arch/arm/include/asm/futex.h
> +++ b/arch/arm/include/asm/futex.h
> @@ -35,7 +35,7 @@
>        : "cc", "memory")
>
>  static inline int
> -futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
> +futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -46,7 +46,7 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();    /* implies preempt_disable() */
> @@ -88,36 +88,38 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>  }
>
>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
>  {
> -       int val;
> +       int ret = 0;
> +       u32 val;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
> -       pagefault_disable();    /* implies preempt_disable() */
> +       /* Note that preemption is disabled by futex_atomic_cmpxchg_inatomic
> +        * call sites. */
>
>        __asm__ __volatile__("@futex_atomic_cmpxchg_inatomic\n"
> -       "1:     " T(ldr) "      %0, [%3]\n"
> -       "       teq     %0, %1\n"
> +       "1:     " T(ldr) "      %1, [%4]\n"
> +       "       teq     %1, %2\n"
>        "       it      eq      @ explicit IT needed for the 2b label\n"
> -       "2:     " T(streq) "    %2, [%3]\n"
> +       "2:     " T(streq) "    %3, [%4]\n"
>        "3:\n"
>        "       .pushsection __ex_table,\"a\"\n"
>        "       .align  3\n"
>        "       .long   1b, 4f, 2b, 4f\n"
>        "       .popsection\n"
>        "       .pushsection .fixup,\"ax\"\n"
> -       "4:     mov     %0, %4\n"
> +       "4:     mov     %0, %5\n"
>        "       b       3b\n"
>        "       .popsection"
> -       : "=&r" (val)
> +       : "+r" (ret), "=&r" (val)
>        : "r" (oldval), "r" (newval), "r" (uaddr), "Ir" (-EFAULT)
>        : "cc", "memory");
>
> -       pagefault_enable();     /* subsumes preempt_enable() */
> -
> -       return val;
> +       *uval = val;
> +       return ret;
>  }
>
>  #endif /* !SMP */
> diff --git a/arch/frv/include/asm/futex.h b/arch/frv/include/asm/futex.h
> index 08b3d1d..4bea27f 100644
> --- a/arch/frv/include/asm/futex.h
> +++ b/arch/frv/include/asm/futex.h
> @@ -7,10 +7,11 @@
>  #include <asm/errno.h>
>  #include <asm/uaccess.h>
>
> -extern int futex_atomic_op_inuser(int encoded_op, int __user *uaddr);
> +extern int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr);
>
>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
>  {
>        return -ENOSYS;
>  }
> diff --git a/arch/frv/kernel/futex.c b/arch/frv/kernel/futex.c
> index 14f64b0..d155ca9 100644
> --- a/arch/frv/kernel/futex.c
> +++ b/arch/frv/kernel/futex.c
> @@ -18,7 +18,7 @@
>  * the various futex operations; MMU fault checking is ignored under no-MMU
>  * conditions
>  */
> -static inline int atomic_futex_op_xchg_set(int oparg, int __user *uaddr, int *_oldval)
> +static inline int atomic_futex_op_xchg_set(int oparg, u32 __user *uaddr, int *_oldval)
>  {
>        int oldval, ret;
>
> @@ -50,7 +50,7 @@ static inline int atomic_futex_op_xchg_set(int oparg, int __user *uaddr, int *_o
>        return ret;
>  }
>
> -static inline int atomic_futex_op_xchg_add(int oparg, int __user *uaddr, int *_oldval)
> +static inline int atomic_futex_op_xchg_add(int oparg, u32 __user *uaddr, int *_oldval)
>  {
>        int oldval, ret;
>
> @@ -83,7 +83,7 @@ static inline int atomic_futex_op_xchg_add(int oparg, int __user *uaddr, int *_o
>        return ret;
>  }
>
> -static inline int atomic_futex_op_xchg_or(int oparg, int __user *uaddr, int *_oldval)
> +static inline int atomic_futex_op_xchg_or(int oparg, u32 __user *uaddr, int *_oldval)
>  {
>        int oldval, ret;
>
> @@ -116,7 +116,7 @@ static inline int atomic_futex_op_xchg_or(int oparg, int __user *uaddr, int *_ol
>        return ret;
>  }
>
> -static inline int atomic_futex_op_xchg_and(int oparg, int __user *uaddr, int *_oldval)
> +static inline int atomic_futex_op_xchg_and(int oparg, u32 __user *uaddr, int *_oldval)
>  {
>        int oldval, ret;
>
> @@ -149,7 +149,7 @@ static inline int atomic_futex_op_xchg_and(int oparg, int __user *uaddr, int *_o
>        return ret;
>  }
>
> -static inline int atomic_futex_op_xchg_xor(int oparg, int __user *uaddr, int *_oldval)
> +static inline int atomic_futex_op_xchg_xor(int oparg, u32 __user *uaddr, int *_oldval)
>  {
>        int oldval, ret;
>
> @@ -186,7 +186,7 @@ static inline int atomic_futex_op_xchg_xor(int oparg, int __user *uaddr, int *_o
>  /*
>  * do the futex operations
>  */
> -int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
> +int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -197,7 +197,7 @@ int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();
> diff --git a/arch/ia64/include/asm/futex.h b/arch/ia64/include/asm/futex.h
> index c7f0f06..8428525 100644
> --- a/arch/ia64/include/asm/futex.h
> +++ b/arch/ia64/include/asm/futex.h
> @@ -46,7 +46,7 @@ do {                                                                  \
>  } while (0)
>
>  static inline int
> -futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
> +futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -56,7 +56,7 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();
> @@ -100,23 +100,26 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>  }
>
>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
>  {
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        {
> -               register unsigned long r8 __asm ("r8");
> +               register unsigned long r8 __asm ("r8") = 0;
> +               unsigned long prev;
>                __asm__ __volatile__(
>                        "       mf;;                                    \n"
>                        "       mov ar.ccv=%3;;                         \n"
>                        "[1:]   cmpxchg4.acq %0=[%1],%2,ar.ccv          \n"
>                        "       .xdata4 \"__ex_table\", 1b-., 2f-.      \n"
>                        "[2:]"
> -                       : "=r" (r8)
> +                       : "=r" (prev)
>                        : "r" (uaddr), "r" (newval),
>                          "rO" ((long) (unsigned) oldval)
>                        : "memory");
> +               *uval = prev;
>                return r8;
>        }
>  }
> diff --git a/arch/microblaze/include/asm/futex.h b/arch/microblaze/include/asm/futex.h
> index ad3fd61..b0526d2 100644
> --- a/arch/microblaze/include/asm/futex.h
> +++ b/arch/microblaze/include/asm/futex.h
> @@ -29,7 +29,7 @@
>  })
>
>  static inline int
> -futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
> +futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -39,7 +39,7 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();
> @@ -94,31 +94,34 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>  }
>
>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
>  {
> -       int prev, cmp;
> +       int ret = 0, cmp;
> +       u32 prev;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
> -       __asm__ __volatile__ ("1:       lwx     %0, %2, r0;             \
> -                                       cmp     %1, %0, %3;             \
> -                                       beqi    %1, 3f;                 \
> -                               2:      swx     %4, %2, r0;             \
> -                                       addic   %1, r0, 0;              \
> -                                       bnei    %1, 1b;                 \
> +       __asm__ __volatile__ ("1:       lwx     %1, %3, r0;             \
> +                                       cmp     %2, %1, %4;             \
> +                                       beqi    %2, 3f;                 \
> +                               2:      swx     %5, %3, r0;             \
> +                                       addic   %2, r0, 0;              \
> +                                       bnei    %2, 1b;                 \
>                                3:                                      \
>                                .section .fixup,\"ax\";                 \
>                                4:      brid    3b;                     \
> -                                       addik   %0, r0, %5;             \
> +                                       addik   %0, r0, %6;             \
>                                .previous;                              \
>                                .section __ex_table,\"a\";              \
>                                .word   1b,4b,2b,4b;                    \
>                                .previous;"                             \
> -               : "=&r" (prev), "=&r"(cmp)                              \
> +               : "+r" (ret), "=&r" (prev), "=&r"(cmp)  \
>                : "r" (uaddr), "r" (oldval), "r" (newval), "i" (-EFAULT));
>
> -       return prev;
> +       *uval = prev;
> +       return ret;
>  }
>
>  #endif /* __KERNEL__ */
> diff --git a/arch/mips/include/asm/futex.h b/arch/mips/include/asm/futex.h
> index b9cce90..6ebf173 100644
> --- a/arch/mips/include/asm/futex.h
> +++ b/arch/mips/include/asm/futex.h
> @@ -75,7 +75,7 @@
>  }
>
>  static inline int
> -futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
> +futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -85,7 +85,7 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();
> @@ -132,11 +132,13 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>  }
>
>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
>  {
> -       int retval;
> +       int ret = 0;
> +       u32 val;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        if (cpu_has_llsc && R10000_LLSC_WAR) {
> @@ -145,25 +147,25 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
>                "       .set    push                                    \n"
>                "       .set    noat                                    \n"
>                "       .set    mips3                                   \n"
> -               "1:     ll      %0, %2                                  \n"
> -               "       bne     %0, %z3, 3f                             \n"
> +               "1:     ll      %1, %3                                  \n"
> +               "       bne     %1, %z4, 3f                             \n"
>                "       .set    mips0                                   \n"
> -               "       move    $1, %z4                                 \n"
> +               "       move    $1, %z5                                 \n"
>                "       .set    mips3                                   \n"
> -               "2:     sc      $1, %1                                  \n"
> +               "2:     sc      $1, %2                                  \n"
>                "       beqzl   $1, 1b                                  \n"
>                __WEAK_LLSC_MB
>                "3:                                                     \n"
>                "       .set    pop                                     \n"
>                "       .section .fixup,\"ax\"                          \n"
> -               "4:     li      %0, %5                                  \n"
> +               "4:     li      %0, %6                                  \n"
>                "       j       3b                                      \n"
>                "       .previous                                       \n"
>                "       .section __ex_table,\"a\"                       \n"
>                "       "__UA_ADDR "\t1b, 4b                            \n"
>                "       "__UA_ADDR "\t2b, 4b                            \n"
>                "       .previous                                       \n"
> -               : "=&r" (retval), "=R" (*uaddr)
> +               : "+r" (ret), "=&r" (val), "=R" (*uaddr)
>                : "R" (*uaddr), "Jr" (oldval), "Jr" (newval), "i" (-EFAULT)
>                : "memory");
>        } else if (cpu_has_llsc) {
> @@ -172,31 +174,32 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
>                "       .set    push                                    \n"
>                "       .set    noat                                    \n"
>                "       .set    mips3                                   \n"
> -               "1:     ll      %0, %2                                  \n"
> -               "       bne     %0, %z3, 3f                             \n"
> +               "1:     ll      %1, %3                                  \n"
> +               "       bne     %1, %z4, 3f                             \n"
>                "       .set    mips0                                   \n"
> -               "       move    $1, %z4                                 \n"
> +               "       move    $1, %z5                                 \n"
>                "       .set    mips3                                   \n"
> -               "2:     sc      $1, %1                                  \n"
> +               "2:     sc      $1, %2                                  \n"
>                "       beqz    $1, 1b                                  \n"
>                __WEAK_LLSC_MB
>                "3:                                                     \n"
>                "       .set    pop                                     \n"
>                "       .section .fixup,\"ax\"                          \n"
> -               "4:     li      %0, %5                                  \n"
> +               "4:     li      %0, %6                                  \n"
>                "       j       3b                                      \n"
>                "       .previous                                       \n"
>                "       .section __ex_table,\"a\"                       \n"
>                "       "__UA_ADDR "\t1b, 4b                            \n"
>                "       "__UA_ADDR "\t2b, 4b                            \n"
>                "       .previous                                       \n"
> -               : "=&r" (retval), "=R" (*uaddr)
> +               : "+r" (ret), "=&r" (val), "=R" (*uaddr)
>                : "R" (*uaddr), "Jr" (oldval), "Jr" (newval), "i" (-EFAULT)
>                : "memory");
>        } else
>                return -ENOSYS;
>
> -       return retval;
> +       *uval = val;
> +       return ret;
>  }
>
>  #endif
> diff --git a/arch/parisc/include/asm/futex.h b/arch/parisc/include/asm/futex.h
> index 0c705c3..67a33cc 100644
> --- a/arch/parisc/include/asm/futex.h
> +++ b/arch/parisc/include/asm/futex.h
> @@ -8,7 +8,7 @@
>  #include <asm/errno.h>
>
>  static inline int
> -futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
> +futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -18,7 +18,7 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();
> @@ -51,10 +51,10 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>
>  /* Non-atomic version */
>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
>  {
> -       int err = 0;
> -       int uval;
> +       u32 val;
>
>        /* futex.c wants to do a cmpxchg_inatomic on kernel NULL, which is
>         * our gateway page, and causes no end of trouble...
> @@ -62,15 +62,15 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
>        if (segment_eq(KERNEL_DS, get_fs()) && !uaddr)
>                return -EFAULT;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
> -       err = get_user(uval, uaddr);
> -       if (err) return -EFAULT;
> -       if (uval == oldval)
> -               err = put_user(newval, uaddr);
> -       if (err) return -EFAULT;
> -       return uval;
> +       if (get_user(val, uaddr))
> +               return -EFAULT;
> +       if (val == oldval && put_user(newval, uaddr))
> +               return -EFAULT;
> +       *uval = val;
> +       return 0;
>  }
>
>  #endif /*__KERNEL__*/
> diff --git a/arch/powerpc/include/asm/futex.h b/arch/powerpc/include/asm/futex.h
> index 7c589ef..c94e4a3 100644
> --- a/arch/powerpc/include/asm/futex.h
> +++ b/arch/powerpc/include/asm/futex.h
> @@ -30,7 +30,7 @@
>        : "b" (uaddr), "i" (-EFAULT), "r" (oparg) \
>        : "cr0", "memory")
>
> -static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
> +static inline int futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -40,7 +40,7 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();
> @@ -82,35 +82,38 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>  }
>
>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
>  {
> -       int prev;
> +       int ret = 0;
> +       u32 prev;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>         __asm__ __volatile__ (
>         PPC_RELEASE_BARRIER
> -"1:     lwarx   %0,0,%2         # futex_atomic_cmpxchg_inatomic\n\
> -        cmpw    0,%0,%3\n\
> +"1:     lwarx   %1,0,%3         # futex_atomic_cmpxchg_inatomic\n\
> +        cmpw    0,%1,%4\n\
>         bne-    3f\n"
> -        PPC405_ERR77(0,%2)
> -"2:     stwcx.  %4,0,%2\n\
> +        PPC405_ERR77(0,%3)
> +"2:     stwcx.  %5,0,%3\n\
>         bne-    1b\n"
>         PPC_ACQUIRE_BARRIER
>  "3:    .section .fixup,\"ax\"\n\
> -4:     li      %0,%5\n\
> +4:     li      %0,%6\n\
>        b       3b\n\
>        .previous\n\
>        .section __ex_table,\"a\"\n\
>        .align 3\n\
>        " PPC_LONG "1b,4b,2b,4b\n\
>        .previous" \
> -        : "=&r" (prev), "+m" (*uaddr)
> +        : "+r" (ret), "=&r" (prev), "+m" (*uaddr)
>         : "r" (uaddr), "r" (oldval), "r" (newval), "i" (-EFAULT)
>         : "cc", "memory");
>
> -        return prev;
> +       *uval = prev;
> +        return ret;
>  }
>
>  #endif /* __KERNEL__ */
> diff --git a/arch/s390/include/asm/futex.h b/arch/s390/include/asm/futex.h
> index 5c5d02d..81cf36b 100644
> --- a/arch/s390/include/asm/futex.h
> +++ b/arch/s390/include/asm/futex.h
> @@ -7,7 +7,7 @@
>  #include <linux/uaccess.h>
>  #include <asm/errno.h>
>
> -static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
> +static inline int futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -18,7 +18,7 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();
> @@ -39,13 +39,13 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>        return ret;
>  }
>
> -static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr,
> -                                               int oldval, int newval)
> +static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                                               u32 oldval, u32 newval)
>  {
> -       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
> -       return uaccess.futex_atomic_cmpxchg(uaddr, oldval, newval);
> +       return uaccess.futex_atomic_cmpxchg(uval, uaddr, oldval, newval);
>  }
>
>  #endif /* __KERNEL__ */
> diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
> index d6b1ed0..2d9ea11f 100644
> --- a/arch/s390/include/asm/uaccess.h
> +++ b/arch/s390/include/asm/uaccess.h
> @@ -83,8 +83,8 @@ struct uaccess_ops {
>        size_t (*clear_user)(size_t, void __user *);
>        size_t (*strnlen_user)(size_t, const char __user *);
>        size_t (*strncpy_from_user)(size_t, const char __user *, char *);
> -       int (*futex_atomic_op)(int op, int __user *, int oparg, int *old);
> -       int (*futex_atomic_cmpxchg)(int __user *, int old, int new);
> +       int (*futex_atomic_op)(int op, u32 __user *, int oparg, int *old);
> +       int (*futex_atomic_cmpxchg)(u32 *, u32 __user *, u32 old, u32 new);
>  };
>
>  extern struct uaccess_ops uaccess;
> diff --git a/arch/s390/lib/uaccess.h b/arch/s390/lib/uaccess.h
> index 126011d..1d2536c 100644
> --- a/arch/s390/lib/uaccess.h
> +++ b/arch/s390/lib/uaccess.h
> @@ -12,12 +12,12 @@ extern size_t copy_from_user_std(size_t, const void __user *, void *);
>  extern size_t copy_to_user_std(size_t, void __user *, const void *);
>  extern size_t strnlen_user_std(size_t, const char __user *);
>  extern size_t strncpy_from_user_std(size_t, const char __user *, char *);
> -extern int futex_atomic_cmpxchg_std(int __user *, int, int);
> -extern int futex_atomic_op_std(int, int __user *, int, int *);
> +extern int futex_atomic_cmpxchg_std(u32 *, u32 __user *, u32, u32);
> +extern int futex_atomic_op_std(int, u32 __user *, int, int *);
>
>  extern size_t copy_from_user_pt(size_t, const void __user *, void *);
>  extern size_t copy_to_user_pt(size_t, void __user *, const void *);
> -extern int futex_atomic_op_pt(int, int __user *, int, int *);
> -extern int futex_atomic_cmpxchg_pt(int __user *, int, int);
> +extern int futex_atomic_op_pt(int, u32 __user *, int, int *);
> +extern int futex_atomic_cmpxchg_pt(u32 *, u32 __user *, u32, u32);
>
>  #endif /* __ARCH_S390_LIB_UACCESS_H */
> diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
> index 404f2de..afc716a 100644
> --- a/arch/s390/lib/uaccess_pt.c
> +++ b/arch/s390/lib/uaccess_pt.c
> @@ -302,7 +302,7 @@ fault:
>                     : "0" (-EFAULT), "d" (oparg), "a" (uaddr),         \
>                       "m" (*uaddr) : "cc" );
>
> -static int __futex_atomic_op_pt(int op, int __user *uaddr, int oparg, int *old)
> +static int __futex_atomic_op_pt(int op, u32 __user *uaddr, int oparg, int *old)
>  {
>        int oldval = 0, newval, ret;
>
> @@ -335,7 +335,7 @@ static int __futex_atomic_op_pt(int op, int __user *uaddr, int oparg, int *old)
>        return ret;
>  }
>
> -int futex_atomic_op_pt(int op, int __user *uaddr, int oparg, int *old)
> +int futex_atomic_op_pt(int op, u32 __user *uaddr, int oparg, int *old)
>  {
>        int ret;
>
> @@ -354,26 +354,29 @@ int futex_atomic_op_pt(int op, int __user *uaddr, int oparg, int *old)
>        return ret;
>  }
>
> -static int __futex_atomic_cmpxchg_pt(int __user *uaddr, int oldval, int newval)
> +static int __futex_atomic_cmpxchg_pt(u32 *uval, u32 __user *uaddr,
> +                                    u32 oldval, u32 newval)
>  {
>        int ret;
>
>        asm volatile("0: cs   %1,%4,0(%5)\n"
> -                    "1: lr   %0,%1\n"
> +                    "1: la   %0,0\n"
>                     "2:\n"
>                     EX_TABLE(0b,2b) EX_TABLE(1b,2b)
>                     : "=d" (ret), "+d" (oldval), "=m" (*uaddr)
>                     : "0" (-EFAULT), "d" (newval), "a" (uaddr), "m" (*uaddr)
>                     : "cc", "memory" );
> +       *uval = oldval;
>        return ret;
>  }
>
> -int futex_atomic_cmpxchg_pt(int __user *uaddr, int oldval, int newval)
> +int futex_atomic_cmpxchg_pt(int *uval, int __user *uaddr,
> +                           int oldval, int newval)
>  {
>        int ret;
>
>        if (segment_eq(get_fs(), KERNEL_DS))
> -               return __futex_atomic_cmpxchg_pt(uaddr, oldval, newval);
> +               return __futex_atomic_cmpxchg_pt(uval, uaddr, oldval, newval);
>        spin_lock(&current->mm->page_table_lock);
>        uaddr = (int __user *) __dat_user_addr((unsigned long) uaddr);
>        if (!uaddr) {
> @@ -382,7 +385,7 @@ int futex_atomic_cmpxchg_pt(int __user *uaddr, int oldval, int newval)
>        }
>        get_page(virt_to_page(uaddr));
>        spin_unlock(&current->mm->page_table_lock);
> -       ret = __futex_atomic_cmpxchg_pt(uaddr, oldval, newval);
> +       ret = __futex_atomic_cmpxchg_pt(uval, uaddr, oldval, newval);
>        put_page(virt_to_page(uaddr));
>        return ret;
>  }
> diff --git a/arch/s390/lib/uaccess_std.c b/arch/s390/lib/uaccess_std.c
> index a6c4f7e..bb1a7ee 100644
> --- a/arch/s390/lib/uaccess_std.c
> +++ b/arch/s390/lib/uaccess_std.c
> @@ -255,7 +255,7 @@ size_t strncpy_from_user_std(size_t size, const char __user *src, char *dst)
>                : "0" (-EFAULT), "d" (oparg), "a" (uaddr),              \
>                  "m" (*uaddr) : "cc");
>
> -int futex_atomic_op_std(int op, int __user *uaddr, int oparg, int *old)
> +int futex_atomic_op_std(int op, u32 __user *uaddr, int oparg, int *old)
>  {
>        int oldval = 0, newval, ret;
>
> @@ -287,19 +287,21 @@ int futex_atomic_op_std(int op, int __user *uaddr, int oparg, int *old)
>        return ret;
>  }
>
> -int futex_atomic_cmpxchg_std(int __user *uaddr, int oldval, int newval)
> +int futex_atomic_cmpxchg_std(u32 *uval, u32 __user *uaddr,
> +                            u32 oldval, u32 newval)
>  {
>        int ret;
>
>        asm volatile(
>                "   sacf 256\n"
>                "0: cs   %1,%4,0(%5)\n"
> -               "1: lr   %0,%1\n"
> +               "1: la   %0,0\n"
>                "2: sacf 0\n"
>                EX_TABLE(0b,2b) EX_TABLE(1b,2b)
>                : "=d" (ret), "+d" (oldval), "=m" (*uaddr)
>                : "0" (-EFAULT), "d" (newval), "a" (uaddr), "m" (*uaddr)
>                : "cc", "memory" );
> +       *uval = oldval;
>        return ret;
>  }
>
> diff --git a/arch/sh/include/asm/futex-irq.h b/arch/sh/include/asm/futex-irq.h
> index a9f16a7..6cb9f19 100644
> --- a/arch/sh/include/asm/futex-irq.h
> +++ b/arch/sh/include/asm/futex-irq.h
> @@ -3,7 +3,7 @@
>
>  #include <asm/system.h>
>
> -static inline int atomic_futex_op_xchg_set(int oparg, int __user *uaddr,
> +static inline int atomic_futex_op_xchg_set(int oparg, u32 __user *uaddr,
>                                           int *oldval)
>  {
>        unsigned long flags;
> @@ -20,7 +20,7 @@ static inline int atomic_futex_op_xchg_set(int oparg, int __user *uaddr,
>        return ret;
>  }
>
> -static inline int atomic_futex_op_xchg_add(int oparg, int __user *uaddr,
> +static inline int atomic_futex_op_xchg_add(int oparg, u32 __user *uaddr,
>                                           int *oldval)
>  {
>        unsigned long flags;
> @@ -37,7 +37,7 @@ static inline int atomic_futex_op_xchg_add(int oparg, int __user *uaddr,
>        return ret;
>  }
>
> -static inline int atomic_futex_op_xchg_or(int oparg, int __user *uaddr,
> +static inline int atomic_futex_op_xchg_or(int oparg, u32 __user *uaddr,
>                                          int *oldval)
>  {
>        unsigned long flags;
> @@ -54,7 +54,7 @@ static inline int atomic_futex_op_xchg_or(int oparg, int __user *uaddr,
>        return ret;
>  }
>
> -static inline int atomic_futex_op_xchg_and(int oparg, int __user *uaddr,
> +static inline int atomic_futex_op_xchg_and(int oparg, u32 __user *uaddr,
>                                           int *oldval)
>  {
>        unsigned long flags;
> @@ -71,7 +71,7 @@ static inline int atomic_futex_op_xchg_and(int oparg, int __user *uaddr,
>        return ret;
>  }
>
> -static inline int atomic_futex_op_xchg_xor(int oparg, int __user *uaddr,
> +static inline int atomic_futex_op_xchg_xor(int oparg, u32 __user *uaddr,
>                                           int *oldval)
>  {
>        unsigned long flags;
> @@ -88,11 +88,13 @@ static inline int atomic_futex_op_xchg_xor(int oparg, int __user *uaddr,
>        return ret;
>  }
>
> -static inline int atomic_futex_op_cmpxchg_inatomic(int __user *uaddr,
> -                                                  int oldval, int newval)
> +static inline int atomic_futex_op_cmpxchg_inatomic(u32 *uval,
> +                                                  u32 __user *uaddr,
> +                                                  u32 oldval, u32 newval)
>  {
>        unsigned long flags;
> -       int ret, prev = 0;
> +       int ret;
> +       u32 prev = 0;
>
>        local_irq_save(flags);
>
> @@ -102,10 +104,8 @@ static inline int atomic_futex_op_cmpxchg_inatomic(int __user *uaddr,
>
>        local_irq_restore(flags);
>
> -       if (ret)
> -               return ret;
> -
> -       return prev;
> +       *uval = prev;
> +       return ret;
>  }
>
>  #endif /* __ASM_SH_FUTEX_IRQ_H */
> diff --git a/arch/sh/include/asm/futex.h b/arch/sh/include/asm/futex.h
> index 68256ec..7be39a6 100644
> --- a/arch/sh/include/asm/futex.h
> +++ b/arch/sh/include/asm/futex.h
> @@ -10,7 +10,7 @@
>  /* XXX: UP variants, fix for SH-4A and SMP.. */
>  #include <asm/futex-irq.h>
>
> -static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
> +static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -21,7 +21,7 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();
> @@ -65,12 +65,13 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>  }
>
>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
>  {
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
> -       return atomic_futex_op_cmpxchg_inatomic(uaddr, oldval, newval);
> +       return atomic_futex_op_cmpxchg_inatomic(uval, uaddr, oldval, newval);
>  }
>
>  #endif /* __KERNEL__ */
> diff --git a/arch/sparc/include/asm/futex_64.h b/arch/sparc/include/asm/futex_64.h
> index 47f9583..444e7be 100644
> --- a/arch/sparc/include/asm/futex_64.h
> +++ b/arch/sparc/include/asm/futex_64.h
> @@ -30,7 +30,7 @@
>        : "r" (uaddr), "r" (oparg), "i" (-EFAULT)       \
>        : "memory")
>
> -static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
> +static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -38,7 +38,7 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>        int cmparg = (encoded_op << 20) >> 20;
>        int oldval = 0, ret, tem;
>
> -       if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(int))))
> +       if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
>                return -EFAULT;
>        if (unlikely((((unsigned long) uaddr) & 0x3UL)))
>                return -EINVAL;
> @@ -85,26 +85,30 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>  }
>
>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
>  {
> +       int ret = 0;
> +
>        __asm__ __volatile__(
> -       "\n1:   casa    [%3] %%asi, %2, %0\n"
> +       "\n1:   casa    [%4] %%asi, %3, %1\n"
>        "2:\n"
>        "       .section .fixup,#alloc,#execinstr\n"
>        "       .align  4\n"
>        "3:     sethi   %%hi(2b), %0\n"
>        "       jmpl    %0 + %%lo(2b), %%g0\n"
> -       "        mov    %4, %0\n"
> +       "       mov     %5, %0\n"
>        "       .previous\n"
>        "       .section __ex_table,\"a\"\n"
>        "       .align  4\n"
>        "       .word   1b, 3b\n"
>        "       .previous\n"
> -       : "=r" (newval)
> -       : "0" (newval), "r" (oldval), "r" (uaddr), "i" (-EFAULT)
> +       : "+r" (ret), "=r" (newval)
> +       : "1" (newval), "r" (oldval), "r" (uaddr), "i" (-EFAULT)
>        : "memory");
>
> -       return newval;
> +       *uval = newval;
> +       return ret;
>  }
>
>  #endif /* !(_SPARC64_FUTEX_H) */
> diff --git a/arch/tile/include/asm/futex.h b/arch/tile/include/asm/futex.h
> index fe0d10d..d03ec12 100644
> --- a/arch/tile/include/asm/futex.h
> +++ b/arch/tile/include/asm/futex.h
> @@ -29,16 +29,16 @@
>  #include <linux/uaccess.h>
>  #include <linux/errno.h>
>
> -extern struct __get_user futex_set(int __user *v, int i);
> -extern struct __get_user futex_add(int __user *v, int n);
> -extern struct __get_user futex_or(int __user *v, int n);
> -extern struct __get_user futex_andn(int __user *v, int n);
> -extern struct __get_user futex_cmpxchg(int __user *v, int o, int n);
> +extern struct __get_user futex_set(u32 __user *v, int i);
> +extern struct __get_user futex_add(u32 __user *v, int n);
> +extern struct __get_user futex_or(u32 __user *v, int n);
> +extern struct __get_user futex_andn(u32 __user *v, int n);
> +extern struct __get_user futex_cmpxchg(u32 __user *v, int o, int n);
>
>  #ifndef __tilegx__
> -extern struct __get_user futex_xor(int __user *v, int n);
> +extern struct __get_user futex_xor(u32 __user *v, int n);
>  #else
> -static inline struct __get_user futex_xor(int __user *uaddr, int n)
> +static inline struct __get_user futex_xor(u32 __user *uaddr, int n)
>  {
>        struct __get_user asm_ret = __get_user_4(uaddr);
>        if (!asm_ret.err) {
> @@ -53,7 +53,7 @@ static inline struct __get_user futex_xor(int __user *uaddr, int n)
>  }
>  #endif
>
> -static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
> +static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -65,7 +65,7 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();
> @@ -119,16 +119,17 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>        return ret;
>  }
>
> -static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
> -                                               int newval)
> +static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                                               u32 oldval, u32 newval)
>  {
>        struct __get_user asm_ret;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        asm_ret = futex_cmpxchg(uaddr, oldval, newval);
> -       return asm_ret.err ? asm_ret.err : asm_ret.val;
> +       *uval = asm_ret.val;
> +       return asm_ret.err;
>  }
>
>  #ifndef __tilegx__
> diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
> index 1f11ce4..d09bb03 100644
> --- a/arch/x86/include/asm/futex.h
> +++ b/arch/x86/include/asm/futex.h
> @@ -37,7 +37,7 @@
>                       "+m" (*uaddr), "=&r" (tem)               \
>                     : "r" (oparg), "i" (-EFAULT), "1" (0))
>
> -static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
> +static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -48,7 +48,7 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>  #if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
> @@ -109,9 +109,10 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
>        return ret;
>  }
>
> -static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
> -                                               int newval)
> +static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                                               u32 oldval, u32 newval)
>  {
> +       int ret = 0;
>
>  #if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
>        /* Real i386 machines have no cmpxchg instruction */
> @@ -119,21 +120,22 @@ static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
>                return -ENOSYS;
>  #endif
>
> -       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
> -       asm volatile("1:\t" LOCK_PREFIX "cmpxchgl %3, %1\n"
> +       asm volatile("1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"
>                     "2:\t.section .fixup, \"ax\"\n"
> -                    "3:\tmov     %2, %0\n"
> +                    "3:\tmov     %3, %0\n"
>                     "\tjmp     2b\n"
>                     "\t.previous\n"
>                     _ASM_EXTABLE(1b, 3b)
> -                    : "=a" (oldval), "+m" (*uaddr)
> -                    : "i" (-EFAULT), "r" (newval), "0" (oldval)
> +                    : "+r" (ret), "=a" (oldval), "+m" (*uaddr)
> +                    : "i" (-EFAULT), "r" (newval), "1" (oldval)
>                     : "memory"
>        );
>
> -       return oldval;
> +       *uval = oldval;
> +       return ret;
>  }
>
>  #endif
> diff --git a/include/asm-generic/futex.h b/include/asm-generic/futex.h
> index 3c2344f..01f227e 100644
> --- a/include/asm-generic/futex.h
> +++ b/include/asm-generic/futex.h
> @@ -6,7 +6,7 @@
>  #include <asm/errno.h>
>
>  static inline int
> -futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
> +futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
>  {
>        int op = (encoded_op >> 28) & 7;
>        int cmp = (encoded_op >> 24) & 15;
> @@ -16,7 +16,7 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
>                oparg = 1 << oparg;
>
> -       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
> +       if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
>                return -EFAULT;
>
>        pagefault_disable();
> @@ -48,7 +48,8 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
>  }
>
>  static inline int
> -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
>  {
>        return -ENOSYS;
>  }
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 3184d3b..53b783f 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -381,15 +381,16 @@ static struct futex_q *futex_top_waiter(struct futex_hash_bucket *hb,
>        return NULL;
>  }
>
> -static u32 cmpxchg_futex_value_locked(u32 __user *uaddr, u32 uval, u32 newval)
> +static int cmpxchg_futex_value_locked(u32 *curval, u32 __user *uaddr,
> +                                     u32 uval, u32 newval)
>  {
> -       u32 curval;
> +       int ret;
>
>        pagefault_disable();
> -       curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
> +       ret = futex_atomic_cmpxchg_inatomic(curval, uaddr, uval, newval);
>        pagefault_enable();
>
> -       return curval;
> +       return ret;
>  }
>
>  static int get_futex_value_locked(u32 *dest, u32 __user *from)
> @@ -688,9 +689,7 @@ retry:
>        if (set_waiters)
>                newval |= FUTEX_WAITERS;
>
> -       curval = cmpxchg_futex_value_locked(uaddr, 0, newval);
> -
> -       if (unlikely(curval == -EFAULT))
> +       if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, 0, newval)))
>                return -EFAULT;
>
>        /*
> @@ -728,9 +727,7 @@ retry:
>                lock_taken = 1;
>        }
>
> -       curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
> -
> -       if (unlikely(curval == -EFAULT))
> +       if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
>                return -EFAULT;
>        if (unlikely(curval != uval))
>                goto retry;
> @@ -843,9 +840,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
>
>                newval = FUTEX_WAITERS | task_pid_vnr(new_owner);
>
> -               curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
> -
> -               if (curval == -EFAULT)
> +               if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
>                        ret = -EFAULT;
>                else if (curval != uval)
>                        ret = -EINVAL;
> @@ -880,10 +875,8 @@ static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
>         * There is no waiter, so we unlock the futex. The owner died
>         * bit has not to be preserved here. We are the owner:
>         */
> -       oldval = cmpxchg_futex_value_locked(uaddr, uval, 0);
> -
> -       if (oldval == -EFAULT)
> -               return oldval;
> +       if (cmpxchg_futex_value_locked(&oldval, uaddr, uval, 0))
> +               return -EFAULT;
>        if (oldval != uval)
>                return -EAGAIN;
>
> @@ -1578,9 +1571,7 @@ retry:
>        while (1) {
>                newval = (uval & FUTEX_OWNER_DIED) | newtid;
>
> -               curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
> -
> -               if (curval == -EFAULT)
> +               if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
>                        goto handle_fault;
>                if (curval == uval)
>                        break;
> @@ -2073,11 +2064,9 @@ retry:
>         * again. If it succeeds then we can return without waking
>         * anyone else up:
>         */
> -       if (!(uval & FUTEX_OWNER_DIED))
> -               uval = cmpxchg_futex_value_locked(uaddr, task_pid_vnr(current), 0);
> -
> -
> -       if (unlikely(uval == -EFAULT))
> +       if (!(uval & FUTEX_OWNER_DIED) &&
> +           unlikely(cmpxchg_futex_value_locked(&uval, uaddr,
> +                                               task_pid_vnr(current), 0)))
>                goto pi_faulted;
>        /*
>         * Rare case: we managed to release the lock atomically,
> @@ -2464,9 +2453,7 @@ retry:
>                 * userspace.
>                 */
>                mval = (uval & FUTEX_WAITERS) | FUTEX_OWNER_DIED;
> -               nval = futex_atomic_cmpxchg_inatomic(uaddr, uval, mval);
> -
> -               if (nval == -EFAULT)
> +               if (futex_atomic_cmpxchg_inatomic(&nval, uaddr, uval, mval))
>                        return -1;
>
>                if (nval != uval)
> @@ -2679,8 +2666,7 @@ static int __init futex_init(void)
>         * implementation, the non-functional ones will return
>         * -ENOSYS.
>         */
> -       curval = cmpxchg_futex_value_locked(NULL, 0, 0);
> -       if (curval == -EFAULT)
> +       if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
>                futex_cmpxchg_enabled = 1;
>
>        for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
>
>
> --
> Michel "Walken" Lespinasse
> A program is never fully debugged until the last user dies.
>



-- 
Darren Hart
