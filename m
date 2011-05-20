Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab1ETAVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:21:05 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38875 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933480Ab1ETALP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:15 -0400
X-Sasl-enc: fWG6fHcBEETPDfBzRnF+87fqpFjBKs6rIezmH70nj8rh 1305850274
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ludwig Nussel <ludwig.nussel@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/44] kernel/ksysfs.c: expose file_caps_enabled in sysfs
Date: Thu, 19 May 2011 17:10:24 -0700
Message-Id: <1305850262-9575-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ludwig Nussel <ludwig.nussel@suse.de>

A kernel booted with no_file_caps allows to install fscaps on a binary
but doesn't actually honor the fscaps when running the binary. Userspace
currently has no sane way to determine whether installing fscaps
actually has any effect. Since parsing /proc/cmdline is fragile this
patch exposes the current setting (1 or 0) via /sys/kernel/fscaps

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ABI/testing/sysfs-kernel-fscaps |    8 ++++++++
 kernel/ksysfs.c                               |   10 ++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-fscaps

diff --git a/Documentation/ABI/testing/sysfs-kernel-fscaps b/Documentation/ABI/testing/sysfs-kernel-fscaps
new file mode 100644
index 0000000..50a3033
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-fscaps
@@ -0,0 +1,8 @@
+What:		/sys/kernel/fscaps
+Date:		February 2011
+KernelVersion:	2.6.38
+Contact:	Ludwig Nussel <ludwig.nussel@suse.de>
+Description
+		Shows whether file system capabilities are honored
+		when executing a binary
+
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 0b624e7..3b053c0 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -16,6 +16,7 @@
 #include <linux/kexec.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <linux/capability.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
@@ -131,6 +132,14 @@ KERNEL_ATTR_RO(vmcoreinfo);
 
 #endif /* CONFIG_KEXEC */
 
+/* whether file capabilities are enabled */
+static ssize_t fscaps_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", file_caps_enabled);
+}
+KERNEL_ATTR_RO(fscaps);
+
 /*
  * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
  */
@@ -158,6 +167,7 @@ struct kobject *kernel_kobj;
 EXPORT_SYMBOL_GPL(kernel_kobj);
 
 static struct attribute * kernel_attrs[] = {
+	&fscaps_attr.attr,
 #if defined(CONFIG_HOTPLUG)
 	&uevent_seqnum_attr.attr,
 	&uevent_helper_attr.attr,
-- 
1.7.4.2

