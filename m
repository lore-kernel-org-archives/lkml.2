Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab1DYNZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 09:25:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57972 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1DYNZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 09:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=rXolpKUoCwHsAMNCUyP1eM104n9FQrN9GVSG4+BZxdUB12AumOsddq94mfyDAkWNGW
         NUBi+uRzrw2LPL8hgwyuebauSo/heR3COrD1ApvCZWpczGgzP4XS8BTF7UcNURZSWRf5
         H1ObR/WV4qZTw1GSqTboInYhnsKceiNrtKWA0=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, Magnus Damm <magnus.damm@gmail.com>,
        lethal@linux-sh.org, simon@horms.net, linux-sh@vger.kernel.org
Date: Mon, 25 Apr 2011 22:32:11 +0900
Message-Id: <20110425133211.3957.30006.sendpatchset@t400s>
Subject: [PATCH] clocksource: sh_cmt: __clocksource_updatefreq_hz() update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch updates the clocksource part of the CMT driver
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

 Tested on the sh7372 Mackerel board with CMT10.

 drivers/clocksource/sh_cmt.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- 0001/drivers/clocksource/sh_cmt.c
+++ work/drivers/clocksource/sh_cmt.c	2011-04-25 14:47:06.000000000 +0900
@@ -416,11 +416,15 @@ static cycle_t sh_cmt_clocksource_read(s
 
 static int sh_cmt_clocksource_enable(struct clocksource *cs)
 {
+	int ret;
 	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
 
 	p->total_cycles = 0;
 
-	return sh_cmt_start(p, FLAG_CLOCKSOURCE);
+	ret = sh_cmt_start(p, FLAG_CLOCKSOURCE);
+	if (!ret)
+		__clocksource_updatefreq_hz(cs, p->rate);
+	return ret;
 }
 
 static void sh_cmt_clocksource_disable(struct clocksource *cs)
@@ -448,19 +452,10 @@ static int sh_cmt_register_clocksource(s
 	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
-	/* clk_get_rate() needs an enabled clock */
-	clk_enable(p->clk);
-	p->rate = clk_get_rate(p->clk) / ((p->width == 16) ? 512 : 8);
-	clk_disable(p->clk);
-
-	/* TODO: calculate good shift from rate and counter bit width */
-	cs->shift = 0;
-	cs->mult = clocksource_hz2mult(p->rate, cs->shift);
-
 	dev_info(&p->pdev->dev, "used as clock source\n");
 
-	clocksource_register(cs);
-
+	/* Register with dummy 1 Hz value, gets updated in ->enable() */
+	clocksource_register_hz(cs, 1);
 	return 0;
 }
 
