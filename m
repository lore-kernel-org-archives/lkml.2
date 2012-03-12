Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab2CLBYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 21:24:32 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48052 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2CLBYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 21:24:25 -0400
X-AuditID: 9c930197-b7bd0ae000002080-29-4f5d5041b5ad
From: "Kim, Jong-Sung" <neidhard.kim@lge.com>
To: "'Chanho Min'" <chanho0207@gmail.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Alan Cox'" <alan@linux.intel.com>,
        "'Shreshtha Kumar Sahu'" <shreshthakumar.sahu@stericsson.com>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>	<20120308184954.GA1275@kroah.com>	<CACRpkdY3A_k_ywWgnFYG_3Jp+EssfULO0R59=GWUG2a0VS3--g@mail.gmail.com>	<20120309163739.GA9545@kroah.com> <CAOAMb1Bpx4ucHgKy+oT2rvt16cubFR3Vi8o3fjwrT65DdJko_Q@mail.gmail.com>
In-Reply-To: <CAOAMb1Bpx4ucHgKy+oT2rvt16cubFR3Vi8o3fjwrT65DdJko_Q@mail.gmail.com>
Subject: RE: [PATCH] Clear previous interrupts after fifo is disabled
Date: Mon, 12 Mar 2012 10:24:17 +0900
Organization: LG Electronics
Message-ID: <018601ccffee$d9a8cf00$8cfa6d00$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIncI9SqTNPd0fm4fZPB+aBpvBgGgGX3bXoAhHnJzIBt8QCXAKfKVtYlXDy9zA=
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Chanho Min [mailto:chanho0207@gmail.com]
> Sent: Saturday, March 10, 2012 11:15 AM
> To: Greg Kroah-Hartman
> Cc: Linus Walleij; Russell King; Alan Cox; Shreshtha Kumar Sahu; Kim,
Jong-
> Sung; linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org
> Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
> 
> >> To me it seems Russell's patch solves part of the problem, and
> >> Jong-Sung Kim's patch on top of that solves the entire problem, but
> >> Chanho need to come back and tell whether this is the case in
> >> practice.
> >
> > Ok, then, once it is tested, can someone resend them to me?
> >
> > thanks,
> >
> > greg k-h
> 
> I checked that Jong-Sung Kim's patch solved this hang-up issue and agree
on
> it. But, RTIS seems to be cleared as well.

You're right. RTIS should be cleared as well as RXIS. Revised patch:

diff --git a/drivers/tty/serial/amba-pl011.c
b/drivers/tty/serial/amba-pl011.c
index 6800f5f..39520db 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -224,6 +224,11 @@ static int pl011_fifo_to_tty(struct uart_amba_port
*uap)
 		uart_insert_char(&uap->port, ch, UART011_DR_OE, ch, flag);
 	}
 
+	/* RTIS and/or RXIS, but RXFE? Just clear the interrupt(s) */
+	if(unlikely(fifotaken == 0))
+		writew(UART011_RTIS | UART011_RXIS, uap->port.membase +
+		       UART011_ICR);
+
 	return fifotaken;
 }



