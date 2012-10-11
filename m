Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab2JKBjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:39:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59285 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933384Ab2JKBNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:13:38 -0400
X-Sasl-enc: R9Ycc4nfhAhctXWKbw3p/wy3BDI/VUgOOygq14YWdmMK 1349918017
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [ 094/120] cris: Add missing RCU idle APIs on idle loop
Date: Thu, 11 Oct 2012 10:00:46 +0900
Message-Id: <20121011005844.132602658@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit c633f9e788928e91ad11f44df29b47bbbe9550b0 upstream.

In the old times, the whole idle task was considered
as an RCU quiescent state. But as RCU became more and
more successful overtime, some RCU read side critical
section have been added even in the code of some
architectures idle tasks, for tracing for example.

So nowadays, rcu_idle_enter() and rcu_idle_exit() must
be called by the architecture to tell RCU about the part
in the idle loop that doesn't make use of rcu read side
critical sections, typically the part that puts the CPU
in low power mode.

This is necessary for RCU to find the quiescent states in
idle in order to complete grace periods.

Add this missing pair of calls in the Cris's idle loop.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Cris <linux-cris-kernel@axis.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/cris/kernel/process.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -25,6 +25,7 @@
 #include <linux/elfcore.h>
 #include <linux/mqueue.h>
 #include <linux/reboot.h>
+#include <linux/rcupdate.h>
 
 //#define DEBUG
 
@@ -102,6 +103,7 @@ void cpu_idle (void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched()) {
 			void (*idle)(void);
 			/*
@@ -114,6 +116,7 @@ void cpu_idle (void)
 				idle = default_idle;
 			idle();
 		}
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
 }


