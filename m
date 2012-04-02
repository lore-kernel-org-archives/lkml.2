Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2DBV1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:27:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:51640 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2DBV1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:27:45 -0400
Date: Mon, 2 Apr 2012 23:27:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Andreas Schwab <schwab@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use
 irq_alloc_desc() instead
In-Reply-To: <1333401600.30734.56.camel@pasglop>
Message-ID: <alpine.LFD.2.02.1204022324140.2542@ionos>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>  <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>  <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>  <alpine.LFD.2.02.1204022251420.2542@ionos>
 <1333401600.30734.56.camel@pasglop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012, Benjamin Herrenschmidt wrote:

> On Mon, 2012-04-02 at 22:52 +0200, Thomas Gleixner wrote:
> > > When I revert a09b659cd68c10ec6a30cb91ebd2c327fcd5bfe5 ("genirq: Fix
> > > long-term regression in genirq irq_set_irq_type() handling") on top
> > of
> > > 3.4-rc1 the sata irq errors disappear, but I see a lot of spurious
> > 
> > Hmm. Which irq chip is handling the interrupt for that sata irq ?
> 
> MPIC. The irq is a PCI IRQ, and so should be level-low, it should have
> been mapped by the PCI code using the of_* calls.

So it's covered by this section:

mpic_set_irq_type()

        if (flow_type == IRQ_TYPE_NONE)
                if (mpic->senses && src < mpic->senses_count)
                        flow_type = mpic->senses[src];
        if (flow_type == IRQ_TYPE_NONE)
                flow_type = IRQ_TYPE_LEVEL_LOW;

And with IRQ_TYPE_NONE this is always going to end up with
IRQ_TYPE_LEVEL_LOW simply because the only function which might set
mpic->senses is mpic_set_default_senses(). And this function does not
have a single caller .....

/me scratches head
