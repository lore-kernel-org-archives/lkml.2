Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422654Ab2E0BRe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:17:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422705Ab2E0BRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:17:24 -0400
Message-Id: <20120527002515.541379086@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:46 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Christian Melki <christian.melki@ericsson.se>
Subject: [ 40/91] 8250.c: less than 2400 baud fix.
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Melki <christian.melki@ericsson.se>

commit f9a9111b540fd67db5dab332f4b83d86c90e27b1 upstream.

We noticed that we were loosing data at speed less than 2400 baud.
It turned out our (TI16750 compatible) uart with 64 byte outgoing fifo
was truncated to 16 byte (bit 5 sets fifo len) when modifying the fcr
reg.
The input code still fills the buffer with 64 bytes if I remember
correctly and thus data is lost.
Our fix was to remove whiping of the fcr content and just add the
TRIGGER_1 which we want for latency.
I can't see why this would not work on less than 2400 always, for all
uarts ...
Otherwise one would have to make sure the filling of the fifo re-checks
the current state of available fifo size (urrk).

Signed-off-by: Christian Melki <christian.melki@ericsson.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -2280,10 +2280,11 @@ serial8250_do_set_termios(struct uart_po
 		quot++;
 
 	if (up->capabilities & UART_CAP_FIFO && port->fifosize > 1) {
-		if (baud < 2400)
-			fcr = UART_FCR_ENABLE_FIFO | UART_FCR_TRIGGER_1;
-		else
-			fcr = uart_config[port->type].fcr;
+		fcr = uart_config[port->type].fcr;
+		if (baud < 2400) {
+			fcr &= ~UART_FCR_TRIGGER_MASK;
+			fcr |= UART_FCR_TRIGGER_1;
+		}
 	}
 
 	/*


