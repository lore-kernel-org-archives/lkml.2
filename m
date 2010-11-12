Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab0KLVlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:41:23 -0500
Received: from kroah.org ([198.145.64.141]:41618 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076Ab0KLVlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/19] serial: bfin_5xx: always include DMA headers
Date: Fri, 12 Nov 2010 13:41:01 -0800
Message-Id: <1289598066-10112-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

On Blackfin systems, peripherals that have optional DMA support always
route their interrupts through the corresponding DMA channel -- even
when DMA is not being used.  So in PIO mode, we still need to request
the DMA channel (so interrupts are delivered) which means we need to
always include the DMA header for the DMA defines/functions.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_5xx.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 351cc03..c8ca3b4 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -23,6 +23,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
+#include <linux/dma-mapping.h>
 
 #if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
 	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
@@ -33,12 +34,10 @@
 #include <asm/gpio.h>
 #include <mach/bfin_serial_5xx.h>
 
-#ifdef CONFIG_SERIAL_BFIN_DMA
-#include <linux/dma-mapping.h>
+#include <asm/dma.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/cacheflush.h>
-#endif
 
 #ifdef CONFIG_SERIAL_BFIN_MODULE
 # undef CONFIG_EARLY_PRINTK
@@ -688,6 +687,13 @@ static int bfin_serial_startup(struct uart_port *port)
 
 # ifdef CONFIG_BF54x
 	{
+		/*
+		 * UART2 and UART3 on BF548 share interrupt PINs and DMA
+		 * controllers with SPORT2 and SPORT3. UART rx and tx
+		 * interrupts are generated in PIO mode only when configure
+		 * their peripheral mapping registers properly, which means
+		 * request corresponding DMA channels in PIO mode as well.
+		 */
 		unsigned uart_dma_ch_rx, uart_dma_ch_tx;
 
 		switch (uart->port.irq) {
-- 
1.7.1

