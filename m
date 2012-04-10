Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab2DJKLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:11:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53975 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab2DJKLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:11:04 -0400
Date: Tue, 10 Apr 2012 11:10:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Sven Neumann <s.neumann@raumfeld.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
        linux-input@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Input: eeti_ts: Mark as CONFIG_BROKEN
Message-ID: <20120410101047.GQ24211@n2100.arm.linux.org.uk>
References: <1333777207-4151-1-git-send-email-olof@lixom.net> <20120407070206.GA17623@core.coreip.homeip.net> <4F8089A9.6080704@raumfeld.com> <CAOesGMiPZ0so-ZN0HCHHhw16oPWWgfVD5t--wKSvEUtzQx94CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMiPZ0so-ZN0HCHHhw16oPWWgfVD5t--wKSvEUtzQx94CA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2012 at 01:32:31PM -0700, Olof Johansson wrote:
> Haojian, I think it was probably premature to do the multiplatform
> change like that, since it means that a PXA-only kernel has no mapping
> from irq_to_gpio to pxa_irq_to_gpio. Can you please address this as a
> fix for 3.4?

Please fix ezx-pcap instead - it's broken as it currently stands by using
irq_to_gpio(), and it's one reason why my randconfig builds on OMAP fail.

The big problem is - what does this do:

        do {
...
        } while (gpio_get_value(irq_to_gpio(pcap->spi->irq)));

if pcap->spi->irq has no GPIO associated with the interrupt?  irq_to_gpio()
probably returns some random number which might be some other GPIO in the
system, and gpio_get_value() could oops if irq_to_gpio returns a negative
or large positive number.  To put it another way, according to the above
code, irq_to_gpio() must always return a valid gpio for the IRQ even if
the IRQ doesn't have a GPIO associated with it.

This is a fine illustration of why irq_to_gpio() is just plain broken in
its design.
