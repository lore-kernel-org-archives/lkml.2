Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab1GFVJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:09:39 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:49317 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756272Ab1GFVJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:09:37 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jul 2011 17:09:37 EDT
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: fix regression in IXP4xx clocksource
Date: Wed, 06 Jul 2011 23:02:17 +0200
Message-ID: <m3liwb15t2.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

Commit 234b6ceddb4fc2a4bc5b9a7670f070f6e69e0868

   clocksource: convert ARM 32-bit up counting clocksources

broke the build for ixp4xx and made big endian operation impossible.
This commit restores the original behaviour.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 74ed81a..0777257 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -419,14 +419,20 @@ static void notrace ixp4xx_update_sched_clock(void)
 /*
  * clocksource
  */
+
+static cycle_t ixp4xx_clocksource_read(struct clocksource *c)
+{
+	return *IXP4XX_OSTS;
+}
+
 unsigned long ixp4xx_timer_freq = IXP4XX_TIMER_FREQ;
 EXPORT_SYMBOL(ixp4xx_timer_freq);
 static void __init ixp4xx_clocksource_init(void)
 {
 	init_sched_clock(&cd, ixp4xx_update_sched_clock, 32, ixp4xx_timer_freq);
 
-	clocksource_mmio_init(&IXP4XX_OSTS, "OSTS", ixp4xx_timer_freq, 200, 32,
-			clocksource_mmio_readl_up);
+	clocksource_mmio_init(NULL, "OSTS", ixp4xx_timer_freq, 200, 32,
+			ixp4xx_clocksource_read);
 }
 
 /*
