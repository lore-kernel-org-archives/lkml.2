Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab1KQIbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:31:14 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56917 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1KQIbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:31:11 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3] PM/Memory-hotplug: Avoid task freezing failures
To: rjw@sisk.pl
Cc: pavel@ucw.cz, lenb@kernel.org, ak@linux.intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Date: Thu, 17 Nov 2011 14:00:50 +0530
Message-ID: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11111622-9264-0000-0000-0000003812C0
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
Also, we use msleep() to avoid busy looping and breaking expectations
that we go to sleep when we fail to acquire the lock.
And we also call try_to_freeze() in order to cooperate with the freezer,
without which we would end up in almost the same situation as mutex_lock(),
due to uninterruptible sleep caused by msleep().

v3: Tejun suggested avoiding busy-looping by adding an msleep() since
    it is not guaranteed that we will get frozen immediately.

v2: Tejun pointed problems with using mutex_lock_interruptible() in a
    while loop, when signals not related to freezing are involved.
    So, replaced it with mutex_trylock().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/suspend.h |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 57a6924..0af3048 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -5,6 +5,8 @@
 #include <linux/notifier.h>
 #include <linux/init.h>
 #include <linux/pm.h>
+#include <linux/freezer.h>
+#include <linux/delay.h>
 #include <linux/mm.h>
 #include <asm/errno.h>
 
@@ -380,7 +382,40 @@ static inline void unlock_system_sleep(void) {}
 
 static inline void lock_system_sleep(void)
 {
-	mutex_lock(&pm_mutex);
+	/*
+	 * "To sleep, or not to sleep, that is the question!"
+	 *
+	 * We should not use mutex_lock() here because, in case we fail to
+	 * acquire the lock, it would put us to sleep in TASK_UNINTERRUPTIBLE
+	 * state, which would lead to task freezing failures. As a
+	 * consequence, hibernation would fail (even though it had acquired
+	 * the 'pm_mutex' lock).
+	 * Using mutex_lock_interruptible() in a loop is not a good idea,
+	 * because we could end up treating non-freezing signals badly.
+	 * So we use mutex_trylock() in a loop instead.
+	 *
+	 * Also, we add try_to_freeze() to the loop, to co-operate with the
+	 * freezer, to avoid task freezing failures due to busy-looping.
+	 *
+	 * But then, since it is not guaranteed that we will get frozen
+	 * rightaway, we could keep spinning for some time, breaking the
+	 * expectation that we go to sleep when we fail to acquire the lock.
+	 * So we add an msleep() to the loop, to dampen the spin (but we are
+	 * careful enough not to sleep for too long at a stretch, lest the
+	 * freezer whine and give up again!).
+	 *
+	 * Now that we no longer busy-loop, try_to_freeze() becomes all the
+	 * more important, due to a subtle reason: if we don't cooperate with
+	 * the freezer at this point, we could end up in a situation very
+	 * similar to mutex_lock() due to the usage of msleep() (which sleeps
+	 * uninterruptibly).
+	 *
+	 * Phew! What a delicate balance!
+	 */
+	while (!mutex_trylock(&pm_mutex)) {
+		try_to_freeze();
+		msleep(10);
+	}
 }
 
 static inline void unlock_system_sleep(void)

