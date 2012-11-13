Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2KMUwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:52:19 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:41738 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab2KMUwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:52:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-acpi@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        mathias.nyman@linux.intel.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 2/3 rev 2] ACPI / platform: Use common ACPI device resource parsing routines
Date: Tue, 13 Nov 2012 21:55:34 +0100
Message-ID: <4733383.f9kxETzVYn@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <5953163.ZajFIHZXph@vostro.rjw.lan>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <2429141.J1r7BIpiiT@vostro.rjw.lan> <5953163.ZajFIHZXph@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Use common routines in drivers/acpi/resource.c to parse ACPI device
resources while creating platform device objects.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_platform.c |   89 +++++++++----------------------------------
 1 file changed, 20 insertions(+), 69 deletions(-)

Index: linux/drivers/acpi/acpi_platform.c
===================================================================
--- linux.orig/drivers/acpi/acpi_platform.c
+++ linux/drivers/acpi/acpi_platform.c
@@ -29,21 +29,20 @@ static acpi_status acpi_platform_count_r
 						 void *data)
 {
 	struct acpi_resource_extended_irq *acpi_xirq;
+	struct acpi_resource_irq *acpi_irq;
 	struct resource_info *ri = data;
 
 	switch (res->type) {
-	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 	case ACPI_RESOURCE_TYPE_IRQ:
-		ri->n++;
+		acpi_irq = &res->data.irq;
+		ri->n += acpi_irq->interrupt_count;
 		break;
 	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
 		acpi_xirq = &res->data.extended_irq;
 		ri->n += acpi_xirq->interrupt_count;
 		break;
-	case ACPI_RESOURCE_TYPE_ADDRESS32:
-		if (res->data.address32.resource_type == ACPI_IO_RANGE)
-			ri->n++;
-		break;
+	default:
+		ri->n++;
 	}
 
 	return AE_OK;
@@ -52,71 +51,26 @@ static acpi_status acpi_platform_count_r
 static acpi_status acpi_platform_add_resources(struct acpi_resource *res,
 					       void *data)
 {
-	struct acpi_resource_fixed_memory32 *acpi_mem;
-	struct acpi_resource_address32 *acpi_add32;
-	struct acpi_resource_extended_irq *acpi_xirq;
-	struct acpi_resource_irq *acpi_irq;
 	struct resource_info *ri = data;
 	struct resource *r;
-	int irq, i;
-
-	switch (res->type) {
-	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
-		acpi_mem = &res->data.fixed_memory32;
-		r = &ri->res[ri->cur++];
-
-		r->start = acpi_mem->address;
-		r->end = r->start + acpi_mem->address_length - 1;
-		r->flags = IORESOURCE_MEM;
-
-		dev_dbg(ri->dev, "Memory32Fixed %pR\n", r);
-		break;
-
-	case ACPI_RESOURCE_TYPE_ADDRESS32:
-		acpi_add32 = &res->data.address32;
 
-		if (acpi_add32->resource_type == ACPI_IO_RANGE) {
-			r = &ri->res[ri->cur++];
-			r->start = acpi_add32->minimum;
-			r->end = r->start + acpi_add32->address_length - 1;
-			r->flags = IORESOURCE_IO;
-			dev_dbg(ri->dev, "Address32 %pR\n", r);
-		}
-		break;
-
-	case ACPI_RESOURCE_TYPE_IRQ:
-		acpi_irq = &res->data.irq;
-		r = &ri->res[ri->cur++];
-
-		irq = acpi_register_gsi(ri->dev,
-					acpi_irq->interrupts[0],
-					acpi_irq->triggering,
-					acpi_irq->polarity);
-
-		r->start = r->end = irq;
-		r->flags = IORESOURCE_IRQ;
-
-		dev_dbg(ri->dev, "IRQ %pR\n", r);
-		break;
-
-	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
-		acpi_xirq = &res->data.extended_irq;
-
-		for (i = 0; i < acpi_xirq->interrupt_count; i++, ri->cur++) {
-			r = &ri->res[ri->cur];
-			irq = acpi_register_gsi(ri->dev,
-						acpi_xirq->interrupts[i],
-						acpi_xirq->triggering,
-						acpi_xirq->polarity);
+	r = ri->res + ri->cur;
+	if (acpi_dev_resource_memory(res, r)
+	    || acpi_dev_resource_io(res, r)
+	    || acpi_dev_resource_address_space(res, r)
+	    || acpi_dev_resource_ext_address_space(res, r)) {
+		ri->cur++;
+		return AE_OK;
+	}
+	if (acpi_dev_resource_interrupt(res, 0, r)) {
+		int i;
 
-			r->start = r->end = irq;
-			r->flags = IORESOURCE_IRQ;
+		r++;
+		for (i = 1; acpi_dev_resource_interrupt(res, i, r); i++)
+			r++;
 
-			dev_dbg(ri->dev, "Interrupt %pR\n", r);
-		}
-		break;
+		ri->cur += i;
 	}
-
 	return AE_OK;
 }
 
@@ -165,9 +119,6 @@ struct platform_device *acpi_create_plat
 		goto out;
 	}
 
-	if (WARN_ON(ri.n != ri.cur))
-		goto out;
-
 	/*
 	 * If the ACPI node has a parent and that parent has a physical device
 	 * attached to it, that physical device should be the parent of the
@@ -189,7 +140,7 @@ struct platform_device *acpi_create_plat
 		mutex_unlock(&acpi_parent->physical_node_lock);
 	}
 	pdev = platform_device_register_resndata(parent, dev_name(&adev->dev),
-						 -1, ri.res, ri.n, NULL, 0);
+						 -1, ri.res, ri.cur, NULL, 0);
 	if (IS_ERR(pdev)) {
 		dev_err(&adev->dev, "platform device creation failed: %ld\n",
 			PTR_ERR(pdev));
