Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab2ILHEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:04:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55780 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2ILHEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:04:31 -0400
Date: Wed, 12 Sep 2012 00:01:54 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Colin Cross <ccross@android.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [RFC] tty/serial/kgdboc: Add and wire up clear_irqs callback
Message-ID: <20120912070154.GA8932@lizard>
References: <20120911093042.GA12471@lizard>
 <1347356106-25368-6-git-send-email-anton.vorontsov@linaro.org>
 <20120911151540.362001c6@pyramind.ukuu.org.uk>
 <20120912033209.GA32156@lizard>
 <CAMbhsRTmZyxFE-vAa-UvNE8KJ2f0cfXP7mncXKcpUiNF6C9PUQ@mail.gmail.com>
 <20120912040657.GA3880@lizard>
 <CAMbhsRT+JR9-qzADiPXo9e59oHFCY4g6HNObKNMeciC5Xj6m6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMbhsRT+JR9-qzADiPXo9e59oHFCY4g6HNObKNMeciC5Xj6m6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 09:40:35PM -0700, Colin Cross wrote:
[..]
> >> the polling rx function should clear the interrupt
> >> for you.
> >
> > Yes, that's an option. But that way we add a new semantic for the
> > polling routines, and effecitvely we just merge the two callbacks.
> >
> > Of course, if Alan is OK with this, I'm more than OK too. :-)
> >
> > (But the polling routines would need to clear all interrupts, not
> > just rx/tx. For example, if the controller indicated some error, and
> > nobody clears it, then we'll start reentering infinitely.)
> 
> For exynos5, the only non-8250 based serial port I've come across, we
> clear all interrupts in the rx poll function (see
> https://android.googlesource.com/kernel/exynos/+/ef427aafffb7153dde59745e440fd7ec41ea969d/arch/arm/mach-exynos/exynos_fiq_debugger.c).

Yes, but if you'd like to merge your code, some might ask you: why?

You'd answer that you need to clear the interrupts, otherwise you'll
keep reentering NMI. The next that you might get is this: "this does
not belong to the getc callback, it's better to factor it out". :-) And
here comes clear_irq() (or alike, see below).

> >> If you use a clear_irqs callback, you can drop characters if
> >> one arrives between the last character buffer read and calling
> >> clear_irqs.
> >
> > Only if we call clear_irqs() after reading the characters, but we do
> > it before. So if new characters are available, we will reenter NMI,
> > which is OK.
> >
> > But if used incorrectly, it truly can cause dropping (or staling) of
> > characters, so I'd better add some comments about this.
> 
> What does clear_irqs() mean for a status or tx interrupt?  The tx
> interrupt will generally re-assert as long as the tx fifo is empty,
> which would require disabling it.

Yup, and that's exactly what we do: http://lkml.org/lkml/2012/9/11/119

Your words made me think that clear_irq() might be indeed a somewhat
inappropriate name. We have to be even stricter on its definition and
behaviour.

So, returning to your question "What does clear_irqs() mean", I'd
answer that: the function must do whatever needed to lower the IRQ
line, plus the function must leave the port in the state that it's
still able to throw RX interrupts after the call.

So, the 100% proper name for this function would be this:

	quiesce_irqs_but_rx()

It's a bit long, but does exactly what the name states.

Thanks!
Anton.
