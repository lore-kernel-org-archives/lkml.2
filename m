Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab2KTUmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:42:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58689 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab2KTUmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:42:43 -0500
Date: Tue, 20 Nov 2012 12:42:38 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ellyjones@chromium.org,
        Kay Sievers <kay@vrfy.org>, Roland Eggner <edvx1@systemanalysen.net>
Subject: [PATCH v2] devtmpfs: mount with noexec and nosuid
Message-ID: <20121120204238.GA19554@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since devtmpfs is writable, make the default noexec,nosuid as well. This
protects from the case of a privileged process having an arbitrary file
write flaw and an argumentless arbitrary execution (i.e. it would lack
the ability to run "mount -o remount,exec,suid /dev").

Cc: ellyjones@chromium.org
Cc: Kay Sievers <kay@vrfy.org>
Cc: Roland Eggner <edvx1@systemanalysen.net>
Signed-off-by: Kees Cook <keescook@chromium.org>

---
v2:
- use CONFIG_DEVTMPFS_SAFE to wrap the logic.
---
 drivers/base/Kconfig    |   12 ++++++++++++
 drivers/base/devtmpfs.c |   12 ++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index b34b5cd..a37fcf2 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -56,6 +56,18 @@ config DEVTMPFS_MOUNT
 	  rescue mode with init=/bin/sh, even when the /dev directory
 	  on the rootfs is completely empty.
 
+config DEVTMPFS_SAFE
+	bool "Use nosuid,noexec mount options on devtmpfs"
+	depends on DEVTMPFS
+	help
+	  This instructs the kernel to include the MS_NOEXEC and
+	  MS_NOSUID mount flags when mounting devtmpfs. This prevents
+	  certain kinds of code-execution attacks on embedded platforms.
+
+	  Notice: If enabled, things like /dev/mem cannot be mmapped
+	  with the PROT_EXEC flag. This can break, for example, non-KMS
+	  video drivers.
+
 config STANDALONE
 	bool "Select only drivers that don't need compile-time external firmware" if EXPERIMENTAL
 	default y
diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 147d1a4..bf85fbf 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -340,6 +340,10 @@ static int handle_remove(const char *nodename, struct device *dev)
 int devtmpfs_mount(const char *mntdir)
 {
 	int err;
+	int mflags = MS_SILENT;
+#ifdef CONFIG_DEVTMPFS_SAFE
+	mflags |= MS_NOEXEC | MS_NOSUID;
+#endif
 
 	if (!mount_dev)
 		return 0;
@@ -347,7 +351,7 @@ int devtmpfs_mount(const char *mntdir)
 	if (!thread)
 		return 0;
 
-	err = sys_mount("devtmpfs", (char *)mntdir, "devtmpfs", MS_SILENT, NULL);
+	err = sys_mount("devtmpfs", (char *)mntdir, "devtmpfs", mflags, NULL);
 	if (err)
 		printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
 	else
@@ -369,10 +373,14 @@ static int devtmpfsd(void *p)
 {
 	char options[] = "mode=0755";
 	int *err = p;
+	int mflags = MS_SILENT;
+#ifdef CONFIG_DEVTMPFS_SAFE
+	mflags |= MS_NOEXEC | MS_NOSUID;
+#endif
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
