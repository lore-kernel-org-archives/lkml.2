Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab1JGAo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 20:44:59 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54539 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759096Ab1JGAo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 20:44:58 -0400
Date: Thu, 6 Oct 2011 17:44:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: tglx@linutronix.de, peterz@infradead.org
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH, RFC, -rt] Make lockdep-RCU insist on rcu_read_lock_bh()
Message-ID: <20111007004451.GA13738@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11100700-3534-0000-0000-000000789215
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu: Make -rt complain about lack of rcu_read_lock_bh()

Mainline permits local_bh_disable() to be used in place of
rcu_read_lock_bh(), but this fails for CONFIG_PREEMPT_RT_FULL.  This
commit therefore makes rcu_read_lock_bh_held() insist on
rcu_read_lock_bh() for CONFIG_PREEMPT_RT_FULL.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 5e0577b..e91a85d 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -89,7 +89,11 @@ int rcu_read_lock_bh_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	return lock_is_held(&rcu_bh_lock_map);
+#else
 	return in_softirq() || irqs_disabled();
+#endif
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 #endif

