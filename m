Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0IWAvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:51:03 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60850 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab0IWAvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:51:00 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/8] rcu: upgrade stallwarn.txt documentation for CPU-bound RT processes
Date: Wed, 22 Sep 2010 17:50:46 -0700
Message-Id: <1285203053-22068-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100923005033.GA22006@linux.vnet.ibm.com>
References: <20100923005033.GA22006@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU-bound real-time processes can cause RCU CPU stall warnings, and
much other trouble as well.  Document the fact that they can cause
RCU CPU stall warnings.

Suggested-by: Darren Hart <dvhltc@us.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/stallwarn.txt |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 44c6dcc..862c08e 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -80,6 +80,24 @@ o	A CPU looping with bottom halves disabled.  This condition can
 o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the kernel
 	without invoking schedule().
 
+o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
+	happen to preempt a low-priority task in the middle of an RCU
+	read-side critical section.   This is especially damaging if
+	that low-priority task is not permitted to run on any other CPU,
+	in which case the next RCU grace period can never complete, which
+	will eventually cause the system to run out of memory and hang.
+	While the system is in the process of running itself out of
+	memory, you might see stall-warning messages.
+
+o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
+	is running at a higher priority than the RCU softirq threads.
+	This will prevent RCU callbacks from ever being invoked,
+	and in a CONFIG_TREE_PREEMPT_RCU kernel will further prevent
+	RCU grace periods from ever completing.  Either way, the
+	system will eventually run out of memory and hang.  In the
+	CONFIG_TREE_PREEMPT_RCU case, you might see stall-warning
+	messages.
+
 o	A bug in the RCU implementation.
 
 o	A hardware failure.  This is quite unlikely, but has occurred
-- 
1.7.0.6

