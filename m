Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2A3XOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:14:41 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:55844 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2A3XOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:14:39 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 1/4] PM/Freezer: Use thaw_kernel_threads() in preparation
 for changes to thaw_processes()
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 04:44:30 +0530
Message-ID: <20120130231418.11129.24809.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
References: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12013023-2000-0000-0000-0000063E9A9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of now, thaw_processes() is a superset of thaw_kernel_threads() in the
sense that thaw_processes() thaws both userspace tasks and kernel threads.
But that is going to change very soon. So, in preparation for that, add
some calls to thaw_kernel_threads() like this:

 * If only kernel threads need to be thawed, _replace_ thaw_processes()
   with thaw_kernel_threads().

 * If everything needs to be thawed, _add_ a call to thaw_kernel_threads()
   adjacent to the existing call to thaw_processes().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |    5 +++++
 kernel/power/power.h     |   15 +++++++++++++--
 kernel/power/process.c   |    4 ++--
 kernel/power/user.c      |    8 ++++++++
 4 files changed, 28 insertions(+), 4 deletions(-)

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
index eeca003..3734fb9 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -143,7 +143,7 @@ int freeze_processes(void)
 /**
  * freeze_kernel_threads - Make freezable kernel threads go to the refrigerator.
  *
- * On success, returns 0.  On failure, -errno and system is fully thawed.
+ * On success, returns 0. On failure, -errno and all kernel threads are thawed.
  */
 int freeze_kernel_threads(void)
 {
@@ -159,7 +159,7 @@ int freeze_kernel_threads(void)
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

