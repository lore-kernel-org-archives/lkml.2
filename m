Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2BEQOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 11:14:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42334 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2BEQOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 11:14:18 -0500
Date: Sun, 5 Feb 2012 16:13:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 00/25] irq_domain generalization and refinement
Message-ID: <20120205161348.GZ889@n2100.arm.linux.org.uk>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca> <20120204221748.GN14129@n2100.arm.linux.org.uk> <20120204223125.GO14129@n2100.arm.linux.org.uk> <20120205013853.GQ20333@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120205013853.GQ20333@atomide.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 05:38:53PM -0800, Tony Lindgren wrote:
> * Russell King - ARM Linux <linux@arm.linux.org.uk> [120204 14:00]:
> > 
> > Actually, it turns out to be not that hard, because twl doesn't actually
> > make use of the IRQ domain stuff:
> > 
> > commit aeb5032b3f8b9ab69daa545777433fa94b3494c4
> > Author:     Benoit Cousson <b-cousson@ti.com>
> > AuthorDate: Mon Aug 29 16:20:23 2011 +0200
> > Commit:     Samuel Ortiz <sameo@linux.intel.com>
> > CommitDate: Mon Jan 9 00:37:40 2012 +0100
> > 
> >     mfd: twl-core: Add initial DT support for twl4030/twl6030
> > 
> >     [grant.likely@secretlab.ca: Fix IRQ_DOMAIN dependency in kconfig]
> > 
> > Adding any dependency - especially one which wouldn't be enabled - for
> > a new feature which wasn't required before is going to break existing
> > users, so this shouldn't have been done in the first place.
> > 
> > A better fix to preserve existing users would've been as below - yes
> > it means more ifdefs, but if irq domain is to remain a DT only thing
> > then we're going to end up with _lots_ of this stuff.
> > 
> > I'd much prefer to see irq domain become more widely available so it
> > doesn't require these ifdefs everywhere.
> 
> Your patch below looks like a correct fix to me to the problem
> you and Grazvydas are seeing:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

It's not quite correct, because OMAP4 has issues in this area as well
(which does select IRQ_DOMAIN but can be without OF.)  The result is
an oops from irq_domain_add() because domain->ops is NULL.

The right solution is three fold:

1. Wrap the bits of code in CONFIG_IRQ_DOMAIN
2. Get rid of the #ifdef CONFIG_OF there, so the 'ops' member can be
   initialized.
3. Fix the OMAP vp code not to oops when voltdm->pmic is NULL

which I have in my combined patch for fixing OMAP so far.
