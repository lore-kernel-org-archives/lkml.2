Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1BWXwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:52:53 -0500
Received: from www.tglx.de ([62.245.132.106]:56013 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab1BWXww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:52:52 -0500
Message-Id: <20110223231601.613115832@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 23 Feb 2011 23:52:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 0/5] genirq: Forced threaded interrupt handlers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some time ago when the threaded interrupt handlers infrastructure was
about to be merged, Andrew asked me where that command line switch was
which magically runs all interrupt handlers and the softirqs in
threads.

While we were doing that brute force in preempt-rt for quite a while
it took some time to come up with a reasonable non intrusive
implementation for mainline. We also had to find a solution which fits
Linus' recently issued "palatable Trojan horse" requirement (see:
https://lwn.net/Articles/370998/).

The gift of this patch series is the ability to add "threadirqs" to
the kernel command line and magically (almost) all interrupt handlers
- except those which are explicitely marked IRQF_NO_THREAD - are
confined into threads along with all soft interrupts.

That allows to enhance the debugability of the kernel as a bug in an
interrupt handler is not necessarily taking the whole machine
down. It's just the particular irq thread which goes into nirwana. Bad
luck if that's the one which is crucial to retrieve the bug report,
but in most cases - yes, I analysed quite a lot of bugzilla reports -
it will be helpful for reporters not to be forced to transcribe the
bug from the screen.

An architecture has to enable that feature in Kconfig via a selectable
option which says: Yes, we marked all interrupts which never can be
threaded - like IPIs etc. - as IRQF_NO_THREAD. All interrupts marked
IRQF_TIMER or IRQF_PER_CPU are automatically excluded from threading.

A side effect of this is, that the long standing request of supporting
oneshot threaded handlers on shared interrupt lines (given that all
drivers agree) is now possible. I know, that this is nuts, but
unfortunately common sense and basic understanding of the problem
seems to be not required when HW folks are set out to save a gate.

Thanks,

	tglx
---
 Documentation/kernel-parameters.txt |    4 +
 include/linux/interrupt.h           |   13 +++
 include/linux/irqdesc.h             |    2 
 kernel/irq/Kconfig                  |    3 
 kernel/irq/handle.c                 |   34 +++++----
 kernel/irq/internals.h              |    2 
 kernel/irq/manage.c                 |  128 +++++++++++++++++++++++++++++++-----
 kernel/sched.c                      |    5 +
 kernel/softirq.c                    |   16 +++-
 9 files changed, 175 insertions(+), 32 deletions(-)

