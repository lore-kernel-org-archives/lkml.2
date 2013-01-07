Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3AGLYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:24:44 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56295 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3AGLYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:24:40 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tong Liu <tong.liu@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 09/16] dmaengine: ste_dma40: support more than 128 event lines
Date: Mon,  7 Jan 2013 12:21:51 +0100
Message-Id: <1357557718-15676-10-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tong Liu <tong.liu@stericsson.com>

U8540 DMA controller is different from u9540 we need define new
registers and use them to support handling more than 128 event lines.

Signed-off-by: Tong Liu <tong.liu@stericsson.com>
Reviewed-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40.c    | 306 +++++++++++++++++++++++++++++++++------------
 drivers/dma/ste_dma40_ll.h | 130 ++++++++++++++++++-
 2 files changed, 355 insertions(+), 81 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ca18117..67e565b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -53,6 +53,8 @@
 #define D40_ALLOC_PHY		(1 << 30)
 #define D40_ALLOC_LOG_FREE	0
 
+#define MAX(a, b) (((a) < (b)) ? (b) : (a))
+
 /**
  * enum 40_command - The different commands and/or statuses.
  *
@@ -100,8 +102,19 @@ static u32 d40_backup_regs[] = {
 
 #define BACKUP_REGS_SZ ARRAY_SIZE(d40_backup_regs)
 
-/* TODO: Check if all these registers have to be saved/restored on dma40 v3 */
-static u32 d40_backup_regs_v3[] = {
+/*
+ * since 9540 and 8540 has the same HW revision
+ * use v4a for 9540 or ealier
+ * use v4b for 8540 or later
+ * HW revision:
+ * DB8500ed has revision 0
+ * DB8500v1 has revision 2
+ * DB8500v2 has revision 3
+ * AP9540v1 has revision 4
+ * DB8540v1 has revision 4
+ * TODO: Check if all these registers have to be saved/restored on dma40 v4a
+ */
+static u32 d40_backup_regs_v4a[] = {
 	D40_DREG_PSEG1,
 	D40_DREG_PSEG2,
 	D40_DREG_PSEG3,
@@ -120,7 +133,32 @@ static u32 d40_backup_regs_v3[] = {
 	D40_DREG_RCEG4,
 };
 
-#define BACKUP_REGS_SZ_V3 ARRAY_SIZE(d40_backup_regs_v3)
+#define BACKUP_REGS_SZ_V4A ARRAY_SIZE(d40_backup_regs_v4a)
+
+static u32 d40_backup_regs_v4b[] = {
+	D40_DREG_CPSEG1,
+	D40_DREG_CPSEG2,
+	D40_DREG_CPSEG3,
+	D40_DREG_CPSEG4,
+	D40_DREG_CPSEG5,
+	D40_DREG_CPCEG1,
+	D40_DREG_CPCEG2,
+	D40_DREG_CPCEG3,
+	D40_DREG_CPCEG4,
+	D40_DREG_CPCEG5,
+	D40_DREG_CRSEG1,
+	D40_DREG_CRSEG2,
+	D40_DREG_CRSEG3,
+	D40_DREG_CRSEG4,
+	D40_DREG_CRSEG5,
+	D40_DREG_CRCEG1,
+	D40_DREG_CRCEG2,
+	D40_DREG_CRCEG3,
+	D40_DREG_CRCEG4,
+	D40_DREG_CRCEG5,
+};
+
+#define BACKUP_REGS_SZ_V4B ARRAY_SIZE(d40_backup_regs_v4b)
 
 static u32 d40_backup_regs_chan[] = {
 	D40_CHAN_REG_SSCFG,
@@ -134,6 +172,102 @@ static u32 d40_backup_regs_chan[] = {
 };
 
 /**
+ * struct d40_interrupt_lookup - lookup table for interrupt handler
+ *
+ * @src: Interrupt mask register.
+ * @clr: Interrupt clear register.
+ * @is_error: true if this is an error interrupt.
+ * @offset: start delta in the lookup_log_chans in d40_base. If equals to
+ * D40_PHY_CHAN, the lookup_phy_chans shall be used instead.
+ */
+struct d40_interrupt_lookup {
+	u32 src;
+	u32 clr;
+	bool is_error;
+	int offset;
+};
+
+
+static struct d40_interrupt_lookup il_v4a[] = {
+	{D40_DREG_LCTIS0, D40_DREG_LCICR0, false,  0},
+	{D40_DREG_LCTIS1, D40_DREG_LCICR1, false, 32},
+	{D40_DREG_LCTIS2, D40_DREG_LCICR2, false, 64},
+	{D40_DREG_LCTIS3, D40_DREG_LCICR3, false, 96},
+	{D40_DREG_LCEIS0, D40_DREG_LCICR0, true,   0},
+	{D40_DREG_LCEIS1, D40_DREG_LCICR1, true,  32},
+	{D40_DREG_LCEIS2, D40_DREG_LCICR2, true,  64},
+	{D40_DREG_LCEIS3, D40_DREG_LCICR3, true,  96},
+	{D40_DREG_PCTIS,  D40_DREG_PCICR,  false, D40_PHY_CHAN},
+	{D40_DREG_PCEIS,  D40_DREG_PCICR,  true,  D40_PHY_CHAN},
+};
+
+static struct d40_interrupt_lookup il_v4b[] = {
+	{D40_DREG_CLCTIS1, D40_DREG_CLCICR1, false,  0},
+	{D40_DREG_CLCTIS2, D40_DREG_CLCICR2, false, 32},
+	{D40_DREG_CLCTIS3, D40_DREG_CLCICR3, false, 64},
+	{D40_DREG_CLCTIS4, D40_DREG_CLCICR4, false, 96},
+	{D40_DREG_CLCTIS5, D40_DREG_CLCICR5, false, 128},
+	{D40_DREG_CLCEIS1, D40_DREG_CLCICR1, true,   0},
+	{D40_DREG_CLCEIS2, D40_DREG_CLCICR2, true,  32},
+	{D40_DREG_CLCEIS3, D40_DREG_CLCICR3, true,  64},
+	{D40_DREG_CLCEIS4, D40_DREG_CLCICR4, true,  96},
+	{D40_DREG_CLCEIS5, D40_DREG_CLCICR5, true,  128},
+	{D40_DREG_CPCTIS,  D40_DREG_CPCICR,  false, D40_PHY_CHAN},
+	{D40_DREG_CPCEIS,  D40_DREG_CPCICR,  true,  D40_PHY_CHAN},
+};
+
+/**
+ * struct d40_reg_val - simple lookup struct
+ *
+ * @reg: The register.
+ * @val: The value that belongs to the register in reg.
+ */
+struct d40_reg_val {
+	unsigned int reg;
+	unsigned int val;
+};
+
+static __initdata struct d40_reg_val dma_init_reg_v4a[] = {
+	/* Clock every part of the DMA block from start */
+	{ .reg = D40_DREG_GCC,    .val = D40_DREG_GCC_ENABLE_ALL},
+
+	/* Interrupts on all logical channels */
+	{ .reg = D40_DREG_LCMIS0, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_LCMIS1, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_LCMIS2, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_LCMIS3, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_LCICR0, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_LCICR1, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_LCICR2, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_LCICR3, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_LCTIS0, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_LCTIS1, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_LCTIS2, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_LCTIS3, .val = 0xFFFFFFFF}
+};
+static __initdata struct d40_reg_val dma_init_reg_v4b[] = {
+	/* Clock every part of the DMA block from start */
+	{ .reg = D40_DREG_GCC,    .val = D40_DREG_GCC_ENABLE_ALL},
+
+	/* Interrupts on all logical channels */
+	{ .reg = D40_DREG_CLCMIS1, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCMIS2, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCMIS3, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCMIS4, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCMIS5, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCICR1, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCICR2, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCICR3, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCICR4, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCICR5, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCTIS1, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCTIS2, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCTIS3, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCTIS4, .val = 0xFFFFFFFF},
+	{ .reg = D40_DREG_CLCTIS5, .val = 0xFFFFFFFF}
+};
+
+/**
  * struct d40_lli_pool - Structure for keeping LLIs in memory
  *
  * @base: Pointer to memory area when the pre_alloc_lli's are not large
@@ -289,6 +423,38 @@ struct d40_chan {
 };
 
 /**
+ * struct d40_gen_dmac - generic values to represent u8500/u8540 DMA
+ * controller
+ *
+ * @backup: the pointer to the registers address array for backup
+ * @backup_size: the size of the registers address array for backup
+ * @realtime_en: the realtime enable register
+ * @realtime_clear: the realtime clear register
+ * @high_prio_en: the high priority enable register
+ * @high_prio_clear: the high priority clear register
+ * @interrupt_en: the interrupt enable register
+ * @interrupt_clear: the interrupt clear register
+ * @il: the pointer to struct d40_interrupt_lookup
+ * @il_size: the size of d40_interrupt_lookup array
+ * @init_reg: the pointer to the struct d40_reg_val
+ * @init_reg_size: the size of d40_reg_val array
+ */
+struct d40_gen_dmac {
+	u32				*backup;
+	u32				 backup_size;
+	u32				 realtime_en;
+	u32				 realtime_clear;
+	u32				 high_prio_en;
+	u32				 high_prio_clear;
+	u32				 interrupt_en;
+	u32				 interrupt_clear;
+	struct d40_interrupt_lookup	*il;
+	u32				 il_size;
+	struct d40_reg_val		*init_reg;
+	u32				 init_reg_size;
+};
+
+/**
  * struct d40_base - The big global struct, one for each probe'd instance.
  *
  * @interrupt_lock: Lock used to make sure one interrupt is handle a time.
@@ -326,11 +492,13 @@ struct d40_chan {
  * @desc_slab: cache for descriptors.
  * @reg_val_backup: Here the values of some hardware registers are stored
  * before the DMA is powered off. They are restored when the power is back on.
- * @reg_val_backup_v3: Backup of registers that only exits on dma40 v3 and
- * later.
+ * @reg_val_backup_v4: Backup of registers that only exits on dma40 v3 and
+ * later
  * @reg_val_backup_chan: Backup data for standard channel parameter registers.
  * @gcc_pwr_off_mask: Mask to maintain the channels that can be turned off.
  * @initialized: true if the dma has been initialized
+ * @gen_dmac: the struct for generic registers values to represent u8500/8540
+ * DMA controller
  */
 struct d40_base {
 	spinlock_t			 interrupt_lock;
@@ -362,37 +530,11 @@ struct d40_base {
 	resource_size_t			  lcpa_size;
 	struct kmem_cache		 *desc_slab;
 	u32				  reg_val_backup[BACKUP_REGS_SZ];
-	u32				  reg_val_backup_v3[BACKUP_REGS_SZ_V3];
+	u32				  reg_val_backup_v4[MAX(BACKUP_REGS_SZ_V4A, BACKUP_REGS_SZ_V4B)];
 	u32				 *reg_val_backup_chan;
 	u16				  gcc_pwr_off_mask;
 	bool				  initialized;
-};
-
-/**
- * struct d40_interrupt_lookup - lookup table for interrupt handler
- *
- * @src: Interrupt mask register.
- * @clr: Interrupt clear register.
- * @is_error: true if this is an error interrupt.
- * @offset: start delta in the lookup_log_chans in d40_base. If equals to
- * D40_PHY_CHAN, the lookup_phy_chans shall be used instead.
- */
-struct d40_interrupt_lookup {
-	u32 src;
-	u32 clr;
-	bool is_error;
-	int offset;
-};
-
-/**
- * struct d40_reg_val - simple lookup struct
- *
- * @reg: The register.
- * @val: The value that belongs to the register in reg.
- */
-struct d40_reg_val {
-	unsigned int reg;
-	unsigned int val;
+	struct d40_gen_dmac		  gen_dmac;
 };
 
 static struct device *chan2dev(struct d40_chan *d40c)
@@ -875,11 +1017,11 @@ static void d40_save_restore_registers(struct d40_base *base, bool save)
 		     save);
 
 	/* Save/Restore registers only existing on dma40 v3 and later */
-	if (base->rev >= 3)
-		dma40_backup(base->virtbase, base->reg_val_backup_v3,
-			     d40_backup_regs_v3,
-			     ARRAY_SIZE(d40_backup_regs_v3),
-			     save);
+	if (base->gen_dmac.backup)
+		dma40_backup(base->virtbase, base->reg_val_backup_v4,
+			     base->gen_dmac.backup,
+			base->gen_dmac.backup_size,
+			save);
 }
 #else
 static void d40_save_restore_registers(struct d40_base *base, bool save)
@@ -1470,41 +1612,30 @@ err:
 
 static irqreturn_t d40_handle_interrupt(int irq, void *data)
 {
-	static const struct d40_interrupt_lookup il[] = {
-		{D40_DREG_LCTIS0, D40_DREG_LCICR0, false,  0},
-		{D40_DREG_LCTIS1, D40_DREG_LCICR1, false, 32},
-		{D40_DREG_LCTIS2, D40_DREG_LCICR2, false, 64},
-		{D40_DREG_LCTIS3, D40_DREG_LCICR3, false, 96},
-		{D40_DREG_LCEIS0, D40_DREG_LCICR0, true,   0},
-		{D40_DREG_LCEIS1, D40_DREG_LCICR1, true,  32},
-		{D40_DREG_LCEIS2, D40_DREG_LCICR2, true,  64},
-		{D40_DREG_LCEIS3, D40_DREG_LCICR3, true,  96},
-		{D40_DREG_PCTIS,  D40_DREG_PCICR,  false, D40_PHY_CHAN},
-		{D40_DREG_PCEIS,  D40_DREG_PCICR,  true,  D40_PHY_CHAN},
-	};
-
 	int i;
-	u32 regs[ARRAY_SIZE(il)];
 	u32 idx;
 	u32 row;
 	long chan = -1;
 	struct d40_chan *d40c;
 	unsigned long flags;
 	struct d40_base *base = data;
+	u32 regs[base->gen_dmac.il_size];
+	struct d40_interrupt_lookup *il = base->gen_dmac.il;
+	u32 il_size = base->gen_dmac.il_size;
 
 	spin_lock_irqsave(&base->interrupt_lock, flags);
 
 	/* Read interrupt status of both logical and physical channels */
-	for (i = 0; i < ARRAY_SIZE(il); i++)
+	for (i = 0; i < il_size; i++)
 		regs[i] = readl(base->virtbase + il[i].src);
 
 	for (;;) {
 
 		chan = find_next_bit((unsigned long *)regs,
-				     BITS_PER_LONG * ARRAY_SIZE(il), chan + 1);
+				     BITS_PER_LONG * il_size, chan + 1);
 
 		/* No more set bits found? */
-		if (chan == BITS_PER_LONG * ARRAY_SIZE(il))
+		if (chan == BITS_PER_LONG * il_size)
 			break;
 
 		row = chan / BITS_PER_LONG;
@@ -2189,12 +2320,14 @@ static void __d40_set_prio_rt(struct d40_chan *d40c, int dev_type, bool src)
 {
 	bool realtime = d40c->dma_cfg.realtime;
 	bool highprio = d40c->dma_cfg.high_priority;
-	u32 rtreg = realtime ? D40_DREG_RSEG1 : D40_DREG_RCEG1;
+	u32 rtreg;
 	u32 event = D40_TYPE_TO_EVENT(dev_type);
 	u32 group = D40_TYPE_TO_GROUP(dev_type);
 	u32 bit = 1 << event;
 	u32 prioreg;
+	struct d40_gen_dmac *dmac = &d40c->base->gen_dmac;
 
+	rtreg = realtime ? dmac->realtime_en : dmac->realtime_clear;
 	/*
 	 * Due to a hardware bug, in some cases a logical channel triggered by
 	 * a high priority destination event line can generate extra packet
@@ -2206,7 +2339,7 @@ static void __d40_set_prio_rt(struct d40_chan *d40c, int dev_type, bool src)
 	if (!src && chan_is_logical(d40c))
 		highprio = false;
 
-	prioreg = highprio ? D40_DREG_PSEG1 : D40_DREG_PCEG1;
+	prioreg = highprio ? dmac->high_prio_en : dmac->high_prio_clear;
 
 	/* Destination event lines are stored in the upper halfword */
 	if (!src)
@@ -3056,6 +3189,36 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	base->phy_chans = ((void *)base) + ALIGN(sizeof(struct d40_base), 4);
 	base->log_chans = &base->phy_chans[num_phy_chans];
 
+	if (base->plat_data->num_of_phy_chans == 14) {
+		base->gen_dmac.backup = d40_backup_regs_v4b;
+		base->gen_dmac.backup_size = BACKUP_REGS_SZ_V4B;
+		base->gen_dmac.interrupt_en = D40_DREG_CPCMIS;
+		base->gen_dmac.interrupt_clear = D40_DREG_CPCICR;
+		base->gen_dmac.realtime_en = D40_DREG_CRSEG1;
+		base->gen_dmac.realtime_clear = D40_DREG_CRCEG1;
+		base->gen_dmac.high_prio_en = D40_DREG_CPSEG1;
+		base->gen_dmac.high_prio_clear = D40_DREG_CPCEG1;
+		base->gen_dmac.il = il_v4b;
+		base->gen_dmac.il_size = ARRAY_SIZE(il_v4b);
+		base->gen_dmac.init_reg = dma_init_reg_v4b;
+		base->gen_dmac.init_reg_size = ARRAY_SIZE(dma_init_reg_v4b);
+	} else {
+		if (base->rev >= 3) {
+			base->gen_dmac.backup = d40_backup_regs_v4a;
+			base->gen_dmac.backup_size = BACKUP_REGS_SZ_V4A;
+		}
+		base->gen_dmac.interrupt_en = D40_DREG_PCMIS;
+		base->gen_dmac.interrupt_clear = D40_DREG_PCICR;
+		base->gen_dmac.realtime_en = D40_DREG_RSEG1;
+		base->gen_dmac.realtime_clear = D40_DREG_RCEG1;
+		base->gen_dmac.high_prio_en = D40_DREG_PSEG1;
+		base->gen_dmac.high_prio_clear = D40_DREG_PCEG1;
+		base->gen_dmac.il = il_v4a;
+		base->gen_dmac.il_size = ARRAY_SIZE(il_v4a);
+		base->gen_dmac.init_reg = dma_init_reg_v4a;
+		base->gen_dmac.init_reg_size = ARRAY_SIZE(dma_init_reg_v4a);
+	}
+
 	base->phy_res = kzalloc(num_phy_chans * sizeof(struct d40_phy_res),
 				GFP_KERNEL);
 	if (!base->phy_res)
@@ -3127,31 +3290,15 @@ failure:
 static void __init d40_hw_init(struct d40_base *base)
 {
 
-	static struct d40_reg_val dma_init_reg[] = {
-		/* Clock every part of the DMA block from start */
-		{ .reg = D40_DREG_GCC,    .val = D40_DREG_GCC_ENABLE_ALL},
-
-		/* Interrupts on all logical channels */
-		{ .reg = D40_DREG_LCMIS0, .val = 0xFFFFFFFF},
-		{ .reg = D40_DREG_LCMIS1, .val = 0xFFFFFFFF},
-		{ .reg = D40_DREG_LCMIS2, .val = 0xFFFFFFFF},
-		{ .reg = D40_DREG_LCMIS3, .val = 0xFFFFFFFF},
-		{ .reg = D40_DREG_LCICR0, .val = 0xFFFFFFFF},
-		{ .reg = D40_DREG_LCICR1, .val = 0xFFFFFFFF},
-		{ .reg = D40_DREG_LCICR2, .val = 0xFFFFFFFF},
-		{ .reg = D40_DREG_LCICR3, .val = 0xFFFFFFFF},
-		{ .reg = D40_DREG_LCTIS0, .val = 0xFFFFFFFF},
-		{ .reg = D40_DREG_LCTIS1, .val = 0xFFFFFFFF},
-		{ .reg = D40_DREG_LCTIS2, .val = 0xFFFFFFFF},
-		{ .reg = D40_DREG_LCTIS3, .val = 0xFFFFFFFF}
-	};
 	int i;
 	u32 prmseo[2] = {0, 0};
 	u32 activeo[2] = {0xFFFFFFFF, 0xFFFFFFFF};
 	u32 pcmis = 0;
 	u32 pcicr = 0;
+	struct d40_reg_val *dma_init_reg = base->gen_dmac.init_reg;
+	u32 reg_size = base->gen_dmac.init_reg_size;
 
-	for (i = 0; i < ARRAY_SIZE(dma_init_reg); i++)
+	for (i = 0; i < reg_size; i++)
 		writel(dma_init_reg[i].val,
 		       base->virtbase + dma_init_reg[i].reg);
 
@@ -3184,11 +3331,14 @@ static void __init d40_hw_init(struct d40_base *base)
 	writel(activeo[0], base->virtbase + D40_DREG_ACTIVO);
 
 	/* Write which interrupt to enable */
-	writel(pcmis, base->virtbase + D40_DREG_PCMIS);
+	writel(pcmis, base->virtbase + base->gen_dmac.interrupt_en);
 
 	/* Write which interrupt to clear */
-	writel(pcicr, base->virtbase + D40_DREG_PCICR);
+	writel(pcicr, base->virtbase + base->gen_dmac.interrupt_clear);
 
+	/* These are __initdata and cannot be accessed after init */
+	base->gen_dmac.init_reg = NULL;
+	base->gen_dmac.init_reg_size = 0;
 }
 
 static int __init d40_lcla_allocate(struct d40_base *base)
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 6d47373..fdde8ef 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -125,7 +125,7 @@
 #define D40_DREG_GCC		0x000
 #define D40_DREG_GCC_ENA	0x1
 /* This assumes that there are only 4 event groups */
-#define D40_DREG_GCC_ENABLE_ALL	0xff01
+#define D40_DREG_GCC_ENABLE_ALL	0x3ff01
 #define D40_DREG_GCC_EVTGRP_POS 8
 #define D40_DREG_GCC_SRC 0
 #define D40_DREG_GCC_DST 1
@@ -148,14 +148,31 @@
 
 #define D40_DREG_LCPA		0x020
 #define D40_DREG_LCLA		0x024
+
+#define D40_DREG_SSEG1		0x030
+#define D40_DREG_SSEG2		0x034
+#define D40_DREG_SSEG3		0x038
+#define D40_DREG_SSEG4		0x03C
+
+#define D40_DREG_SCEG1		0x040
+#define D40_DREG_SCEG2		0x044
+#define D40_DREG_SCEG3		0x048
+#define D40_DREG_SCEG4		0x04C
+
 #define D40_DREG_ACTIVE		0x050
 #define D40_DREG_ACTIVO		0x054
-#define D40_DREG_FSEB1		0x058
-#define D40_DREG_FSEB2		0x05C
+#define D40_DREG_CIDMOD		0x058
+#define D40_DREG_TCIDV		0x05C
 #define D40_DREG_PCMIS		0x060
 #define D40_DREG_PCICR		0x064
 #define D40_DREG_PCTIS		0x068
 #define D40_DREG_PCEIS		0x06C
+
+#define D40_DREG_SPCMIS		0x070
+#define D40_DREG_SPCICR		0x074
+#define D40_DREG_SPCTIS		0x078
+#define D40_DREG_SPCEIS		0x07C
+
 #define D40_DREG_LCMIS0		0x080
 #define D40_DREG_LCMIS1		0x084
 #define D40_DREG_LCMIS2		0x088
@@ -172,6 +189,33 @@
 #define D40_DREG_LCEIS1		0x0B4
 #define D40_DREG_LCEIS2		0x0B8
 #define D40_DREG_LCEIS3		0x0BC
+
+#define D40_DREG_SLCMIS1	0x0C0
+#define D40_DREG_SLCMIS2	0x0C4
+#define D40_DREG_SLCMIS3	0x0C8
+#define D40_DREG_SLCMIS4	0x0CC
+
+#define D40_DREG_SLCICR1	0x0D0
+#define D40_DREG_SLCICR2	0x0D4
+#define D40_DREG_SLCICR3	0x0D8
+#define D40_DREG_SLCICR4	0x0DC
+
+#define D40_DREG_SLCTIS1	0x0E0
+#define D40_DREG_SLCTIS2	0x0E4
+#define D40_DREG_SLCTIS3	0x0E8
+#define D40_DREG_SLCTIS4	0x0EC
+
+#define D40_DREG_SLCEIS1	0x0F0
+#define D40_DREG_SLCEIS2	0x0F4
+#define D40_DREG_SLCEIS3	0x0F8
+#define D40_DREG_SLCEIS4	0x0FC
+
+#define D40_DREG_FSESS1		0x100
+#define D40_DREG_FSESS2		0x104
+
+#define D40_DREG_FSEBS1		0x108
+#define D40_DREG_FSEBS2		0x10C
+
 #define D40_DREG_PSEG1		0x110
 #define D40_DREG_PSEG2		0x114
 #define D40_DREG_PSEG3		0x118
@@ -188,6 +232,86 @@
 #define D40_DREG_RCEG2		0x144
 #define D40_DREG_RCEG3		0x148
 #define D40_DREG_RCEG4		0x14C
+
+#define D40_DREG_PREFOT		0x15C
+#define D40_DREG_EXTCFG		0x160
+
+#define D40_DREG_CPSEG1		0x200
+#define D40_DREG_CPSEG2		0x204
+#define D40_DREG_CPSEG3		0x208
+#define D40_DREG_CPSEG4		0x20C
+#define D40_DREG_CPSEG5		0x210
+
+#define D40_DREG_CPCEG1		0x220
+#define D40_DREG_CPCEG2		0x224
+#define D40_DREG_CPCEG3		0x228
+#define D40_DREG_CPCEG4		0x22C
+#define D40_DREG_CPCEG5		0x230
+
+#define D40_DREG_CRSEG1		0x240
+#define D40_DREG_CRSEG2		0x244
+#define D40_DREG_CRSEG3		0x248
+#define D40_DREG_CRSEG4		0x24C
+#define D40_DREG_CRSEG5		0x250
+
+#define D40_DREG_CRCEG1		0x260
+#define D40_DREG_CRCEG2		0x264
+#define D40_DREG_CRCEG3		0x268
+#define D40_DREG_CRCEG4		0x26C
+#define D40_DREG_CRCEG5		0x270
+
+#define D40_DREG_CFSESS1	0x280
+#define D40_DREG_CFSESS2	0x284
+#define D40_DREG_CFSESS3	0x288
+
+#define D40_DREG_CFSEBS1	0x290
+#define D40_DREG_CFSEBS2	0x294
+#define D40_DREG_CFSEBS3	0x298
+
+#define D40_DREG_CLCMIS1	0x300
+#define D40_DREG_CLCMIS2	0x304
+#define D40_DREG_CLCMIS3	0x308
+#define D40_DREG_CLCMIS4	0x30C
+#define D40_DREG_CLCMIS5	0x310
+
+#define D40_DREG_CLCICR1	0x320
+#define D40_DREG_CLCICR2	0x324
+#define D40_DREG_CLCICR3	0x328
+#define D40_DREG_CLCICR4	0x32C
+#define D40_DREG_CLCICR5	0x330
+
+#define D40_DREG_CLCTIS1	0x340
+#define D40_DREG_CLCTIS2	0x344
+#define D40_DREG_CLCTIS3	0x348
+#define D40_DREG_CLCTIS4	0x34C
+#define D40_DREG_CLCTIS5	0x350
+
+#define D40_DREG_CLCEIS1	0x360
+#define D40_DREG_CLCEIS2	0x364
+#define D40_DREG_CLCEIS3	0x368
+#define D40_DREG_CLCEIS4	0x36C
+#define D40_DREG_CLCEIS5	0x370
+
+#define D40_DREG_CPCMIS		0x380
+#define D40_DREG_CPCICR		0x384
+#define D40_DREG_CPCTIS		0x388
+#define D40_DREG_CPCEIS		0x38C
+
+#define D40_DREG_SCCIDA1	0xE80
+#define D40_DREG_SCCIDA2	0xE90
+#define D40_DREG_SCCIDA3	0xEA0
+#define D40_DREG_SCCIDA4	0xEB0
+#define D40_DREG_SCCIDA5	0xEC0
+
+#define D40_DREG_SCCIDB1	0xE84
+#define D40_DREG_SCCIDB2	0xE94
+#define D40_DREG_SCCIDB3	0xEA4
+#define D40_DREG_SCCIDB4	0xEB4
+#define D40_DREG_SCCIDB5	0xEC4
+
+#define D40_DREG_PRSCCIDA	0xF80
+#define D40_DREG_PRSCCIDB	0xF84
+
 #define D40_DREG_STFU		0xFC8
 #define D40_DREG_ICFG		0xFCC
 #define D40_DREG_PERIPHID0	0xFE0
-- 
1.7.12.1

