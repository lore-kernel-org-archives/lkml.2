Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0L2Aih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 19:38:37 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:33402 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab0L2Aig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 19:38:36 -0500
Subject: Re: [RFC/PATCH 3/3] mfd: twl4030-irq: implement bus_*lock
From: Felipe Balbi <me@felipebalbi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101228235836.GA2609@opensource.wolfsonmicro.com>
References: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
	 <1293556459-28613-1-git-send-email-balbi@ti.com>
	 <1293556459-28613-4-git-send-email-balbi@ti.com>
	 <20101228235836.GA2609@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 02:38:28 +0200
Message-ID: <1293583108.1822.3.camel@eowin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2010-12-28 at 23:58 +0000, Mark Brown wrote:
> On Tue, Dec 28, 2010 at 07:14:19PM +0200, Felipe Balbi wrote:
> 
> > +static void twl4030_sih_bus_sync_unlock(unsigned int irq)
> > +{
> > +       struct sih_agent        *agent = get_irq_chip_data(irq);
> > +
> > +       mutex_unlock(&agent->irq_lock);
> > +}
> 
> I suspect you need to do some sort of sync with the hardware here - the
> _sync bit of the name comes from the fact that the mask and unmask stuff
> is still called with IRQs disabled and so can't touch and I2C chip, this
> is called after reenabling them give a chance for the updates done to
> be reflected in the hardware.  The implementation everyone else has done
> is to update a register cache in the other functions then write that
> out here before dropping the mutex.

now that I look at some gpio chips I see what you're saying, will update
that tomorrow. Thanks

> >  static struct irq_chip twl4030_sih_irq_chip = {
> >  	.name		= "twl4030",
> >  	.mask		= twl4030_sih_mask,
> >  	.unmask		= twl4030_sih_unmask,
> >  	.set_type	= twl4030_sih_set_type,
> > +	.bus_lock	= twl4030_sih_bus_lock,
> > +	.bus_sync_unlock = twl4030_sih_bus_sync_unlock,
> >  };
> 
> I just realised that this collides with the conversion to the irq_
> versions that has been done on the driver in -next by either myself or
> Lennart (we both submitted essentially the same patches and a couple of
> his went in) - that was a purely mechanical conversion that didn't
> address any of the issues this patch addresses but they're touching the
> same code.

no problem. This will actually only be able on 2.6.39 merge window
anyway, so I'll have plenty of time to rebase on 2.6.38 and get these
patches queued.

ps: sorry the mail change, out of the office.

-- 
balbi

