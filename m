Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250Ab1KJQmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:42:54 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52568 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935032Ab1KJQmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:42:52 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM/Memory-hotplug: Avoid task freezing failures
To: rjw@sisk.pl
Cc: pavel@ucw.cz, lenb@kernel.org, ak@linux.intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Date: Thu, 10 Nov 2011 22:12:43 +0530
Message-ID: <20111110163825.4321.56320.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock_system_sleep() function is used in the memory hotplug code at
several places in order to implement mutual exclusion with hibernation.
However, this function tries to acquire the 'pm_mutex' lock using
mutex_lock() and hence blocks in TASK_UNINTERRUPTIBLE state if it doesn't
get the lock. This would lead to task freezing failures and hence
hibernation failure as a consequence, even though the hibernation call path
successfully acquired the lock.

This patch fixes this issue by modifying lock_system_sleep() to use
mutex_lock_interruptible() instead of mutex_lock(), so that it blocks in the
TASK_INTERRUPTIBLE state. This would allow the freezer to freeze the blocked
task. Also, since the freezer could use signals to freeze tasks, it is quite
likely that mutex_lock_interruptible() returns -EINTR (and fails to acquire
the lock). Hence we keep retrying in a loop until we acquire the lock. Also,
we call try_to_freeze() within the loop, so that we don't cause freezing
failures due to busy looping.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/suspend.h |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 57a6924..02a0d09 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -5,6 +5,7 @@
 #include <linux/notifier.h>
 #include <linux/init.h>
 #include <linux/pm.h>
+#include <linux/freezer.h>
 #include <linux/mm.h>
 #include <asm/errno.h>
 
@@ -380,7 +381,22 @@ static inline void unlock_system_sleep(void) {}
 
 static inline void lock_system_sleep(void)
 {
-	mutex_lock(&pm_mutex);
+	/*
+	 * We should not use mutex_lock() here because, in case we fail to
+	 * acquire the lock, it would put us to sleep in TASK_UNINTERRUPTIBLE
+	 * state, which would lead to task freezing failures. As a
+	 * consequence, hibernation would fail (even though it had acquired
+	 * the 'pm_mutex' lock).
+	 *
+	 * Note that mutex_lock_interruptible() returns -EINTR if we happen
+	 * to get a signal when we are waiting to acquire the lock (and this
+	 * is very likely here because the freezer could use signals to freeze
+	 * tasks). Hence we have to keep retrying until we get the lock. But
+	 * we have to use try_to_freeze() in the loop, so that we don't cause
+	 * freezing failures due to busy looping.
+	 */
+	while (mutex_lock_interruptible(&pm_mutex))
+		try_to_freeze();
 }
 
 static inline void unlock_system_sleep(void)

