Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971Ab0EYWQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:16:42 -0400
Received: from kroah.org ([198.145.64.141]:38075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab0EYWQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:16:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>
Subject: [PATCH 1/1] driver core: add devname module aliases to allow module on-demand auto-loading
Date: Tue, 25 May 2010 15:16:38 -0700
Message-Id: <1274825798-29613-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100525221546.GA29511@kroah.com>
References: <20100525221546.GA29511@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds:
  alias: devname:<name>
to some common kernel modules, which will allow the on-demand loading
of the kernel module when the device node is accessed.

Ideally all these modules would be compiled-in, but distros seems too
much in love with their modularization that we need to cover the common
cases with this new facility. It will allow us to remove a bunch of pretty
useless init scripts and modprobes from init scripts.

The static device node aliases will be carried in the module itself. The
program depmod will extract this information to a file in the module directory:
  $ cat /lib/modules/2.6.34-00650-g537b60d-dirty/modules.devname
  # Device nodes to trigger on-demand module loading.
  microcode cpu/microcode c10:184
  fuse fuse c10:229
  ppp_generic ppp c108:0
  tun net/tun c10:200
  dm_mod mapper/control c10:235

Udev will pick up the depmod created file on startup and create all the
static device nodes which the kernel modules specify, so that these modules
get automatically loaded when the device node is accessed:
  $ /sbin/udevd --debug
  ...
  static_dev_create_from_modules: mknod '/dev/cpu/microcode' c10:184
  static_dev_create_from_modules: mknod '/dev/fuse' c10:229
  static_dev_create_from_modules: mknod '/dev/ppp' c108:0
  static_dev_create_from_modules: mknod '/dev/net/tun' c10:200
  static_dev_create_from_modules: mknod '/dev/mapper/control' c10:235
  udev_rules_apply_static_dev_perms: chmod '/dev/net/tun' 0666
  udev_rules_apply_static_dev_perms: chmod '/dev/fuse' 0666

A few device nodes are switched to statically allocated numbers, to allow
the static nodes to work. This might also useful for systems which still run
a plain static /dev, which is completely unsafe to use with any dynamic minor
numbers.

Note:
The devname aliases must be limited to the *common* and *single*instance*
device nodes, like the misc devices, and never be used for conceptually limited
systems like the loop devices, which should rather get fixed properly and get a
control node for losetup to talk to, instead of creating a random number of
device nodes in advance, regardless if they are ever used.

This facility is to hide the mess distros are creating with too modualized
kernels, and just to hide that these modules are not compiled-in, and not to
paper-over broken concepts. Thanks! :)

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Ian Kent <raven@themaw.net>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/devices.txt        |    2 ++
 arch/x86/kernel/microcode_core.c |    1 +
 drivers/net/ppp_generic.c        |    4 ++--
 drivers/net/tun.c                |    1 +
 fs/autofs4/dev-ioctl.c           |    5 ++++-
 fs/btrfs/super.c                 |    5 ++++-
 fs/fuse/dev.c                    |    1 +
 include/linux/miscdevice.h       |    2 ++
 8 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 53d64d3..1d83d12 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -443,6 +443,8 @@ Your cooperation is appreciated.
 		231 = /dev/snapshot	System memory snapshot device
 		232 = /dev/kvm		Kernel-based virtual machine (hardware virtualization extensions)
 		233 = /dev/kmview	View-OS A process with a view
+		234 = /dev/btrfs-control	Btrfs control device
+		235 = /dev/autofs	Autofs control device
 		240-254			Reserved for local use
 		255			Reserved for MISC_DYNAMIC_MINOR
 
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 2cd8c54..fa6551d 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -260,6 +260,7 @@ static void microcode_dev_exit(void)
 }
 
 MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
+MODULE_ALIAS("devname:cpu/microcode");
 #else
 #define microcode_dev_init()	0
 #define microcode_dev_exit()	do { } while (0)
diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 5441688..c5f8eb1 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -2926,5 +2926,5 @@ EXPORT_SYMBOL(ppp_output_wakeup);
 EXPORT_SYMBOL(ppp_register_compressor);
 EXPORT_SYMBOL(ppp_unregister_compressor);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_CHARDEV_MAJOR(PPP_MAJOR);
-MODULE_ALIAS("/dev/ppp");
+MODULE_ALIAS_CHARDEV(PPP_MAJOR, 0);
+MODULE_ALIAS("devname:ppp");
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 97b2553..005cad6 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1649,3 +1649,4 @@ MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(TUN_MINOR);
+MODULE_ALIAS("devname:net/tun");
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index d29b7f6..d832062 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -736,11 +736,14 @@ static const struct file_operations _dev_ioctl_fops = {
 };
 
 static struct miscdevice _autofs_dev_ioctl_misc = {
-	.minor 		= MISC_DYNAMIC_MINOR,
+	.minor		= AUTOFS_MINOR,
 	.name  		= AUTOFS_DEVICE_NAME,
 	.fops  		= &_dev_ioctl_fops
 };
 
+MODULE_ALIAS_MISCDEV(AUTOFS_MINOR);
+MODULE_ALIAS("devname:autofs");
+
 /* Register/deregister misc character device */
 int autofs_dev_ioctl_init(void)
 {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1866dff..2909a03 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -832,11 +832,14 @@ static const struct file_operations btrfs_ctl_fops = {
 };
 
 static struct miscdevice btrfs_misc = {
-	.minor		= MISC_DYNAMIC_MINOR,
+	.minor		= BTRFS_MINOR,
 	.name		= "btrfs-control",
 	.fops		= &btrfs_ctl_fops
 };
 
+MODULE_ALIAS_MISCDEV(BTRFS_MINOR);
+MODULE_ALIAS("devname:btrfs-control");
+
 static int btrfs_interface_init(void)
 {
 	return misc_register(&btrfs_misc);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index eb7e942..e53df5e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
+MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 8b5f7cc..b631c46 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -31,6 +31,8 @@
 #define FUSE_MINOR		229
 #define KVM_MINOR		232
 #define VHOST_NET_MINOR		233
+#define BTRFS_MINOR		234
+#define AUTOFS_MINOR		235
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
-- 
1.7.0.3

