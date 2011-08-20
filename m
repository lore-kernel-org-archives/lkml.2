Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1HTA6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 20:58:47 -0400
Received: from b.mail.sonic.net ([64.142.19.5]:59587 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1HTA6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 20:58:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Priority: Normal
X-Mailer: AtMail PHP 5.62
Message-ID: <29681.1313801904@sonic.net>
To: "Jiri Slaby" <jslaby@suse.cz>, <mikeci@acm.org>
Reply-To: mikeci@acm.org
X-Origin: 207.114.132.30
X-Atmail-Account: mikeci@sonic.net
Date: Fri, 19 Aug 2011 17:58:24 -0700
Subject: Re: Possible bug in 8250.c
From: Ivica Mikec <mikeci@acm.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I traced the function using jtag debugger. 

UART is not sharing interrupts:
========================================= Console ========================
Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
serial8250.0: ttyS0 at MMIO 0xae023400 (irq = 53) is a 16550A
console [ttyS0] enabled, bootconsole disabled
=========================================================================
And /proc/interrupts:

=========================================================================
cat /proc/interrupts
              CPU0
 53:       4534                XXXXX  serial
 56:         12                   XXXXX  phy_interrupt
153:   20262068          XXXXX  timer
ERR:          0
=========================================================================

So in first iteration, interrupt is cleared, and in second, function will execute:

          } else if (end == NULL)
                        end = l;

which will terminate the loop, but the return code will be IRQ_RETVAL(0).




On Fri 19/08/11 12:01 , Jiri Slaby <jslaby@suse.cz> wrote:

> On 08/19/2011 07:44 PM, Ivica Mikec wrote:
> > 
> > Hi!
> > 
> > 
> > I noticed a problem in 8250.c. 
> > 
> > My board has only one UART port, and is 16550 compatible, so in function
> serial8250_interrupt I see that serial_in function is called twice. Second
> time, code "else if (end == NULL)" is executed and function return
> IRQ_NONE. This causes an entry in /proc/irq/spurious:
> > 
> > count 239
> > unhandled 1
> > last_unhandled 4294700846 ms
> > 
> > But this is not a spurious interrupt.
> 
> How did you find out? Have you checked that the port signals that it
> raised an interrupt? I.e. does it go through the 'if (!(iir &
> UART_IIR_NO_INT))' branch?
> 
> What other devices are bound to the same interrupt? Attach
> /proc/interrupts.
> 
> regards,
> -- 
> js
> suse labs
> 
> 
> 
