Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2K1Mrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 07:47:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:47427 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab2K1Mra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 07:47:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,177,1355126400"; 
   d="scan'208";a="255861987"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] serial: 8250: Allow drivers to deliver capabilities
Date: Wed, 28 Nov 2012 14:48:40 +0200
Message-Id: <1354106924-11013-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354106924-11013-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1354106924-11013-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern UARTs are able to provide information about their
capabilities such as FIFO size. This allows the drivers to
deliver this information to 8250.c when they are registering
ports.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 3ba4234..7dd131e 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -1906,9 +1906,12 @@ static int serial8250_startup(struct uart_port *port)
 	if (port->type == PORT_8250_CIR)
 		return -ENODEV;
 
-	port->fifosize = uart_config[up->port.type].fifo_size;
-	up->tx_loadsz = uart_config[up->port.type].tx_loadsz;
-	up->capabilities = uart_config[up->port.type].flags;
+	if (!port->fifosize)
+		port->fifosize = uart_config[port->type].fifo_size;
+	if (!up->tx_loadsz)
+		up->tx_loadsz = uart_config[port->type].tx_loadsz;
+	if (!up->capabilities)
+		up->capabilities = uart_config[port->type].flags;
 	up->mcr = 0;
 
 	if (port->iotype != up->cur_iotype)
@@ -2739,9 +2742,12 @@ static void
 serial8250_init_fixed_type_port(struct uart_8250_port *up, unsigned int type)
 {
 	up->port.type = type;
-	up->port.fifosize = uart_config[type].fifo_size;
-	up->capabilities = uart_config[type].flags;
-	up->tx_loadsz = uart_config[type].tx_loadsz;
+	if (!up->port.fifosize)
+		up->port.fifosize = uart_config[type].fifo_size;
+	if (!up->tx_loadsz)
+		up->tx_loadsz = uart_config[type].tx_loadsz;
+	if (!up->capabilities)
+		up->capabilities = uart_config[type].flags;
 }
 
 static void __init
@@ -3175,6 +3181,10 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		uart->bugs		= up->bugs;
 		uart->port.mapbase      = up->port.mapbase;
 		uart->port.private_data = up->port.private_data;
+		uart->port.fifosize	= up->port.fifosize;
+		uart->tx_loadsz		= up->tx_loadsz;
+		uart->capabilities	= up->capabilities;
+
 		if (up->port.dev)
 			uart->port.dev = up->port.dev;
 
-- 
1.7.10.4

