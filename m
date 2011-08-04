Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab1HDWgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:36:47 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40250 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab1HDWgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:36:41 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] devtmpfs: Fix section mismatch on devtmpfsd()
Date: Thu,  4 Aug 2011 23:36:11 +0100
Message-Id: <1312497371-25685-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devtmpfsd_init() references setup_done which is __initdata, but
devtmpfsd() is not an __init function.  The code is fine, because it
is never referenced after discarding __init sections, but it leaves
some additional code that can be discarded with the rest of __init and
it causes gcc to complain with a section mismatch warning.

This patch moves the discardable portion into a separate __init
function.

Compile tested on SPARC and ARM.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/base/devtmpfs.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 33e1bed..5bf4f33 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -386,19 +386,8 @@ static int handle(const char *name, mode_t mode, struct device *dev)
 		return handle_remove(name, dev);
 }
 
-static int devtmpfsd(void *p)
+static void devtmpfsd(void)
 {
-	char options[] = "mode=0755";
-	int *err = p;
-	*err = sys_unshare(CLONE_NEWNS);
-	if (*err)
-		goto out;
-	*err = sys_mount("devtmpfs", "/", "devtmpfs", MS_SILENT, options);
-	if (*err)
-		goto out;
-	sys_chdir("/.."); /* will traverse into overmounted root */
-	sys_chroot(".");
-	complete(&setup_done);
 	while (1) {
 		spin_lock(&req_lock);
 		while (requests) {
@@ -418,6 +407,22 @@ static int devtmpfsd(void *p)
 		schedule();
 		__set_current_state(TASK_RUNNING);
 	}
+}
+
+static int __init devtmpfsd_run(void *p)
+{
+	char options[] = "mode=0755";
+	int *err = p;
+	*err = sys_unshare(CLONE_NEWNS);
+	if (*err)
+		goto out;
+	*err = sys_mount("devtmpfs", "/", "devtmpfs", MS_SILENT, options);
+	if (*err)
+		goto out;
+	sys_chdir("/.."); /* will traverse into overmounted root */
+	sys_chroot(".");
+	complete(&setup_done);
+	devtmpfsd();
 	return 0;
 out:
 	complete(&setup_done);
@@ -437,7 +442,7 @@ int __init devtmpfs_init(void)
 		return err;
 	}
 
-	thread = kthread_run(devtmpfsd, &err, "kdevtmpfs");
+	thread = kthread_run(devtmpfsd_run, &err, "kdevtmpfs");
 	if (!IS_ERR(thread)) {
 		wait_for_completion(&setup_done);
 	} else {
-- 
1.7.4.1

