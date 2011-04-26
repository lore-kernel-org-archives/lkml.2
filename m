Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1DZXVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 19:21:41 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:55185 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694Ab1DZXVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 19:21:40 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Apr 2011 19:21:40 EDT
Date: Tue, 26 Apr 2011 23:15:58 +0000 (UTC)
From: johnlinn@comcast.net
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        michal.simek@petalogix.com, joe@perches.com, grant.likely@secretlab.ca,
        greg@kroah.com
Message-ID: <549692800.1907368.1303859758362.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <381805170.1906645.1303859011392.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
Subject: Re: [PATCH V3] tty/serial: add support for Xilinx PS UART
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [149.199.62.254]
X-Mailer: Zimbra 6.0.5_GA_2431.RHEL5_64 (ZimbraWebClient - IE8 (Win)/6.0.5_GA_2427.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
> Sent: Tuesday, April 26, 2011 1:58 PM
> To: John Linn
> Cc: linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org;
> michal.simek@petalogix.com; joe@perches.com;
> grant.likely@secretlab.ca;
> greg@kroah.com
> Subject: Re: [PATCH V3] tty/serial: add support for Xilinx PS UART
> 
> O
> > +	if (percent_err >= 3)
> > +		dev_err(port->dev, "Error too large, baud rate not
> set\n");
> 
> So in this cause baud isn't the one the user asked. Also the user can
> make it spew errors by continually generating wrong rates.
> 
> If the error is large go for the nearest you can and return it. The
> core
> tty code will do all the rest including reporting to the user they
> didn't
> get their wishes.
> 

Hi Alan,

Thanks for the input. I wrestled with this some before doing the 1st patchset.  

Prior to this, we were not checking for this error, but instead we were finding
the values with the least amount of error and then going with them.

I thought I was improving but now as I look at it further, that seems like it 
was better and I should have stuck to that method.

Thoughts?

> > +	else {
> > +		/* Set the values for the new baud rate */
> > +		xuartps_writel(brgr_val, XUARTPS_BAUDGEN_OFFSET);
> > +		xuartps_writel(brdiv_val, XUARTPS_BAUDDIV_OFFSET);
> 
> and in this it may not be exact.
> 
> I suspect this routine needs to return the actual baud rate (or maybe
> baudrate/error code)
> 
> 
> > +	/* Min baud rate = 6bps and Max Baud Rate is 10Mbps for 100Mhz
> clk */
> > +	baud = uart_get_baud_rate(port, termios, old, 0, 10000000);
> > +	xuartps_set_baud_rate(port, baud);
> > +	if (tty_termios_baud_rate(termios))
> > +		tty_termios_encode_baud_rate(termios, baud, baud);
> 
> and this should do something like
> 
> 	baud = xuartps_set_baud_rate(port baud);
> 
> > +
> > +	/*
> > +	 * Update the per-port timeout.
> > +	 */
> > +	uart_update_timeout(port, termios->c_cflag, baud);
> 
> [which would also fix this timeout!]

Maybe you were meaning that if the baud rate was not really set because of the
error this timeout would be wrong also, and if so that makes sense.

Otherwise, I didn't undestand why the timeout was broken.

Thanks,
John

> 
> Otherwise looks ready to merge
> 
> 
