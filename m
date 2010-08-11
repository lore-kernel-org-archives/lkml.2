Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab0HKCUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 22:20:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33748 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077Ab0HKCUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 22:20:10 -0400
Subject: [PATCH] arm: fix versatile boot hang (seen with qemu)
From: john stultz <johnstul@us.ibm.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, arnd.bergmann@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 19:19:51 -0700
Message-ID: <1281493191.2955.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Russell,

	I have been having troubles getting the 2.6.35 kernel to boot in my
qemu-system-arm environment. It worked with 2.6.34, and so I bisected it
down to:
	commit e388771458b4ff3ad81ab70e390b24d069647da4
	Author: Russell King <rmk+kernel@arm.linux.org.uk>
	Date:   Thu Jan 14 13:30:16 2010 +0000
	ARM: Realview/Versatile: separate out common SP804 timer code

The issue seems to be that the common sp804_set_mode function was not
identical to the ones it replaced. It added an extra writel and did not
write zero out on shutdown.

The following patch resolves the issue for me and gets things booting.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/arm/plat-versatile/timer-sp.c b/arch/arm/plat-versatile/timer-sp.c
index 98722f4..6d7fff4 100644
--- a/arch/arm/plat-versatile/timer-sp.c
+++ b/arch/arm/plat-versatile/timer-sp.c
@@ -102,8 +102,6 @@ static void sp804_set_mode(enum clock_event_mode mode,
 {
 	unsigned long ctrl = TIMER_CTRL_32BIT | TIMER_CTRL_IE;
 
-	writel(ctrl, clkevt_base + TIMER_CTRL);
-
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		writel(TIMER_RELOAD, clkevt_base + TIMER_LOAD);
@@ -118,7 +116,7 @@ static void sp804_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	default:
-		break;
+		ctrl = 0;
 	}
 
 	writel(ctrl, clkevt_base + TIMER_CTRL);


