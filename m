Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0I1IJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:09:09 -0400
Received: from www.tglx.de ([62.245.132.106]:56164 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab0I1IJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:09:07 -0400
Date: Tue, 28 Sep 2010 10:08:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Arthur Kepner <akepner@sgi.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [RFC/PATCHv2] x86/irq: round-robin distribution of irqs to cpus
 w/in node
In-Reply-To: <m1hbhalo1o.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1009280957150.2416@localhost6.localdomain6>
References: <20100927203448.GC30050@sgi.com> <alpine.LFD.2.00.1009272236430.2416@localhost6.localdomain6> <20100927220113.GD30050@sgi.com> <alpine.LFD.2.00.1009280003300.2416@localhost6.localdomain6> <m1hbhalo1o.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010, Eric W. Biederman wrote:
> > On Mon, 27 Sep 2010, Arthur Kepner wrote:
> The deep bug is that create_irq_nr allocates a vector (which it does
> because at the time there was no better way to mark an irq in use on
> x86).  In the case of msi-x we really don't know the node that irq is
> going to be used on until we get a request irq.  We simply know which
> node the device is on.

Bah. So the whole per node allocation business is completely useless
at this point.

> If you want to see what is going follow the call trace looks like.
> pci_enable_msix 
>   arch_setup_msi_irqs
>     create_irq_nr
> 
> After pci_enable_msix is finished then the driver goes and makes all
> of the irqs per cpu irqs.
> 
> There are goofy things that happen when hardware asks for 1 irq per cpu.
> But since msi can ask for up to 4096 irqs (assuming the hardware
> supports it) I can totally see putting all 256 of those irqs on a single
> cpu, before you go to user space and let user space or something
> reassign all of those irqs in a per cpu way.
> 
> My gut feel says that the real answer is to delay assigning a vector
> to an irq until request_irq().  At which point we will know that someone
> at least wants to use the irq.

Right. So the solution would be:

create_irq allocates an irq number + irq descriptor, nothing else

chip->startup() will setup the vector and chip->shutdown releases
it. That requires to change the return value of chip->startup to int,
so we can return an error code, but that can be done in course of the
overhaul I'm working on. 

Right now I prefer not to add more crap to io_apic.c, it's horrible
enough already. I'll fix that with the cleanup.

Thanks

	tglx


