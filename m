Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2LKBQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 20:16:24 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:11881
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab2LKBQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 20:16:22 -0500
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI1432Izz1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h947hd25hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1758h1765h1155h)
Message-ID: <50C68922.5030203@am.sony.com>
Date: Mon, 10 Dec 2012 17:15:14 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH RT 3/4] sched/rt: Use IPI to trigger RT task push
 migration instead of pulling
References: <20121207235615.206108556@goodmis.org> <20121208000900.613917378@goodmis.org> <50C682F6.5030709@am.sony.com>
In-Reply-To: <50C682F6.5030709@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/12 16:48, Frank Rowand wrote:
> On 12/07/12 15:56, Steven Rostedt wrote:
>> When debugging the latencies on a 40 core box, where we hit 300 to
>> 500 microsecond latencies, I found there was a huge contention on the
>> runqueue locks.
>>
>> Investigating it further, running ftrace, I found that it was due to
>> the pulling of RT tasks.
>>
>> The test that was run was the following:
>>
>>  cyclictest --numa -p95 -m -d0 -i100
>>
>> This created a thread on each CPU, that would set its wakeup in interations
>> of 100 microseconds. The -d0 means that all the threads had the same
>> interval (100us). Each thread sleeps for 100us and wakes up and measures
>> its latencies.
>>
>> What happened was another RT task would be scheduled on one of the CPUs
>> that was running our test, when the other CPUS test went to sleep and
>> scheduled idle. This cause the "pull" operation to execute on all
>> these CPUs. Each one of these saw the RT task that was overloaded on
>> the CPU of the test that was still running, and each one tried
>> to grab that task in a thundering herd way.
>>
>> To grab the task, each thread would do a double rq lock grab, grabbing
>> its own lock as well as the rq of the overloaded CPU. As the sched
>> domains on this box was rather flat for its size, I saw up to 12 CPUs
>> block on this lock at once. This caused a ripple affect with the
>> rq locks. As these locks were blocked, any wakeups on these CPUs
>> would also block on these locks, and the wait time escalated.
>>
>> I've tried various methods to lesson the load, but things like an
>> atomic counter to only let one CPU grab the task wont work, because
>> the task may have a limited affinity, and we may pick the wrong
>> CPU to take that lock and do the pull, to only find out that the
>> CPU we picked isn't in the task's affinity.
> 
> You are saying that the pulling CPU might not be in the pulled task's
> affinity?  But isn't that checked:
> 
>   pull_rt_task()
>      pick_next_highest_task_rt()
>         pick_rt_task()
>            if ( ... || cpumask_test_cpu(cpu, tsk_cpus_allowed(p) ...
> 
>>
>> Instead of doing the PULL, I now have the CPUs that want the pull to
>> send over an IPI to the overloaded CPU, and let that CPU pick what
>> CPU to push the task to. No more need to grab the rq lock, and the
>> push/pull algorithm still works fine.
> 
> That gives me the opposite of a warm fuzzy feeling.  Processing an IPI
> on the overloaded CPU is not free (I'm being ARM-centric), and this is
> putting more load on the already overloaded CPU.

I should have also mentioned some previous experience using IPIs to
avoid runq lock contention on wake up.  Someone encountered IPI
storms when using the TTWU_QUEUE feature, thus it defaults to off
for CONFIG_PREEMPT_RT_FULL:

  #ifndef CONFIG_PREEMPT_RT_FULL
  /*
   * Queue remote wakeups on the target CPU and process them
   * using the scheduler IPI. Reduces rq->lock contention/bounces.
   */
  SCHED_FEAT(TTWU_QUEUE, true)
  #else
  SCHED_FEAT(TTWU_QUEUE, false)

-Frank



