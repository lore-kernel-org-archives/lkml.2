Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab0LSJnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 04:43:53 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:46551 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab0LSJnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 04:43:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FjbsaWiD3ikJTYZyqrnGYk29YwkXYZUTeLxkOotGw130YVp9bWQ2Fbsve5zCismlpq
         sSx9si/RwY872tEPlrGIRxinVNZ5zuUeWa2tOhvQCGd4qHNmmCQiHBSWYMnBL5jcyKIC
         PMadOH/CxcL0ZV9xXZhgLDX4R9lWX5MA0AuKI=
Message-ID: <4D0DD3D2.4030606@kernel.org>
Date: Sun, 19 Dec 2010 10:43:46 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 13/20] rcu: increase synchronize_sched_expedited()
 batching
References: <20101217205433.GA10199@linux.vnet.ibm.com> <1292619291-2468-13-git-send-email-paulmck@linux.vnet.ibm.com> <4D0CDD93.7040907@kernel.org> <20101218201419.GD2143@linux.vnet.ibm.com>
In-Reply-To: <20101218201419.GD2143@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/18/2010 09:14 PM, Paul E. McKenney wrote:
>>> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
>>> index 49e8e16..af56148 100644
>>> --- a/include/linux/rcupdate.h
>>> +++ b/include/linux/rcupdate.h
>>> @@ -47,6 +47,8 @@
>>>  extern int rcutorture_runnable; /* for sysctl */
>>>  #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
>>>  
>>> +#define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
>>> +#define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
>>>  #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
>>>  #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
>>
>> I don't think the original comparison had overflow problem.  (a) < (b)
>> gives the wrong result on overflow but (int)((a) - (b)) < 0 is
>> correct.
> 
> You are right that it does give the correct result now, but the C
> standard never has defined overflow for signed integers, as noted in
> Section 6.3.1.3p3 of the N1494 Working Draft of the C standard:
> 
> 	Otherwise, the new type is signed and the value cannot be
> 	represented in it; either the result is implementation-defined
> 	or an implementation-defined signal is raised.
> 
> I have heard too many compiler guys gleefully discussing optimizations
> that they could use if they took full advantage of this clause, so I
> am not comfortable relying on the intuitive semantics for signed
> arithmetic.  (Now atomic_t is another story -- both C and C++ will
> be requiring twos-complement semantics, thankfully.)
>
>> I find the latter approach cleaner and that way the constant in the
>> instruction can be avoided too although if the compiler might generate
>> the same code regardless.
> 
> I would like your way better if it was defined in the C standard.
> But it unfortunately is not.  :-(

I see, then would something like the following work?

 (int)((unsigned)(a) - (unsigned)(b)) < 0

>> Also, I think the names are misleading.  They aren't testing whether
>> one is greater or less than the other.  They're testing whether one is
>> before or after the other where the counters are used as monotonically
>> incrementing (with wrapping) sequence, so wouldn't something like the
>> following be better?
> 
> They are comparing the twos-complement difference between the two
> numbers against zero.

But still GE/LT are way too misleading.  Anyways, so with the above
change the macro now would look like the following.

#define SEQ_TEST(a, b, op)	({					\
	typeof(a) __seq_a = (a);					\
	typeof(b) __seq_b = (b);					\
	bool __ret;							\
	(void)(&__seq_a == &__seq_b);					\
	switch (sizeof(__seq_a)) {					\
		case sizeof(s8):					\
			__ret = (s8)((u8)__seq_a - (u8)__seq_b) op 0;	\
			break;						\
		case sizeof(s16):					\
			__ret = (s16)((u16)__seq_a - (u16)__seq_b) op 0;\
			break;						\
		case sizeof(s32):					\
			__ret = (s32)((u32)__seq_a - (u32)__seq_b) op 0;\
			break;						\
		case sizeof(s64):					\
			__ret = (s64)((u64)__seq_a - (u64)__seq_b) op 0;\
			break;						\
		default:						\
			__make_build_fail;				\
	}								\
	__ret;								\
})

Would the above work?

Thanks.

-- 
tejun
