Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1KHPpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:45:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58340 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1KHPpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:45:51 -0500
Message-ID: <4EB94EAA.2010603@evidence.eu.com>
Date: Tue, 08 Nov 2011 16:45:46 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>, alan@linux.intel.com,
        Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jesper Nilsson <Jesper.Nilsson@axis.com>,
        Mikael Starvik <mikael.starvik@axis.com>,
        Darron Black <darron@griffin.net>
Subject: Re: [PATCH] RS485: fix inconsistencies in the meaning of some variables
References: <4E492CFF.7040905@pwrnet.de> <20110822211832.GA8023@kroah.com> <4EB3A009.10502@evidence.eu.com> <4EB8F6B9.6010008@atmel.com> <4EB90902.4030200@evidence.eu.com> <4EB9447C.4050109@atmel.com>
In-Reply-To: <4EB9447C.4050109@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/11/2011 16:02, Nicolas Ferre ha scritto:
> On 11/08/2011 11:48 AM, Claudio Scordino :
>> Il 08/11/2011 10:30, Nicolas Ferre ha scritto:
>>> On 11/04/2011 09:19 AM, Claudio Scordino :
>>>> Hi Alan, Hi Greg,
>>>>
>>>>      it seems that the crisv10.c and the atmel_serial.c serial
>>>> drivers interpret the fields of the serial_rs485 structure in a
>>>> different
>>>> way.
>>>>
>>>> In particular, it seems that crisv10.c uses SER_RS485_RTS_AFTER_SEND and
>>>> SER_RS485_RTS_ON_SEND for the _logic value_ of the RTS pin;
>>>> atmel_serial.c, instead, uses these values to know if a _delay_ must be
>>>> set before and after sending.
>>>
>>> It seems sensible, but, on the other hand, I fear that this is a big
>>> change in the user interface: If people are already relying on this for
>>> their application, this can be difficult to understand the change. Can't
>>> we imagine an smoother migration path?
>>>
>>> It seems from de6f86ce5 that 16C950 may also use rs485 mode (with
>>> another signal that RTS BTW)...
>>>
>>> See comments online...
>>>
>>>> This patch makes the usage of these variables consistent across all
>>>> drivers and fixes the Documentation as well.
>>>> In particular, SER_RS485_RTS_AFTER_SEND and SER_RS485_RTS_ON_SEND will
>>>> be used to set the logic value of the RTS pin (as in the crisv10.c
>>>> driver); the delay is understood by looking only at the value of
>>>> delay_rts_before_send and delay_rts_after_send.
>>>>
>>>> Best regards,
>>>>
>>>>      Claudio
>>>>
>>>>
>>>> Subject: RS485: fix inconsistencies in the meaning of some variables
>>>> From: Claudio Scordino<claudio@evidence.eu.com>
>>>>
>>>> The crisv10.c and the atmel_serial.c serial drivers interpret the fields
>>>> of the serial_rs485 structure in a different way.
>>>> In particular, crisv10.c uses SER_RS485_RTS_AFTER_SEND and
>>>> SER_RS485_RTS_ON_SEND for the voltage of the RTS pin; atmel_serial.c,
>>>> instead,
>>>> uses these values to know if a delay must be set before and after
>>>> sending.
>>>> This patch makes the usage of these variables consistent across all
>>>> drivers and
>>>> fixes the Documentation as well.
>>>>>  From now on, SER_RS485_RTS_AFTER_SEND and SER_RS485_RTS_ON_SEND
>>>> will be used to
>>>> set the voltage of the RTS pin (as in the crisv10.c driver); the
>>>> delay will be
>>>> understood by looking only at the value of delay_rts_before_send and
>>>> delay_rts_after_send.
>>>
>>> Ok, but don't you think that the flags names are not so much
>>> self-explanatory for this new meaning?
>>>
>>> What about:
>>> SER_RS485_RTS_LEVEL_DURING_SEND
>>> SER_RS485_RTS_VALUE_DURING_SEND (maybe too vague?)
>>> SER_RS485_RTS_LOGICAL_VALUE_DURING_SEND (maybe too long?)
>>>
>>> Moreover, can't we just use one property for this? I mean, if RTS
>>> logical value is high during the sending of data, can it mean that RTS
>>> will be low before and after? And the other way around: if the signal is
>>> low during data send, will it be high before and after?
>>>
>>> Here again, changing the user interface is not a good idea, so I fear
>>> that it can be a show stopper.
>>
>> Hi Nicolas,
>>
>>      I understand, but honestly I do not agree.
>>
>> The current state is inconsistent, and leaving the status quo can only
>> bring to more issues in the future (because it is not clear if the
>> interface should be used either as in the Cris or in the Atmel driver).
>> That's why I think it should be fixed ASAP (before further drivers start
>> using it).
>>
>> The modifications that I have proposed are very minimal, and most
>> user-space code should continue to work without any difference. Any Cris
>> user-space code will continue to work, because we didn't change the
>> behavior of the driver. For Atmel user-space code, instead, the behavior
>> of the driver changes only if flags are not set and delay variables
>> contain a value different than 0 (which, hopefully, is not a very common
>> situation).
> 
> Ok then. I was fearing that, with Atmel driver, someone can set
> SER_RS485_RTS_AFTER_SEND to tell that the delay is needed but not
> necessarily that the signal level is "high".
> 
> But you are right telling that this inconstancy should be addressed.
> 
>> That's the reason why I preferred to not change the names of
>> the variables, even if better names would be desirable.
> 
> 100% agree with this.
> 
>> If you want, I can re-format the patch according to you suggestions,
> 
> Yes
> 
>> remove formatted lines
> 
> Yes

Hi all,

	please find below a better formatted patch.

Best regards,

	Claudio



Subject: RS485: fix inconsistencies in the meaning of some variables
From: Claudio Scordino <claudio@evidence.eu.com>

The crisv10.c and the atmel_serial.c serial drivers intepret the fields of the
serial_rs485 structure in a different way.
In particular, crisv10.c uses SER_RS485_RTS_AFTER_SEND and 
SER_RS485_RTS_ON_SEND for the voltage of the RTS pin; atmel_serial.c, instead,
uses these values to know if a delay must be set before and after sending.
This patch makes the usage of these variables consistent across all drivers and
fixes the Documentation as well.
>From now on, SER_RS485_RTS_AFTER_SEND and SER_RS485_RTS_ON_SEND will be used to
set the voltage of the RTS pin (as in the crisv10.c driver); the delay will be
understood by looking only at the value of delay_rts_before_send and 
delay_rts_after_send.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Signed-off-by: Darron Black <darron@griffin.net>
---
 Documentation/serial/serial-rs485.txt |   14 +++++++++++---
 drivers/tty/serial/atmel_serial.c     |   16 +++-------------
 drivers/tty/serial/crisv10.c          |   10 ++--------
 include/linux/serial.h                |   14 ++++++++------
 4 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/Documentation/serial/serial-rs485.txt b/Documentation/serial/serial-rs485.txt
index 079cb3d..41c8378 100644
--- a/Documentation/serial/serial-rs485.txt
+++ b/Documentation/serial/serial-rs485.txt
@@ -97,15 +97,23 @@
 
 	struct serial_rs485 rs485conf;
 
-	/* Set RS485 mode: */
+	/* Enable RS485 mode: */
 	rs485conf.flags |= SER_RS485_ENABLED;
 
+	/* Set logical level for RTS pin equal to 1 when sending: */
+	rs485conf.flags |= SER_RS485_RTS_ON_SEND;
+	/* or, set logical level for RTS pin equal to 0 when sending: */
+	rs485conf.flags &= ~(SER_RS485_RTS_ON_SEND);
+
+	/* Set logical level for RTS pin equal to 1 after sending: */
+	rs485conf.flags |= SER_RS485_RTS_AFTER_SEND;
+	/* or, set logical level for RTS pin equal to 0 after sending: */
+	rs485conf.flags &= ~(SER_RS485_RTS_AFTER_SEND);
+
 	/* Set rts delay before send, if needed: */
-	rs485conf.flags |= SER_RS485_RTS_BEFORE_SEND;
 	rs485conf.delay_rts_before_send = ...;
 
 	/* Set rts delay after send, if needed: */
-	rs485conf.flags |= SER_RS485_RTS_AFTER_SEND;
 	rs485conf.delay_rts_after_send = ...;
 
 	/* Set this flag if you want to receive data even whilst sending data */
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 4a0f86f..4c823f3 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -228,7 +228,7 @@ void atmel_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
 	if (rs485conf->flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
 		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
-		if (rs485conf->flags & SER_RS485_RTS_AFTER_SEND)
+		if ((rs485conf->delay_rts_after_send) > 0)
 			UART_PUT_TTGR(port, rs485conf->delay_rts_after_send);
 		mode |= ATMEL_US_USMODE_RS485;
 	} else {
@@ -304,7 +304,7 @@ static void atmel_set_mctrl(struct uart_port *port, u_int mctrl)
 
 	if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
-		if (atmel_port->rs485.flags & SER_RS485_RTS_AFTER_SEND)
+		if ((atmel_port->rs485.delay_rts_after_send) > 0)
 			UART_PUT_TTGR(port,
 					atmel_port->rs485.delay_rts_after_send);
 		mode |= ATMEL_US_USMODE_RS485;
@@ -1228,7 +1228,7 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
-		if (atmel_port->rs485.flags & SER_RS485_RTS_AFTER_SEND)
+		if ((atmel_port->rs485.delay_rts_after_send) > 0)
 			UART_PUT_TTGR(port,
 					atmel_port->rs485.delay_rts_after_send);
 		mode |= ATMEL_US_USMODE_RS485;
@@ -1447,16 +1447,6 @@ static void __devinit atmel_of_init_port(struct atmel_uart_port *atmel_port,
 		rs485conf->delay_rts_after_send = rs485_delay[1];
 		rs485conf->flags = 0;
 
-		if (rs485conf->delay_rts_before_send == 0 &&
-		    rs485conf->delay_rts_after_send == 0) {
-			rs485conf->flags |= SER_RS485_RTS_ON_SEND;
-		} else {
-			if (rs485conf->delay_rts_before_send)
-				rs485conf->flags |= SER_RS485_RTS_BEFORE_SEND;
-			if (rs485conf->delay_rts_after_send)
-				rs485conf->flags |= SER_RS485_RTS_AFTER_SEND;
-		}
-
 		if (of_get_property(np, "rs485-rx-during-tx", NULL))
 			rs485conf->flags |= SER_RS485_RX_DURING_TX;
 
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index b743504..1dfba7b 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3234,9 +3234,8 @@ rs_write(struct tty_struct *tty,
 		e100_disable_rx(info);
 		e100_enable_rx_irq(info);
 #endif
-		if ((info->rs485.flags & SER_RS485_RTS_BEFORE_SEND) &&
-			(info->rs485.delay_rts_before_send > 0))
-				msleep(info->rs485.delay_rts_before_send);
+		if (info->rs485.delay_rts_before_send > 0)
+			msleep(info->rs485.delay_rts_before_send);
 	}
 #endif /* CONFIG_ETRAX_RS485 */
 
@@ -3693,10 +3692,6 @@ rs_ioctl(struct tty_struct *tty,
 
 		rs485data.delay_rts_before_send = rs485ctrl.delay_rts_before_send;
 		rs485data.flags = 0;
-		if (rs485data.delay_rts_before_send != 0)
-			rs485data.flags |= SER_RS485_RTS_BEFORE_SEND;
-		else
-			rs485data.flags &= ~(SER_RS485_RTS_BEFORE_SEND);
 
 		if (rs485ctrl.enabled)
 			rs485data.flags |= SER_RS485_ENABLED;
@@ -4531,7 +4526,6 @@ static int __init rs_init(void)
 		/* Set sane defaults */
 		info->rs485.flags &= ~(SER_RS485_RTS_ON_SEND);
 		info->rs485.flags |= SER_RS485_RTS_AFTER_SEND;
-		info->rs485.flags &= ~(SER_RS485_RTS_BEFORE_SEND);
 		info->rs485.delay_rts_before_send = 0;
 		info->rs485.flags &= ~(SER_RS485_ENABLED);
 #endif
diff --git a/include/linux/serial.h b/include/linux/serial.h
index 97ff8e2..3d86517 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -207,13 +207,15 @@ struct serial_icounter_struct {
 
 struct serial_rs485 {
 	__u32	flags;			/* RS485 feature flags */
-#define SER_RS485_ENABLED		(1 << 0)
-#define SER_RS485_RTS_ON_SEND		(1 << 1)
-#define SER_RS485_RTS_AFTER_SEND	(1 << 2)
-#define SER_RS485_RTS_BEFORE_SEND	(1 << 3)
+#define SER_RS485_ENABLED		(1 << 0)	/* If enabled */
+#define SER_RS485_RTS_ON_SEND		(1 << 1)	/* Logical level for
+							   RTS pin when
+							   sending */
+#define SER_RS485_RTS_AFTER_SEND	(1 << 2)	/* Logical level for
+							   RTS pin after sent*/
 #define SER_RS485_RX_DURING_TX		(1 << 4)
-	__u32	delay_rts_before_send;	/* Milliseconds */
-	__u32	delay_rts_after_send;	/* Milliseconds */
+	__u32	delay_rts_before_send;	/* Delay before send (milliseconds) */
+	__u32	delay_rts_after_send;	/* Delay after send (milliseconds) */
 	__u32	padding[5];		/* Memory is cheap, new structs
 					   are a royal PITA .. */
 };
-- 
1.7.1

