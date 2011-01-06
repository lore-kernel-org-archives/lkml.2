Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1AFWYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:24:03 -0500
Received: from kroah.org ([198.145.64.141]:55699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab1AFWX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ondrej Puzman <puzman@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/36] 8250: fix uninitialized FIFOs
Date: Thu,  6 Jan 2011 14:23:18 -0800
Message-Id: <1294352605-31906-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Puzman <puzman@gmail.com>

I have found a bug in 8250.c driver which causes that 16550A uart FIFOs
are not turned on during initialization if they are manually configured
by setserial. UART is then working only as plain 16450 without FIFOs. On
systems with higher interrupt latency this causes buffer overruns and
loss of received data when using higher communication speeds.

I'm working for a company which produces industrial computers. These
devices typically contain high number (8 or more) of traditional 16550A
uarts - we use TL16C554A chips, but that is not much relevant. UARTs are
connected to the CPU by ISA bus (Celeron based devices) or LPC bus (Atom
based devices).

In the Linux the UARTs are using standard 8250.c driver and are
initialized using setserial command:
setserial /dev/ttyS4 uart 16550A port 0x3E0 irq 10 baud_base 115200

This executes the UART initialization through serial8250_startup()
function. At the beginning of the function up->capabilities is
initialized from uart_config:
 up->capabilities = uart_config[up->port.type].flags;
Please note that neither up->port.fifosize nor up->tx_loadsz is
initialized here!!

Later in the same function serial8250_clear_fifos() is called and
disables FIFOs. The above comment says that they will be reenabled in
set_termios (they won't ...)

After serial8250_startup() the serial8250_set_termios() is called. In
this function the following check fails because up->port.fifosize is
zero because it is not initialized correctly.

        if (up->capabilities & UART_CAP_FIFO && up->port.fifosize > 1) {
                if (baud < 2400)
                        fcr = UART_FCR_ENABLE_FIFO | UART_FCR_TRIGGER_1;
                else
                        fcr = uart_config[up->port.type].fcr;
        }

fcr variable remains zero and in the end the FCR register is set to zero
which results in disabled FIFOs even if the UART type is 16550A. This is
also true for other types of UARTs with FIFOs.

If the UART is autoconfigured via 'setserial /dev/ttySx autoconfig' then
port.fifosize and tx_loadsz are initialized correctly in the
autoconfig() function and the UART is working correctly then.

I checked the source codes and I can say that this bug is present in
2.6.x series of kernels for a couple of years. Namely I can confirm its
presence in 2.6.16.57, 2.6.32.24 and 2.6.36.1 (tested all of them on our
hardware).

I think it was not noticed before because not many people use manually
configured non PNP UARTs on ISA/LPC bus these days. Also the data loss
caused by buffer overruns occures only if  IRQ latency is higher then
time needed to receive one character on given communication speed.
For example our hardware looses received characters only if the UARTs
are connected throught LPC bus with SERIRQ (serial IRQ transport) and
not if they are connected to ISA bus because LPC SERIRQ has higher
interrupt latency then parallel ISA interupt lines.

Here is the patch to correct the bug created against 2.6.36.1:

Signed-off-by: Ondrej Puzman <puzman@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 9839199..8747215 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1981,6 +1981,8 @@ static int serial8250_startup(struct uart_port *port)
 	unsigned char lsr, iir;
 	int retval;
 
+	up->port.fifosize = uart_config[up->port.type].fifo_size;
+	up->tx_loadsz = uart_config[up->port.type].tx_loadsz;
 	up->capabilities = uart_config[up->port.type].flags;
 	up->mcr = 0;
 
-- 
1.7.3.2

