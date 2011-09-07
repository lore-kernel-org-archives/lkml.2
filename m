Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1IGDDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 23:03:16 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37952 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab1IGDDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 23:03:11 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dK179dN1432N98dKzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E66DE31.6060101@am.sony.com>
Date: Tue, 6 Sep 2011 20:00:01 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-rt-users <linux-rt-users@vger.kernel.org>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Venkatesh Pallipadi <venki@google.com>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
References: <1313232790.25267.7.camel@twins> <4E559039.8060209@am.sony.com> <20110826235507.GJ2342@linux.vnet.ibm.com> <4E66DCAB.8090801@am.sony.com>
In-Reply-To: <4E66DCAB.8090801@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/11 19:53, Frank Rowand wrote:
> On 08/26/11 16:55, Paul E. McKenney wrote:
>> On Wed, Aug 24, 2011 at 04:58:49PM -0700, Frank Rowand wrote:
>>> On 08/13/11 03:53, Peter Zijlstra wrote:
>>>>
>>>> Whee, I can skip release announcements too!
>>>>
>>>> So no the subject ain't no mistake its not, 3.0.1-rt11 is there for the
>>>> grabs.
> 
> < snip >
> 
>>> I have a consistent (every boot) hang on boot.  With a few
>>> hacks to get console output, I get the
>>>
>>>   rcu_preempt_state detected stalls on CPUs/tasks
> 
> < snip >
> 
>>> This is an ARM NaviEngine (out of tree, so I also have applied
>>> a series of pages for platform support).
>>>
>>> CONFIG_PREEMPT_RT_FULL is set.  Full config is attached.
> 
> I have also replicated the problem on the ARM RealView (in tree) and
> without the RT patches.
> 
>>
>> Hmmm...  The last few that I have seen that looked like this were
>> due to my messing up rcutorture so that the RCU-boost testing kthreads
>> ran CPU-bound at real-time priority.
>>
>> Is it possible that something similar is happening on your system?
>>
>>                                                         Thanx, Paul
> 
> The problem ended up being caused by the allowed cpus mask being set
> to all possible cpus for the ksoftirqd on the secondary processors.
> So the RCU softirq was never executing on cpu 2.
> 
> I'll test the following patch on 3.1 tomorrow.


And the following patch is some clean up for code that is in the
RT patch.  I do not know if this is needed, but after making the
changes in my first patch it seemed reasonable to add some extra
checks here, just in case softirq_check_pending_idle() gets
called in the window before the variable ksoftirqd gets set.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 kernel/softirq.c |   25 	14 +	11 -	0 !
 1 file changed, 14 insertions(+), 11 deletions(-)

Index: b/kernel/softirq.c
===================================================================
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -87,18 +87,21 @@ void softirq_check_pending_idle(void)
 		struct task_struct *tsk;
 
 		tsk = __get_cpu_var(ksoftirqd);
-		/*
-		 * The wakeup code in rtmutex.c wakes up the task
-		 * _before_ it sets pi_blocked_on to NULL under
-		 * tsk->pi_lock. So we need to check for both: state
-		 * and pi_blocked_on.
-		 */
-		raw_spin_lock(&tsk->pi_lock);
+		if (tsk) {
+			/*
+			 * The wakeup code in rtmutex.c wakes up the task
+			 * _before_ it sets pi_blocked_on to NULL under
+			 * tsk->pi_lock. So we need to check for both: state
+			 * and pi_blocked_on.
+			 */
+			raw_spin_lock(&tsk->pi_lock);
+
+			if (!tsk->pi_blocked_on &&
+			    !(tsk->state == TASK_RUNNING))
+				warnpending = 1;
 
-		if (!tsk->pi_blocked_on && !(tsk->state == TASK_RUNNING))
-			warnpending = 1;
-
-		raw_spin_unlock(&tsk->pi_lock);
+			raw_spin_unlock(&tsk->pi_lock);
+		}
 	}
 
 	if (warnpending) {

