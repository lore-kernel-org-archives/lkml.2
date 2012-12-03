Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2LCLQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:16:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:54270 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754Ab2LCLQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:16:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,205,1355126400"; 
   d="scan'208";a="175377233"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 1/5] serial: 8250: Allow drivers to deliver capabilities
Date: Mon,  3 Dec 2012 13:17:55 +0200
Message-Id: <1354533479-27306-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
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
index d085e3a..da3f828 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -1980,9 +1980,12 @@ static int serial8250_startup(struct uart_port *port)
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
@@ -2815,9 +2818,12 @@ static void
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
@@ -3251,6 +3257,10 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
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

