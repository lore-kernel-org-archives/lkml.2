Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1GOPE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:04:29 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:33251 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751869Ab1GOPE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:04:27 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 2/3] watchdog: sp805: Don't write 0 to the load value register.
Date: Fri, 15 Jul 2011 11:04:01 -0400
Message-Id: <1310742242-14647-3-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com>
References: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least on the Versatile Express' V2M, calling wdt_disable followed by
wdt_enable, for instance by running the following sequence:

  echo V > /dev/watchdog; echo V > /dev/watchdog

results in an immediate reset.  The wdt_disable function writes 0 to the
load register; while the watchdog interrupts are disabled at this point,
this special value is defined to trigger an interrupt immediately.  It
appears that in this instance, the reset happens when the interrupts
are subsequently enabled by wdt_enable.

Putting in a short delay after writing a new load value in wdt_enable
solves the issue, but it seems cleaner to simply never write 0 to the
load register at all: according to the hardware docs, writing 0 to the
control register suffices to stop the counter, and the write of 0 to
the load register is questionable anyway since this register resets to
0xffffffff.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 drivers/watchdog/sp805_wdt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 0d80e08..c1e099a 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -144,7 +144,6 @@ static void wdt_disable(void)
 
 	writel(UNLOCK, wdt->base + WDTLOCK);
 	writel(0, wdt->base + WDTCONTROL);
-	writel(0, wdt->base + WDTLOAD);
 	writel(LOCK, wdt->base + WDTLOCK);
 
 	spin_unlock(&wdt->lock);
-- 
1.7.3.4

