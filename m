Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2KHAmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 19:42:16 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:33154 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab2KHAmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 19:42:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Date: Thu, 08 Nov 2012 01:46:24 +0100
Message-ID: <30766811.i5oXHLoU7e@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121107130548.GZ24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <1493573.krE1QVlUux@vostro.rjw.lan> <20121107130548.GZ24532@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 07, 2012 03:05:48 PM Mika Westerberg wrote:
> On Wed, Nov 07, 2012 at 12:14:31PM +0100, Rafael J. Wysocki wrote:
> > > So is the idea now that the ACPI core parses the resources and passes them
> > > forward via struct acpi_device? I'm just wondering how to proceed with
> > > these I2C and SPI enumeration patches.
> > 
> > Well, we definitely don't want to duplicate what drivers/pnp/pnpacpi/rsparser.c
> > does, so the idea is to move the code from there to the core in such a way that
> > both the SPI/I2C patches and the PNP layer can use it.
> 
> Ok.
> 
> > I'll have some prototype code ready shortly, hopefully, and I'll post it
> > in that form for comments (and so that you know what to expect).
> 
> Sounds good. Thanks!

There you go.

I haven't even try to compile it, so most likely it breaks things left, right
and in between, but I hope it shows the idea.

It does a couple of things at the same time, so it should be split into a few
simpler patches.  First, it moves some code from drivers/pnp/pnpacpi/rsparser.c
to a new file drivers/acpi/resource.c and makes pnpacpi use functions from
there.  Second, it changes acpi_platform.c to use those functions too.
Finally, it adds a list of ACPI resources to struct acpi_device and
makes acpi_platform.c use that list intead of evaluating _CRS and parsing its
output with acpi_walk_resources().

While changing acpi_platform.c I noticed that we had a bug in there, because
GSIs were registered for the struct acpi_device object, although they should be
registered for the struct platform_device one created by that code.  I didn't
try to fix that in the patch below, but it generally needs fixing.

Thanks,
Rafael


Prototype, no sign-off.
---
 drivers/acpi/Makefile          |    1 
 drivers/acpi/acpi_platform.c   |  122 +++++-------------
 drivers/acpi/resource.c        |  269 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/scan.c            |   48 +++++++
 drivers/pnp/base.h             |    2 
 drivers/pnp/pnpacpi/rsparser.c |  150 +---------------------
 drivers/pnp/resource.c         |   16 ++
 include/acpi/acpi_bus.h        |    6 
 8 files changed, 386 insertions(+), 228 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -259,6 +259,11 @@ struct acpi_device_physical_node {
 	struct device *dev;
 };
 
+struct acpi_resource_list_entry {
+	struct list_head node;
+	struct acpi_resource resource;
+};
+
 /* set maximum of physical nodes to 32 for expansibility */
 #define ACPI_MAX_PHYSICAL_NODE	32
 
@@ -269,6 +274,7 @@ struct acpi_device {
 	struct acpi_device *parent;
 	struct list_head children;
 	struct list_head node;
+	struct list_head resources;	/* Device resources. */
 	struct list_head wakeup_list;
 	struct acpi_device_status status;
 	struct acpi_device_flags flags;
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -670,6 +670,8 @@ end:
 
 static void acpi_device_unregister(struct acpi_device *device, int type)
 {
+	struct acpi_resource_list_entry *entry, *s;
+
 	mutex_lock(&acpi_device_lock);
 	if (device->parent)
 		list_del(&device->node);
@@ -681,6 +683,9 @@ static void acpi_device_unregister(struc
 
 	acpi_device_remove_files(device);
 	device_unregister(&device->dev);
+
+	list_for_each_entry_safe(entry, s, &device->resources, node)
+		kfree(entry);
 }
 
 /* --------------------------------------------------------------------------
@@ -990,6 +995,40 @@ static void acpi_bus_get_wakeup_device_f
 				"error in _DSW or _PSW evaluation\n"));
 }
 
+static acpi_status acpi_bus_add_resource(struct acpi_resource *res,
+					 void *context)
+{
+	struct list_head *list = context;
+	struct acpi_resource_list_entry *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return AE_NO_MEMORY;
+
+	entry->resource = *res;
+	list_add_tail(&entry->node, list);
+	return AE_OK;
+}
+
+static int acpi_bus_get_resources(struct acpi_device *adev)
+{
+	acpi_status status;
+	int ret = 0;
+
+	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
+				     acpi_bus_add_resource, &adev->resources);
+	if (ACPI_FAILURE(status)) {
+		switch(status) {
+		case AE_NO_MEMORY:
+			ret = -ENOMEM;
+			break;
+		default:
+			ret = -EIO;
+		}
+	}
+	return ret;
+}
+
 static void acpi_bus_add_power_resource(acpi_handle handle);
 
 static int acpi_bus_get_power_flags(struct acpi_device *device)
@@ -1412,6 +1451,15 @@ static int acpi_add_single_object(struct
 	acpi_device_set_id(device);
 
 	/*
+	 * Device Resources
+	 * ----------------
+	 */
+	INIT_LIST_HEAD(&device->resources);
+	result = acpi_bus_get_resources(device);
+	if (result)
+		goto end;
+
+	/*
 	 * Power Management
 	 * ----------------
 	 */
Index: linux-pm/drivers/acpi/resource.c
===================================================================
--- /dev/null
+++ linux-pm/drivers/acpi/resource.c
@@ -0,0 +1,269 @@
+/*
+ * drivers/acpi/resource.c - ACPI device resources management.
+ *
+ * Copyright (C) 2012, Intel Corp.
+ * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/ioport.h>
+
+#include <acpi/acpi.h>
+#include <acpi/acpi_bus.h>
+
+static unsigned long acpi_dev_memresource_flags(u64 len, u8 write_protect,
+						bool window)
+{
+	unsigned long flags = IORESOURCE_MEM;
+
+	if (len == 0)
+		flags |= IORESOURCE_DISABLED;
+
+	if (write_protect == ACPI_READ_WRITE_MEMORY)
+		flags |= IORESOURCE_MEM_WRITEABLE;
+
+	if (window)
+		flags |= IORESOURCE_WINDOW;
+
+	return flags;
+}
+
+static void acpi_dev_get_memresource(struct resource *res, u64 start, u64 len,
+				     u8 write_protect)
+{
+	res->start = start;
+	res->end = start + len - 1;
+	res->flags = acpi_dev_memresource_flags(len, write_protect, false);
+}
+
+/**
+ * acpi_dev_resource_memory - Extract ACPI memory resource information.
+ * @ares: Input ACPI resource object.
+ * @res: Output generic resource object.
+ *
+ * Check if the given ACPI resource object represents a memory resource and
+ * if that's the case, use the information in it to populate the generic
+ * resource object pointed to by @res.
+ */
+bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
+{
+	struct acpi_resource_memory24 *memory24;
+	struct acpi_resource_memory32 *memory32;
+	struct acpi_resource_fixed_memory32 *fixed_memory32;
+
+	switch (res->type) {
+	case ACPI_RESOURCE_TYPE_MEMORY24:
+		memory24 = &ares->data.memory24;
+		acpi_dev_get_memresource(res, memory24->minimum,
+					 memory24->address_length,
+					 memory24->write_protect);
+		break;
+	case ACPI_RESOURCE_TYPE_MEMORY32:
+		memory32 = &ares->data.memory32;
+		acpi_dev_get_memresource(res, memory32->minimum,
+					 memory32->address_length,
+					 memory32->write_protect);
+		break;
+	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
+		fixed_memory32 = &ares->data.fixed_memory32;
+		acpi_dev_get_memresource(res, fixed_memory32->address,
+					 fixed_memory32->address_length,
+					 fixed_memory32->write_protect);
+		break;
+	default:
+		return false;
+	}
+	return true;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_resource_memory);
+
+static void acpi_dev_ioresource_flags(u64 start, u64 end, u8 io_decode,
+				      bool window)
+{
+	int flags = IORESOURCE_IO;
+
+	if (io_decode == ACPI_DECODE_16)
+		flags |= IORESOURCE_IO_16BIT_ADDR;
+
+	if (start > end || end >= 0x10003)
+		flags |= IORESOURCE_DISABLED;
+
+	if (window)
+		flags |= IORESOURCE_WINDOW;
+
+	return flags;
+}
+
+static void acpi_dev_get_ioresource(struct resource *res, u64 start, u64 len,
+				    u8 io_decode)
+{
+	u64 end = start + len - 1;
+
+	res->start = start;
+	res->end = end;
+	res->flags = acpi_dev_ioresource_flags(start, end, io_decode, false);
+}
+
+/**
+ * acpi_dev_resource_io - Extract ACPI I/O resource information.
+ * @ares: Input ACPI resource object.
+ * @res: Output generic resource object.
+ *
+ * Check if the given ACPI resource object represents an I/O resource and
+ * if that's the case, use the information in it to populate the generic
+ * resource object pointed to by @res.
+ */
+bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res)
+{
+	struct acpi_resource_io *io;
+	struct acpi_resource_fixed_io *fixed_io;
+
+	switch (res->type) {
+	case ACPI_RESOURCE_TYPE_IO:
+		io = &ares->data.io;
+		acpi_dev_get_ioresource(res, io->minimum,
+					  io->address_length,
+					  io->io_decode);
+		break;
+	case ACPI_RESOURCE_TYPE_FIXED_IO
+		fixed_io = &res->data.fixed_io;
+		acpi_dev_get_ioresource(res, fixed_io->address,
+					  fixed_io->address_length,
+					  ACPI_DECODE_10);
+		break;
+	default:
+		return false;
+	}
+	return true;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_resource_io);
+
+/**
+ * acpi_dev_resource_address_space - Extract ACPI address space information.
+ * @ares: Input ACPI resource object.
+ * @res: Output generic resource object.
+ *
+ * Check if the given ACPI resource object represents an address space resource
+ * and if that's the case, use the information in it to populate the generic
+ * resource object pointed to by @res.
+ */
+bool acpi_dev_resource_address_space(struct acpi_resource *ares,
+				     struct resource *res)
+{
+	acpi_status status;
+	struct acpi_resource_address64 addr;
+	bool window;
+	u64 len;
+	u8 io_decode;
+
+	switch (res->type) {
+	case ACPI_RESOURCE_TYPE_ADDRESS16:
+	case ACPI_RESOURCE_TYPE_ADDRESS32:
+	case ACPI_RESOURCE_TYPE_ADDRESS64:
+		break;
+	default:
+		return false;
+	}
+
+	status = acpi_resource_to_address64(ares, &addr);
+	if (ACPI_FAILURE(status))
+		return true;
+
+	res->start = addr.minimum;
+	res->end = addr.maximum;
+	window = addr.producer_consumer == ACPI_PRODUCER;
+
+	switch(resource_type) {
+	case ACPI_MEMORY_RANGE:
+		len = addr.maximum - addr.minimum + 1;
+		res->flags = acpi_dev_memresource_flags(len,
+						addr.info.mem.write_protect,
+						window);
+		break;
+	case ACPI_IO_RANGE:
+		io_decode = addr.granularity == 0xfff ?
+				ACPI_DECODE_10 : ACPI_DECODE_16;
+		res->flags = acpi_dev_ioresource_flags(addr.minimum,
+						       addr.maximum,
+						       io_decode, window);
+		break;
+	case ACPI_BUS_NUMBER_RANGE:
+		res->flags = IORESOURCE_BUS;
+		break;
+	default:
+		res->flags = 0;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space);
+
+/**
+ * acpi_dev_resource_ext_address_space - Extract ACPI address space information.
+ * @ares: Input ACPI resource object.
+ * @res: Output generic resource object.
+ *
+ * Check if the given ACPI resource object represents an extended address space
+ * resource and if that's the case, use the information in it to populate the
+ * generic resource object pointed to by @res.
+ */
+bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
+					 struct resource *res)
+{
+	acpi_status status;
+	struct acpi_resource_extended_address64 *ext_addr;
+	bool window;
+	u64 len;
+	u8 io_decode;
+
+	if (res->type != ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64)
+		return false;
+
+	ext_addr = &res->data.ext_address64;
+
+	res->start = ext_addr->minimum;
+	res->end = ext_addr->maximum;
+	window = ext_addr->producer_consumer == ACPI_PRODUCER;
+
+	switch(resource_type) {
+	case ACPI_MEMORY_RANGE:
+		len = ext_addr->maximum - ext_addr->minimum + 1;
+		res->flags = acpi_dev_memresource_flags(len,
+					ext_addr->info.mem.write_protect,
+					window);
+		break;
+	case ACPI_IO_RANGE:
+		io_decode = ext_addr->granularity == 0xfff ?
+				ACPI_DECODE_10 : ACPI_DECODE_16;
+		res->flags = acpi_dev_ioresource_flags(ext_addr->minimum,
+						       ext_addr->maximum,
+						       io_decode, window);
+		break;
+	case ACPI_BUS_NUMBER_RANGE:
+		res->flags = IORESOURCE_BUS;
+		break;
+	default:
+		res->flags = 0;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_resource_ext_address_space);
Index: linux-pm/drivers/acpi/Makefile
===================================================================
--- linux-pm.orig/drivers/acpi/Makefile
+++ linux-pm/drivers/acpi/Makefile
@@ -33,6 +33,7 @@ acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
 #
 acpi-y				+= bus.o glue.o
 acpi-y				+= scan.o
+acpi-y				+= resource.o
 acpi-y				+= processor_core.o
 acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
Index: linux-pm/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux-pm.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux-pm/drivers/pnp/pnpacpi/rsparser.c
@@ -177,23 +177,6 @@ static int dma_flags(struct pnp_dev *dev
 	return flags;
 }
 
-static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev, u64 start,
-					       u64 len, int io_decode,
-					       int window)
-{
-	int flags = 0;
-	u64 end = start + len - 1;
-
-	if (io_decode == ACPI_DECODE_16)
-		flags |= IORESOURCE_IO_16BIT_ADDR;
-	if (len == 0 || end >= 0x10003)
-		flags |= IORESOURCE_DISABLED;
-	if (window)
-		flags |= IORESOURCE_WINDOW;
-
-	pnp_add_io_resource(dev, start, end, flags);
-}
-
 /*
  * Device CSRs that do not appear in PCI config space should be described
  * via ACPI.  This would normally be done with Address Space Descriptors
@@ -249,83 +232,6 @@ static void pnpacpi_parse_allocated_vend
 	}
 }
 
-static void pnpacpi_parse_allocated_memresource(struct pnp_dev *dev,
-						u64 start, u64 len,
-						int write_protect, int window)
-{
-	int flags = 0;
-	u64 end = start + len - 1;
-
-	if (len == 0)
-		flags |= IORESOURCE_DISABLED;
-	if (write_protect == ACPI_READ_WRITE_MEMORY)
-		flags |= IORESOURCE_MEM_WRITEABLE;
-	if (window)
-		flags |= IORESOURCE_WINDOW;
-
-	pnp_add_mem_resource(dev, start, end, flags);
-}
-
-static void pnpacpi_parse_allocated_busresource(struct pnp_dev *dev,
-						u64 start, u64 len)
-{
-	u64 end = start + len - 1;
-
-	pnp_add_bus_resource(dev, start, end);
-}
-
-static void pnpacpi_parse_allocated_address_space(struct pnp_dev *dev,
-						  struct acpi_resource *res)
-{
-	struct acpi_resource_address64 addr, *p = &addr;
-	acpi_status status;
-	int window;
-	u64 len;
-
-	status = acpi_resource_to_address64(res, p);
-	if (!ACPI_SUCCESS(status)) {
-		dev_warn(&dev->dev, "failed to convert resource type %d\n",
-			 res->type);
-		return;
-	}
-
-	/* Windows apparently computes length rather than using _LEN */
-	len = p->maximum - p->minimum + 1;
-	window = (p->producer_consumer == ACPI_PRODUCER) ? 1 : 0;
-
-	if (p->resource_type == ACPI_MEMORY_RANGE)
-		pnpacpi_parse_allocated_memresource(dev, p->minimum, len,
-			p->info.mem.write_protect, window);
-	else if (p->resource_type == ACPI_IO_RANGE)
-		pnpacpi_parse_allocated_ioresource(dev, p->minimum, len,
-			p->granularity == 0xfff ? ACPI_DECODE_10 :
-				ACPI_DECODE_16, window);
-	else if (p->resource_type == ACPI_BUS_NUMBER_RANGE)
-		pnpacpi_parse_allocated_busresource(dev, p->minimum, len);
-}
-
-static void pnpacpi_parse_allocated_ext_address_space(struct pnp_dev *dev,
-						      struct acpi_resource *res)
-{
-	struct acpi_resource_extended_address64 *p = &res->data.ext_address64;
-	int window;
-	u64 len;
-
-	/* Windows apparently computes length rather than using _LEN */
-	len = p->maximum - p->minimum + 1;
-	window = (p->producer_consumer == ACPI_PRODUCER) ? 1 : 0;
-
-	if (p->resource_type == ACPI_MEMORY_RANGE)
-		pnpacpi_parse_allocated_memresource(dev, p->minimum, len,
-			p->info.mem.write_protect, window);
-	else if (p->resource_type == ACPI_IO_RANGE)
-		pnpacpi_parse_allocated_ioresource(dev, p->minimum, len,
-			p->granularity == 0xfff ? ACPI_DECODE_10 :
-				ACPI_DECODE_16, window);
-	else if (p->resource_type == ACPI_BUS_NUMBER_RANGE)
-		pnpacpi_parse_allocated_busresource(dev, p->minimum, len);
-}
-
 static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 					      void *data)
 {
@@ -339,8 +245,17 @@ static acpi_status pnpacpi_allocated_res
 	struct acpi_resource_memory32 *memory32;
 	struct acpi_resource_fixed_memory32 *fixed_memory32;
 	struct acpi_resource_extended_irq *extended_irq;
+	struct resource r;
 	int i, flags;
 
+	if (acpi_dev_resource_memory(res, &r)
+	    || acpi_dev_resource_io(res, &r)
+	    || acpi_dev_resource_address_space(res, &r)
+	    || acpi_dev_resource_ext_address_space(res, &r))
+		pnp_add_resource(dev, &r);
+		return AE_OK;
+	}
+
 	switch (res->type) {
 	case ACPI_RESOURCE_TYPE_IRQ:
 		/*
@@ -383,26 +298,10 @@ static acpi_status pnpacpi_allocated_res
 		pnp_add_dma_resource(dev, dma->channels[0], flags);
 		break;
 
-	case ACPI_RESOURCE_TYPE_IO:
-		io = &res->data.io;
-		pnpacpi_parse_allocated_ioresource(dev,
-			io->minimum,
-			io->address_length,
-			io->io_decode, 0);
-		break;
-
 	case ACPI_RESOURCE_TYPE_START_DEPENDENT:
 	case ACPI_RESOURCE_TYPE_END_DEPENDENT:
 		break;
 
-	case ACPI_RESOURCE_TYPE_FIXED_IO:
-		fixed_io = &res->data.fixed_io;
-		pnpacpi_parse_allocated_ioresource(dev,
-			fixed_io->address,
-			fixed_io->address_length,
-			ACPI_DECODE_10, 0);
-		break;
-
 	case ACPI_RESOURCE_TYPE_VENDOR:
 		vendor_typed = &res->data.vendor_typed;
 		pnpacpi_parse_allocated_vendor(dev, vendor_typed);
@@ -411,37 +310,6 @@ static acpi_status pnpacpi_allocated_res
 	case ACPI_RESOURCE_TYPE_END_TAG:
 		break;
 
-	case ACPI_RESOURCE_TYPE_MEMORY24:
-		memory24 = &res->data.memory24;
-		pnpacpi_parse_allocated_memresource(dev,
-			memory24->minimum,
-			memory24->address_length,
-			memory24->write_protect, 0);
-		break;
-	case ACPI_RESOURCE_TYPE_MEMORY32:
-		memory32 = &res->data.memory32;
-		pnpacpi_parse_allocated_memresource(dev,
-			memory32->minimum,
-			memory32->address_length,
-			memory32->write_protect, 0);
-		break;
-	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
-		fixed_memory32 = &res->data.fixed_memory32;
-		pnpacpi_parse_allocated_memresource(dev,
-			fixed_memory32->address,
-			fixed_memory32->address_length,
-			fixed_memory32->write_protect, 0);
-		break;
-	case ACPI_RESOURCE_TYPE_ADDRESS16:
-	case ACPI_RESOURCE_TYPE_ADDRESS32:
-	case ACPI_RESOURCE_TYPE_ADDRESS64:
-		pnpacpi_parse_allocated_address_space(dev, res);
-		break;
-
-	case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
-		pnpacpi_parse_allocated_ext_address_space(dev, res);
-		break;
-
 	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
 		extended_irq = &res->data.extended_irq;
 
Index: linux-pm/drivers/pnp/base.h
===================================================================
--- linux-pm.orig/drivers/pnp/base.h
+++ linux-pm/drivers/pnp/base.h
@@ -159,6 +159,8 @@ struct pnp_resource {
 
 void pnp_free_resource(struct pnp_resource *pnp_res);
 
+struct pnp_resource *pnp_add_resource(struct pnp_dev *dev,
+				      struct resource *res);
 struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
 					  int flags);
 struct pnp_resource *pnp_add_dma_resource(struct pnp_dev *dev, int dma,
Index: linux-pm/drivers/pnp/resource.c
===================================================================
--- linux-pm.orig/drivers/pnp/resource.c
+++ linux-pm/drivers/pnp/resource.c
@@ -503,6 +503,22 @@ static struct pnp_resource *pnp_new_reso
 	return pnp_res;
 }
 
+struct pnp_resource *pnp_add_resource(struct pnp_dev *dev,
+				      struct resource *res)
+{
+	struct pnp_resource *pnp_res;
+
+	pnp_res = pnp_new_resource(dev);
+	if (!pnp_res) {
+		dev_err(&dev->dev, "can't add resource %pR\n", res);
+		return NULL;
+	}
+
+	pnp_res->res = *res;
+	dev_dbg(&dev->dev, "%pR\n", res);
+	return pnp_res;
+}
+
 struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
 					  int flags)
 {
Index: linux-pm/drivers/acpi/acpi_platform.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_platform.c
+++ linux-pm/drivers/acpi/acpi_platform.c
@@ -19,76 +19,30 @@
 
 ACPI_MODULE_NAME("platform");
 
-struct resource_info {
-	struct device *dev;
-	struct resource *res;
-	size_t n, cur;
-};
-
-static acpi_status acpi_platform_count_resources(struct acpi_resource *res,
-						 void *data)
+static acpi_status acpi_platform_resource_size(struct acpi_resource *res)
 {
-	struct acpi_resource_extended_irq *acpi_xirq;
-	struct resource_info *ri = data;
-
-	switch (res->type) {
-	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
-	case ACPI_RESOURCE_TYPE_IRQ:
-		ri->n++;
-		break;
-	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
-		acpi_xirq = &res->data.extended_irq;
-		ri->n += acpi_xirq->interrupt_count;
-		break;
-	case ACPI_RESOURCE_TYPE_ADDRESS32:
-		if (res->data.address32.resource_type == ACPI_IO_RANGE)
-			ri->n++;
-		break;
-	}
-
-	return AE_OK;
+	return res->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ ?
+			res->data.extended_irq.interrupt_count : 1;
 }
 
-static acpi_status acpi_platform_add_resources(struct acpi_resource *res,
-					       void *data)
+static acpi_status acpi_platform_add_resource(struct device *dev,
+					      struct acpi_resource *res,
+					      struct resource *resources,
+					      unsigned int count)
 {
-	struct acpi_resource_fixed_memory32 *acpi_mem;
-	struct acpi_resource_address32 *acpi_add32;
 	struct acpi_resource_extended_irq *acpi_xirq;
 	struct acpi_resource_irq *acpi_irq;
-	struct resource_info *ri = data;
-	struct resource *r;
+	struct resource *r = resources + count;
 	int irq, i;
 
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
-
-		if (acpi_add32->resource_type == ACPI_IO_RANGE) {
-			r = &ri->res[ri->cur++];
-			r->start = acpi_add32->minimum;
-			r->end = r->start + acpi_add32->address_length - 1;
-			r->flags = IORESOURCE_IO;
-			dev_dbg(ri->dev, "Address32 %pR\n", r);
-		}
-		break;
+	if (acpi_dev_resource_memory(res, &r)
+	    || acpi_dev_resource_address_space(res, &r))
+		return 1;
 
+	switch (res->type) {
 	case ACPI_RESOURCE_TYPE_IRQ:
 		acpi_irq = &res->data.irq;
-		r = &ri->res[ri->cur++];
-
-		irq = acpi_register_gsi(ri->dev,
+		irq = acpi_register_gsi(dev,
 					acpi_irq->interrupts[0],
 					acpi_irq->triggering,
 					acpi_irq->polarity);
@@ -96,15 +50,13 @@ static acpi_status acpi_platform_add_res
 		r->start = r->end = irq;
 		r->flags = IORESOURCE_IRQ;
 
-		dev_dbg(ri->dev, "IRQ %pR\n", r);
-		break;
+		dev_dbg(dev, "Interrupt %pR\n", r);
+		return 1;
 
 	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
 		acpi_xirq = &res->data.extended_irq;
-
-		for (i = 0; i < acpi_xirq->interrupt_count; i++, ri->cur++) {
-			r = &ri->res[ri->cur];
-			irq = acpi_register_gsi(ri->dev,
+		for (i = 0; i < acpi_xirq->interrupt_count; i++, r++) {
+			irq = acpi_register_gsi(dev,
 						acpi_xirq->interrupts[i],
 						acpi_xirq->triggering,
 						acpi_xirq->polarity);
@@ -112,12 +64,12 @@ static acpi_status acpi_platform_add_res
 			r->start = r->end = irq;
 			r->flags = IORESOURCE_IRQ;
 
-			dev_dbg(ri->dev, "Interrupt %pR\n", r);
+			dev_dbg(dev, "Interrupt %pR\n", r);
 		}
-		break;
+		return i;
 	}
 
-	return AE_OK;
+	return 0;
 }
 
 static acpi_status acpi_platform_get_device_uid(struct acpi_device *adev,
@@ -154,7 +106,9 @@ struct platform_device *acpi_create_plat
 	struct platform_device *pdev = NULL;
 	struct acpi_device *acpi_parent;
 	struct device *parent = NULL;
-	struct resource_info ri;
+	struct acpi_resource_list_entry *entry;
+	struct resource *resources;
+	unsigned int count = 0;
 	acpi_status status;
 	int devid;
 
@@ -170,29 +124,22 @@ struct platform_device *acpi_create_plat
 	memset(&ri, 0, sizeof(ri));
 
 	/* First, count the resources. */
-	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
-				     acpi_platform_count_resources, &ri);
-	if (ACPI_FAILURE(status) || !ri.n)
-		return NULL;
+	list_for_each_entry(entry, &adev->resources, node)
+		count += acpi_platform_resource_size(&entry->resource);
 
 	/* Next, allocate memory for all the resources and populate it. */
-	ri.dev = &adev->dev;
-	ri.res = kzalloc(ri.n * sizeof(struct resource), GFP_KERNEL);
-	if (!ri.res) {
+	resources = kalloc(count * sizeof(struct resource), GFP_KERNEL);
+	if (!resources) {
 		dev_err(&adev->dev,
 			"failed to allocate memory for resources\n");
 		return NULL;
 	}
 
-	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
-				     acpi_platform_add_resources, &ri);
-	if (ACPI_FAILURE(status)) {
-		dev_err(&adev->dev, "failed to walk resources\n");
-		goto out;
-	}
-
-	if (WARN_ON(ri.n != ri.cur))
-		goto out;
+	count = 0;
+	list_for_each_entry(entry, &adev->resources, node)
+		count += acpi_platform_add_resource(&adev->dev,
+						    &entry->resource,
+						    resources, count);
 
 	/*
 	 * If the ACPI node has a parent and that parent has a physical device
@@ -215,7 +162,8 @@ struct platform_device *acpi_create_plat
 		mutex_unlock(&acpi_parent->physical_node_lock);
 	}
 	pdev = platform_device_register_resndata(parent, acpi_device_hid(adev),
-						 devid, ri.res, ri.n, NULL, 0);
+						 devid, resources, count,
+						 NULL, 0);
 	if (IS_ERR(pdev)) {
 		dev_err(&adev->dev, "platform device creation failed: %ld\n",
 			PTR_ERR(pdev));
@@ -226,7 +174,7 @@ struct platform_device *acpi_create_plat
 	}
 
  out:
-	kfree(ri.res);
+	kfree(resources);
 	return pdev;
 }
 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
