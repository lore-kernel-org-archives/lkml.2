Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab2DKFEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:04:16 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:42327
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929Ab2DKFEP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:04:15 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz9371I179dN1432N98dKzz1202hzz8275bhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2AU2V-02-1AD-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: Clemens Ladisch <clemens@ladisch.de>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Topic: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Index: Ac0P7b5dm37XnMCsR726LS+rxvQKd///odaAgANgVTOAA464hf/+uc3QgAIOroCABc15Wv/9yK4Q
Date: Wed, 11 Apr 2012 05:04:03 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE043A33A9E@SCYBEXDAG02.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
 <20120401121943.GA11893@gmail.com>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com>
 <20120403075245.GD26826@gmail.com> <4F7DA8FD.1020909@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9E45@SCYBEXDAG02.amd.com>
 <4F7EC111.4010608@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9ED2@SCYBEXDAG02.amd.com>
 <20120409184538.GE2430@linux.vnet.ibm.com>
In-Reply-To: <20120409184538.GE2430@linux.vnet.ibm.com>
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

On Tue, Apr 10, 2012 at 2:45 AM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Apr 06, 2012 at 05:47:28PM +0000, Chen, Dennis (SRDC SW) wrote:
>> On Fri, Apr 6, 2012 at 6:10 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
>> > Chen, Dennis (SRDC SW) wrote:
>> >
>> > "On the internet, nobody can hear you being subtle."
>> >
>> > If some other process wants to run on the same CPU, needs_resched() is set.
>> > (This might happen to make the cursor blink, for keyboard input, or when
>> > somebody starts a rogue process like ps.)
>> >
>>
>> Hmm, I forget that in each timer interrupt, __rcu_pending() will be called, it will call
>> set_need_resched() to set the TIF_NEED_RESCHED in some condition...
>> The optimization of mutex work closely with rcu, so fantastic!
>
> I must confess that you all lost me on this one.
>
> There is a call to set_need_resched() in __rcu_pending(), which is
> invoked when the current CPU has not yet responded to a non-preemptible
> RCU grace period for some time.  However, in the common case where the
> CPUs all respond in reasonable time, __rcu_pending() will never call
> set_need_resched().
>
> However, we really do not want to call set_need_resched() on every call
> to __rcu_pending().  There is almost certainly a better solution to any
> problem that might be solved by a per-jiffy call to set_need_resched().
>
> So, what are you really trying to do?
>
>                                                        Thanx, Paul

Paul, I must confess that maybe you're right, I've realized the misunderstanding in the previous email.
But I don't want to pretend that I have a full understanding for your " There is almost certainly a 
better solution to any problem that might be solved by a per-jiffy call to set_need_resched()", because
this is related with your last question.

I just want to measure the performance between semaphore and mutex, before that I looked at the mutex 
optimization code, and the focus is on the mutex_spin_on_owner() function, I don't know how long it will
take before some components in the kernel call set_need_resched() to break the while loop. If it's on
jiffies level, given the time of a process switch possibly in microsecond level, that means current 
process must spin for several jiffies before it got the mutex lock or go to sleep finally, I can't
see the benefit here... 

