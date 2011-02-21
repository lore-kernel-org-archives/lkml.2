Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1BUCvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 21:51:14 -0500
Received: from ozlabs.org ([203.10.76.45]:54102 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab1BUCvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 21:51:12 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2/2] clk: Generic support for fixed-rate clocks
Message-Id: <1298256658.862488.956979497586.2.gpush@pororo>
In-Reply-To: <1298256658.861611.43913489619.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-sh@vger.kernel.org>,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Russell King <linux@arm.linux.org.uk>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Mon, 21 Feb 2011 10:50:58 +0800
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
index 0bc9c6f..0da0bb9 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -130,3 +130,17 @@ void __clk_put(struct clk *clk)
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
index 604be74..7c0808c 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -155,6 +155,22 @@ static inline void clk_common_init(struct clk *clk)
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
