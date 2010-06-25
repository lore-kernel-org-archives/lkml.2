Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab0FYXfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 19:35:23 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58904 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab0FYXfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 19:35:21 -0400
Message-ID: <4C253D32.6040304@us.ibm.com>
Date: Fri, 25 Jun 2010 16:35:14 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: futex: race in lock and unlock&exit for robust futex with PI?
References: <20100623091307.GA11072@tiehlicka.suse.cz> <4C2417AA.4030306@us.ibm.com> <20100625082711.GA32765@tiehlicka.suse.cz> <4C24ED34.9040808@us.ibm.com>
In-Reply-To: <4C24ED34.9040808@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 10:53 AM, Darren Hart wrote:
> On 06/25/2010 01:27 AM, Michal Hocko wrote:
>> On Thu 24-06-10 19:42:50, Darren Hart wrote:
>>> On 06/23/2010 02:13 AM, Michal Hocko wrote:

>>>> attached you can find a simple test case which fails quite easily on 
>>>> the
>>>> following glibc assert:
>>>> "SharedMutexTest: pthread_mutex_lock.c:289: __pthread_mutex_lock:
>>>> Assertion `(-(e)) != 3 || !robust' failed." "
>>>
>>> I've run runSimple.sh in a tight loop for a couple hours (about 2k
>>> iterations so far) and haven't seen anything other than "Here we go"
>>> printed to the console.
>>
>> Maybe a higher load on CPUs would help (busy loop on other CPUs).
> 
> Must have been a build issue. I can reproduce _something_ now. Within 10 
> iterations of runSimple.sh the test hangs. ps shows all the simple 
> processes sitting in pause.
> 
> (gdb) bt
> #0 0x0000003c0060e030 in __pause_nocancel () from /lib64/libpthread.so.0
> #1 0x0000003c006085fc in __pthread_mutex_lock_full ()
> from /lib64/libpthread.so.0
> #2 0x0000000000400cd6 in main (argc=1, argv=0x7fffc016e508) at simple.c:101
> 
> There is only one call to pause* in pthread_mutex_lock.c: (line ~316):
> 
> /* ESRCH can happen only for non-robust PI mutexes where
> the owner of the lock died. */
> assert (INTERNAL_SYSCALL_ERRNO (e, __err) != ESRCH || !robust);
> 
> /* Delay the thread indefinitely. */
> while (1)
> pause_not_cancel ();
> 
> Right now I'm thinking that NDEBUG is set in my build for whatever 
> reason, but I think I'm seeing the same issue you are. I'll review the 
> futex code and prepare a trace patch and see if I can reproduce with that.
> 
> Note: confirmed, the glibc rpm has -DNDEBUG=1

The simple tracing patch (below) confirms that we are indeed returning
-ESRCH to userspace from futex_lock_pi(). Notice that the pids of the
two "simple" processes lingering after the runSimple.sh script are the
ones that return -ESRCH to userspace, and therefor end up in the
pause_not_cancel() trap inside glibc.

# trace-cmd record -p nop ./runSimple.sh 
<snip>

# ps -eLo pid,comm,wchan | grep "simple "
20636 simple          pause
20876 simple          pause

# trace-cmd report
version = 6
CPU 0 is empty
cpus=4
field->offset = 24 size=8
           <...>-20636 [003]  1778.965860: bprint:               futex_lock_pi_atomic : lookup_pi_state: -ESRCH
           <...>-20636 [003]  1778.965865: bprint:               futex_lock_pi_atomic : ownerdied not detected, returning -ESRCH
           <...>-20636 [003]  1778.965866: bprint:               futex_lock_pi_atomic : lookup_pi_state: -3
>>--->     <...>-20636 [003]  1778.965867: bprint:               futex_lock_pi : returning -ESRCH to userspace
           <...>-20876 [001]  1780.199394: bprint:               futex_lock_pi_atomic : cmpxchg failed, retrying
           <...>-20876 [001]  1780.199400: bprint:               futex_lock_pi_atomic : lookup_pi_state: -ESRCH
           <...>-20876 [001]  1780.199401: bprint:               futex_lock_pi_atomic : ownerdied not detected, returning -ESRCH
           <...>-20876 [001]  1780.199402: bprint:               futex_lock_pi_atomic : lookup_pi_state: -3
>>--->     <...>-20876 [001]  1780.199403: bprint:               futex_lock_pi : returning -ESRCH to userspace
           <...>-21316 [002]  1782.300695: bprint:               futex_lock_pi_atomic : cmpxchg failed, retrying
           <...>-21316 [002]  1782.300698: bprint:               futex_lock_pi_atomic : cmpxchg failed, retrying

Attaching gdb to 20636, we can see the state of the mutex:
(gdb) print (struct __pthread_mutex_s)*mutex
$1 = {__lock = 0, __count = 1, __owner = 0, __nusers = 0, __kind = 176, __spins = 0, __list = {__prev = 0x0, __next = 0x0}}

This is consistent with hex dump of the first bits of the backing file:
# xxd test.file | head -n 3
0000000: 0000 0000 0100 0000 0000 0000 0000 0000  ................
0000010: b000 0000 0000 0000 0000 0000 0000 0000  ................
0000020: 0000 0000 0000 0000 0000 0000 0000 0000  ................

The futex (__lock) value is 0, indicating it is unlocked and has no waiters. The count being 1 however suggests a task has acquired it once, which, if I read the glibc source correctly, means the owner field and __lock fields should not be 0. This supports Michal's thought about lock racing with unlock, seeing it's held, then unable to find the owner (pi_state) as it has since been unlocked. Possibly some horkage with the WAITERS bit leading to glibc performing atomic acquistions/releases and rendering the mutex inconsistent with the kernel's view. This should be protected against, but that is the direction I am going to start looking.

--
Darren Hart

>From 92014a07df73489460ff788274506255ff0f775d Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Fri, 25 Jun 2010 13:54:25 -0700
Subject: [PATCH] robust pi futex tracing

---
 kernel/futex.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e7a35f1..24ac437 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -683,6 +683,8 @@ retry:
 	 */
 	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
 		/* Keep the OWNER_DIED bit */
+		if (ownerdied)
+			trace_printk("ownerdied, taking over lock\n");
 		newval = (curval & ~FUTEX_TID_MASK) | task_pid_vnr(task);
 		ownerdied = 0;
 		lock_taken = 1;
@@ -692,14 +694,18 @@ retry:
 
 	if (unlikely(curval == -EFAULT))
 		return -EFAULT;
-	if (unlikely(curval != uval))
+	if (unlikely(curval != uval)) {
+		trace_printk("cmpxchg failed, retrying\n");
 		goto retry;
+	}
 
 	/*
 	 * We took the lock due to owner died take over.
 	 */
-	if (unlikely(lock_taken))
+	if (unlikely(lock_taken)) {
+		trace_printk("ownerdied, lock acquired, return 1\n");
 		return 1;
+	}
 
 	/*
 	 * We dont have the lock. Look up the PI state (or create it if
@@ -710,13 +716,16 @@ retry:
 	if (unlikely(ret)) {
 		switch (ret) {
 		case -ESRCH:
+			trace_printk("lookup_pi_state: -ESRCH\n");
 			/*
 			 * No owner found for this futex. Check if the
 			 * OWNER_DIED bit is set to figure out whether
 			 * this is a robust futex or not.
 			 */
-			if (get_futex_value_locked(&curval, uaddr))
+			if (get_futex_value_locked(&curval, uaddr)) {
+				trace_printk("get_futex_value_locked: -EFAULT\n");
 				return -EFAULT;
+			}
 
 			/*
 			 * We simply start over in case of a robust
@@ -724,10 +733,13 @@ retry:
 			 * and return happy.
 			 */
 			if (curval & FUTEX_OWNER_DIED) {
+				trace_printk("ownerdied, goto retry\n");
 				ownerdied = 1;
 				goto retry;
 			}
+			trace_printk("ownerdied not detected, returning -ESRCH\n");
 		default:
+			trace_printk("lookup_pi_state: %d\n", ret);
 			break;
 		}
 	}
@@ -1950,6 +1962,8 @@ retry_private:
 			put_futex_key(fshared, &q.key);
 			cond_resched();
 			goto retry;
+		case -ESRCH:
+			trace_printk("returning -ESRCH to userspace\n");
 		default:
 			goto out_unlock_put_key;
 		}
@@ -2537,8 +2551,10 @@ void exit_robust_list(struct task_struct *curr)
 		/*
 		 * Avoid excessively long or circular lists:
 		 */
-		if (!--limit)
+		if (!--limit) {
+			trace_printk("excessively long list, aborting\n");
 			break;
+		}
 
 		cond_resched();
 	}
-- 
1.7.0.4

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
