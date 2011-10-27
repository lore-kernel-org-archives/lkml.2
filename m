Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab1J0S5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 14:57:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53836 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754532Ab1J0S5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 14:57:13 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX18AZspjIZMAnl1aboGytA/lDsXCvhw2oicWw/+V6v
	Y1rXQB/OoJJEhM
Message-ID: <4EA9A96F.1030708@gmx.net>
Date: Thu, 27 Oct 2011 20:56:47 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
CC: linux-kernel@vger.kernel.org, len.brown@intel.com, bhelgaas@google.com
Subject: [PATCH, resend] PNPACPI: Simplify disabled resource registration
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch simplifies 29df8d8f8702f0f53c1375015f09f04bc8d023c1.  As 
the "pnp_xxx" structs are not designed to cope with IORESOURCE_DISABLED, and 
hence no code can test for this value, setting this value is actually a "no op" 
and can be skipped altogether.  It is sufficient to remove the checks for 
"empty" resources and continue processing. 

The patch is applied against 3.1.


Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>


diff -u linux/drivers/pnp/pnpacpi/rsparser.c linux/drivers/pnp/pnpacpi/rsparser.c
--- linux/drivers/pnp/pnpacpi/rsparser.c
+++ linux/drivers/pnp/pnpacpi/rsparser.c
@@ -509,15 +509,12 @@
 					    struct acpi_resource_dma *p)
 {
 	int i;
-	unsigned char map = 0, flags = 0;
-
-	if (p->channel_count == 0)
-		flags |= IORESOURCE_DISABLED;
+	unsigned char map = 0, flags;
 
 	for (i = 0; i < p->channel_count; i++)
 		map |= 1 << p->channels[i];
 
-	flags |= dma_flags(dev, p->type, p->bus_master, p->transfer);
+	flags = dma_flags(dev, p->type, p->bus_master, p->transfer);
 	pnp_register_dma_resource(dev, option_flags, map, flags);
 }
 
@@ -527,17 +524,14 @@
 {
 	int i;
 	pnp_irq_mask_t map;
-	unsigned char flags = 0;
-
-	if (p->interrupt_count == 0)
-		flags |= IORESOURCE_DISABLED;
+	unsigned char flags;
 
 	bitmap_zero(map.bits, PNP_IRQ_NR);
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
 			__set_bit(p->interrupts[i], map.bits);
 
-	flags |= irq_flags(p->triggering, p->polarity, p->sharable);
+	flags = irq_flags(p->triggering, p->polarity, p->sharable);
 	pnp_register_irq_resource(dev, option_flags, &map, flags);
 }
 
@@ -547,10 +541,7 @@
 {
 	int i;
 	pnp_irq_mask_t map;
-	unsigned char flags = 0;
-
-	if (p->interrupt_count == 0)
-		flags |= IORESOURCE_DISABLED;
+	unsigned char flags;
 
 	bitmap_zero(map.bits, PNP_IRQ_NR);
 	for (i = 0; i < p->interrupt_count; i++) {
@@ -564,7 +555,7 @@
 		}
 	}
 
-	flags |= irq_flags(p->triggering, p->polarity, p->sharable);
+	flags = irq_flags(p->triggering, p->polarity, p->sharable);
 	pnp_register_irq_resource(dev, option_flags, &map, flags);
 }
 
@@ -574,11 +565,8 @@
 {
 	unsigned char flags = 0;
 
-	if (io->address_length == 0)
-		flags |= IORESOURCE_DISABLED;
-
 	if (io->io_decode == ACPI_DECODE_16)
-		flags |= IORESOURCE_IO_16BIT_ADDR;
+		flags = IORESOURCE_IO_16BIT_ADDR;
 	pnp_register_port_resource(dev, option_flags, io->minimum, io->maximum,
 				   io->alignment, io->address_length, flags);
 }
@@ -587,13 +575,8 @@
 					unsigned int option_flags,
 					struct acpi_resource_fixed_io *io)
 {
-	unsigned char flags = 0;
-
-	if (io->address_length == 0)
-		flags |= IORESOURCE_DISABLED;
-
 	pnp_register_port_resource(dev, option_flags, io->address, io->address,
-				   0, io->address_length, flags | IORESOURCE_IO_FIXED);
+				   0, io->address_length, IORESOURCE_IO_FIXED);
 }
 
 static __init void pnpacpi_parse_mem24_option(struct pnp_dev *dev,
@@ -602,11 +585,8 @@
 {
 	unsigned char flags = 0;
 
-	if (p->address_length == 0)
-		flags |= IORESOURCE_DISABLED;
-
 	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
-		flags |= IORESOURCE_MEM_WRITEABLE;
+		flags = IORESOURCE_MEM_WRITEABLE;
 	pnp_register_mem_resource(dev, option_flags, p->minimum, p->maximum,
 				  p->alignment, p->address_length, flags);
 }
@@ -617,11 +597,8 @@
 {
 	unsigned char flags = 0;
 
-	if (p->address_length == 0)
-		flags |= IORESOURCE_DISABLED;
-
 	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
-		flags |= IORESOURCE_MEM_WRITEABLE;
+		flags = IORESOURCE_MEM_WRITEABLE;
 	pnp_register_mem_resource(dev, option_flags, p->minimum, p->maximum,
 				  p->alignment, p->address_length, flags);
 }
@@ -632,11 +609,8 @@
 {
 	unsigned char flags = 0;
 
-	if (p->address_length == 0)
-		flags |= IORESOURCE_DISABLED;
-
 	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
-		flags |= IORESOURCE_MEM_WRITEABLE;
+		flags = IORESOURCE_MEM_WRITEABLE;
 	pnp_register_mem_resource(dev, option_flags, p->address, p->address,
 				  0, p->address_length, flags);
 }
@@ -656,19 +630,16 @@
 		return;
 	}
 
-	if (p->address_length == 0)
-		flags |= IORESOURCE_DISABLED;
-
 	if (p->resource_type == ACPI_MEMORY_RANGE) {
 		if (p->info.mem.write_protect == ACPI_READ_WRITE_MEMORY)
-			flags |= IORESOURCE_MEM_WRITEABLE;
+			flags = IORESOURCE_MEM_WRITEABLE;
 		pnp_register_mem_resource(dev, option_flags, p->minimum,
 					  p->minimum, 0, p->address_length,
 					  flags);
 	} else if (p->resource_type == ACPI_IO_RANGE)
 		pnp_register_port_resource(dev, option_flags, p->minimum,
 					   p->minimum, 0, p->address_length,
-					   flags | IORESOURCE_IO_FIXED);
+					   IORESOURCE_IO_FIXED);
 }
 
 static __init void pnpacpi_parse_ext_address_option(struct pnp_dev *dev,
@@ -678,19 +649,16 @@
 	struct acpi_resource_extended_address64 *p = &r->data.ext_address64;
 	unsigned char flags = 0;
 
-	if (p->address_length == 0)
-		flags |= IORESOURCE_DISABLED;
-
 	if (p->resource_type == ACPI_MEMORY_RANGE) {
 		if (p->info.mem.write_protect == ACPI_READ_WRITE_MEMORY)
-			flags |= IORESOURCE_MEM_WRITEABLE;
+			flags = IORESOURCE_MEM_WRITEABLE;
 		pnp_register_mem_resource(dev, option_flags, p->minimum,
 					  p->minimum, 0, p->address_length,
 					  flags);
 	} else if (p->resource_type == ACPI_IO_RANGE)
 		pnp_register_port_resource(dev, option_flags, p->minimum,
 					   p->minimum, 0, p->address_length,
-					   flags | IORESOURCE_IO_FIXED);
+					   IORESOURCE_IO_FIXED);
 }
 
 struct acpipnp_parse_option_s {
