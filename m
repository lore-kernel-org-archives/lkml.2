Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab1KPL4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:56:44 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:41063 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab1KPL4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:56:43 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2] PM/Memory-hotplug: Avoid task freezing failures
To: rjw@sisk.pl
Cc: pavel@ucw.cz, lenb@kernel.org, ak@linux.intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Date: Wed, 16 Nov 2011 17:25:23 +0530
Message-ID: <20111116115515.25945.35368.stgit@srivatsabhat.in.ibm.com>
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
mutex_trylock() in a loop until the lock is acquired, instead of using
mutex_lock(), in order to avoid going to uninterruptible sleep.
Also, try_to_freeze() is called within the loop, so that we don't cause
freezing failures due to busy looping.

v2: Tejun pointed problems with using mutex_lock_interruptible() in a
    while loop, when signals not related to freezing are involved.
    So, replaced it with mutex_trylock().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/suspend.h |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 57a6924..c2b5aab 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -5,6 +5,7 @@
 #include <linux/notifier.h>
 #include <linux/init.h>
 #include <linux/pm.h>
+#include <linux/freezer.h>
 #include <linux/mm.h>
 #include <asm/errno.h>
 
@@ -380,7 +381,18 @@ static inline void unlock_system_sleep(void) {}
 
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
+	 * We should use try_to_freeze() in the while loop so that we don't
+	 * cause freezing failures due to busy looping.
+	 */
+	while (!mutex_trylock(&pm_mutex))
+		try_to_freeze();
 }
 
 static inline void unlock_system_sleep(void)

