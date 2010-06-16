Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab0FPVNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:13:44 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:26641 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752864Ab0FPVNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:13:41 -0400
Date: Wed, 16 Jun 2010 22:13:11 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Lothar Wa?mann <LW@KARO-electronics.de>
Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Kerr <jeremy.kerr@canonical.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100616211311.GA30005@fluff.org.uk>
References: <201006111557.12249.jeremy.kerr@canonical.com>
 <19473.61547.684572.647641@ipc1.ka-ro>
 <201006111718.47426.jeremy.kerr@canonical.com>
 <19474.172.742782.972629@ipc1.ka-ro>
 <20100611095839.GC10894@pengutronix.de>
 <19474.2817.333749.485028@ipc1.ka-ro>
 <1276319643.1962.181.camel@pasglop>
 <19477.52889.982995.407051@ipc1.ka-ro>
 <20100614064028.GA12159@pengutronix.de>
 <19477.53673.644128.558827@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19477.53673.644128.558827@ipc1.ka-ro>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 08:52:25AM +0200, Lothar Wa?mann wrote:
> Hi,
> 
> Uwe Kleine-K?nig writes:
> > Hello Lothar,
> > 
> > On Mon, Jun 14, 2010 at 08:39:21AM +0200, Lothar Wa?mann wrote:
> > > Hi,
> > > 
> > > Benjamin Herrenschmidt writes:
> > > > On Fri, 2010-06-11 at 12:08 +0200, Lothar Wa?mann wrote:
> > > > > Hi,
> > > > > 
> > > > > > > > > Using a mutex in clk_enable()/clk_disable() is a bad idea, since that
> > > > > > > > > makes it impossible to call those functions in interrupt context.
> > > > > > IMHO if a device generates an irq its clock should already be on.  This
> > > > > > way you don't need to enable or disable a clock in irq context.
> > > > > >  
> > > > > You may want to disable a clock in the IRQ handler. The VPU driver in
> > > > > the Freescale BSP for i.MX51 does exactly this.
> > > > > Anyway I don't see any reason for using a mutex here instead of
> > > > > spin_lock_irq_save() as all other implementations do.
> > > > 
> > > > Because you suddenly make it impossible to sleep inside enable/disable
> > >               ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > ???
> > > All implementations so far use spin_lock_irq_save()!
> > > 
> > > How would you be able to sleep with a mutex held?
> > > If you hold a lock you must not sleep, no matter what sort of lock it
> > > is.
> > That's wrong.  With a mutex hold you may sleep.
> > 
> OK, you're right. But still all other implementations (omap, mxc,
> davinci,...) use spin_lock_irqsave() to protect the enable/disable
> functions and don't seem to have any problem with this.
> Is there any reason to change this, or make it inconsistent
> for one arch?
> 
> And arch/arm/plat-s3c/clock.c has the following comment:
> |/* We originally used an mutex here, but some contexts (see resume)
> | * are calling functions such as clk_set_parent() with IRQs disabled
> | * causing an BUG to be triggered.
> | */
> |DEFINE_SPINLOCK(clocks_lock);

It entirely depends on what you are protecting, in some cases a mutex
is good enough for finding clocks, sometimes you may well end up with
the case you need to spin.

However, none of these clock implementations really thought through
all the subtleties of how it works. The s3c gets the clock naming
wrong (will be trying to sort that out soon).

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
