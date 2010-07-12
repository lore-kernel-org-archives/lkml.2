Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0GLChl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:37:41 -0400
Received: from ozlabs.org ([203.10.76.45]:49153 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab0GLChj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:37:39 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2/2] clk: Generic support for fixed-rate clocks
Message-Id: <1278902245.966134.443547423568.2.gpush@pororo>
In-Reply-To: <1278902245.965352.293245076889.0.gpush@pororo>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Ben Herrenchmidt <benh@kernel.crashing.org>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Mon, 12 Jul 2010 10:37:25 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since most platforms will need a fixed-rate clock, add one. This will
also serve as a basic example of an implementation of struct clk.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 include/linux/clk.h |   13 +++++++++++++
 kernel/clk.c        |   14 ++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index a95cc82..85e1d44 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -90,6 +90,19 @@ static inline void clk_common_init(struct clk *clk)
 	clk->enable_count = 0;
 }
 
+/* Simple fixed-rate clock */
+struct clk_fixed {
+	struct clk	clk;
+	unsigned long	rate;
+};
+
+extern struct clk_ops clk_fixed_ops;
+
+#define INIT_CLK_FIXED(r) { \
+	.clk = INIT_CLK(clk_fixed_ops), \
+	.rate = (r) \
+}
+
 #else /* !CONFIG_USE_COMMON_STRUCT_CLK */
 
 /*
diff --git a/kernel/clk.c b/kernel/clk.c
index cdea25f..32f25ef 100644
--- a/kernel/clk.c
+++ b/kernel/clk.c
@@ -99,3 +99,17 @@ struct clk *clk_get_parent(struct clk *clk)
 	return ERR_PTR(-ENOSYS);
 }
 EXPORT_SYMBOL_GPL(clk_get_parent);
+
+/* clk_fixed support */
+
+#define to_clk_fixed(clk) (container_of(clk, struct clk_fixed, clk))
+
+static unsigned long clk_fixed_get_rate(struct clk *clk)
+{
+	return to_clk_fixed(clk)->rate;
+}
+
+struct clk_ops clk_fixed_ops = {
+	.get_rate = clk_fixed_get_rate,
+};
+EXPORT_SYMBOL_GPL(clk_fixed_ops);
