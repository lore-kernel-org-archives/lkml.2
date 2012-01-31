Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2AaH1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 02:27:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57916 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab2AaH1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 02:27:42 -0500
MIME-Version: 1.0
Date: Tue, 31 Jan 2012 16:27:41 +0900
Message-ID: <CAOAMb1APdCnB8hDHo6sTP-eaws8c2FB2Bt0mJX2B3+9AK8x2Zw@mail.gmail.com>
Subject: Re: [PATCH] amba-pl011: clear previous interrupts before request_irq
From: Chanho Min <chanho0207@gmail.com>
To: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry for late reply and missing sign-off.
> In the setup where console is disabled and logs are diverted to buffer, it is
> observed that, continuous uart interrupts are coming. Even before IMSC
> (Interrupt mask set/clear register) is enabled for TX or RX interrupts,
> it is seen that interrupt handler getting called just after request_irq.
> It was found that this situation happens when RIS (raw interrupt register)
> has some pending interrupts (e.g. RI, CTS, DCD, RX etc. but IMO RX is main)
> when control gets transferred to kernel from bootloader. This refers that
> GIC (global interrupt controller) is providing interrupt even if interrupts
> for UART are masked/disabled in IMSC register.
> In this state problem elivated when cpu is looping in interrupt handler
> because of Rx interrupt set but Rx fifo is empty (hence rx_char is simply
> returning). How UART goes in to this state is still not completely
> understood.
Hi,
This is my analsys.
RXFE is set by 'writew(0, uap->port.membase + uap->lcrh_rx)'
UART can not get any data from DR because of the below break condtion.
pl011_fifo_to_tty
 while (max_count--) {
   if (status & UART01x_FR_RXFE)
	break;
Rx interrupt is never cleared. cpu is looping in ISR.
