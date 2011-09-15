Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935495Ab1IOXl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:41:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:47581 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935248Ab1IOXl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:41:58 -0400
Date: Fri, 16 Sep 2011 01:41:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id
 interrupts
In-Reply-To: <20110915232903.GA22533@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1109160137130.2723@ionos>
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com> <1316105551-17505-2-git-send-email-marc.zyngier@arm.com> <alpine.LFD.2.02.1109152207010.2723@ionos> <20110915232903.GA22533@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011, Russell King - ARM Linux wrote:

> On Fri, Sep 16, 2011 at 12:49:10AM +0200, Thomas Gleixner wrote:
> > Marc,
> > 
> > On Thu, 15 Sep 2011, Marc Zyngier wrote:
> > > +
> > > +	raw_spin_unlock_irqrestore(&desc->lock, flags);
> > > +
> > > +	unregister_handler_proc(irq, action);
> > > +
> > > +	/* Make sure it's not being used on another CPU: */
> > > +	synchronize_irq(irq);
> > 
> > That's not helping w/o making synchronize_irq() aware of the percpu
> > stuff. Also there is the question whether we need the ability to
> > remove such interrupts in the first place. The target users are low
> > level arch interrupts not some random device drivers.
> 
> You do - think local timers which go away on hotunplug and come back
> on hotplug.  The alternative is requiring every local timer code to
> remember whether it registered its per-cpu handler on each CPU or not,
> and that just gets more messy than having them unregister on hotunplug.
> Not only would that be more prone to bugs but it will also mean extra
> complexity in arch code.

Yikes! That code is removing the GLOBAL action, so all users are going
to hell.

The point of the percpu_irq stuff is to have a single action with a
percpu dev_id and a per cpu enable/disable. So when you unplug your
cpu that very cpu calls the disable function and therefor removes
itself w/o causing the other cpus to die on action = NULL

Thanks,

	tglx


 
