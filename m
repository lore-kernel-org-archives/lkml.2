Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2BBAeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:34:18 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42596 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab2BBAeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:34:15 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM/Hibernate: Thaw kernel threads in hibernation_snapshot()
 in error/test path
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 02 Feb 2012 06:04:05 +0530
Message-ID: <20120202003359.9930.9844.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12020200-9574-0000-0000-000001336283
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the hibernation call path, the kernel threads are frozen inside
hibernation_snapshot(). If we happen to encounter an error further down
the road or if we are exiting early due to a successful freezer test,
then thaw kernel threads before returning to the caller.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/hibernate.c |    6 ++++--
 kernel/power/user.c      |    8 ++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a5d4cf0..c6dee73 100644
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
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 3e10007..7bee91f 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -249,16 +249,12 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
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
 

