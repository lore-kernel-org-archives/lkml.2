Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1LANPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:15:50 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37623 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab1LANPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:15:49 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM / Hibernate: Thaw processes in SNAPSHOT_CREATE_IMAGE ioctl
 error/test paths
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Thu, 01 Dec 2011 18:45:37 +0530
Message-ID: <20111201131532.21615.86479.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11120113-8256-0000-0000-0000005A7F27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2aede851ddf08666f68ffc17be446420e9d2a056 (PM / Hibernate: Freeze
kernel threads after preallocating memory) moved the freezing of kernel
threads to hibernation_snapshot() function.

So now, if the call to hibernation_snapshot() fails or returns early due
to a successful hibernation test, the caller has to thaw processes to
ensure that the system gets back to its original state.

But in SNAPSHOT_CREATE_IMAGE hibernation ioctl, the caller does not thaw
processes. Fix this issue. But note that if hibernation_snapshot() returned
due to a successful freezer test, we still send the value of 'in_suspend'
(which is now 0) to userspace, because we are not in an error path per-se,
and moreover, the value of in_suspend correctly depicts the situation here.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |    2 +-
 kernel/power/power.h     |    2 ++
 kernel/power/user.c      |   13 ++++++++++---
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a6b0503..624538a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -55,7 +55,7 @@ enum {
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-static bool freezer_test_done;
+bool freezer_test_done;
 
 static const struct platform_hibernation_ops *hibernation_ops;
 
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 23a2db1..0c4defe 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -50,6 +50,8 @@ static inline char *check_image_kernel(struct swsusp_info *info)
 #define SPARE_PAGES	((1024 * 1024) >> PAGE_SHIFT)
 
 /* kernel/power/hibernate.c */
+extern bool freezer_test_done;
+
 extern int hibernation_snapshot(int platform_mode);
 extern int hibernation_restore(int platform_mode);
 extern int hibernation_platform_enter(void);
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 6d8f535..b98b7e1 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -283,10 +283,17 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		}
 		pm_restore_gfp_mask();
 		error = hibernation_snapshot(data->platform_support);
-		if (!error)
+		if (error) {
+			thaw_processes();
+		} else {
 			error = put_user(in_suspend, (int __user *)arg);
-		if (!error)
-			data->ready = 1;
+			if (!error && !freezer_test_done)
+				data->ready = 1;
+			if (freezer_test_done) {
+				freezer_test_done = false;
+				thaw_processes();
+			}
+		}
 		break;
 
 	case SNAPSHOT_ATOMIC_RESTORE:

