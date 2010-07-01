Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab0GAVik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:38:40 -0400
Received: from kroah.org ([198.145.64.141]:33000 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759210Ab0GAVOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:40 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:58 2010
Message-Id: <20100701174257.983808629@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mundt <lethal@linux-sh.org>
Subject: [137/200] clocksource: sh_cmt: compute mult and shift before registration
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mundt <lethal@linux-sh.org>

commit f4d7c3565c1692c54d9152b52090fe73f0029e37 upstream.

Based on the sh_tmu change in 66f49121ffa41a19c59965b31b046d8368fec3c7
("clocksource: sh_tmu: compute mult and shift before registration").
The same issues impact the sh_cmt driver, so we take the same approach
here.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/clocksource/sh_cmt.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -413,18 +413,10 @@ static cycle_t sh_cmt_clocksource_read(s
 static int sh_cmt_clocksource_enable(struct clocksource *cs)
 {
 	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
-	int ret;
 
 	p->total_cycles = 0;
 
-	ret = sh_cmt_start(p, FLAG_CLOCKSOURCE);
-	if (ret)
-		return ret;
-
-	/* TODO: calculate good shift from rate and counter bit width */
-	cs->shift = 0;
-	cs->mult = clocksource_hz2mult(p->rate, cs->shift);
-	return 0;
+	return sh_cmt_start(p, FLAG_CLOCKSOURCE);
 }
 
 static void sh_cmt_clocksource_disable(struct clocksource *cs)
@@ -451,7 +443,18 @@ static int sh_cmt_register_clocksource(s
 	cs->resume = sh_cmt_clocksource_resume;
 	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
+
+	/* clk_get_rate() needs an enabled clock */
+	clk_enable(p->clk);
+	p->rate = clk_get_rate(p->clk) / (p->width == 16) ? 512 : 8;
+	clk_disable(p->clk);
+
+	/* TODO: calculate good shift from rate and counter bit width */
+	cs->shift = 10;
+	cs->mult = clocksource_hz2mult(p->rate, cs->shift);
+
 	pr_info("sh_cmt: %s used as clock source\n", cs->name);
+
 	clocksource_register(cs);
 	return 0;
 }


