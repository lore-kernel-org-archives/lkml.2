Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750852Ab2ILEJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 00:09:41 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40372 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2ILEJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 00:09:38 -0400
Date: Tue, 11 Sep 2012 21:06:57 -0700
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
Message-ID: <20120912040657.GA3880@lizard>
References: <20120911093042.GA12471@lizard>
 <1347356106-25368-6-git-send-email-anton.vorontsov@linaro.org>
 <20120911151540.362001c6@pyramind.ukuu.org.uk>
 <20120912033209.GA32156@lizard>
 <CAMbhsRTmZyxFE-vAa-UvNE8KJ2f0cfXP7mncXKcpUiNF6C9PUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMbhsRTmZyxFE-vAa-UvNE8KJ2f0cfXP7mncXKcpUiNF6C9PUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 08:42:46PM -0700, Colin Cross wrote:
[...]
> > The "problem" is in the last step. If we exit NMI without making UART
> > know that we're done with the interrupt, we will reenter the NMI
> > immediately, even without any new characters from the UART.
> 
> The UART irq line should go low when you read the character out of the

Probably some controllers may lower the line by themselves, but not
all, and probably most of them need an explicit clear.

> receive buffer, or the polling rx function should clear the interrupt
> for you.

Yes, that's an option. But that way we add a new semantic for the
polling routines, and effecitvely we just merge the two callbacks.

Of course, if Alan is OK with this, I'm more than OK too. :-)

(But the polling routines would need to clear all interrupts, not
just rx/tx. For example, if the controller indicated some error, and
nobody clears it, then we'll start reentering infinitely.)

> If you use a clear_irqs callback, you can drop characters if
> one arrives between the last character buffer read and calling
> clear_irqs.

Only if we call clear_irqs() after reading the characters, but we do
it before. So if new characters are available, we will reenter NMI,
which is OK.

But if used incorrectly, it truly can cause dropping (or staling) of
characters, so I'd better add some comments about this.

Thanks!

Anton.
