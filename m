Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0IWAc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:32:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49803 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab0IWAcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:32:25 -0400
Date: Wed, 22 Sep 2010 17:32:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/urgent] rcu: rcu_read_lock_bh_held(): disabling
 irqs also disables bh
Message-ID: <20100923003220.GA21822@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_dereference_bh() doesnt know yet about hard irq being disabled, so
lockdep can trigger in netpoll_rx() after commit f0f9deae9e7c4 (netpoll:
Disable IRQ around RCU dereference in netpoll_rx)

Reported-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9fbc54a..0dcc00e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -454,7 +454,8 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * Makes rcu_dereference_check() do the dirty work.
  */
 #define rcu_dereference_bh(p) \
-		rcu_dereference_check(p, rcu_read_lock_bh_held())
+		rcu_dereference_check(p, rcu_read_lock_bh_held() || \
+					 irqs_disabled())
 
 /**
  * rcu_dereference_sched - fetch RCU-protected pointer, checking for RCU-sched
-- 
1.7.0.6

