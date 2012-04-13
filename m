Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2DMOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:16:59 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:21235
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333Ab2DMOQ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:16:56 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz9371I1432N98dK11fbIzz1202hzz8275bhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2F8XQ-02-0Q1-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: Clemens Ladisch <clemens@ladisch.de>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Topic: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Index: Ac0P7b5dm37XnMCsR726LS+rxvQKd///odaAgANgVTOAA464hf/+uc3QgAIOroCACN1x5v//GEGQgAHOfYD//gfXMA==
Date: Fri, 13 Apr 2012 14:15:25 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE043A33FD3@SCYBEXDAG02.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com>
 <20120403075245.GD26826@gmail.com> <4F7DA8FD.1020909@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9E45@SCYBEXDAG02.amd.com>
 <4F7EC111.4010608@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9ED2@SCYBEXDAG02.amd.com>
 <20120409184538.GE2430@linux.vnet.ibm.com>
 <491D6B4EAD0A714894D8AD22F4BDE043A33A9E@SCYBEXDAG02.amd.com>
 <20120411173006.GB2473@linux.vnet.ibm.com>
 <491D6B4EAD0A714894D8AD22F4BDE043A33D37@SCYBEXDAG02.amd.com>
 <20120412151854.GB2394@linux.vnet.ibm.com>
In-Reply-To: <20120412151854.GB2394@linux.vnet.ibm.com>
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

On Thu, Apr 12, 2012 at 11:18 PM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Apr 12, 2012 at 09:42:36AM +0000, Chen, Dennis (SRDC SW) wrote:
>> I think mutex_lock is not the same as spin_lock, so it's not reasonable to add the time restriction
>> for the lock user...though maybe most owners of the lock release it very quickly in real life
>
> Yep -- to do otherwise is usually bad for both performance and scalability.
>
>> The preemptive has been disabled at the beginning of the mutex lock slow path, so I guess above 2 and 3
>> are impossible...
>
> Almost.  The guy in mutex_spin_on_owner() might be interrupted at just
> the wrong times, which would have the same effect as being preempted.
> But in both cases, the probability is really low, so it can still be
> safely ignored.
>
>> I have a test to get the jiffies lasting when someone call set_need_resched() to break the loop:
>>     ...
>>     i0 = jiffies;
>>     rcu_read_lock();
>>     while(1){
>>         if (need_resched())
>>             break;
>>         cpu_relax();
>>     }
>>     rcu_read_unlock();
>>     i1 = jiffies;
>>     printk("i0 = %ld, i1 = %ld, HZ=%d\n", i0, i1, HZ);
>>     ...
>> The result is, in the case of HZ=1000, i1-i0 will be in [1,...,5] range randomly. So if we exit the while loop
>> on need_resched(), that means the optimization of mutex comparing semaphore doesn't success: mutex spins about
>> several jiffies before goto sleep or get the lock finally,right?
>
> But this is quite different than mutex_spin_on_owner().  You are doing
> "while(1)" and mutex_spin_on_owner() is doing "while (owner_running(...))".
> This means that mutex_spin_on_owner() will typically stop spinning as
> soon as the owner blocks or releases the mutex.  In contrast, the only
> way your loop can exit is if need_resched() returns true.
>
> Therefore, your results are irrelevant to mutex_spin_on_owner().  If you
> want to show that mutex_spin_on_owner() has a problem, you should
> instrument mutex_spin_on_owner() and run your instrumented version in
> the kernel.

I know that the test is different from mutex_spin_on_owner(), the reason I used while(1) not the actual code instead is
that I want to know how many jiffies will be elapsed when break the loop on need_resched in case of owner running long enough.
If you want to see the test result on mutex_spin_on_owner(), I have the following test case (based on my earlier message
in this thread, you can check if for some background context...):

1. <in a kernel module> in the xxx_read() function, I have the follow code pieces:
    /* idle loop for 5s between the 1st App get the lock and release it
     Unsigned long j = jiffies + 5 * HZ;
    /* identify ourself in the mutex_spin_on_owner function to void tons of printk message
     * The first App will get the mutex lock in fast path, it will not enter into slow path, so it's easy
     * to identify the 2nd App by tricky pid
     */
    current->pid |= (1 << 31);
    mutex_lock(&c_mutex);
    while(time_before(jiffies, j)){
        cpu_relax();
    }
    mutex_unlock(&c_mutex);
    current->pid &= ~(1 << 31);

2. <in the kernel source code> I make some changes in mutex_spin_on_owner as below:
    int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
{
        unsigned long j0, j1; /*add*/
        if (!sched_feat(OWNER_SPIN))
                return 0;

        rcu_read_lock();
        j0 = jiffies; /*add*/
        while (owner_running(lock, owner)) {
                if (need_resched())
                        break;

                arch_mutex_cpu_relax();
        }
        j1 = jiffies;
        rcu_read_unlock();
        if(current->pid & (1 << 31))  /*add*/
                printk("j1-j0=%ld\n", j1-j0); /*add*/
        /*
         * We break out the loop above on need_resched() and when the
         * owner changed, which is a sign for heavy contention. Return
         * success only when lock->owner is NULL.
         */
        return lock->owner == NULL;
}

3. run the Apps in 2 different CPUs (0 and 2):
   #taskset 0x00000001 ./main
   #taskset 0x00000004 ./main
   
  The App running on cpu0 will get the lock directly, and it will in idle loop state for 5s owning the lock,
  So App on cpu2 will enter into slow path and call mutex_spin_on_owner(), thus we can get the delta jiffies
  When the loop break on need_resched(). The test result as below(HZ=1000, I run the test about 6 rounds):
  j1-j0=19    -- NO.1
  j1-j0=512   -- NO.2
  j1-j0=316   -- NO.3
  j1-j0=538   -- NO.4
  j1-j0=331   -- NO.5
  j1-j0=996   -- NO.6

obviously, the mutex will waste lots of CPU resource comparing semaphore in this case.
I know the base rock of mutex performance optimization is "if the lock owner is running, it is likely to
release the lock soon", I don't know if there are some statistics data to support this rational, in other words,
what does make us get this conclusion?

>> If lucky enough, maybe in 99% case we break the loop by owner_running(lock, owner), meaning the lock owner release
>> the lock in a very quick speed (can't be measured by jiffies).
>
> That is in fact the intent of the design.
>
> In theory, possible problems with the current code include:
>
> 1.      Unnecessarily blocking lower-priority tasks.
>
> 2.      Consuming energy spinning when the CPU might otherwise
>        go idle and thus into a low-power state.
>
> But you need to measure the actual code running a realistic workload
> to get a fair diagnosis of any problems that might be present.

Actually, as I mentioned earlier in this thread, I have no intention to care about the code design itself, I am just curious
about the PERFORMANCE OPTIMIZATION of mutex, not others. Now I am writing some simple benchmark code which used to measure 
the real performance of the 2 primitives with realistic workload, hopefully I can finish it in this weekend, I am not familiar
with the user space codes :-)

>
>                                                        Thanx, Paul
>


