Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab1IGCyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 22:54:10 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:33704 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751093Ab1IGCyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 22:54:03 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dK179dN1432N98dKzz1202hzz8275bhz2fh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E66DCAB.8090801@am.sony.com>
Date: Tue, 6 Sep 2011 19:53:31 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Venkatesh Pallipadi <venki@google.com>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
References: <1313232790.25267.7.camel@twins> <4E559039.8060209@am.sony.com> <20110826235507.GJ2342@linux.vnet.ibm.com>
In-Reply-To: <20110826235507.GJ2342@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/11 16:55, Paul E. McKenney wrote:
> On Wed, Aug 24, 2011 at 04:58:49PM -0700, Frank Rowand wrote:
>> On 08/13/11 03:53, Peter Zijlstra wrote:
>>>
>>> Whee, I can skip release announcements too!
>>>
>>> So no the subject ain't no mistake its not, 3.0.1-rt11 is there for the
>>> grabs.

< snip >

>> I have a consistent (every boot) hang on boot.  With a few
>> hacks to get console output, I get the
>>
>>   rcu_preempt_state detected stalls on CPUs/tasks

< snip >

>> This is an ARM NaviEngine (out of tree, so I also have applied
>> a series of pages for platform support).
>>
>> CONFIG_PREEMPT_RT_FULL is set.  Full config is attached.

I have also replicated the problem on the ARM RealView (in tree) and
without the RT patches.

> 
> Hmmm...  The last few that I have seen that looked like this were
> due to my messing up rcutorture so that the RCU-boost testing kthreads
> ran CPU-bound at real-time priority.
> 
> Is it possible that something similar is happening on your system?
> 
>                                                         Thanx, Paul

The problem ended up being caused by the allowed cpus mask being set
to all possible cpus for the ksoftirqd on the secondary processors.
So the RCU softirq was never executing on cpu 2.

I'll test the following patch on 3.1 tomorrow.

-Frank Rowand


Symptom: rcu stall

The problem was that ksoftirqd was woken on the secondary processors before
the secondary processors were online.  This led to allowed cpus being set
to all cpus.

   wake_up_process()
      try_to_wake_up()
         select_task_rq()
            if (... || !cpu_online(cpu))
               select_fallback_rq(task_cpu(p), p)
                  ...
                  /* No more Mr. Nice Guy. */
                  dest_cpu = cpuset_cpus_allowed_fallback(p)
                     do_set_cpus_allowed(p, cpu_possible_mask)
                        #  Thus ksoftirqd can now run on any cpu...


Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 kernel/softirq.c |   19 	14 +	5 -	0 !
 1 file changed, 14 insertions(+), 5 deletions(-)

Index: b/kernel/softirq.c
===================================================================
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -55,6 +55,7 @@ EXPORT_SYMBOL(irq_stat);
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
 DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU(struct task_struct *, ksoftirqd_pending_online);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
@@ -862,28 +863,36 @@ static int __cpuinit cpu_callback(struct
 			return notifier_from_errno(PTR_ERR(p));
 		}
 		kthread_bind(p, hotcpu);
-  		per_cpu(ksoftirqd, hotcpu) = p;
+		per_cpu(ksoftirqd_pending_online, hotcpu) = p;
  		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+		per_cpu(ksoftirqd, hotcpu) =
+			per_cpu(ksoftirqd_pending_online, hotcpu);
+		per_cpu(ksoftirqd_pending_online, hotcpu) = NULL;
 		wake_up_process(per_cpu(ksoftirqd, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
-		if (!per_cpu(ksoftirqd, hotcpu))
+		p = per_cpu(ksoftirqd_pending_online, hotcpu);
+		if (!p)
+			p = per_cpu(ksoftirqd, hotcpu);
+		if (!p)
 			break;
 		/* Unbind so it can run.  Fall thru. */
-		kthread_bind(per_cpu(ksoftirqd, hotcpu),
-			     cpumask_any(cpu_online_mask));
+		kthread_bind(p, cpumask_any(cpu_online_mask));
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN: {
 		static const struct sched_param param = {
 			.sched_priority = MAX_RT_PRIO-1
 		};
 
-		p = per_cpu(ksoftirqd, hotcpu);
+		p = per_cpu(ksoftirqd_pending_online, hotcpu);
+		if (!p)
+			p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
+		per_cpu(ksoftirqd_pending_online, hotcpu) = NULL;
 		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 		kthread_stop(p);
 		takeover_tasklets(hotcpu);

