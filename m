Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab2JJOU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:20:26 -0400
Received: from mail.x86-64.org ([217.9.48.20]:44186 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505Ab2JJOUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:20:17 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 1/3] Add DEVICE_BIT_ATTR
Date: Wed, 10 Oct 2012 16:19:59 +0200
Message-Id: <1349878801-15956-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349878801-15956-1-git-send-email-bp@amd64.org>
References: <1349878801-15956-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Not-Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/base/core.c    | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  9 +++++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index abea76c36a4b..3946a6fbe7bf 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -171,6 +171,42 @@ ssize_t device_show_int(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(device_show_int);
 
+/*
+ * ->var is the bitvector and ->aux is the bit number
+ */
+ssize_t device_store_bit(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t size)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	u64 *bvec = (u64 *)ea->var;
+	u8 val, bit = ea->aux;
+
+	if (kstrtou8(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	if (val > 63)
+		return -EINVAL;
+
+	if (val)
+		*bvec |=  BIT_64(bit);
+	else
+		*bvec &= ~BIT_64(bit);
+
+	return size;
+}
+EXPORT_SYMBOL_GPL(device_store_bit);
+
+ssize_t device_show_bit(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+	u64 *bvec = (u64 *)ea->var;
+	u8 bit = ea->aux;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", !!(*bvec & BIT_64(bit)));
+}
+EXPORT_SYMBOL_GPL(device_show_bit);
+
 /**
  *	device_release - free device structure.
  *	@kobj:	device's kobject.
diff --git a/include/linux/device.h b/include/linux/device.h
index 86ef6ab553b1..78ade603875f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -486,6 +486,7 @@ struct device_attribute {
 struct dev_ext_attribute {
 	struct device_attribute attr;
 	void *var;
+	u8 aux;
 };
 
 ssize_t device_show_ulong(struct device *dev, struct device_attribute *attr,
@@ -496,6 +497,10 @@ ssize_t device_show_int(struct device *dev, struct device_attribute *attr,
 			char *buf);
 ssize_t device_store_int(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count);
+ssize_t device_show_bit(struct device *dev, struct device_attribute *attr,
+			char *buf);
+ssize_t device_store_bit(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count);
 
 #define DEVICE_ATTR(_name, _mode, _show, _store) \
 	struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
@@ -505,6 +510,10 @@ ssize_t device_store_int(struct device *dev, struct device_attribute *attr,
 #define DEVICE_INT_ATTR(_name, _mode, _var) \
 	struct dev_ext_attribute dev_attr_##_name = \
 		{ __ATTR(_name, _mode, device_show_int, device_store_int), &(_var) }
+#define DEVICE_BIT_ATTR(_name, _mode, _bitvec, _bit) \
+	struct dev_ext_attribute dev_attr_##_name = \
+		{ __ATTR(_name, _mode, device_show_bit, device_store_bit), \
+			&(_bitvec), (_bit) }
 #define DEVICE_ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store) \
 	struct device_attribute dev_attr_##_name =		\
 		__ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store)
-- 
1.8.0.rc0.18.gf84667d

