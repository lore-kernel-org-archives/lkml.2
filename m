Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab1GRNJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:09:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab1GRNJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:09:13 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, gregkh@suse.de
Subject: [PATCH 26/34] drivers/tty changes for SMBIOS and System Firmware
Date: Mon, 18 Jul 2011 09:08:40 -0400
Message-Id: <1310994528-26276-27-git-send-email-prarit@redhat.com>
In-Reply-To: <1310994528-26276-1-git-send-email-prarit@redhat.com>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers

Cc: gregkh@suse.de
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
1.6.5.2

