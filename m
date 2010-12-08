Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab0LHCI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:08:29 -0500
Received: from ozlabs.org ([203.10.76.45]:54356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab0LHCIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 21:08:24 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2/2] clk: Generic support for fixed-rate clocks
Message-Id: <1291774094.270492.31002734529.2.gpush@pororo>
In-Reply-To: <1291774094.269634.503532219345.0.gpush@pororo>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Wed, 08 Dec 2010 10:08:14 +0800
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
index e09e40e..ae7e4ed 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -158,6 +158,19 @@ static inline void clk_common_init(struct clk *clk)
 		mutex_init(&clk->lock.mutex);
 }
 
+/* Simple fixed-rate clock */
+struct clk_fixed {
+	struct clk	clk;
+	unsigned long	rate;
+};
+
+extern struct clk_ops clk_fixed_ops;
+
+#define INIT_CLK_FIXED(name, r) { \
+	.clk = INIT_CLK(name.clk, clk_fixed_ops), \
+	.rate = (r) \
+}
+
 #else /* !CONFIG_USE_COMMON_STRUCT_CLK */
 
 /*
diff --git a/kernel/clk.c b/kernel/clk.c
index 1545e69..2779abb 100644
--- a/kernel/clk.c
+++ b/kernel/clk.c
@@ -98,3 +98,17 @@ struct clk *clk_get_parent(struct clk *clk)
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
