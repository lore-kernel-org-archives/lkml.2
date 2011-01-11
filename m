Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1AKMq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:46:58 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45082 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab1AKMoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:38 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/16] staging: tidspbridge: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:44 +0000
Message-Id: <1294749833-32019-8-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/staging/tidspbridge/core/wdt.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/wdt.c b/drivers/staging/tidspbridge/core/wdt.c
index 2126f59..bfbf88d 100644
--- a/drivers/staging/tidspbridge/core/wdt.c
+++ b/drivers/staging/tidspbridge/core/wdt.c
@@ -15,6 +15,7 @@
  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
+#include <linux/err.h>
 #include <linux/types.h>
 
 #include <dspbridge/dbdefs.h>
@@ -60,15 +61,15 @@ int dsp_wdt_init(void)
 
 	dsp_wdt.fclk = clk_get(NULL, "wdt3_fck");
 
-	if (dsp_wdt.fclk) {
+	if (!IS_ERR(dsp_wdt.fclk)) {
 		dsp_wdt.iclk = clk_get(NULL, "wdt3_ick");
-		if (!dsp_wdt.iclk) {
+		if (IS_ERR(dsp_wdt.iclk)) {
 			clk_put(dsp_wdt.fclk);
 			dsp_wdt.fclk = NULL;
-			ret = -EFAULT;
+			ret = PTR_ERR(dsp_wdt.iclk);
 		}
 	} else
-		ret = -EFAULT;
+		ret = PTR_ERR(dsp_wdt.fclk);
 
 	if (!ret)
 		ret = request_irq(INT_34XX_WDT3_IRQ, dsp_wdt_isr, 0,
-- 
1.7.3.4

