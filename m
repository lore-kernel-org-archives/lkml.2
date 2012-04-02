Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2DBVzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:55:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53094 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2DBVzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:55:51 -0400
Date: Mon, 2 Apr 2012 22:55:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use
	irq_alloc_desc() instead
Message-ID: <20120402215524.GM24211@n2100.arm.linux.org.uk>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca> <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home> <20120402202848.1EB833E02A7@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402202848.1EB833E02A7@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 02:28:48PM -0600, Grant Likely wrote:
> On Mon, 02 Apr 2012 18:29:15 +0200, Andreas Schwab <schwab@linux-m68k.org> wrote:
> > Andreas Schwab <schwab@linux-m68k.org> writes:
> > 
> > > Grant Likely <grant.likely@secretlab.ca> writes:
> > >
> > >> This patch drops the powerpc-specific irq_map table and replaces it with
> > >> directly using the irq_alloc_desc()/irq_free_desc() interfaces for allocating
> > >> and freeing irq_desc structures.
> > >
> > > This breaks irqs on PowerMac G5.  I see lost irq errors from the sata
> > > driver.
> > 
> > When I revert a09b659cd68c10ec6a30cb91ebd2c327fcd5bfe5 ("genirq: Fix
> > long-term regression in genirq irq_set_irq_type() handling") on top of
> > 3.4-rc1 the sata irq errors disappear, but I see a lot of spurious
> > interrupts.  Also the X server is broken somehow, though I don't know
> > whether that is related or a different bug.
> 
> That change is:
> 
> @@ -61,8 +61,7 @@ int irq_set_irq_type(unsigned int irq, unsigned int type)
>                 return -EINVAL;
>  
>         type &= IRQ_TYPE_SENSE_MASK;
> -       if (type != IRQ_TYPE_NONE)
> -               ret = __irq_set_trigger(desc, irq, type);
> +       ret = __irq_set_trigger(desc, irq, type);
>         irq_put_desc_busunlock(desc, flags);
>         return ret;
> 
> So presumably irq_set_irq_type() is getting called with type ==
> IRQ_TYPE_NONE.  From Russell's description, presumably that would mean
> the G5 sata driver isn't setting the correct type for the interrupt,
> but I have *no* idea how that intersects with the change removing the
> powerpc irq map.

Well, presumably someone is calling irq_set_irq_type() asking explicitly
for IRQ_TYPE_NONE.  The code will now (as it always used to before David's
change) do exactly what you ask this to: it will ask the type to be set
to none.

If you don't want to set the type to none, don't call the interface asking
for that to happen.
