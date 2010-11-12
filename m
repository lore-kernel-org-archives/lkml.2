Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab0KLVmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:42:36 -0500
Received: from kroah.org ([198.145.64.141]:41629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083Ab0KLVlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/19] serial: bfin_5xx: grab port lock before making port termios changes
Date: Fri, 12 Nov 2010 13:41:04 -0800
Message-Id: <1289598066-10112-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The port lock exists to protect these resources, so we need to grab it
before making changes.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_5xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 9655321..19cac9f 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -849,6 +849,8 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (termios->c_cflag & CMSPAR)
 		lcr |= STP;
 
+	spin_lock_irqsave(&uart->port.lock, flags);
+
 	port->read_status_mask = OE;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= (FE | PE);
@@ -878,8 +880,6 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (termios->c_line != N_IRDA)
 		quot -= ANOMALY_05000230;
 
-	spin_lock_irqsave(&uart->port.lock, flags);
-
 	UART_SET_ANOMALY_THRESHOLD(uart, USEC_PER_SEC / baud * 15);
 
 	/* Disable UART */
-- 
1.7.1

