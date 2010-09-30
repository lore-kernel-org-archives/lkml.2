Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0I3Onz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 10:43:55 -0400
Received: from smtp.netsonic.fi ([194.29.192.26]:43677 "EHLO smtp.netsonic.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471Ab0I3Onx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 10:43:53 -0400
X-Greylist: delayed 2148 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2010 10:43:53 EDT
From: Timo Juhani Lindfors <timo.lindfors@iki.fi>
To: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Timo Juhani Lindfors <timo.lindfors@iki.fi>
Subject: [PATCH 2/2] watchdog: it8712f_wdt: Add module parameter for alternative reset sources
Date: Thu, 30 Sep 2010 17:08:04 +0300
Message-Id: <1285855684-8369-2-git-send-email-timo.lindfors@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1285855684-8369-1-git-send-email-timo.lindfors@iki.fi>
References: <1285855684-8369-1-git-send-email-timo.lindfors@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On iEi PCISA-9652-R10 (BIOS version 1.5) single board computer reads
from the game port do not seem to reset the watchdog timer. This patch
adds a module parameter wdt_config_reg to specify alternative reset
sources. At least WDT_RESET_KBD has been tested, even just running

while true; do
    setleds -L +scroll
    sleep 1
    setleds -L -scroll
    sleep 1
done

is enough to keep the watchdog happy.

Signed-off-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
---
 drivers/watchdog/it8712f_wdt.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index b08fae6..b32c6c0 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -85,6 +85,14 @@ static unsigned short address;
 #define WDT_OUT_PWROK	0x10	/* Pulse PWROK on timeout */
 #define WDT_OUT_KRST	0x40	/* Pulse reset on timeout */
 
+static int wdt_control_reg = WDT_RESET_GAME;
+module_param(wdt_control_reg, int, 0);
+MODULE_PARM_DESC(wdt_control_reg, "Value to write to watchdog control "
+		"register. The default WDT_RESET_GAME resets the timer on "
+		"game port reads that this driver generates. You can also "
+		"use KBD, MOUSE or CIR if you have some external way to "
+		"generate those interrupts.");
+
 static int superio_inb(int reg)
 {
 	outb(reg, REG);
@@ -131,7 +139,8 @@ static inline void superio_exit(void)
 
 static inline void it8712f_wdt_ping(void)
 {
-	inb(address);
+	if (wdt_control_reg & WDT_RESET_GAME)
+		inb(address);
 }
 
 static void it8712f_wdt_update_margin(void)
@@ -170,7 +179,7 @@ static void it8712f_wdt_enable(void)
 	superio_enter();
 	superio_select(LDN_GPIO);
 
-	superio_outb(WDT_RESET_GAME, WDT_CONTROL);
+	superio_outb(wdt_control_reg, WDT_CONTROL);
 
 	it8712f_wdt_update_margin();
 
-- 
1.7.1

