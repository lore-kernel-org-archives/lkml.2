Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2K1LxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 06:53:21 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:58728 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754437Ab2K1LxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 06:53:18 -0500
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: Mike Turquette <mturquette@ti.com>, Russell King <linux@arm.linux.org.uk>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [RFC 2/2] clk: per-user clock accounting for debug
Date: Wed, 28 Nov 2012 12:52:51 +0100
Message-ID: <1354103571-27394-2-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1354103571-27394-1-git-send-email-rabin.vincent@stericsson.com>
References: <1354103571-27394-1-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a clock has multiple users, the WARNING on imbalance of
enable/disable may not show the guilty party since although they may
have commited the error earlier, the warning is emitted later when some
other user, presumably innocent, disables the clock.

Provide per-user clock enable/disable accounting and disabler tracking
in order to help debug these problems.

NOTE: with this patch, clk_get_parent() behaves like clk_get(), i.e. it
needs to be matched with a clk_put().  Otherwise, memory will leak.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/clk/clk-core.h      | 18 ++++++++++++++----
 drivers/clk/clk.c           | 35 +++++++++++++++++++++++++++++++++--
 drivers/clk/clkdev.c        |  9 ++++++---
 include/linux/clk-private.h |  6 +++++-
 4 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/clk-core.h b/drivers/clk/clk-core.h
index 341ae45..c8259c2 100644
--- a/drivers/clk/clk-core.h
+++ b/drivers/clk/clk-core.h
@@ -4,11 +4,21 @@
 struct clk_core;
 
 #ifdef CONFIG_COMMON_CLK
-#define clk_to_clk_core(clk)	((struct clk_core *)(clk))
-#define clk_core_to_clk(core)	((struct clk *)(core))
+struct clk_core *clk_to_clk_core(struct clk *clk);
+struct clk *clk_core_to_clk(struct clk_core *clk_core, const char *dev,
+			    const char *con);
+
+static inline void clk_free_clk(struct clk *clk)
+{
+	kfree(clk);
+}
 #else
-#define clk_to_clk_core(clk)	((clk))
-#define clk_core_to_clk(core)	((core))
+#define clk_to_clk_core(clk)		((clk))
+#define clk_core_to_clk(core, dev, con)	((core))
+
+static inline void clk_free_clk(struct clk *clk)
+{
+}
 #endif
 
 #endif
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1fb7043..57ba594 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -250,6 +250,27 @@ static int clk_disable_unused(void)
 }
 late_initcall(clk_disable_unused);
 
+struct clk *clk_core_to_clk(struct clk_core *clk_core, const char *dev,
+			    const char *con)
+{
+	struct clk *clk;
+
+	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+	if (!clk)
+		return ERR_PTR(-ENOMEM);
+
+	clk->core = clk_core;
+	clk->dev_id = dev;
+	clk->con_id = con;
+
+	return clk;
+}
+
+struct clk_core *clk_to_clk_core(struct clk *clk)
+{
+	return clk->core;
+}
+
 /***    helper functions   ***/
 
 inline const char *__clk_get_name(struct clk_core *clk)
@@ -504,7 +525,15 @@ void clk_disable(struct clk *clk_user)
 	unsigned long flags;
 
 	spin_lock_irqsave(&enable_lock, flags);
-	__clk_disable(clk);
+	if (!WARN(clk_user->enable_count == 0,
+		  "incorrect disable clk dev %s con %s last disabler %pF\n",
+		  clk_user->dev_id, clk_user->con_id, clk_user->last_disable)) {
+
+		clk_user->last_disable = __builtin_return_address(0);
+		clk_user->enable_count--;
+
+		__clk_disable(clk);
+	}
 	spin_unlock_irqrestore(&enable_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clk_disable);
@@ -559,6 +588,8 @@ int clk_enable(struct clk *clk_user)
 
 	spin_lock_irqsave(&enable_lock, flags);
 	ret = __clk_enable(clk);
+	if (!ret)
+		clk_user->enable_count++;
 	spin_unlock_irqrestore(&enable_lock, flags);
 
 	return ret;
@@ -976,7 +1007,7 @@ struct clk *clk_get_parent(struct clk *clk_user)
 	parent = __clk_get_parent(clk);
 	mutex_unlock(&prepare_lock);
 
-	return clk_core_to_clk(parent);
+	return clk_core_to_clk(parent, clk_user->dev_id, clk_user->con_id);
 }
 EXPORT_SYMBOL_GPL(clk_get_parent);
 
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 5ddcaf1..1321b7c 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -43,7 +43,7 @@ struct clk *of_clk_get(struct device_node *np, int index)
 
 	clk = of_clk_get_from_provider(&clkspec);
 	of_node_put(clkspec.np);
-	return clk_core_to_clk(clk);
+	return clk_core_to_clk(clk, np->full_name, NULL);
 }
 EXPORT_SYMBOL(of_clk_get);
 
@@ -151,7 +151,7 @@ struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 	if (!cl)
 		return ERR_PTR(-ENOENT);
 
-	return clk_core_to_clk(cl->clk);
+	return clk_core_to_clk(cl->clk, dev_id, con_id);
 }
 EXPORT_SYMBOL(clk_get_sys);
 
@@ -172,7 +172,10 @@ EXPORT_SYMBOL(clk_get);
 
 void clk_put(struct clk *clk)
 {
-	__clk_put(clk_to_clk_core(clk));
+	clk_core_t *core = clk_to_clk_core(clk);
+
+	clk_free_clk(clk);
+	__clk_put(core);
 }
 EXPORT_SYMBOL(clk_put);
 
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index e5b766e..406c951 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -47,7 +47,11 @@ struct clk_core {
 };
 
 struct clk {
-	struct clk_core clk;
+	struct clk_core	*core;
+	unsigned int	enable_count;
+	const char	*dev_id;
+	const char	*con_id;
+	void		*last_disable;
 };
 
 /*
-- 
1.7.11.3

