Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab0GJRax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 13:30:53 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51774 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0GJRav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 13:30:51 -0400
Message-ID: <4C38AE46.2090803@us.ibm.com>
Date: Sat, 10 Jul 2010 10:30:46 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Mike Galbraith <efault@gmx.de>, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 2/4 V2] rtmutex: add BUG_ON if a task attempts to block
 on two locks
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com> <1278714780-788-3-git-send-email-dvhltc@us.ibm.com> <1278721825.1537.171.camel@gandalf.stny.rr.com>
In-Reply-To: <1278721825.1537.171.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 05:30 PM, Steven Rostedt wrote:
> On Fri, 2010-07-09 at 15:32 -0700, Darren Hart wrote:
>> rtmutex proxy locking complicates the logic a bit and opens up
>> the possibility for a task to wake and attempt to take another
>> sleeping lock without knowing it has been enqueued on another
>> lock already. Add a BUG_ON to catch this scenario early.
>>
>> Signed-off-by: Darren Hart<dvhltc@us.ibm.com>
>> Cc: Thomas Gleixner<tglx@linutronix.de>
>> Cc: Peter Zijlstra<peterz@infradead.org>
>> Cc: Ingo Molnar<mingo@elte.hu>
>> Cc: Eric Dumazet<eric.dumazet@gmail.com>
>> Cc: John Kacur<jkacur@redhat.com>
>> Cc: Steven Rostedt<rostedt@goodmis.org>
>> Cc: Mike Galbraith<efault@gmx.de>
>> ---
>>   kernel/rtmutex.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
>> index baac7d9..22f9d18 100644
>> --- a/kernel/rtmutex.c
>> +++ b/kernel/rtmutex.c
>> @@ -459,6 +459,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
>>   		top_waiter = rt_mutex_top_waiter(lock);
>>   	plist_add(&waiter->list_entry,&lock->wait_list);
>>
>> +	/* Tasks can only block on one lock at a time. */
>> +	BUG_ON(task->pi_blocked_on != NULL);
> 
> WARN_ON may be better. Since it may not cause a system crash or other
> huge bug if it is not true.
> 

No objection.


>From 31c7b6c5657bcc897ddc79d7f9bb1942eb4c854a Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Fri, 9 Jul 2010 17:46:05 -0400
Subject: [PATCH 2/4] rtmutex: add WARN_ON if a task attempts to block on two locks

rtmutex proxy locking complicates the logic a bit and opens up
the possibility for a task to wake and attempt to take another
sleeping lock without knowing it has been enqueued on another
lock already. Add a WARN_ON to catch this scenario early.

V2: use a WARN_ON instead of a BUG_ON per Steven's request.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/rtmutex.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index baac7d9..5262d0f 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -459,6 +459,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 		top_waiter = rt_mutex_top_waiter(lock);
 	plist_add(&waiter->list_entry, &lock->wait_list);
 
+	/* Tasks can only block on one lock at a time. */
+	WARN_ON(task->pi_blocked_on != NULL);
+
 	task->pi_blocked_on = waiter;
 
 	raw_spin_unlock(&task->pi_lock);
-- 
1.7.0.4

