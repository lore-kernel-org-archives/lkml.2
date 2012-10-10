Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab2JKAcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:32:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34736 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933316Ab2JKAYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:24:48 -0400
X-Sasl-enc: aFV1wAyOzImLseMdVKC70bJNQ8tNu3qpaVJqupvJckDo 1349915086
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [ 092/122] mn10300: Add missing RCU idle APIs on idle loop
Date: Thu, 11 Oct 2012 07:54:18 +0900
Message-Id: <20121010225354.600345079@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 5b0753a90b7a98bc613c3767e9263a1a76d4f900 upstream.

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

Add this missing pair of calls in the mn10300's idle loop.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mn10300/kernel/process.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -107,6 +108,7 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	for (;;) {
+		rcu_idle_enter();
 		while (!need_resched()) {
 			void (*idle)(void);
 
@@ -121,6 +123,7 @@ void cpu_idle(void)
 			}
 			idle();
 		}
+		rcu_idle_exit();
 
 		schedule_preempt_disabled();
 	}


