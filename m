Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0LSQgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 11:36:00 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51774 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab0LSQf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 11:35:59 -0500
Date: Sun, 19 Dec 2010 08:35:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 13/20] rcu: increase
 synchronize_sched_expedited() batching
Message-ID: <20101219163552.GF2143@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101217205433.GA10199@linux.vnet.ibm.com>
 <1292619291-2468-13-git-send-email-paulmck@linux.vnet.ibm.com>
 <4D0CDD93.7040907@kernel.org>
 <20101218201419.GD2143@linux.vnet.ibm.com>
 <4D0DD3D2.4030606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0DD3D2.4030606@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 10:43:46AM +0100, Tejun Heo wrote:
> Hello,
> 
> On 12/18/2010 09:14 PM, Paul E. McKenney wrote:
> >>> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> >>> index 49e8e16..af56148 100644
> >>> --- a/include/linux/rcupdate.h
> >>> +++ b/include/linux/rcupdate.h
> >>> @@ -47,6 +47,8 @@
> >>>  extern int rcutorture_runnable; /* for sysctl */
> >>>  #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
> >>>  
> >>> +#define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
> >>> +#define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
> >>>  #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
> >>>  #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
> >>
> >> I don't think the original comparison had overflow problem.  (a) < (b)
> >> gives the wrong result on overflow but (int)((a) - (b)) < 0 is
> >> correct.
> > 
> > You are right that it does give the correct result now, but the C
> > standard never has defined overflow for signed integers, as noted in
> > Section 6.3.1.3p3 of the N1494 Working Draft of the C standard:
> > 
> > 	Otherwise, the new type is signed and the value cannot be
> > 	represented in it; either the result is implementation-defined
> > 	or an implementation-defined signal is raised.
> > 
> > I have heard too many compiler guys gleefully discussing optimizations
> > that they could use if they took full advantage of this clause, so I
> > am not comfortable relying on the intuitive semantics for signed
> > arithmetic.  (Now atomic_t is another story -- both C and C++ will
> > be requiring twos-complement semantics, thankfully.)
> >
> >> I find the latter approach cleaner and that way the constant in the
> >> instruction can be avoided too although if the compiler might generate
> >> the same code regardless.
> > 
> > I would like your way better if it was defined in the C standard.
> > But it unfortunately is not.  :-(
> 
> I see, then would something like the following work?
> 
>  (int)((unsigned)(a) - (unsigned)(b)) < 0

Unfortunately, no.  :-(

The (int) converts from unsigned to signed, and if the upper bit of
the unsigned difference is non-zero, then the paragraph I quoted above
applies, and the standard allows the compiler to do whatever it wants.

> >> Also, I think the names are misleading.  They aren't testing whether
> >> one is greater or less than the other.  They're testing whether one is
> >> before or after the other where the counters are used as monotonically
> >> incrementing (with wrapping) sequence, so wouldn't something like the
> >> following be better?
> > 
> > They are comparing the twos-complement difference between the two
> > numbers against zero.
> 
> But still GE/LT are way too misleading.  Anyways, so with the above
> change the macro now would look like the following.

I am not all that worried about the names.  I can certainly live with
SEQ_TEST() just as easily as I can live with the current names.

> #define SEQ_TEST(a, b, op)	({					\
> 	typeof(a) __seq_a = (a);					\
> 	typeof(b) __seq_b = (b);					\
> 	bool __ret;							\
> 	(void)(&__seq_a == &__seq_b);					\
> 	switch (sizeof(__seq_a)) {					\
> 		case sizeof(s8):					\
> 			__ret = (s8)((u8)__seq_a - (u8)__seq_b) op 0;	\
> 			break;						\
> 		case sizeof(s16):					\
> 			__ret = (s16)((u16)__seq_a - (u16)__seq_b) op 0;\
> 			break;						\
> 		case sizeof(s32):					\
> 			__ret = (s32)((u32)__seq_a - (u32)__seq_b) op 0;\
> 			break;						\
> 		case sizeof(s64):					\
> 			__ret = (s64)((u64)__seq_a - (u64)__seq_b) op 0;\
> 			break;						\
> 		default:						\
> 			__make_build_fail;				\
> 	}								\
> 	__ret;								\
> })
> 
> Would the above work?

Again, unfortunately, no.  The (s8), (s16), (s32), and (s64) casts result
in implementation-defined behavior when the top bit of the difference is
set, just as with (int) above.

To remain within the confines of the standard, the entire computation
needs to be done using unsigned arithmetic.  One way to do this might
be something like the following:

#define U8_MAX		((u8)(~0U))
#define U16_MAX		((u16)(~0U))
#define U32_MAX		((u32)(~0UL))
#define U64_MAX		((u64)(~0ULL))

#define SEQ_TEST(a, b, op)	({					\
	typeof(a) __seq_a = (a);					\
	typeof(b) __seq_b = (b);					\
	bool __ret;							\
	(void)(&__seq_a == &__seq_b);					\
	switch (sizeof(__seq_a)) {					\
		case sizeof(s8):					\
			__ret = (U8_MAX / 2 op (u8)__seq_a - (u8)__seq_b);\
			break;						\
		case sizeof(s16):					\
			__ret = (U16_MAX / 2 op (u16)__seq_a - (u16)__seq_b);\
			break;						\
		case sizeof(s32):					\
			__ret = (U32_MAX / 2 op (u32)__seq_a - (u32)__seq_b);\
			break;						\
		case sizeof(s64):					\
			__ret = (U64_MAX / 2 op (u64)__seq_a - (u64)__seq_b);\
			break;						\
		default:						\
			__make_build_fail;				\
	}								\
	__ret;								\
})

Make sense?

							Thanx, Paul
