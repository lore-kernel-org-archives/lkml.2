Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1EDABB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 20:01:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53610 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1EDAA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 20:00:59 -0400
Date: Tue, 3 May 2011 18:00:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, arnd@arndb.de,
        nico@fluxnic.net, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110504000055.GA4008@ponder.secretlab.ca>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <20110503210950.GA2866@ponder.secretlab.ca>
 <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
 <20110503215211.GA8491@oksana.dev.rtsoft.ru>
 <20110503220408.GA6978@pulham.picochip.com>
 <20110503223415.GA14024@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503223415.GA14024@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 02:34:15AM +0400, Anton Vorontsov wrote:
> On Tue, May 03, 2011 at 11:04:08PM +0100, Jamie Iles wrote:
> [...]
> > The advantage that Grant's proposal has though is that the user can 
> > override the gpio_chip callbacks.  When I tried porting over some 
> > existing ARM platforms, one of the blocking issues was that lots of 
> > platforms had some annoying small detail that was slightly different 
> > (such as doing muxing in the _get() callback or needing a to_irq 
> > callback).
> > 
> > If we make bgpio_chip public and return that from bgpio_probe 
> > unregistered then the calling code can override some of the methods then 
> > register the gpio_chip.
> 
> Oh, that makes sense, right.
> 
> > As a slight aside, if we don't want a platform_device per bank for 
> > devices with multiple banks then I don't think the named resource 
> > approach will work (at least I can't see a particularly nice mechanism).  
> > Any ideas?
> 
> I think Grant misunderstood Alan's words. If a PCI device registers
> platform devices to represent each of PCI device's banks -- that is not
> good. It's waste of devices, complicates sysfs/device heirarchy and so
> on. And that's why bgpio_probe() thing started, to not create platform
> devices when you already have one.

Actually, I did understand what Alan was suggesting.  If I gave the
impression that existing platform devices should be consolidated into
single devices, regardless of whether or not they were related, then
that was not my intent.

*however*, for devices that do implement a multi-function register
block, I do think it is better to have a single driver perform a
single ioremap and then register the N interfaces that use it against
a single device.  I certainly don't see this as a hard and fast rule,
but it is definitely my preference.

> 
> But personally I think it's OK for platforms (arch/ code) to register
> each bank as a separate device. In some cases, that describes hardware
> even better. And that makes life easier for device-tree stuff as well.

>From the device tree use-case, I personally still prefer a binding
that provides a single 'reg' entry for the register block and explicit
offsets in the binding to specify where/how the gpio registers are
layed out.  It just fits better with existing binding practices.

Also, if you're talking about a gpio device with, say, 128 gpios on an
soc, then the natural binding probably will be to have a single device
tree node covering all 4 banks because that is the way the
documentation lays out the device.  Perhaps something like this
(completely off the top of my head):

gpio@fedc0000 {
	compatible = "acme,super-soc-gpio", "mmio-gpio";
	reg = <0xfedc0000 0x100>;
	gpio-controller;
	#gpio-cells = <1>;

	mmgpio-regoffset-data = <0x00 0x04 0x08 0x0c>;
	mmgpio-regoffset-dir  = <0x20 0x24 0x28 0x2c>;
	mmgpio-regoffset-set  = <0x10 0x14 0x18 0x1c>;
	mmgpio-regoffset-clr  = <0x30 0x34 0x38 0x3c>;
};

... where an array of regoffset values allows for multiple banks.
Although this might be completely insane and it would be better to
make the kernel key directly off the 'acme,super-soc-gpio' value.

> And if you really don't want this behaviour for your platform, you can
> create your own driver that would use "bgpio library", and would
> register several banks for a single device (as in PCI case).

Exactly.

g.
