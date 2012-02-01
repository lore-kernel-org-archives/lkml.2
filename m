Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2BATnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:35 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54532 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab2BATnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:31 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 26/41] rcu: Note that rcu_access_pointer() can be used for teardown
Date: Wed,  1 Feb 2012 11:41:44 -0800
Message-Id: <1328125319-5205-26-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5806-0000-0000-000011F2FF5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

There is no convenient expression for rcu_deference_protected()
when it is used in tearing down multilinked structures following
a grace period.  For example, suppose that an element containing an
RCU-protected pointer to a second element is removed from an enclosing
RCU-protected data structure, then the write-side lock is released,
and finally synchronize_rcu() is invoked to wait for a grace period.
Then it is necessary to traverse the pointer in order to free up the
second element.  But we are not in an RCU read-side critical section
and we are holding no locks, so the usual rcu_dereference_check() and
rcu_dereference_protected() primitives are not appropriate.  Neither
is rcu_dereference_raw(), as it is intended for use in data structures
where the user defines the locking design (for example, list_head).

So this responsibility is added to rcu_access_pointer()'s list, and
this commit updates rcu_assign_pointer()'s header comment accordingly.

Suggested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 include/linux/rcupdate.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6df0ae1..f409529 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -484,6 +484,13 @@ static inline void rcu_preempt_sleep_check(void)
  * NULL.  Although rcu_access_pointer() may also be used in cases where
  * update-side locks prevent the value of the pointer from changing, you
  * should instead use rcu_dereference_protected() for this use case.
+ *
+ * It is also permissible to use rcu_access_pointer() when read-side
+ * access to the pointer was removed at least one grace period ago, as
+ * is the case in the context of the RCU callback that is freeing up
+ * the data, or after a synchronize_rcu() returns.  This can be useful
+ * when tearing down multi-linked structures after a grace period
+ * has elapsed.
  */
 #define rcu_access_pointer(p) __rcu_access_pointer((p), __rcu)
 
-- 
1.7.8

