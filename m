Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab2LVCsC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:48:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab2LVCsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:48:00 -0500
Message-ID: <50D52037.60602@redhat.com>
Date: Fri, 21 Dec 2012 21:51:35 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3] x86,smp: auto tune spinlock backoff delay factor
References: <20121221184940.103c31ad@annuminas.surriel.com> <20121221185147.4ae48ab5@annuminas.surriel.com> <50D5033A.2070309@gmail.com>
In-Reply-To: <50D5033A.2070309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 07:47 PM, David Daney wrote:

>> +#define MIN_SPINLOCK_DELAY 1
>> +#define MAX_SPINLOCK_DELAY 1000
>> +DEFINE_PER_CPU(int, spinlock_delay) = { MIN_SPINLOCK_DELAY };
>
>
> This gives the same delay for all locks in the system, but the amount of
> work done under each lock is different.  So, for any given lock, the
> delay is not optimal.
>
> This is an untested idea that came to me after looking at this:
>
> o Assume that for any given lock, the optimal delay is the same for all
> CPUs in the system.
 >
> o Store a per-lock delay value in arch_spinlock_t.
>
> o Once a CPU owns the lock it can update the delay as you do for the
> per_cpu version.  Tuning the delay on fewer of the locking operations
> reduces bus traffic, but makes it converge more slowly.
>
> o Bonus points if you can update the delay as part of the releasing store.

It would absolutely have to be part of the same load and
store cycle, otherwise we would increase bus traffic and
defeat the purpose.

However, since spinlock contention should not be the
usual state, and all a scalable lock does is make sure
that N+1 CPUs does not perform worse than N CPUs, using
scalable locks is a stop-gap measure.

I believe a stop-gap measure should be kept as simple as
we can. I am willing to consider moving to a per-lock
delay factor if we can figure out an easy way to do it,
but I would like to avoid too much extra complexity...
