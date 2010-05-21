Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433Ab0EURFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:05:07 -0400
Received: from kroah.org ([198.145.64.141]:50301 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934078Ab0EUQwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/25] serial: bfin_sport_uart: protect changes to uart_port
Date: Fri, 21 May 2010 09:51:36 -0700
Message-Id: <1274460714-11277-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Common serial API says we need to grab the port lock before modifying
the port state to prevent inconsistent state between threads.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_sport_uart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 8cb0a40..5224db2 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -498,6 +498,8 @@ static void sport_set_termios(struct uart_port *port,
 		/* up->parib = 1; */
 	}
 
+	spin_lock_irqsave(&up->port.lock, flags);
+
 	port->read_status_mask = OE;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= (FE | PE);
@@ -538,8 +540,6 @@ static void sport_set_termios(struct uart_port *port,
 	/* uart baud rate */
 	port->uartclk = uart_get_baud_rate(port, termios, old, 0, get_sclk()/16);
 
-	spin_lock_irqsave(&up->port.lock, flags);
-
 	/* Disable UART */
 	SPORT_PUT_TCR1(up, SPORT_GET_TCR1(up) & ~TSPEN);
 	SPORT_PUT_RCR1(up, SPORT_GET_RCR1(up) & ~RSPEN);
-- 
1.7.0.3

