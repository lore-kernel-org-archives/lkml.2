Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0DSHzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 03:55:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:53108 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab0DSHzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 03:55:35 -0400
Date: Mon, 19 Apr 2010 07:54:41 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       davem@davemloft.net, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100415195039.GA22623@linux.vnet.ibm.com>
References: <20100415195039.GA22623@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Make RCU lockdep check the lockdep_recursion variable
Message-ID: <tip-bc293d62b26ec590afc90a9e0a31c45d355b7bd8@git.kernel.org>
Git-Commit-ID: bc293d62b26ec590afc90a9e0a31c45d355b7bd8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 19 Apr 2010 07:54:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc293d62b26ec590afc90a9e0a31c45d355b7bd8
Gitweb:     http://git.kernel.org/tip/bc293d62b26ec590afc90a9e0a31c45d355b7bd8
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 15 Apr 2010 12:50:39 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 19 Apr 2010 08:37:19 +0200

rcu: Make RCU lockdep check the lockdep_recursion variable

The lockdep facility temporarily disables lockdep checking by
incrementing the current->lockdep_recursion variable.  Such
disabling happens in NMIs and in other situations where lockdep
might expect to recurse on itself.

This patch therefore checks current->lockdep_recursion, disabling RCU
lockdep splats when this variable is non-zero.  In addition, this patch
removes the "likely()", as suggested by Lai Jiangshan.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: David Miller <davem@davemloft.net>
Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: eric.dumazet@gmail.com
LKML-Reference: <20100415195039.GA22623@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcupdate.h |    5 +----
 kernel/rcupdate.c        |    7 +++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9f1ddfe..07db2fe 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -101,10 +101,7 @@ extern struct lockdep_map rcu_sched_lock_map;
 # define rcu_read_release_sched() \
 		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
 
-static inline int debug_lockdep_rcu_enabled(void)
-{
-	return likely(rcu_scheduler_active && debug_locks);
-}
+extern int debug_lockdep_rcu_enabled(void);
 
 /**
  * rcu_read_lock_held - might we be in RCU read-side critical section?
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 63fe254..03a7ea1 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -69,6 +69,13 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
+int debug_lockdep_rcu_enabled(void)
+{
+	return rcu_scheduler_active && debug_locks &&
+	       current->lockdep_recursion == 0;
+}
+EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
+
 /**
  * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
  *
