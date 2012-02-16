Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab2BPFcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:32:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47839 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2BPFcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:32:46 -0500
Date: Wed, 15 Feb 2012 22:32:43 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 24/25] irq_domain: remove "hint" when allocating irq
 numbers
Message-ID: <20120216053243.GM25779@ponder.secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <1327700179-17454-25-git-send-email-grant.likely@secretlab.ca>
 <4F316848.4060100@atmel.com>
 <4F3BC97C.6030203@atmel.com>
 <20120215202145.GH25779@ponder.secretlab.ca>
 <20120215215001.GA30946@r65073-Latitude-D630>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215215001.GA30946@r65073-Latitude-D630>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 01:50:02PM -0800, Shawn Guo wrote:
> On Wed, Feb 15, 2012 at 01:21:45PM -0700, Grant Likely wrote:
> > On Wed, Feb 15, 2012 at 04:04:28PM +0100, Nicolas Ferre wrote:
> > > On 02/07/2012 07:07 PM, Nicolas Ferre :
> > > > On 01/27/2012 10:36 PM, Grant Likely :
> > > >> The 'hint' used to try and line up irq numbers with hw irq numbers is
> > > >> rather a hack and not very useful.  Now that /proc/interrupts also outputs
> > > >> the hwirq number, it is even less useful to keep around the 'hint' heuristic.
> > > >>
> > > >> This patch removes it.
> > > > 
> > > > Grant,
> > > > 
> > > > While trying your patch series in conjunction with Rob one, I do not
> > > > find this patch in your irqdomain/next branch (and a couple of others).
> > > > Can you tell me if this v3 series is available as a git tree?
> > > 
> > > I am still interested by patch 24-25 of this series but still cannot
> > > find them in your irqdomain/next branch:
> > > Are they also expected to join the 3.4 merge window material?
> > 
> > I've held off on putting them in irqdomain/next because they are a bit more
> > risky than the other patches, and I want an explicit ack from Ben for patches
> > 24 & 25.  However, that shouldn't really cause any issues since the changes
> > in 24 & 25 don't impact the irq_domain functionality or API.  They are just
> > optimizations.
> > 
> I'm seeing that patch 24 does impact on irq_domain functionality
> a little bit.  On next tree which has no this patch yet,
> irq_create_mapping can reasonably create virq in range 1..15, while
> irq_find_mapping will only try to find the virq from 16
> (NUM_ISA_INTERRUPTS).  This will result in that any hwirq that is < 16
> gets multiple entries in the mapping table with different virq numbers
> mapped to the same one hwirq.

That's a bug then.  The implementation should work without patch 24.  Does
this patch fix it?

---

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 2c1d6f8..2d3dfff 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -516,8 +516,8 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 		return irq_domain_legacy_revmap(domain, hwirq);
 
 	/* Slow path does a linear search of the map */
-	if (hint < NUM_ISA_INTERRUPTS)
-		hint = NUM_ISA_INTERRUPTS;
+	if (hint == 0)
+		hint = 1;
 	i = hint;
 	do {
 		struct irq_data *data = irq_get_irq_data(i);
@@ -525,7 +525,7 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 			return i;
 		i++;
 		if (i >= irq_virq_count)
-			i = NUM_ISA_INTERRUPTS;
+			i = 1
 	} while(i != hint);
 	return 0;
 }

