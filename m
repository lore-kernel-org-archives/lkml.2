Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0DIFQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 01:16:10 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52194 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab0DIFQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:16:06 -0400
From: dvhltc@us.ibm.com
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Ulrich Drepper <drepper@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>
Subject: [PATCH V5 0/4][RFC] futex: FUTEX_LOCK with optional adaptive spinning 
Date: Thu,  8 Apr 2010 22:15:17 -0700
Message-Id: <1270790121-16317-1-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOT FOR INCLUSION

The following patch series implements a new experimental kernel side futex mutex
via new FUTEX_LOCK and FUTEX_LOCK_ADAPTIVE futex op codes. The adaptive spin
allows for multiple spinners until the lock is released or the owner is
descheduled. The patch currently allows the user to specify if they want
spinning or not, but the final version will only provide the adaptive variant as
blocking locks are already very efficiently implemented with the existing
operations.

This version greatly outperforms the last, and actually shows some benefit using
adaptive locks! The primary difference in the implementations was the removal of
any attempt to limit the number of spinners as we have no means to track
spinners. This version also allows spinners to continue spinning if the owner of
a lock changes, and only aborts if the current owner deschedules. Aborting the
spin if the owner changes proved ineffectual as this locking mechanism does a
lot of lock stealing, so many of the loops would be a single cycle, and then
move on to block. Something to note is that the adaptive runs can make
significantly more syscalls than the non-adaptive version, and still show
significant improvement.

Normal Lock
===========
# ./futex_lock -i100000000 -n8 -p1000 -d10 
futex_lock: Measure FUTEX_LOCK operations per second
	Arguments: iterations=100000000 threads=8 adaptive=no
	           period=1000 duty-cycle=10%
Result: 606 Kiter/s
lock calls:      100000000
lock syscalls:   35729444 (35.73%)
unlock calls:    100000000
unlock syscalls: 41740294 (41.74%)

Adaptive Lock
=============
# ./futex_lock -i100000000 -n8 -p1000 -d10 -a
futex_lock: Measure FUTEX_LOCK operations per second
	Arguments: iterations=100000000 threads=8 adaptive=yes
	           period=1000 duty-cycle=10%
Result: 749 Kiter/s
lock calls:      100000000
lock syscalls:   72257679 (72.26%)
unlock calls:    100000000
unlock syscalls: 72265869 (72.27%)

I'm using the futex_lock branch of my futextest test suite to gather results.
The test is performance/futex_lock.c and can be checked out here:

git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/futextest.git

At Avi's suggestion, I prepared plots of multiple thread counts, they are
available at the URL below. These plots are all from runs with a period of 1000
instructions, with one plot per each of several duty-cycles.

http://www.kernel.org/pub/linux/kernel/people/dvhart/adaptive_futex/v5/1000-period/plots.html

Now that an advantage can be shown using FUTEX_LOCK_ADAPTIVE over FUTEX_LOCK,
the next steps as I see them are:

o Try and show improvement of FUTEX_LOCK_ADAPTIVE over FUTEX_WAIT based
  implementations (pthread_mutex specifically).

o Improve workload definition. The current workload is a cpu-hog. It runs a
  fixed set of instructions in a loop, with some percentage of those being
  contained within the lock/unlock block. Adding sleeps to reduce CPU overhead
  just added so much scheduling overhead that the numbers dropped absurdly for
  both normal and adaptive. I'd appreciate any assistance in preparing a
  test-case for a real-world usage scenario. I will work with some of IBM's
  product teams to do so, and would welcome any input from others with an
  interest in kernel assisted userspace spinlocks.

o Attempt the kernel assisted userspace spinning version proposed by Avi, Alan,
  and Ulrich for comparison.

Thanks,

Darren Hart
IBM Linux Technology Center
Real-Time Linux Team


