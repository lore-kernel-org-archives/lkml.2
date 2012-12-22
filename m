Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2LVCyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:54:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2LVCyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:54:09 -0500
Message-ID: <50D521A4.7050509@redhat.com>
Date: Fri, 21 Dec 2012 21:57:40 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
References: <20121221184940.103c31ad@annuminas.surriel.com>  <20121221185147.4ae48ab5@annuminas.surriel.com>  <20121221185613.1f4c9523@annuminas.surriel.com> <1356137332.21834.8155.camel@edumazet-glaptop>
In-Reply-To: <1356137332.21834.8155.camel@edumazet-glaptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 07:48 PM, Eric Dumazet wrote:
> On Fri, 2012-12-21 at 18:56 -0500, Rik van Riel wrote:
>> Argh, the first one had a typo in it that did not influence
>> performance with fewer threads running, but that made things
>> worse with more than a dozen threads...
>>
>> Please let me know if you can break these patches.
>> ---8<---
>> Subject: x86,smp: auto tune spinlock backoff delay factor
>
>> +#define MIN_SPINLOCK_DELAY 1
>> +#define MAX_SPINLOCK_DELAY 1000
>> +DEFINE_PER_CPU(int, spinlock_delay) = { MIN_SPINLOCK_DELAY };
>
> Using a single spinlock_delay per cpu assumes there is a single
> contended spinlock on the machine, or that contended
> spinlocks protect the same critical section.

The goal is to reduce bus traffic, and keep total
system performance from falling through the floor.

If we have one lock that takes N cycles to acquire,
and a second contended lock that takes N*2 cycles
to acquire, checking the first lock fewer times
before acquisition, and the second lock more times,
should still result in similar average system
throughput.

I suspect this approach should work well if we have
multiple contended locks in the system.

> Given that we probably know where the contended spinlocks are, couldnt
> we use a real scalable implementation for them ?

The scalable locks tend to have a slightly more
complex locking API, resulting in a slightly
higher overhead in the non-contended (normal)
case.  That means we cannot use them everywhere.

Also, scalable locks merely make sure that N+1
CPUs perform the same as N CPUs when there is
lock contention.  They do not cause the system
to actually scale.

For actual scalability, the data structure would
need to be changed, so locking requirements are
better.

> A known contended one is the Qdisc lock in network layer. We added a
> second lock (busylock) to lower a bit the pressure on a separate cache
> line, but a scalable lock would be much better...

My locking patches are meant for dealing with the
offenders we do not know about, to make sure that
system performance does not fall off a cliff when
we run into a surprise.

Known scalability bugs we can fix.

Unknown ones should not cause somebody's system
to fail.

> I guess there are patent issues...

At least one of the scalable lock implementations has been
known since 1991, so there should not be any patent issues
with that one.

