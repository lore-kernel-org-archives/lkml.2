Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab2CZFC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:02:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51089 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2CZFCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:02:23 -0400
Message-ID: <1332738134.10660.1.camel@phoenix>
Subject: [PATCH] watchdog: Fix build error in txx9wdt.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Ralf Baechle <ralf@linux-mips.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Date: Mon, 26 Mar 2012 13:02:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we need to get clk_get_rate(txx9_imclk) before using WD_MAX_TIMEOUT.

This patch fixes below build errors:
  CC      drivers/watchdog/txx9wdt.o
drivers/watchdog/txx9wdt.c:104: error: initializer element is not constant
drivers/watchdog/txx9wdt.c:104: error: (near initialization for ‘txx9wdt.max_timeout’)
make[2]: *** [drivers/watchdog/txx9wdt.o] Error 1
make[1]: *** [drivers/watchdog] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/txx9wdt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index f9afe2f..98e1637 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -100,8 +100,6 @@ static const struct watchdog_ops txx9wdt_ops = {
 static struct watchdog_device txx9wdt = {
 	.info = &txx9wdt_info,
 	.ops = &txx9wdt_ops,
-	.min_timeout = 1,
-	.max_timeout = WD_MAX_TIMEOUT,
 };
 
 static int __init txx9wdt_probe(struct platform_device *dev)
@@ -132,6 +130,8 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 	if (timeout < 1 || timeout > WD_MAX_TIMEOUT)
 		timeout = TIMER_MARGIN;
 	txx9wdt.timeout = timeout;
+	txx9wdt.min_timeout = 1;
+	txx9wdt.max_timeout = WD_MAX_TIMEOUT;
 	watchdog_set_nowayout(&txx9wdt, nowayout);
 
 	ret = watchdog_register_device(&txx9wdt);
-- 
1.7.5.4



