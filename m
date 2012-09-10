Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab2IJUPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:15:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34829 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2IJUPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:15:47 -0400
Date: Mon, 10 Sep 2012 13:13:13 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH 08/14] tty/serial/kgdboc: Add and wire up clear_irqs
 callback
Message-ID: <20120910201313.GA31746@lizard>
References: <20120910040802.GA1261@lizard>
 <20120910041357.GH29537@lizard>
 <20120910121624.226c1a88@pyramind.ukuu.org.uk>
 <20120910175704.GA11392@lizard>
 <20120910201918.1e3c8fd0@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120910201918.1e3c8fd0@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 08:19:18PM +0100, Alan Cox wrote:
> On Mon, 10 Sep 2012 10:57:04 -0700
> Anton Vorontsov <anton.vorontsov@linaro.org> wrote:
> 
> > On Mon, Sep 10, 2012 at 12:16:24PM +0100, Alan Cox wrote:
> > > > serial port, the CPU receives NMI exception, and we fall into KDB
> > > > shell.  So, it is our "debug console", and it is able to interrupt
> > > > (and thus debug) even IRQ handlers themselves.
> > > 
> > > You seem to have an assumption of single core here. What happens if
> > > the NMI hits CPU #0 and the serial IRQ hits CPU #1 simultaneously ?
> > 
> > If you can't redirect all serial IRQs to NMI context, e.g. sometimes you get
> > NMIs, sometimes IRQs, then your NMI handling is not deterministic, and surely
> > this is not supported.
> 
> This seems like arch specific magic leaking into the tty code. Surely
> this should be buried in the depths of the platform IRQ code ?

I'd not call this arch-specific. It's task-specific, and the task is quite
peculiar, true, but still nothing to do with arch.

If the arch is not able to turn serial IRQs into NMIs, then surely that arch is
not able to implement serial-triggered NMI/KDB-shell, so we don't support that
arch.

And we don't have any other way to accoplish the same: we need to clear the
serial interrupts, not some arch-specific interrupts. It is the serial device
that causes NMI, not some arch's magic. So we just provide the knob to manage
the device's functionality.

We do have a separate arch-specific NMI-masking knob that works at CPU level,
but if we mask NMI source at CPU level, we have to keep it always masked,
otherwise we'll keep reentering NMI. So, we really have to clear serial's
interrupt line.

That's why I came with clear_irqs callback, it has defined semantics for the
serial driver, and zero knowledge about any underlaying architecture or task.

Thanks,

Anton.
