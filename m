Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2CGVVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:21:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47997 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2CGVU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:20:57 -0500
Date: Wed, 7 Mar 2012 22:20:25 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linaro-dev@lists.linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH v5 4/4] clk: basic clock hardware types
Message-ID: <20120307212025.GC26882@pengutronix.de>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-5-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330763341-3437-5-git-send-email-mturquette@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:15:48 up 116 days,  5:02, 29 users,  load average: 0.00, 0.07,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 12:29:01AM -0800, Mike Turquette wrote:
> +struct clk *clk_register_divider(struct device *dev, const char *name,
> +		const char *parent_name, unsigned long flags,
> +		void __iomem *reg, u8 shift, u8 width,
> +		u8 clk_divider_flags, spinlock_t *lock)
> +{
> +	struct clk_divider *div;
> +	char **parent_names = NULL;
> +	u8 len;
> +
> +	div = kmalloc(sizeof(struct clk_divider), GFP_KERNEL);
> +
> +	if (!div) {
> +		pr_err("%s: could not allocate divider clk\n", __func__);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	/* struct clk_divider assignments */
> +	div->reg = reg;
> +	div->shift = shift;
> +	div->width = width;
> +	div->flags = clk_divider_flags;
> +	div->lock = lock;
> +
> +	if (parent_name) {
> +		parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
> +
> +		if (! parent_names)
> +			goto out;
> +
> +		len = sizeof(char) * strlen(parent_name);
> +
> +		parent_names[0] = kmalloc(len, GFP_KERNEL);
> +
> +		if (!parent_names[0])
> +			goto out;
> +
> +		strncpy(parent_names[0], parent_name, len);
> +	}
> +
> +out:
> +	return clk_register(dev, name,
> +			&clk_divider_ops, &div->hw,
> +			parent_names,
> +			(parent_name ? 1 : 0),
> +			flags);
> +}

clk_register_divider and also clk_register_gate have some problems.
First you allocate memory with exactly the string length without
the terminating 0. Then the functions leak memory when clk_register
fails. Could you fold in the following patch to fix this?

Sascha

8<--------------------------------------------------

fix divider/gate registration

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/clk/clk-divider.c    |   34 +++++++++++++++-------------------
 drivers/clk/clk-gate.c       |   33 ++++++++++++++-------------------
 include/linux/clk-provider.h |    2 ++
 3 files changed, 31 insertions(+), 38 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 8f02930..99b6b55 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -156,14 +156,13 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
 		u8 clk_divider_flags, spinlock_t *lock)
 {
 	struct clk_divider *div;
-	char **parent_names = NULL;
-	u8 len;
+	struct clk *clk;
 
-	div = kmalloc(sizeof(struct clk_divider), GFP_KERNEL);
+	div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
 
 	if (!div) {
 		pr_err("%s: could not allocate divider clk\n", __func__);
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}
 
 	/* struct clk_divider assignments */
@@ -174,25 +173,22 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
 	div->lock = lock;
 
 	if (parent_name) {
-		parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
-
-		if (! parent_names)
-			goto out;
-
-		len = sizeof(char) * strlen(parent_name);
-
-		parent_names[0] = kmalloc(len, GFP_KERNEL);
-
-		if (!parent_names[0])
+		div->parent[0] = kstrdup(parent_name, GFP_KERNEL);
+		if (!div->parent[0])
 			goto out;
-
-		strncpy(parent_names[0], parent_name, len);
 	}
 
-out:
-	return clk_register(dev, name,
+	clk = clk_register(dev, name,
 			&clk_divider_ops, &div->hw,
-			parent_names,
+			div->parent,
 			(parent_name ? 1 : 0),
 			flags);
+	if (clk)
+		return clk;
+
+out:
+	kfree(div->parent[0]);
+	kfree(div);
+
+	return NULL;
 }
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index e831f7b..92c0489 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -80,14 +80,13 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 		u8 clk_gate_flags, spinlock_t *lock)
 {
 	struct clk_gate *gate;
-	char **parent_names = NULL;
-	u8 len;
+	struct clk *clk;
 
-	gate = kmalloc(sizeof(struct clk_gate), GFP_KERNEL);
+	gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
 
 	if (!gate) {
 		pr_err("%s: could not allocate gated clk\n", __func__);
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}
 
 	/* struct clk_gate assignments */
@@ -97,25 +96,21 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 	gate->lock = lock;
 
 	if (parent_name) {
-		parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
-
-		if (! parent_names)
-			goto out;
-
-		len = sizeof(char) * strlen(parent_name);
-
-		parent_names[0] = kmalloc(len, GFP_KERNEL);
-
-		if (!parent_names[0])
+		gate->parent[0] = kstrdup(parent_name, GFP_KERNEL);
+		if (!gate->parent[0])
 			goto out;
-
-		strncpy(parent_names[0], parent_name, len);
 	}
 
-out:
-	return clk_register(dev, name,
+	clk = clk_register(dev, name,
 			&clk_gate_ops, &gate->hw,
-			parent_names,
+			gate->parent,
 			(parent_name ? 1 : 0),
 			flags);
+	if (clk)
+		return clk;
+out:
+	kfree(gate->parent[0]);
+	kfree(gate);
+
+	return NULL;
 }
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 9b7dd5e..ed1f918 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -174,6 +174,7 @@ struct clk_gate {
 	u8		bit_idx;
 	u8		flags;
 	spinlock_t	*lock;
+	char		*parent[1];
 };
 
 #define CLK_GATE_SET_TO_DISABLE		BIT(0)
@@ -210,6 +211,7 @@ struct clk_divider {
 	u8		width;
 	u8		flags;
 	spinlock_t	*lock;
+	char		*parent[1];
 };
 
 #define CLK_DIVIDER_ONE_BASED		BIT(0)
-- 
1.7.9.1

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
