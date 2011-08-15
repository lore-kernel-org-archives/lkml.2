Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1HOOhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:37:55 -0400
Received: from relay1.orceo.com ([62.245.254.100]:47110 "HELO relay1.orceo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753600Ab1HOOhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:37:50 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Aug 2011 10:37:50 EDT
Message-ID: <4E492CFF.7040905@pwrnet.de>
Date: Mon, 15 Aug 2011 16:28:15 +0200
From: Bernhard Roth <br@pwrnet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: nicolas.ferre@atmel.com
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, claudio@evidence.eu.com
Subject: [PATCH] atmel_serial: RS485: receiving enabled when sending data
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

By default the atmel_serial driver in RS485 mode disables receiving data 
until all data in the send buffer has been sent. This flag allows to 
receive data even whilst sending data. This is very useful to

- check if the data has been sent correctly over the RS485 bus
- assure that no collision happened
- check for short circuits/termination issues on the RS485 bus

Usually this functionality is realized by hardware, wether controlling 
the RX-Enable pin of the RS485 transceiver with RTS (driver control 
signal) or pulling it LOW permanently. The present atmel_serial driver 
makes this impossible, thus requiring following patch.

Usage example:

     struct serial_rs485     rs485;

     memset(&rs485, 0, sizeof(rs485));
     rs485.flags = SER_RS485_ENABLED | SER_RS485_RX_DURING_TX;
     ioctl(fd, TIOCSRS485, &rs485);




atmel_serial: RS485: receiving enabled when sending data

By default the atmel_serial driver in RS485 mode disables receiving data 
until
all data in the send buffer has been sent. This flag allows to receive data
even whilst sending data.

Signed-off-by: Bernhard Roth <br@pwrnet.de>
Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
  drivers/tty/serial/atmel_serial.c |   17 ++++++++++-------
  include/linux/serial.h            |    1 +
  2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c 
b/drivers/tty/serial/atmel_serial.c
index af9b781..5f6c745 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -339,8 +339,9 @@ static void atmel_stop_tx(struct uart_port *port)
      /* Disable interrupts */
      UART_PUT_IDR(port, atmel_port->tx_done_mask);

-    if (atmel_port->rs485.flags & SER_RS485_ENABLED)
-        atmel_start_rx(port);
+    if ((atmel_port->rs485.flags & SER_RS485_ENABLED) &&
+        !(atmel_port->rs485.flags & SER_RS485_RX_DURING_TX))
+            atmel_start_rx(port);
  }

  /*
@@ -356,8 +357,9 @@ static void atmel_start_tx(struct uart_port *port)
                 really need this.*/
              return;

-        if (atmel_port->rs485.flags & SER_RS485_ENABLED)
-            atmel_stop_rx(port);
+        if ((atmel_port->rs485.flags & SER_RS485_ENABLED) &&
+            !(atmel_port->rs485.flags & SER_RS485_RX_DURING_TX))
+                atmel_stop_rx(port);

          /* re-enable PDC transmit */
          UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
@@ -680,9 +682,10 @@ static void atmel_tx_dma(struct uart_port *port)
          /* Enable interrupts */
          UART_PUT_IER(port, atmel_port->tx_done_mask);
      } else {
-        if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
-            /* DMA done, stop TX, start RX for RS485 */
-            atmel_start_rx(port);
+        if ((atmel_port->rs485.flags & SER_RS485_ENABLED) &&
+            !(atmel_port->rs485.flags & SER_RS485_RX_DURING_TX)) {
+                /* DMA done, stop TX, start RX for RS485 */
+                atmel_start_rx(port);
          }
      }

diff --git a/include/linux/serial.h b/include/linux/serial.h
index ef91406..97ff8e2 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -211,6 +211,7 @@ struct serial_rs485 {
  #define SER_RS485_RTS_ON_SEND        (1 << 1)
  #define SER_RS485_RTS_AFTER_SEND    (1 << 2)
  #define SER_RS485_RTS_BEFORE_SEND    (1 << 3)
+#define SER_RS485_RX_DURING_TX        (1 << 4)
      __u32    delay_rts_before_send;    /* Milliseconds */
      __u32    delay_rts_after_send;    /* Milliseconds */
      __u32    padding[5];        /* Memory is cheap, new structs
-- 
1.7.1


