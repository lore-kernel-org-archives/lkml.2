Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab1B0QEO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:04:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:58544 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab1B0QBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:01:43 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 06/17] unicore32 time.c: change calculate method for clock_event_device
Date: Sun, 27 Feb 2011 15:59:34 +0000
Message-Id: <5c1cbf284fb0ca905fc3f44a9d17e9cbebfd814e.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

apply clockevents_calc_mult_shift() to get rid of
shift assignment and mult calculation for osmr0
  -- by advice with Thomas Gleixner

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/kernel/time.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/unicore32/kernel/time.c b/arch/unicore32/kernel/time.c
index 8090d76..8bb4b81 100644
--- a/arch/unicore32/kernel/time.c
+++ b/arch/unicore32/kernel/time.c
@@ -66,11 +66,6 @@ puv3_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *c)
 static struct clock_event_device ckevt_puv3_osmr0 = {
 	.name		= "osmr0",
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
-#ifdef CONFIG_ARCH_FPGA
-	.shift		= 18, /* correct shift val: 16, but warn_on_slowpath */
-#else
-	.shift          = 30,
-#endif
 	.rating		= 200,
 	.set_next_event	= puv3_osmr0_set_next_event,
 	.set_mode	= puv3_osmr0_set_mode,
@@ -101,8 +96,8 @@ void __init time_init(void)
 	OST_OIER = 0;		/* disable any timer interrupts */
 	OST_OSSR = 0;		/* clear status on all timers */
 
-	ckevt_puv3_osmr0.mult =
-		div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, ckevt_puv3_osmr0.shift);
+	clockevents_calc_mult_shift(&ckevt_puv3_osmr0, CLOCK_TICK_RATE, 5);
+
 	ckevt_puv3_osmr0.max_delta_ns =
 		clockevent_delta2ns(0x7fffffff, &ckevt_puv3_osmr0);
 	ckevt_puv3_osmr0.min_delta_ns =
-- 
1.7.4.1

