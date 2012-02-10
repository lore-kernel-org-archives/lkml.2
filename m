Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab2BJWmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:42:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2BJWmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:49 -0500
MIME-Version: 1.0
Message-Id: <20120210222948.247125805@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 36/86] PM / Hibernate: Thaw processes in SNAPSHOT_CREATE_IMAGE ioctl test path
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

commit 97819a26224f019e73d88bb2fd4eb5a614860461 upstream.

Commit 2aede851ddf08666f68ffc17be446420e9d2a056 (PM / Hibernate: Freeze
kernel threads after preallocating memory) moved the freezing of kernel
threads to hibernation_snapshot() function.

So now, if the call to hibernation_snapshot() returns early due to a
successful hibernation test, the caller has to thaw processes to ensure
that the system gets back to its original state.

But in SNAPSHOT_CREATE_IMAGE hibernation ioctl, the caller does not thaw
processes in case hibernation_snapshot() returned due to a successful
freezer test. Fix this issue. But note we still send the value of 'in_suspend'
(which is now 0) to userspace, because we are not in an error path per-se,
and moreover, the value of in_suspend correctly depicts the situation here.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/hibernate.c |    2 +-
 kernel/power/power.h     |    2 ++
 kernel/power/user.c      |   11 ++++++++---
 3 files changed, 11 insertions(+), 4 deletions(-)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -55,7 +55,7 @@ enum {
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-static bool freezer_test_done;
+bool freezer_test_done;
 
 static const struct platform_hibernation_ops *hibernation_ops;
 
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -50,6 +50,8 @@ static inline char *check_image_kernel(s
 #define SPARE_PAGES	((1024 * 1024) >> PAGE_SHIFT)
 
 /* kernel/power/hibernate.c */
+extern bool freezer_test_done;
+
 extern int hibernation_snapshot(int platform_mode);
 extern int hibernation_restore(int platform_mode);
 extern int hibernation_platform_enter(void);
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -283,10 +283,15 @@ static long snapshot_ioctl(struct file *
 		}
 		pm_restore_gfp_mask();
 		error = hibernation_snapshot(data->platform_support);
-		if (!error)
+		if (!error) {
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


