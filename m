Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab1FWRY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:24:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933000Ab1FWRYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:24:21 -0400
Date: Thu, 23 Jun 2011 13:24:20 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172420.27716.28054.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 21/35] drivers/pci changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/pci changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables
- add exactmatch functionality

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/pci/dmar.c                |   14 ++--
 drivers/pci/hotplug/cpqphp.h      |   81 +--------------
 drivers/pci/hotplug/cpqphp_core.c |  207 +++++--------------------------------
 drivers/pci/intel-iommu.c         |   20 ++--
 drivers/pci/pci-label.c           |   82 +++++++--------
 drivers/pci/pci.h                 |    2 +-
 drivers/pci/pcie/portdrv_pci.c    |   26 +++---
 drivers/pci/quirks.c              |   29 ++++-
 8 files changed, 120 insertions(+), 341 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 3dc9bef..1f8352a 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -34,7 +34,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/tboot.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/slab.h>
 #include <asm/iommu_table.h>
 
@@ -367,9 +367,9 @@ dmar_parse_one_rhsa(struct acpi_dmar_header *header)
 		"Your BIOS is broken; RHSA refers to non-existent DMAR unit at %llx\n"
 		"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
 		drhd->reg_base_addr,
-		dmi_get_system_info(DMI_BIOS_VENDOR),
-		dmi_get_system_info(DMI_BIOS_VERSION),
-		dmi_get_system_info(DMI_PRODUCT_VERSION));
+		sysfw_lookup(SYSFW_BIOS_VENDOR),
+		sysfw_lookup(SYSFW_BIOS_VERSION),
+		sysfw_lookup(SYSFW_PRODUCT_VERSION));
 
 	return 0;
 }
@@ -629,9 +629,9 @@ static void warn_invalid_dmar(u64 addr, const char *message)
 		"Your BIOS is broken; DMAR reported at address %llx%s!\n"
 		"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
 		addr, message,
-		dmi_get_system_info(DMI_BIOS_VENDOR),
-		dmi_get_system_info(DMI_BIOS_VERSION),
-		dmi_get_system_info(DMI_PRODUCT_VERSION));
+		sysfw_lookup(SYSFW_BIOS_VENDOR),
+		sysfw_lookup(SYSFW_BIOS_VERSION),
+		sysfw_lookup(SYSFW_PRODUCT_VERSION));
 }
 
 int __init check_zero_address(void)
diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index d8ffc73..6af1de3 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -33,6 +33,7 @@
 #include <linux/delay.h>	/* for delays */
 #include <linux/mutex.h>
 #include <linux/sched.h>	/* for signal_pending() */
+#include <linux/smbios.h>
 
 #define MY_NAME	"cpqphp"
 
@@ -41,84 +42,6 @@
 #define info(format, arg...) printk(KERN_INFO "%s: " format , MY_NAME , ## arg)
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format , MY_NAME , ## arg)
 
-
-
-struct smbios_system_slot {
-	u8 type;
-	u8 length;
-	u16 handle;
-	u8 name_string_num;
-	u8 slot_type;
-	u8 slot_width;
-	u8 slot_current_usage;
-	u8 slot_length;
-	u16 slot_number;
-	u8 properties1;
-	u8 properties2;
-} __attribute__ ((packed));
-
-/* offsets to the smbios generic type based on the above structure layout */
-enum smbios_system_slot_offsets {
-	SMBIOS_SLOT_GENERIC_TYPE =	offsetof(struct smbios_system_slot, type),
-	SMBIOS_SLOT_GENERIC_LENGTH =	offsetof(struct smbios_system_slot, length),
-	SMBIOS_SLOT_GENERIC_HANDLE =	offsetof(struct smbios_system_slot, handle),
-	SMBIOS_SLOT_NAME_STRING_NUM =	offsetof(struct smbios_system_slot, name_string_num),
-	SMBIOS_SLOT_TYPE =		offsetof(struct smbios_system_slot, slot_type),
-	SMBIOS_SLOT_WIDTH =		offsetof(struct smbios_system_slot, slot_width),
-	SMBIOS_SLOT_CURRENT_USAGE =	offsetof(struct smbios_system_slot, slot_current_usage),
-	SMBIOS_SLOT_LENGTH =		offsetof(struct smbios_system_slot, slot_length),
-	SMBIOS_SLOT_NUMBER =		offsetof(struct smbios_system_slot, slot_number),
-	SMBIOS_SLOT_PROPERTIES1 =	offsetof(struct smbios_system_slot, properties1),
-	SMBIOS_SLOT_PROPERTIES2 =	offsetof(struct smbios_system_slot, properties2),
-};
-
-struct smbios_generic {
-	u8 type;
-	u8 length;
-	u16 handle;
-} __attribute__ ((packed));
-
-/* offsets to the smbios generic type based on the above structure layout */
-enum smbios_generic_offsets {
-	SMBIOS_GENERIC_TYPE =	offsetof(struct smbios_generic, type),
-	SMBIOS_GENERIC_LENGTH =	offsetof(struct smbios_generic, length),
-	SMBIOS_GENERIC_HANDLE =	offsetof(struct smbios_generic, handle),
-};
-
-struct smbios_entry_point {
-	char anchor[4];
-	u8 ep_checksum;
-	u8 ep_length;
-	u8 major_version;
-	u8 minor_version;
-	u16 max_size_entry;
-	u8 ep_rev;
-	u8 reserved[5];
-	char int_anchor[5];
-	u8 int_checksum;
-	u16 st_length;
-	u32 st_address;
-	u16 number_of_entrys;
-	u8 bcd_rev;
-} __attribute__ ((packed));
-
-/* offsets to the smbios entry point based on the above structure layout */
-enum smbios_entry_point_offsets {
-	ANCHOR =		offsetof(struct smbios_entry_point, anchor[0]),
-	EP_CHECKSUM =		offsetof(struct smbios_entry_point, ep_checksum),
-	EP_LENGTH =		offsetof(struct smbios_entry_point, ep_length),
-	MAJOR_VERSION =		offsetof(struct smbios_entry_point, major_version),
-	MINOR_VERSION =		offsetof(struct smbios_entry_point, minor_version),
-	MAX_SIZE_ENTRY =	offsetof(struct smbios_entry_point, max_size_entry),
-	EP_REV =		offsetof(struct smbios_entry_point, ep_rev),
-	INT_ANCHOR =		offsetof(struct smbios_entry_point, int_anchor[0]),
-	INT_CHECKSUM =		offsetof(struct smbios_entry_point, int_checksum),
-	ST_LENGTH =		offsetof(struct smbios_entry_point, st_length),
-	ST_ADDRESS =		offsetof(struct smbios_entry_point, st_address),
-	NUMBER_OF_ENTRYS =	offsetof(struct smbios_entry_point, number_of_entrys),
-	BCD_REV =		offsetof(struct smbios_entry_point, bcd_rev),
-};
-
 struct ctrl_reg {			/* offset */
 	u8	slot_RST;		/* 0x00 */
 	u8	slot_enable;		/* 0x01 */
@@ -273,7 +196,7 @@ struct slot {
 	struct timer_list task_event;
 	u8 hp_slot;
 	struct controller *ctrl;
-	void __iomem *p_sm_slot;
+	const union smbios_struct *ss;
 	struct hotplug_slot *hotplug_slot;
 };
 
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index 4952c3b..70bb361 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -39,6 +39,7 @@
 #include <linux/pci_hotplug.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/sysfw.h>
 
 #include <asm/uaccess.h>
 
@@ -54,8 +55,6 @@ struct pci_func *cpqhp_slot_list[256];
 struct irq_routing_table *cpqhp_routing_table;
 
 /* local variables */
-static void __iomem *smbios_table;
-static void __iomem *smbios_start;
 static void __iomem *cpqhp_rom_start;
 static int power_mode;
 static int debug;
@@ -79,50 +78,12 @@ MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
 
 static inline int is_slot64bit(struct slot *slot)
 {
-	return (readb(slot->p_sm_slot + SMBIOS_SLOT_WIDTH) == 0x06) ? 1 : 0;
+	return (slot->ss->type9.slot_data_bus_width == 0x06) ? 1 : 0;
 }
 
 static inline int is_slot66mhz(struct slot *slot)
 {
-	return (readb(slot->p_sm_slot + SMBIOS_SLOT_TYPE) == 0x0E) ? 1 : 0;
-}
-
-/**
- * detect_SMBIOS_pointer - find the System Management BIOS Table in mem region.
- * @begin: begin pointer for region to be scanned.
- * @end: end pointer for region to be scanned.
- *
- * Returns pointer to the head of the SMBIOS tables (or %NULL).
- */
-static void __iomem * detect_SMBIOS_pointer(void __iomem *begin, void __iomem *end)
-{
-	void __iomem *fp;
-	void __iomem *endp;
-	u8 temp1, temp2, temp3, temp4;
-	int status = 0;
-
-	endp = (end - sizeof(u32) + 1);
-
-	for (fp = begin; fp <= endp; fp += 16) {
-		temp1 = readb(fp);
-		temp2 = readb(fp+1);
-		temp3 = readb(fp+2);
-		temp4 = readb(fp+3);
-		if (temp1 == '_' &&
-		    temp2 == 'S' &&
-		    temp3 == 'M' &&
-		    temp4 == '_') {
-			status = 1;
-			break;
-		}
-	}
-
-	if (!status)
-		fp = NULL;
-
-	dbg("Discovered SMBIOS Entry point at %p\n", fp);
-
-	return fp;
+	return (slot->ss->type9.slot_type == 0x0E) ? 1 : 0;
 }
 
 /**
@@ -192,94 +153,6 @@ static void pci_print_IRQ_route(void)
 	return;
 }
 
-
-/**
- * get_subsequent_smbios_entry: get the next entry from bios table.
- * @smbios_start: where to start in the SMBIOS table
- * @smbios_table: location of the SMBIOS table
- * @curr: %NULL or pointer to previously returned structure
- *
- * Gets the first entry if previous == NULL;
- * otherwise, returns the next entry.
- * Uses global SMBIOS Table pointer.
- *
- * Returns a pointer to an SMBIOS structure or NULL if none found.
- */
-static void __iomem *get_subsequent_smbios_entry(void __iomem *smbios_start,
-						void __iomem *smbios_table,
-						void __iomem *curr)
-{
-	u8 bail = 0;
-	u8 previous_byte = 1;
-	void __iomem *p_temp;
-	void __iomem *p_max;
-
-	if (!smbios_table || !curr)
-		return NULL;
-
-	/* set p_max to the end of the table */
-	p_max = smbios_start + readw(smbios_table + ST_LENGTH);
-
-	p_temp = curr;
-	p_temp += readb(curr + SMBIOS_GENERIC_LENGTH);
-
-	while ((p_temp < p_max) && !bail) {
-		/* Look for the double NULL terminator
-		 * The first condition is the previous byte
-		 * and the second is the curr
-		 */
-		if (!previous_byte && !(readb(p_temp)))
-			bail = 1;
-
-		previous_byte = readb(p_temp);
-		p_temp++;
-	}
-
-	if (p_temp < p_max)
-		return p_temp;
-	else
-		return NULL;
-}
-
-
-/**
- * get_SMBIOS_entry - return the requested SMBIOS entry or %NULL
- * @smbios_start: where to start in the SMBIOS table
- * @smbios_table: location of the SMBIOS table
- * @type: SMBIOS structure type to be returned
- * @previous: %NULL or pointer to previously returned structure
- *
- * Gets the first entry of the specified type if previous == %NULL;
- * Otherwise, returns the next entry of the given type.
- * Uses global SMBIOS Table pointer.
- * Uses get_subsequent_smbios_entry.
- *
- * Returns a pointer to an SMBIOS structure or %NULL if none found.
- */
-static void __iomem *get_SMBIOS_entry(void __iomem *smbios_start,
-					void __iomem *smbios_table,
-					u8 type,
-					void __iomem *previous)
-{
-	if (!smbios_table)
-		return NULL;
-
-	if (!previous)
-		previous = smbios_start;
-	else
-		previous = get_subsequent_smbios_entry(smbios_start,
-					smbios_table, previous);
-
-	while (previous)
-		if (readb(previous + SMBIOS_GENERIC_TYPE) != type)
-			previous = get_subsequent_smbios_entry(smbios_start,
-						smbios_table, previous);
-		else
-			break;
-
-	return previous;
-}
-
 static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
@@ -596,9 +469,26 @@ static struct hotplug_slot_ops cpqphp_hotplug_slot_ops = {
 
 #define SLOT_NAME_SIZE 10
 
-static int ctrl_slot_setup(struct controller *ctrl,
-			void __iomem *smbios_start,
-			void __iomem *smbios_table)
+static int cpqphp_find_smbios_slot(const union smbios_struct *ss, void *data)
+{
+	struct slot *slot = data;
+
+	/* Don't do anything if an SMBIOS struct has already been found */
+	if (slot->ss)
+		return SMBIOS_WALK_CONTINUE;
+
+	if (ss->header.type != 9)
+		return SMBIOS_WALK_CONTINUE;
+
+	if (slot->number == ss->type9.slot_id) {
+		slot->ss = ss;
+		return SMBIOS_WALK_STOP;
+	}
+
+	return SMBIOS_WALK_CONTINUE;
+}
+
+static int ctrl_slot_setup(struct controller *ctrl)
 {
 	struct slot *slot;
 	struct hotplug_slot *hotplug_slot;
@@ -610,7 +500,6 @@ static int ctrl_slot_setup(struct controller *ctrl,
 	u8 ctrl_slot;
 	u32 tempdword;
 	char name[SLOT_NAME_SIZE];
-	void __iomem *slot_entry= NULL;
 	int result = -ENOMEM;
 
 	dbg("%s\n", __func__);
@@ -644,16 +533,8 @@ static int ctrl_slot_setup(struct controller *ctrl,
 		slot->number = slot_number;
 		dbg("slot->number = %u\n", slot->number);
 
-		slot_entry = get_SMBIOS_entry(smbios_start, smbios_table, 9,
-					slot_entry);
-
-		while (slot_entry && (readw(slot_entry + SMBIOS_SLOT_NUMBER) !=
-				slot->number)) {
-			slot_entry = get_SMBIOS_entry(smbios_start,
-						smbios_table, 9, slot_entry);
-		}
-
-		slot->p_sm_slot = slot_entry;
+		/* match SMBIOS slot information */
+		smbios_walk(cpqphp_find_smbios_slot, slot);
 
 		init_timer(&slot->task_event);
 		slot->task_event.expires = jiffies + 5 * HZ;
@@ -764,44 +645,14 @@ static int one_time_init(void)
 	 * this also needs to be worked with Christoph
 	 * register_NMI_handler();
 	 */
-	/* Map rom address */
-	cpqhp_rom_start = ioremap(ROM_PHY_ADDR, ROM_PHY_LEN);
-	if (!cpqhp_rom_start) {
-		err ("Could not ioremap memory region for ROM\n");
-		retval = -EIO;
-		goto error;
-	}
 
 	/* Now, map the int15 entry point if we are on compaq specific
 	 * hardware
 	 */
 	compaq_nvram_init(cpqhp_rom_start);
 
-	/* Map smbios table entry point structure */
-	smbios_table = detect_SMBIOS_pointer(cpqhp_rom_start,
-					cpqhp_rom_start + ROM_PHY_LEN);
-	if (!smbios_table) {
-		err ("Could not find the SMBIOS pointer in memory\n");
-		retval = -EIO;
-		goto error_rom_start;
-	}
-
-	smbios_start = ioremap(readl(smbios_table + ST_ADDRESS),
-					readw(smbios_table + ST_LENGTH));
-	if (!smbios_start) {
-		err ("Could not ioremap memory region taken from SMBIOS values\n");
-		retval = -EIO;
-		goto error_smbios_start;
-	}
-
-	initialized = 1;
-
-	return retval;
-
-error_smbios_start:
-	iounmap(smbios_start);
-error_rom_start:
-	iounmap(cpqhp_rom_start);
+	if (!smbios_available)
+		retval = -ENODEV;
 error:
 	return retval;
 }
@@ -1190,7 +1041,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ctrl->next_event = 0;
 
 	/* Setup the slot information structures */
-	rc = ctrl_slot_setup(ctrl, smbios_start, smbios_table);
+	rc = ctrl_slot_setup(ctrl);
 	if (rc) {
 		err(msg_initialization_err, 6);
 		err("%s: unable to save PCI configuration data, error %d\n",
@@ -1416,8 +1267,6 @@ static void __exit unload_cpqphpd(void)
 	/* unmap the rom address */
 	if (cpqhp_rom_start)
 		iounmap(cpqhp_rom_start);
-	if (smbios_start)
-		iounmap(smbios_start);
 }
 
 static struct pci_device_id hpcd_pci_tbl[] = {
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index f02c34d..9525da1 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -38,7 +38,7 @@
 #include <linux/intel-iommu.h>
 #include <linux/syscore_ops.h>
 #include <linux/tboot.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/pci-ats.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
@@ -2108,9 +2108,9 @@ static int iommu_prepare_identity_map(struct pci_dev *pdev,
 	if (end < start) {
 		WARN(1, "Your BIOS is broken; RMRR ends before it starts!\n"
 			"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-			dmi_get_system_info(DMI_BIOS_VENDOR),
-			dmi_get_system_info(DMI_BIOS_VERSION),
-		     dmi_get_system_info(DMI_PRODUCT_VERSION));
+			sysfw_lookup(SYSFW_BIOS_VENDOR),
+			sysfw_lookup(SYSFW_BIOS_VERSION),
+		     sysfw_lookup(SYSFW_PRODUCT_VERSION));
 		ret = -EIO;
 		goto error;
 	}
@@ -2119,9 +2119,9 @@ static int iommu_prepare_identity_map(struct pci_dev *pdev,
 		WARN(1, "Your BIOS is broken; RMRR exceeds permitted address width (%d bits)\n"
 		     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
 		     agaw_to_width(domain->agaw),
-		     dmi_get_system_info(DMI_BIOS_VENDOR),
-		     dmi_get_system_info(DMI_BIOS_VERSION),
-		     dmi_get_system_info(DMI_PRODUCT_VERSION));
+		     sysfw_lookup(SYSFW_BIOS_VENDOR),
+		     sysfw_lookup(SYSFW_BIOS_VERSION),
+		     sysfw_lookup(SYSFW_PRODUCT_VERSION));
 		ret = -EIO;
 		goto error;
 	}
@@ -4005,9 +4005,9 @@ static void __init check_tylersburg_isoch(void)
 	if (!vtisochctrl) {
 		WARN(1, "Your BIOS is broken; DMA routed to ISOCH DMAR unit but no TLB space.\n"
 		     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-		     dmi_get_system_info(DMI_BIOS_VENDOR),
-		     dmi_get_system_info(DMI_BIOS_VERSION),
-		     dmi_get_system_info(DMI_PRODUCT_VERSION));
+		     sysfw_lookup(SYSFW_BIOS_VENDOR),
+		     sysfw_lookup(SYSFW_BIOS_VERSION),
+		     sysfw_lookup(SYSFW_PRODUCT_VERSION));
 		iommu_identity_mapping |= IDENTMAP_AZALIA;
 		return;
 	}
diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index 77cb2a1..bb4f11c 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -20,7 +20,7 @@
  * information.
  */
 
-#include <linux/dmi.h>
+#include <linux/smbios.h>
 #include <linux/sysfs.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
@@ -34,59 +34,47 @@
 
 #define	DEVICE_LABEL_DSM	0x07
 
-#ifndef CONFIG_DMI
-
-static inline int
-pci_create_smbiosname_file(struct pci_dev *pdev)
-{
-	return -1;
-}
-
-static inline void
-pci_remove_smbiosname_file(struct pci_dev *pdev)
-{
-}
-
-#else
-
 enum smbios_attr_enum {
 	SMBIOS_ATTR_NONE = 0,
 	SMBIOS_ATTR_LABEL_SHOW,
 	SMBIOS_ATTR_INSTANCE_SHOW,
 };
 
+static int pci_label_smbios_walk(const union smbios_struct *ss, void *data)
+{
+	struct pci_dev *pdev = (struct pci_dev *)data;
+
+	if (ss->header.type != 41)
+		return SMBIOS_WALK_CONTINUE;
+
+	if ((pdev->bus->number == ss->type41.bus_number) &&
+	    (pdev->devfn == ss->type41.device_function_number))
+		return SMBIOS_WALK_STOP;
+
+	return SMBIOS_WALK_CONTINUE;
+}
+
+
 static mode_t
 find_smbios_instance_string(struct pci_dev *pdev, char *buf,
 			    enum smbios_attr_enum attribute)
 {
-	const struct dmi_device *dmi;
-	struct dmi_dev_onboard *donboard;
-	int bus;
-	int devfn;
-
-	bus = pdev->bus->number;
-	devfn = pdev->devfn;
-
-	dmi = NULL;
-	while ((dmi = dmi_find_device(DMI_DEV_TYPE_DEV_ONBOARD,
-				      NULL, dmi)) != NULL) {
-		donboard = dmi->device_data;
-		if (donboard && donboard->bus == bus &&
-					donboard->devfn == devfn) {
-			if (buf) {
-				if (attribute == SMBIOS_ATTR_INSTANCE_SHOW)
-					return scnprintf(buf, PAGE_SIZE,
-							 "%d\n",
-							 donboard->instance);
-				else if (attribute == SMBIOS_ATTR_LABEL_SHOW)
-					return scnprintf(buf, PAGE_SIZE,
-							 "%s\n",
-							 dmi->name);
-			}
-			return strlen(dmi->name);
-		}
-	}
-	return 0;
+	const char *str;
+	const union smbios_struct *ss;
+
+	ss = smbios_walk(pci_label_smbios_walk, pdev);
+	if (!ss)
+		return 0;
+
+	if (attribute == SMBIOS_ATTR_INSTANCE_SHOW)
+		return scnprintf(buf, PAGE_SIZE, "%d\n",
+				 ss->type41.device_type_instance);
+
+	str = smbios_get_string(ss, ss->type41.reference_designation);
+	if (attribute == SMBIOS_ATTR_LABEL_SHOW)
+		return scnprintf(buf, PAGE_SIZE, "%s\n", str);
+	/* SMBIOS_ATTR_NONE */
+	return strlen(str);
 }
 
 static mode_t
@@ -148,17 +136,19 @@ static struct attribute_group smbios_attr_group = {
 static int
 pci_create_smbiosname_file(struct pci_dev *pdev)
 {
+	if (!smbios_available)
+		return -1;
 	return sysfs_create_group(&pdev->dev.kobj, &smbios_attr_group);
 }
 
 static void
 pci_remove_smbiosname_file(struct pci_dev *pdev)
 {
+	if (!smbios_available)
+		return;
 	sysfs_remove_group(&pdev->dev.kobj, &smbios_attr_group);
 }
 
-#endif
-
 #ifndef CONFIG_ACPI
 
 static inline int
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 731e202..f0e2967 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -11,7 +11,7 @@
 extern int pci_uevent(struct device *dev, struct kobj_uevent_env *env);
 extern int pci_create_sysfs_dev_files(struct pci_dev *pdev);
 extern void pci_remove_sysfs_dev_files(struct pci_dev *pdev);
-#if !defined(CONFIG_DMI) && !defined(CONFIG_ACPI)
+#ifndef CONFIG_ACPI
 static inline void pci_create_firmware_label_files(struct pci_dev *pdev)
 { return; }
 static inline void pci_remove_firmware_label_files(struct pci_dev *pdev)
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index e0610bd..30ffd66 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -14,7 +14,7 @@
 #include <linux/init.h>
 #include <linux/pcieport_if.h>
 #include <linux/aer.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/pci-aspm.h>
 
 #include "portdrv.h"
@@ -330,7 +330,7 @@ static struct pci_driver pcie_portdriver = {
 	.driver.pm 	= PCIE_PORTDRV_PM_OPS,
 };
 
-static int __init dmi_pcie_pme_disable_msi(const struct dmi_system_id *d)
+static int __init id_pcie_pme_disable_msi(const struct sysfw_id *d)
 {
 	pr_notice("%s detected: will not use MSI for PCIe PME signaling\n",
 			d->ident);
@@ -338,20 +338,20 @@ static int __init dmi_pcie_pme_disable_msi(const struct dmi_system_id *d)
 	return 0;
 }
 
-static struct dmi_system_id __initdata pcie_portdrv_dmi_table[] = {
+static struct sysfw_id __initdata pcie_portdrv_id_table[] = {
 	/*
 	 * Boxes that should not use MSI for PCIe PME signaling.
 	 */
 	{
-	 .callback = dmi_pcie_pme_disable_msi,
-	 .ident = "MSI Wind U-100",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR,
-		     		"MICRO-STAR INTERNATIONAL CO., LTD"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "U-100"),
-		     },
-	 },
-	 {}
+		.callback = id_pcie_pme_disable_msi,
+		.ident = "MSI Wind U-100",
+		.matches = {
+				SYSFW_MATCH(SYSFW_SYS_VENDOR,
+					   "MICRO-STAR INTERNATIONAL CO., LTD"),
+				SYSFW_MATCH(SYSFW_PRODUCT_NAME, "U-100"),
+		},
+	},
+	{}
 };
 
 static int __init pcie_portdrv_init(void)
@@ -361,7 +361,7 @@ static int __init pcie_portdrv_init(void)
 	if (pcie_ports_disabled)
 		return pci_register_driver(&pcie_portdriver);
 
-	dmi_check_system(pcie_portdrv_dmi_table);
+	sysfw_callback(pcie_portdrv_id_table);
 
 	retval = pcie_port_bus_register();
 	if (retval) {
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e8a1406..34d63fe 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -22,7 +22,7 @@
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include <linux/kallsyms.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/pci-aspm.h>
 #include <linux/ioport.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
@@ -2343,19 +2343,36 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS,
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8132_BRIDGE,
 			 ht_enable_msi_mapping);
 
+static const struct sysfw_id __initdata nvenet_msi_disable_table[] = {
+	{
+		.ident = "5N32-SLI PREMIUM",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "P5N32-SLI PREMIUM"),
+		},
+		.exactmatch = 1,
+	},
+	{
+		.ident = "P5N32-E SLI",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "P5N32-E SLI"),
+		},
+		.exactmatch = 1,
+	},
+	{}
+};
+
 /* The P5N32-SLI motherboards from Asus have a problem with msi
  * for the MCP55 NIC. It is not yet determined whether the msi problem
  * also affects other devices. As for now, turn off msi for this device.
  */
 static void __devinit nvenet_msi_disable(struct pci_dev *dev)
 {
-	const char *board_name = dmi_get_system_info(DMI_BOARD_NAME);
+	const struct sysfw_id *id;
 
-	if (board_name &&
-	    (strstr(board_name, "P5N32-SLI PREMIUM") ||
-	     strstr(board_name, "P5N32-E SLI"))) {
+	id = sysfw_callback(nvenet_msi_disable_table);
+	if (id) {
 		dev_info(&dev->dev,
-			 "Disabling msi for MCP55 NIC on P5N32-SLI\n");
+			 "Disabling msi for MCP55 NIC on %s\n", id->ident);
 		dev->no_msi = 1;
 	}
 }
-- 
1.7.5.4

