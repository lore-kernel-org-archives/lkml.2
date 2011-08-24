Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab1HXHsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 03:48:33 -0400
Received: from bishop.asidev.net ([95.141.38.214]:37008 "EHLO
	bishop.asidev.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1HXHsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 03:48:32 -0400
Message-ID: <4E54ACC7.6070201@evidence.eu.com>
Date: Wed, 24 Aug 2011 09:48:23 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Bernhard Roth <br@pwrnet.de>, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] atmel_serial: RS485: receiving enabled when sending data
References: <4E492CFF.7040905@pwrnet.de> <20110822211832.GA8023@kroah.com> <4E536536.3030004@evidence.eu.com> <20110823153932.GA26081@kroah.com>
In-Reply-To: <20110823153932.GA26081@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/08/2011 17:39, Greg KH ha scritto:
> On Tue, Aug 23, 2011 at 10:30:46AM +0200, Claudio Scordino wrote:
>> Il 22/08/2011 23:18, Greg KH ha scritto:
>>> On Mon, Aug 15, 2011 at 04:28:15PM +0200, Bernhard Roth wrote:
>>>> Hello!
>>>>
>>>> By default the atmel_serial driver in RS485 mode disables receiving
>>>> data until all data in the send buffer has been sent. This flag
>>>> allows to receive data even whilst sending data. This is very useful
>>>> to
>>>>
>>>> - check if the data has been sent correctly over the RS485 bus
>>>> - assure that no collision happened
>>>> - check for short circuits/termination issues on the RS485 bus
>>>>
>>>> Usually this functionality is realized by hardware, wether
>>>> controlling the RX-Enable pin of the RS485 transceiver with RTS
>>>> (driver control signal) or pulling it LOW permanently. The present
>>>> atmel_serial driver makes this impossible, thus requiring following
>>>> patch.
>>>>
>>>> Usage example:
>>>>
>>>>       struct serial_rs485     rs485;
>>>>
>>>>       memset(&rs485, 0, sizeof(rs485));
>>>>       rs485.flags = SER_RS485_ENABLED | SER_RS485_RX_DURING_TX;
>>>>       ioctl(fd, TIOCSRS485,&rs485);
>>>>
>>>>
>>>>
>>>>
>>>> atmel_serial: RS485: receiving enabled when sending data
>>>>
>>>> By default the atmel_serial driver in RS485 mode disables receiving
>>>> data until
>>>> all data in the send buffer has been sent. This flag allows to receive data
>>>> even whilst sending data.
>>>>
>>>> Signed-off-by: Bernhard Roth<br@pwrnet.de>
>>>> Signed-off-by: Claudio Scordino<claudio@evidence.eu.com>
>>>> ---
>>>>    drivers/tty/serial/atmel_serial.c |   17 ++++++++++-------
>>>>    include/linux/serial.h            |    1 +
>>>>    2 files changed, 11 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/drivers/tty/serial/atmel_serial.c
>>>> b/drivers/tty/serial/atmel_serial.c
>>>> index af9b781..5f6c745 100644
>>>> --- a/drivers/tty/serial/atmel_serial.c
>>>> +++ b/drivers/tty/serial/atmel_serial.c
>>>> @@ -339,8 +339,9 @@ static void atmel_stop_tx(struct uart_port *port)
>>>>        /* Disable interrupts */
>>>>        UART_PUT_IDR(port, atmel_port->tx_done_mask);
>>>>
>>>> -    if (atmel_port->rs485.flags&   SER_RS485_ENABLED)
>>>> -        atmel_start_rx(port);
>>>> +    if ((atmel_port->rs485.flags&   SER_RS485_ENABLED)&&
>>>> +        !(atmel_port->rs485.flags&   SER_RS485_RX_DURING_TX))
>>>> +            atmel_start_rx(port);
>>>
>>> Can you fix your email client to not strip patches of tabs and resend
>>> this so that I can apply it?
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Hi Greg,
>>
>>      please find below the patch with the right tabs.
>>
>> Remind however that the main author of the patch is Bernhard, not me.
> 
> Then properly send the patch so that this is shown.  Please just add a:
> 
> From: foo<foo@foo.org>
> 
> as the first line of the patch changelog portion and git will fix things
> up correctly.  Documentation/SubmittingPatches describes this in detail.
> 
> Care to resend your updated version, with this corrected author
> information, so I get it right?

Here it is. I also added a few lines in the Documentation.

Many thanks,

	Claudio

Subject: atmel_serial: RS485: receiving enabled when sending data
From: Bernhard Roth <br@pwrnet.de> 

By default the atmel_serial driver in RS485 mode disables receiving data until
all data in the send buffer has been sent. This flag allows to receive data
even whilst sending data.

Signed-off-by: Bernhard Roth <br@pwrnet.de> 
Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Acked-by: Alan Cox <alan@linux.intel.com>
---
 Documentation/serial/serial-rs485.txt |    3 +++
 drivers/tty/serial/atmel_serial.c     |    9 ++++++---
 include/linux/serial.h                |    1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/serial/serial-rs485.txt b/Documentation/serial/serial-rs485.txt
index a493238..c8878f8 100644
--- a/Documentation/serial/serial-rs485.txt
+++ b/Documentation/serial/serial-rs485.txt
@@ -104,6 +104,9 @@
 	rs485conf.flags |= SER_RS485_RTS_AFTER_SEND;
 	rs485conf.delay_rts_after_send = ...;
 
+	/* Set this flag if you want to receive data even whilst sending data */
+	rs485conf.flags |= SER_RS485_RX_DURING_TX;
+
 	if (ioctl (fd, TIOCSRS485, &rs485conf) < 0) {
 		/* Error handling. See errno. */
 	}
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index af9b781..c7232a9 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -339,7 +339,8 @@ static void atmel_stop_tx(struct uart_port *port)
 	/* Disable interrupts */
 	UART_PUT_IDR(port, atmel_port->tx_done_mask);
 
-	if (atmel_port->rs485.flags & SER_RS485_ENABLED)
+	if ((atmel_port->rs485.flags & SER_RS485_ENABLED) &&
+	    !(atmel_port->rs485.flags & SER_RS485_RX_DURING_TX))
 		atmel_start_rx(port);
 }
 
@@ -356,7 +357,8 @@ static void atmel_start_tx(struct uart_port *port)
 			   really need this.*/
 			return;
 
-		if (atmel_port->rs485.flags & SER_RS485_ENABLED)
+		if ((atmel_port->rs485.flags & SER_RS485_ENABLED) &&
+		    !(atmel_port->rs485.flags & SER_RS485_RX_DURING_TX))
 			atmel_stop_rx(port);
 
 		/* re-enable PDC transmit */
@@ -680,7 +682,8 @@ static void atmel_tx_dma(struct uart_port *port)
 		/* Enable interrupts */
 		UART_PUT_IER(port, atmel_port->tx_done_mask);
 	} else {
-		if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
+		if ((atmel_port->rs485.flags & SER_RS485_ENABLED) &&
+		    !(atmel_port->rs485.flags & SER_RS485_RX_DURING_TX)) {
 			/* DMA done, stop TX, start RX for RS485 */
 			atmel_start_rx(port);
 		}
diff --git a/include/linux/serial.h b/include/linux/serial.h
index ef91406..97ff8e2 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -211,6 +211,7 @@ struct serial_rs485 {
 #define SER_RS485_RTS_ON_SEND		(1 << 1)
 #define SER_RS485_RTS_AFTER_SEND	(1 << 2)
 #define SER_RS485_RTS_BEFORE_SEND	(1 << 3)
+#define SER_RS485_RX_DURING_TX		(1 << 4)
 	__u32	delay_rts_before_send;	/* Milliseconds */
 	__u32	delay_rts_after_send;	/* Milliseconds */
 	__u32	padding[5];		/* Memory is cheap, new structs
-- 
1.7.1

