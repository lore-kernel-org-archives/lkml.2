Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2A3WF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:05:26 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:44095 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab2A3WFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:05:23 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/4] PM/Freezer: Use thaw_processes() and
 thaw_kernel_threads() correctly
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 03:35:13 +0530
Message-ID: <20120130220503.9442.61746.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120130220259.9442.70091.stgit@srivatsabhat.in.ibm.com>
References: <20120130220259.9442.70091.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12013022-8256-0000-0000-000001127407
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now thaw_processes() thaws only userspace tasks (instead of thawing
everything, unlike what it used to do before). So fix the uses of
thaw_processes() by using thaw_kernel_threads() where appropriate.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |    5 +++++
 kernel/power/power.h     |   15 +++++++++++++--
 kernel/power/process.c   |    7 ++++---
 kernel/power/user.c      |    8 ++++++++
 4 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a5d4cf0..1670387 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -656,6 +656,11 @@ int hibernate(void)
 	}
 
  Thaw:
+	/*
+	 * Kernel threads had been frozen inside hibernation_snapshot().
+	 * So thaw them here, on the success path.
+	 */
+	thaw_kernel_threads();
 	thaw_processes();
  Finish:
 	free_basic_memory_bitmaps();
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 0c4defe..e37a1e0 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -231,12 +231,23 @@ extern int pm_test_level;
 #ifdef CONFIG_SUSPEND_FREEZER
 static inline int suspend_freeze_processes(void)
 {
-	int error = freeze_processes();
-	return error ? : freeze_kernel_threads();
+	int error;
+
+	error = freeze_processes();
+	if (error)
+		goto Finish;
+
+	error = freeze_kernel_threads();
+	if (error)
+		thaw_processes();
+
+Finish:
+	return error;
 }
 
 static inline void suspend_thaw_processes(void)
 {
+	thaw_kernel_threads();
 	thaw_processes();
 }
 #else
diff --git a/kernel/power/process.c b/kernel/power/process.c
index def6b1b..8ae6c4b 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -116,7 +116,8 @@ static int try_to_freeze_tasks(bool user_only)
 /**
  * freeze_processes - Signal user space processes to enter the refrigerator.
  *
- * On success, returns 0.  On failure, -errno and system is fully thawed.
+ * On success, returns 0.  On failure, -errno and all user space processes
+ * are thawed.
  */
 int freeze_processes(void)
 {
@@ -143,7 +144,7 @@ int freeze_processes(void)
 /**
  * freeze_kernel_threads - Make freezable kernel threads go to the refrigerator.
  *
- * On success, returns 0.  On failure, -errno and system is fully thawed.
+ * On success, returns 0. On failure, -errno and all kernel threads are thawed.
  */
 int freeze_kernel_threads(void)
 {
@@ -159,7 +160,7 @@ int freeze_kernel_threads(void)
 	BUG_ON(in_atomic());
 
 	if (error)
-		thaw_processes();
+		thaw_kernel_threads();
 	return error;
 }
 
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 3e10007..eaf5c97 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -119,6 +119,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 	free_all_swap_pages(data->swap);
 	if (data->frozen) {
 		pm_restore_gfp_mask();
+		thaw_kernel_threads();
 		thaw_processes();
 	}
 	pm_notifier_call_chain(data->mode == O_RDONLY ?
@@ -237,6 +238,13 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		if (!data->frozen || data->ready)
 			break;
 		pm_restore_gfp_mask();
+
+		/*
+		 * Be paranoid and thaw kernel threads as well, in order to
+		 * make sure that the system gets thawed fully, irrespective
+		 * of which (error) path we took to come here.
+		 */
+		thaw_kernel_threads();
 		thaw_processes();
 		usermodehelper_enable();
 		data->frozen = 0;

