Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab1ECWEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:04:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45744 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1ECWEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:04:13 -0400
Date: Tue, 3 May 2011 23:04:08 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Jamie Iles <jamie@jamieiles.com>,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110503220408.GA6978@pulham.picochip.com>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <20110503210950.GA2866@ponder.secretlab.ca>
 <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
 <20110503215211.GA8491@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110503215211.GA8491@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 01:52:11AM +0400, Anton Vorontsov wrote:
> On Tue, May 03, 2011 at 03:13:20PM -0600, Grant Likely wrote:
> > > struct gpio_mmio_generic {
> > >        spinlock_t      lock;
> > >
> > >        /* initialized by user */
> > >        unsigned long   reg_data;
> > >        unsigned long   reg_set;
> > >        unsigned long   reg_clr;
> > >        unsigned long   reg_dir;
> > >
> > >        void __iomem    *reg_base;
> 
> This assumes that all reg_* will be mapped with a single ioremap().
> My solution (see below) doesn't have this issue.
> 
> > > void gpio_mmio_generic_setup(struct gpio_mmio_generic *gmg, int register_width);
> > > int gpio_mmio_generic_add(struct gpio_mmio_generic *gmg);
> > > void gpio_mmio_generic_remove(struct gpio_mmio_generic *gmg);
> 
> I'm not sure you need that complex API.
> 
> > > gpio_mmio_generic_setup() sets up the common callback ops in the
> > > embedded gpio_chip, but the decisions it makes could be overridden by
> > > the user before calling gpio_mmio_generic_add().
> > >
> > > I've not had time to prototype this yet, but I wanted to get it
> > > written down and out onto the list for feedback since I probably won't
> > > have any chance to get to it until after UDS.  Bonus points to anyone
> > > who wants to take the initiative to hack it together before I get to
> > > it.  Extra bonus points to anyone who also converts some of the other
> > > gpio controllers to use it.  :-D
> > 
> > And triple bonus points to anyone who thinks this is stupid and comes
> > up with a better approach.  :-)
> 
> This isn't stupid. And I started working on this, so what about
> http://lkml.org/lkml/2011/4/19/401 ? This is pretty much the same
> that you propose.

The advantage that Grant's proposal has though is that the user can 
override the gpio_chip callbacks.  When I tried porting over some 
existing ARM platforms, one of the blocking issues was that lots of 
platforms had some annoying small detail that was slightly different 
(such as doing muxing in the _get() callback or needing a to_irq 
callback).

If we make bgpio_chip public and return that from bgpio_probe 
unregistered then the calling code can override some of the methods then 
register the gpio_chip.

As a slight aside, if we don't want a platform_device per bank for 
devices with multiple banks then I don't think the named resource 
approach will work (at least I can't see a particularly nice mechanism).  
Any ideas?

Jamie
