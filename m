Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2KQAUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:20:24 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54879 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab2KQAUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:20:23 -0500
Date: Fri, 16 Nov 2012 16:20:16 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ellyjones@chromium.org
Subject: [PATCH] devtmpfs: mount with noexec and nosuid
Message-ID: <20121117002016.GA13493@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since devtmpfs is writable, make the default noexec nosuid as well. This
protects from the case of a privileged process having an arbitrary file
write flaw and an argumentless arbitrary execution (i.e. it would lack
the ability to run "mount -o remount,exec,suid /dev"), with a system
that already has nosuid,noexec on all other writable mounts.

Cc: ellyjones@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/base/devtmpfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 147d1a4..b7e2e57 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -340,6 +340,7 @@ static int handle_remove(const char *nodename, struct device *dev)
 int devtmpfs_mount(const char *mntdir)
 {
 	int err;
+	int mflags = MS_SILENT | MS_NOEXEC | MS_NOSUID;
 
 	if (!mount_dev)
 		return 0;
@@ -347,7 +348,7 @@ int devtmpfs_mount(const char *mntdir)
 	if (!thread)
 		return 0;
 
-	err = sys_mount("devtmpfs", (char *)mntdir, "devtmpfs", MS_SILENT, NULL);
+	err = sys_mount("devtmpfs", (char *)mntdir, "devtmpfs", mflags, NULL);
 	if (err)
 		printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
 	else
@@ -368,11 +369,12 @@ static int handle(const char *name, umode_t mode, struct device *dev)
 static int devtmpfsd(void *p)
 {
 	char options[] = "mode=0755";
+	int mflags = MS_SILENT | MS_NOEXEC | MS_NOSUID;
 	int *err = p;
 	*err = sys_unshare(CLONE_NEWNS);
 	if (*err)
 		goto out;
-	*err = sys_mount("devtmpfs", "/", "devtmpfs", MS_SILENT, options);
+	*err = sys_mount("devtmpfs", "/", "devtmpfs", mflags, options);
 	if (*err)
 		goto out;
 	sys_chdir("/.."); /* will traverse into overmounted root */
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
