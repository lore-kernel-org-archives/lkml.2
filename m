Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab2JWTnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:43:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34166 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab2JWTnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <20121023110133.62bed522@pyramind.ukuu.org.uk>
References: <alpine.LFD.2.02.1210221633450.28146@nightowl>
	<20121023110133.62bed522@pyramind.ukuu.org.uk>
Date: Tue, 23 Oct 2012 12:43:50 -0700
Message-ID: <CAJ0e-Fofs48N9VnYr1_8Kch6+yHjGx9iCWBRtRsqpD-B_rWutQ@mail.gmail.com>
Subject: Re: [PATCH] serial: 8250 check iir rdi in interrupt
From: Min Zhang <mzhang@mvista.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 3:01 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> > Added module parameter skip_rdi_check to opt out this workaround.
>
> NAK. Anything like this should be runtime.

One can echo 1 (or 0) > /sys/modules/8250/parameters/skip_rdi_check
during run time to turn it off (or on) dynamically. Does it count as
runtime?

> > Tested on Radisys ATCA 46XX which uses FPGA 16550-compatible and
> > other generic 16550 UART. It takes from an hour to days to reproduce by
> > pumping inputs to serial console continously using TeraTerm script:
>
> You turn this on by default but it's a nasty IRQ latency penalty
> on a lot of x86 platforms with the uarts on the lpc bus.

I agree. Will this patch be more acceptable if default is off? I can't
narrow it hardware down since it is all generic UART.,

> What I am not clear on from this is
>
> - do you see it on both the ports (the bug that is)

No, each hardware only has one serial console port that has traffic,
and only one of the two symptom occur on one type of hardware. That is
hardware 1 ttyS0 has "too much work for irq", and hardware 2 ttyS0 has
console freeze under a separate test. I group them together since they
occur using the same console flooding test script and under similar
RDI root cause.

> - if you do see it on both are you sure its not in reality a symptom of
>   some other console/irq handling race ?

It is racing. For "too much work for irq", here is sequence events
analyzed by a Motorola engineer:

        1) Data arrives in the FIFO, but not enough to cause an
interrupt
        2) The transmitter is started.
        3) A transmit needs data interrupt occurs (0xC2 in the
IIR)
        4) The processing function is called and it reads the
LSR
        5) The LSR indicates that the transmitter needs data,
but also indicates the presence of data in the FIFO (0x61 in the LSR)
        6) The processing function receives the characters, and
outputs data to the FIFO
        7) At the exact time (very very small window) that the
character is read from the FIFO, the FIFO timeout occurs locking in an
interrupt cause
        8) The next loop through the interrupt code begins
        9) The IIR now indicates the data timeout interrupt
(0xCC in the IIR)
        10) The processing function is called and it reads the
LSR
        11) The LSR is 0 indicating nothing to do
        12) The interrupt loop continues (the IIR won't clear
until a character is pulled) until it reaches its max count and
displays the error.

The other console freeze symptom is caused by similar sequence. The
last interrupt before interrupt stops always shows IIR=0xC2 and
LSR=0x21, which means has transmit interrupt but both transmit and
receive status.

After interrupt stops, i insmod a module to force read: IIR=0xC6,
IER=0x0F, still no interrupt. Then I read LSR=0xE3., which is what the
next interrupt would have done, makes interrupt resume again. Instead
of force reading LSR, I can also resume interrupt by forcing a printk,
which triggers a new transmit interrupt that reads LSR anyway.

>
> Alan
