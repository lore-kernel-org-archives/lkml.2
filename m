Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1HLIaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:30:23 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:52230 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639Ab1HLI3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:29:33 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Vijaya Kumar Kilari <vijay.kilari@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 13/23] mfd/db5500-prcmu: update mailbox handling
Date: Fri, 12 Aug 2011 10:29:20 +0200
Message-ID: <1313137760-31015-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

This updates the mailbox handling to be more robust and
adds basic infrastructure for event (IRQ) handling.

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Signed-off-by: Vijaya Kumar Kilari <vijay.kilari@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/include/mach/irqs-db5500.h |   29 ++
 drivers/mfd/db5500-prcmu.c                     |  350 +++++++++++++++++++++++-
 2 files changed, 370 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-ux500/include/mach/irqs-db5500.h b/arch/arm/mach-ux500/include/mach/irqs-db5500.h
index 7723977..d8d00b6 100644
--- a/arch/arm/mach-ux500/include/mach/irqs-db5500.h
+++ b/arch/arm/mach-ux500/include/mach/irqs-db5500.h
@@ -85,6 +85,35 @@
 
 #ifdef CONFIG_UX500_SOC_DB5500
 
+/* Virtual interrupts corresponding to the PRCMU wakeups.  */
+#define IRQ_DB5500_PRCMU_BASE IRQ_SOC_START
+
+#define IRQ_DB5500_PRCMU_RTC (IRQ_DB5500_PRCMU_BASE)
+#define IRQ_DB5500_PRCMU_RTT0 (IRQ_DB5500_PRCMU_BASE + 1)
+#define IRQ_DB5500_PRCMU_RTT1 (IRQ_DB5500_PRCMU_BASE + 2)
+#define IRQ_DB5500_PRCMU_CD_IRQ (IRQ_DB5500_PRCMU_BASE + 3)
+#define IRQ_DB5500_PRCMU_SRP_TIM (IRQ_DB5500_PRCMU_BASE + 4)
+#define IRQ_DB5500_PRCMU_APE_REQ (IRQ_DB5500_PRCMU_BASE + 5)
+#define IRQ_DB5500_PRCMU_USB (IRQ_DB5500_PRCMU_BASE + 6)
+#define IRQ_DB5500_PRCMU_ABB (IRQ_DB5500_PRCMU_BASE + 7)
+#define IRQ_DB5500_PRCMU_ARM (IRQ_DB5500_PRCMU_BASE + 8)
+#define IRQ_DB5500_PRCMU_MODEM_SW_RESET_REQ (IRQ_DB5500_PRCMU_BASE + 9)
+#define IRQ_DB5500_PRCMU_AC_WAKE_ACK (IRQ_DB5500_PRCMU_BASE + 10)
+#define IRQ_DB5500_PRCMU_GPIO0 (IRQ_DB5500_PRCMU_BASE + 11)
+#define IRQ_DB5500_PRCMU_GPIO1 (IRQ_DB5500_PRCMU_BASE + 12)
+#define IRQ_DB5500_PRCMU_GPIO2 (IRQ_DB5500_PRCMU_BASE + 13)
+#define IRQ_DB5500_PRCMU_GPIO3 (IRQ_DB5500_PRCMU_BASE + 14)
+#define IRQ_DB5500_PRCMU_GPIO4 (IRQ_DB5500_PRCMU_BASE + 15)
+#define IRQ_DB5500_PRCMU_GPIO5 (IRQ_DB5500_PRCMU_BASE + 16)
+#define IRQ_DB5500_PRCMU_GPIO6 (IRQ_DB5500_PRCMU_BASE + 17)
+#define IRQ_DB5500_PRCMU_GPIO7 (IRQ_DB5500_PRCMU_BASE + 18)
+#define IRQ_DB5500_PRCMU_AC_REL_ACK (IRQ_DB5500_PRCMU_BASE + 19)
+#define IRQ_DB5500_PRCMU_LOW_POWER_AUDIO (IRQ_DB5500_PRCMU_BASE + 20)
+#define IRQ_DB5500_PRCMU_TEMP_SENSOR (IRQ_DB5500_PRCMU_BASE + 21)
+#define IRQ_DB5500_PRCMU_END (IRQ_DB5500_PRCMU_BASE + 22)
+
+#define NUM_DB5500_PRCMU_WAKEUPS (IRQ_DB5500_PRCMU_END - IRQ_DB5500_PRCMU_BASE)
+
 /*
  * After the GPIO ones we reserve a range of IRQ:s in which virtual
  * IRQ:s representing modem IRQ:s can be allocated
diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index bb115b2..c8709b0 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -64,6 +64,47 @@
 #define PRCM_ACK_MB6 (tcdm_base + 0xF0C)
 #define PRCM_ACK_MB7 (tcdm_base + 0xF08)
 
+/* Mailbox 0 REQs */
+#define PRCM_REQ_MB0_AP_POWER_STATE    (PRCM_REQ_MB0 + 0x0)
+#define PRCM_REQ_MB0_ULP_CLOCK_STATE   (PRCM_REQ_MB0 + 0x1)
+#define PRCM_REQ_MB0_AP_PLL_STATE      (PRCM_REQ_MB0 + 0x2)
+#define PRCM_REQ_MB0_DDR_STATE         (PRCM_REQ_MB0 + 0x3)
+#define PRCM_REQ_MB0_ESRAM0_STATE      (PRCM_REQ_MB0 + 0x4)
+#define PRCM_REQ_MB0_WAKEUP_DBB        (PRCM_REQ_MB0 + 0x8)
+#define PRCM_REQ_MB0_WAKEUP_ABB        (PRCM_REQ_MB0 + 0xC)
+
+/* Mailbox 0 ACKs */
+#define PRCM_ACK_MB0_AP_PWRSTTR_STATUS (PRCM_ACK_MB0 + 0x0)
+#define PRCM_ACK_MB0_READ_POINTER      (PRCM_ACK_MB0 + 0x1)
+#define PRCM_ACK_MB0_WAKEUP_0_DBB      (PRCM_ACK_MB0 + 0x4)
+#define PRCM_ACK_MB0_WAKEUP_0_ABB      (PRCM_ACK_MB0 + 0x8)
+#define PRCM_ACK_MB0_WAKEUP_1_DBB      (PRCM_ACK_MB0 + 0x28)
+#define PRCM_ACK_MB0_WAKEUP_1_ABB      (PRCM_ACK_MB0 + 0x2C)
+#define PRCM_ACK_MB0_EVENT_ABB_NUMBERS 20
+
+/* Request mailbox 1 fields. */
+#define PRCM_REQ_MB1_ARM_OPP			(PRCM_REQ_MB1 + 0x0)
+#define PRCM_REQ_MB1_APE_OPP			(PRCM_REQ_MB1 + 0x1)
+
+/* Mailbox 1 ACKs */
+#define PRCM_ACK_MB1_CURRENT_ARM_OPP	(PRCM_ACK_MB1 + 0x0)
+#define PRCM_ACK_MB1_CURRENT_APE_OPP	(PRCM_ACK_MB1 + 0x1)
+#define PRCM_ACK_MB1_ARM_VOLT_STATUS	(PRCM_ACK_MB1 + 0x2)
+#define PRCM_ACK_MB1_APE_VOLT_STATUS	(PRCM_ACK_MB1 + 0x3)
+
+/* Mailbox 2 REQs */
+#define PRCM_REQ_MB2_EPOD_CLIENT (PRCM_REQ_MB2 + 0x0)
+#define PRCM_REQ_MB2_EPOD_STATE  (PRCM_REQ_MB2 + 0x1)
+#define PRCM_REQ_MB2_CLK_CLIENT  (PRCM_REQ_MB2 + 0x2)
+#define PRCM_REQ_MB2_CLK_STATE   (PRCM_REQ_MB2 + 0x3)
+#define PRCM_REQ_MB2_PLL_CLIENT  (PRCM_REQ_MB2 + 0x4)
+#define PRCM_REQ_MB2_PLL_STATE   (PRCM_REQ_MB2 + 0x5)
+
+/* Mailbox 2 ACKs */
+#define PRCM_ACK_MB2_EPOD_STATUS (PRCM_ACK_MB2 + 0x2)
+#define PRCM_ACK_MB2_CLK_STATUS  (PRCM_ACK_MB2 + 0x6)
+#define PRCM_ACK_MB2_PLL_STATUS  (PRCM_ACK_MB2 + 0xA)
+
 enum mb_return_code {
 	RC_SUCCESS,
 	RC_FAIL,
@@ -71,12 +112,36 @@ enum mb_return_code {
 
 /* Mailbox 0 headers. */
 enum mb0_header {
-	/* request */
-	RMB0H_PWR_STATE_TRANS = 1,
-	RMB0H_WAKE_UP_CFG,
-	RMB0H_RD_WAKE_UP_ACK,
 	/* acknowledge */
-	AMB0H_WAKE_UP = 1,
+	MB0H_WAKE_UP = 0,
+	/* request */
+	MB0H_PWR_STATE_TRANS,
+	MB0H_WAKE_UP_CFG,
+	MB0H_RD_WAKE_UP_ACK,
+};
+
+/* Mailbox 1 headers.*/
+enum mb1_header {
+	MB1H_ARM_OPP = 1,
+	MB1H_APE_OPP,
+	MB1H_ARM_APE_OPP,
+};
+
+/* Mailbox 2 headers. */
+enum mb2_header {
+	MB2H_EPOD_REQUEST = 1,
+	MB2H_CLK_REQUEST,
+	MB2H_PLL_REQUEST,
+};
+
+/* Mailbox 3 headers. */
+enum mb3_header {
+	MB3H_REFCLK_REQUEST = 1,
+};
+
+enum sysclk_state {
+	SYSCLK_OFF,
+	SYSCLK_ON,
 };
 
 /* Mailbox 5 headers. */
@@ -85,6 +150,46 @@ enum mb5_header {
 	MB5H_I2C_READ,
 };
 
+enum db5500_arm_opp {
+	DB5500_ARM_100_OPP = 1,
+	DB5500_ARM_50_OPP,
+	DB5500_ARM_EXT_OPP,
+};
+
+enum epod_state {
+	EPOD_OFF,
+	EPOD_ON,
+};
+enum epod_onoffret_state {
+	EPOD_OOR_OFF,
+	EPOD_OOR_RET,
+	EPOD_OOR_ON,
+};
+enum db5500_prcmu_pll {
+	DB5500_PLL_SOC0,
+	DB5500_PLL_SOC1,
+	DB5500_PLL_DDR,
+	DB5500_NUM_PLL_ID,
+};
+
+enum on_off_ret {
+	OFF_ST,
+	RET_ST,
+	ON_ST,
+};
+
+enum db5500_ap_pwr_state {
+	DB5500_AP_SLEEP = 2,
+	DB5500_AP_DEEP_SLEEP,
+	DB5500_AP_IDLE,
+};
+
+/* Request mailbox 3 fields */
+#define PRCM_REQ_MB3_REFCLK_MGT		(PRCM_REQ_MB3 + 0x0)
+
+/* Ack. mailbox 3 fields */
+#define PRCM_ACK_MB3_REFCLK_REQ		(PRCM_ACK_MB3 + 0x0)
+
 /* Request mailbox 5 fields. */
 #define PRCM_REQ_MB5_I2C_SLAVE (PRCM_REQ_MB5 + 0)
 #define PRCM_REQ_MB5_I2C_REG (PRCM_REQ_MB5 + 1)
@@ -125,13 +230,157 @@ enum mb5_header {
 #define PRCMU_PLLDSI_LOCKP_LOCKED		0x3
 
 /*
+ * Wakeups/IRQs
+ */
+
+#define WAKEUP_BIT_RTC BIT(0)
+#define WAKEUP_BIT_RTT0 BIT(1)
+#define WAKEUP_BIT_RTT1 BIT(2)
+#define WAKEUP_BIT_CD_IRQ BIT(3)
+#define WAKEUP_BIT_SRP_TIM BIT(4)
+#define WAKEUP_BIT_APE_REQ BIT(5)
+#define WAKEUP_BIT_USB BIT(6)
+#define WAKEUP_BIT_ABB BIT(7)
+#define WAKEUP_BIT_LOW_POWER_AUDIO BIT(8)
+#define WAKEUP_BIT_TEMP_SENSOR BIT(9)
+#define WAKEUP_BIT_ARM BIT(10)
+#define WAKEUP_BIT_AC_WAKE_ACK BIT(11)
+#define WAKEUP_BIT_MODEM_SW_RESET_REQ BIT(20)
+#define WAKEUP_BIT_GPIO0 BIT(23)
+#define WAKEUP_BIT_GPIO1 BIT(24)
+#define WAKEUP_BIT_GPIO2 BIT(25)
+#define WAKEUP_BIT_GPIO3 BIT(26)
+#define WAKEUP_BIT_GPIO4 BIT(27)
+#define WAKEUP_BIT_GPIO5 BIT(28)
+#define WAKEUP_BIT_GPIO6 BIT(29)
+#define WAKEUP_BIT_GPIO7 BIT(30)
+#define WAKEUP_BIT_AC_REL_ACK BIT(30)
+
+/*
+ * This vector maps irq numbers to the bits in the bit field used in
+ * communication with the PRCMU firmware.
+ *
+ * The reason for having this is to keep the irq numbers contiguous even though
+ * the bits in the bit field are not. (The bits also have a tendency to move
+ * around, to further complicate matters.)
+ */
+#define IRQ_INDEX(_name) ((IRQ_DB5500_PRCMU_##_name) - IRQ_DB5500_PRCMU_BASE)
+#define IRQ_ENTRY(_name)[IRQ_INDEX(_name)] = (WAKEUP_BIT_##_name)
+static u32 prcmu_irq_bit[NUM_DB5500_PRCMU_WAKEUPS] = {
+	IRQ_ENTRY(RTC),
+	IRQ_ENTRY(RTT0),
+	IRQ_ENTRY(RTT1),
+	IRQ_ENTRY(CD_IRQ),
+	IRQ_ENTRY(SRP_TIM),
+	IRQ_ENTRY(APE_REQ),
+	IRQ_ENTRY(USB),
+	IRQ_ENTRY(ABB),
+	IRQ_ENTRY(LOW_POWER_AUDIO),
+	IRQ_ENTRY(TEMP_SENSOR),
+	IRQ_ENTRY(ARM),
+	IRQ_ENTRY(AC_WAKE_ACK),
+	IRQ_ENTRY(MODEM_SW_RESET_REQ),
+	IRQ_ENTRY(GPIO0),
+	IRQ_ENTRY(GPIO1),
+	IRQ_ENTRY(GPIO2),
+	IRQ_ENTRY(GPIO3),
+	IRQ_ENTRY(GPIO4),
+	IRQ_ENTRY(GPIO5),
+	IRQ_ENTRY(GPIO6),
+	IRQ_ENTRY(GPIO7),
+	IRQ_ENTRY(AC_REL_ACK),
+};
+
+#define VALID_WAKEUPS (BIT(NUM_PRCMU_WAKEUP_INDICES) - 1)
+#define WAKEUP_ENTRY(_name)[PRCMU_WAKEUP_INDEX_##_name] = (WAKEUP_BIT_##_name)
+static u32 prcmu_wakeup_bit[NUM_PRCMU_WAKEUP_INDICES] = {
+	WAKEUP_ENTRY(RTC),
+	WAKEUP_ENTRY(RTT0),
+	WAKEUP_ENTRY(RTT1),
+	WAKEUP_ENTRY(CD_IRQ),
+	WAKEUP_ENTRY(USB),
+	WAKEUP_ENTRY(ABB),
+	WAKEUP_ENTRY(ARM)
+};
+
+/*
  * mb0_transfer - state needed for mailbox 0 communication.
- * @lock:		The transaction lock.
+ * @lock                The transaction lock.
+ * @dbb_irqs_lock       lock used for (un)masking DBB wakeup interrupts
+ * @mask_work:          Work structure used for (un)masking wakeup interrupts.
+ * @req:                Request data that need to persist between requests.
  */
 static struct {
 	spinlock_t lock;
+	spinlock_t dbb_irqs_lock;
+	struct work_struct mask_work;
+	struct {
+		u32 dbb_irqs;
+		u32 dbb_wakeups;
+		u32 abb_events;
+	} req;
 } mb0_transfer;
 
+
+/*
+ * mb1_transfer - state needed for mailbox 1 communication.
+ * @lock:	The transaction lock.
+ * @work:	The transaction completion structure.
+ * @req_arm_opp Requested arm opp
+ * @req_ape_opp Requested ape opp
+ * @ack:	Reply ("acknowledge") data.
+ */
+static struct {
+	struct mutex lock;
+	struct completion work;
+	u8 req_arm_opp;
+	u8 req_ape_opp;
+	struct {
+		u8 header;
+		u8 arm_opp;
+		u8 ape_opp;
+		u8 arm_voltage_st;
+		u8 ape_voltage_st;
+	} ack;
+} mb1_transfer;
+
+/*
+ * mb2_transfer - state needed for mailbox 2 communication.
+ * @lock:      The transaction lock.
+ * @work:      The transaction completion structure.
+ * @req:       Request data that need to persist between requests.
+ * @ack:       Reply ("acknowledge") data.
+ */
+static struct {
+	struct mutex lock;
+	struct completion work;
+	struct {
+		u8 epod_st[DB5500_NUM_EPOD_ID];
+		u8 pll_st[DB5500_NUM_PLL_ID];
+	} req;
+	struct {
+		u8 header;
+		u8 status;
+	} ack;
+} mb2_transfer;
+
+/*
+ * mb3_transfer - state needed for mailbox 3 communication.
+ * @sysclk_lock:	A lock used to handle concurrent sysclk requests.
+ * @sysclk_work:	Work structure used for sysclk requests.
+ * @req_st:		Requested clock state.
+ * @ack:		Acknowledgement data
+ */
+static struct {
+	struct mutex sysclk_lock;
+	struct completion sysclk_work;
+	enum sysclk_state req_st;
+	struct {
+		u8 header;
+		u8 status;
+	} ack;
+} mb3_transfer;
+
 /*
  * mb5_transfer - state needed for mailbox 5 communication.
  * @lock:	The transaction lock.
@@ -291,7 +540,7 @@ static void ack_dbb_wakeup(void)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
 		cpu_relax();
 
-	writeb(RMB0H_RD_WAKE_UP_ACK, PRCM_REQ_MB0_HEADER);
+	writeb(MB0H_RD_WAKE_UP_ACK, PRCM_REQ_MB0_HEADER);
 	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
 
 	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
@@ -306,11 +555,25 @@ static inline void print_unknown_header_warning(u8 n, u8 header)
 static bool read_mailbox_0(void)
 {
 	bool r;
+	u32 ev;
+	unsigned int n;
+
 	u8 header;
 
 	header = readb(PRCM_ACK_MB0_HEADER);
 	switch (header) {
-	case AMB0H_WAKE_UP:
+	case MB0H_WAKE_UP:
+		if (readb(PRCM_ACK_MB0_READ_POINTER) & 1)
+			ev = readl(PRCM_ACK_MB0_WAKEUP_1_DBB);
+		else
+			ev = readl(PRCM_ACK_MB0_WAKEUP_0_DBB);
+
+		ev &= mb0_transfer.req.dbb_irqs;
+
+		for (n = 0; n < NUM_DB5500_PRCMU_WAKEUPS; n++) {
+			if (ev & prcmu_irq_bit[n])
+				generic_handle_irq(IRQ_DB5500_PRCMU_BASE + n);
+		}
 		r = true;
 		break;
 	default:
@@ -324,19 +587,81 @@ static bool read_mailbox_0(void)
 
 static bool read_mailbox_1(void)
 {
+	u8 header;
+	bool do_complete = true;
+
+	header = mb1_transfer.ack.header = readb(PRCM_ACK_MB1_HEADER);
+
+	switch (header) {
+	case MB1H_ARM_OPP:
+		mb1_transfer.ack.arm_opp = readb(PRCM_ACK_MB1_CURRENT_ARM_OPP);
+		mb1_transfer.ack.arm_voltage_st =
+			readb(PRCM_ACK_MB1_ARM_VOLT_STATUS);
+		break;
+	case MB1H_ARM_APE_OPP:
+		mb1_transfer.ack.ape_opp = readb(PRCM_ACK_MB1_CURRENT_APE_OPP);
+		mb1_transfer.ack.ape_voltage_st =
+			readb(PRCM_ACK_MB1_APE_VOLT_STATUS);
+		break;
+	default:
+		print_unknown_header_warning(1, header);
+		do_complete = false;
+		break;
+	}
+
 	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLR);
+
+	if (do_complete)
+		complete(&mb1_transfer.work);
+
 	return false;
 }
 
 static bool read_mailbox_2(void)
 {
+	u8 header;
+
+	header = readb(PRCM_ACK_MB2_HEADER);
+	mb2_transfer.ack.header = header;
+	switch (header) {
+	case MB2H_EPOD_REQUEST:
+		mb2_transfer.ack.status = readb(PRCM_ACK_MB2_EPOD_STATUS);
+		break;
+	case MB2H_CLK_REQUEST:
+		mb2_transfer.ack.status = readb(PRCM_ACK_MB2_CLK_STATUS);
+		break;
+	case MB2H_PLL_REQUEST:
+		mb2_transfer.ack.status = readb(PRCM_ACK_MB2_PLL_STATUS);
+		break;
+	default:
+		writel(MBOX_BIT(2), PRCM_ARM_IT1_CLR);
+		pr_err("prcmu: Wrong ACK received for MB2 request \n");
+		return false;
+		break;
+	}
 	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLR);
+	complete(&mb2_transfer.work);
 	return false;
 }
 
 static bool read_mailbox_3(void)
 {
-	writel(MBOX_BIT(3), PRCM_ARM_IT1_CLR);
+	u8 header;
+
+	header = readb(PRCM_ACK_MB3_HEADER);
+	mb3_transfer.ack.header = header;
+	switch (header) {
+	case MB3H_REFCLK_REQUEST:
+		mb3_transfer.ack.status = readb(PRCM_ACK_MB3_REFCLK_REQ);
+		writel(MBOX_BIT(3), PRCM_ARM_IT1_CLR);
+		complete(&mb3_transfer.sysclk_work);
+		break;
+	default:
+		writel(MBOX_BIT(3), PRCM_ARM_IT1_CLR);
+		pr_err("prcmu: wrong MB3 header\n");
+		break;
+	}
+
 	return false;
 }
 
@@ -421,6 +746,13 @@ void __init db5500_prcmu_early_init(void)
 {
 	tcdm_base = __io_address(U5500_PRCMU_TCDM_BASE);
 	spin_lock_init(&mb0_transfer.lock);
+	spin_lock_init(&mb0_transfer.dbb_irqs_lock);
+	mutex_init(&mb1_transfer.lock);
+	init_completion(&mb1_transfer.work);
+	mutex_init(&mb2_transfer.lock);
+	init_completion(&mb2_transfer.work);
+	mutex_init(&mb3_transfer.sysclk_lock);
+	init_completion(&mb3_transfer.sysclk_work);
 	mutex_init(&mb5_transfer.lock);
 	init_completion(&mb5_transfer.work);
 }
-- 
1.7.3.2

