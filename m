Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1DVNgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 09:36:36 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:32316
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627Ab1DVNgd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 09:36:33 -0400
X-SpamScore: -33
X-BigFish: VPS-33(zz1803M9371O1447R542M1432N98dKc8kzz1202hzz8275bhz2dh95h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V2] tty/serial: add support for Xilinx PS UART
Date: Fri, 22 Apr 2011 07:36:28 -0600
In-Reply-To: <4DB14626.8090002@petalogix.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V2] tty/serial: add support for Xilinx PS UART
Thread-Index: AcwAzToumuHZAoknS3+YKZ3srosTCQAI9qlw
References: <90e49570-bc82-41a9-ac79-2f5007e93a2a@VA3EHSMHS018.ehs.local> <4DB14626.8090002@petalogix.com>
From: John Linn <John.Linn@xilinx.com>
To: <michal.simek@petalogix.com>
CC: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <alan@lxorguk.ukuu.org.uk>, <greg@kroah.com>,
        <grant.likely@secretlab.ca>
X-OriginalArrivalTime: 22 Apr 2011 13:36:29.0943 (UTC) FILETIME=[49571070:01CC00F2]
Message-ID: <ad920746-773d-475a-9c0e-dc5dd7a4b1e1@VA3EHSMHS026.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Michal Simek [mailto:michal.simek@petalogix.com]
> Sent: Friday, April 22, 2011 3:11 AM
> To: John Linn
> Cc: linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org;
> alan@lxorguk.ukuu.org.uk; greg@kroah.com; grant.likely@secretlab.ca
> Subject: Re: [PATCH V2] tty/serial: add support for Xilinx PS UART
> 
> John Linn wrote:
> > The Xilinx PS Uart is used on the new ARM based SoC. This
> > UART is not compatible with others such that a seperate
> > driver is required.
> >
> > Signed-off-by: John Linn <john.linn@xilinx.com>
> > ---
> >
> > V2 Changes
> >
> > Updated based on Alan Cox and Greg KH comments. Thanks for their
> input.
> > I hope I corrected everything as expected.
> >
> > 1. Now using dynamic device nodes so Doc*/devices.txt removed from
> patch.
> > 2. Other minor updates based on Alan's input.
> >
> >  drivers/tty/serial/Kconfig         |   13 +
> >  drivers/tty/serial/Makefile        |    1 +
> >  drivers/tty/serial/xilinx_uartps.c | 1121
> ++++++++++++++++++++++++++++++++++++
> >  include/linux/serial_core.h        |    3 +
> >  4 files changed, 1138 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/tty/serial/xilinx_uartps.c
> >
> > diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> > index 80484af..84876ec 100644
> > --- a/drivers/tty/serial/Kconfig
> > +++ b/drivers/tty/serial/Kconfig
> > @@ -1612,4 +1612,17 @@ config SERIAL_MXS_AUART_CONSOLE
> >  	help
> >  	  Enable a MXS AUART port to be the system console.
> >
> > +config SERIAL_XILINX_PS_UART
> > +	tristate "Xilinx PS UART support"
> > +	select SERIAL_CORE
> > +	help
> > +	  This driver supports the Xilinx PS UART port.
> > +
> > +config SERIAL_XILINX_PS_UART_CONSOLE
> > +	bool "Xilinx PS UART console support"
> > +	depends on SERIAL_XILINX_PS_UART=y
> > +	select SERIAL_CORE_CONSOLE
> > +	help
> > +	  Enable a Xilinx PS UART port to be the system console.
> > +
> >  endmenu
> > diff --git a/drivers/tty/serial/Makefile
> b/drivers/tty/serial/Makefile
> > index fee0690..aafddf1 100644
> > --- a/drivers/tty/serial/Makefile
> > +++ b/drivers/tty/serial/Makefile
> > @@ -94,3 +94,4 @@ obj-$(CONFIG_SERIAL_IFX6X60)  	+= ifx6x60.o
> >  obj-$(CONFIG_SERIAL_PCH_UART)	+= pch_uart.o
> >  obj-$(CONFIG_SERIAL_MSM_SMD)	+= msm_smd_tty.o
> >  obj-$(CONFIG_SERIAL_MXS_AUART) += mxs-auart.o
> > +obj-$(CONFIG_SERIAL_XILINX_PS_UART) += xilinx_uartps.o
> > diff --git a/drivers/tty/serial/xilinx_uartps.c
> b/drivers/tty/serial/xilinx_uartps.c
> > new file mode 100644
> > index 0000000..814fb5b
> > --- /dev/null
> > +++ b/drivers/tty/serial/xilinx_uartps.c
> > @@ -0,0 +1,1121 @@
> > +/*
> > + * Xilinx PS UART driver
> > + *
> > + * 2011 (c) Xilinx Inc.
> > + *
> > + * This program is free software; you can redistribute it
> > + * and/or modify it under the terms of the GNU General Public
> > + * License as published by the Free Software Foundation;
> > + * either version 2 of the License, or (at your option) any
> > + * later version.
> > + *
> > + */

<snip>

> > +#define XUARTPS_SR_RXEMPTY	0x00000002 /* RX FIFO empty */
> > +#define XUARTPS_SR_TXEMPTY	0x00000008 /* TX FIFO empty */
> > +#define XUARTPS_SR_TXFULL	0x00000010 /* TX FIFO full */
> > +#define XUARTPS_SR_RXTRIG	0x00000001 /* Rx Trigger */
> > +
> > +
> 
> empty line
> 
> > +/**
> > + * xuartps_isr - Interrupt handler
> > + * @irq: Irq number
> > + * @dev_id: Id of the port
> > + *
> > + * Returns IRQHANDLED
> > + **/

<snip>

> > +
> > +	if (percent_err >= 3)
> > +		dev_err(port->dev, "Error too large, baud rate not
set\n");
> > +	else {
> > +		/* Set the values for the new baud rate */
> > +		xuartps_writel(brgr_val, XUARTPS_BAUDGEN_OFFSET);
> > +		xuartps_writel(brdiv_val, XUARTPS_BAUDDIV_OFFSET);
> > +
> 
> remove this empty line.
> 
> > +	}
> > +}
> > +
> > +

<snip>

> > +
> > +	/* Enable the TX Empty interrupt */
> > +	xuartps_writel(XUARTPS_IXR_TXEMPTY, XUARTPS_IER_OFFSET);
> > +
> > +	if (uart_circ_chars_pending(&port->state->xmit) < WAKEUP_CHARS)
> > +		uart_write_wakeup(port);
> > +
> 
> remove this empty line
> 
> > +}
> > +
> > +/**
> > + * xuartps_stop_tx - Stop TX
> > + * @port: Handle to the uart port structure
> > + *
> > + **/
> > +static void xuartps_stop_tx(struct uart_port *port)
> > +{
> > +	unsigned int regval;
> > +
> > +	regval = xuartps_readl(XUARTPS_CR_OFFSET);
> > +	regval |= XUARTPS_CR_TX_DIS;
> > +	/* Disable the transmitter */
> > +	xuartps_writel(regval, XUARTPS_CR_OFFSET);
> > +}
> > +
> > +/**
> > + * xuartps_stop_rx - Stop RX
> > + * @port: Handle to the uart port structure
> > + *
> > + **/
> > +static void xuartps_stop_rx(struct uart_port *port)
> > +{
> > +	unsigned int regval;
> > +
> > +	regval = xuartps_readl(XUARTPS_CR_OFFSET);
> > +	regval |= XUARTPS_CR_RX_DIS;
> > +	/* Disable the receiver */
> > +	xuartps_writel(regval, XUARTPS_CR_OFFSET);
> > +}
> > +
> > +/**
> > + * xuartps_tx_empty -  Check whether TX is empty
> > + * @port: Handle to the uart port structure
> > + *
> > + * Returns TIOCSER_TEMT on success, 0 otherwise
> > + **/
> > +static unsigned int xuartps_tx_empty(struct uart_port *port)
> > +{
> > +	unsigned int status;
> > +
> > +	status = xuartps_readl(XUARTPS_ISR_OFFSET) &
XUARTPS_IXR_TXEMPTY;
> > +	return status ? TIOCSER_TEMT : 0;
> > +
> 
> remove this empty line.
> 
> > +}
> > +
> > +
> 
> and this
> 
> > +/**
> > + * xuartps_break_ctl - Based on the input ctl we have to start or
> stop
> > + *			transmitting char breaks
> > + * @port: Handle to the uart port structure
> > + * @ctl: Value based on which start or stop decision is taken
> > + *
> > + **/
> > +static void xuartps_break_ctl(struct uart_port *port, int ctl)

<snip>

> > +/**
> > + * xuartps_config_port - Configure xuartps, called when the driver
> adds a
> > + *				xuartps port
> > + * @port: Handle to the uart port structure
> > + * @flags: If any
> > + *
> > + **/
> > +static void xuartps_config_port(struct uart_port *port, int flags)
> > +{
> > +	if (flags & UART_CONFIG_TYPE && xuartps_request_port(port) == 0)
> > +		port->type = PORT_XUARTPS;
> > +
> 
> empty line
> 
> > +}
> > +
> > +/**
> > + * xuartps_get_mctrl - Get the modem control state
> > + *
> > + * @port: Handle to the uart port structure
> > + *
> > + * Returns the modem control state
> > + *
> > + **/
> > +static unsigned int xuartps_get_mctrl(struct uart_port *port)
> > +{
> > +	return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
> > +}
> > +

<snip>

> > +/* Match table for of_platform binding */
> > +
> > +#ifdef CONFIG_OF
> > +static struct of_device_id xuartps_of_match[] __devinitdata = {
> > +	{ .compatible = "xlnx,xuartps", },
> > +	{}
> > +};
> > +MODULE_DEVICE_TABLE(of, xuartps_of_match);
> > +#endif
> > +
> > +static struct platform_driver xuartps_platform_driver = {
> > +	.probe   = xuartps_probe,		/* Probe method */
> > +	.remove  = __exit_p(xuartps_remove),	/* Detach method */
> > +	.suspend = xuartps_suspend,		/* Suspend */
> > +	.resume  = xuartps_resume,		/* Resume after a
suspend */
> > +	.driver  = {
> > +		.owner = THIS_MODULE,
> > +		.name = XUARTPS_NAME,		/* Driver name */
> > +#ifdef CONFIG_OF
> > +		.of_match_table = xuartps_of_match,
> > +#endif
> > +		},
> > +};
> 

Hi Michal,

I don't have a problem removing the empty lines, but is there some
guideline on that
which I'm ignoring and should know?

> AFAIK. Grant proposed to write it in different style. I think he will
> agree with me.
> 
> #ifdef CONFIG_OF
> static struct of_device_id xuartps_of_match[] __devinitdata = {
> 	{ .compatible = "xlnx,xuartps", },
> 	{}
> };
> MODULE_DEVICE_TABLE(of, xuartps_of_match);
> #else
> #define xuartps_of_match NULL
> #endif
> 
> 
> static struct platform_driver xuartps_platform_driver = {
> 	.probe   = xuartps_probe,		/* Probe method */
> 	.remove  = __exit_p(xuartps_remove),	/* Detach method */
> 	.suspend = xuartps_suspend,		/* Suspend */
> 	.resume  = xuartps_resume,		/* Resume after a
suspend */
> 	.driver  = {
> 		.owner = THIS_MODULE,
> 		.name = XUARTPS_NAME,		/* Driver name */
> 		.of_match_table = xuartps_of_match,
> 	},
> };
> 

I'll check it out, that does look familiar to me now that you say it.
We've had this
driver around for a while so it just needs to be updated to the newer
style.

Easy enough.

Thanks for the review and input,
John

> Regards,
> Michal
> 
> 
> 
> --
> Michal Simek, Ing. (M.Eng)
> PetaLogix - Linux Solutions for a Reconfigurable World
> w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-
> 30090663


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


