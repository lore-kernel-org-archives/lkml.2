Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab2LLPeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 10:34:36 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:43966 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754200Ab2LLPee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 10:34:34 -0500
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX1+7GeJ1PL67tS2d3YeQ5yORmpVMhEI0SCrnR01AHh
	xZYn47aJU72nO9
Message-ID: <50C8A407.7070906@gmx.net>
Date: Wed, 12 Dec 2012 16:34:31 +0100
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] PNP: Handle IORESOURCE_BITS in resource allocation
References: <4460434.rhV1bpKLo5@vostro.rjw.lan> <50C75E65.70802@gmx.net> <7930705.OcvDjiPjJD@vostro.rjw.lan>
In-Reply-To: <7930705.OcvDjiPjJD@vostro.rjw.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch copies the flags masked by IORESOURCE_BITS from a resource's 
template.  This is necessary because the resource settings require proper
IORESOURCE_BITS which are not known during the definition of these resources 
using the "/sys/bus/pnp/*/*/resources" interface.  (In fact, they should not 
be set by the user as the resource templates define the proper settings.)

If the patch is not applied, the resource flags are not initialized properly 
and obscure messages in the kernel log have been seen ("invalid flags").  

The patch is applied against Linux 3.7 as well as linux-pm.git/master 
as of 2012-12-12.


Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>


Index: linux/drivers/pnp/manager.c
===================================================================
--- linux.orig/drivers/pnp/manager.c
+++ linux/drivers/pnp/manager.c
@@ -18,11 +18,27 @@
 
 DEFINE_MUTEX(pnp_res_mutex);
 
+static struct resource *pnp_find_resource(struct pnp_dev *dev,
+					  unsigned char rule,
+					  unsigned long type,
+					  unsigned int bar)
+{
+	struct resource *res = pnp_get_resource(dev, type, bar);
+
+	/* when the resource already exists, set its resource bits from rule */
+	if (res) {
+		res->flags &= ~IORESOURCE_BITS;
+		res->flags |= rule & IORESOURCE_BITS;
+	}
+
+	return res;
+}
+
 static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 {
 	struct resource *res, local_res;
 
-	res = pnp_get_resource(dev, IORESOURCE_IO, idx);
+	res = pnp_find_resource(dev, rule->flags, IORESOURCE_IO, idx);
 	if (res) {
 		pnp_dbg(&dev->dev, "  io %d already set to %#llx-%#llx "
 			"flags %#lx\n", idx, (unsigned long long) res->start,
@@ -65,7 +81,7 @@ static int pnp_assign_mem(struct pnp_dev
 {
 	struct resource *res, local_res;
 
-	res = pnp_get_resource(dev, IORESOURCE_MEM, idx);
+	res = pnp_find_resource(dev, rule->flags, IORESOURCE_MEM, idx);
 	if (res) {
 		pnp_dbg(&dev->dev, "  mem %d already set to %#llx-%#llx "
 			"flags %#lx\n", idx, (unsigned long long) res->start,
@@ -78,6 +94,7 @@ static int pnp_assign_mem(struct pnp_dev
 	res->start = 0;
 	res->end = 0;
 
+	/* ??? rule->flags restricted to 8 bits, all tests bogus ??? */
 	if (!(rule->flags & IORESOURCE_MEM_WRITEABLE))
 		res->flags |= IORESOURCE_READONLY;
 	if (rule->flags & IORESOURCE_MEM_CACHEABLE)
@@ -123,7 +140,7 @@ static int pnp_assign_irq(struct pnp_dev
 		5, 10, 11, 12, 9, 14, 15, 7, 3, 4, 13, 0, 1, 6, 8, 2
 	};
 
-	res = pnp_get_resource(dev, IORESOURCE_IRQ, idx);
+	res = pnp_find_resource(dev, rule->flags, IORESOURCE_IRQ, idx);
 	if (res) {
 		pnp_dbg(&dev->dev, "  irq %d already set to %d flags %#lx\n",
 			idx, (int) res->start, res->flags);
@@ -182,7 +199,7 @@ static int pnp_assign_dma(struct pnp_dev
 		1, 3, 5, 6, 7, 0, 2, 4
 	};
 
-	res = pnp_get_resource(dev, IORESOURCE_DMA, idx);
+	res = pnp_find_resource(dev, rule->flags, IORESOURCE_DMA, idx);
 	if (res) {
 		pnp_dbg(&dev->dev, "  dma %d already set to %d flags %#lx\n",
 			idx, (int) res->start, res->flags);


