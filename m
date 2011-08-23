Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab1HWKG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 06:06:56 -0400
Received: from bishop.asidev.net ([95.141.38.214]:39511 "EHLO
	bishop.asidev.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1HWKGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 06:06:53 -0400
Message-ID: <4E537BB3.60001@evidence.eu.com>
Date: Tue, 23 Aug 2011 12:06:43 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Greg KH <greg@kroah.com>, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Bernhard Roth <br@pwrnet.de>
Subject: Re: [PATCH] atmel_serial: RS485: receiving enabled when sending	data
References: <4E492CFF.7040905@pwrnet.de> <20110822211832.GA8023@kroah.com> <4E536536.3030004@evidence.eu.com> <20110823093035.GB19622@n2100.arm.linux.org.uk>
In-Reply-To: <20110823093035.GB19622@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/08/2011 11:30, Russell King - ARM Linux ha scritto:
> On Tue, Aug 23, 2011 at 10:30:46AM +0200, Claudio Scordino wrote:
>> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
>> index af9b781..5f6c745 100644
>> --- a/drivers/tty/serial/atmel_serial.c
>> +++ b/drivers/tty/serial/atmel_serial.c
>> @@ -339,8 +339,9 @@ static void atmel_stop_tx(struct uart_port *port)
>>   	/* Disable interrupts */
>>   	UART_PUT_IDR(port, atmel_port->tx_done_mask);
>>
>> -	if (atmel_port->rs485.flags&  SER_RS485_ENABLED)
>> -		atmel_start_rx(port);
>> +	if ((atmel_port->rs485.flags&  SER_RS485_ENABLED)&&
>> +		!(atmel_port->rs485.flags&  SER_RS485_RX_DURING_TX))
>> +			atmel_start_rx(port);
> 
> However, this is incorrect formatting.  The code following the 'if' ends
> up being indented by two tabs.
> 
> This illustrates why the whole idea that tabs should only be used for
> indenting is wrong.  You end up with either what you have above, or:
> 
> 	if ((atmel_port->rs485.flags&  SER_RS485_ENABLED)&&
> 		!(atmel_port->rs485.flags&  SER_RS485_RX_DURING_TX))
> 		atmel_start_rx(port);
> 
> both of which are dire for readability.  The only sane way to do this is
> to ignore that stupid "indentation by tabs only" thing and do it as the
> kernel code has _always_ been done over the last 19 years:
> 
> 	if ((atmel_port->rs485.flags&  SER_RS485_ENABLED)&&
> 	!(atmel_port->rs485.flags&  SER_RS485_RX_DURING_TX))
> 		atmel_start_rx(port);
> 
> IOW, use spaces to align the wrapped 'if' statement.
> 
>> +		if ((atmel_port->rs485.flags&  SER_RS485_ENABLED)&&
>> +			!(atmel_port->rs485.flags&  SER_RS485_RX_DURING_TX)) {
>> +				/* DMA done, stop TX, start RX for RS485 */
>> +				atmel_start_rx(port);
> 
> And here it makes it look like there's a missing brace.
> 

I understand. So the right patch should be the following one.

Best regards,

	Claudio

atmel_serial: RS485: receiving enabled when sending data

By default the atmel_serial driver in RS485 mode disables receiving data until
all data in the send buffer has been sent. This flag allows to receive data
even whilst sending data.

Signed-off-by: Bernhard Roth <br@pwrnet.de> 
Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
 drivers/tty/serial/atmel_serial.c |    9 ++++++---
 include/linux/serial.h            |    1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

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

