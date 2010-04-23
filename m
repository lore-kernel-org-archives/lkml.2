Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0DWIGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:06:13 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:48716 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab0DWIFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:05:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 03/14] m68k: amiga - Zorro host bridge platform device conversion
Date: Fri, 23 Apr 2010 10:00:24 +0200
Message-Id: <1272009635-6504-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272009635-6504-3-git-send-email-geert@linux-m68k.org>
References: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-3-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/Makefile   |    2 +-
 arch/m68k/amiga/platform.c |   58 +++++++++++
 drivers/zorro/proc.c       |    6 +-
 drivers/zorro/zorro.c      |  243 +++++++++++++++++++++++---------------------
 include/linux/zorro.h      |    9 --
 5 files changed, 190 insertions(+), 128 deletions(-)
 create mode 100644 arch/m68k/amiga/platform.c

diff --git a/arch/m68k/amiga/Makefile b/arch/m68k/amiga/Makefile
index 6a0d765..11dd30b 100644
--- a/arch/m68k/amiga/Makefile
+++ b/arch/m68k/amiga/Makefile
@@ -2,6 +2,6 @@
 # Makefile for Linux arch/m68k/amiga source directory
 #
 
-obj-y		:= config.o amiints.o cia.o chipram.o amisound.o
+obj-y		:= config.o amiints.o cia.o chipram.o amisound.o platform.o
 
 obj-$(CONFIG_AMIGA_PCMCIA)	+= pcmcia.o
diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
new file mode 100644
index 0000000..33a7669
--- /dev/null
+++ b/arch/m68k/amiga/platform.c
@@ -0,0 +1,58 @@
+/*
+ *  Copyright (C) 2007-2009 Geert Uytterhoeven
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/zorro.h>
+
+#include <asm/amigahw.h>
+
+
+#ifdef CONFIG_ZORRO
+
+static const struct resource zorro_resources[] __initconst = {
+	/* Zorro II regions (on Zorro II/III) */
+	{
+		.name	= "Zorro II exp",
+		.start	= 0x00e80000,
+		.end	= 0x00efffff,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name	= "Zorro II mem",
+		.start	= 0x00200000,
+		.end	= 0x009fffff,
+		.flags	= IORESOURCE_MEM,
+	},
+	/* Zorro III regions (on Zorro III only) */
+	{
+		.name	= "Zorro III exp",
+		.start	= 0xff000000,
+		.end	= 0xffffffff,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name	= "Zorro III cfg",
+		.start	= 0x40000000,
+		.end	= 0x7fffffff,
+		.flags	= IORESOURCE_MEM,
+	}
+};
+
+
+static int __init amiga_init_bus(void)
+{
+	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(ZORRO))
+		return -ENODEV;
+
+	platform_device_register_simple("amiga-zorro", -1, zorro_resources,
+					AMIGAHW_PRESENT(ZORRO3) ? 4 : 2);
+	return 0;
+}
+
+subsys_initcall(amiga_init_bus);
+
+#endif /* CONFIG_ZORRO */
diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index d47c47f..3c7046d 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -97,7 +97,7 @@ static void zorro_seq_stop(struct seq_file *m, void *v)
 
 static int zorro_seq_show(struct seq_file *m, void *v)
 {
-	u_int slot = *(loff_t *)v;
+	unsigned int slot = *(loff_t *)v;
 	struct zorro_dev *z = &zorro_autocon[slot];
 
 	seq_printf(m, "%02x\t%08x\t%08lx\t%08lx\t%02x\n", slot, z->id,
@@ -129,7 +129,7 @@ static const struct file_operations zorro_devices_proc_fops = {
 
 static struct proc_dir_entry *proc_bus_zorro_dir;
 
-static int __init zorro_proc_attach_device(u_int slot)
+static int __init zorro_proc_attach_device(unsigned int slot)
 {
 	struct proc_dir_entry *entry;
 	char name[4];
@@ -146,7 +146,7 @@ static int __init zorro_proc_attach_device(u_int slot)
 
 static int __init zorro_proc_init(void)
 {
-	u_int slot;
+	unsigned int slot;
 
 	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(ZORRO)) {
 		proc_bus_zorro_dir = proc_mkdir("bus/zorro", NULL);
diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
index d45fb34..6455f3a 100644
--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -15,6 +15,8 @@
 #include <linux/zorro.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
 
 #include <asm/setup.h>
 #include <asm/amigahw.h>
@@ -26,24 +28,17 @@
      *  Zorro Expansion Devices
      */
 
-u_int zorro_num_autocon = 0;
+unsigned int zorro_num_autocon;
 struct zorro_dev zorro_autocon[ZORRO_NUM_AUTO];
 
 
     /*
-     *  Single Zorro bus
+     *  Zorro bus
      */
 
-struct zorro_bus zorro_bus = {\
-    .resources = {
-	/* Zorro II regions (on Zorro II/III) */
-	{ .name = "Zorro II exp", .start = 0x00e80000, .end = 0x00efffff },
-	{ .name = "Zorro II mem", .start = 0x00200000, .end = 0x009fffff },
-	/* Zorro III regions (on Zorro III only) */
-	{ .name = "Zorro III exp", .start = 0xff000000, .end = 0xffffffff },
-	{ .name = "Zorro III cfg", .start = 0x40000000, .end = 0x7fffffff }
-    },
-    .name = "Zorro bus"
+struct zorro_bus {
+	struct list_head devices;	/* list of devices on this bus */
+	struct device dev;
 };
 
 
@@ -53,18 +48,19 @@ struct zorro_bus zorro_bus = {\
 
 struct zorro_dev *zorro_find_device(zorro_id id, struct zorro_dev *from)
 {
-    struct zorro_dev *z;
+	struct zorro_dev *z;
 
-    if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(ZORRO))
-	return NULL;
+	if (!zorro_num_autocon)
+		return NULL;
 
-    for (z = from ? from+1 : &zorro_autocon[0];
-	 z < zorro_autocon+zorro_num_autocon;
-	 z++)
-	if (id == ZORRO_WILDCARD || id == z->id)
-	    return z;
-    return NULL;
+	for (z = from ? from+1 : &zorro_autocon[0];
+	     z < zorro_autocon+zorro_num_autocon;
+	     z++)
+		if (id == ZORRO_WILDCARD || id == z->id)
+			return z;
+	return NULL;
 }
+EXPORT_SYMBOL(zorro_find_device);
 
 
     /*
@@ -83,121 +79,138 @@ struct zorro_dev *zorro_find_device(zorro_id id, struct zorro_dev *from)
      */
 
 DECLARE_BITMAP(zorro_unused_z2ram, 128);
+EXPORT_SYMBOL(zorro_unused_z2ram);
 
 
 static void __init mark_region(unsigned long start, unsigned long end,
 			       int flag)
 {
-    if (flag)
-	start += Z2RAM_CHUNKMASK;
-    else
-	end += Z2RAM_CHUNKMASK;
-    start &= ~Z2RAM_CHUNKMASK;
-    end &= ~Z2RAM_CHUNKMASK;
-
-    if (end <= Z2RAM_START || start >= Z2RAM_END)
-	return;
-    start = start < Z2RAM_START ? 0x00000000 : start-Z2RAM_START;
-    end = end > Z2RAM_END ? Z2RAM_SIZE : end-Z2RAM_START;
-    while (start < end) {
-	u32 chunk = start>>Z2RAM_CHUNKSHIFT;
 	if (flag)
-	    set_bit(chunk, zorro_unused_z2ram);
+		start += Z2RAM_CHUNKMASK;
 	else
-	    clear_bit(chunk, zorro_unused_z2ram);
-	start += Z2RAM_CHUNKSIZE;
-    }
+		end += Z2RAM_CHUNKMASK;
+	start &= ~Z2RAM_CHUNKMASK;
+	end &= ~Z2RAM_CHUNKMASK;
+
+	if (end <= Z2RAM_START || start >= Z2RAM_END)
+		return;
+	start = start < Z2RAM_START ? 0x00000000 : start-Z2RAM_START;
+	end = end > Z2RAM_END ? Z2RAM_SIZE : end-Z2RAM_START;
+	while (start < end) {
+		u32 chunk = start>>Z2RAM_CHUNKSHIFT;
+		if (flag)
+			set_bit(chunk, zorro_unused_z2ram);
+		else
+			clear_bit(chunk, zorro_unused_z2ram);
+		start += Z2RAM_CHUNKSIZE;
+	}
 }
 
 
-static struct resource __init *zorro_find_parent_resource(struct zorro_dev *z)
+static struct resource __init *zorro_find_parent_resource(
+	struct platform_device *bridge, struct zorro_dev *z)
 {
-    int i;
+	int i;
 
-    for (i = 0; i < zorro_bus.num_resources; i++)
-	if (zorro_resource_start(z) >= zorro_bus.resources[i].start &&
-	    zorro_resource_end(z) <= zorro_bus.resources[i].end)
-		return &zorro_bus.resources[i];
-    return &iomem_resource;
+	for (i = 0; i < bridge->num_resources; i++) {
+		struct resource *r = &bridge->resource[i];
+		if (zorro_resource_start(z) >= r->start &&
+		    zorro_resource_end(z) <= r->end)
+			return r;
+	}
+	return &iomem_resource;
 }
 
 
-    /*
-     *  Initialization
-     */
 
-static int __init zorro_init(void)
+static int __init amiga_zorro_probe(struct platform_device *pdev)
 {
-    struct zorro_dev *z;
-    unsigned int i;
-    int error;
-
-    if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(ZORRO))
-	return 0;
-
-    pr_info("Zorro: Probing AutoConfig expansion devices: %d device%s\n",
-	   zorro_num_autocon, zorro_num_autocon == 1 ? "" : "s");
-
-    /* Initialize the Zorro bus */
-    INIT_LIST_HEAD(&zorro_bus.devices);
-    dev_set_name(&zorro_bus.dev, "zorro");
-    error = device_register(&zorro_bus.dev);
-    if (error) {
-	pr_err("Zorro: Error registering zorro_bus\n");
-	return error;
-    }
-
-    /* Request the resources */
-    zorro_bus.num_resources = AMIGAHW_PRESENT(ZORRO3) ? 4 : 2;
-    for (i = 0; i < zorro_bus.num_resources; i++)
-	request_resource(&iomem_resource, &zorro_bus.resources[i]);
-
-    /* Register all devices */
-    for (i = 0; i < zorro_num_autocon; i++) {
-	z = &zorro_autocon[i];
-	z->id = (z->rom.er_Manufacturer<<16) | (z->rom.er_Product<<8);
-	if (z->id == ZORRO_PROD_GVP_EPC_BASE) {
-	    /* GVP quirk */
-	    unsigned long magic = zorro_resource_start(z)+0x8000;
-	    z->id |= *(u16 *)ZTWO_VADDR(magic) & GVP_PRODMASK;
-	}
-	sprintf(z->name, "Zorro device %08x", z->id);
-	zorro_name_device(z);
-	z->resource.name = z->name;
-	if (request_resource(zorro_find_parent_resource(z), &z->resource))
-	    pr_err("Zorro: Address space collision on device %s %pR\n",
-		   z->name, &z->resource);
-	dev_set_name(&z->dev, "%02x", i);
-	z->dev.parent = &zorro_bus.dev;
-	z->dev.bus = &zorro_bus_type;
-	error = device_register(&z->dev);
+	struct zorro_bus *bus;
+	struct zorro_dev *z;
+	struct resource *r;
+	unsigned int i;
+	int error;
+
+	/* Initialize the Zorro bus */
+	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
+	if (!bus)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&bus->devices);
+	bus->dev.parent = &pdev->dev;
+	dev_set_name(&bus->dev, "zorro");
+	error = device_register(&bus->dev);
 	if (error) {
-	    pr_err("Zorro: Error registering device %s\n", z->name);
-	    continue;
+		pr_err("Zorro: Error registering zorro_bus\n");
+		kfree(bus);
+		return error;
 	}
-	error = zorro_create_sysfs_dev_files(z);
-	if (error)
-	    dev_err(&z->dev, "Error creating sysfs files\n");
-    }
-
-    /* Mark all available Zorro II memory */
-    zorro_for_each_dev(z) {
-	if (z->rom.er_Type & ERTF_MEMLIST)
-	    mark_region(zorro_resource_start(z), zorro_resource_end(z)+1, 1);
-    }
-
-    /* Unmark all used Zorro II memory */
-    for (i = 0; i < m68k_num_memory; i++)
-	if (m68k_memory[i].addr < 16*1024*1024)
-	    mark_region(m68k_memory[i].addr,
-			m68k_memory[i].addr+m68k_memory[i].size, 0);
-
-    return 0;
+	platform_set_drvdata(pdev, bus);
+
+	/* Register all devices */
+	pr_info("Zorro: Probing AutoConfig expansion devices: %u device%s\n",
+		 zorro_num_autocon, zorro_num_autocon == 1 ? "" : "s");
+
+	for (i = 0; i < zorro_num_autocon; i++) {
+		z = &zorro_autocon[i];
+		z->id = (z->rom.er_Manufacturer<<16) | (z->rom.er_Product<<8);
+		if (z->id == ZORRO_PROD_GVP_EPC_BASE) {
+			/* GVP quirk */
+			unsigned long magic = zorro_resource_start(z)+0x8000;
+			z->id |= *(u16 *)ZTWO_VADDR(magic) & GVP_PRODMASK;
+		}
+		sprintf(z->name, "Zorro device %08x", z->id);
+		zorro_name_device(z);
+		z->resource.name = z->name;
+		r = zorro_find_parent_resource(pdev, z);
+		error = request_resource(r, &z->resource);
+		if (error)
+			dev_err(&bus->dev,
+				"Address space collision on device %s %pR\n",
+				z->name, &z->resource);
+		dev_set_name(&z->dev, "%02x", i);
+		z->dev.parent = &bus->dev;
+		z->dev.bus = &zorro_bus_type;
+		error = device_register(&z->dev);
+		if (error) {
+			dev_err(&bus->dev, "Error registering device %s\n",
+				z->name);
+			continue;
+		}
+		error = zorro_create_sysfs_dev_files(z);
+		if (error)
+			dev_err(&z->dev, "Error creating sysfs files\n");
+	}
+
+	/* Mark all available Zorro II memory */
+	zorro_for_each_dev(z) {
+		if (z->rom.er_Type & ERTF_MEMLIST)
+			mark_region(zorro_resource_start(z),
+				    zorro_resource_end(z)+1, 1);
+	}
+
+	/* Unmark all used Zorro II memory */
+	for (i = 0; i < m68k_num_memory; i++)
+		if (m68k_memory[i].addr < 16*1024*1024)
+			mark_region(m68k_memory[i].addr,
+				    m68k_memory[i].addr+m68k_memory[i].size,
+				    0);
+
+	return 0;
 }
 
-subsys_initcall(zorro_init);
+static struct platform_driver amiga_zorro_driver = {
+	.driver   = {
+		.name	= "amiga-zorro",
+		.owner	= THIS_MODULE,
+	},
+};
 
-EXPORT_SYMBOL(zorro_find_device);
-EXPORT_SYMBOL(zorro_unused_z2ram);
+static int __init amiga_zorro_init(void)
+{
+	return platform_driver_probe(&amiga_zorro_driver, amiga_zorro_probe);
+}
+
+module_init(amiga_zorro_init);
 
 MODULE_LICENSE("GPL");
diff --git a/include/linux/zorro.h b/include/linux/zorro.h
index 908db1b..7bf9db5 100644
--- a/include/linux/zorro.h
+++ b/include/linux/zorro.h
@@ -141,15 +141,6 @@ struct zorro_dev {
      *  Zorro bus
      */
 
-struct zorro_bus {
-    struct list_head devices;		/* list of devices on this bus */
-    unsigned int num_resources;		/* number of resources */
-    struct resource resources[4];	/* address space routed to this bus */
-    struct device dev;
-    char name[10];
-};
-
-extern struct zorro_bus zorro_bus;	/* single Zorro bus */
 extern struct bus_type zorro_bus_type;
 
 
-- 
1.6.0.4

