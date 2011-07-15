Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1GOPEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:04:30 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:33255 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752019Ab1GOPE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:04:27 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 3/3] watchdog: sp805: Flush posted writes in enable/disable.
Date: Fri, 15 Jul 2011 11:04:02 -0400
Message-Id: <1310742242-14647-4-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com>
References: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no reads in these functions, so if MMIO writes are posted,
the writes in enable/disable may not have completed by the time these
functions return.  If the functions run from different CPUs, it's
in theory possible for the writes to be interleaved, which would be
disastrous for this driver.

At the very least, we need an mmiowb() before releasing the lock, but
since it seems desirable for the watchdog timer to be actually stopped
or reset when these functions return, read the lock register to force
the writes out.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 drivers/watchdog/sp805_wdt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index c1e099a..cc2cfbe 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -134,6 +134,8 @@ static void wdt_enable(void)
 	writel(INT_ENABLE | RESET_ENABLE, wdt->base + WDTCONTROL);
 	writel(LOCK, wdt->base + WDTLOCK);
 
+	/* Flush posted writes. */
+	readl(wdt->base + WDTLOCK);
 	spin_unlock(&wdt->lock);
 }
 
@@ -146,6 +148,8 @@ static void wdt_disable(void)
 	writel(0, wdt->base + WDTCONTROL);
 	writel(LOCK, wdt->base + WDTLOCK);
 
+	/* Flush posted writes. */
+	readl(wdt->base + WDTLOCK);
 	spin_unlock(&wdt->lock);
 }
 
-- 
1.7.3.4

