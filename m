Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1C0Luu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 07:50:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:11820 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab1C0Lut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 07:50:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,250,1299484800"; 
   d="scan'208";a="619514644"
Date: Sun, 27 Mar 2011 07:50:47 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: Compiling virtualbox with Linux 2.6.38
Message-ID: <20110327115047.GJ4183@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The Virtualbox developers have segregated themselves into a walled garden
of their own choice (only subscribers may post to vbox-dev; you have to
sign up to join their forums, etc, etc.).  So in the hopes of reaching
anybody who cares, here is a patch to Virtualbox to handle the recent
VFS change of replacing ->get_sb with ->mount.

This isn't enough to get virtualbox to compile with a recent kernel.
The DRM change that replaced pci_driver with kdriver seems harder to ifdef
a solution to.  Maybe somebody else out there has already done this work
and is similarly waiting for somebody else to do the VFS portion :-)

Index: src/VBox/Additions/linux/sharedfolders/vfsmod.c
===================================================================
--- src/VBox/Additions/linux/sharedfolders/vfsmod.c	(revision 36443)
+++ src/VBox/Additions/linux/sharedfolders/vfsmod.c	(working copy)
@@ -453,20 +453,31 @@
     TRACE();
     return get_sb_nodev(fs_type, flags, data, sf_read_super_26);
 }
-#else
+#elsif LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 37)
 static int sf_get_sb(struct file_system_type *fs_type, int flags,
                      const char *dev_name, void *data, struct vfsmount *mnt)
 {
     TRACE();
     return get_sb_nodev(fs_type, flags, data, sf_read_super_26, mnt);
 }
+#else
+static struct dentry *sf_mount(struct file_system_type *fs_type, int flags,
+                     const char *dev_name, void *data)
+{
+    TRACE();
+    return mount_nodev(fs_type, flags, data, sf_read_super_26);
+}
 #endif
 
 static struct file_system_type vboxsf_fs_type =
 {
     .owner   = THIS_MODULE,
     .name    = "vboxsf",
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 37)
     .get_sb  = sf_get_sb,
+#else
+    .mount   = sf_mount,
+#endif
     .kill_sb = kill_anon_super
 };
 #endif
