Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2GTSsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:48:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:17115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab2GTSsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="174868550"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()
Date: Fri, 20 Jul 2012 11:46:31 -0700
Message-Id: <ad82bfe7f7d130247fbe2b5b4275654807774227.1342809673.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1342809673.git.dvhart@linux.intel.com>
References: <cover.1342809673.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1342809673.git.dvhart@linux.intel.com>
References: <cover.1342809673.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If uaddr == uaddr2, then we have broken the rule of only requeueing from
a non-pi futex to a pi futex with this call. If we attempt this, as the
trinity test suite manages to do, we miss early wakeups as q.key is
equal to key2 (because they are the same uaddr). We will then attempt to
dereference the pi_mutex (which would exist had the futex_q been
properly requeued to a pi futex) and trigger a NULL pointer dereference.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Dave Jones <davej@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 5551ada..3717e7b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2231,11 +2231,11 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
  * @uaddr2:	the pi futex we will take prior to returning to user-space
  *
  * The caller will wait on uaddr and will be requeued by futex_requeue() to
- * uaddr2 which must be PI aware.  Normal wakeup will wake on uaddr2 and
- * complete the acquisition of the rt_mutex prior to returning to userspace.
- * This ensures the rt_mutex maintains an owner when it has waiters; without
- * one, the pi logic wouldn't know which task to boost/deboost, if there was a
- * need to.
+ * uaddr2 which must be PI aware and unique from uaddr.  Normal wakeup will wake
+ * on uaddr2 and complete the acquisition of the rt_mutex prior to returning to
+ * userspace.  This ensures the rt_mutex maintains an owner when it has waiters;
+ * without one, the pi logic would not know which task to boost/deboost, if
+ * there was a need to.
  *
  * We call schedule in futex_wait_queue_me() when we enqueue and return there
  * via the following:
@@ -2272,6 +2272,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	struct futex_q q = futex_q_init;
 	int res, ret;
 
+	if (uaddr == uaddr2)
+		return -EINVAL;
+
 	if (!bitset)
 		return -EINVAL;
 
-- 
1.7.10.4

