Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab2A3XPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:15:18 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:55913 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab2A3XPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:15:15 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 3/4] PM/Hibernate: Thaw kernel threads in
 hibernation_snapshot() in error/test path
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 04:45:06 +0530
Message-ID: <20120130231456.11129.2954.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
References: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12013023-2000-0000-0000-0000063E9AC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the hibernation call path, the kernel threads are frozen inside
hibernation_snapshot(). If we happen to encounter an error further down
the road or if we are exiting early due to a successful freezer test,
then thaw kernel threads before returning to the caller.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |    9 ++++++---
 kernel/power/user.c      |    8 ++------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 1670387..0ce1220 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -343,13 +343,13 @@ int hibernation_snapshot(int platform_mode)
 		 * successful freezer test.
 		 */
 		freezer_test_done = true;
-		goto Cleanup;
+		goto Thaw;
 	}
 
 	error = dpm_prepare(PMSG_FREEZE);
 	if (error) {
 		dpm_complete(PMSG_RECOVER);
-		goto Cleanup;
+		goto Thaw;
 	}
 
 	suspend_console();
@@ -385,6 +385,8 @@ int hibernation_snapshot(int platform_mode)
 	platform_end(platform_mode);
 	return error;
 
+ Thaw:
+	thaw_kernel_threads();
  Cleanup:
 	swsusp_free();
 	goto Close;
@@ -655,12 +657,13 @@ int hibernate(void)
 		pr_debug("PM: Image restored successfully.\n");
 	}
 
- Thaw:
 	/*
 	 * Kernel threads had been frozen inside hibernation_snapshot().
 	 * So thaw them here, on the success path.
 	 */
 	thaw_kernel_threads();
+
+ Thaw:
 	thaw_processes();
  Finish:
 	free_basic_memory_bitmaps();
diff --git a/kernel/power/user.c b/kernel/power/user.c
index eaf5c97..62dbe93 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -257,16 +257,12 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		}
 		pm_restore_gfp_mask();
 		error = hibernation_snapshot(data->platform_support);
-		if (error) {
-			thaw_kernel_threads();
-		} else {
+		if (!error) {
 			error = put_user(in_suspend, (int __user *)arg);
 			if (!error && !freezer_test_done)
 				data->ready = 1;
-			if (freezer_test_done) {
+			if (freezer_test_done)
 				freezer_test_done = false;
-				thaw_kernel_threads();
-			}
 		}
 		break;
 

