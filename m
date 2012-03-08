Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab2CHJR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:17:58 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47301 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab2CHJRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 04:17:54 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2012 04:17:53 EST
X-AuditID: 9c930179-b7c4fae0000073fb-0a-4f5875b854c1
From: "Kim, Jong-Sung" <neidhard.kim@lge.com>
To: "'Chanho Min'" <chanho0207@gmail.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Alan Cox'" <alan@linux.intel.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Shreshtha Kumar Sahu'" <shreshthakumar.sahu@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
In-Reply-To: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
Subject: RE: [PATCH] Clear previous interrupts after fifo is disabled
Date: Thu, 8 Mar 2012 18:02:48 +0900
Organization: LG Electronics
Message-ID: <00d901ccfd0a$3c268740$b47395c0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIncI9SqTNPd0fm4fZPB+aBpvBgGpWrLkmQ
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Chanho Min [mailto:chanho0207@gmail.com]
> Sent: Monday, February 27, 2012 6:30 PM
> To: Russell King; Alan Cox; Greg Kroah-Hartman; Linus Walleij; Shreshtha
> Kumar Sahu; Kim, Jong-Sung
> Cc: linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org
> Subject: [PATCH] Clear previous interrupts after fifo is disabled
> 
> This is another workaroud of  'https://lkml.org/lkml/2012/1/17/104'
> with additional analysis.Bootloader can transfer control to kernel and
there
> are some pending interrupts. In this case, RXFE of the flag register is
set
> by clearing FEN(LCRH) even if rx data remains in the fifo. It seems that
the
> fifo's status is initiailized. Interrupt handler can not get any data from
> data register because of the below break condtion.
> 
> pl011_fifo_to_tty
>  while (max_count--) {
>    if (status & UART01x_FR_RXFE)
> 	break;
> 
> Then, Rx interrupt is never cleared. cpu is looping in ISR. System is
hang.
> If we don't guarantee that no interrupt is pended until fifo is disabled
by
> calling 'writew(0, uap->port.membase + uap->lcrh_rx)', this misbehave of
the
> interrupt handelr can be occurred. So, All pending interrupts should be
> cleared just after fifo is disabled under the protection from interrupt.
> Also,'clear error interrupts' routine can be removed becuase all
interrupts
> are cleared before.
> 
> Signed-off-by: Chanho Min <chanho.min@lge.com>

May I suggest another approach at this point? The problematic condition you
reported could be considered as an exceptional Rx interrupt status. So, we
can handle it in the Rx ISR. Simply:

diff --git a/drivers/tty/serial/amba-pl011.c
b/drivers/tty/serial/amba-pl011.c
index 6800f5f..5b5358705 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -224,6 +224,10 @@ static int pl011_fifo_to_tty(struct uart_amba_port
*uap)
                uart_insert_char(&uap->port, ch, UART011_DR_OE, ch, flag);
        }
 
+       /* RXIS but RXFE? Just clear the interrupt */
+       if(unlikely(fifotaken == 0))
+               writew(UART011_RXIS, uap->port.membase + UART01x_ICR);
+
        return fifotaken;
 }


