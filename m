Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab2ILKem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:34:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42422 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab2ILKek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:34:40 -0400
Date: Wed, 12 Sep 2012 03:32:05 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Colin Cross <ccross@android.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [RFC] tty/serial/kgdboc: Add and wire up clear_irqs callback
Message-ID: <20120912103202.GA26690@lizard>
References: <20120911093042.GA12471@lizard>
 <1347356106-25368-6-git-send-email-anton.vorontsov@linaro.org>
 <20120911151540.362001c6@pyramind.ukuu.org.uk>
 <20120912033209.GA32156@lizard>
 <CAMbhsRTmZyxFE-vAa-UvNE8KJ2f0cfXP7mncXKcpUiNF6C9PUQ@mail.gmail.com>
 <20120912040657.GA3880@lizard>
 <20120912104420.06a88957@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120912104420.06a88957@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 10:44:20AM +0100, Alan Cox wrote:
> > Of course, if Alan is OK with this, I'm more than OK too. :-)
> 
> It may well be better.
> 
> > (But the polling routines would need to clear all interrupts, not
> > just rx/tx. For example, if the controller indicated some error, and
> > nobody clears it, then we'll start reentering infinitely.)
> 
> For a lot of devices and platforms you'd probably mask them instead ?

If there is no way to clear them, yes, we obviously would want to
mask them before using the port for NMI debugger. Then we'd need
three callbacks:

- mask_all_irqs_but_rx() -- used before we want to start using the port
  for the NMI debugger;
- clear_rx_irq() -- (optional) clears rx IRQ for controllers that need
  it;
- restore_irqs() -- unmasks interrupts that were previously masked.

If we ever encounter a case when just clearing interrupts doesn't work,
we can surely implement the above scheme... It's just so far I don't
see any need to over-design this, but again, it's your call, I told my
opinion on this, but I'll do whatever you guys like more. :-)

> > > If you use a clear_irqs callback, you can drop characters if
> > > one arrives between the last character buffer read and calling
> > > clear_irqs.
> > 
> > Only if we call clear_irqs() after reading the characters, but we do
> > it before. So if new characters are available, we will reenter NMI,
> > which is OK.
> 
> Recursively or not... again you get platform specific magic in places
> we don't want.

I really really don't see how this is platform-specific. All we ask the
serial driver is to quiesce its interrupt. Whether we can handle
NMIs/IRQs recursively or not is not serial driver's worry, since its
IRQ handler is not going to fire anyway. The polling routines already
gave us the power to steal/inject the data, so now we're stealing the
interrupt too.

How we use the callback is indeed platform-specific, but so is the
whole KGDB, and that knowledge is hidden there.

For serial driver it's all pretty much clear: lower the interrupt, but
don't turn off rx detection.

Thanks!

Anton.
