Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2GXOYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:24:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42138 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab2GXOYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:24:46 -0400
Date: Tue, 24 Jul 2012 07:24:30 -0700
From: tip-bot for Darren Hart <dvhart@linux.intel.com>
Message-ID: <tip-6f7b0a2a5c0fb03be7c25bd1745baa50582348ef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dvhart@linux.intel.com, davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, tglx@linutronix.de, davej@redhat.com
In-Reply-To: <ad82bfe7f7d130247fbe2b5b4275654807774227.1342809673.git.dvhart@linux.intel.com>
References: <ad82bfe7f7d130247fbe2b5b4275654807774227.1342809673.git.dvhart@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Forbid uaddr ==
  uaddr2 in futex_wait_requeue_pi()
Git-Commit-ID: 6f7b0a2a5c0fb03be7c25bd1745baa50582348ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 24 Jul 2012 07:24:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f7b0a2a5c0fb03be7c25bd1745baa50582348ef
Gitweb:     http://git.kernel.org/tip/6f7b0a2a5c0fb03be7c25bd1745baa50582348ef
Author:     Darren Hart <dvhart@linux.intel.com>
AuthorDate: Fri, 20 Jul 2012 11:53:31 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 24 Jul 2012 16:02:57 +0200

futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()

If uaddr == uaddr2, then we have broken the rule of only requeueing
from a non-pi futex to a pi futex with this call. If we attempt this,
as the trinity test suite manages to do, we miss early wakeups as
q.key is equal to key2 (because they are the same uaddr). We will then
attempt to dereference the pi_mutex (which would exist had the futex_q
been properly requeued to a pi futex) and trigger a NULL pointer
dereference.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/ad82bfe7f7d130247fbe2b5b4275654807774227.1342809673.git.dvhart@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/futex.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

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
 
