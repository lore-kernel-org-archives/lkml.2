Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab1DYNbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 09:31:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40345 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab1DYNby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 09:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=ZAExWkjb+TTO3HnaTxSAFalacoHzwI5WJsmxQAYvTo5y7/Xv4LfQuuTfCQazcUGPPN
         ZOPwShnTqeNiojysE9qJVR9ACYraz1XgSlCJVOL9pBT0IMblHi+JXnMuw7nMRn8aJWk7
         f5KK7pj71STSFgU2KqHpspZpZBFCd34ItVYkw=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, Magnus Damm <magnus.damm@gmail.com>,
        lethal@linux-sh.org, linux-sh@vger.kernel.org
Date: Mon, 25 Apr 2011 22:38:37 +0900
Message-Id: <20110425133837.4242.80952.sendpatchset@t400s>
Subject: [PATCH] clocksource: sh_tmu: __clocksource_updatefreq_hz() update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch updates the clocksource part of the TMU driver
to make use of the __clocksource_updatefreq_hz() function.

Without this patch the old code uses clocksource_register()
together with a hack that assumes a never changing clock rate
(see clk_enable(), clk_get_rate() and clk_disable()).

The patch uses clocksource_register_hz() with 1 Hz as initial
value, then lets the ->enable() callback update the value
with __clocksource_updatefreq_hz() once the struct clk has
been enabled and the frequency is stable.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Thanks to John Stultz for the framework changes and the
 initial implementation.

 Tested on the sh7372 Mackerel board with TMU00 and TMU01.

 drivers/clocksource/sh_tmu.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- 0001/drivers/clocksource/sh_tmu.c
+++ work/drivers/clocksource/sh_tmu.c	2011-04-25 15:07:41.000000000 +0900
@@ -199,8 +199,12 @@ static cycle_t sh_tmu_clocksource_read(s
 static int sh_tmu_clocksource_enable(struct clocksource *cs)
 {
 	struct sh_tmu_priv *p = cs_to_sh_tmu(cs);
+	int ret;
 
-	return sh_tmu_enable(p);
+	ret = sh_tmu_enable(p);
+	if (!ret)
+		__clocksource_updatefreq_hz(cs, p->rate);
+	return ret;
 }
 
 static void sh_tmu_clocksource_disable(struct clocksource *cs)
@@ -221,17 +225,10 @@ static int sh_tmu_register_clocksource(s
 	cs->mask = CLOCKSOURCE_MASK(32);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
-	/* clk_get_rate() needs an enabled clock */
-	clk_enable(p->clk);
-	/* channel will be configured at parent clock / 4 */
-	p->rate = clk_get_rate(p->clk) / 4;
-	clk_disable(p->clk);
-	/* TODO: calculate good shift from rate and counter bit width */
-	cs->shift = 10;
-	cs->mult = clocksource_hz2mult(p->rate, cs->shift);
-
 	dev_info(&p->pdev->dev, "used as clock source\n");
-	clocksource_register(cs);
+
+	/* Register with dummy 1 Hz value, gets updated in ->enable() */
+	clocksource_register_hz(cs, 1);
 	return 0;
 }
 
