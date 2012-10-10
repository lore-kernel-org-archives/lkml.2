Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab2JKAcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:32:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41054 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933185Ab2JKAYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:24:44 -0400
X-Sasl-enc: IdJHfD4D9AmnQHIQaabSp/k94e4vvQZp01aHZvRxjwD3 1349915082
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [ 091/122] frv: Add missing RCU idle APIs on idle loop
Date: Thu, 11 Oct 2012 07:54:17 +0900
Message-Id: <20121010225354.420936743@linuxfoundation.org>
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

commit 41d8fe5bb3cf91ce2716ac8f43e4b40d802a99c8 upstream.

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

Add this missing pair of calls in the Frv's idle loop.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/frv/kernel/process.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -25,6 +25,7 @@
 #include <linux/reboot.h>
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
+#include <linux/rcupdate.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/uaccess.h>
@@ -69,12 +70,14 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched()) {
 			check_pgt_cache();
 
 			if (!frv_dma_inprogress && idle)
 				idle();
 		}
+		rcu_idle_exit();
 
 		schedule_preempt_disabled();
 	}


