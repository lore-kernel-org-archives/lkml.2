Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1HJDw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 23:52:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56067 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1HJDwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 23:52:25 -0400
From: Hemant Pedanekar <hemantp@ti.com>
To: <linux-omap@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: [PATCH] omap: timer: Set dmtimer used as clocksource in autoreload mode
Date: Wed, 10 Aug 2011 09:22:03 +0530
Message-ID: <1312948323-22823-1-git-send-email-hemantp@ti.com>
X-Mailer: git-send-email 1.7.3.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_OMAP_32K_TIMER is not selected and dmtimer is used as clocksource, the
timer stops counting once overflow occurs as it was not set in autoreload mode.
This results into timekeeping failure: for example, 'sleep 1' at the shell after
the timer counter overflow would hang.

This patch sets up autoreload when starting the clocksource timer which fixes
the above issue.

Signed-off-by: Hemant Pedanekar <hemantp@ti.com>
---
 arch/arm/mach-omap2/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index e964072..796b935 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -293,7 +293,7 @@ static void __init omap2_gp_clocksource_init(int gptimer_id,
 	pr_info("OMAP clocksource: GPTIMER%d at %lu Hz\n",
 		gptimer_id, clksrc.rate);
 
-	__omap_dm_timer_load_start(clksrc.io_base, OMAP_TIMER_CTRL_ST, 0, 1);
+	omap_dm_timer_set_load_start(&clksrc, 1, 0);
 	init_sched_clock(&cd, dmtimer_update_sched_clock, 32, clksrc.rate);
 
 	if (clocksource_register_hz(&clocksource_gpt, clksrc.rate))
-- 
1.7.3.5

