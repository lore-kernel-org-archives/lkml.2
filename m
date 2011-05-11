Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab1EKVAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:00:13 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45517 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab1EKVAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:00:11 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] rcu: avoid build error for third-party modules
Date: Wed, 11 May 2011 13:59:35 -0700
Message-Id: <1305147577-1812-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110511205915.GA1731@linux.vnet.ibm.com>
References: <20110511205915.GA1731@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial definition of __kfree_rcu() checked a static inline function
argument to see if it was a compile-time constant.  Apparently not all
compilers are willing to put up with this at all optimization levels.
Add a nasty comment and remove the warning, relying on the fact that
__kfree_rcu() is called only from kfree_rcu(), which always passes in
a compile-time constant.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 99f9aa7..58b13f1 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -814,13 +814,14 @@ static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
 	return offset < 4096;
 }
 
+/*
+ * Intended to be called only from the kfree_rcu() macro.
+ */
 static __always_inline
 void __kfree_rcu(struct rcu_head *head, unsigned long offset)
 {
 	typedef void (*rcu_callback)(struct rcu_head *);
 
-	BUILD_BUG_ON(!__builtin_constant_p(offset));
-
 	/* See the kfree_rcu() header comment. */
 	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
 
-- 
1.7.3.2

