Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1LND70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 22:59:26 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:48474 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756702Ab1LND6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 22:58:52 -0500
From: Mike Turquette <mturquette@linaro.org>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        paul@pwsan.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, mturquette@linaro.org, mturquette@ti.com,
        andrew@lunn.ch, Yong Shen <yong.shen@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v4 6/6] clk: export the clk tree topology to debugfs
Date: Tue, 13 Dec 2011 19:53:58 -0800
Message-Id: <1323834838-2206-7-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323834838-2206-1-git-send-email-mturquette@linaro.org>
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Represents the clk tree as a directory hieraching in debugfs.  Each clk
is a directory filled with the following read-only entries:

clk_rate
clk_flags
clk_prepare_count
clk_enable_count
clk_notifier_count

This commit borrows some code from Yong Shen's patch to export clkdev
clk's to debugfs:
http://git.pengutronix.de/?p=imx/linux-2.6.git;a=commit;h=30aa15230747b3b92da16d841b1cf369f07192e7

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Cc: Yong Shen <yong.shen@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/clk/Kconfig |    9 +++
 drivers/clk/clk.c   |  176 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/clk.h |    3 +
 3 files changed, 186 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index ba7eb8c..09cc198 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -19,3 +19,12 @@ config GENERIC_CLK_BASIC
 	help
 	   Allow use of basic, single-function clock types.  These
 	   common definitions can be used across many platforms.
+
+config GENERIC_CLK_DEBUG
+	bool "Clock tree representation in debugs"
+	depends on GENERIC_CLK
+	help
+	  Creates a directory hierchy in debugfs for visualizing the clk
+	  tree structure as well.  Each directory contains read-only
+	  members that export information specific to that clk node:
+	  clk_rate, clk_flags, clk_prepare_count & clk_enable_count.
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f86cb98..a6ddbb1 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -23,6 +23,166 @@ static DEFINE_MUTEX(prepare_lock);
 static HLIST_HEAD(clk_root_list);
 static LIST_HEAD(clk_notifier_list);
 
+/***        debugfs support        ***/
+
+#ifdef CONFIG_GENERIC_CLK_DEBUG
+#include <linux/debugfs.h>
+
+static struct dentry *rootdir;
+static int inited = 0;
+
+/* caller must hold prepare_lock */
+static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
+{
+	struct dentry *d;
+	int ret = -ENOMEM;
+
+	if (!clk || !pdentry) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	d = debugfs_create_dir(clk->name, pdentry);
+	if (!d)
+		goto out;
+
+	clk->dentry = d;
+
+	d = debugfs_create_u64("clk_rate", S_IRUGO, clk->dentry,
+			(u64 *)&clk->rate);
+	if (!d)
+		goto err_out;
+
+	d = debugfs_create_x32("clk_flags", S_IRUGO, clk->dentry,
+			(u32 *)&clk->flags);
+	if (!d)
+		goto err_out;
+
+	d = debugfs_create_u32("clk_prepare_count", S_IRUGO, clk->dentry,
+			(u32 *)&clk->prepare_count);
+	if (!d)
+		goto err_out;
+
+	d = debugfs_create_u32("clk_enable_count", S_IRUGO, clk->dentry,
+			(u32 *)&clk->enable_count);
+	if (!d)
+		goto err_out;
+
+	d = debugfs_create_u32("clk_notifier_count", S_IRUGO, clk->dentry,
+			(u32 *)&clk->notifier_count);
+	if (!d)
+		goto err_out;
+
+	ret = 0;
+	goto out;
+
+err_out:
+	debugfs_remove(clk->dentry);
+out:
+	return ret;
+}
+
+/* caller must hold prepare_lock */
+static int clk_debug_create_subtree(struct clk *clk, struct dentry *pdentry)
+{
+	struct clk *child;
+	struct hlist_node *tmp;
+	int ret = -EINVAL;;
+
+	if (!clk || !pdentry)
+		goto out;
+
+	ret = clk_debug_create_one(clk, pdentry);
+
+	if (ret)
+		goto out;
+
+	hlist_for_each_entry(child, tmp, &clk->children, child_node)
+		clk_debug_create_subtree(child, clk->dentry);
+
+	ret = 0;
+out:
+	return ret;
+}
+
+/**
+ * clk_debug_register - add a clk node to the debugfs clk tree
+ * @clk: the clk being added to the debugfs clk tree
+ *
+ * Dynamically adds a clk to the debugfs clk tree if debugfs has been
+ * initialized.  Otherwise it bails out early since the debugfs clk tree
+ * will be created lazily by clk_debug_init as part of a late_initcall.
+ *
+ * Caller must hold prepare_lock.  Only clk_init calls this function (so
+ * far) so this is taken care.
+ */
+static int clk_debug_register(struct clk *clk)
+{
+	struct clk *parent;
+	struct dentry *pdentry;
+	int ret = 0;
+
+	if (!inited)
+		goto out;
+
+	parent = clk->parent;
+
+	/*
+	 * Check to see if a clk is a root clk.  Also check that it is
+	 * safe to add this clk to debugfs
+	 */
+	if (!parent)
+		pdentry = rootdir;
+	else
+		if (parent->dentry)
+			pdentry = parent->dentry;
+		else
+			goto out;
+
+	ret = clk_debug_create_subtree(clk, pdentry);
+
+out:
+	return ret;
+}
+
+/**
+ * clk_debug_init - lazily create the debugfs clk tree visualization
+ *
+ * clks are often initialized very early during boot before memory can
+ * be dynamically allocated and well before debugfs is setup.
+ * clk_debug_init walks the clk tree hierarchy while holding
+ * prepare_lock and creates the topology as part of a late_initcall,
+ * thus insuring that clks initialized very early will still be
+ * represented in the debugfs clk tree.  This function should only be
+ * called once at boot-time, and all other clks added dynamically will
+ * be done so with clk_debug_register.
+ */
+static int __init clk_debug_init(void)
+{
+	struct clk *root_clk;
+	struct hlist_node *tmp;
+
+	rootdir = debugfs_create_dir("clk", NULL);
+
+	if (!rootdir)
+		return -ENOMEM;
+
+	mutex_lock(&prepare_lock);
+
+	hlist_for_each_entry(root_clk, tmp, &clk_root_list, child_node)
+		clk_debug_create_subtree(root_clk, rootdir);
+
+	inited = 1;
+
+	mutex_unlock(&prepare_lock);
+
+	return 0;
+}
+late_initcall(clk_debug_init);
+#else
+static inline int clk_debug_register(struct clk *clk) { return 0; }
+#endif /* CONFIG_GENERIC_CLK_DEBUG */
+
 /***        clk API        ***/
 
 void __clk_unprepare(struct clk *clk)
@@ -574,15 +734,25 @@ EXPORT_SYMBOL_GPL(clk_get_parent);
 
 void __clk_reparent(struct clk *clk, struct clk *new_parent)
 {
+	struct dentry *d;
+
 	if (!clk || !new_parent)
 		return;
 
 	hlist_del(&clk->child_node);
 	hlist_add_head(&clk->child_node, &new_parent->children);
 
-	clk->parent = new_parent;
+#ifdef CONFIG_GENERIC_CLK_DEBUG
+	d = debugfs_rename(clk->parent->dentry, clk->dentry,
+			new_parent->dentry, clk->name);
+	if (d)
+		clk->dentry = d;
+	else
+		pr_debug("%s: failed to reparent debugfs entry for %s\n",
+				__func__, clk->name);
+#endif
 
-	/* FIXME update sysfs clock topology */
+	clk->parent = new_parent;
 }
 
 /**
@@ -697,6 +867,8 @@ void clk_init(struct device *dev, struct clk *clk)
 	else
 		clk->rate = 0;
 
+	clk_debug_register(clk);
+
 	mutex_unlock(&prepare_lock);
 
 	return;
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 55049ee..6cf3e2b 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -46,6 +46,9 @@ struct clk {
 	struct hlist_head	children;
 	struct hlist_node	child_node;
 	unsigned int		notifier_count;
+#ifdef CONFIG_GENERIC_CLK_DEBUG
+	struct dentry		*dentry;
+#endif
 };
 
 /**
-- 
1.7.5.4

