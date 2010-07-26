Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0GZIxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:53:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61844 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0GZIxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:53:18 -0400
Message-ID: <4C4D4C2E.8010103@monstr.eu>
Date: Mon, 26 Jul 2010 10:49:50 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Subject: Re: [PATCH] asm-generic: Use raw_local_irq_save/restore instead local_irq_save/restore
References: <1274863724-14906-1-git-send-email-monstr@monstr.eu>	<1274863724-14906-2-git-send-email-monstr@monstr.eu>	<1274884963.22648.245.camel@gandalf.stny.rr.com> <20100526100805.171b3c48.akpm@linux-foundation.org>
In-Reply-To: <20100526100805.171b3c48.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------060002050301040704000104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060002050301040704000104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Wed, 26 May 2010 10:42:43 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Wed, 2010-05-26 at 10:48 +0200, monstr@monstr.eu wrote:
>>> From: Michal Simek <monstr@monstr.eu>
>>>
>>> start/stop_critical_timing function for preemptirqsoff, preemptoff
>>> and irqsoff tracers contains atomic_inc and atomic_dec operations.
>>>
>>> Atomic operations used local_irq_save/restore macros to ensure
>>> atomic access but they are traced by the same function which is causing
>>> recursion problem.
>>>
>>> The reason is when these tracers are turn ON then local_irq_save/restore
>>> macros are changed in include/linux/irqflags.h to call trace_hardirqs_on/off
>>> which call start/stop_critical_timing.
>>>
>>> Microblaze was affected because use generic atomic implementation.
>>>
>>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>>
> 
> Sighed-at-by: me.
> 
>>> diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
>>> index 058129e..6c190fd 100644
>>> --- a/include/asm-generic/atomic.h
>>> +++ b/include/asm-generic/atomic.h
>>> @@ -57,11 +57,11 @@ static inline int atomic_add_return(int i, atomic_t *v)
>>>  	unsigned long flags;
>>>  	int temp;
>>>  
>>> -	local_irq_save(flags);
>>> +	raw_local_irq_save(flags);
>>>  	temp = v->counter;
>>>  	temp += i;
>>>  	v->counter = temp;
>>> -	local_irq_restore(flags);
>>> +	raw_local_irq_restore(flags);
>>>  
>>>  	return temp;
>>>  }
> 
> If a developer looks at atomic_add_return() and asks himself "why did
> this use raw_local_irq_save()", the only way of answering that question
> is to go groveling through the git logs, which is a right PITA if
> you're trying to get some coding work done.
> 
> Guys, any time you add code which is non-obvious at the raw C level, it
> *needs* a comment!

Andrew: Can you please add this patch to your tree? I have it in 
microblaze next branch but should go through different tree.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian

--------------060002050301040704000104
Content-Type: text/x-patch;
 name="0001-asm-generic-Use-raw_local_irq_save-restore-instead.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-asm-generic-Use-raw_local_irq_save-restore-instead.patc";
 filename*1="h"

>From 06c2447c8939227b4c4d3340fba1c712f03e70ca Mon Sep 17 00:00:00 2001
From: Michal Simek <monstr@monstr.eu>
Date: Wed, 26 May 2010 08:57:36 +0200
Subject: [PATCH] asm-generic: Use raw_local_irq_save/restore instead local_irq_save/restore

start/stop_critical_timing function for preemptirqsoff, preemptoff
and irqsoff tracers contains atomic_inc and atomic_dec operations.

Atomic operations used local_irq_save/restore macros to ensure
atomic access but they are traced by the same function which is causing
recursion problem.

The reason is when these tracers are turn ON then local_irq_save/restore
macros are changed in include/linux/irqflags.h to call trace_hardirqs_on/off
which call start/stop_critical_timing.

Microblaze was affected because use generic atomic implementation.

Signed-off-by: Michal Simek <monstr@monstr.eu>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/asm-generic/atomic.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 058129e..e53347f 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -57,11 +57,11 @@ static inline int atomic_add_return(int i, atomic_t *v)
 	unsigned long flags;
 	int temp;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
 	temp = v->counter;
 	temp += i;
 	v->counter = temp;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 
 	return temp;
 }
@@ -78,11 +78,11 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 	unsigned long flags;
 	int temp;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
 	temp = v->counter;
 	temp -= i;
 	v->counter = temp;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 
 	return temp;
 }
@@ -135,9 +135,9 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 	unsigned long flags;
 
 	mask = ~mask;
-	local_irq_save(flags);
+	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
 	*addr &= mask;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 }
 
 #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
-- 
1.5.5.6


--------------060002050301040704000104--
