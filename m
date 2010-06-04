Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0FDVLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 17:11:41 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42565 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0FDVLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 17:11:38 -0400
Subject: [PATCH 1/2] sparc/of: Move of_device fields into struct pdev_archdata
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       devicetree-discuss@lists.ozlabs.org,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Date: Fri, 04 Jun 2010 15:11:33 -0600
Message-ID: <20100604211132.2762.54164.stgit@angua>
In-Reply-To: <20100604205930.2762.17131.stgit@angua>
References: <20100604205930.2762.17131.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves SPARC architecture specific data members out of
struct of_device and into the pdev_archdata structure.  The reason
for this change is to unify the struct of_device definition amongst
all the architectures.  It also remvoes the .sysdata, .slot, .portid
and .clock_freq properties because they aren't actually used by
anything.

A subsequent patch will replace struct of_device entirely with struct
platform_device and the of_platform support code will share common
routines with the platform bus (but the bus instances themselves can
remain separate).

This patch also adds 'struct resources *resource' and num_resources
to match the fields defined in struct platform_device.  After this
change, 'struct platform_device' can be used as a drop-in replacement
for 'struct of_platform'.

This change is in preparation for merging the of_platform_bus_type
with the platform_bus_type.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
CC: "David S. Miller" <davem@davemloft.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
CC: sparclinux@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: devicetree-discuss@lists.ozlabs.org
---
 arch/sparc/include/asm/device.h      |    5 +++++
 arch/sparc/include/asm/floppy_64.h   |    4 ++--
 arch/sparc/include/asm/of_device.h   |   11 +++--------
 arch/sparc/include/asm/parport.h     |    4 ++--
 arch/sparc/kernel/of_device_32.c     |   28 ++++++++++++----------------
 arch/sparc/kernel/of_device_64.c     |   24 ++++++++++--------------
 arch/sparc/kernel/of_device_common.c |    4 ++--
 arch/sparc/kernel/pci.c              |    2 +-
 arch/sparc/kernel/pci_psycho.c       |    8 ++++----
 arch/sparc/kernel/pci_sabre.c        |    8 ++++----
 arch/sparc/kernel/pci_schizo.c       |   20 ++++++++++----------
 arch/sparc/kernel/power.c            |    2 +-
 drivers/atm/fore200e.c               |    2 +-
 drivers/input/serio/i8042-sparcio.h  |    8 ++++----
 drivers/net/myri_sbus.c              |    2 +-
 drivers/net/niu.c                    |    6 +++---
 drivers/net/sunbmac.c                |    2 +-
 drivers/net/sunhme.c                 |    6 +++---
 drivers/net/sunlance.c               |    2 +-
 drivers/net/sunqe.c                  |    6 +++---
 drivers/parport/parport_sunbpp.c     |    2 +-
 drivers/sbus/char/bbc_i2c.c          |    6 +++---
 drivers/sbus/char/uctrl.c            |    2 +-
 drivers/scsi/qlogicpti.c             |    4 ++--
 drivers/scsi/sun_esp.c               |    2 +-
 drivers/serial/sunhv.c               |    4 ++--
 drivers/serial/sunsab.c              |    2 +-
 drivers/serial/sunsu.c               |    2 +-
 drivers/serial/sunzilog.c            |   10 +++++-----
 drivers/watchdog/cpwd.c              |    2 +-
 sound/sparc/amd7930.c                |    2 +-
 sound/sparc/cs4231.c                 |   14 +++++++-------
 sound/sparc/dbri.c                   |    2 +-
 33 files changed, 100 insertions(+), 108 deletions(-)

diff --git a/arch/sparc/include/asm/device.h b/arch/sparc/include/asm/device.h
index d4c4521..f9740d0 100644
--- a/arch/sparc/include/asm/device.h
+++ b/arch/sparc/include/asm/device.h
@@ -6,6 +6,8 @@
 #ifndef _ASM_SPARC_DEVICE_H
 #define _ASM_SPARC_DEVICE_H
 
+#include <asm/openprom.h>
+
 struct device_node;
 struct of_device;
 
@@ -18,6 +20,9 @@ struct dev_archdata {
 };
 
 struct pdev_archdata {
+	struct resource		resource[PROMREG_MAX];
+	unsigned int		irqs[PROMINTR_MAX];
+	int			num_irqs;
 };
 
 #endif /* _ASM_SPARC_DEVICE_H */
diff --git a/arch/sparc/include/asm/floppy_64.h b/arch/sparc/include/asm/floppy_64.h
index 8fac3ab..4f5bde6 100644
--- a/arch/sparc/include/asm/floppy_64.h
+++ b/arch/sparc/include/asm/floppy_64.h
@@ -567,7 +567,7 @@ static unsigned long __init sun_floppy_init(void)
 	}
 	if (op) {
 		floppy_op = op;
-		FLOPPY_IRQ = op->irqs[0];
+		FLOPPY_IRQ = op->archdata.irqs[0];
 	} else {
 		struct device_node *ebus_dp;
 		void __iomem *auxio_reg;
@@ -593,7 +593,7 @@ static unsigned long __init sun_floppy_init(void)
 		if (state_prop && !strncmp(state_prop, "disabled", 8))
 			return 0;
 
-		FLOPPY_IRQ = op->irqs[0];
+		FLOPPY_IRQ = op->archdata.irqs[0];
 
 		/* Make sure the high density bit is set, some systems
 		 * (most notably Ultra5/Ultra10) come up with it clear.
diff --git a/arch/sparc/include/asm/of_device.h b/arch/sparc/include/asm/of_device.h
index f320246..6d1844a 100644
--- a/arch/sparc/include/asm/of_device.h
+++ b/arch/sparc/include/asm/of_device.h
@@ -15,15 +15,10 @@
 struct of_device
 {
 	struct device			dev;
-	struct resource			resource[PROMREG_MAX];
-	unsigned int			irqs[PROMINTR_MAX];
-	int				num_irqs;
+	u32				num_resources;
+	struct resource			*resource;
 
-	void				*sysdata;
-
-	int				slot;
-	int				portid;
-	int				clock_freq;
+	struct pdev_archdata		archdata;
 };
 
 extern void __iomem *of_ioremap(struct resource *res, unsigned long offset, unsigned long size, char *name);
diff --git a/arch/sparc/include/asm/parport.h b/arch/sparc/include/asm/parport.h
index c333b8d..0c34a87 100644
--- a/arch/sparc/include/asm/parport.h
+++ b/arch/sparc/include/asm/parport.h
@@ -116,7 +116,7 @@ static int __devinit ecpp_probe(struct of_device *op, const struct of_device_id
 	parent = op->dev.of_node->parent;
 	if (!strcmp(parent->name, "dma")) {
 		p = parport_pc_probe_port(base, base + 0x400,
-					  op->irqs[0], PARPORT_DMA_NOFIFO,
+					  op->archdata.irqs[0], PARPORT_DMA_NOFIFO,
 					  op->dev.parent->parent, 0);
 		if (!p)
 			return -ENOMEM;
@@ -166,7 +166,7 @@ static int __devinit ecpp_probe(struct of_device *op, const struct of_device_id
 		       0, PTR_LPT_REG_DIR);
 
 	p = parport_pc_probe_port(base, base + 0x400,
-				  op->irqs[0],
+				  op->archdata.irqs[0],
 				  slot,
 				  op->dev.parent,
 				  0);
diff --git a/arch/sparc/kernel/of_device_32.c b/arch/sparc/kernel/of_device_32.c
index 47e63f1..331de91 100644
--- a/arch/sparc/kernel/of_device_32.c
+++ b/arch/sparc/kernel/of_device_32.c
@@ -267,6 +267,8 @@ static void __init build_device_resources(struct of_device *op,
 	/* Conver to num-entries.  */
 	num_reg /= na + ns;
 
+	op->resource = op->archdata.resource;
+	op->num_resources = num_reg;
 	for (index = 0; index < num_reg; index++) {
 		struct resource *r = &op->resource[index];
 		u32 addr[OF_MAX_ADDR_CELLS];
@@ -349,27 +351,21 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 
 	op->dev.of_node = dp;
 
-	op->clock_freq = of_getintprop_default(dp, "clock-frequency",
-					       (25*1000*1000));
-	op->portid = of_getintprop_default(dp, "upa-portid", -1);
-	if (op->portid == -1)
-		op->portid = of_getintprop_default(dp, "portid", -1);
-
 	intr = of_get_property(dp, "intr", &len);
 	if (intr) {
-		op->num_irqs = len / sizeof(struct linux_prom_irqs);
-		for (i = 0; i < op->num_irqs; i++)
-			op->irqs[i] = intr[i].pri;
+		op->archdata.num_irqs = len / sizeof(struct linux_prom_irqs);
+		for (i = 0; i < op->archdata.num_irqs; i++)
+			op->archdata.irqs[i] = intr[i].pri;
 	} else {
 		const unsigned int *irq =
 			of_get_property(dp, "interrupts", &len);
 
 		if (irq) {
-			op->num_irqs = len / sizeof(unsigned int);
-			for (i = 0; i < op->num_irqs; i++)
-				op->irqs[i] = irq[i];
+			op->archdata.num_irqs = len / sizeof(unsigned int);
+			for (i = 0; i < op->archdata.num_irqs; i++)
+				op->archdata.irqs[i] = irq[i];
 		} else {
-			op->num_irqs = 0;
+			op->archdata.num_irqs = 0;
 		}
 	}
 	if (sparc_cpu_model == sun4d) {
@@ -411,8 +407,8 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 			goto build_resources;
 		}
 
-		for (i = 0; i < op->num_irqs; i++) {
-			int this_irq = op->irqs[i];
+		for (i = 0; i < op->archdata.num_irqs; i++) {
+			int this_irq = op->archdata.irqs[i];
 			int sbusl = pil_to_sbus[this_irq];
 
 			if (sbusl)
@@ -420,7 +416,7 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 					    (sbusl << 2) +
 					    slot);
 
-			op->irqs[i] = this_irq;
+			op->archdata.irqs[i] = this_irq;
 		}
 	}
 
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index 1dae807..5e8cbb9 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -344,6 +344,8 @@ static void __init build_device_resources(struct of_device *op,
 		num_reg = PROMREG_MAX;
 	}
 
+	op->resource = op->archdata.resource;
+	op->num_resources = num_reg;
 	for (index = 0; index < num_reg; index++) {
 		struct resource *r = &op->resource[index];
 		u32 addr[OF_MAX_ADDR_CELLS];
@@ -644,31 +646,25 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 
 	op->dev.of_node = dp;
 
-	op->clock_freq = of_getintprop_default(dp, "clock-frequency",
-					       (25*1000*1000));
-	op->portid = of_getintprop_default(dp, "upa-portid", -1);
-	if (op->portid == -1)
-		op->portid = of_getintprop_default(dp, "portid", -1);
-
 	irq = of_get_property(dp, "interrupts", &len);
 	if (irq) {
-		op->num_irqs = len / 4;
+		op->archdata.num_irqs = len / 4;
 
 		/* Prevent overrunning the op->irqs[] array.  */
-		if (op->num_irqs > PROMINTR_MAX) {
+		if (op->archdata.num_irqs > PROMINTR_MAX) {
 			printk(KERN_WARNING "%s: Too many irqs (%d), "
 			       "limiting to %d.\n",
-			       dp->full_name, op->num_irqs, PROMINTR_MAX);
-			op->num_irqs = PROMINTR_MAX;
+			       dp->full_name, op->archdata.num_irqs, PROMINTR_MAX);
+			op->archdata.num_irqs = PROMINTR_MAX;
 		}
-		memcpy(op->irqs, irq, op->num_irqs * 4);
+		memcpy(op->archdata.irqs, irq, op->archdata.num_irqs * 4);
 	} else {
-		op->num_irqs = 0;
+		op->archdata.num_irqs = 0;
 	}
 
 	build_device_resources(op, parent);
-	for (i = 0; i < op->num_irqs; i++)
-		op->irqs[i] = build_one_device_irq(op, parent, op->irqs[i]);
+	for (i = 0; i < op->archdata.num_irqs; i++)
+		op->archdata.irqs[i] = build_one_device_irq(op, parent, op->archdata.irqs[i]);
 
 	op->dev.parent = parent;
 	op->dev.bus = &of_platform_bus_type;
diff --git a/arch/sparc/kernel/of_device_common.c b/arch/sparc/kernel/of_device_common.c
index 10c6c36..016c947 100644
--- a/arch/sparc/kernel/of_device_common.c
+++ b/arch/sparc/kernel/of_device_common.c
@@ -35,10 +35,10 @@ unsigned int irq_of_parse_and_map(struct device_node *node, int index)
 {
 	struct of_device *op = of_find_device_by_node(node);
 
-	if (!op || index >= op->num_irqs)
+	if (!op || index >= op->archdata.num_irqs)
 		return 0;
 
-	return op->irqs[index];
+	return op->archdata.irqs[index];
 }
 EXPORT_SYMBOL(irq_of_parse_and_map);
 
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 8a8363a..1523290 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -340,7 +340,7 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 		dev->hdr_type = PCI_HEADER_TYPE_NORMAL;
 		dev->rom_base_reg = PCI_ROM_ADDRESS;
 
-		dev->irq = sd->op->irqs[0];
+		dev->irq = sd->op->archdata.irqs[0];
 		if (dev->irq == 0xffffffff)
 			dev->irq = PCI_IRQ_NONE;
 	}
diff --git a/arch/sparc/kernel/pci_psycho.c b/arch/sparc/kernel/pci_psycho.c
index 558a705..93011e6 100644
--- a/arch/sparc/kernel/pci_psycho.c
+++ b/arch/sparc/kernel/pci_psycho.c
@@ -302,23 +302,23 @@ static void psycho_register_error_handlers(struct pci_pbm_info *pbm)
 	 * 5: POWER MANAGEMENT
 	 */
 
-	if (op->num_irqs < 6)
+	if (op->archdata.num_irqs < 6)
 		return;
 
 	/* We really mean to ignore the return result here.  Two
 	 * PCI controller share the same interrupt numbers and
 	 * drive the same front-end hardware.
 	 */
-	err = request_irq(op->irqs[1], psycho_ue_intr, IRQF_SHARED,
+	err = request_irq(op->archdata.irqs[1], psycho_ue_intr, IRQF_SHARED,
 			  "PSYCHO_UE", pbm);
-	err = request_irq(op->irqs[2], psycho_ce_intr, IRQF_SHARED,
+	err = request_irq(op->archdata.irqs[2], psycho_ce_intr, IRQF_SHARED,
 			  "PSYCHO_CE", pbm);
 
 	/* This one, however, ought not to fail.  We can just warn
 	 * about it since the system can still operate properly even
 	 * if this fails.
 	 */
-	err = request_irq(op->irqs[0], psycho_pcierr_intr, IRQF_SHARED,
+	err = request_irq(op->archdata.irqs[0], psycho_pcierr_intr, IRQF_SHARED,
 			  "PSYCHO_PCIERR", pbm);
 	if (err)
 		printk(KERN_WARNING "%s: Could not register PCIERR, "
diff --git a/arch/sparc/kernel/pci_sabre.c b/arch/sparc/kernel/pci_sabre.c
index 6dad8e3..99c6dba 100644
--- a/arch/sparc/kernel/pci_sabre.c
+++ b/arch/sparc/kernel/pci_sabre.c
@@ -329,7 +329,7 @@ static void sabre_register_error_handlers(struct pci_pbm_info *pbm)
 	 * 2: CE ERR
 	 * 3: POWER FAIL
 	 */
-	if (op->num_irqs < 4)
+	if (op->archdata.num_irqs < 4)
 		return;
 
 	/* We clear the error bits in the appropriate AFSR before
@@ -341,7 +341,7 @@ static void sabre_register_error_handlers(struct pci_pbm_info *pbm)
 		    SABRE_UEAFSR_SDTE | SABRE_UEAFSR_PDTE),
 		   base + SABRE_UE_AFSR);
 
-	err = request_irq(op->irqs[1], sabre_ue_intr, 0, "SABRE_UE", pbm);
+	err = request_irq(op->archdata.irqs[1], sabre_ue_intr, 0, "SABRE_UE", pbm);
 	if (err)
 		printk(KERN_WARNING "%s: Couldn't register UE, err=%d.\n",
 		       pbm->name, err);
@@ -351,11 +351,11 @@ static void sabre_register_error_handlers(struct pci_pbm_info *pbm)
 		   base + SABRE_CE_AFSR);
 
 
-	err = request_irq(op->irqs[2], sabre_ce_intr, 0, "SABRE_CE", pbm);
+	err = request_irq(op->archdata.irqs[2], sabre_ce_intr, 0, "SABRE_CE", pbm);
 	if (err)
 		printk(KERN_WARNING "%s: Couldn't register CE, err=%d.\n",
 		       pbm->name, err);
-	err = request_irq(op->irqs[0], psycho_pcierr_intr, 0,
+	err = request_irq(op->archdata.irqs[0], psycho_pcierr_intr, 0,
 			  "SABRE_PCIERR", pbm);
 	if (err)
 		printk(KERN_WARNING "%s: Couldn't register PCIERR, err=%d.\n",
diff --git a/arch/sparc/kernel/pci_schizo.c b/arch/sparc/kernel/pci_schizo.c
index 97a1ae2..9041dae 100644
--- a/arch/sparc/kernel/pci_schizo.c
+++ b/arch/sparc/kernel/pci_schizo.c
@@ -857,14 +857,14 @@ static void tomatillo_register_error_handlers(struct pci_pbm_info *pbm)
 	 */
 
 	if (pbm_routes_this_ino(pbm, SCHIZO_UE_INO)) {
-		err = request_irq(op->irqs[1], schizo_ue_intr, 0,
+		err = request_irq(op->archdata.irqs[1], schizo_ue_intr, 0,
 				  "TOMATILLO_UE", pbm);
 		if (err)
 			printk(KERN_WARNING "%s: Could not register UE, "
 			       "err=%d\n", pbm->name, err);
 	}
 	if (pbm_routes_this_ino(pbm, SCHIZO_CE_INO)) {
-		err = request_irq(op->irqs[2], schizo_ce_intr, 0,
+		err = request_irq(op->archdata.irqs[2], schizo_ce_intr, 0,
 				  "TOMATILLO_CE", pbm);
 		if (err)
 			printk(KERN_WARNING "%s: Could not register CE, "
@@ -872,10 +872,10 @@ static void tomatillo_register_error_handlers(struct pci_pbm_info *pbm)
 	}
 	err = 0;
 	if (pbm_routes_this_ino(pbm, SCHIZO_PCIERR_A_INO)) {
-		err = request_irq(op->irqs[0], schizo_pcierr_intr, 0,
+		err = request_irq(op->archdata.irqs[0], schizo_pcierr_intr, 0,
 				  "TOMATILLO_PCIERR", pbm);
 	} else if (pbm_routes_this_ino(pbm, SCHIZO_PCIERR_B_INO)) {
-		err = request_irq(op->irqs[0], schizo_pcierr_intr, 0,
+		err = request_irq(op->archdata.irqs[0], schizo_pcierr_intr, 0,
 				  "TOMATILLO_PCIERR", pbm);
 	}
 	if (err)
@@ -883,7 +883,7 @@ static void tomatillo_register_error_handlers(struct pci_pbm_info *pbm)
 		       "err=%d\n", pbm->name, err);
 
 	if (pbm_routes_this_ino(pbm, SCHIZO_SERR_INO)) {
-		err = request_irq(op->irqs[3], schizo_safarierr_intr, 0,
+		err = request_irq(op->archdata.irqs[3], schizo_safarierr_intr, 0,
 				  "TOMATILLO_SERR", pbm);
 		if (err)
 			printk(KERN_WARNING "%s: Could not register SERR, "
@@ -952,14 +952,14 @@ static void schizo_register_error_handlers(struct pci_pbm_info *pbm)
 	 */
 
 	if (pbm_routes_this_ino(pbm, SCHIZO_UE_INO)) {
-		err = request_irq(op->irqs[1], schizo_ue_intr, 0,
+		err = request_irq(op->archdata.irqs[1], schizo_ue_intr, 0,
 				  "SCHIZO_UE", pbm);
 		if (err)
 			printk(KERN_WARNING "%s: Could not register UE, "
 			       "err=%d\n", pbm->name, err);
 	}
 	if (pbm_routes_this_ino(pbm, SCHIZO_CE_INO)) {
-		err = request_irq(op->irqs[2], schizo_ce_intr, 0,
+		err = request_irq(op->archdata.irqs[2], schizo_ce_intr, 0,
 				  "SCHIZO_CE", pbm);
 		if (err)
 			printk(KERN_WARNING "%s: Could not register CE, "
@@ -967,10 +967,10 @@ static void schizo_register_error_handlers(struct pci_pbm_info *pbm)
 	}
 	err = 0;
 	if (pbm_routes_this_ino(pbm, SCHIZO_PCIERR_A_INO)) {
-		err = request_irq(op->irqs[0], schizo_pcierr_intr, 0,
+		err = request_irq(op->archdata.irqs[0], schizo_pcierr_intr, 0,
 				  "SCHIZO_PCIERR", pbm);
 	} else if (pbm_routes_this_ino(pbm, SCHIZO_PCIERR_B_INO)) {
-		err = request_irq(op->irqs[0], schizo_pcierr_intr, 0,
+		err = request_irq(op->archdata.irqs[0], schizo_pcierr_intr, 0,
 				  "SCHIZO_PCIERR", pbm);
 	}
 	if (err)
@@ -978,7 +978,7 @@ static void schizo_register_error_handlers(struct pci_pbm_info *pbm)
 		       "err=%d\n", pbm->name, err);
 
 	if (pbm_routes_this_ino(pbm, SCHIZO_SERR_INO)) {
-		err = request_irq(op->irqs[3], schizo_safarierr_intr, 0,
+		err = request_irq(op->archdata.irqs[3], schizo_safarierr_intr, 0,
 				  "SCHIZO_SERR", pbm);
 		if (err)
 			printk(KERN_WARNING "%s: Could not register SERR, "
diff --git a/arch/sparc/kernel/power.c b/arch/sparc/kernel/power.c
index 168d4cb..1cfee57 100644
--- a/arch/sparc/kernel/power.c
+++ b/arch/sparc/kernel/power.c
@@ -36,7 +36,7 @@ static int __devinit has_button_interrupt(unsigned int irq, struct device_node *
 static int __devinit power_probe(struct of_device *op, const struct of_device_id *match)
 {
 	struct resource *res = &op->resource[0];
-	unsigned int irq= op->irqs[0];
+	unsigned int irq = op->archdata.irqs[0];
 
 	power_reg = of_ioremap(res, 0, 0x4, "power");
 
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index da8f176..38df87b 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -2657,7 +2657,7 @@ static int __devinit fore200e_sba_probe(struct of_device *op,
 
 	fore200e->bus = bus;
 	fore200e->bus_dev = op;
-	fore200e->irq = op->irqs[0];
+	fore200e->irq = op->archdata.irqs[0];
 	fore200e->phys_base = op->resource[0].start;
 
 	sprintf(fore200e->name, "%s-%d", bus->model_name, index);
diff --git a/drivers/input/serio/i8042-sparcio.h b/drivers/input/serio/i8042-sparcio.h
index 04e32f2..c7d50ff 100644
--- a/drivers/input/serio/i8042-sparcio.h
+++ b/drivers/input/serio/i8042-sparcio.h
@@ -58,9 +58,9 @@ static int __devinit sparc_i8042_probe(struct of_device *op, const struct of_dev
 		if (!strcmp(dp->name, OBP_PS2KBD_NAME1) ||
 		    !strcmp(dp->name, OBP_PS2KBD_NAME2)) {
 			struct of_device *kbd = of_find_device_by_node(dp);
-			unsigned int irq = kbd->irqs[0];
+			unsigned int irq = kbd->archdata.irqs[0];
 			if (irq == 0xffffffff)
-				irq = op->irqs[0];
+				irq = op->archdata.irqs[0];
 			i8042_kbd_irq = irq;
 			kbd_iobase = of_ioremap(&kbd->resource[0],
 						0, 8, "kbd");
@@ -68,9 +68,9 @@ static int __devinit sparc_i8042_probe(struct of_device *op, const struct of_dev
 		} else if (!strcmp(dp->name, OBP_PS2MS_NAME1) ||
 			   !strcmp(dp->name, OBP_PS2MS_NAME2)) {
 			struct of_device *ms = of_find_device_by_node(dp);
-			unsigned int irq = ms->irqs[0];
+			unsigned int irq = ms->archdata.irqs[0];
 			if (irq == 0xffffffff)
-				irq = op->irqs[0];
+				irq = op->archdata.irqs[0];
 			i8042_aux_irq = irq;
 		}
 
diff --git a/drivers/net/myri_sbus.c b/drivers/net/myri_sbus.c
index 1a57c3d..370d3c1 100644
--- a/drivers/net/myri_sbus.c
+++ b/drivers/net/myri_sbus.c
@@ -1079,7 +1079,7 @@ static int __devinit myri_sbus_probe(struct of_device *op, const struct of_devic
 
 	mp->dev = dev;
 	dev->watchdog_timeo = 5*HZ;
-	dev->irq = op->irqs[0];
+	dev->irq = op->archdata.irqs[0];
 	dev->netdev_ops = &myri_ops;
 
 	/* Register interrupt handler now. */
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 63e8e38..5dd50b6 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -9119,12 +9119,12 @@ static int __devinit niu_n2_irq_init(struct niu *np, u8 *ldg_num_map)
 	if (!int_prop)
 		return -ENODEV;
 
-	for (i = 0; i < op->num_irqs; i++) {
+	for (i = 0; i < op->archdata.num_irqs; i++) {
 		ldg_num_map[i] = int_prop[i];
-		np->ldg[i].irq = op->irqs[i];
+		np->ldg[i].irq = op->archdata.irqs[i];
 	}
 
-	np->num_ldg = op->num_irqs;
+	np->num_ldg = op->archdata.num_irqs;
 
 	return 0;
 #else
diff --git a/drivers/net/sunbmac.c b/drivers/net/sunbmac.c
index 367e96f..0b10d24 100644
--- a/drivers/net/sunbmac.c
+++ b/drivers/net/sunbmac.c
@@ -1201,7 +1201,7 @@ static int __devinit bigmac_ether_init(struct of_device *op,
 	dev->watchdog_timeo = 5*HZ;
 
 	/* Finish net device registration. */
-	dev->irq = bp->bigmac_op->irqs[0];
+	dev->irq = bp->bigmac_op->archdata.irqs[0];
 	dev->dma = 0;
 
 	if (register_netdev(dev)) {
diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index 3d9650b..0a63ebe 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -2561,7 +2561,7 @@ static int __init quattro_sbus_register_irqs(void)
 		if (skip)
 			continue;
 
-		err = request_irq(op->irqs[0],
+		err = request_irq(op->archdata.irqs[0],
 				  quattro_sbus_interrupt,
 				  IRQF_SHARED, "Quattro",
 				  qp);
@@ -2590,7 +2590,7 @@ static void quattro_sbus_free_irqs(void)
 		if (skip)
 			continue;
 
-		free_irq(op->irqs[0], qp);
+		free_irq(op->archdata.irqs[0], qp);
 	}
 }
 #endif /* CONFIG_SBUS */
@@ -2790,7 +2790,7 @@ static int __devinit happy_meal_sbus_probe_one(struct of_device *op, int is_qfe)
 	/* Happy Meal can do it all... */
 	dev->features |= NETIF_F_SG | NETIF_F_HW_CSUM;
 
-	dev->irq = op->irqs[0];
+	dev->irq = op->archdata.irqs[0];
 
 #if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
 	/* Hook up SBUS register/descriptor accessors. */
diff --git a/drivers/net/sunlance.c b/drivers/net/sunlance.c
index 7d9c33d..c6bfdad 100644
--- a/drivers/net/sunlance.c
+++ b/drivers/net/sunlance.c
@@ -1474,7 +1474,7 @@ no_link_test:
 	dev->ethtool_ops = &sparc_lance_ethtool_ops;
 	dev->netdev_ops = &sparc_lance_ops;
 
-	dev->irq = op->irqs[0];
+	dev->irq = op->archdata.irqs[0];
 
 	/* We cannot sleep if the chip is busy during a
 	 * multicast list update event, because such events
diff --git a/drivers/net/sunqe.c b/drivers/net/sunqe.c
index 72b579c..4465174 100644
--- a/drivers/net/sunqe.c
+++ b/drivers/net/sunqe.c
@@ -803,7 +803,7 @@ static struct sunqec * __devinit get_qec(struct of_device *child)
 
 			qec_init_once(qecp, op);
 
-			if (request_irq(op->irqs[0], qec_interrupt,
+			if (request_irq(op->archdata.irqs[0], qec_interrupt,
 					IRQF_SHARED, "qec", (void *) qecp)) {
 				printk(KERN_ERR "qec: Can't register irq.\n");
 				goto fail;
@@ -901,7 +901,7 @@ static int __devinit qec_ether_init(struct of_device *op)
 	SET_NETDEV_DEV(dev, &op->dev);
 
 	dev->watchdog_timeo = 5*HZ;
-	dev->irq = op->irqs[0];
+	dev->irq = op->archdata.irqs[0];
 	dev->dma = 0;
 	dev->ethtool_ops = &qe_ethtool_ops;
 	dev->netdev_ops = &qec_ops;
@@ -999,7 +999,7 @@ static void __exit qec_exit(void)
 		struct sunqec *next = root_qec_dev->next_module;
 		struct of_device *op = root_qec_dev->op;
 
-		free_irq(op->irqs[0], (void *) root_qec_dev);
+		free_irq(op->archdata.irqs[0], (void *) root_qec_dev);
 		of_iounmap(&op->resource[0], root_qec_dev->gregs,
 			   GLOB_REG_SIZE);
 		kfree(root_qec_dev);
diff --git a/drivers/parport/parport_sunbpp.c b/drivers/parport/parport_sunbpp.c
index 9a5b4b8..3cdfe96 100644
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -295,7 +295,7 @@ static int __devinit bpp_probe(struct of_device *op, const struct of_device_id *
 	void __iomem *base;
 	struct parport *p;
 
-	irq = op->irqs[0];
+	irq = op->archdata.irqs[0];
 	base = of_ioremap(&op->resource[0], 0,
 			  resource_size(&op->resource[0]),
 			  "sunbpp");
diff --git a/drivers/sbus/char/bbc_i2c.c b/drivers/sbus/char/bbc_i2c.c
index 8bfdd63..40d7a1f 100644
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -317,7 +317,7 @@ static struct bbc_i2c_bus * __init attach_one_i2c(struct of_device *op, int inde
 
 	bp->waiting = 0;
 	init_waitqueue_head(&bp->wq);
-	if (request_irq(op->irqs[0], bbc_i2c_interrupt,
+	if (request_irq(op->archdata.irqs[0], bbc_i2c_interrupt,
 			IRQF_SHARED, "bbc_i2c", bp))
 		goto fail;
 
@@ -373,7 +373,7 @@ static int __devinit bbc_i2c_probe(struct of_device *op,
 
 	err = bbc_envctrl_init(bp);
 	if (err) {
-		free_irq(op->irqs[0], bp);
+		free_irq(op->archdata.irqs[0], bp);
 		if (bp->i2c_bussel_reg)
 			of_iounmap(&op->resource[0], bp->i2c_bussel_reg, 1);
 		if (bp->i2c_control_regs)
@@ -392,7 +392,7 @@ static int __devexit bbc_i2c_remove(struct of_device *op)
 
 	bbc_envctrl_cleanup(bp);
 
-	free_irq(op->irqs[0], bp);
+	free_irq(op->archdata.irqs[0], bp);
 
 	if (bp->i2c_bussel_reg)
 		of_iounmap(&op->resource[0], bp->i2c_bussel_reg, 1);
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index 5f25366..b8b40e9 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -367,7 +367,7 @@ static int __devinit uctrl_probe(struct of_device *op,
 		goto out_free;
 	}
 
-	p->irq = op->irqs[0];
+	p->irq = op->archdata.irqs[0];
 	err = request_irq(p->irq, uctrl_interrupt, 0, "uctrl", p);
 	if (err) {
 		printk(KERN_ERR "uctrl: Unable to register irq.\n");
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index ca5c15c..3f5b541 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -729,7 +729,7 @@ static int __devinit qpti_register_irq(struct qlogicpti *qpti)
 {
 	struct of_device *op = qpti->op;
 
-	qpti->qhost->irq = qpti->irq = op->irqs[0];
+	qpti->qhost->irq = qpti->irq = op->archdata.irqs[0];
 
 	/* We used to try various overly-clever things to
 	 * reduce the interrupt processing overhead on
@@ -1302,7 +1302,7 @@ static int __devinit qpti_sbus_probe(struct of_device *op, const struct of_devic
 	/* Sometimes Antares cards come up not completely
 	 * setup, and we get a report of a zero IRQ.
 	 */
-	if (op->irqs[0] == 0)
+	if (op->archdata.irqs[0] == 0)
 		return -ENODEV;
 
 	host = scsi_host_alloc(tpnt, sizeof(struct qlogicpti));
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 386dd9d..ddc221a 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -116,7 +116,7 @@ static int __devinit esp_sbus_register_irq(struct esp *esp)
 	struct Scsi_Host *host = esp->host;
 	struct of_device *op = esp->dev;
 
-	host->irq = op->irqs[0];
+	host->irq = op->archdata.irqs[0];
 	return request_irq(host->irq, scsi_esp_intr, IRQF_SHARED, "ESP", esp);
 }
 
diff --git a/drivers/serial/sunhv.c b/drivers/serial/sunhv.c
index 890f917..36e2448 100644
--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -525,7 +525,7 @@ static int __devinit hv_probe(struct of_device *op, const struct of_device_id *m
 	unsigned long minor;
 	int err;
 
-	if (op->irqs[0] == 0xffffffff)
+	if (op->archdata.irqs[0] == 0xffffffff)
 		return -ENODEV;
 
 	port = kzalloc(sizeof(struct uart_port), GFP_KERNEL);
@@ -557,7 +557,7 @@ static int __devinit hv_probe(struct of_device *op, const struct of_device_id *m
 
 	port->membase = (unsigned char __iomem *) __pa(port);
 
-	port->irq = op->irqs[0];
+	port->irq = op->archdata.irqs[0];
 
 	port->dev = &op->dev;
 
diff --git a/drivers/serial/sunsab.c b/drivers/serial/sunsab.c
index 5e81bc6..0a7dd68 100644
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -969,7 +969,7 @@ static int __devinit sunsab_init_one(struct uart_sunsab_port *up,
 		return -ENOMEM;
 	up->regs = (union sab82532_async_regs __iomem *) up->port.membase;
 
-	up->port.irq = op->irqs[0];
+	up->port.irq = op->archdata.irqs[0];
 
 	up->port.fifosize = SAB82532_XMIT_FIFO_SIZE;
 	up->port.iotype = UPIO_MEM;
diff --git a/drivers/serial/sunsu.c b/drivers/serial/sunsu.c
index 234459c..56d891a 100644
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1443,7 +1443,7 @@ static int __devinit su_probe(struct of_device *op, const struct of_device_id *m
 		return -ENOMEM;
 	}
 
-	up->port.irq = op->irqs[0];
+	up->port.irq = op->archdata.irqs[0];
 
 	up->port.dev = &op->dev;
 
diff --git a/drivers/serial/sunzilog.c b/drivers/serial/sunzilog.c
index f9a24f4..fcbe20d 100644
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -1426,7 +1426,7 @@ static int __devinit zs_probe(struct of_device *op, const struct of_device_id *m
 	rp = sunzilog_chip_regs[inst];
 
 	if (zilog_irq == -1)
-		zilog_irq = op->irqs[0];
+		zilog_irq = op->archdata.irqs[0];
 
 	up = &sunzilog_port_table[inst * 2];
 
@@ -1434,7 +1434,7 @@ static int __devinit zs_probe(struct of_device *op, const struct of_device_id *m
 	up[0].port.mapbase = op->resource[0].start + 0x00;
 	up[0].port.membase = (void __iomem *) &rp->channelA;
 	up[0].port.iotype = UPIO_MEM;
-	up[0].port.irq = op->irqs[0];
+	up[0].port.irq = op->archdata.irqs[0];
 	up[0].port.uartclk = ZS_CLOCK;
 	up[0].port.fifosize = 1;
 	up[0].port.ops = &sunzilog_pops;
@@ -1451,7 +1451,7 @@ static int __devinit zs_probe(struct of_device *op, const struct of_device_id *m
 	up[1].port.mapbase = op->resource[0].start + 0x04;
 	up[1].port.membase = (void __iomem *) &rp->channelB;
 	up[1].port.iotype = UPIO_MEM;
-	up[1].port.irq = op->irqs[0];
+	up[1].port.irq = op->archdata.irqs[0];
 	up[1].port.uartclk = ZS_CLOCK;
 	up[1].port.fifosize = 1;
 	up[1].port.ops = &sunzilog_pops;
@@ -1492,12 +1492,12 @@ static int __devinit zs_probe(struct of_device *op, const struct of_device_id *m
 		       "is a %s\n",
 		       dev_name(&op->dev),
 		       (unsigned long long) up[0].port.mapbase,
-		       op->irqs[0], sunzilog_type(&up[0].port));
+		       op->archdata.irqs[0], sunzilog_type(&up[0].port));
 		printk(KERN_INFO "%s: Mouse at MMIO 0x%llx (irq = %d) "
 		       "is a %s\n",
 		       dev_name(&op->dev),
 		       (unsigned long long) up[1].port.mapbase,
-		       op->irqs[0], sunzilog_type(&up[1].port));
+		       op->archdata.irqs[0], sunzilog_type(&up[1].port));
 		kbm_inst++;
 	}
 
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index d62b9ce..8c03fd7 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -545,7 +545,7 @@ static int __devinit cpwd_probe(struct of_device *op,
 		goto out;
 	}
 
-	p->irq = op->irqs[0];
+	p->irq = op->archdata.irqs[0];
 
 	spin_lock_init(&p->lock);
 
diff --git a/sound/sparc/amd7930.c b/sound/sparc/amd7930.c
index 71221fd..43c63d4 100644
--- a/sound/sparc/amd7930.c
+++ b/sound/sparc/amd7930.c
@@ -1010,7 +1010,7 @@ static int __devinit amd7930_sbus_probe(struct of_device *op, const struct of_de
 	struct snd_amd7930 *amd;
 	int err, irq;
 
-	irq = op->irqs[0];
+	irq = op->archdata.irqs[0];
 
 	if (dev_num >= SNDRV_CARDS)
 		return -ENODEV;
diff --git a/sound/sparc/cs4231.c b/sound/sparc/cs4231.c
index fb4c6f2..f7f05c2 100644
--- a/sound/sparc/cs4231.c
+++ b/sound/sparc/cs4231.c
@@ -1832,14 +1832,14 @@ static int __devinit snd_cs4231_sbus_create(struct snd_card *card,
 	chip->c_dma.request = sbus_dma_request;
 	chip->c_dma.address = sbus_dma_addr;
 
-	if (request_irq(op->irqs[0], snd_cs4231_sbus_interrupt,
+	if (request_irq(op->archdata.irqs[0], snd_cs4231_sbus_interrupt,
 			IRQF_SHARED, "cs4231", chip)) {
 		snd_printdd("cs4231-%d: Unable to grab SBUS IRQ %d\n",
-			    dev, op->irqs[0]);
+			    dev, op->archdata.irqs[0]);
 		snd_cs4231_sbus_free(chip);
 		return -EBUSY;
 	}
-	chip->irq[0] = op->irqs[0];
+	chip->irq[0] = op->archdata.irqs[0];
 
 	if (snd_cs4231_probe(chip) < 0) {
 		snd_cs4231_sbus_free(chip);
@@ -1870,7 +1870,7 @@ static int __devinit cs4231_sbus_probe(struct of_device *op, const struct of_dev
 		card->shortname,
 		rp->flags & 0xffL,
 		(unsigned long long)rp->start,
-		op->irqs[0]);
+		op->archdata.irqs[0]);
 
 	err = snd_cs4231_sbus_create(card, op, dev);
 	if (err < 0) {
@@ -1979,12 +1979,12 @@ static int __devinit snd_cs4231_ebus_create(struct snd_card *card,
 	chip->c_dma.ebus_info.flags = EBUS_DMA_FLAG_USE_EBDMA_HANDLER;
 	chip->c_dma.ebus_info.callback = snd_cs4231_ebus_capture_callback;
 	chip->c_dma.ebus_info.client_cookie = chip;
-	chip->c_dma.ebus_info.irq = op->irqs[0];
+	chip->c_dma.ebus_info.irq = op->archdata.irqs[0];
 	strcpy(chip->p_dma.ebus_info.name, "cs4231(play)");
 	chip->p_dma.ebus_info.flags = EBUS_DMA_FLAG_USE_EBDMA_HANDLER;
 	chip->p_dma.ebus_info.callback = snd_cs4231_ebus_play_callback;
 	chip->p_dma.ebus_info.client_cookie = chip;
-	chip->p_dma.ebus_info.irq = op->irqs[1];
+	chip->p_dma.ebus_info.irq = op->archdata.irqs[1];
 
 	chip->p_dma.prepare = _ebus_dma_prepare;
 	chip->p_dma.enable = _ebus_dma_enable;
@@ -2060,7 +2060,7 @@ static int __devinit cs4231_ebus_probe(struct of_device *op, const struct of_dev
 	sprintf(card->longname, "%s at 0x%llx, irq %d",
 		card->shortname,
 		op->resource[0].start,
-		op->irqs[0]);
+		op->archdata.irqs[0]);
 
 	err = snd_cs4231_ebus_create(card, op, dev);
 	if (err < 0) {
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 1557bf1..491ce71 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -2608,7 +2608,7 @@ static int __devinit dbri_probe(struct of_device *op, const struct of_device_id
 		return -ENOENT;
 	}
 
-	irq = op->irqs[0];
+	irq = op->archdata.irqs[0];
 	if (irq <= 0) {
 		printk(KERN_ERR "DBRI-%d: No IRQ.\n", dev);
 		return -ENODEV;

