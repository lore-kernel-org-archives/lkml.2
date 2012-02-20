Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2BTN5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 08:57:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab2BTN5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 08:57:00 -0500
From: Thomas Weber <weber@corscience.de>
To: NeilBrown <neil.brown@suse.de>
Cc: Paul Walmsley <paul@pwsan.com>, Evgeniy Polyakov <zbr@ioremap.net>,
        Greg KH <greg@kroah.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP: hdq: software-supervised control of HDQ_ICLK
Date: Mon, 20 Feb 2012 14:56:00 +0100
Message-Id: <1329746160-1152-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <4F422C2B.9030908@gmail.com>
References: <4F422C2B.9030908@gmail.com>
X-Provags-ID: V02:K0:Y1gk+Ycu/1X2P7VPS5l9ZRH14GoWWkDloI2LYxwtfzm
 6pfvDEj9/XeyfJAemANPhs8u5Yr+7y3GlZuC74SO/HOx4dtnjt
 NkizVLBEsyp9mwuIteI7Kmfv3M4lSGWZCqk8Iffr2teoNs5s5M
 9I3HhtX5363k7D1YVG3ZNLrt90LAubWFsuVnCN34w3HSf9S9Qv
 JtBdtde4QaZz7TyIknBhuhE2mljOFEqRA1Jq5uS9CGnnM9e+On
 +9yTVODRJ7nAZ/IRtaCCWicVMsGbuhuCrALuqV6Y+MHRAhistw
 hYYy+H0qvS07W8tUnpAcoZxUakmRzFRDBAnVIlGn/HuyJ5Qx72
 YverQiRo25fMgBi53gN6ekKQ0mA+CFJX49a6SxuGlfpu7k4qZR
 kqEhXfPyUE93Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Walmsley <paul@pwsan.com>

Hello Neil, hello Paul,

the patch below fixes the communication between omap3 and
bq27000 battery.

I got the patch from Neil's git tree and removed the part for hdq1w.

Regards,
Thomas

Do not automatically enable interface clock autoidle on
HDQ_ICLK. Require the hwmod layer to use software gating on
HDQ_ICLK. This is because the CM FSM that handles HDQ_FCLK
appears to not be working as expected.
---
 arch/arm/mach-omap2/clock3xxx_data.c    |    1 +
 arch/arm/plat-omap/clock.c              |    4 +++-
 arch/arm/plat-omap/include/plat/clock.h |    1 +
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/clock3xxx_data.c b/arch/arm/mach-omap2/clock3xxx_data.c
index d75e5f6..ac95afd 100644
--- a/arch/arm/mach-omap2/clock3xxx_data.c
+++ b/arch/arm/mach-omap2/clock3xxx_data.c
@@ -1882,6 +1882,7 @@ static struct clk hdq_ick = {
 	.enable_bit	= OMAP3430_EN_HDQ_SHIFT,
 	.clkdm_name	= "core_l4_clkdm",
 	.recalc		= &followparent_recalc,
+	.flags		= SWSUP_ICLK_IDLE,
 };
 
 static struct clk mcspi4_ick = {
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 567e4b5..3fce16a 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -348,7 +348,9 @@ int omap_clk_enable_autoidle_all(void)
 	spin_lock_irqsave(&clockfw_lock, flags);
 
 	list_for_each_entry(c, &clocks, node)
-		if (c->ops->allow_idle)
+		if (c->flags & SWSUP_ICLK_IDLE && c->ops->deny_idle)
+			c->ops->deny_idle(c);
+		else if (c->ops->allow_idle)
 			c->ops->allow_idle(c);
 
 	spin_unlock_irqrestore(&clockfw_lock, flags);
diff --git a/arch/arm/plat-omap/include/plat/clock.h b/arch/arm/plat-omap/include/plat/clock.h
index 240a7b9..f4f6e7b 100644
--- a/arch/arm/plat-omap/include/plat/clock.h
+++ b/arch/arm/plat-omap/include/plat/clock.h
@@ -191,6 +191,7 @@ struct dpll_data {
 #define ENABLE_ON_INIT		(1 << 3)	/* Enable upon framework init */
 #define INVERT_ENABLE		(1 << 4)	/* 0 enables, 1 disables */
 #define CLOCK_CLKOUTX2		(1 << 5)
+#define SWSUP_ICLK_IDLE		(1 << 6)
 
 /**
  * struct clk - OMAP struct clk
-- 
1.7.8.4

