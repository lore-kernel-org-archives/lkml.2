Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab0LIXqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:46:44 -0500
Received: from smtp-out.google.com ([216.239.44.51]:36040 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab0LIXqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:46:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Dtl94oEUaaOndGcvhqTJbLG9kEci7UIwr/c6x+PEnC6TI5i/y94mcgvv4/Wwa/FQWv
         Xra652n2eUV88fSY2Qew==
MIME-Version: 1.0
In-Reply-To: <1291922467.6803.44.camel@twins>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
	<1291922467.6803.44.camel@twins>
Date: Fri, 10 Dec 2010 00:46:40 +0100
Message-ID: <AANLkTinanAQYQvwtowTzJ0bpLRUvp-5sqF6M9PoMSJR-@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So I have tested this patch a bit on WSM and as I expected there
are issues with sampling.

When HT is on, both siblings CPUs get the interrupt. The HW does not
allow you to only point interrupts to a single HT thread (CPU).

I did verify that indeed both threads get the interrupt and that you have a
race condition. Both sibling CPUs stop uncore, get the status. They may get
the same overflow status. Both will pass the uncore->active_mask because
it's shared among siblings cores. Thus,  you have a race for the whole
interrupt handler execution.

You need some serialization in there. But the patch does not address this.
The problem is different from the back-to-back interrupt issue that
Don worked on.
The per-cpu marked/handled trick cannot work to avoid this problem.

You cannot simply say "the lowest indexed" CPU of a sibling pair
handles the interrupt
because you don't know if this in an uncore intr, core interrupt or
something else. You
need to check. That means each HT thread needs to check uncore
ovfl_status. IF the
status is zero, then return. Otherwise, you need to do a 2nd level
check before you can
execute the handler. You need to know if the sibling CPU has already
"consumed" that
interrupt.

I think you need some sort of generation counter per physical core and
per HT thread.
On interrupt, you could do something along the line of:
      if (mycpu->intr_count == mysibling->intr_count) {
          then mycpu->intr_count++
          execute intr_handler()
      } else {
          mycpu->intr_count++
          return;
      }
Of course, the above needs some atomicity and ad locking (but I don't
think you can
use locks in NMI context).

This makes me wonder if vectoring uncore to NMI is really needed,
given you cannot
correlated to an IP, incl. a kernel IP. If we were to vector to a
dedicated (lower prio)
vector, then we could use the trick of saying the lowest indexed CPU in a pair
handles the interrupt (because we would already know this is an uncore
interrupt).
This would be much simpler. Price: not samples in kernel's critical
section. But those
are useless anyway with uncore events.

- uncore_get_status().
  PERF_GLOBAL_STATUS contains more than overflow
  status, bit 61-63 need to be masked off.

- uncore_pmu_cpu_prepare()
  I don't understand the x86_max_cores < 2 test. If you run your
  NHM/WSM is single core mode, you still have uncore to deal with
  thus, you need cpuc->intel_uncore initialized, don't you?

- I assume that the reason the uncore->refcnt management is not
  using atomic ops because the whole CPU hotplug is serialized, right?
