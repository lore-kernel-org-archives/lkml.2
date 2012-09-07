Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360Ab2IGLMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:12:18 -0400
Received: from ni.piap.pl ([195.187.100.4]:41618 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab2IGLMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:12:15 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
References: <m3k3w8g2m4.fsf@t19.piap.pl>
	<20120906140137.75ebe6ba@pyramind.ukuu.org.uk>
Date: Fri, 07 Sep 2012 13:07:20 +0200
In-Reply-To: <20120906140137.75ebe6ba@pyramind.ukuu.org.uk> (Alan Cox's
	message of "Thu, 6 Sep 2012 14:01:37 +0100")
MIME-Version: 1.0
Message-ID: <m3627qt7kn.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: 3.4.10 N_GSM tty_io WARNING and lockup
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20120907 #7775168, check: 20120907 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> I'm trying to use GSM tty line discipline. Basically
>> 
>> echo AT+CMUX=0 > /dev/ttyS0
>> 
>> set termios (speed etc.)
>> int ldisc = N_GSM0710;
>> ioctl(fd, TIOCSETD, &ldisc);
>
> Baffled at this point. If you set some other ldisc instead (eg PPP) can
> you reproduce it the same way ?

In the meantime I've rebased to v3.5.3 and it started to work. Do you
think it is worth it investigating v3.4.10 at this point?

This is Atheros AR71xx based RouterStation Pro board (MIPS). I'm using
several patches supporting this board, though I can't see anything
relevant to serial/tty, except maybe the following (which is IMHO not
the problem source either):

@@ -1941,17 +1941,20 @@ static int serial8250_startup(struct uart_port *port)
	if (port->type == PORT_16C950) {
 		/* Wake up and initialize UART */
-		up->acr = 0;
+		up->acr = UART_ACR_RTS_485;
+		serial_icr_write(up, UART_ACR, up->acr);
 		serial_port_out(port, UART_LCR, UART_LCR_CONF_MODE_B);
 		serial_port_out(port, UART_EFR, UART_EFR_ECB);
 		serial_port_out(port, UART_IER, 0);
 		serial_port_out(port, UART_LCR, 0);
+#if 0
 		serial_icr_write(up, UART_CSR, 0); /* Reset the UART */
 		serial_port_out(port, UART_LCR, UART_LCR_CONF_MODE_B);
 		serial_port_out(port, UART_EFR, UART_EFR_ECB);
 		serial_port_out(port, UART_LCR, 0);
+#endif

Anyway the patchsets are almost identical with both kernel versions.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
