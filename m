Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab2JKAYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:24:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44063 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932917Ab2JKAY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:24:27 -0400
X-Sasl-enc: hAHcrkPMBXSQhw4PLGEu4pLy5t7yQnxRk64aEQSHB1Qq 1349915066
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [ 087/122] ia64: Add missing RCU idle APIs on idle loop
Date: Thu, 11 Oct 2012 07:54:13 +0900
Message-Id: <20121010225353.711845929@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

commit 93482f4ef1093f5961a63359a34612183d6beea0 upstream.

Traditionally, the entire idle task served as an RCU quiescent state.
But when RCU read side critical sections started appearing within the
idle loop, this traditional strategy became untenable.  The fix was to
create new RCU APIs named rcu_idle_enter() and rcu_idle_exit(), which
must be called by each architecture's idle loop so that RCU can tell
when it is safe to ignore a given idle CPU.

Unfortunately, this fix was never applied to ia64, a shortcoming remedied
by this commit.

Reported by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/ia64/kernel/process.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -29,6 +29,7 @@
 #include <linux/kdebug.h>
 #include <linux/utsname.h>
 #include <linux/tracehook.h>
+#include <linux/rcupdate.h>
 
 #include <asm/cpu.h>
 #include <asm/delay.h>
@@ -279,6 +280,7 @@ cpu_idle (void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		if (can_do_pal_halt) {
 			current_thread_info()->status &= ~TS_POLLING;
 			/*
@@ -309,6 +311,7 @@ cpu_idle (void)
 			normal_xtp();
 #endif
 		}
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 		check_pgt_cache();
 		if (cpu_is_offline(cpu))


