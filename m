Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab2DEIhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:37:54 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:40104
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab2DEIhw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:37:52 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz9371I1803M1432N98dKzz1202hzz8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1ZZZ0-01-2JN-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: RE: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Topic: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Index: Ac0P7b5dm37XnMCsR726LS+rxvQKd///odaAgANgVTP//OeGsA==
Date: Thu, 5 Apr 2012 08:37:46 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE0439F98F4@SCYBEXDAG02.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
 <20120401121943.GA11893@gmail.com>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com>
 <20120403075245.GD26826@gmail.com>
In-Reply-To: <20120403075245.GD26826@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 3:52 PM, Ingo Molnar <mingo@kernel.org> wrote:
> I'm not sure what the point of comparative measurements with
> semaphores would be: for example we don't have per architecture
> optimized semaphores anymore, we switched the legacy semaphores
> to a generic version and are phasing them out.
>

About the point, very simple, I am very curious about the mutex performance 
optimization (actually I am curious about almost everything in the kernel :)
I know that the rationale of the mutex's optimization is, if the lock owner is 
running, it's likely to release the lock soon. So make the waiter to spin a 
short time waiting for the lock to be released is reasonable given the workload 
of a process switch.

But how about if the lock owner running doesn't release the lock soon? Will it
degrade the mutex performance comparing with semaphore?
Look at the below code in mutex slow path:

int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
{
	if (!sched_feat(OWNER_SPIN))
		return 0;

	rcu_read_lock();
	while (owner_running(lock, owner)) {
		if (need_resched())
			break;

		arch_mutex_cpu_relax();
	}
	rcu_read_unlock();

	/*
	 * We break out the loop above on need_resched() and when the
	 * owner changed, which is a sign for heavy contention. Return
	 * success only when lock->owner is NULL.
	 */
	return lock->owner == NULL;
}

According to the codes, I guess probably the waiter will busy wait in the while loop. 
So I made an experiment:
1. write a simple character device kernel module. Add a busy wait for 2 minutes 
between the mutex_lock/mutex_unlock in its read function like this:

xxx_read(){
    /* 2 minutes */
    unsigned long j = jiffies + 120 * HZ; 
    mutex_lock(&c_mutex);
    while(time_before(jiffies, j))
        cpu_relax();
    mutex_unlock(&c_mutex);
}

2. write an Application to open and read this device, I startup the App in 2 
different CPUs almost the same time:
# taskset 0x00000001 ./main
# taskset 0x00000002 ./main

The App in CPU0 will get the mutex lock and running about 2 minutes to release the lock, 
according the mutex_spin_on_owner(), I guess the App in CPU1 will run in the while loop, 
but the ps command output:

root     30197  0.0  0.0   4024   324 pts/2    R+   11:30   0:00 ./main
root     30198  0.0  0.0   4024   324 pts/0    D+   11:30   0:00 ./main

D+ means the App in CPU1 is sleeping in a UNINTERRUPTIBLE state. This is very interesting,
How does this happen? I check my kernel config, the CONFIG_MUTEX_SPIN_ON_OWNER is 
Set and '/sys/kernel/debug# cat sched_features' output:
... ICK LB_BIAS OWNER_SPIN NONTASK_POWER TTWU_QUEUE NO_FORCE_SD_OVERLAP

I know I must have some misunderstanding of the code, but I don't know where it is...

> Mutexes have various advantages (such as lockdep coverage and in
> general tighter semantics that makes their usage more robust)

Yes, I agree.

> and we aren't going back to semaphores.
>
> What would make a ton of sense would be to create a 'perf bench'
> module that would use the kernel's mutex code and would measure
> it in user-space. 'perf bench mem' already does a simplified
>
> So if you'd be interested in writing that brand new benchmarking
> feature and need help then let the perf people know.

Thanks Ingo for the info, it's already in my TODO list of the benchmarking feature for
some kernel feature...


