Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1BAFrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 00:47:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132Ab1BAFrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 00:47:24 -0500
MIME-Version: 1.0
In-Reply-To: <20110201044517.GC2158@linux.vnet.ibm.com>
References: <smp-call-function-peter-reply@mdm.bga.com> <smp-call-function-move-writes@mdm.bga.com>
 <1296145360.15234.234.camel@laptop> <smp-call-function-list-race@mdm.bga.com>
 <smp-call-function-list-race-fix@mdm.bga.com> <1296508677.26581.84.camel@laptop>
 <1296519764.2349.325.camel@pasglop> <AANLkTikEo4Bbqn27nCO_xjwEuy9rkoqBjoOb_HeGw18D@mail.gmail.com>
 <20110201021831.GB2158@linux.vnet.ibm.com> <AANLkTimb7bpTa0fO2VU4pSxO-a3-eQNA6zA_ikAReXsQ@mail.gmail.com>
 <20110201044517.GC2158@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 1 Feb 2011 15:46:26 +1000
Message-ID: <AANLkTikZXh4NbwTCj22dTAEjnNjtEdGtQpTDChw=fckN@mail.gmail.com>
Subject: Re: call_function_many: fix list delete vs add race
To: paulmck@linux.vnet.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>, Milton Miller <miltonm@bga.com>,
        akpm@linux-foundation.org, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 2:45 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Feb 01, 2011 at 12:43:56PM +1000, Linus Torvalds wrote:
>>
>> That said, I do think that if your memory ordering is much weaker than
>> x86, you are going to see bugs that most testers don't see, and it
>> simply might not be worth it.
>
> IBM's CPUs do split the difference, with s390 having somewhat stronger
> ordering than x86, and with powerpc being rather weaker

I'm not talking about memory ordering as done by the cpu, but as done
by the spinlock operations. They can be arbitrarily strong, even if
the CPU architecture itself might be weakly ordered.

So what I suggest is that even if you have a CPU that can implement
acquire/release operations on the locks, you should at least think
about making a lock/unlock sequence be at least a full memory barrier,
simply because it is on x86.

And on at least alpha, with its famously weak memory ordering, you
actually have to do that, because the weak memory ordering of the
normal memory operations are coupled with rather bad memory ordering
primitives.

So on alpha, both LOCK and UNLOCK  are full memory barriers
_individually_, not even paired. So despite being known for being
weakly ordered, alpha is actually the MOST STRONGLY ordered of all
when it comes to spinlock primitives, and doesn't have any notion at
all of "inside" vs "outside" the lock or anything like that. A
spinlock/unlock sequence contains TWO full memory barriers, not just
one.

So "weak memory ordering" in no way means "weak lock ordering". Quite
often it means the reverse. POWER, as you say, has weak memory
ordering on the actual memory ops (like alpha), but like alpha has
traditionally really quite crappy and bad synchronization primitives.

So don't confuse the two. When talking about spinlocks, don't confuse
the memory ordering for non-locked operations with the memory ordering
for the locks themselves. The two are totally independent, and often
weak ordering on the normal memory operations actually is associated
with just total idiotic crap on the synchronization primitives. Most
of them were designed when threading and locking wasn't seen as a big
issue, and before people understood that serialization is a big deal.

(You can tell how ia64 was designed later, for example, by looking at
its fancy serialization primitives.)

Quite frankly, the POWER case is made worse by the fact that the
synchronization primitives have this total confusion about "pipeline"
synchronization due to historical implementation oddities etc. Talk
about crazy. The whole "isync" vs "sync" vs "lwsync" thing is just an
embarrassment. But this is, after all, a company that ran out of
vowels in instruction naming, so I guess their misleading and confused
naming for memory ordering is just par for the course.

                       Linus
