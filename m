Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2HZQCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:02:35 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:61272
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753910Ab2HZQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852299"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Andrew Victor <linux@maxim.org.za>
Cc: kernel-janitors@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/13] arch/arm/mach-at91/gpio.c: use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:01:03 +0200
Message-Id: <1345996865-32082-12-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
clk_enable, and clk_disable and clk_unprepare.  They make the code more
concise, and ensure that clk_unprepare is called when clk_enable fails.

A simplified version of the semantic patch that introduces calls to these
functions is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

- clk_prepare(e);
- clk_enable(e);
+ clk_prepare_enable(e);

@@
expression e;
@@

- clk_disable(e);
- clk_unprepare(e);
+ clk_disable_unprepare(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/arm/mach-at91/gpio.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index be42cf0..7760f35 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -956,19 +956,14 @@ static int __init at91_gpio_setup_clk(int idx)
 		goto err;
 	}
 
-	if (clk_prepare(at91_gpio->clock))
-		goto clk_prep_err;
-
 	/* enable PIO controller's clock */
-	if (clk_enable(at91_gpio->clock)) {
+	if (clk_prepare_enable(at91_gpio->clock)) {
 		pr_err("at91_gpio.%d, failed to enable clock, ignoring.\n", idx);
-		goto clk_err;
+		goto clk_prep_err;
 	}
 
 	return 0;
 
-clk_err:
-	clk_unprepare(at91_gpio->clock);
 clk_prep_err:
 	clk_put(at91_gpio->clock);
 err:

