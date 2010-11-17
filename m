Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934558Ab0KQGmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:42:04 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39401 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934513Ab0KQGmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:42:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=i10dblxNiJGBfWYACuCp23+IULqJvl2x8Zc9jE4vMbc26qvDDGQ1Xj7fW3+EqM6pPy
         8gqBEr4AGQJ23DdiXCQLwKajjcPkvE6pw8e6GKuViUUdxOSAKUqvsYX7HeRloMjws/63
         G6uhmdYkiahXsi8U+Koqj3UY2xZQ5FMqxKkKo=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
        g.liakhovetski@gmx.de, linux-sh@vger.kernel.org
Date: Wed, 17 Nov 2010 15:44:54 +0900
Message-Id: <20101117064454.18139.40718.sendpatchset@t400s>
In-Reply-To: <20101117064405.18139.57035.sendpatchset@t400s>
References: <20101117064405.18139.57035.sendpatchset@t400s>
Subject: [PATCH 05/05] fbdev: sh_mipi_dsi: Allow LCDC board callbacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the MIPI-DSI driver to make use of the
LCD panel callbacks in the LCDC platform data.

Without this patch MIPI panels cannot use board
specific LCDC callbacks to control power and/or
back light.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/video/sh_mipi_dsi.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- 0008/drivers/video/sh_mipi_dsi.c
+++ work/drivers/video/sh_mipi_dsi.c	2010-11-16 17:41:32.000000000 +0900
@@ -50,6 +50,9 @@ struct sh_mipi {
 	void __iomem	*linkbase;
 	struct clk	*dsit_clk;
 	struct clk	*dsip_clk;
+	void *next_board_data;
+	void (*next_display_on)(void *board_data, struct fb_info *info);
+	void (*next_display_off)(void *board_data);
 };
 
 static struct sh_mipi *mipi_dsi[MAX_SH_MIPI_DSI];
@@ -122,12 +125,18 @@ static void mipi_display_on(void *arg, s
 	struct sh_mipi *mipi = arg;
 
 	sh_mipi_dsi_enable(mipi, true);
+
+	if (mipi->next_display_on)
+		mipi->next_display_on(mipi->next_board_data, info);
 }
 
 static void mipi_display_off(void *arg)
 {
 	struct sh_mipi *mipi = arg;
 
+	if (mipi->next_display_off)
+		mipi->next_display_off(mipi->next_board_data);
+
 	sh_mipi_dsi_enable(mipi, false);
 }
 
@@ -431,6 +440,11 @@ static int __init sh_mipi_probe(struct p
 	mutex_unlock(&array_lock);
 	platform_set_drvdata(pdev, mipi);
 
+	/* Save original LCDC callbacks */
+	mipi->next_board_data = pdata->lcd_chan->board_cfg.board_data;
+	mipi->next_display_on = pdata->lcd_chan->board_cfg.display_on;
+	mipi->next_display_off = pdata->lcd_chan->board_cfg.display_off;
+
 	/* Set up LCDC callbacks */
 	pdata->lcd_chan->board_cfg.board_data = mipi;
 	pdata->lcd_chan->board_cfg.display_on = mipi_display_on;
