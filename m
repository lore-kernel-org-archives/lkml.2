Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1LFXQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 18:16:33 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53696 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab1LFXQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 18:16:32 -0500
Date: Wed, 7 Dec 2011 03:16:26 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rob Herring <robherring2@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jeff Garzik <jgarzik@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH v3] of/irq: Get rid of NO_IRQ usage
Message-ID: <20111206231626.GA31683@oksana.dev.rtsoft.ru>
References: <20111110151852.GA7465@oksana.dev.rtsoft.ru>
 <20111110152541.GA3207@oksana.dev.rtsoft.ru>
 <4EDE877A.4080708@gmail.com>
 <CA+55aFwGFogD4ROCH9m=c2jqB2axvrH-dnKPtA8kxXL9b3CVBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFwGFogD4ROCH9m=c2jqB2axvrH-dnKPtA8kxXL9b3CVBw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PPC32/64 defines NO_IRQ to zero, so no problems expected.
ARM defines NO_IRQ to -1, but OF code relies on IRQ domains support,
which returns correct ('0') value in 'no irq' case. So everything
should be fine.

Other arches might break if some of their OF drivers rely on NO_IRQ
being not 0. If so, the drivers must be fixed, finally.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

On Tue, Dec 06, 2011 at 01:25:07PM -0800, Linus Torvalds wrote:
> On Tue, Dec 6, 2011 at 1:22 PM, Rob Herring <robherring2@gmail.com> wrote:
> >
> > This warning code is really ugly. Can we just drop it? In my searching
> > of in kernel dts files, there's only 1 instance I have found (Versatile
> > AB watchdog) that would hit this.
> 
> I do agree. Especially since we never got any input on whether it works or not.
> 
> > If not, you don't need to handle irq_create_of_mapping return as that is
> > already always 0 for no irq or error.
> 
> Yeah, I'd like to just remove NO_IRQ from the OF paths. Afaik, it
> hasn't worked as NO_IRQ before anyway, so even if the rest of the
> drivers end up continuing using NO_IRQ, the OF-enabled ones on ARM
> should just stop. There can't be many of those yet.

Okay, here it goes.

 drivers/of/irq.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 791270b..ac6da0d 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -26,11 +26,6 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 
-/* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
-#ifndef NO_IRQ
-#define NO_IRQ 0
-#endif
-
 /**
  * irq_of_parse_and_map - Parse and map an interrupt into linux virq space
  * @device: Device node of the device whose interrupt is to be mapped
@@ -44,7 +39,7 @@ unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
 	struct of_irq oirq;
 
 	if (of_irq_map_one(dev, index, &oirq))
-		return NO_IRQ;
+		return 0;
 
 	return irq_create_of_mapping(oirq.controller, oirq.specifier,
 				     oirq.size);
@@ -345,7 +340,7 @@ int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
 
 	/* Only dereference the resource if both the
 	 * resource and the irq are valid. */
-	if (r && irq != NO_IRQ) {
+	if (r && irq) {
 		r->start = r->end = irq;
 		r->flags = IORESOURCE_IRQ;
 		r->name = dev->full_name;
@@ -363,7 +358,7 @@ int of_irq_count(struct device_node *dev)
 {
 	int nr = 0;
 
-	while (of_irq_to_resource(dev, nr, NULL) != NO_IRQ)
+	while (of_irq_to_resource(dev, nr, NULL))
 		nr++;
 
 	return nr;
@@ -383,7 +378,7 @@ int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
 	int i;
 
 	for (i = 0; i < nr_irqs; i++, res++)
-		if (of_irq_to_resource(dev, i, res) == NO_IRQ)
+		if (!of_irq_to_resource(dev, i, res))
 			break;
 
 	return i;
-- 
1.7.5.3

