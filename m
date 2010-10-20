Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0JTXoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:44:34 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52975 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279Ab0JTXo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:44:29 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Magnus Damm <magnus.damm@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/7] sh: convert to clocksource_register_hz
Date: Wed, 20 Oct 2010 16:44:08 -0700
Message-Id: <1287618253-13258-3-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287618253-13258-2-git-send-email-johnstul@us.ibm.com>
References: <1287618253-13258-1-git-send-email-johnstul@us.ibm.com>
 <1287618253-13258-2-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert sh_tmu/sh_cmt clocksources to clocksource_register_hz

I was unable to test these, so any help from maintainers would
be appreciated!

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Magnus Damm <magnus.damm@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/sh_cmt.c |   14 +++++++-------
 drivers/clocksource/sh_tmu.c |   12 ++++++------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 717305d..aeee6ac 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -411,11 +411,16 @@ static cycle_t sh_cmt_clocksource_read(struct clocksource *cs)
 
 static int sh_cmt_clocksource_enable(struct clocksource *cs)
 {
+	int ret;
 	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
 
 	p->total_cycles = 0;
 
-	return sh_cmt_start(p, FLAG_CLOCKSOURCE);
+	ret = sh_cmt_start(p, FLAG_CLOCKSOURCE);
+	p->rate = clk_get_rate(p->clk) / (p->width == 16) ? 512 : 8;
+	
+	__clocksource_updatefreq_hz(cs, p->rate);
+	return ret;
 }
 
 static void sh_cmt_clocksource_disable(struct clocksource *cs)
@@ -448,14 +453,9 @@ static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
 	p->rate = clk_get_rate(p->clk) / (p->width == 16) ? 512 : 8;
 	clk_disable(p->clk);
 
-	/* TODO: calculate good shift from rate and counter bit width */
-	cs->shift = 0;
-	cs->mult = clocksource_hz2mult(p->rate, cs->shift);
-
 	dev_info(&p->pdev->dev, "used as clock source\n");
 
-	clocksource_register(cs);
-
+	clocksource_register_hz(cs, p->rate);
 	return 0;
 }
 
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index de71590..09831d9 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -199,8 +199,11 @@ static cycle_t sh_tmu_clocksource_read(struct clocksource *cs)
 static int sh_tmu_clocksource_enable(struct clocksource *cs)
 {
 	struct sh_tmu_priv *p = cs_to_sh_tmu(cs);
-
-	return sh_tmu_enable(p);
+	int ret = sh_tmu_enable(p);
+	p->rate = clk_get_rate(p->clk) / (p->width == 16) ? 512 : 8;
+	
+	__clocksource_updatefreq_hz(cs, p->rate);
+	return ret;
 }
 
 static void sh_tmu_clocksource_disable(struct clocksource *cs)
@@ -226,12 +229,9 @@ static int sh_tmu_register_clocksource(struct sh_tmu_priv *p,
 	/* channel will be configured at parent clock / 4 */
 	p->rate = clk_get_rate(p->clk) / 4;
 	clk_disable(p->clk);
-	/* TODO: calculate good shift from rate and counter bit width */
-	cs->shift = 10;
-	cs->mult = clocksource_hz2mult(p->rate, cs->shift);
 
 	dev_info(&p->pdev->dev, "used as clock source\n");
-	clocksource_register(cs);
+	clocksource_register_hz(cs, p->rate);
 	return 0;
 }
 
-- 
1.6.0.4

