Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2DEQE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:04:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54492 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab2DEQEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:04:24 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <tony@atomide.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>, <sameo@linux.intel.com>,
        <grinberg@compulab.co.il>, <mike@compulab.co.il>, <nm@ti.com>,
        <artem.bityutskiy@linux.intel.com>, <vimal.newwork@gmail.com>,
        <dbaryshkov@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Afzal Mohammed <afzal@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
        Jon Hunter <jon-hunter@ti.com>
Subject: [PATCH v3 1/9] ARM: OMAP2+: gpmc: driver conversion
Date: Thu, 5 Apr 2012 21:15:59 +0530
Message-ID: <cefbe934da40f0a169b1e3a75c46451e5546a8bd.1333640054.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <cover.1333640054.git.afzal@ti.com>
References: <cover.1333640054.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert GPMC code to driver. Boards using GPMC should provide driver
with type of configuration, timing, CS, GPMC address space details
(if already configured, driver will retrieve, as is existing).
Platform devices would the be created for each connected peripheral
(details also to be passed by board so that it reaches respective
driver). And GPMC driver would populate memory resource details for
the driver of connected peripheral.

A peripheral connected to GPMC can have multiple address spaces using
different chip select. Hence GPMC driver has been provided capability
to create platform device for peripheral using mutiple CS. The
peripheral that made it necessary was tusb6010. Thanks to Jon Hunter
for his suggesstion on better way to handle this.

Interrupts of GPMC are presented to drivers of connected peripherals
as resource. A fictitious interrupt controller chip handles these
interrupts at GPMC hardware level. Clients can use normal interrupt
APIs. Platforms should inform GPMC driver infrastruture available
for these imaginary client interrupts (like irq number). Platform
information of peripheral passed to GPMC driver should indicate
interrupts to be used via flags.

Final destination for this driver is being investigated. Before moving
to the new location, all existing GPMC users has to be converted to
work with this driver.

NAND driver for NAND used via GPMC is tightly coupled with GPMC
driver (GPMC has few blocks exclusively for NAND), while that is not
the case for most of the other users (they need GPMCs help only for
initial configuration). Currently NAND driver manage using exported
GPMC symbols. This is being planned to remove later & would need
informing NAND driver about GPMC NAND registers. This would help to
have export symbol free GPMC driver, and probably
"mv omap2.c gpmc-nand.c" for OMAP NAND driver.
Thanks to Vaibhav Hiremath for his ideas on this.

Acquiring CS# for NAND is done on a few boards. It means, depending
on bootloader to embed this information. Probably CS# being used can
be set in the Kernel, and acquiring it can be removed. If ever this
capbility is needed, GPMC driver has to be made aware of handling it.

OneNAND - as it may involve reconfiguring GPMC for synchronous may
need a quirk to handle or driver has to be made more intelligent to
handle it.

Code related to GPMC clock may have to continue live in platform
folders (even if the driver is moved to MFD) as input clock is beyond
the control of GPMC and calculating timing for the peripheral may
need other helpers.

Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Jon Hunter <jon-hunter@ti.com>
Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/gpmc.c             |  518 ++++++++++++++++++++++++++------
 arch/arm/plat-omap/include/plat/gpmc.h |   50 ++-
 2 files changed, 476 insertions(+), 92 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 00d5108..cf5d8f3 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -14,8 +14,11 @@
  */
 #undef DEBUG
 
+#include <linux/platform_device.h>
+
 #include <linux/irq.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/clk.h>
@@ -64,6 +67,47 @@
 #define ENABLE_PREFETCH		(0x1 << 7)
 #define DMA_MPU_MODE		2
 
+#define	DRIVER_NAME	"omap-gpmc"
+
+#define	GPMC_NR_IRQ		6
+
+struct gpmc_device {
+	char			*name;
+	int			id;
+	void			*pdata;
+	unsigned		pdata_size;
+	struct resource		*per_res;
+	unsigned		num_per_res;
+	struct resource		*gpmc_res;
+	unsigned		num_gpmc_res;
+};
+
+struct gpmc_irq	{
+	unsigned		irq;
+	u32			regval;
+};
+
+struct gpmc {
+	struct device		*dev;
+	unsigned long		fclk_period;
+	void __iomem		*io_base;
+	unsigned long		phys_base;
+	u32			memsize;
+	unsigned		cs_map;
+	int			ecc_used;
+	spinlock_t		mem_lock;
+	struct resource		mem_root;
+	struct resource		cs_mem[GPMC_CS_NUM];
+	/* XXX: Or allocate dynamically ? */
+	struct gpmc_device	device[GPMC_CS_NUM];
+	unsigned		num_device;
+	unsigned		master_irq;
+	unsigned		irq_start;
+	unsigned		num_irq;
+	struct gpmc_irq		irq[GPMC_NR_IRQ];
+	struct irq_chip		irq_chip;
+};
+
 /* Structure to save gpmc cs context */
 struct gpmc_cs_config {
 	u32 config1;
@@ -91,58 +135,50 @@ struct omap3_gpmc_regs {
 	struct gpmc_cs_config cs_context[GPMC_CS_NUM];
 };
 
-static struct resource	gpmc_mem_root;
-static struct resource	gpmc_cs_mem[GPMC_CS_NUM];
-static DEFINE_SPINLOCK(gpmc_mem_lock);
-static unsigned int gpmc_cs_map;	/* flag for cs which are initialized */
-static int gpmc_ecc_used = -EINVAL;	/* cs using ecc engine */
-
-static void __iomem *gpmc_base;
-
 static struct clk *gpmc_l3_clk;
 
-static irqreturn_t gpmc_handle_irq(int irq, void *dev);
+static struct gpmc *gpmc;
 
 static void gpmc_write_reg(int idx, u32 val)
 {
-	__raw_writel(val, gpmc_base + idx);
+	writel(val, gpmc->io_base + idx);
 }
 
 static u32 gpmc_read_reg(int idx)
 {
-	return __raw_readl(gpmc_base + idx);
+	return readl(gpmc->io_base + idx);
 }
 
 static void gpmc_cs_write_byte(int cs, int idx, u8 val)
 {
 	void __iomem *reg_addr;
 
-	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
-	__raw_writeb(val, reg_addr);
+	reg_addr = gpmc->io_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
+	writeb(val, reg_addr);
 }
 
 static u8 gpmc_cs_read_byte(int cs, int idx)
 {
 	void __iomem *reg_addr;
 
-	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
-	return __raw_readb(reg_addr);
+	reg_addr = gpmc->io_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
+	return readb(reg_addr);
 }
 
 void gpmc_cs_write_reg(int cs, int idx, u32 val)
 {
 	void __iomem *reg_addr;
 
-	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
-	__raw_writel(val, reg_addr);
+	reg_addr = gpmc->io_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
+	writel(val, reg_addr);
 }
 
 u32 gpmc_cs_read_reg(int cs, int idx)
 {
 	void __iomem *reg_addr;
 
-	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
-	return __raw_readl(reg_addr);
+	reg_addr = gpmc->io_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
+	return readl(reg_addr);
 }
 
 /* TODO: Add support for gpmc_fck to clock framework and use it */
@@ -332,7 +368,7 @@ static void gpmc_cs_disable_mem(int cs)
 	gpmc_cs_write_reg(cs, GPMC_CS_CONFIG7, l);
 }
 
-static void gpmc_cs_get_memconf(int cs, u32 *base, u32 *size)
+static __devinit void gpmc_cs_get_memconf(int cs, u32 *base, u32 *size)
 {
 	u32 l;
 	u32 mask;
@@ -351,23 +387,23 @@ static int gpmc_cs_mem_enabled(int cs)
 	return l & GPMC_CONFIG7_CSVALID;
 }
 
-int gpmc_cs_set_reserved(int cs, int reserved)
+static int gpmc_cs_set_reserved(int cs, int reserved)
 {
 	if (cs > GPMC_CS_NUM)
 		return -ENODEV;
 
-	gpmc_cs_map &= ~(1 << cs);
-	gpmc_cs_map |= (reserved ? 1 : 0) << cs;
+	gpmc->cs_map &= ~(1 << cs);
+	gpmc->cs_map |= (reserved ? 1 : 0) << cs;
 
 	return 0;
 }
 
-int gpmc_cs_reserved(int cs)
+static int gpmc_cs_reserved(int cs)
 {
 	if (cs > GPMC_CS_NUM)
 		return -ENODEV;
 
-	return gpmc_cs_map & (1 << cs);
+	return gpmc->cs_map & (1 << cs);
 }
 
 static unsigned long gpmc_mem_align(unsigned long size)
@@ -384,24 +420,25 @@ static unsigned long gpmc_mem_align(unsigned long size)
 	return size;
 }
 
-static int gpmc_cs_insert_mem(int cs, unsigned long base, unsigned long size)
+static __devinit
+int gpmc_cs_insert_mem(int cs, unsigned long base, unsigned long size)
 {
-	struct resource	*res = &gpmc_cs_mem[cs];
+	struct resource	*res = &gpmc->cs_mem[cs];
 	int r;
 
 	size = gpmc_mem_align(size);
-	spin_lock(&gpmc_mem_lock);
+	spin_lock(&gpmc->mem_lock);
 	res->start = base;
 	res->end = base + size - 1;
-	r = request_resource(&gpmc_mem_root, res);
-	spin_unlock(&gpmc_mem_lock);
+	r = request_resource(&gpmc->mem_root, res);
+	spin_unlock(&gpmc->mem_lock);
 
 	return r;
 }
 
 int gpmc_cs_request(int cs, unsigned long size, unsigned long *base)
 {
-	struct resource *res = &gpmc_cs_mem[cs];
+	struct resource *res = &gpmc->cs_mem[cs];
 	int r = -1;
 
 	if (cs > GPMC_CS_NUM)
@@ -411,7 +448,7 @@ int gpmc_cs_request(int cs, unsigned long size, unsigned long *base)
 	if (size > (1 << GPMC_SECTION_SHIFT))
 		return -ENOMEM;
 
-	spin_lock(&gpmc_mem_lock);
+	spin_lock(&gpmc->mem_lock);
 	if (gpmc_cs_reserved(cs)) {
 		r = -EBUSY;
 		goto out;
@@ -419,7 +456,7 @@ int gpmc_cs_request(int cs, unsigned long size, unsigned long *base)
 	if (gpmc_cs_mem_enabled(cs))
 		r = adjust_resource(res, res->start & ~(size - 1), size);
 	if (r < 0)
-		r = allocate_resource(&gpmc_mem_root, res, size, 0, ~0,
+		r = allocate_resource(&gpmc->mem_root, res, size, 0, ~0,
 				      size, NULL, NULL);
 	if (r < 0)
 		goto out;
@@ -428,24 +465,24 @@ int gpmc_cs_request(int cs, unsigned long size, unsigned long *base)
 	*base = res->start;
 	gpmc_cs_set_reserved(cs, 1);
 out:
-	spin_unlock(&gpmc_mem_lock);
+	spin_unlock(&gpmc->mem_lock);
 	return r;
 }
 EXPORT_SYMBOL(gpmc_cs_request);
 
 void gpmc_cs_free(int cs)
 {
-	spin_lock(&gpmc_mem_lock);
+	spin_lock(&gpmc->mem_lock);
 	if (cs >= GPMC_CS_NUM || cs < 0 || !gpmc_cs_reserved(cs)) {
 		printk(KERN_ERR "Trying to free non-reserved GPMC CS%d\n", cs);
 		BUG();
-		spin_unlock(&gpmc_mem_lock);
+		spin_unlock(&gpmc->mem_lock);
 		return;
 	}
 	gpmc_cs_disable_mem(cs);
-	release_resource(&gpmc_cs_mem[cs]);
+	release_resource(&gpmc->cs_mem[cs]);
 	gpmc_cs_set_reserved(cs, 0);
-	spin_unlock(&gpmc_mem_lock);
+	spin_unlock(&gpmc->mem_lock);
 }
 EXPORT_SYMBOL(gpmc_cs_free);
 
@@ -546,6 +583,12 @@ int gpmc_cs_configure(int cs, int cmd, int wval)
 		gpmc_cs_write_reg(cs, GPMC_CS_CONFIG1, regval);
 		break;
 
+	case GPMC_CONFIG_WAITPIN:
+		regval  = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG1);
+		regval |= GPMC_CONFIG1_WAIT_PIN_SEL(wval);
+		gpmc_cs_write_reg(cs, GPMC_CS_CONFIG1, regval);
+		break;
+
 	default:
 		printk(KERN_ERR "gpmc_configure_cs: Not supported\n");
 		err = -EINVAL;
@@ -668,7 +711,7 @@ int gpmc_prefetch_reset(int cs)
 }
 EXPORT_SYMBOL(gpmc_prefetch_reset);
 
-static void __init gpmc_mem_init(void)
+static __devinit void gpmc_mem_init(void)
 {
 	int cs;
 	unsigned long boot_rom_space = 0;
@@ -680,8 +723,8 @@ static void __init gpmc_mem_init(void)
 	/* In apollon the CS0 is mapped as 0x0000 0000 */
 	if (machine_is_omap_apollon())
 		boot_rom_space = 0;
-	gpmc_mem_root.start = GPMC_MEM_START + boot_rom_space;
-	gpmc_mem_root.end = GPMC_MEM_END;
+	gpmc->mem_root.start = GPMC_MEM_START + boot_rom_space;
+	gpmc->mem_root.end = GPMC_MEM_END;
 
 	/* Reserve all regions that has been set up by bootloader */
 	for (cs = 0; cs < GPMC_CS_NUM; cs++) {
@@ -697,26 +740,15 @@ static void __init gpmc_mem_init(void)
 
 static int __init gpmc_init(void)
 {
-	u32 l, irq;
-	int cs, ret = -EINVAL;
-	int gpmc_irq;
+	int ret = -EINVAL;
 	char *ck = NULL;
 
 	if (cpu_is_omap24xx()) {
 		ck = "core_l3_ck";
-		if (cpu_is_omap2420())
-			l = OMAP2420_GPMC_BASE;
-		else
-			l = OMAP34XX_GPMC_BASE;
-		gpmc_irq = INT_34XX_GPMC_IRQ;
 	} else if (cpu_is_omap34xx()) {
 		ck = "gpmc_fck";
-		l = OMAP34XX_GPMC_BASE;
-		gpmc_irq = INT_34XX_GPMC_IRQ;
 	} else if (cpu_is_omap44xx()) {
 		ck = "gpmc_ck";
-		l = OMAP44XX_GPMC_BASE;
-		gpmc_irq = OMAP44XX_IRQ_GPMC;
 	}
 
 	if (WARN_ON(!ck))
@@ -728,54 +760,360 @@ static int __init gpmc_init(void)
 		BUG();
 	}
 
-	gpmc_base = ioremap(l, SZ_4K);
-	if (!gpmc_base) {
-		clk_put(gpmc_l3_clk);
-		printk(KERN_ERR "Could not get GPMC register memory\n");
-		BUG();
+	clk_enable(gpmc_l3_clk);
+
+	return 0;
+}
+postcore_initcall(gpmc_init);
+
+static __devinit struct resource gpmc_setup_cs_mem(struct gpmc_cs_data *p,
+			struct gpmc_device_pdata *gdp, struct gpmc *gpmc)
+{
+	int i, ret;
+	struct gpmc_config *c;
+	struct resource res;
+	unsigned long start;
+
+	res.flags = 0x0;
+	start = p->mem_start;
+
+	ret = gpmc_cs_request(p->cs, p->mem_size, &start);
+	if (IS_ERR_VALUE(ret)) {
+		dev_err(gpmc->dev, "error: gpmc request on CS: %u\n", p->cs);
+		return res;
 	}
 
-	clk_enable(gpmc_l3_clk);
+	c = p->config;
+	if (!c)
+		dev_warn(gpmc->dev, "config not present for CS: %u\n", p->cs);
+
+	for (i = 0; i < p->num_config; c++, i++) {
+		/* XXX: check for non-NULL c ? */
+		ret = gpmc_cs_configure(p->cs, c->cmd, c->val);
+		if (IS_ERR_VALUE(ret)) {
+			dev_err(gpmc->dev, "invalid cmd or value on CS:	\
+			 %u: cmd: %d value: %d\n", p->cs, c->cmd, c->val);
+			return res;
+		}
+	}
 
-	l = gpmc_read_reg(GPMC_REVISION);
-	printk(KERN_INFO "GPMC revision %d.%d\n", (l >> 4) & 0x0f, l & 0x0f);
-	/* Set smart idle mode and automatic L3 clock gating */
-	l = gpmc_read_reg(GPMC_SYSCONFIG);
-	l &= 0x03 << 3;
-	l |= (0x02 << 3) | (1 << 0);
-	gpmc_write_reg(GPMC_SYSCONFIG, l);
-	gpmc_mem_init();
+	if (p->timing) {
+		ret = gpmc_cs_set_timings(p->cs, p->timing);
+		if (IS_ERR_VALUE(ret)) {
+			dev_err(gpmc->dev, "error: setting timing on CS: %d\n",
+								p->cs);
+			return res;
+		}
+	} else
+		dev_warn(gpmc->dev, "timing not present for CS: %u\n", p->cs);
 
-	/* initalize the irq_chained */
-	irq = OMAP_GPMC_IRQ_BASE;
-	for (cs = 0; cs < GPMC_CS_NUM; cs++) {
-		irq_set_chip_and_handler(irq, &dummy_irq_chip,
-						handle_simple_irq);
-		set_irq_flags(irq, IRQF_VALID);
-		irq++;
+	res.start = start + p->mem_offset;
+	res.end = res.start + p->mem_size - 1;
+	res.flags = IORESOURCE_MEM;
+
+	dev_info(gpmc->dev, "resource memory 0x%x-0x%x for %s (on CS %d)\n",
+				res.start, res.end, gdp->name, p->cs);
+
+	return res;
+}
+
+static __devinit
+int gpmc_setup_cs_irq(struct gpmc *gpmc, struct gpmc_device_pdata *gdp,
+			struct gpmc_cs_data *cs, struct resource *res)
+{
+	int i, n, val;
+
+	for (i = 0, n = 0; i < gpmc->num_irq; i++)
+		if (gpmc->irq[i].regval & cs->irq_flags) {
+			res[n].start = res[n].end = gpmc->irq[i].irq;
+			res[n].flags = IORESOURCE_IRQ;
+
+			dev_info(gpmc->dev, "resource irq %u for %s "
+				"(on CS %d) [bit: %x]\n", res[n].start,
+				gdp->name, cs->cs, __ffs(gpmc->irq[i].regval));
+
+			switch (gpmc->irq[i].regval) {
+			case GPMC_IRQ_WAIT0EDGEDETECTION:
+			case GPMC_IRQ_WAIT1EDGEDETECTION:
+			case GPMC_IRQ_WAIT2EDGEDETECTION:
+			case GPMC_IRQ_WAIT3EDGEDETECTION:
+				val = __ffs(gpmc->irq[i].regval);
+				val -= __ffs(GPMC_IRQ_WAIT0EDGEDETECTION);
+				gpmc_cs_configure(cs->cs,
+					GPMC_CONFIG_WAITPIN, val);
+			}
+			n++;
+		}
+
+	return n;
+}
+
+static __devinit int gpmc_setup_device(struct gpmc_device_pdata *gdp,
+				struct gpmc_device *dev, struct gpmc *gpmc)
+{
+	int i, j, n;
+	struct gpmc_cs_data *cs;
+
+	for (i = 0, n = 0, cs = gdp->cs_data; i < gdp->num_cs; i++, cs++)
+		n += hweight32(cs->irq_flags & GPMC_IRQ_MASK);
+
+	n += gdp->num_cs;
+
+	dev->gpmc_res = devm_kzalloc(gpmc->dev, sizeof(*dev->gpmc_res) * n,
+								GFP_KERNEL);
+	if (dev->gpmc_res == NULL) {
+		dev_err(gpmc->dev, "error: memory allocation\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0, j = 0, cs = gdp->cs_data; i < gdp->num_cs; cs++, i++) {
+		dev->gpmc_res[j] = gpmc_setup_cs_mem(cs, gdp, gpmc);
+		if (dev->gpmc_res[j++].flags & IORESOURCE_MEM)
+			j += gpmc_setup_cs_irq(gpmc, gdp, cs,
+						dev->gpmc_res + j);
+		else {
+			dev_err(gpmc->dev, "error: setup for %s\n", gdp->name);
+			devm_kfree(gpmc->dev, dev->gpmc_res);
+			dev->gpmc_res = NULL;
+			dev->num_gpmc_res = 0;
+			return -EINVAL;
+		}
 	}
+	dev->num_gpmc_res = j;
 
-	ret = request_irq(gpmc_irq,
-			gpmc_handle_irq, IRQF_SHARED, "gpmc", gpmc_base);
-	if (ret)
-		pr_err("gpmc: irq-%d could not claim: err %d\n",
-						gpmc_irq, ret);
-	return ret;
+	dev->name = gdp->name;
+	dev->id = gdp->id;
+	dev->pdata = gdp->pdata;
+	dev->pdata_size = gdp->pdata_size;
+	dev->per_res = gdp->per_res;
+	dev->num_per_res = gdp->num_per_res;
+
+	return 0;
+}
+
+static __devinit
+struct platform_device *gpmc_create_device(struct gpmc_device *p,
+							struct gpmc *gpmc)
+{
+	int num = p->num_per_res + p->num_gpmc_res;
+	struct resource *res;
+	struct platform_device *pdev;
+
+	res = devm_kzalloc(gpmc->dev, sizeof(struct resource) * num,
+								GFP_KERNEL);
+	if (!res) {
+		dev_err(gpmc->dev, "error: allocating memory\n");
+		return NULL;
+	}
+
+	memcpy((char *)res, (const char *) p->gpmc_res,
+				sizeof(struct resource) * p->num_gpmc_res);
+	memcpy((char *)(res + p->num_gpmc_res), (const char *)p->per_res,
+				sizeof(struct resource) * p->num_per_res);
+
+	pdev = platform_device_register_resndata(gpmc->dev, p->name, p->id,
+					res, num, p->pdata, p->pdata_size);
+
+	devm_kfree(gpmc->dev, res);
+
+	return pdev;
 }
-postcore_initcall(gpmc_init);
 
 static irqreturn_t gpmc_handle_irq(int irq, void *dev)
 {
-	u8 cs;
+	int i;
+	u32 regval;
+	struct gpmc *gpmc = dev;
 
-	/* check cs to invoke the irq */
-	cs = ((gpmc_read_reg(GPMC_PREFETCH_CONFIG1)) >> CS_NUM_SHIFT) & 0x7;
-	if (OMAP_GPMC_IRQ_BASE+cs <= OMAP_GPMC_IRQ_END)
-		generic_handle_irq(OMAP_GPMC_IRQ_BASE+cs);
+	regval = gpmc_read_reg(GPMC_IRQSTATUS);
+
+
+	for (i = 0; i < gpmc->num_irq; i++)
+		if (regval & gpmc->irq[i].regval)
+			generic_handle_irq(gpmc->irq[i].irq);
+	gpmc_write_reg(GPMC_IRQSTATUS, regval);
 
 	return IRQ_HANDLED;
 }
 
+static int gpmc_irq_endis(struct irq_data *p, bool endis)
+{
+	struct gpmc *gpmc = irq_data_get_irq_chip_data(p);
+	int i;
+	u32 regval;
+
+	for (i = 0; i < gpmc->num_irq; i++)
+		if (p->irq == gpmc->irq[i].irq) {
+			regval = gpmc_read_reg(GPMC_IRQENABLE);
+			if (endis)
+				regval |= gpmc->irq[i].regval;
+			else
+				regval &= ~gpmc->irq[i].regval;
+			gpmc_write_reg(GPMC_IRQENABLE, regval);
+			break;
+		}
+
+	return 0;
+}
+
+static void gpmc_irq_disable(struct irq_data *p)
+{
+	gpmc_irq_endis(p, false);
+}
+
+static void gpmc_irq_enable(struct irq_data *p)
+{
+	gpmc_irq_endis(p, true);
+}
+
+static void gpmc_irq_noop(struct irq_data *data) { }
+
+static unsigned int gpmc_irq_noop_ret(struct irq_data *data) { return 0; }
+
+static __devinit int gpmc_setup_irq(struct gpmc *gpmc)
+{
+	int i;
+	u32 regval;
+
+	if (!gpmc->master_irq)
+		return -EINVAL;
+
+	if (gpmc->num_irq < GPMC_NR_IRQ) {
+		dev_warn(gpmc->dev, "Insufficient interrupts for device\n");
+		return -EINVAL;
+	} else if (gpmc->num_irq > GPMC_NR_IRQ)
+		gpmc->num_irq = GPMC_NR_IRQ;
+
+	gpmc->irq[0].regval = GPMC_IRQ_FIFOEVENT;
+	gpmc->irq[1].regval = GPMC_IRQ_TERMINALCOUNT;
+	gpmc->irq[2].regval = GPMC_IRQ_WAIT0EDGEDETECTION;
+	gpmc->irq[3].regval = GPMC_IRQ_WAIT1EDGEDETECTION;
+	gpmc->irq[4].regval = GPMC_IRQ_WAIT2EDGEDETECTION;
+	gpmc->irq[5].regval = GPMC_IRQ_WAIT3EDGEDETECTION;
+
+	for (i = 0; i < gpmc->num_irq; i++)
+		gpmc->irq[i].irq = gpmc->irq_start + i;
+
+	gpmc->irq_chip.name = "gpmc";
+	gpmc->irq_chip.irq_startup = gpmc_irq_noop_ret;
+	gpmc->irq_chip.irq_enable = gpmc_irq_enable;
+	gpmc->irq_chip.irq_disable = gpmc_irq_disable;
+	gpmc->irq_chip.irq_shutdown = gpmc_irq_noop;
+	gpmc->irq_chip.irq_ack = gpmc_irq_noop;
+	gpmc->irq_chip.irq_mask = gpmc_irq_noop;
+	gpmc->irq_chip.irq_unmask = gpmc_irq_noop;
+
+	for (i = 0; i < gpmc->num_irq; i++) {
+		irq_set_chip_and_handler(gpmc->irq[i].irq,
+					&gpmc->irq_chip, handle_simple_irq);
+		irq_set_chip_data(gpmc->irq[i].irq, gpmc);
+		set_irq_flags(gpmc->irq[i].irq, IRQF_VALID | IRQF_NOAUTOEN);
+	}
+
+	/* clear interrupts */
+	regval = gpmc_read_reg(GPMC_IRQSTATUS);
+	gpmc_write_reg(GPMC_IRQSTATUS, regval);
+
+	return request_irq(gpmc->master_irq, gpmc_handle_irq, IRQF_SHARED,
+							"gpmc", gpmc);
+}
+
+static __devinit int gpmc_probe(struct platform_device *pdev)
+{
+	u32 l;
+	int i;
+	int ret = 0;
+	struct resource *res = NULL;
+	struct gpmc_pdata *gp = dev_get_platdata(&pdev->dev);
+	struct gpmc_device_pdata **gdq = NULL;
+	struct gpmc_device *gd = NULL;
+
+	gpmc = devm_kzalloc(&pdev->dev, sizeof(struct gpmc), GFP_KERNEL);
+	if (gpmc == NULL)
+		return -ENOMEM;
+
+	gpmc->dev = &pdev->dev;
+	gpmc->fclk_period = gp->fclk_period;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL)
+		return -ENOENT;
+
+	gpmc->phys_base = res->start;
+	gpmc->memsize = resource_size(res);
+
+	gpmc->io_base = devm_request_and_ioremap(gpmc->dev, res);
+	if (!gpmc->io_base)
+		return -EADDRNOTAVAIL;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL)
+		dev_warn(gpmc->dev, "Failed to get resource: irq\n");
+	else
+		gpmc->master_irq = res->start;
+
+	gpmc->irq_start = gp->irq_start;
+	gpmc->num_irq = gp->num_irq;
+	gpmc_setup_irq(gpmc);
+
+	gpmc->ecc_used = -EINVAL;
+	spin_lock_init(&gpmc->mem_lock);
+	platform_set_drvdata(pdev, gpmc);
+
+	l = gpmc_read_reg(GPMC_REVISION);
+	dev_info(gpmc->dev, "GPMC revision %d.%d\n", (l >> 4) & 0x0f, l & 0x0f);
+
+	gpmc_mem_init();
+
+	for (gdq = gp->device_pdata, gd = gpmc->device; *gdq; gdq++, i++) {
+		ret = gpmc_setup_device(*gdq, gd, gpmc);
+		if (IS_ERR_VALUE(ret))
+			dev_err(gpmc->dev, "gpmc setup on %s failed\n",
+								(*gdq)->name);
+		else
+			gd++;
+	}
+	gpmc->num_device = gd - gpmc->device;
+
+	for (i = 0, gd = gpmc->device; i < gpmc->num_device; i++, gd++)
+		if (IS_ERR(gpmc_create_device(gd, gpmc)))
+			dev_err(gpmc->dev, "device creation on %s failed\n",
+								gd->name);
+
+	return 0;
+}
+
+static __devexit int gpmc_free_irq(struct gpmc *gpmc)
+{
+	/* TODO: free gpmc irq chip */
+
+	if (gpmc->master_irq)
+		free_irq(gpmc->master_irq, gpmc);
+
+	return 0;
+}
+
+static __devexit int gpmc_remove(struct platform_device *pdev)
+{
+	struct gpmc *gpmc = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	gpmc_free_irq(gpmc);
+
+	return 0;
+}
+
+static struct platform_driver gpmc_driver = {
+	.probe		= gpmc_probe,
+	.remove		= __devexit_p(gpmc_remove),
+	.driver		= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(gpmc_driver);
+
 #ifdef CONFIG_ARCH_OMAP3
 static struct omap3_gpmc_regs gpmc_context;
 
@@ -855,10 +1193,10 @@ int gpmc_enable_hwecc(int cs, int mode, int dev_width, int ecc_size)
 	unsigned int val;
 
 	/* check if ecc module is in used */
-	if (gpmc_ecc_used != -EINVAL)
+	if (gpmc->ecc_used != -EINVAL)
 		return -EINVAL;
 
-	gpmc_ecc_used = cs;
+	gpmc->ecc_used = cs;
 
 	/* clear ecc and enable bits */
 	val = ((0x00000001<<8) | 0x00000001);
@@ -906,7 +1244,7 @@ int gpmc_calculate_ecc(int cs, const u_char *dat, u_char *ecc_code)
 {
 	unsigned int val = 0x0;
 
-	if (gpmc_ecc_used != cs)
+	if (gpmc->ecc_used != cs)
 		return -EINVAL;
 
 	/* read ecc result */
@@ -916,7 +1254,7 @@ int gpmc_calculate_ecc(int cs, const u_char *dat, u_char *ecc_code)
 	/* P2048o, P1024o, P512o, P256o, P2048e, P1024e, P512e, P256e */
 	*ecc_code++ = ((val >> 8) & 0x0f) | ((val >> 20) & 0xf0);
 
-	gpmc_ecc_used = -EINVAL;
+	gpmc->ecc_used = -EINVAL;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gpmc_calculate_ecc);
diff --git a/arch/arm/plat-omap/include/plat/gpmc.h b/arch/arm/plat-omap/include/plat/gpmc.h
index 1527929..fa62cdf 100644
--- a/arch/arm/plat-omap/include/plat/gpmc.h
+++ b/arch/arm/plat-omap/include/plat/gpmc.h
@@ -36,6 +36,7 @@
 #define GPMC_PREFETCH_FIFO_CNT	0x00000007 /* bytes available in FIFO for r/w */
 #define GPMC_PREFETCH_COUNT	0x00000008 /* remaining bytes to be read/write*/
 #define GPMC_STATUS_BUFFER	0x00000009 /* 1: buffer is available to write */
+#define GPMC_CONFIG_WAITPIN	0x0000000A
 
 #define GPMC_NAND_COMMAND	0x0000000a
 #define GPMC_NAND_ADDRESS	0x0000000b
@@ -83,6 +84,17 @@
 #define GPMC_IRQ_FIFOEVENTENABLE	0x01
 #define GPMC_IRQ_COUNT_EVENT		0x02
 
+#define	GPMC_IRQ_FIFOEVENT		BIT(0)
+#define	GPMC_IRQ_TERMINALCOUNT		BIT(1)
+#define	GPMC_IRQ_WAIT0EDGEDETECTION	BIT(8)
+#define	GPMC_IRQ_WAIT1EDGEDETECTION	BIT(9)
+#define	GPMC_IRQ_WAIT2EDGEDETECTION	BIT(10)
+#define	GPMC_IRQ_WAIT3EDGEDETECTION	BIT(11)
+#define	GPMC_IRQ_MASK	\
+	(GPMC_IRQ_FIFOEVENT | GPMC_IRQ_TERMINALCOUNT | \
+	GPMC_IRQ_WAIT0EDGEDETECTION | GPMC_IRQ_WAIT1EDGEDETECTION | \
+	GPMC_IRQ_WAIT2EDGEDETECTION | GPMC_IRQ_WAIT3EDGEDETECTION)
+
 #define PREFETCH_FIFOTHRESHOLD_MAX	0x40
 #define PREFETCH_FIFOTHRESHOLD(val)	((val) << 8)
 
@@ -131,6 +143,42 @@ struct gpmc_timings {
 	u16 wr_data_mux_bus;	/* WRDATAONADMUXBUS */
 };
 
+struct gpmc_config {
+	int cmd;
+	int val;
+};
+
+struct gpmc_cs_data {
+	unsigned		cs;
+	unsigned long		mem_size;
+	unsigned long		mem_start;
+	unsigned long		mem_offset;
+	struct gpmc_config	*config;
+	unsigned		num_config;
+	struct gpmc_timings	*timing;
+	unsigned		irq_flags;
+};
+
+struct gpmc_device_pdata {
+	char			*name;
+	int			id;
+	void			*pdata;
+	unsigned		pdata_size;
+	/* resources configured via GPMC will be created by GPMC driver */
+	struct resource		*per_res;
+	unsigned		num_per_res;
+	struct gpmc_cs_data	*cs_data;
+	unsigned		num_cs;
+};
+
+struct gpmc_pdata {
+	/* GPMC_FCLK period in picoseconds */
+	unsigned long			fclk_period;
+	struct gpmc_device_pdata	**device_pdata;
+	unsigned			irq_start;
+	unsigned			num_irq;
+};
+
 extern unsigned int gpmc_ns_to_ticks(unsigned int time_ns);
 extern unsigned int gpmc_ps_to_ticks(unsigned int time_ps);
 extern unsigned int gpmc_ticks_to_ns(unsigned int ticks);
@@ -143,8 +191,6 @@ extern int gpmc_cs_calc_divider(int cs, unsigned int sync_clk);
 extern int gpmc_cs_set_timings(int cs, const struct gpmc_timings *t);
 extern int gpmc_cs_request(int cs, unsigned long size, unsigned long *base);
 extern void gpmc_cs_free(int cs);
-extern int gpmc_cs_set_reserved(int cs, int reserved);
-extern int gpmc_cs_reserved(int cs);
 extern int gpmc_prefetch_enable(int cs, int fifo_th, int dma_mode,
 					unsigned int u32_count, int is_write);
 extern int gpmc_prefetch_reset(int cs);
-- 
1.7.9.3

