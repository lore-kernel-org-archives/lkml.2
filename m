Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415Ab2DLJms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 05:42:48 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:14437 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756600Ab2DLJmq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 05:42:46 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz9371I1432N98dKzz1202hzz8275bhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2D1N2-02-0CQ-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: Clemens Ladisch <clemens@ladisch.de>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Topic: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Index: Ac0P7b5dm37XnMCsR726LS+rxvQKd///odaAgANgVTOAA464hf/+uc3QgAIOroCACN1x5v//GEGQ
Date: Thu, 12 Apr 2012 09:42:36 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE043A33D37@SCYBEXDAG02.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
 <20120401121943.GA11893@gmail.com>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com>
 <20120403075245.GD26826@gmail.com> <4F7DA8FD.1020909@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9E45@SCYBEXDAG02.amd.com>
 <4F7EC111.4010608@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9ED2@SCYBEXDAG02.amd.com>
 <20120409184538.GE2430@linux.vnet.ibm.com>
 <491D6B4EAD0A714894D8AD22F4BDE043A33A9E@SCYBEXDAG02.amd.com>
 <20120411173006.GB2473@linux.vnet.ibm.com>
In-Reply-To: <20120411173006.GB2473@linux.vnet.ibm.com>
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

On Thu, Apr 12, 2012 at 1:30 AM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Apr 11, 2012 at 05:04:03AM +0000, Chen, Dennis (SRDC SW) wrote:
>>
>> Paul, I must confess that maybe you're right, I've realized the misunderstanding in the previous email.
>> But I don't want to pretend that I have a full understanding for your " There is almost certainly a
>> better solution to any problem that might be solved by a per-jiffy call to set_need_resched()", because
>> this is related with your last question.
>>
>> I just want to measure the performance between semaphore and mutex, before that I looked at the mutex
>> optimization code, and the focus is on the mutex_spin_on_owner() function, I don't know how long it will
>> take before some components in the kernel call set_need_resched() to break the while loop. If it's on
>> jiffies level, given the time of a process switch possibly in microsecond level, that means current
>> process must spin for several jiffies before it got the mutex lock or go to sleep finally, I can't
>> see the benefit here...
>
> The loop spins only while a given task owns the lock.  This means that
> for the loop to spin for several jiffies, one of three things must happen:
>
> 1.      The task holding the lock has been running continuously for
>        several jiffies.  This would very likely be a bug.  (Why are
>        you running CPU bound in the kernel for several jiffies,
>        whether or not you are holding a lock?)

I think mutex_lock is not the same as spin_lock, so it's not reasonable to add the time restriction
for the lock user...though maybe most owners of the lock release it very quickly in real life

>
> 2.      The task spinning in mutex_spin_on_owner() happens to be being
>        preempted at exactly the same times as the owner is, and so
>        by poor luck happens to always see the owner running.
>
>        The probability of this is quite low, should (famous last words!)
>        can be safely ignored.
>
> 3.      The task spinning in mutex_spin_on_owner() happens to be being
>        preempted at exactly the same times that the owner releases
>        the lock, and so again by poor luck happens to always see the
>        owner running.
>
>        The probability of this is quite low, should (famous last words!)
>        can be safely ignored.

The preemptive has been disabled at the beginning of the mutex lock slow path, so I guess above 2 and 3
are impossible...

>
> Normally, the lock holder either blocks or releases the lock quickly,
> so that mutex_spin_on_owner() exits its loop...
>
> So, are you seeing a situation where mutex_spin_on_owner() really is
> spinning for multiple jiffies?

I have a test to get the jiffies lasting when someone call set_need_resched() to break the loop:
    ...
    i0 = jiffies;
    rcu_read_lock();
    while(1){
        if (need_resched())
            break;
        cpu_relax();
    }
    rcu_read_unlock();
    i1 = jiffies;
    printk("i0 = %ld, i1 = %ld, HZ=%d\n", i0, i1, HZ);
    ...
The result is, in the case of HZ=1000, i1-i0 will be in [1,...,5] range randomly. So if we exit the while loop
on need_resched(), that means the optimization of mutex comparing semaphore doesn't success: mutex spins about 
several jiffies before goto sleep or get the lock finally,right? 

If lucky enough, maybe in 99% case we break the loop by owner_running(lock, owner), meaning the lock owner release
the lock in a very quick speed (can't be measured by jiffies). 

>
>                                                        Thanx, Paul


