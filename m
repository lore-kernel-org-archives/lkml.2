Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1KYPf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 10:35:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45002 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1KYPf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 10:35:57 -0500
Date: Fri, 25 Nov 2011 15:35:53 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Jamie Iles <jamie@jamieiles.com>, Rob Herring <robherring2@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] irq: fix possible null-pointer deref irq_domain_to_irq
Message-ID: <20111125153553.GB8866@totoro>
References: <1320922383-15312-1-git-send-email-jamie@jamieiles.com>
 <20111110111446.GB16018@totoro>
 <4EBBD39C.9000400@gmail.com>
 <20111123122308.GA7382@totoro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123122308.GA7382@totoro>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Wed, Nov 23, 2011 at 12:23:08PM +0000, Jamie Iles wrote:
> On Thu, Nov 10, 2011 at 07:37:32AM -0600, Rob Herring wrote:
> > On 11/10/2011 05:14 AM, Jamie Iles wrote:
> > > On Thu, Nov 10, 2011 at 10:53:03AM +0000, Jamie Iles wrote:
> > >> It is optional for an irqdomain to have a to_irq() method, and for
> > >> simple domains they often don't require any operations at all - just
> > >> hwirq to Linux irq translation.  Check we have valid ops before
> > >> dereferencing them.
> > >>
> > >> Patch originally by Rob Herring.
> > >>
> > >> Suggested-by: Rob Herring <robherring2@gmail.com>
> > > 
> > > Naturally git send-email doesn't know how to convert this into a CC, so 
> > > Rob is now CC'd!
> > > 
> > > Jamie
> > > 
> > >> Cc: Thomas Gleixner <tglx@linutronix.de>
> > >> Cc: Grant Likely <grant.likely@secretlab.ca>
> > >> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> > >> ---
> > >>
> > >> Rob, I can't see that you've already posted this but I didn't want to
> > >> hold Marc's GIC patches up.
> > 
> > Thanks. I didn't get around to it yesterday.
> > 
> > Acked-by: Rob Herring <rob.herring@calxeda.com>
> 
> I've just noticed in kernel/irq/irqdomain.c, that the kerneldoc for 
> irq_domain_add() says that a valid ops structure is required, so perhaps 
> this fix isn't right and we should just have an empty ops structure for 
> simple controllers...

I wonder if this might make more sense instead.  I'll post a proper 
patch if you think so.

Regards,

Jamie

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 200ce83..92c3484 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -143,11 +143,6 @@ int irq_domain_simple_dt_translate(struct irq_domain *d,
 	return 0;
 }
 
-struct irq_domain_ops irq_domain_simple_ops = {
-	.dt_translate = irq_domain_simple_dt_translate,
-};
-EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
-
 /**
  * irq_domain_create_simple() - Set up a 'simple' translation range
  */
@@ -181,4 +176,11 @@ void irq_domain_generate_simple(const struct of_device_id *match,
 		pr_info("no node found\n");
 }
 EXPORT_SYMBOL_GPL(irq_domain_generate_simple);
+#else /* CONFIG_OF_IRQ */
+#define irq_domain_simple_dt_translate NULL
 #endif /* CONFIG_OF_IRQ */
+
+struct irq_domain_ops irq_domain_simple_ops = {
+	.dt_translate = irq_domain_simple_dt_translate,
+};
+EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
