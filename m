Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1DSVvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:51:05 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:24226
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754703Ab1DSVvB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:51:01 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz1803M9371O542M1432N98dK4015Lzz1202hzz8275bh8275dhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] tty/serial: add support for Xilinx PS UART
Date: Tue, 19 Apr 2011 15:51:02 -0600
In-Reply-To: <20110419221530.7370d013@lxorguk.ukuu.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] tty/serial: add support for Xilinx PS UART
Thread-Index: Acv+1sssSnFxRt9QTa61MFxv9kDe+AAAC4CA
References: <e35578a9-909d-4594-bbe4-41d89b5f9b3e@VA3EHSMHS014.ehs.local> <20110419221530.7370d013@lxorguk.ukuu.org.uk>
From: John Linn <John.Linn@xilinx.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
X-OriginalArrivalTime: 19 Apr 2011 21:50:57.0251 (UTC) FILETIME=[DD31C330:01CBFEDB]
X-RCIS-Action: ALLOW
Message-ID: <551928f1-72b8-432e-879e-8721b5c87414@VA3EHSMHS017.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Tuesday, April 19, 2011 3:16 PM
> To: John Linn
> Cc: linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org
> Subject: Re: [PATCH] tty/serial: add support for Xilinx PS UART
> 
> On Tue, 19 Apr 2011 14:14:52 -0600
> John Linn <john.linn@xilinx.com> wrote:
> 
> > The Xilinx PS Uart is used on the new ARM based SoC. This
> > UART is not compatible with others such that a seperate
> > driver is required.
> 
> Joyous. I wish people would standardise.

Yes I agree, I don't always have control of this situation. I'd
also rather not re-invent the wheel.

> 
> > +		 213 = /dev/ttyPS0		Xilinx PS serial port 0
> > +		 214 = /dev/ttyPS1		Xilinx PS serial port 1
> > +		 215 = /dev/ttyPS2		Xilinx PS serial port 2
> > +		 216 = /dev/ttyPS3		Xilinx PS serial port 3
> 
> Is there a specific reason you need fixed minor numbers ? If not
please
> use a dynamic range and keep Linus happy.

I don't know honestly. I'll need to dig into this feature and understand
it
better.

> 
> > +/**
> > + * xuartps_isr - Interrupt handler
> > + * @irq: Irq number
> > + * @dev_id: Id of the port
> > + *
> > + * Returns IRQHANDLED
> > + **/
> > +static irqreturn_t xuartps_isr(int irq, void *dev_id)
> > +{
> > +	struct uart_port *port = (struct uart_port *)dev_id;
> > +	struct tty_struct *tty = port->state->port.tty;
> > +	unsigned long flags;
> > +	unsigned int isrstatus, numbytes;
> > +	unsigned int data;
> > +	char status = TTY_NORMAL;
> > +
> > +	spin_lock_irqsave(&port->lock, flags);
> 
> The ttys are refcounting now and your locking subtly wrong if you want
> to
> avoid it (you lookup port-> stuff before you lock it)
> 
> The best way to do this is
> 
> 	tty = tty_port_tty_get(&port->state->port);
> 
> 	/* Returns a tty with reference or NULL */
> 
> 	Do stuff
> 
> 	tty_kref_put(tty);

Thanks, I'll update to this new way.

> 
> 
> 
> > +static void xuartps_set_termios(struct uart_port *port,
> > +				struct ktermios *termios, struct
ktermios *old)
> > +{
> 
> > +	/* Min baud rate = 6bps and Max Baud Rate is 10Mbps for 100Mhz
> clk */
> > +	baud = uart_get_baud_rate(port, termios, old, 0, 460800);
> > +	xuartps_set_baud_rate(port, baud);
> 
> So why pass 460800 ?

Seems like 115200 is better number.

> 
> > +	if (termios->c_iflag & INPCK)
> > +		port->read_status_mask |= XUARTPS_IXR_PARITY |
> > +		XUARTPS_IXR_FRAMING;
> > +
> > +	if (termios->c_iflag & IGNPAR)
> > +		port->ignore_status_mask |= XUARTPS_IXR_PARITY |
> > +			XUARTPS_IXR_FRAMING | XUARTPS_IXR_OVERRUN;
> > +
> > +	/* ignore all characters if CREAD is not set */
> > +	if ((termios->c_cflag & CREAD) == 0)
> > +		port->ignore_status_mask |= XUARTPS_IXR_RXTRIG |
> > +			XUARTPS_IXR_TOUT | XUARTPS_IXR_PARITY |
> > +			XUARTPS_IXR_FRAMING | XUARTPS_IXR_OVERRUN;
> > +
> > +	mode_reg = xuartps_readl(XUARTPS_MR_OFFSET);
> > +
> > +	/* Handling Data Size */
> > +	switch (termios->c_cflag & CSIZE) {
> > +	case CS6:
> > +		cval |= XUARTPS_MR_CHARLEN_6_BIT;
> > +		break;
> > +	case CS7:
> > +		cval |= XUARTPS_MR_CHARLEN_7_BIT;
> > +		break;
> > +	default:
> > +	case CS8:
> > +		cval |= XUARTPS_MR_CHARLEN_8_BIT;
> > +		break;
> 
> You need to clear/set appropriately any flags for hardware requests
you
> cannot meet. So your default should be
> 
> 	termios->c_cflag &= ~CSIZE;
> 	termios->c_cflag |= CS8;
> 
> to rewrite CS5
> 

Makes sense, easy to fix.

> And set the baud rate (see 8250.c for an example). Note that the
helper
> functions know about mapping slight errors so if you are asked for
9600
> and the hardware does 9575 it will report B9600 as you'd expect not do
> something crazy.
> 

Sorry I didn't follow what you meant above. The h/w is a bit different
with it's
baud rate settings due to 2 different dividers.

> > +	xuartps_set_baud_rate(port, 9600);
> 
> This seems a bit odd in the startup or is there a hardware need to do
> this and then fix the rate ? Ditto some of the others

Could be left over from quite some time ago when the h/w was early and
buggy.
I'll check it out better and see if it can go away.

Thanks, appreciate the review and input.
John

> 
> 
> Otherwise looks fine.
> 
> Alan


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


