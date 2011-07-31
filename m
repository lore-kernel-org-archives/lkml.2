Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1GaMr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 08:47:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47842 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753008Ab1GaMru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 08:47:50 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX19W9SNbrm1WJROhaZF41kosTPrCKKstfkLdDf1IT8
	jExApe472C7L1z
Message-ID: <4E354EF4.1030206@gmx.net>
Date: Sun, 31 Jul 2011 14:47:48 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] PNPACPI: Register disabled/empty resources
References: <4E04FB69.3000206@gmx.net> <20110625025419.GB25126@khazad-dum.debian.net> <4E104966.3030002@gmx.net> <4E10533A.4080707@gmx.net>
In-Reply-To: <4E10533A.4080707@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When parsing PnP ACPI resource structures, it may happen that some of the 
resources are "empty" (in which case "the size" of the resource equals zero).  
The current solution is to skip these resources completely - with the 
unfortunate side effect that they are not registered despite the fact that 
they exist, after all.  (The downside of this approach is that these resources
cannot be used as templates for setting the actual device's resources 
because they are missing from the template.) The kernel's PNPBIOS implementation 
does not suffer from this problem and registers all resources regardless of 
their "size".

This patch fixes a problem with (at least) the vintage IBM ThinkPad 600E (and 
most likely also with the 600, 600X, and 770X which have a very similar layout) 
where some of its PnP devices support options where either an IRQ, a DMA, or an 
IO port is disabled.  Without this patch, the devices can not be configured 
using the "/sys/bus/pnp/devices/*/resources" interface. 

The manipulation of these resources is important because the 600E has very 
demanding requirements.  For instance, the number of IRQs is not sufficient to 
support all devices of the 600E.  Fortunately, some of the devices, like the 
sound card's MPU-401 UART, can be configured to not use any IRQ, hence freeing 
an IRQ for a device that requires one.  (Still, the device's "ResourceTemplate" 
requires an IRQ resource descriptor which cannot be created if the resource has 
not been registered in the first place.)  

As an example, the dependent sets of the 600E's CSC0103 device (the MPU-401 
UART) are listed, with the patch applied, as: 

  Dependent: 00 - Priority preferred
    port 0x300-0x330, align 0xf, size 0x4, 16-bit address decoding
    irq <none> High-Edge
  Dependent: 01 - Priority acceptable
    port 0x300-0x330, align 0xf, size 0x4, 16-bit address decoding
    irq 5,7,2/9,10,11,15 High-Edge

(The same result is obtained when PNPBIOS is used instead of PNPACPI.) Without 
the patch, the IRQ resource in the preferred option is not listed at all: 

  Dependent: 00 - Priority preferred
    port 0x300-0x330, align 0xf, size 0x4, 16-bit address decoding
  Dependent: 01 - Priority acceptable
    port 0x300-0x330, align 0xf, size 0x4, 16-bit address decoding
    irq 5,7,2/9,10,11,15 High-Edge
	
And in fact, the 600E's DSDT lists the empty IRQ as an option, as can  be seen 
from the following excerpt from the DSDT:

    Name (_PRS, ResourceTemplate ()
    {
        StartDependentFn (0x00, 0x00)
        {
            IO (Decode16, 0x0300, 0x0330, 0x10, 0x04)
            IRQNoFlags () {}
        }
        StartDependentFn (0x01, 0x00)
        {
            IO (Decode16, 0x0300, 0x0330, 0x10, 0x04)
            IRQNoFlags () {5,7,9,10,11,15}
        }
        EndDependentFn ()
    })

With this patch applied, a user space program - or maybe even the kernel - can 
allocate all devices' resources optimally.  For the 600E, this means to find 
optimal resources for (at least) the serial port, the parallel port, the 
infrared port, the MWAVE modem, the sound card, and the MPU-401 UART. 

The patch applies the idea to register disabled resources to all types of 
resources, not just to IRQs, DMAs, and IO ports. 

No regressions were observed on hardware that does not require this patch. 

The patch is applied against 3.0 (or against the current development tree
with 29df8d8f8702f0f53c1375015f09f04bc8d023c1 reverted).


NB: The kernel's current PnP interface does not allow for disabling individual
resources using the "/sys/bus/pnp/devices/$device/resources" file.  Assuming 
this could be done, a device could be configured to use a disabled resource 
using a simple series of calls: 

  echo disable > /sys/bus/pnp/devices/$device/resources
  echo clear > /sys/bus/pnp/devices/$device/resources
  echo set irq disabled > /sys/bus/pnp/devices/$device/resources
  echo fill > /sys/bus/pnp/devices/$device/resources
  echo activate > /sys/bus/pnp/devices/$device/resources

This patch addresses only the parsing of PNPACPI devices.  


ChangeLog (v2 -> v3):
 - change patch description
 - remove marking resources as disabled

ChangeLog (v1 -> v2):
 - extend patch description
 - fix typo in patch itself


Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>


Index: linux/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux/drivers/pnp/pnpacpi/rsparser.c
@@ -511,9 +511,6 @@ static __init void pnpacpi_parse_dma_opt
 	int i;
 	unsigned char map = 0, flags;
 
-	if (p->channel_count == 0)
-		return;
-
 	for (i = 0; i < p->channel_count; i++)
 		map |= 1 << p->channels[i];
 
@@ -529,9 +526,6 @@ static __init void pnpacpi_parse_irq_opt
 	pnp_irq_mask_t map;
 	unsigned char flags;
 
-	if (p->interrupt_count == 0)
-		return;
-
 	bitmap_zero(map.bits, PNP_IRQ_NR);
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
@@ -549,9 +543,6 @@ static __init void pnpacpi_parse_ext_irq
 	pnp_irq_mask_t map;
 	unsigned char flags;
 
-	if (p->interrupt_count == 0)
-		return;
-
 	bitmap_zero(map.bits, PNP_IRQ_NR);
 	for (i = 0; i < p->interrupt_count; i++) {
 		if (p->interrupts[i]) {
@@ -574,9 +565,6 @@ static __init void pnpacpi_parse_port_op
 {
 	unsigned char flags = 0;
 
-	if (io->address_length == 0)
-		return;
-
 	if (io->io_decode == ACPI_DECODE_16)
 		flags = IORESOURCE_IO_16BIT_ADDR;
 	pnp_register_port_resource(dev, option_flags, io->minimum, io->maximum,
@@ -587,9 +575,6 @@ static __init void pnpacpi_parse_fixed_p
 					unsigned int option_flags,
 					struct acpi_resource_fixed_io *io)
 {
-	if (io->address_length == 0)
-		return;
-
 	pnp_register_port_resource(dev, option_flags, io->address, io->address,
 				   0, io->address_length, IORESOURCE_IO_FIXED);
 }
@@ -600,9 +585,6 @@ static __init void pnpacpi_parse_mem24_o
 {
 	unsigned char flags = 0;
 
-	if (p->address_length == 0)
-		return;
-
 	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
 		flags = IORESOURCE_MEM_WRITEABLE;
 	pnp_register_mem_resource(dev, option_flags, p->minimum, p->maximum,
@@ -615,9 +597,6 @@ static __init void pnpacpi_parse_mem32_o
 {
 	unsigned char flags = 0;
 
-	if (p->address_length == 0)
-		return;
-
 	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
 		flags = IORESOURCE_MEM_WRITEABLE;
 	pnp_register_mem_resource(dev, option_flags, p->minimum, p->maximum,
@@ -630,9 +609,6 @@ static __init void pnpacpi_parse_fixed_m
 {
 	unsigned char flags = 0;
 
-	if (p->address_length == 0)
-		return;
-
 	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
 		flags = IORESOURCE_MEM_WRITEABLE;
 	pnp_register_mem_resource(dev, option_flags, p->address, p->address,
@@ -654,9 +630,6 @@ static __init void pnpacpi_parse_address
 		return;
 	}
 
-	if (p->address_length == 0)
-		return;
-
 	if (p->resource_type == ACPI_MEMORY_RANGE) {
 		if (p->info.mem.write_protect == ACPI_READ_WRITE_MEMORY)
 			flags = IORESOURCE_MEM_WRITEABLE;
@@ -676,9 +649,6 @@ static __init void pnpacpi_parse_ext_add
 	struct acpi_resource_extended_address64 *p = &r->data.ext_address64;
 	unsigned char flags = 0;
 
-	if (p->address_length == 0)
-		return;
-
 	if (p->resource_type == ACPI_MEMORY_RANGE) {
 		if (p->info.mem.write_protect == ACPI_READ_WRITE_MEMORY)
 			flags = IORESOURCE_MEM_WRITEABLE;

