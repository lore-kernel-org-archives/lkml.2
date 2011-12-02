Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1LBXSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:18:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50211 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1LBXSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:18:40 -0500
Date: Sat, 3 Dec 2011 03:18:33 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Martin <dave.martin@linaro.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v2] of/irq: Get rid of NO_IRQ usage
Message-ID: <20111202231833.GA11588@oksana.dev.rtsoft.ru>
References: <20111110151852.GA7465@oksana.dev.rtsoft.ru>
 <20111110152606.GB3207@oksana.dev.rtsoft.ru>
 <20111110153816.239af1d7@lxorguk.ukuu.org.uk>
 <20111110162859.GA7088@oksana.dev.rtsoft.ru>
 <20111202191917.GB3037@localhost.localdomain>
 <20111202223402.GA7780@oksana.dev.rtsoft.ru>
 <CA+55aFzUy2C26GbTqapEgh0wh5Z1wuH_-Kdm7yCdp6cnu46afQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzUy2C26GbTqapEgh0wh5Z1wuH_-Kdm7yCdp6cnu46afQ@mail.gmail.com>
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

On Fri, Dec 02, 2011 at 02:40:37PM -0800, Linus Torvalds wrote:
> On Fri, Dec 2, 2011 at 2:34 PM, Anton Vorontsov
> <anton.vorontsov@linaro.org> wrote:
> >
> > One option is to test this patch on a board that is now broken:
> >
> > http://lkml.org/lkml/2011/11/10/290
> 
> That seems broken.
> 
> Spot the trouble:
> 
>   +	ret = irq_create_of_mapping(oirq.controller, oirq.specifier,
>   +				    oirq.size);
>   +no_irq:
>   +#ifdef NO_IRQ
>   +#if NO_IRQ != 0
>   +	if (ret == NO_IRQ)
>   +		pr_warn("Hit NO_IRQ case for your arch. Drivers might expect "
>   +			"NO_IRQ, but we return 0. If anything breaks, driver "
>   +			"have to be fixed.\n");
>   +#endif
>   +#endif
>   +	return ret;
> 
> It claims "we return 0", but then doesn't return zero.. Hmm?
> 
>                   Linus

Hehe, I never claimed that I tested the patch on any OF platform. :-D

But, the patch would work for ARM anyway. irq_create_of_mapping()
always return 0 in case of 'no irq'. So, in ARM case the problem was
in the hunk that you snipped:

         if (of_irq_map_one(dev, index, &oirq))
 -               return NO_IRQ;
 -

For the arches that don't use IRQ domains and have NO_IRQ != 0 (e.g.
microblaze), you spot the real trouble indeed. Thanks.

Here is the amended fix. I hope it works, and somebody could test it.

p.s.

Initially I proposed a very simple band-aid fix for 3.2, and wanted
the real fix postponed for 3.3 (since nowadays I don't have any OF
machines to test, but this will change soon).

I hope it's a good excuse. ;-)

 drivers/of/irq.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 791270b..97ee3bd 100644
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
@@ -42,12 +37,25 @@
 unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
 {
 	struct of_irq oirq;
+	int ret = 0;
 
 	if (of_irq_map_one(dev, index, &oirq))
-		return NO_IRQ;
-
-	return irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
+		goto no_irq;
+
+	ret = irq_create_of_mapping(oirq.controller, oirq.specifier,
+				    oirq.size);
+no_irq:
+#ifdef NO_IRQ
+#if NO_IRQ != 0
+	if (ret == NO_IRQ) {
+		pr_warn("Hit NO_IRQ case for your arch. Drivers might expect "
+			"NO_IRQ, but we return 0. If anything breaks, driver "
+			"have to be fixed.\n");
+		ret = 0;
+	}
+#endif
+#endif
+	return ret;
 }
 EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
 
@@ -345,7 +353,7 @@ int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
 
 	/* Only dereference the resource if both the
 	 * resource and the irq are valid. */
-	if (r && irq != NO_IRQ) {
+	if (r && irq) {
 		r->start = r->end = irq;
 		r->flags = IORESOURCE_IRQ;
 		r->name = dev->full_name;
@@ -363,7 +371,7 @@ int of_irq_count(struct device_node *dev)
 {
 	int nr = 0;
 
-	while (of_irq_to_resource(dev, nr, NULL) != NO_IRQ)
+	while (of_irq_to_resource(dev, nr, NULL))
 		nr++;
 
 	return nr;
@@ -383,7 +391,7 @@ int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
 	int i;
 
 	for (i = 0; i < nr_irqs; i++, res++)
-		if (of_irq_to_resource(dev, i, res) == NO_IRQ)
+		if (!of_irq_to_resource(dev, i, res))
 			break;
 
 	return i;
-- 
1.7.5.3

