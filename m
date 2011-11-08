Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab1KHNfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:35:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54860 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab1KHNfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:35:16 -0500
From: Michal Simek <monstr@monstr.eu>
To: devicetree-discuss@lists.ozlabs.org
Cc: grant.likely@secretlab.ca, john.williams@petalogix.com,
        michal.simek@petalogix.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, jacmet@sunsite.dk, arnd@arndb.de
Subject: [RFC 2/2] serial: 8250: Add OF alias support
Date: Tue,  8 Nov 2011 14:35:07 +0100
Message-Id: <1320759307-24877-3-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1320759307-24877-2-git-send-email-monstr@monstr.eu>
References: <1320759307-24877-1-git-send-email-monstr@monstr.eu>
 <1320759307-24877-2-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow alias number for OF driven boards.
For example:
	aliases {
		serial2 = &RS232_Uart_1;
	} ;

Setup port->line number in of_platform_serial_probe from alias node.

Fixing serial8250_find_match_or_unused function is more complicated
because it is key function which check which port is available.

This was probably done for any ancient ISA support where all ports are
registered first in serial8250_register_ports (serial8250_isa_init_ports).
and then, if they are usused, unregistered and registered with
proper setting. Not sure if this is needed.

If port entry matches, it is used. If not, code looks first at entry
at port->line number to be able to assign ttySX number according
port->line setup from of_platform_serial_probe. If this port is used
code looks for the first free entry as before.

The only one change is to check entry on port->line first.

This patch requires more testing because there are several usage of
standard 8250 compatible driver.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/tty/serial/8250.c      |    7 +++++++
 drivers/tty/serial/of_serial.c |   15 +++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 7f50999..ade3c77 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -3212,6 +3212,13 @@ static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *
 		if (uart_match_port(&serial8250_ports[i].port, port))
 			return &serial8250_ports[i];
 
+	/* Look at setup port->line port first. If is available, use it */
+	if (port->line >= 0 && port->line < nr_uarts)
+		if (serial8250_ports[port->line].port.type == PORT_UNKNOWN &&
+		    serial8250_ports[port->line].port.iobase == 0) {
+			return &serial8250_ports[port->line];
+		}
+
 	/*
 	 * We didn't find a matching entry, so look for the first
 	 * free entry.  We look for one which hasn't been previously
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 24aa67c..486f2bd 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -98,6 +98,7 @@ static int __devinit of_platform_serial_probe(struct platform_device *ofdev)
 	struct uart_port port;
 	int port_type;
 	int ret;
+	int id;
 
 	match = of_match_device(of_platform_serial_table, &ofdev->dev);
 	if (!match)
@@ -115,6 +116,20 @@ static int __devinit of_platform_serial_probe(struct platform_device *ofdev)
 	if (ret)
 		goto out;
 
+	id = of_alias_get_id(ofdev->dev.of_node, "serial");
+	if (id < 0) {
+		dev_warn(&ofdev->dev, "FAILED to find out alias id\n");
+	} else {
+		if (id < CONFIG_SERIAL_8250_RUNTIME_UARTS)
+			port.line = id;
+		else {
+			dev_warn(&ofdev->dev,
+				"FAILED to register serial driver with id %d\n",
+									id);
+			goto out;
+		}
+	}
+
 	switch (port_type) {
 #ifdef CONFIG_SERIAL_8250
 	case PORT_8250 ... PORT_MAX_8250:
-- 
1.7.5.4

