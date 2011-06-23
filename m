Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab1FWRZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:25:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657Ab1FWRY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:24:59 -0400
Date: Thu, 23 Jun 2011 13:24:58 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172458.27750.97271.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 27/35] drivers/tty changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/tty/serial/pch_uart.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 4652109..ab2e2af 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -21,7 +21,7 @@
 #include <linux/serial_core.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #include <linux/dmaengine.h>
 #include <linux/pch_dma.h>
@@ -1386,6 +1386,16 @@ static struct uart_driver pch_uart_driver = {
 	.nr = PCH_UART_NR,
 };
 
+static const struct sysfw_id pcih_uart_quirk_id[] = {
+	{
+		.ident = "CM-iTC",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "CM-iTC"),
+		},
+	},
+	{}
+};
+
 static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 					     const struct pci_device_id *id)
 {
@@ -1397,7 +1407,6 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	int fifosize, base_baud;
 	int port_type;
 	struct pch_uart_driver_data *board;
-	const char *board_name;
 
 	board = &drv_dat[id->driver_data];
 	port_type = board->port_type;
@@ -1413,8 +1422,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	base_baud = 1843200; /* 1.8432MHz */
 
 	/* quirk for CM-iTC board */
-	board_name = dmi_get_system_info(DMI_BOARD_NAME);
-	if (board_name && strstr(board_name, "CM-iTC"))
+	if (sysfw_callback(pcih_uart_quirk_id))
 		base_baud = 192000000; /* 192.0MHz */
 
 	switch (port_type) {
-- 
1.7.5.4

