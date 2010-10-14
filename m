Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0JNPkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:40:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48045 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab0JNPkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:40:13 -0400
X-Greylist: delayed 1042 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Oct 2010 11:40:13 EDT
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RESEND PATCH] x86/mrst: add SFI platform device parsing code
To: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 14 Oct 2010 15:29:40 +0100
Message-ID: <20101014142924.12442.3219.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Lots of talk but then nothing happened so resending)

From: Feng Tang <feng.tang@intel.com>

SFI provides a series of tables (differing between 0.7 and 0.8 firmware).
These describe the platform devices present including SPI and I²C devices,
as well as various sensors, keypads and other glue as well as interfaces
provided via the SCU IPC mechanism (intel_scu_ipc.c)

This patch is a merge of the core elements and relevant fixes from the
Intel development code by Feng, Alek, myself into a single coherent patch
for upstream submission.

It provides the needed infrastructure to register I2C, SPI and platform devices
described by the tables, as well as handlers for some of the hardware already
supported in kernel. The 0.8 firmware also provides GPIO tables.

Devices are created at boot time or if they are SCU dependant at the point an
SCU is discovered. The existing Linux device mechanisms will then handle the
device binding. At an abstract level this is an SFI to Linux device translator.

Device/platform specific setup/glue is in this file. This is done so that the
drivers for the generic I²C and SPI bus devices remain cross platform as they
should.

(Updated from RFC version to correct the emc1403 name used by the firmware
 and a wrongly used #define)

[Ingo - let me know if you only see this via the kernel list]

Signed-off-by: Alek Du <alek.du@linux.intel.com>
Signed-off-by: Feng Tang <feng.tang@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/Kconfig                     |    2 
 arch/x86/include/asm/mrst.h          |    5 
 arch/x86/kernel/mrst.c               |  700 ++++++++++++++++++++++++++++++++++
 drivers/platform/x86/intel_scu_ipc.c |    5 
 4 files changed, 712 insertions(+), 0 deletions(-)


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fc5157c..761c4a5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -381,6 +381,8 @@ config X86_MRST
 	depends on X86_EXTENDED_PLATFORM
 	depends on X86_IO_APIC
 	select APB_TIMER
+	select I2C
+	select SPI
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. Moorestown consists of two chips:
diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 4a711a6..cb8fb61 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -14,6 +14,7 @@
 #include <linux/sfi.h>
 
 extern int pci_mrst_init(void);
+
 int __init sfi_parse_mrtc(struct sfi_table_header *table);
 
 /*
@@ -50,4 +51,8 @@ extern void mrst_early_console_init(void);
 
 extern struct console early_hsu_console;
 extern void hsu_early_console_init(void);
+
+extern void intel_scu_devices_create(void);
+extern void intel_scu_devices_destroy(void);
+
 #endif /* _ASM_X86_MRST_H */
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 79ae681..0bf74c5 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -12,6 +12,14 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sfi.h>
+#include <linux/intel_pmic_gpio.h>
+#include <linux/spi/spi.h>
+#include <linux/i2c.h>
+#include <linux/sfi.h>
+#include <linux/i2c/pca953x.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/module.h>
 
@@ -23,6 +31,7 @@
 #include <asm/mrst.h>
 #include <asm/io.h>
 #include <asm/i8259.h>
+#include <asm/intel_scu_ipc.h>
 #include <asm/apb_timer.h>
 
 /*
@@ -309,3 +318,694 @@ static inline int __init setup_x86_mrst_timer(char *arg)
 	return 0;
 }
 __setup("x86_mrst_timer=", setup_x86_mrst_timer);
+
+/*
+ * Parsing GPIO table first, since the DEVS table will need this table
+ * to map the pin name to the actual pin.
+ */
+static struct sfi_gpio_table_entry *gpio_table;
+static int gpio_num_entry;
+
+static int __init sfi_parse_gpio(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_gpio_table_entry *pentry;
+	int num, i;
+
+	if (gpio_table)
+		return 0;
+	sb = (struct sfi_table_simple *)table;
+	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
+	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
+
+	gpio_table = (struct sfi_gpio_table_entry *)
+				kmalloc(num * sizeof(*pentry), GFP_KERNEL);
+	if (!gpio_table)
+		return -1;
+	memcpy(gpio_table, pentry, num * sizeof(*pentry));
+	gpio_num_entry = num;
+
+	pr_info("Moorestown GPIO pin info:\n");
+	for (i = 0; i < num; i++, pentry++)
+		pr_info("info[%2d]: controller = %16.16s, pin_name = %16.16s,"
+		" pin = %d\n", i,
+			pentry->controller_name,
+			pentry->pin_name,
+			pentry->pin_no);
+	return 0;
+}
+
+static int get_gpio_by_name(const char *name)
+{
+	struct sfi_gpio_table_entry *pentry = gpio_table;
+	int i;
+
+	if (!pentry)
+		return -1;
+	for (i = 0; i < gpio_num_entry; i++, pentry++) {
+		if (!strncmp(name, pentry->pin_name, 16))
+			return pentry->pin_no;
+	}
+	return -1;
+}
+
+/*
+ * Here defines the array of devices platform data that IAFW would export
+ * through SFI "DEVS" table, we use name and type to match the device and
+ * its platform data.
+ */
+struct devs_id {
+	char name[17];
+	u8 type;
+	u8 delay;
+	void *(*get_platform_data)(void *info);
+};
+
+/* the offset for the mapping of global gpio pin to irq */
+#define MRST_IRQ_OFFSET 0x100
+
+static void *pmic_gpio_platform_data(void *info)
+{
+	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
+	int gpio_base = get_gpio_by_name("pmic_gpio_base");
+
+	if (gpio_base == -1)
+		gpio_base = 64;	/* Needed for 0.7 SFI firmware */
+	pmic_gpio_pdata.gpio_base = gpio_base;
+	pmic_gpio_pdata.irq_base = gpio_base + MRST_IRQ_OFFSET;
+	pmic_gpio_pdata.gpiointr = 0xffffeff8;
+
+	return &pmic_gpio_pdata;
+}
+
+static void *max3111_platform_data(void *info)
+{
+	static int dummy;
+	struct spi_board_info *spi_info = (struct spi_board_info *)info;
+	int intr = get_gpio_by_name("max3111_int");
+
+	if (intr == -1)
+		return NULL;
+	spi_info->irq = intr + MRST_IRQ_OFFSET;
+	/* we return a dummy pdata */
+	return &dummy;
+}
+
+/* we have multiple max7315 on the board ... */
+#define MAX7315_NUM 2
+static void *max7315_platform_data(void *info)
+{
+	static struct pca953x_platform_data max7315_pdata[MAX7315_NUM];
+	static int nr;
+	struct pca953x_platform_data *max7315 = &max7315_pdata[nr];
+	struct i2c_board_info *i2c_info = (struct i2c_board_info *)info;
+	int gpio_base;
+	int intr;
+	char base_pin_name[17];
+	char intr_pin_name[17];
+
+	if (nr == MAX7315_NUM) {
+		printk(KERN_ERR "too many max7315s, we only support %d\n",
+				MAX7315_NUM);
+		return NULL;
+	}
+	/* we have several max7315 on the board, we only need load several
+	 * instances of the same pca953x driver to cover them
+	 */
+	strcpy(i2c_info->type, "max7315");
+	if (nr++) {
+		sprintf(base_pin_name, "max7315_%d_base", nr);
+		sprintf(intr_pin_name, "max7315_%d_int", nr);
+	} else {
+		strcpy(base_pin_name, "max7315_base");
+		strcpy(intr_pin_name, "max7315_int");
+	}
+
+	gpio_base = get_gpio_by_name(base_pin_name);
+	intr = get_gpio_by_name(intr_pin_name);
+
+	if (gpio_base == -1)
+		return NULL;
+	max7315->gpio_base = gpio_base;
+	if (intr != -1) {
+		i2c_info->irq = intr + MRST_IRQ_OFFSET;
+		max7315->irq_base = gpio_base + MRST_IRQ_OFFSET;
+	} else {
+		i2c_info->irq = -1;
+		max7315->irq_base = -1;
+	}
+	return max7315;
+}
+
+static void *emc1403_platform_data(void *info)
+{
+	static short intr2nd_pdata;
+	struct i2c_board_info *i2c_info = (struct i2c_board_info *)info;
+	int intr = get_gpio_by_name("thermal_int");
+	int intr2nd = get_gpio_by_name("thermal_alert");
+
+	if (intr == -1 || intr2nd == -1)
+		return NULL;
+
+	i2c_info->irq = intr + MRST_IRQ_OFFSET;
+	intr2nd_pdata = intr2nd + MRST_IRQ_OFFSET;
+
+	return &intr2nd_pdata;
+}
+
+static void *lis331dl_platform_data(void *info)
+{
+	static short intr2nd_pdata;
+	struct i2c_board_info *i2c_info = (struct i2c_board_info *)info;
+	int intr = get_gpio_by_name("accel_int");
+	int intr2nd = get_gpio_by_name("accel_2");
+
+	if (intr == -1 || intr2nd == -1)
+		return NULL;
+
+	i2c_info->irq = intr + MRST_IRQ_OFFSET;
+	intr2nd_pdata = intr2nd + MRST_IRQ_OFFSET;
+
+	return &intr2nd_pdata;
+}
+
+static const struct devs_id device_ids[] = {
+	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
+	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
+	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
+	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
+	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data},
+	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data},
+	{},
+};
+
+#define MAX_IPCDEVS	24
+static struct platform_device *ipc_devs[MAX_IPCDEVS];
+static int ipc_next_dev;
+
+#define MAX_DELAYED_SPI	24
+static struct spi_board_info *spi_devs[MAX_DELAYED_SPI];
+static int spi_next_dev;
+
+#define MAX_DELAYED_I2C	24
+static struct i2c_board_info *i2c_devs[MAX_DELAYED_I2C];
+static int i2c_bus[MAX_DELAYED_I2C];
+static int i2c_next_dev;
+
+static void intel_scu_device_register(struct platform_device *pdev)
+{
+	BUG_ON(ipc_next_dev == MAX_IPCDEVS);
+	ipc_devs[ipc_next_dev++] = pdev;
+}
+
+static void intel_delayed_spi_device_register(struct spi_board_info *sdev)
+{
+	struct spi_board_info *new_dev;
+
+	BUG_ON(spi_next_dev == MAX_DELAYED_SPI);
+
+	new_dev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	if (!new_dev) {
+		pr_err("MRST: fail to alloc mem for delayed spi dev %s\n",
+			sdev->modalias);
+		return;
+	}
+	memcpy(new_dev, sdev, sizeof(*sdev));
+
+	spi_devs[spi_next_dev++] = new_dev;
+}
+
+static void intel_delayed_i2c_device_register(int bus,
+						struct i2c_board_info *idev)
+{
+	struct i2c_board_info *new_dev;
+
+	BUG_ON(i2c_next_dev == MAX_DELAYED_I2C);
+
+	new_dev = kzalloc(sizeof(*idev), GFP_KERNEL);
+	if (!new_dev) {
+		pr_err("MRST: fail to alloc mem for delayed i2c dev %s\n",
+			idev->type);
+		return;
+	}
+	memcpy(new_dev, idev, sizeof(*idev));
+
+	i2c_bus[i2c_next_dev] = bus;
+	i2c_devs[i2c_next_dev++] = new_dev;
+}
+
+/* Called by IPC driver */
+void intel_scu_devices_create(void)
+{
+	int i;
+
+	for (i = 0; i < ipc_next_dev; i++)
+		platform_device_add(ipc_devs[i]);
+
+	for (i = 0; i < spi_next_dev; i++) {
+		spi_register_board_info(spi_devs[i], 1);
+		kfree(spi_devs[i]);
+	}
+
+	for (i = 0; i < i2c_next_dev; i++) {
+		struct i2c_adapter *adapter;
+		struct i2c_client *client;
+
+		adapter = i2c_get_adapter(i2c_bus[i]);
+		if (adapter) {
+			client = i2c_new_device(adapter, i2c_devs[i]);
+			if (!client)
+				pr_err("mrst: can't create i2c device %s\n",
+					i2c_devs[i]->type);
+		} else
+			i2c_register_board_info(i2c_bus[i], i2c_devs[i], 1);
+		kfree(i2c_devs[i]);
+	}
+}
+EXPORT_SYMBOL_GPL(intel_scu_devices_create);
+
+/* Called by IPC driver */
+void intel_scu_devices_destroy(void)
+{
+	int i;
+
+	for (i = 0; i < ipc_next_dev; i++)
+		platform_device_del(ipc_devs[i]);
+}
+EXPORT_SYMBOL_GPL(intel_scu_devices_destroy);
+
+static void install_irq_resource(struct platform_device *pdev, int irq)
+{
+	/* Single threaded */
+	static struct resource res = {
+		.name = "IRQ",
+		.flags = IORESOURCE_IRQ,
+	};
+	res.start = irq;
+	platform_device_add_resources(pdev, &res, 1);
+}
+
+static void sfi_handle_ipc_dev(struct platform_device *pdev)
+{
+	const struct devs_id *dev = device_ids;
+	void *pdata = NULL;
+
+	while (dev->name[0]) {
+		if (dev->type == SFI_DEV_TYPE_IPC &&
+				!strncmp(dev->name, pdev->name, 16)) {
+			pdata = dev->get_platform_data(pdev);
+			break;
+		}
+		dev++;
+	}
+	pdev->dev.platform_data = pdata;
+	intel_scu_device_register(pdev);
+}
+
+static int sfi_force_ipc(const char *name)
+{
+	static const char *to_force[] = {
+		"pmic_gpio",
+		"pmic_battery",
+		"pmic_touch",
+		"pmic_audio",
+		"msic_audio",
+		NULL
+	};
+	const char **p = &to_force[0];
+	while (*p != NULL) {
+		if (strcmp(*p, name) == 0)
+			return 1;
+		p++;
+	}
+	return 0;
+}
+
+static void sfi_handle_spi_dev(struct spi_board_info *spi_info)
+{
+	const struct devs_id *dev = device_ids;
+	void *pdata = NULL;
+
+	/* Older firmware lists some IPC devices as SPI. We want to force
+	   these to be the correct type for Linux */
+	if (sfi_force_ipc(spi_info->modalias)) {
+		/* Allocate a platform device, and translate the device
+		   configuration, then use the ipc helper. */
+		struct platform_device *pdev;
+
+		pdev = platform_device_alloc(spi_info->modalias,
+					spi_info->irq);
+		if (pdev == NULL) {
+			pr_err("out of memory for SFI platform device '%s'.\n",
+						spi_info->modalias);
+			return;
+		}
+		install_irq_resource(pdev, spi_info->irq);
+		sfi_handle_ipc_dev(pdev);
+		return;
+	}
+
+
+	while (dev->name[0]) {
+		if (dev->type == SFI_DEV_TYPE_SPI &&
+				!strncmp(dev->name, spi_info->modalias, 16)) {
+			pdata = dev->get_platform_data(spi_info);
+			break;
+		}
+		dev++;
+	}
+	spi_info->platform_data = pdata;
+	if (dev->delay)
+		intel_delayed_spi_device_register(spi_info);
+	else
+		spi_register_board_info(spi_info, 1);
+}
+
+static void sfi_handle_i2c_dev(int bus, struct i2c_board_info *i2c_info)
+{
+	const struct devs_id *dev = device_ids;
+	void *pdata = NULL;
+
+	while (dev->name[0]) {
+		if (dev->type == SFI_DEV_TYPE_I2C &&
+				!strncmp(dev->name, i2c_info->type, 16)) {
+			pdata = dev->get_platform_data(i2c_info);
+			break;
+		}
+		dev++;
+	}
+	i2c_info->platform_data = pdata;
+
+	if (dev->delay)
+		intel_delayed_i2c_device_register(bus, i2c_info);
+	else
+		i2c_register_board_info(bus, i2c_info, 1);
+ }
+
+
+static int __init sfi_parse_devs(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_device_table_entry *pentry;
+	struct spi_board_info spi_info;
+	struct i2c_board_info i2c_info;
+	struct platform_device *pdev;
+	int num, i, bus;
+	int ioapic;
+	struct io_apic_irq_attr irq_attr;
+
+	sb = (struct sfi_table_simple *)table;
+	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_device_table_entry);
+	pentry = (struct sfi_device_table_entry *)sb->pentry;
+
+	for (i = 0; i < num; i++, pentry++) {
+		if (pentry->irq != (u8)0xff) { /* native RTE case */
+			/* these SPI2 devices are not exposed to system as PCI
+			 * devices, but they have separate RTE entry in IOAPIC
+			 * so we have to enable them one by one here
+			 */
+			ioapic = mp_find_ioapic(pentry->irq);
+			irq_attr.ioapic = ioapic;
+			irq_attr.ioapic_pin = pentry->irq;
+			irq_attr.trigger = 1;
+			irq_attr.polarity = 1;
+			io_apic_set_pci_routing(NULL, pentry->irq, &irq_attr);
+		}
+		switch (pentry->type) {
+		case SFI_DEV_TYPE_IPC:
+			/* ID as IRQ is a hack that will go away */
+			pdev = platform_device_alloc(pentry->name, pentry->irq);
+			if (pdev == NULL) {
+				pr_err("out of memory for SFI platform device '%s'.\n",
+							pentry->name);
+				continue;
+			}
+			install_irq_resource(pdev, pentry->irq);
+			pr_info("info[%2d]: IPC bus, name = %16.16s, "
+				"irq = 0x%2x\n", i, pentry->name, pentry->irq);
+			sfi_handle_ipc_dev(pdev);
+			break;
+		case SFI_DEV_TYPE_SPI:
+			memset(&spi_info, 0, sizeof(spi_info));
+			strncpy(spi_info.modalias, pentry->name, 16);
+			spi_info.irq = pentry->irq;
+			spi_info.bus_num = pentry->host_num;
+			spi_info.chip_select = pentry->addr;
+			spi_info.max_speed_hz = pentry->max_freq;
+			pr_info("info[%2d]: SPI bus = %d, name = %16.16s, "
+				"irq = 0x%2x, max_freq = %d, cs = %d\n", i,
+				spi_info.bus_num,
+				spi_info.modalias,
+				spi_info.irq,
+				spi_info.max_speed_hz,
+				spi_info.chip_select);
+			sfi_handle_spi_dev(&spi_info);
+			break;
+		case SFI_DEV_TYPE_I2C:
+			memset(&i2c_info, 0, sizeof(i2c_info));
+			bus = pentry->host_num;
+			strncpy(i2c_info.type, pentry->name, 16);
+			i2c_info.irq = pentry->irq;
+			i2c_info.addr = pentry->addr;
+			pr_info("info[%2d]: I2C bus = %d, name = %16.16s, "
+				"irq = 0x%2x, addr = 0x%x\n", i, bus,
+				i2c_info.type,
+				i2c_info.irq,
+				i2c_info.addr);
+			sfi_handle_i2c_dev(bus, &i2c_info);
+			break;
+		case SFI_DEV_TYPE_UART:
+		case SFI_DEV_TYPE_HSI:
+		default:
+			;
+		}
+	}
+	return 0;
+}
+
+#define MRST_SPI2_CS_START	4
+static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
+
+static int __init sfi_parse_spib(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_spi_table_entry *pentry;
+	struct spi_board_info *info;
+	int num, i, j;
+	int ioapic;
+	struct io_apic_irq_attr irq_attr;
+
+	sb = (struct sfi_table_simple *)table;
+	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_spi_table_entry);
+	pentry = (struct sfi_spi_table_entry *) sb->pentry;
+
+	info = kzalloc(num * sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		pr_info("%s(): Error in kzalloc\n", __func__);
+		return -ENOMEM;
+	}
+
+	if (num)
+		pr_info("Moorestown SPI devices info:\n");
+
+	for (i = 0, j = 0; i < num; i++, pentry++) {
+		strncpy(info[j].modalias, pentry->name, 16);
+		info[j].irq = pentry->irq_info;
+		info[j].bus_num = pentry->host_num;
+		info[j].chip_select = pentry->cs;
+		info[j].max_speed_hz = 3125000;	/* hard coded */
+		if (info[i].chip_select >= MRST_SPI2_CS_START) {
+			/* these SPI2 devices are not exposed to system as PCI
+			 * devices, but they have separate RTE entry in IOAPIC
+			 * so we have to enable them one by one here
+			 */
+			ioapic = mp_find_ioapic(info[j].irq);
+			irq_attr.ioapic = ioapic;
+			irq_attr.ioapic_pin = info[j].irq;
+			irq_attr.trigger = 1;
+			irq_attr.polarity = 1;
+			io_apic_set_pci_routing(NULL, info[j].irq,
+							&irq_attr);
+		}
+		info[j].platform_data = pentry->dev_info;
+
+		if (!strcmp(pentry->name, "pmic_gpio")) {
+			memcpy(&pmic_gpio_pdata, pentry->dev_info, 8);
+			pmic_gpio_pdata.gpiointr = 0xffffeff8;
+			info[j].platform_data = &pmic_gpio_pdata;
+		}
+		pr_info("info[%d]: name = %16.16s, irq = 0x%04x, bus = %d, "
+			"cs = %d\n", j, info[j].modalias, info[j].irq,
+			info[j].bus_num, info[j].chip_select);
+		sfi_handle_spi_dev(&info[j]);
+		j++;
+	}
+	kfree(info);
+	return 0;
+}
+
+#define MRST_I2C_BUSNUM	3
+static struct pca953x_platform_data max7315_pdata;
+static struct pca953x_platform_data max7315_pdata_2;
+
+static int __init sfi_parse_i2cb(struct sfi_table_header *table)
+{
+	struct sfi_table_simple *sb;
+	struct sfi_i2c_table_entry *pentry;
+	struct i2c_board_info info;
+	int num, i, busnum;
+
+	sb = (struct sfi_table_simple *)table;
+	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_i2c_table_entry);
+	pentry = (struct sfi_i2c_table_entry *) sb->pentry;
+
+	if (num <= 0)
+		return -ENODEV;
+
+	for (i = 0; i < num; i++, pentry++) {
+		busnum = pentry->host_num;
+		if (busnum >= MRST_I2C_BUSNUM || busnum < 0)
+			continue;
+
+		memset(&info, 0, sizeof(info));
+		strncpy(info.type, pentry->name, 16);
+		info.irq = pentry->irq_info;
+		info.addr = pentry->addr;
+		info.platform_data = pentry->dev_info;
+
+		if (!strcmp(pentry->name, "i2c_max7315")) {
+			strcpy(info.type, "max7315");
+			max7315_pdata.irq_base = *(int *)pentry->dev_info;
+			max7315_pdata.gpio_base =
+				*((u32 *)pentry->dev_info + 1);
+			info.platform_data = &max7315_pdata;
+		} else if (!strcmp(pentry->name, "i2c_max7315_2")) {
+			strcpy(info.type, "max7315");
+			max7315_pdata_2.irq_base = *(int *)pentry->dev_info;
+			max7315_pdata_2.gpio_base =
+				*((u32 *)pentry->dev_info + 1);
+			info.platform_data = &max7315_pdata_2;
+		}
+
+		pr_info("info[%d]: bus = %d, name = %16.16s, irq = 0x%04x, "
+			"addr = 0x%x\n", i, busnum, info.type,
+		       info.irq, info.addr);
+
+		i2c_register_board_info(busnum, &info, 1);
+	}
+
+	return 0;
+}
+
+
+static int __init mrst_platform_init(void)
+{
+	/* Keep for back compatibility for SFI 0.7 and before */
+	sfi_table_parse(SFI_SIG_SPIB, NULL, NULL, sfi_parse_spib);
+	sfi_table_parse(SFI_SIG_I2CB, NULL, NULL, sfi_parse_i2cb);
+
+	/* For SFi 0.8 version */
+	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_parse_gpio);
+	sfi_table_parse(SFI_SIG_DEVS, NULL, NULL, sfi_parse_devs);
+	return 0;
+}
+arch_initcall(mrst_platform_init);
+
+/*
+ * we will search these buttons in SFI GPIO table (by name)
+ * and register them dynamically. Please add all possible
+ * buttons here, we will shrink them if no GPIO found.
+ */
+static struct gpio_keys_button gpio_button[] = {
+	{KEY_POWER,		-1, 1, "power_btn",	EV_KEY, 0, 3000},
+	{KEY_PROG1,		-1, 1, "prog_btn1",	EV_KEY, 0, 20},
+	{KEY_PROG2,		-1, 1, "prog_btn2",	EV_KEY, 0, 20},
+	{SW_LID,		-1, 1, "lid_switch",	EV_SW,  0, 20},
+	{KEY_VOLUMEUP,		-1, 1, "vol_up",	EV_KEY, 0, 20},
+	{KEY_VOLUMEDOWN,	-1, 1, "vol_down",	EV_KEY, 0, 20},
+	{KEY_CAMERA,		-1, 1, "camera_full",	EV_KEY, 0, 20},
+	{KEY_CAMERA_FOCUS,	-1, 1, "camera_half",	EV_KEY, 0, 20},
+	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw1",	EV_SW,  0, 20},
+	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw2",	EV_SW,  0, 20},
+	{-1},/* must be ended with code = -1 */
+};
+
+static struct gpio_keys_platform_data mrst_gpio_keys = {
+	.buttons	= gpio_button,
+	.rep		= 1,
+	.nbuttons	= -1, /* will fill it after search */
+};
+
+static struct platform_device pb_device = {
+	.name		= "gpio-keys",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &mrst_gpio_keys,
+	},
+};
+
+static void __init pb_match(const char *name, int gpio)
+{
+	struct gpio_keys_button *gb = gpio_button;
+
+	while (gb->code != -1) {
+		if (!strcmp(name, gb->desc)) {
+			gb->gpio = gpio;
+			break;
+		}
+		gb++;
+	}
+}
+
+/* shrink non-existent buttons and return total available number */
+static int __init pb_shrink(void)
+{
+	struct gpio_keys_button *gb = gpio_button;
+	struct gpio_keys_button *next = NULL;
+	int num = 0;
+
+	while (gb->code != -1) {
+		if (gb->gpio == -1) {
+			if (!next)
+				next = gb + 1;
+			while (next->code != -1 && next->gpio == -1)
+				next++;
+			if (next->code == -1)/* end */
+				break;
+			*gb = *next;
+			next->gpio = -1;
+			next++;
+		}
+		num++;
+		gb++;
+	}
+	return num;
+}
+
+static int __init pb_keys_init(void)
+{
+	int num;
+	/* for SFI 0.7, we have to claim static gpio buttons */
+	if (!gpio_table) {
+		pb_match("power_btn", 65);
+		pb_match("prog_btn1", 66);
+		pb_match("prog_btn2", 69);
+		pb_match("lid_switch", 101);
+	} else {/* SFI 0.8 */
+		struct gpio_keys_button *gb = gpio_button;
+
+		while (gb->code != -1) {
+			gb->gpio = get_gpio_by_name(gb->desc);
+			gb++;
+		}
+	}
+	num = pb_shrink();
+	if (num) {
+		mrst_gpio_keys.nbuttons = num;
+		return platform_device_register(&pb_device);
+	}
+	return 0;
+}
+
+late_initcall(pb_keys_init);
+
diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 41a9e34..ca35b0c 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -26,6 +26,7 @@
 #include <linux/sfi.h>
 #include <asm/mrst.h>
 #include <asm/intel_scu_ipc.h>
+#include <asm/mrst.h>
 
 /* IPC defines the following message types */
 #define IPCMSG_WATCHDOG_TIMER 0xF8 /* Set Kernel Watchdog Threshold */
@@ -699,6 +700,9 @@ static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		iounmap(ipcdev.ipc_base);
 		return -ENOMEM;
 	}
+
+	intel_scu_devices_create();
+
 	return 0;
 }
 
@@ -720,6 +724,7 @@ static void ipc_remove(struct pci_dev *pdev)
 	iounmap(ipcdev.ipc_base);
 	iounmap(ipcdev.i2c_base);
 	ipcdev.pdev = NULL;
+	intel_scu_devices_destroy();
 }
 
 static const struct pci_device_id pci_ids[] = {

