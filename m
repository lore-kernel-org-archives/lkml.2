Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab0JQKoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:44:20 -0400
Received: from www.tglx.de ([62.245.132.106]:35336 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab0JQKoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:44:19 -0400
Date: Sun, 17 Oct 2010 12:44:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Arthur Kepner <akepner@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC/PATCHv2] x86/irq: round-robin distribution of irqs to cpus
 w/in node
In-Reply-To: <m1eicennfu.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1010171201410.2496@localhost6.localdomain6>
References: <20100927203448.GC30050@sgi.com> <alpine.LFD.2.00.1009272236430.2416@localhost6.localdomain6> <20100927220113.GD30050@sgi.com> <alpine.LFD.2.00.1009280003300.2416@localhost6.localdomain6> <m1hbhalo1o.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1009280957150.2416@localhost6.localdomain6> <m1eicennfu.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On Tue, 28 Sep 2010, Eric W. Biederman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> >> My gut feel says that the real answer is to delay assigning a vector
> >> to an irq until request_irq().  At which point we will know that someone
> >> at least wants to use the irq.

Looked a bit deeper into the users. Quite a bunch do

       pci_enable_msix();
       request_irqs();

in their probe function. There is no sign of making them per cpu or
node. mlx4 is one of them. No sign of anything related to nodes or cpus in
the whole driver.

Even if the driver does not request the irqs from the probe function,
why does it need to do the msi/msix setup in the probe function at
all?

Wouldn't it be sufficient to do that at open() right before the
interrupts are requested.

> > Right. So the solution would be:
> >
> > create_irq allocates an irq number + irq descriptor, nothing else
> >
> > chip->startup() will setup the vector and chip->shutdown releases
> > it. That requires to change the return value of chip->startup to int,
> > so we can return an error code, but that can be done in course of the
> > overhaul I'm working on. 
> >
> > Right now I prefer not to add more crap to io_apic.c, it's horrible
> > enough already. I'll fix that with the cleanup.
> 
> Understood.  It has taken a couple of years before this bug finally
> bit anyone waiting a release or two to get it fixed properly seems
> reasonable.

That needs some real work on drivers :)

> pci_enable_msix all in it's own way is fixable, but it has
> few enough callers < 80 that it is also fixable.

The fundamental flaw of arch_setup_msi_irqs() is 

  node = dev_to_node(&dev->dev);

That's the only node information we get. So we put everything on a
single node.

What we really need is a node entry in struct msi_desc, which gets
assigned from struct msix_entry in msix_setup_entries().

Thoughts ?

	 tglx
