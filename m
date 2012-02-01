Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab2BAWcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:32:07 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60002 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab2BAWcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:32:04 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM/Freezer: Thaw only kernel threads if freezing of kernel
 threads fails
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 02 Feb 2012 04:01:12 +0530
Message-ID: <20120201223105.6669.12718.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12020122-2674-0000-0000-000003324F45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If freezing of kernel threads fails, we are expected to automatically thaw
tasks in the error recovery path. However, at times, we encounter situations
in which we would like the automatic error recovery path to thaw only the
kernel threads, because we want to be able to do some more cleanup before
we thaw userspace. Something like:

error = freeze_kernel_threads();
if (error) {
	/* Do some cleanup */

	/* Only then thaw userspace tasks*/
	thaw_processes();
}

An example of such a situation is where we freeze/thaw filesystems during
suspend/hibernation. There, if freezing of kernel threads fails, we would
like to thaw the frozen filesystems before thawing the userspace tasks.

So, modify freeze_kernel_threads() to thaw only kernel threads in case of
freezing failure.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/power.h   |   26 ++++++++++++++++++++++++--
 kernel/power/process.c |    7 +++++--
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 0c4defe..cf41c03 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -231,8 +231,30 @@ extern int pm_test_level;
 #ifdef CONFIG_SUSPEND_FREEZER
 static inline int suspend_freeze_processes(void)
 {
-	int error = freeze_processes();
-	return error ? : freeze_kernel_threads();
+	int error;
+
+	error = freeze_processes();
+
+	/*
+	 * freeze_processes() automatically thaws
+	 * every task if freezing fails. So we need
+	 * not do anything extra upon error.
+	 */
+	if (error)
+		goto Finish;
+
+	error = freeze_kernel_threads();
+
+	/*
+	 * freeze_kernel_threads() thaws only kernel
+	 * threads upon freezing failure. So we have
+	 * to thaw the userspace tasks ourselves.
+	 */
+	if (error)
+		thaw_processes();
+
+ Finish:
+	return error;
 }
 
 static inline void suspend_thaw_processes(void)
diff --git a/kernel/power/process.c b/kernel/power/process.c
index eeca003..7e42645 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -143,7 +143,10 @@ int freeze_processes(void)
 /**
  * freeze_kernel_threads - Make freezable kernel threads go to the refrigerator.
  *
- * On success, returns 0.  On failure, -errno and system is fully thawed.
+ * On success, returns 0.  On failure, -errno and only the kernel threads are
+ * thawed, so as to give a chance to the caller to do additional cleanups
+ * (if any) before thawing the userspace tasks. So, it is the responsibility
+ * of the caller to thaw the userspace tasks, when the time is right.
  */
 int freeze_kernel_threads(void)
 {
@@ -159,7 +162,7 @@ int freeze_kernel_threads(void)
 	BUG_ON(in_atomic());
 
 	if (error)
-		thaw_processes();
+		thaw_kernel_threads();
 	return error;
 }
 

