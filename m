Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab1FWRW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760Ab1FWRWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:54 -0400
Date: Thu, 23 Jun 2011 13:22:53 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        dz@debian.org, platform-driver-x86@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172252.27638.12084.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 07/35] drivers/char changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/char/i8k.c               |   75 +++++++++---------
 drivers/char/ipmi/ipmi_si_intf.c |  159 +++++++++++++++++++-------------------
 drivers/char/sonypi.c            |   16 ++--
 3 files changed, 125 insertions(+), 125 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 6e40072..f198fac 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -24,7 +24,7 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/capability.h>
 #include <linux/mutex.h>
 #include <linux/hwmon.h>
@@ -73,9 +73,10 @@ static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force loading without checking for supported models");
 
-static int ignore_dmi;
-module_param(ignore_dmi, bool, 0);
-MODULE_PARM_DESC(ignore_dmi, "Continue probing hardware even if DMI data does not match");
+static int ignore_smbios;
+module_param(ignore_smbios, bool, 0);
+MODULE_PARM_DESC(ignore_smbios,
+		"Continue probing hardware even if SMBIOS data does not match");
 
 static int restricted;
 module_param(restricted, bool, 0);
@@ -110,11 +111,11 @@ struct smm_regs {
 	unsigned int edi __attribute__ ((packed));
 };
 
-static inline const char *i8k_get_dmi_data(int field)
+static inline const char *i8k_get_smbios_data(int field)
 {
-	const char *dmi_data = dmi_get_system_info(field);
+	const char *smbios_data = sysfw_lookup(field);
 
-	return dmi_data && *dmi_data ? dmi_data : "?";
+	return smbios_data && *smbios_data ? smbios_data : "?";
 }
 
 /*
@@ -333,7 +334,8 @@ i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 
 	case I8K_MACHINE_ID:
 		memset(buff, 0, 16);
-		strlcpy(buff, i8k_get_dmi_data(DMI_PRODUCT_SERIAL), sizeof(buff));
+		strlcpy(buff, i8k_get_smbios_data(SYSFW_PRODUCT_SERIAL),
+			sizeof(buff));
 		break;
 
 	case I8K_FN_STATUS:
@@ -450,7 +452,7 @@ static int i8k_proc_show(struct seq_file *seq, void *offset)
 	return seq_printf(seq, "%s %s %s %d %d %d %d %d %d %d\n",
 			  I8K_PROC_FMT,
 			  bios_version,
-			  i8k_get_dmi_data(DMI_PRODUCT_SERIAL),
+			  i8k_get_smbios_data(SYSFW_PRODUCT_SERIAL),
 			  cpu_temp,
 			  left_fan, right_fan, left_speed, right_speed,
 			  ac_power, fn_key);
@@ -607,64 +609,64 @@ static void __exit i8k_exit_hwmon(void)
 	hwmon_device_unregister(i8k_hwmon_dev);
 }
 
-static struct dmi_system_id __initdata i8k_dmi_table[] = {
+static struct sysfw_id __initdata i8k_smbios_table[] = {
 	{
 		.ident = "Dell Inspiron",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Computer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron"),
 		},
 	},
 	{
 		.ident = "Dell Latitude",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Computer"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Latitude"),
 		},
 	},
 	{
 		.ident = "Dell Inspiron 2",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Inspiron"),
 		},
 	},
 	{
 		.ident = "Dell Latitude 2",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Latitude"),
 		},
 	},
 	{	/* UK Inspiron 6400  */
 		.ident = "Dell Inspiron 3",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MM061"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MM061"),
 		},
 	},
 	{
 		.ident = "Dell Inspiron 3",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MP061"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MP061"),
 		},
 	},
 	{
 		.ident = "Dell Precision",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Precision"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Precision"),
 		},
 	},
 	{
 		.ident = "Dell Vostro",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Dell Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Vostro"),
 		},
 	},
-        { }
+	{}
 };
 
 /*
@@ -676,20 +678,21 @@ static int __init i8k_probe(void)
 	int version;
 
 	/*
-	 * Get DMI information
+	 * Get SMBIOS information
 	 */
-	if (!dmi_check_system(i8k_dmi_table)) {
-		if (!ignore_dmi && !force)
+	if (!sysfw_callback(i8k_smbios_table)) {
+		if (!ignore_smbios && !force)
 			return -ENODEV;
 
 		printk(KERN_INFO "i8k: not running on a supported Dell system.\n");
 		printk(KERN_INFO "i8k: vendor=%s, model=%s, version=%s\n",
-			i8k_get_dmi_data(DMI_SYS_VENDOR),
-			i8k_get_dmi_data(DMI_PRODUCT_NAME),
-			i8k_get_dmi_data(DMI_BIOS_VERSION));
+			i8k_get_smbios_data(SYSFW_SYS_VENDOR),
+			i8k_get_smbios_data(SYSFW_PRODUCT_NAME),
+			i8k_get_smbios_data(SYSFW_BIOS_VERSION));
 	}
 
-	strlcpy(bios_version, i8k_get_dmi_data(DMI_BIOS_VERSION), sizeof(bios_version));
+	strlcpy(bios_version, i8k_get_smbios_data(SYSFW_BIOS_VERSION),
+		sizeof(bios_version));
 
 	/*
 	 * Get SMM Dell signature
@@ -713,9 +716,9 @@ static int __init i8k_probe(void)
 		buff[2] = (version) & 0xff;
 		buff[3] = '\0';
 		/*
-		 * If DMI BIOS version is unknown use SMM BIOS version.
+		 * If SMBIOS version is unknown use SMM BIOS version.
 		 */
-		if (!dmi_get_system_info(DMI_BIOS_VERSION))
+		if (!sysfw_lookup(SYSFW_BIOS_VERSION))
 			strlcpy(bios_version, buff, sizeof(bios_version));
 
 		/*
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 9397ab4..7c64c3d 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -63,7 +63,7 @@
 #include <asm/io.h>
 #include "ipmi_si_sm.h"
 #include <linux/init.h>
-#include <linux/dmi.h>
+#include <linux/smbios.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/pnp.h>
@@ -273,7 +273,7 @@ struct smi_info {
 	 */
 	int dev_registered;
 
-	/* Slave address, could be reported from DMI. */
+	/* Slave address, could be reported from SMBIOS. */
 	unsigned char slave_addr;
 
 	/* Counters and things for the proc filesystem. */
@@ -2269,8 +2269,7 @@ static struct pnp_driver ipmi_pnp_driver = {
 };
 #endif
 
-#ifdef CONFIG_DMI
-struct dmi_ipmi_data {
+struct smbios_ipmi_data {
 	u8   		type;
 	u8   		addr_space;
 	unsigned long	base_addr;
@@ -2279,69 +2278,7 @@ struct dmi_ipmi_data {
 	u8              slave_addr;
 };
 
-static int __devinit decode_dmi(const struct dmi_header *dm,
-				struct dmi_ipmi_data *dmi)
-{
-	const u8	*data = (const u8 *)dm;
-	unsigned long  	base_addr;
-	u8		reg_spacing;
-	u8              len = dm->length;
-
-	dmi->type = data[4];
-
-	memcpy(&base_addr, data+8, sizeof(unsigned long));
-	if (len >= 0x11) {
-		if (base_addr & 1) {
-			/* I/O */
-			base_addr &= 0xFFFE;
-			dmi->addr_space = IPMI_IO_ADDR_SPACE;
-		} else
-			/* Memory */
-			dmi->addr_space = IPMI_MEM_ADDR_SPACE;
-
-		/* If bit 4 of byte 0x10 is set, then the lsb for the address
-		   is odd. */
-		dmi->base_addr = base_addr | ((data[0x10] & 0x10) >> 4);
-
-		dmi->irq = data[0x11];
-
-		/* The top two bits of byte 0x10 hold the register spacing. */
-		reg_spacing = (data[0x10] & 0xC0) >> 6;
-		switch (reg_spacing) {
-		case 0x00: /* Byte boundaries */
-		    dmi->offset = 1;
-		    break;
-		case 0x01: /* 32-bit boundaries */
-		    dmi->offset = 4;
-		    break;
-		case 0x02: /* 16-byte boundaries */
-		    dmi->offset = 16;
-		    break;
-		default:
-		    /* Some other interface, just ignore it. */
-		    return -EIO;
-		}
-	} else {
-		/* Old DMI spec. */
-		/*
-		 * Note that technically, the lower bit of the base
-		 * address should be 1 if the address is I/O and 0 if
-		 * the address is in memory.  So many systems get that
-		 * wrong (and all that I have seen are I/O) so we just
-		 * ignore that bit and assume I/O.  Systems that use
-		 * memory should use the newer spec, anyway.
-		 */
-		dmi->base_addr = base_addr & 0xfffe;
-		dmi->addr_space = IPMI_IO_ADDR_SPACE;
-		dmi->offset = 1;
-	}
-
-	dmi->slave_addr = data[6];
-
-	return 0;
-}
-
-static void __devinit try_init_dmi(struct dmi_ipmi_data *ipmi_data)
+static void __devinit try_init_smbios(struct smbios_ipmi_data *ipmi_data)
 {
 	struct smi_info *info;
 
@@ -2409,21 +2346,83 @@ static void __devinit try_init_dmi(struct dmi_ipmi_data *ipmi_data)
 		kfree(info);
 }
 
-static void __devinit dmi_find_bmc(void)
+/* XXX: This code doesn't use the smbios_struct laid out for IPMI.  It should
+ * be investigated to see if this code even works */
+static int __devinit decode_smbios(const union smbios_struct *ss,
+				   void *smbios_data)
 {
-	const struct dmi_device *dev = NULL;
-	struct dmi_ipmi_data data;
-	int                  rv;
+	const u8	*data = (const u8 *)ss;
+	unsigned long	base_addr;
+	u8		reg_spacing;
+	u8		len = ss->header.length;
+	struct		smbios_ipmi_data *smbios = smbios_data;
 
-	while ((dev = dmi_find_device(DMI_DEV_TYPE_IPMI, NULL, dev))) {
-		memset(&data, 0, sizeof(data));
-		rv = decode_dmi((const struct dmi_header *) dev->device_data,
-				&data);
-		if (!rv)
-			try_init_dmi(&data);
+	if (ss->header.type != 38)
+		return SMBIOS_WALK_CONTINUE;
+
+	smbios->type = data[4];
+
+	memcpy(&base_addr, data+8, sizeof(unsigned long));
+	if (len >= 0x11) {
+		if (base_addr & 1) {
+			/* I/O */
+			base_addr &= 0xFFFE;
+			smbios->addr_space = IPMI_IO_ADDR_SPACE;
+		} else
+			/* Memory */
+			smbios->addr_space = IPMI_MEM_ADDR_SPACE;
+
+		/* If bit 4 of byte 0x10 is set, then the lsb for the address
+		   is odd. */
+		smbios->base_addr = base_addr | ((data[0x10] & 0x10) >> 4);
+
+		smbios->irq = data[0x11];
+
+		/* The top two bits of byte 0x10 hold the register spacing. */
+		reg_spacing = (data[0x10] & 0xC0) >> 6;
+		switch (reg_spacing) {
+		case 0x00: /* Byte boundaries */
+		    smbios->offset = 1;
+		    break;
+		case 0x01: /* 32-bit boundaries */
+		    smbios->offset = 3;
+		    break;
+		case 0x02: /* 16-byte boundaries */
+		    smbios->offset = 16;
+		    break;
+		default:
+		    /* Some other interface, just ignore it. */
+		    return SMBIOS_WALK_CONTINUE;
+		}
+	} else {
+		/* Old SMBIOS spec. */
+		/*
+		 * Note that technically, the lower bit of the base
+		 * address should be 1 if the address is I/O and 0 if
+		 * the address is in memory.  So many systems get that
+		 * wrong (and all that I have seen are I/O) so we just
+		 * ignore that bit and assume I/O.  Systems that use
+		 * memory should use the newer spec, anyway.
+		 */
+		smbios->base_addr = base_addr & 0xfffe;
+		smbios->addr_space = IPMI_IO_ADDR_SPACE;
+		smbios->offset = 1;
 	}
+
+	smbios->slave_addr = data[6];
+
+	try_init_smbios(smbios);
+
+	return SMBIOS_WALK_STOP;
+}
+
+
+static void __devinit smbios_find_bmc(void)
+{
+	struct smbios_ipmi_data data;
+
+	smbios_walk(decode_smbios, &data);
 }
-#endif /* CONFIG_DMI */
 
 #ifdef CONFIG_PCI
 
@@ -3417,9 +3416,7 @@ static int __devinit init_ipmi_si(void)
 	pnp_registered = 1;
 #endif
 
-#ifdef CONFIG_DMI
-	dmi_find_bmc();
-#endif
+	smbios_find_bmc();
 
 #ifdef CONFIG_ACPI
 	spmi_find_bmc();
diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 1ee8ce7..4a50ebd 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -46,11 +46,11 @@
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include <linux/acpi.h>
-#include <linux/dmi.h>
 #include <linux/err.h>
 #include <linux/kfifo.h>
 #include <linux/platform_device.h>
 #include <linux/gfp.h>
+#include <linux/sysfw.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -1497,22 +1497,22 @@ static struct platform_driver sonypi_driver = {
 
 static struct platform_device *sonypi_platform_device;
 
-static struct dmi_system_id __initdata sonypi_dmi_table[] = {
+static struct sysfw_id __initdata sonypi_smbios_table[] = {
 	{
 		.ident = "Sony Vaio",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PCG-"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "PCG-"),
 		},
 	},
 	{
 		.ident = "Sony Vaio",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Sony Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "VGN-"),
 		},
 	},
-	{ }
+	{}
 };
 
 static int __init sonypi_init(void)
@@ -1523,7 +1523,7 @@ static int __init sonypi_init(void)
 		"sonypi: Sony Programmable I/O Controller Driver v%s.\n",
 		SONYPI_DRIVER_VERSION);
 
-	if (!dmi_check_system(sonypi_dmi_table))
+	if (!sysfw_callback(sonypi_smbios_table))
 		return -ENODEV;
 
 	error = platform_driver_register(&sonypi_driver);
-- 
1.7.5.4

