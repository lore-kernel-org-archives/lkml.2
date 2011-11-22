Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab1KVBoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:44:04 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:58388 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547Ab1KVBn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:43:59 -0500
From: Mike Turquette <mturquette@ti.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        aul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, mturquette@ti.com,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
Date: Mon, 21 Nov 2011 17:40:47 -0800
Message-Id: <1321926047-14211-6-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduces kobject support for the common struct clk, exports per-clk
data via read-only callbacks and models the clk tree topology in sysfs.

Also adds support for generating the clk tree in clk_init and migrating
nodes when input sources are switches in clk_set_parent.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/Kconfig     |   10 +++
 drivers/clk/Makefile    |    1 +
 drivers/clk/clk-sysfs.c |  199 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clk.c       |    5 +-
 include/linux/clk.h     |   36 ++++++++-
 5 files changed, 248 insertions(+), 3 deletions(-)
 create mode 100644 drivers/clk/clk-sysfs.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index ba7eb8c..8f8e7ac 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -19,3 +19,13 @@ config GENERIC_CLK_BASIC
 	help
 	   Allow use of basic, single-function clock types.  These
 	   common definitions can be used across many platforms.
+
+config GENERIC_CLK_SYSFS
+	bool "Clock tree topology and debug info"
+	depends on EXPERIMENTAL && GENERIC_CLK
+	help
+	   Creates clock tree represenation in sysfs.  Directory names
+	   and hierarchy represent clock names and tree structure,
+	   respectively.  Each directory exports clock rate, flags,
+	   prepare_count and enable_count info as read-only for debug
+	   purposes.
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 68b20a1..806a9999 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -2,3 +2,4 @@
 obj-$(CONFIG_CLKDEV_LOOKUP)		+= clkdev.o
 obj-$(CONFIG_GENERIC_CLK)		+= clk.o
 obj-$(CONFIG_GENERIC_CLK_BASIC)		+= clk-basic.o
+obj-$(CONFIG_GENERIC_CLK_SYSFS)		+= clk-sysfs.o
diff --git a/drivers/clk/clk-sysfs.c b/drivers/clk/clk-sysfs.c
new file mode 100644
index 0000000..8ccf9e3
--- /dev/null
+++ b/drivers/clk/clk-sysfs.c
@@ -0,0 +1,199 @@
+/*
+ * Copyright (C) 2011 Linaro Ltd <mturquette@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Clock tree topology and debug info for the common clock framework
+ */
+
+#include <linux/clk.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/err.h>
+
+#define MAX_STRING_LENGTH	32
+
+static struct kobject *clk_kobj;
+LIST_HEAD(kobj_list);
+
+struct clk_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct clk *clk, char *buf);
+};
+
+static ssize_t clk_rate_show(struct clk *clk, char *buf)
+{
+	if (IS_ERR_OR_NULL(clk))
+		return -ENODEV;
+
+	return snprintf(buf, MAX_STRING_LENGTH, "%lu\n", clk->rate);
+}
+
+static ssize_t clk_flags_show(struct clk *clk, char *buf)
+{
+	if (IS_ERR_OR_NULL(clk))
+		return -ENODEV;
+
+	return snprintf(buf, MAX_STRING_LENGTH, "0x%lX\n", clk->flags);
+}
+
+static ssize_t clk_prepare_count_show(struct clk *clk, char *buf)
+{
+	if (IS_ERR_OR_NULL(clk))
+		return -ENODEV;
+
+	return snprintf(buf, MAX_STRING_LENGTH, "%d\n", clk->prepare_count);
+}
+
+static ssize_t clk_enable_count_show(struct clk *clk, char *buf)
+{
+	if (IS_ERR_OR_NULL(clk))
+		return -ENODEV;
+
+	return snprintf(buf, MAX_STRING_LENGTH, "%d\n", clk->enable_count);
+}
+
+static ssize_t clk_show(struct kobject *kobj, struct attribute *attr,
+		char *buf)
+{
+	struct clk *clk;
+	struct clk_attribute *clk_attr;
+	ssize_t ret = -EINVAL;
+
+	clk = container_of(kobj, struct clk, kobj);
+	clk_attr = container_of(attr, struct clk_attribute, attr);
+
+	if (!clk || !clk_attr)
+		goto out;
+
+	/* we don't do any locking for debug operations */
+
+	/* refcount++ */
+	kobject_get(&clk->kobj);
+
+	if (clk_attr->show)
+		ret = clk_attr->show(clk, buf);
+	else
+		ret = -EIO;
+
+	/* refcount-- */
+	kobject_put(&clk->kobj);
+
+out:
+	return ret;
+}
+
+static struct clk_attribute clk_rate = __ATTR_RO(clk_rate);
+static struct clk_attribute clk_flags = __ATTR_RO(clk_flags);
+static struct clk_attribute clk_prepare_count = __ATTR_RO(clk_prepare_count);
+static struct clk_attribute clk_enable_count = __ATTR_RO(clk_enable_count);
+
+static struct attribute *clk_default_attrs[] = {
+	&clk_rate.attr,
+	&clk_flags.attr,
+	&clk_prepare_count.attr,
+	&clk_enable_count.attr,
+	NULL,
+};
+
+static const struct sysfs_ops clk_ops = {
+	.show	= clk_show,
+};
+
+static void clk_release(struct kobject *kobj)
+{
+	struct clk *clk;
+
+	clk = container_of(kobj, struct clk, kobj);
+
+	complete(&clk->kobj_unregister);
+}
+
+static struct kobj_type clk_ktype = {
+	.sysfs_ops	= &clk_ops,
+	.default_attrs	= clk_default_attrs,
+	.release	= clk_release,
+};
+
+int clk_kobj_add(struct clk *clk)
+{
+	if (IS_ERR(clk))
+		return -EINVAL;
+
+	/*
+	 * Some kobject trickery!
+	 *
+	 * We want to (ab)use the kobject infrastructure to track our
+	 * tree topology for us, specifically the root clocks (which are
+	 * otherwise not remembered in a global list).
+	 *
+	 * Unfortunately we might not be able to allocate memory yet
+	 * when this path is hit.  This pretty much rules out anything
+	 * that looks or smells like kobject_add, since there are
+	 * allocations for kobject->name and a dependency on sysfs being
+	 * initialized.
+	 *
+	 * To get around this we initialize the kobjects and (ab)use
+	 * struct kobject's list_head member, "entry".  Later on we walk
+	 * this list in clk_sysfs_tree_create() to make proper
+	 * kobject_add calls once it is safe to do so.
+	 *
+	 * FIXME - this is starting to smell alot like clkdev (i.e.
+	 * tracking the clocks in a list)
+	 */
+
+	kobject_init(&clk->kobj, &clk_ktype);
+	list_add_tail(&clk->kobj.entry, &kobj_list);
+	return 0;
+}
+
+int clk_kobj_reparent(struct clk *clk, struct clk *parent)
+{
+	int ret;
+
+	if (!clk || !parent)
+		return -EINVAL;
+
+	ret = kobject_move(&clk->kobj, &parent->kobj);
+	if (ret)
+		pr_warning("%s: failed to reparent %s to %s in sysfs\n",
+				__func__, clk->name, parent->name);
+
+	return ret;
+}
+
+static int __init clk_sysfs_init(void)
+{
+	struct list_head *tmp;
+
+	clk_kobj = kobject_create_and_add("clk", NULL);
+
+	WARN_ON(!clk_kobj);
+
+	list_for_each(tmp, &kobj_list) {
+		struct kobject *kobj;
+		struct clk *clk;
+		struct kobject *parent_kobj = NULL;
+		int ret;
+
+		kobj = container_of(tmp, struct kobject, entry);
+
+		clk = container_of(kobj, struct clk, kobj);
+
+		/* assumes list is ordered */
+		if (clk->parent)
+			parent_kobj = &clk->parent->kobj;
+		else
+			parent_kobj = clk_kobj;
+
+		ret = kobject_add(kobj, parent_kobj, clk->name);
+		if (ret)
+			pr_warning("%s: failed to create sysfs entry for %s\n",
+					__func__, clk->name);
+	}
+
+	return 0;
+}
+late_initcall(clk_sysfs_init);
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 12c9994..85dabdb 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -436,7 +436,8 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
 
 	clk->parent = new_parent;
 
-	/* FIXME update sysfs clock topology */
+	/* update sysfs clock topology */
+	clk_kobj_reparent(clk, clk->parent);
 }
 
 /**
@@ -531,6 +532,8 @@ void clk_init(struct device *dev, struct clk *clk)
 	else
 		clk->rate = 0;
 
+	clk_kobj_add(clk);
+
 	mutex_unlock(&prepare_lock);
 
 	return;
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 8ed354a..99337ca 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -14,8 +14,8 @@
 #define __LINUX_CLK_H
 
 #include <linux/kernel.h>
-
-#include <linux/kernel.h>
+#include <linux/kobject.h>
+#include <linux/completion.h>
 #include <linux/errno.h>
 
 struct device;
@@ -46,6 +46,10 @@ struct clk {
 	unsigned int		prepare_count;
 	struct hlist_head	children;
 	struct hlist_node	child_node;
+#ifdef CONFIG_GENERIC_CLK_SYSFS
+	struct kobject		kobj;
+	struct completion	kobj_unregister;
+#endif
 };
 
 /**
@@ -177,6 +181,34 @@ int clk_register_gate(struct device *dev, const char *name, unsigned long flags,
  */
 void clk_init(struct device *dev, struct clk *clk);
 
+#ifdef CONFIG_GENERIC_CLK_SYSFS
+/**
+ * clk_kobj_add - create a clk entry in sysfs
+ * @clk: clk to model in sysfs
+ *
+ * Create a directory in sysfs with the same name as clk.  Also creates
+ * read-only entries for the common struct clk members (rate, flags,
+ * prepare_count & enable_count).  The topology of the tree is
+ * represented by the sysfs directory structure itself.
+ */
+int clk_kobj_add(struct clk *clk);
+
+/**
+ * clk_kobj_reparent - reparent a clk entry in sysfs
+ * @clk: the child clk that is switching parents
+ * @parent: the new parent clk
+ *
+ * Simple call to kobject_move to keep sysfs up to date with the
+ * hardware clock topology
+ */
+int clk_kobj_reparent(struct clk *clk, struct clk *parent);
+#else
+static inline int clk_kobj_add(struct clk *clk)
+{ return 0; }
+static inline int clk_kobj_reparent(struct clk *clk, struct clk *parent)
+{ return 0; }
+#endif
+
 #endif /* !CONFIG_GENERIC_CLK */
 
 /**
-- 
1.7.4.1

