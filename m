Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab0IXQfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:35:53 -0400
Received: from kroah.org ([198.145.64.141]:37413 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932827Ab0IXQfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:50 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:48 2010
Message-Id: <20100924163348.921002016@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Aurelien Jarno <aurelien@aurel32.net>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [55/68] [PATCH] clocksource: sh_tmu: compute mult and shift before registration
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

commit 66f49121ffa41a19c59965b31b046d8368fec3c7 upstream.

Since commit 98962465ed9e6ea99c38e0af63fe1dcb5a79dc25 ("nohz: Prevent
clocksource wrapping during idle"), the CPU of an R2D board never goes
to idle. This commit assumes that mult and shift are assigned before
the clocksource is registered. As a consequence the safe maximum sleep
time is negative and the CPU never goes into idle.

This patch fixes the problem by moving mult and shift initialization
from sh_tmu_clocksource_enable() to sh_tmu_register_clocksource().

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/clocksource/sh_tmu.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -199,16 +199,8 @@ static cycle_t sh_tmu_clocksource_read(s
 static int sh_tmu_clocksource_enable(struct clocksource *cs)
 {
 	struct sh_tmu_priv *p = cs_to_sh_tmu(cs);
-	int ret;
 
-	ret = sh_tmu_enable(p);
-	if (ret)
-		return ret;
-
-	/* TODO: calculate good shift from rate and counter bit width */
-	cs->shift = 10;
-	cs->mult = clocksource_hz2mult(p->rate, cs->shift);
-	return 0;
+	return sh_tmu_enable(p);
 }
 
 static void sh_tmu_clocksource_disable(struct clocksource *cs)
@@ -228,6 +220,16 @@ static int sh_tmu_register_clocksource(s
 	cs->disable = sh_tmu_clocksource_disable;
 	cs->mask = CLOCKSOURCE_MASK(32);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
+
+	/* clk_get_rate() needs an enabled clock */
+	clk_enable(p->clk);
+	/* channel will be configured at parent clock / 4 */
+	p->rate = clk_get_rate(p->clk) / 4;
+	clk_disable(p->clk);
+	/* TODO: calculate good shift from rate and counter bit width */
+	cs->shift = 10;
+	cs->mult = clocksource_hz2mult(p->rate, cs->shift);
+
 	pr_info("sh_tmu: %s used as clock source\n", cs->name);
 	clocksource_register(cs);
 	return 0;


