Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2E1Dsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:48:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51997 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803Ab2E1D3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:24 -0400
Message-Id: <20120528031208.684542670@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Christian Melki <christian.melki@ericsson.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 042/117] 8250.c: less than 2400 baud fix.
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename; replace *port with up->port]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/8250.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -2327,10 +2327,11 @@
 		quot++;
 
 	if (up->capabilities & UART_CAP_FIFO && up->port.fifosize > 1) {
-		if (baud < 2400)
-			fcr = UART_FCR_ENABLE_FIFO | UART_FCR_TRIGGER_1;
-		else
-			fcr = uart_config[up->port.type].fcr;
+		fcr = uart_config[up->port.type].fcr;
+		if (baud < 2400) {
+			fcr &= ~UART_FCR_TRIGGER_MASK;
+			fcr |= UART_FCR_TRIGGER_1;
+		}
 	}
 
 	/*


