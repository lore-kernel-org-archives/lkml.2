Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0DEUYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:24:24 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36707 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab0DEUYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:24:19 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive spinning
Date: Mon,  5 Apr 2010 13:23:53 -0700
Message-Id: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In-Reply-To: 

NOT FOR INCLUSION

The following patch series implements a new experimental kernel side futex mutex
via new FUTEX_LOCK and FUTEX_LOCK_ADAPTIVE futex op codes. The adaptive spin
follows the kernel mutex model of allowing one spinner until the lock is
released or the owner is descheduled. The patch currently allows the user to
specify if they want no spinning, a single adaptive spinner, or multiple
spinners (aggressive adaptive spinning, or aas... which I have mistyped as "ass"
enough times to realize a better term is indeed required :-).

I'm using the futex_lock branch of my futextest test suite to gather results.
The test is performance/futex_lock.c and can be checked out here:

git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/futextest.git

Per Avi's suggestion I added asm instruction based period and duty-cycle options
to do some testing. A series of plots with 256 threads, one per period length,
is shown at the URL below. Each plot compares raw futex lock (normal, no
spinning) with a single spinner (adaptive) and with multiple spinners (aas) for
each of several duty-cycles to determine performance at various levels of
contention. The test measure the number of lock/unlock pairs performed per
second (in thousands).

http://www.kernel.org/pub/linux/kernel/people/dvhart/adaptive_futex/v4/

Avi's suggested starting point was 1000 instructions with a 10% duty cycle.
That plot "Futex Lock/Unlock (Period=1000, Threads=256)" does appear to be the
most interesting of the lot. It's not so short that other overhead becomes the
bottleneck, and not so long so as to make adaptive spinning benefits show up
as noise in the numbers. The adaptive spin (with a single waiter) consistently
beats the normal run, and outperforms aas for most duty-cycles. I rechecked a
few points on this plot to confirm and the relative scores remained consistent.
These plots were generated using 10,000,000 iterations per datapoint.

Lastly, I should mention that these results all underperform a simple
pthread_mutex_lock()/pthread_mutex_unlock() pair. I'm looking into why but felt
I was overdue in sharing what I have to date. A test comparing this to a
sched_yield() style userspace spinlock would probably be more appropraite.

Thanks,

Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

