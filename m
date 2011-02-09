Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab1BIGmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 01:42:17 -0500
Received: from ozlabs.org ([203.10.76.45]:44474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab1BIGlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 01:41:46 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [RFC,PATCH 2/3] clk: Generic support for fixed-rate clocks
Message-Id: <1297233693.242725.820672531799.2.gpush@pororo>
In-Reply-To: <1297233693.241680.897691111624.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Russell King <linux@arm.linux.org.uk>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Wed, 09 Feb 2011 14:41:33 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since most platforms will need a fixed-rate clock, add one. This will
also serve as a basic example of an implementation of struct clk.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 drivers/clk/clk.c   |   14 ++++++++++++++
 include/linux/clk.h |   16 ++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index c35478a..bbbdb0d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -124,3 +124,17 @@ void __clk_put(struct clk *clk)
 	if (clk->ops->put)
 		clk->ops->put(clk);
 }
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
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fe806b7..e67fdb0 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -185,6 +185,22 @@ static inline void clk_common_init(struct clk *clk)
 	mutex_init(&clk->prepare_lock);
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
+#define DEFINE_CLK_FIXED(name, r) \
+	struct clk_fixed name = INIT_CLK_FIXED(name, r)
+
 #else /* !CONFIG_USE_COMMON_STRUCT_CLK */
 
 /*
