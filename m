Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0LRQNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 11:13:13 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:57588 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab0LRQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 11:13:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F8lPszhPlOJWX2Ak4GjhAzzk1jH+BpCJWkLZ/kWrFr1EH7KS5LzCHl50e0AfwOASoe
         5nsOX2lQIKe4NiipTczxFIFGrz6SdhzPEIyGJotIKGyqhJLtAOLPg6POLLDuYBBq1t8X
         KOsh+pFiNwt4VE2UTEw1ohDScxtsh6uYFlKdg=
Message-ID: <4D0CDD93.7040907@kernel.org>
Date: Sat, 18 Dec 2010 17:13:07 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 13/20] rcu: increase synchronize_sched_expedited()
 batching
References: <20101217205433.GA10199@linux.vnet.ibm.com> <1292619291-2468-13-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1292619291-2468-13-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/17/2010 09:54 PM, Paul E. McKenney wrote:
> From: Tejun Heo <tj@kernel.org>
> 
> The fix in commit #6a0cc49 requires more than three concurrent instances
> of synchronize_sched_expedited() before batching is possible.  This
> patch uses a ticket-counter-like approach that is also not unrelated to
> Lai Jiangshan's Ring RCU to allow sharing of expedited grace periods even
> when there are only two concurrent instances of synchronize_sched_expedited().
> 
> This commit builds on Tejun's original posting, which may be found at
> http://lkml.org/lkml/2010/11/9/204, adding memory barriers, avoiding
> overflow of signed integers (other than via atomic_t), and fixing the
> detection of batching.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Tejun Heo <tj@kernel.org>

Some comments on the sequence testing tho.

> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 49e8e16..af56148 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -47,6 +47,8 @@
>  extern int rcutorture_runnable; /* for sysctl */
>  #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
>  
> +#define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
> +#define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
>  #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
>  #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))

I don't think the original comparison had overflow problem.  (a) < (b)
gives the wrong result on overflow but (int)((a) - (b)) < 0 is
correct.

I find the latter approach cleaner and that way the constant in the
instruction can be avoided too although if the compiler might generate
the same code regardless.

Also, I think the names are misleading.  They aren't testing whether
one is greater or less than the other.  They're testing whether one is
before or after the other where the counters are used as monotonically
incrementing (with wrapping) sequence, so wouldn't something like the
following be better?

#define SEQ_TEST(a, b, test_op)	({					\
	typeof(a) __seq_a = (a);					\
	typeof(b) __seq_b = (b);					\
	bool __ret;							\
	(void)(&__seq_a == &__seq_b);					\
	switch (sizeof(__seq_a)) {					\
		case sizeof(char):					\
			__ret = (char)(__seq_a - __seq_b) test_op 0;	\
			break;						\
		case sizeof(int):					\
			__ret = (int)(__seq_a - __seq_b) test_op 0;	\
			break;						\
		case sizeof(long):					\
			__ret = (long)(__seq_a - __seq_b) test_op 0;	\
			break;						\
		case sizeof(long long):					\
			__ret = (long long)(__seq_a - __seq_b) test_op 0; \
			break;						\
		default:						\
			__make_build_fail;				\
	}								\
	__ret;								\
})

#define SEQ_BEFORE(a, b)	SEQ_TEST((a), (b), <)
 and so on...

Please note that the above macro is completely untested.

Thanks.

-- 
tejun
