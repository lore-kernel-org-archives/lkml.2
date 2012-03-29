Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab2C2PCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:02:07 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50199 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373Ab2C2PB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:01:56 -0400
Date: Thu, 29 Mar 2012 16:04:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Donald" <donald@asix.com.tw>
Cc: "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: Patch "USB: serial: mos7840: Supported MCS7810 device"
Message-ID: <20120329160414.1e70d4c5@pyramind.ukuu.org.uk>
In-Reply-To: <005a01cd0db0$8ec89e50$ac59daf0$@com.tw>
References: <009c01cd00ee$924eb2e0$b6ec18a0$@com.tw>
	<20120313160951.GA18810@kroah.com>
	<005a01cd0db0$8ec89e50$ac59daf0$@com.tw>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static void mos7810_control_callback(struct urb *urb)
> +{
> +	if (!urb)
> +		return;

How can this ever occur. If its not theoretically possible then this
check is just going to hide bugs in future.

> +static void mos7810_led_off(unsigned long arg)
> +{
> +	struct moschip_port *mcs = (struct moschip_port *) arg;
> +
> +	if (!mcs)
> +		return;

Ditto

> +	/* Turn on MCS7810 LED */
> +	if (serial->num_ports == 1 && mos7840_port->mos7810_led_flag == 0) {
> +		mos7840_port->mos7810_led_flag = 1;
> +		mos7810_set_reg(mos7840_port, 0x0301,
> MODEM_CONTROL_REGISTER);
> +		mod_timer(&mos7840_port->mos7810_led_timer1, jiffies + 500);
> +	}

The assumption that serial->num_ports = 1 means "has LED" is going to
cause problems later if another deivce appears with 1 port and no LED. I
think it would be much clearer to have something like

	if (mos7840_port->has_led)

for these tests of the driver

> +static int mos7810_check(struct usb_serial *serial)
> +{
> +	int i, pass_count = 0;
> +	__u16 Data = 0, MCR_Data = 0;
> +	__u16 test_pattern = 0x55AA, write_pattern;

generally linux style is all lower case for egister names. Not a big deal

> +		/* If this a MCS7810 device, both test patterns must match
> */
> +		if (((test_pattern >> i) & 0x0001) != ((~(Data >> 1)) &
> 0x0001))

		if (((test_pattern >> i) ^ (~Data >> 1)) & 0x0001) ?

again trivia...


> +			mos7840_port->mos7810_led_timer1.expires =
> +							jiffies + 500;

This 500 value depends upon the HZ value of the kernel which won't always
be 1000 on all platforms. You probably want

			jiffies + msecs_to_jiffies(500);

(or indeed HZ/2)

> +				/* Turn off MCS7810 LED */
> +				usb_control_msg(serial->dev,
> +					usb_sndctrlpipe(serial->dev, 0),
> +					MCS_WRREQ, MCS_WR_RTYPE, 0x0300,
> +					MODEM_CONTROL_REGISTER,	NULL, 0,
> +					MOS_WDR_TIMEOUT);
> +

Might be clearer if these occurences were a separate small function - gcc
will inline them if it makes sense, and it will be clearer.


Alan
