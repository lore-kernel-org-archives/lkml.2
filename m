Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0I2RTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:19:46 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49528 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754560Ab0I2RTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:19:45 -0400
Date: Wed, 29 Sep 2010 10:19:41 -0700
From: Arthur Kepner <akepner@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [RFC/PATCHv2] x86/irq: round-robin distribution of irqs to
	cpus w/in node
Message-ID: <20100929171941.GH3096@sgi.com>
References: <20100927203448.GC30050@sgi.com> <alpine.LFD.2.00.1009272236430.2416@localhost6.localdomain6> <20100927220113.GD30050@sgi.com> <alpine.LFD.2.00.1009280003300.2416@localhost6.localdomain6> <m1hbhalo1o.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1009280957150.2416@localhost6.localdomain6> <m1eicennfu.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1eicennfu.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Compendium reply to 2 emails.)

On Mon, Sep 27, 2010 at 05:17:07PM -0700, Eric W. Biederman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > On Mon, 27 Sep 2010, Arthur Kepner wrote:
> >
> ......
> The deep bug is that create_irq_nr allocates a vector (which it does
> because at the time there was no better way to mark an irq in use on
> x86).  In the case of msi-x we really don't know the node that irq is
> going to be used on until we get a request irq.  We simply know which
> node the device is on.
> 
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

Yes, that's exactly the problem. All of the vectors on the lowest 
numbered CPUs get used. Any subsequent request for an interrupt on 
one of the low numbered CPUs will fail.

> .....

On Tue, Sep 28, 2010 at 03:59:33AM -0700, Eric W. Biederman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > On Mon, 27 Sep 2010, Eric W. Biederman wrote:
> >> > On Mon, 27 Sep 2010, Arthur Kepner wrote:
> >> The deep bug is that create_irq_nr allocates a vector (which it does
> >> because at the time there was no better way to mark an irq in use on
> >> x86).  In the case of msi-x we really don't know the node that irq is
> >> going to be used on until we get a request irq.  We simply know which
> >> node the device is on.
> >
> > Bah. So the whole per node allocation business is completely useless
> > at this point.
> 
> Probably.

Huh? No, the patch that started this thread spreads the irqs around 
and avoids the problem of a single CPU's vectors all being consumed.

> ...
> 
> Understood.  It has taken a couple of years before this bug finally
> bit anyone waiting a release or two to get it fixed properly seems
> reasonable.
> ....

And so what are we to do in the meantime? At the moment we're 
disabling MSIX, which is a pretty unattractive workaround.

-- 
Arthur
