Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab2FGEVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:21:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759838Ab2FGEVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:21:47 -0400
Message-Id: <20120607040348.080257473@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:55 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Grazvydas Ignotas <notasas@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 79/82] wl1251: fix oops on early interrupt
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grazvydas Ignotas <notasas@gmail.com>

commit f380f2c4a12e913356bd49f8790ec1063c4fe9f8 upstream.

This driver disables interrupt just after requesting it and enables it
later, after interface is up. However currently there is a time window
between request_irq() and disable_irq() where if interrupt arrives, the
driver oopses because it's not yet ready to process it. This can be
reproduced by inserting the module, associating and removing the module
multiple times.

Eliminate this race by setting IRQF_NOAUTOEN flag before request_irq().

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/wl1251/sdio.c |    2 +-
 drivers/net/wireless/wl1251/spi.c  |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/wl1251/sdio.c
+++ b/drivers/net/wireless/wl1251/sdio.c
@@ -260,6 +260,7 @@ static int wl1251_sdio_probe(struct sdio
 	}
 
 	if (wl->irq) {
+		irq_set_status_flags(wl->irq, IRQ_NOAUTOEN);
 		ret = request_irq(wl->irq, wl1251_line_irq, 0, "wl1251", wl);
 		if (ret < 0) {
 			wl1251_error("request_irq() failed: %d", ret);
@@ -267,7 +268,6 @@ static int wl1251_sdio_probe(struct sdio
 		}
 
 		irq_set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
-		disable_irq(wl->irq);
 
 		wl1251_sdio_ops.enable_irq = wl1251_enable_line_irq;
 		wl1251_sdio_ops.disable_irq = wl1251_disable_line_irq;
--- a/drivers/net/wireless/wl1251/spi.c
+++ b/drivers/net/wireless/wl1251/spi.c
@@ -281,6 +281,7 @@ static int __devinit wl1251_spi_probe(st
 
 	wl->use_eeprom = pdata->use_eeprom;
 
+	irq_set_status_flags(wl->irq, IRQ_NOAUTOEN);
 	ret = request_irq(wl->irq, wl1251_irq, 0, DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1251_error("request_irq() failed: %d", ret);
@@ -289,8 +290,6 @@ static int __devinit wl1251_spi_probe(st
 
 	irq_set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
 
-	disable_irq(wl->irq);
-
 	ret = wl1251_init_ieee80211(wl);
 	if (ret)
 		goto out_irq;


