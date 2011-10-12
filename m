Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1JLAGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 20:06:07 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3147 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1JLAGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 20:06:05 -0400
From: Doug Anderson <dianders@chromium.org>
To: Jiri Slaby <jirislaby@gmail.com>, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Allen Martin <AMartin@nvidia.com>, Tom Warren <twarren@nvidia.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH] tty/serial: Prevent drop of DCD on suspend for Tegra UARTs
Date: Tue, 11 Oct 2011 17:05:43 -0700
Message-Id: <1318377943-24519-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tegra UARTs (except UART1), the DTR / DCD / DSR lines are not
externally accessible.  Instead, the DTR line internally appears to be
looped back to be the input to the DCD and DSR lines.  The net effect
of this is that when we drop DTR (like when we suspend), we'll see DCD
drop too.  ...and when we see DCD drop, we treat that as a hangup.

In order to prevent this hangup from occurring at every sleep, we need
to force DTR to remain high on Tegra UARTs.

This patch uses the mcr_mask / mcr_force fields, which were originally
added for the kludge ALPHA_KLUDGE_MCR.  Using these fields does not
prevent us from removing ALPHA_KLUDGE_MCR--we can just remove the "if"
tests I have added and always init mcr_mask / mcr_force from the
serial8250_config.

NOTE: If we have people that are using UARTA on a Tegra and need to
control DTR, we'll need to either add a separate port type for UARTA
or we'll need to add some tegra-specific code to detect whether the
DTR needs to be left high.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/tty/serial/8250.c |   14 ++++++++++++++
 drivers/tty/serial/8250.h |    2 ++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 7f50999..c8d26a3 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -308,6 +308,8 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_01 |
 				  UART_FCR_T_TRIG_01,
 		.flags		= UART_CAP_FIFO | UART_CAP_RTOIE,
+		.mcr_mask	= ~UART_MCR_DTR,
+		.mcr_force	= UART_MCR_DTR,
 	},
 };
 
@@ -1282,6 +1284,10 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	up->port.fifosize = uart_config[up->port.type].fifo_size;
 	up->capabilities = uart_config[up->port.type].flags;
 	up->tx_loadsz = uart_config[up->port.type].tx_loadsz;
+	if (!ALPHA_KLUDGE_MCR) {
+		up->mcr_mask = uart_config[up->port.type].mcr_mask;
+		up->mcr_force = uart_config[up->port.type].mcr_force;
+	}
 
 	if (up->port.type == PORT_UNKNOWN)
 		goto out;
@@ -2034,6 +2040,10 @@ static int serial8250_startup(struct uart_port *port)
 	up->port.fifosize = uart_config[up->port.type].fifo_size;
 	up->tx_loadsz = uart_config[up->port.type].tx_loadsz;
 	up->capabilities = uart_config[up->port.type].flags;
+	if (!ALPHA_KLUDGE_MCR) {
+		up->mcr_mask = uart_config[up->port.type].mcr_mask;
+		up->mcr_force = uart_config[up->port.type].mcr_force;
+	}
 	up->mcr = 0;
 
 	if (up->port.iotype != up->cur_iotype)
@@ -2841,6 +2851,10 @@ serial8250_init_fixed_type_port(struct uart_8250_port *up, unsigned int type)
 	up->port.fifosize = uart_config[type].fifo_size;
 	up->capabilities = uart_config[type].flags;
 	up->tx_loadsz = uart_config[type].tx_loadsz;
+	if (!ALPHA_KLUDGE_MCR) {
+		up->mcr_mask = uart_config[type].mcr_mask;
+		up->mcr_force = uart_config[type].mcr_force;
+	}
 }
 
 static void __init
diff --git a/drivers/tty/serial/8250.h b/drivers/tty/serial/8250.h
index 6edf4a6..1f75100 100644
--- a/drivers/tty/serial/8250.h
+++ b/drivers/tty/serial/8250.h
@@ -35,6 +35,8 @@ struct serial8250_config {
 	unsigned short	tx_loadsz;
 	unsigned char	fcr;
 	unsigned int	flags;
+	unsigned char	mcr_mask;
+	unsigned char	mcr_force;
 };
 
 #define UART_CAP_FIFO	(1 << 8)	/* UART has FIFO */
-- 
1.7.3.1

