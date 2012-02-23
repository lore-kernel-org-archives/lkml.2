Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab2BWVjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:39:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58646 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2BWVjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:39:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.68.136.231 as permitted sender) smtp.mail=glikely@secretlab.ca
Date: Thu, 23 Feb 2012 14:39:04 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 22/25] irq_domain/x86: Convert x86 (embedded) to use
 common irq_domain
Message-ID: <20120223213904.GD25293@ponder.secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <1327700179-17454-23-git-send-email-grant.likely@secretlab.ca>
 <20120128164405.GA20763@linutronix.de>
 <20120130195842.GT28397@ponder.secretlab.ca>
 <20120201141705.GF9587@linutronix.de>
 <CACxGe6vZxWXUG-WJFWDaoH3+PYBGWOXb291_jn9TdjrSF=p_JQ@mail.gmail.com>
 <CACxGe6tQvBZBMynXbknWx1o1s5TPEN7rXrNOOAjC5F_dz9B51w@mail.gmail.com>
 <4F46AE07.2000105@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F46AE07.2000105@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 10:22:15PM +0100, Sebastian Andrzej Siewior wrote:
> On 02/23/2012 08:56 PM, Grant Likely wrote:
> >On Wed, Feb 1, 2012 at 11:06 AM, Grant Likely<grant.likely@secretlab.ca>  wrote:
> >>On Wed, Feb 1, 2012 at 7:17 AM, Sebastian Andrzej Siewior
> >><bigeasy@linutronix.de>  wrote:
> >>>* Grant Likely | 2012-01-30 12:58:42 [-0700]:
> >>>
> >>>>Ugh.  This isn't easy.  The legacy mapping really needs all the
> >>>
> >>>Feel free to merge this patch. I don't have the time to look at this now
> >>>so I take a look at the ioapic later.
> >>
> >>There's no rush here.  I can leave it as-is with IRQ_DOMAIN turned off
> >>for x86 for now.
> >
> >Turns out I have to enable IRQ_DOMAIN for x86 because the TI TWL4030
> >driver needs it.  I do need to apply this patch.  Until something
> >better can be implemented, can I change ioapic_add_ofnode() so that it
> >allocates all irq_descs immediately.  It's not ideal, but every other
> >approach I've looked at results in nasty hacks.
> >
> >Looking at the ioapic code, it appears to handle preallocated
> >irq_descs gracefully.
> 
> Please merge your initial patch as-it.

Okay, will do.

> >Does adding this loop help (apologies if it is whitespace damaged, I
> >cut&paste it):
> >
> >diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
> >index 3ae2ced..89c1310 100644
> >--- a/arch/x86/kernel/devicetree.c
> >+++ b/arch/x86/kernel/devicetree.c
> >@@ -345,7 +345,7 @@ const struct irq_domain_ops ioapic_irq_domain_ops = {
> >  static void __init ioapic_add_ofnode(struct device_node *np)
> >  {
> >  	struct resource r;
> >-	int i, ret;
> >+	int i, j, ret;
> >
> >  	ret = of_address_to_resource(np, 0,&r);
> >  	if (ret) {
> >@@ -361,6 +361,14 @@ static void __init ioapic_add_ofnode(struct
> >device_node *np)
> >
> >  			gsi_cfg = mp_ioapic_gsi_routing(i);
> >
> >+			/*
> >+			 * Preallocate irq_descs so that the legacy mapping
> >+			 * works, but don't set them up.
> >+			 * io_apic_setup_irq_pin_once() will finish the set up.
> >+			 */
> >+			for (j = 0; j<  32; j++)
> 
> It is not 32. If I remember correctly the first ioapic had 24 pins so
> did the second. This is ioapic specifc.

Is this better (bigger diffstat, but mostly due to renaming a local varable):

---

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 3ae2ced..4028dc6 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -345,7 +345,7 @@ const struct irq_domain_ops ioapic_irq_domain_ops = {
 static void __init ioapic_add_ofnode(struct device_node *np)
 {
 	struct resource r;
-	int i, ret;
+	int i, irq, ret;
 
 	ret = of_address_to_resource(np, 0, &r);
 	if (ret) {
@@ -357,13 +357,22 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 	for (i = 0; i < nr_ioapics; i++) {
 		if (r.start == mpc_ioapic_addr(i)) {
 			struct irq_domain *id;
-			struct mp_ioapic_gsi *gsi_cfg;
-
-			gsi_cfg = mp_ioapic_gsi_routing(i);
-
-			id = irq_domain_add_legacy(np, 32, gsi_cfg->gsi_base, 0,
-						   &ioapic_irq_domain_ops,
-						   (void*)i);
+			struct mp_ioapic_gsi *cfg;
+
+			cfg = mp_ioapic_gsi_routing(i);
+
+			/*
+			 * Preallocate irq_descs so that the legacy mapping
+			 * works, but don't set them up.
+			 * io_apic_setup_irq_pin_once() will finish the set up.
+			 */
+			for (irq = cfg->gsi_base; irq <= cfg->gsi_end; irq++)
+				irq_alloc_desc_at(irq, cpu_to_node(0));
+
+			id = irq_domain_add_legacy(np,
+					cfg->gsi_end - cfg->gsi_base + 1,
+					cfg->gsi_base, 0,
+					&ioapic_irq_domain_ops, (void*)i);
 			BUG_ON(!id);
 			return;
 		}
