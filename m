Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2JQLOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:14:02 -0400
Received: from mail.x86-64.org ([217.9.48.20]:49945 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab2JQLN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:13:59 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/5] drivers/base: Add a DEVICE_BOOL_ATTR macro
Date: Wed, 17 Oct 2012 13:13:51 +0200
Message-Id: <1350472435-29307-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc2.4.g42e55a5
In-Reply-To: <1350472435-29307-1-git-send-email-bp@amd64.org>
References: <1350472435-29307-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... which, analogous to DEVICE_INT_ATTR provides functionality to
set/clear bools. Its purpose is to be used where values need to be used
as booleans in configuration context.

Next patch uses this.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/base/core.c    | 24 ++++++++++++++++++++++++
 include/linux/device.h |  7 +++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index abea76c36a4b..d298fbe7d1b4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -171,6 +171,30 @@ ssize_t device_show_int(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(device_show_int);
 
+ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t size)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	u8 bval;
+
+	if (kstrtou8(buf, 10, &bval) < 0)
+		return -EINVAL;
+
+	*(bool *)ea->var = !!bval;
+
+	return size;
+}
+EXPORT_SYMBOL_GPL(device_store_bool);
+
+ssize_t device_show_bool(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", *(bool *)(ea->var));
+}
+EXPORT_SYMBOL_GPL(device_show_bool);
+
 /**
  *	device_release - free device structure.
  *	@kobj:	device's kobject.
diff --git a/include/linux/device.h b/include/linux/device.h
index 86ef6ab553b1..50c85a26b003 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -496,6 +496,10 @@ ssize_t device_show_int(struct device *dev, struct device_attribute *attr,
 			char *buf);
 ssize_t device_store_int(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count);
+ssize_t device_show_bool(struct device *dev, struct device_attribute *attr,
+			char *buf);
+ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count);
 
 #define DEVICE_ATTR(_name, _mode, _show, _store) \
 	struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
@@ -505,6 +509,9 @@ ssize_t device_store_int(struct device *dev, struct device_attribute *attr,
 #define DEVICE_INT_ATTR(_name, _mode, _var) \
 	struct dev_ext_attribute dev_attr_##_name = \
 		{ __ATTR(_name, _mode, device_show_int, device_store_int), &(_var) }
+#define DEVICE_BOOL_ATTR(_name, _mode, _var) \
+	struct dev_ext_attribute dev_attr_##_name = \
+		{ __ATTR(_name, _mode, device_show_bool, device_store_bool), &(_var) }
 #define DEVICE_ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store) \
 	struct device_attribute dev_attr_##_name =		\
 		__ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store)
-- 
1.8.0.rc2.4.g42e55a5

