Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657Ab2IEKA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:00:56 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:37185 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245Ab2IEKAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:00:54 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 11/17] mfd: pcrmu: create common header file for legacy mailbox
Date: Wed, 5 Sep 2012 11:59:07 +0200
Message-ID: <1346839153-6465-12-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Legacy mailbox are used by both 8500 and x540 projects.
Structure and definition should be shared to avoid misalignment.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c | 576 +++++++++++----------------------------------
 drivers/mfd/dbx500-prcmu.h | 378 +++++++++++++++++++++++++++++
 2 files changed, 518 insertions(+), 436 deletions(-)
 create mode 100644 drivers/mfd/dbx500-prcmu.h

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 36f7c1d..96487a0 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -36,6 +36,7 @@
 #include <mach/irqs.h>
 #include <mach/db8500-regs.h>
 #include <mach/id.h>
+#include "dbx500-prcmu.h"
 #include "dbx500-prcmu-regs.h"
 
 /* Offset for the firmware version within the TCPM */
@@ -69,202 +70,6 @@
 #define PRCM_ROMCODE_P2A	0xFFD
 #define PRCM_XP70_CUR_PWR_STATE 0xFFC      /* 4 BYTES */
 
-#define PRCM_SW_RST_REASON 0xFF8 /* 2 bytes */
-
-#define _PRCM_MBOX_HEADER		0xFE8 /* 16 bytes */
-#define PRCM_MBOX_HEADER_REQ_MB0	(_PRCM_MBOX_HEADER + 0x0)
-#define PRCM_MBOX_HEADER_REQ_MB1	(_PRCM_MBOX_HEADER + 0x1)
-#define PRCM_MBOX_HEADER_REQ_MB2	(_PRCM_MBOX_HEADER + 0x2)
-#define PRCM_MBOX_HEADER_REQ_MB3	(_PRCM_MBOX_HEADER + 0x3)
-#define PRCM_MBOX_HEADER_REQ_MB4	(_PRCM_MBOX_HEADER + 0x4)
-#define PRCM_MBOX_HEADER_REQ_MB5	(_PRCM_MBOX_HEADER + 0x5)
-#define PRCM_MBOX_HEADER_ACK_MB0	(_PRCM_MBOX_HEADER + 0x8)
-
-/* Req Mailboxes */
-#define PRCM_REQ_MB0 0xFDC /* 12 bytes  */
-#define PRCM_REQ_MB1 0xFD0 /* 12 bytes  */
-#define PRCM_REQ_MB2 0xFC0 /* 16 bytes  */
-#define PRCM_REQ_MB3 0xE4C /* 372 bytes  */
-#define PRCM_REQ_MB4 0xE48 /* 4 bytes  */
-#define PRCM_REQ_MB5 0xE44 /* 4 bytes  */
-
-/* Ack Mailboxes */
-#define PRCM_ACK_MB0 0xE08 /* 52 bytes  */
-#define PRCM_ACK_MB1 0xE04 /* 4 bytes */
-#define PRCM_ACK_MB2 0xE00 /* 4 bytes */
-#define PRCM_ACK_MB3 0xDFC /* 4 bytes */
-#define PRCM_ACK_MB4 0xDF8 /* 4 bytes */
-#define PRCM_ACK_MB5 0xDF4 /* 4 bytes */
-
-/* Mailbox 0 headers */
-#define MB0H_POWER_STATE_TRANS		0
-#define MB0H_CONFIG_WAKEUPS_EXE		1
-#define MB0H_READ_WAKEUP_ACK		3
-#define MB0H_CONFIG_WAKEUPS_SLEEP	4
-
-#define MB0H_WAKEUP_EXE 2
-#define MB0H_WAKEUP_SLEEP 5
-
-/* Mailbox 0 REQs */
-#define PRCM_REQ_MB0_AP_POWER_STATE	(PRCM_REQ_MB0 + 0x0)
-#define PRCM_REQ_MB0_AP_PLL_STATE	(PRCM_REQ_MB0 + 0x1)
-#define PRCM_REQ_MB0_ULP_CLOCK_STATE	(PRCM_REQ_MB0 + 0x2)
-#define PRCM_REQ_MB0_DO_NOT_WFI		(PRCM_REQ_MB0 + 0x3)
-#define PRCM_REQ_MB0_WAKEUP_8500	(PRCM_REQ_MB0 + 0x4)
-#define PRCM_REQ_MB0_WAKEUP_4500	(PRCM_REQ_MB0 + 0x8)
-
-/* Mailbox 0 ACKs */
-#define PRCM_ACK_MB0_AP_PWRSTTR_STATUS	(PRCM_ACK_MB0 + 0x0)
-#define PRCM_ACK_MB0_READ_POINTER	(PRCM_ACK_MB0 + 0x1)
-#define PRCM_ACK_MB0_WAKEUP_0_8500	(PRCM_ACK_MB0 + 0x4)
-#define PRCM_ACK_MB0_WAKEUP_0_4500	(PRCM_ACK_MB0 + 0x8)
-#define PRCM_ACK_MB0_WAKEUP_1_8500	(PRCM_ACK_MB0 + 0x1C)
-#define PRCM_ACK_MB0_WAKEUP_1_4500	(PRCM_ACK_MB0 + 0x20)
-#define PRCM_ACK_MB0_EVENT_4500_NUMBERS	20
-
-/* Mailbox 1 headers */
-#define MB1H_ARM_APE_OPP 0x0
-#define MB1H_RESET_MODEM 0x2
-#define MB1H_REQUEST_APE_OPP_100_VOLT 0x3
-#define MB1H_RELEASE_APE_OPP_100_VOLT 0x4
-#define MB1H_RELEASE_USB_WAKEUP 0x5
-#define MB1H_PLL_ON_OFF 0x6
-
-/* Mailbox 1 Requests */
-#define PRCM_REQ_MB1_ARM_OPP			(PRCM_REQ_MB1 + 0x0)
-#define PRCM_REQ_MB1_APE_OPP			(PRCM_REQ_MB1 + 0x1)
-#define PRCM_REQ_MB1_PLL_ON_OFF			(PRCM_REQ_MB1 + 0x4)
-#define PLL_SOC0_OFF	0x1
-#define PLL_SOC0_ON	0x2
-#define PLL_SOC1_OFF	0x4
-#define PLL_SOC1_ON	0x8
-
-/* Mailbox 1 ACKs */
-#define PRCM_ACK_MB1_CURRENT_ARM_OPP	(PRCM_ACK_MB1 + 0x0)
-#define PRCM_ACK_MB1_CURRENT_APE_OPP	(PRCM_ACK_MB1 + 0x1)
-#define PRCM_ACK_MB1_APE_VOLTAGE_STATUS	(PRCM_ACK_MB1 + 0x2)
-#define PRCM_ACK_MB1_DVFS_STATUS	(PRCM_ACK_MB1 + 0x3)
-
-/* Mailbox 2 headers */
-#define MB2H_DPS	0x0
-#define MB2H_AUTO_PWR	0x1
-
-/* Mailbox 2 REQs */
-#define PRCM_REQ_MB2_SVA_MMDSP		(PRCM_REQ_MB2 + 0x0)
-#define PRCM_REQ_MB2_SVA_PIPE		(PRCM_REQ_MB2 + 0x1)
-#define PRCM_REQ_MB2_SIA_MMDSP		(PRCM_REQ_MB2 + 0x2)
-#define PRCM_REQ_MB2_SIA_PIPE		(PRCM_REQ_MB2 + 0x3)
-#define PRCM_REQ_MB2_SGA		(PRCM_REQ_MB2 + 0x4)
-#define PRCM_REQ_MB2_B2R2_MCDE		(PRCM_REQ_MB2 + 0x5)
-#define PRCM_REQ_MB2_ESRAM12		(PRCM_REQ_MB2 + 0x6)
-#define PRCM_REQ_MB2_ESRAM34		(PRCM_REQ_MB2 + 0x7)
-#define PRCM_REQ_MB2_AUTO_PM_SLEEP	(PRCM_REQ_MB2 + 0x8)
-#define PRCM_REQ_MB2_AUTO_PM_IDLE	(PRCM_REQ_MB2 + 0xC)
-
-/* Mailbox 2 ACKs */
-#define PRCM_ACK_MB2_DPS_STATUS (PRCM_ACK_MB2 + 0x0)
-#define HWACC_PWR_ST_OK 0xFE
-
-/* Mailbox 3 headers */
-#define MB3H_ANC	0x0
-#define MB3H_SIDETONE	0x1
-#define MB3H_SYSCLK	0xE
-
-/* Mailbox 3 Requests */
-#define PRCM_REQ_MB3_ANC_FIR_COEFF	(PRCM_REQ_MB3 + 0x0)
-#define PRCM_REQ_MB3_ANC_IIR_COEFF	(PRCM_REQ_MB3 + 0x20)
-#define PRCM_REQ_MB3_ANC_SHIFTER	(PRCM_REQ_MB3 + 0x60)
-#define PRCM_REQ_MB3_ANC_WARP		(PRCM_REQ_MB3 + 0x64)
-#define PRCM_REQ_MB3_SIDETONE_FIR_GAIN	(PRCM_REQ_MB3 + 0x68)
-#define PRCM_REQ_MB3_SIDETONE_FIR_COEFF	(PRCM_REQ_MB3 + 0x6C)
-#define PRCM_REQ_MB3_SYSCLK_MGT		(PRCM_REQ_MB3 + 0x16C)
-
-/* Mailbox 4 headers */
-#define MB4H_DDR_INIT	0x0
-#define MB4H_MEM_ST	0x1
-#define MB4H_HOTDOG	0x12
-#define MB4H_HOTMON	0x13
-#define MB4H_HOT_PERIOD	0x14
-#define MB4H_A9WDOG_CONF 0x16
-#define MB4H_A9WDOG_EN   0x17
-#define MB4H_A9WDOG_DIS  0x18
-#define MB4H_A9WDOG_LOAD 0x19
-#define MB4H_A9WDOG_KICK 0x20
-
-/* Mailbox 4 Requests */
-#define PRCM_REQ_MB4_DDR_ST_AP_SLEEP_IDLE	(PRCM_REQ_MB4 + 0x0)
-#define PRCM_REQ_MB4_DDR_ST_AP_DEEP_IDLE	(PRCM_REQ_MB4 + 0x1)
-#define PRCM_REQ_MB4_ESRAM0_ST			(PRCM_REQ_MB4 + 0x3)
-#define PRCM_REQ_MB4_HOTDOG_THRESHOLD		(PRCM_REQ_MB4 + 0x0)
-#define PRCM_REQ_MB4_HOTMON_LOW			(PRCM_REQ_MB4 + 0x0)
-#define PRCM_REQ_MB4_HOTMON_HIGH		(PRCM_REQ_MB4 + 0x1)
-#define PRCM_REQ_MB4_HOTMON_CONFIG		(PRCM_REQ_MB4 + 0x2)
-#define PRCM_REQ_MB4_HOT_PERIOD			(PRCM_REQ_MB4 + 0x0)
-#define HOTMON_CONFIG_LOW			BIT(0)
-#define HOTMON_CONFIG_HIGH			BIT(1)
-#define PRCM_REQ_MB4_A9WDOG_0			(PRCM_REQ_MB4 + 0x0)
-#define PRCM_REQ_MB4_A9WDOG_1			(PRCM_REQ_MB4 + 0x1)
-#define PRCM_REQ_MB4_A9WDOG_2			(PRCM_REQ_MB4 + 0x2)
-#define PRCM_REQ_MB4_A9WDOG_3			(PRCM_REQ_MB4 + 0x3)
-#define A9WDOG_AUTO_OFF_EN			BIT(7)
-#define A9WDOG_AUTO_OFF_DIS			0
-#define A9WDOG_ID_MASK				0xf
-
-/* Mailbox 5 Requests */
-#define PRCM_REQ_MB5_I2C_SLAVE_OP	(PRCM_REQ_MB5 + 0x0)
-#define PRCM_REQ_MB5_I2C_HW_BITS	(PRCM_REQ_MB5 + 0x1)
-#define PRCM_REQ_MB5_I2C_REG		(PRCM_REQ_MB5 + 0x2)
-#define PRCM_REQ_MB5_I2C_VAL		(PRCM_REQ_MB5 + 0x3)
-#define PRCMU_I2C_WRITE(slave) \
-	(((slave) << 1) | (cpu_is_u8500v2() ? BIT(6) : 0))
-#define PRCMU_I2C_READ(slave) \
-	(((slave) << 1) | BIT(0) | (cpu_is_u8500v2() ? BIT(6) : 0))
-#define PRCMU_I2C_STOP_EN		BIT(3)
-
-/* Mailbox 5 ACKs */
-#define PRCM_ACK_MB5_I2C_STATUS	(PRCM_ACK_MB5 + 0x1)
-#define PRCM_ACK_MB5_I2C_VAL	(PRCM_ACK_MB5 + 0x3)
-#define I2C_WR_OK 0x1
-#define I2C_RD_OK 0x2
-
-#define NUM_MB 8
-#define MBOX_BIT BIT
-#define ALL_MBOX_BITS (MBOX_BIT(NUM_MB) - 1)
-
-/*
- * Wakeups/IRQs
- */
-
-#define WAKEUP_BIT_RTC BIT(0)
-#define WAKEUP_BIT_RTT0 BIT(1)
-#define WAKEUP_BIT_RTT1 BIT(2)
-#define WAKEUP_BIT_HSI0 BIT(3)
-#define WAKEUP_BIT_HSI1 BIT(4)
-#define WAKEUP_BIT_CA_WAKE BIT(5)
-#define WAKEUP_BIT_USB BIT(6)
-#define WAKEUP_BIT_ABB BIT(7)
-#define WAKEUP_BIT_ABB_FIFO BIT(8)
-#define WAKEUP_BIT_SYSCLK_OK BIT(9)
-#define WAKEUP_BIT_CA_SLEEP BIT(10)
-#define WAKEUP_BIT_AC_WAKE_ACK BIT(11)
-#define WAKEUP_BIT_SIDE_TONE_OK BIT(12)
-#define WAKEUP_BIT_ANC_OK BIT(13)
-#define WAKEUP_BIT_SW_ERROR BIT(14)
-#define WAKEUP_BIT_AC_SLEEP_ACK BIT(15)
-#define WAKEUP_BIT_ARM BIT(17)
-#define WAKEUP_BIT_HOTMON_LOW BIT(18)
-#define WAKEUP_BIT_HOTMON_HIGH BIT(19)
-#define WAKEUP_BIT_MODEM_SW_RESET_REQ BIT(20)
-#define WAKEUP_BIT_GPIO0 BIT(23)
-#define WAKEUP_BIT_GPIO1 BIT(24)
-#define WAKEUP_BIT_GPIO2 BIT(25)
-#define WAKEUP_BIT_GPIO3 BIT(26)
-#define WAKEUP_BIT_GPIO4 BIT(27)
-#define WAKEUP_BIT_GPIO5 BIT(28)
-#define WAKEUP_BIT_GPIO6 BIT(29)
-#define WAKEUP_BIT_GPIO7 BIT(30)
-#define WAKEUP_BIT_GPIO8 BIT(31)
-
 static struct {
 	bool valid;
 	struct prcmu_fw_version version;
@@ -322,102 +127,6 @@ static u32 prcmu_wakeup_bit[NUM_PRCMU_WAKEUP_INDICES] = {
 	WAKEUP_ENTRY(ARM)
 };
 
-/*
- * mb0_transfer - state needed for mailbox 0 communication.
- * @lock:		The transaction lock.
- * @dbb_events_lock:	A lock used to handle concurrent access to (parts of)
- *			the request data.
- * @mask_work:		Work structure used for (un)masking wakeup interrupts.
- * @req:		Request data that need to persist between requests.
- */
-static struct {
-	spinlock_t lock;
-	spinlock_t dbb_irqs_lock;
-	struct work_struct mask_work;
-	struct mutex ac_wake_lock;
-	struct completion ac_wake_work;
-	struct {
-		u32 dbb_irqs;
-		u32 dbb_wakeups;
-		u32 abb_events;
-	} req;
-} mb0_transfer;
-
-/*
- * mb1_transfer - state needed for mailbox 1 communication.
- * @lock:	The transaction lock.
- * @work:	The transaction completion structure.
- * @ape_opp:	The current APE OPP.
- * @ack:	Reply ("acknowledge") data.
- */
-static struct {
-	struct mutex lock;
-	struct completion work;
-	u8 ape_opp;
-	struct {
-		u8 header;
-		u8 arm_opp;
-		u8 ape_opp;
-		u8 ape_voltage_status;
-	} ack;
-} mb1_transfer;
-
-/*
- * mb2_transfer - state needed for mailbox 2 communication.
- * @lock:            The transaction lock.
- * @work:            The transaction completion structure.
- * @auto_pm_lock:    The autonomous power management configuration lock.
- * @auto_pm_enabled: A flag indicating whether autonomous PM is enabled.
- * @req:             Request data that need to persist between requests.
- * @ack:             Reply ("acknowledge") data.
- */
-static struct {
-	struct mutex lock;
-	struct completion work;
-	spinlock_t auto_pm_lock;
-	bool auto_pm_enabled;
-	struct {
-		u8 status;
-	} ack;
-} mb2_transfer;
-
-/*
- * mb3_transfer - state needed for mailbox 3 communication.
- * @lock:		The request lock.
- * @sysclk_lock:	A lock used to handle concurrent sysclk requests.
- * @sysclk_work:	Work structure used for sysclk requests.
- */
-static struct {
-	spinlock_t lock;
-	struct mutex sysclk_lock;
-	struct completion sysclk_work;
-} mb3_transfer;
-
-/*
- * mb4_transfer - state needed for mailbox 4 communication.
- * @lock:	The transaction lock.
- * @work:	The transaction completion structure.
- */
-static struct {
-	struct mutex lock;
-	struct completion work;
-} mb4_transfer;
-
-/*
- * mb5_transfer - state needed for mailbox 5 communication.
- * @lock:	The transaction lock.
- * @work:	The transaction completion structure.
- * @ack:	Reply ("acknowledge") data.
- */
-static struct {
-	struct mutex lock;
-	struct completion work;
-	struct {
-		u8 status;
-		u8 value;
-	} ack;
-} mb5_transfer;
-
 static atomic_t ac_wake_req_state = ATOMIC_INIT(0);
 
 /* Spinlocks */
@@ -428,18 +137,13 @@ static DEFINE_SPINLOCK(clkout_lock);
 static __iomem void *tcdm_legacy_base;
 static __iomem void *tcdm_base;
 
-struct clk_mgt {
-	void __iomem *reg;
-	u32 pllsw;
-	int branch;
-	bool clk38div;
-};
-
-enum {
-	PLL_RAW,
-	PLL_FIX,
-	PLL_DIV
-};
+/* mailbox definition */
+static struct mb0_transfer mb0;
+static struct mb1_transfer mb1;
+static struct mb2_transfer mb2;
+static struct mb3_transfer mb3;
+static struct mb4_transfer mb4;
+static struct mb5_transfer mb5;
 
 static DEFINE_SPINLOCK(clk_mgt_lock);
 
@@ -774,7 +478,7 @@ int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 
 	BUG_ON((state < PRCMU_AP_SLEEP) || (PRCMU_AP_DEEP_IDLE < state));
 
-	spin_lock_irqsave(&mb0_transfer.lock, flags);
+	spin_lock_irqsave(&mb0.lock, flags);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
 		cpu_relax();
@@ -789,7 +493,7 @@ int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 	writeb(0, (tcdm_legacy_base + PRCM_REQ_MB0_DO_NOT_WFI));
 	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
 
-	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+	spin_unlock_irqrestore(&mb0.lock, flags);
 
 	return 0;
 }
@@ -912,7 +616,7 @@ int db8500_prcmu_copy_gic_settings(void)
 	return 0;
 }
 
-/* This function should only be called while mb0_transfer.lock is held. */
+/* This function should only be called while mb0.lock is held. */
 static void config_wakeups(void)
 {
 	const u8 header[2] = {
@@ -925,10 +629,10 @@ static void config_wakeups(void)
 	u32 abb_events;
 	unsigned int i;
 
-	dbb_events = mb0_transfer.req.dbb_irqs | mb0_transfer.req.dbb_wakeups;
+	dbb_events = mb0.req.dbb_irqs | mb0.req.dbb_wakeups;
 	dbb_events |= (WAKEUP_BIT_AC_WAKE_ACK | WAKEUP_BIT_AC_SLEEP_ACK);
 
-	abb_events = mb0_transfer.req.abb_events;
+	abb_events = mb0.req.abb_events;
 
 	if ((dbb_events == last_dbb_events) && (abb_events == last_abb_events))
 		return;
@@ -958,24 +662,24 @@ static void db8500_prcmu_enable_wakeups(u32 wakeups)
 			bits |= prcmu_wakeup_bit[i];
 	}
 
-	spin_lock_irqsave(&mb0_transfer.lock, flags);
+	spin_lock_irqsave(&mb0.lock, flags);
 
-	mb0_transfer.req.dbb_wakeups = bits;
+	mb0.req.dbb_wakeups = bits;
 	config_wakeups();
 
-	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+	spin_unlock_irqrestore(&mb0.lock, flags);
 }
 
 static void db8500_prcmu_config_abb_event_readout(u32 abb_events)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&mb0_transfer.lock, flags);
+	spin_lock_irqsave(&mb0.lock, flags);
 
-	mb0_transfer.req.abb_events = abb_events;
+	mb0.req.abb_events = abb_events;
 	config_wakeups();
 
-	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+	spin_unlock_irqrestore(&mb0.lock, flags);
 }
 
 static void db8500_prcmu_get_abb_event_buffer(void __iomem **buf)
@@ -1002,7 +706,7 @@ static int db8500_prcmu_set_arm_opp(u8 opp)
 
 	r = 0;
 
-	mutex_lock(&mb1_transfer.lock);
+	mutex_lock(&mb1.lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
@@ -1012,13 +716,13 @@ static int db8500_prcmu_set_arm_opp(u8 opp)
 	writeb(APE_NO_CHANGE, (tcdm_legacy_base + PRCM_REQ_MB1_APE_OPP));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1_transfer.work);
+	wait_for_completion(&mb1.work);
 
-	if ((mb1_transfer.ack.header != MB1H_ARM_APE_OPP) ||
-		(mb1_transfer.ack.arm_opp != opp))
+	if ((mb1.ack.header != MB1H_ARM_APE_OPP) ||
+		(mb1.ack.arm_opp != opp))
 		r = -EIO;
 
-	mutex_unlock(&mb1_transfer.lock);
+	mutex_unlock(&mb1.lock);
 
 	return r;
 }
@@ -1118,15 +822,15 @@ static int db8500_prcmu_set_ape_opp(u8 opp)
 {
 	int r = 0;
 
-	if (opp == mb1_transfer.ape_opp)
+	if (opp == mb1.ape_opp)
 		return 0;
 
-	mutex_lock(&mb1_transfer.lock);
+	mutex_lock(&mb1.lock);
 
-	if (mb1_transfer.ape_opp == APE_50_PARTLY_25_OPP)
+	if (mb1.ape_opp == APE_50_PARTLY_25_OPP)
 		request_even_slower_clocks(false);
 
-	if ((opp != APE_100_OPP) && (mb1_transfer.ape_opp != APE_100_OPP))
+	if ((opp != APE_100_OPP) && (mb1.ape_opp != APE_100_OPP))
 		goto skip_message;
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
@@ -1138,20 +842,20 @@ static int db8500_prcmu_set_ape_opp(u8 opp)
 		(tcdm_legacy_base + PRCM_REQ_MB1_APE_OPP));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1_transfer.work);
+	wait_for_completion(&mb1.work);
 
-	if ((mb1_transfer.ack.header != MB1H_ARM_APE_OPP) ||
-		(mb1_transfer.ack.ape_opp != opp))
+	if ((mb1.ack.header != MB1H_ARM_APE_OPP) ||
+		(mb1.ack.ape_opp != opp))
 		r = -EIO;
 
 skip_message:
 	if ((!r && (opp == APE_50_PARTLY_25_OPP)) ||
-		(r && (mb1_transfer.ape_opp == APE_50_PARTLY_25_OPP)))
+		(r && (mb1.ape_opp == APE_50_PARTLY_25_OPP)))
 		request_even_slower_clocks(true);
 	if (!r)
-		mb1_transfer.ape_opp = opp;
+		mb1.ape_opp = opp;
 
-	mutex_unlock(&mb1_transfer.lock);
+	mutex_unlock(&mb1.lock);
 
 	return r;
 }
@@ -1178,7 +882,7 @@ static int db8500_prcmu_request_ape_opp_100_voltage(bool enable)
 	u8 header;
 	static unsigned int requests;
 
-	mutex_lock(&mb1_transfer.lock);
+	mutex_lock(&mb1.lock);
 
 	if (enable) {
 		if (0 != requests++)
@@ -1200,14 +904,14 @@ static int db8500_prcmu_request_ape_opp_100_voltage(bool enable)
 	writeb(header, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1_transfer.work);
+	wait_for_completion(&mb1.work);
 
-	if ((mb1_transfer.ack.header != header) ||
-		((mb1_transfer.ack.ape_voltage_status & BIT(0)) != 0))
+	if ((mb1.ack.header != header) ||
+		((mb1.ack.ape_voltage_status & BIT(0)) != 0))
 		r = -EIO;
 
 unlock_and_return:
-	mutex_unlock(&mb1_transfer.lock);
+	mutex_unlock(&mb1.lock);
 
 	return r;
 }
@@ -1221,7 +925,7 @@ int prcmu_release_usb_wakeup_state(void)
 {
 	int r = 0;
 
-	mutex_lock(&mb1_transfer.lock);
+	mutex_lock(&mb1.lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
@@ -1230,13 +934,13 @@ int prcmu_release_usb_wakeup_state(void)
 		(tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1_transfer.work);
+	wait_for_completion(&mb1.work);
 
-	if ((mb1_transfer.ack.header != MB1H_RELEASE_USB_WAKEUP) ||
-		((mb1_transfer.ack.ape_voltage_status & BIT(0)) != 0))
+	if ((mb1.ack.header != MB1H_RELEASE_USB_WAKEUP) ||
+		((mb1.ack.ape_voltage_status & BIT(0)) != 0))
 		r = -EIO;
 
-	mutex_unlock(&mb1_transfer.lock);
+	mutex_unlock(&mb1.lock);
 
 	return r;
 }
@@ -1252,7 +956,7 @@ static int request_pll(u8 clock, bool enable)
 	else
 		return -EINVAL;
 
-	mutex_lock(&mb1_transfer.lock);
+	mutex_lock(&mb1.lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
@@ -1261,12 +965,12 @@ static int request_pll(u8 clock, bool enable)
 	writeb(clock, (tcdm_legacy_base + PRCM_REQ_MB1_PLL_ON_OFF));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1_transfer.work);
+	wait_for_completion(&mb1.work);
 
-	if (mb1_transfer.ack.header != MB1H_PLL_ON_OFF)
+	if (mb1.ack.header != MB1H_PLL_ON_OFF)
 		r = -EIO;
 
-	mutex_unlock(&mb1_transfer.lock);
+	mutex_unlock(&mb1.lock);
 
 	return r;
 }
@@ -1303,7 +1007,7 @@ static int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 	BUG_ON(epod_state == EPOD_STATE_RAMRET && !ram_retention);
 
 	/* get lock */
-	mutex_lock(&mb2_transfer.lock);
+	mutex_lock(&mb2.lock);
 
 	/* wait for mailbox */
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(2))
@@ -1324,7 +1028,7 @@ static int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 	 * and we cannot recover if there is an error.
 	 * This is expected to change when the firmware is updated.
 	 */
-	if (!wait_for_completion_timeout(&mb2_transfer.work,
+	if (!wait_for_completion_timeout(&mb2.work,
 			msecs_to_jiffies(20000))) {
 		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
 			__func__);
@@ -1332,11 +1036,11 @@ static int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 		goto unlock_and_return;
 	}
 
-	if (mb2_transfer.ack.status != HWACC_PWR_ST_OK)
+	if (mb2.ack.status != HWACC_PWR_ST_OK)
 		r = -EIO;
 
 unlock_and_return:
-	mutex_unlock(&mb2_transfer.lock);
+	mutex_unlock(&mb2.lock);
 	return r;
 }
 
@@ -1368,7 +1072,7 @@ static void db8500_prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 	idle_cfg = ((idle_cfg << 4) | (idle->sva_policy & 0xF));
 	idle_cfg = ((idle_cfg << 4) | (idle->sia_policy & 0xF));
 
-	spin_lock_irqsave(&mb2_transfer.auto_pm_lock, flags);
+	spin_lock_irqsave(&mb2.auto_pm_lock, flags);
 
 	/*
 	 * The autonomous power management configuration is done through
@@ -1378,18 +1082,18 @@ static void db8500_prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 	writel(sleep_cfg, (tcdm_legacy_base + PRCM_REQ_MB2_AUTO_PM_SLEEP));
 	writel(idle_cfg, (tcdm_legacy_base + PRCM_REQ_MB2_AUTO_PM_IDLE));
 
-	mb2_transfer.auto_pm_enabled =
+	mb2.auto_pm_enabled =
 		((sleep->sva_auto_pm_enable == PRCMU_AUTO_PM_ON) ||
 		 (sleep->sia_auto_pm_enable == PRCMU_AUTO_PM_ON) ||
 		 (idle->sva_auto_pm_enable == PRCMU_AUTO_PM_ON) ||
 		 (idle->sia_auto_pm_enable == PRCMU_AUTO_PM_ON));
 
-	spin_unlock_irqrestore(&mb2_transfer.auto_pm_lock, flags);
+	spin_unlock_irqrestore(&mb2.auto_pm_lock, flags);
 }
 
 bool prcmu_is_auto_pm_enabled(void)
 {
-	return mb2_transfer.auto_pm_enabled;
+	return mb2.auto_pm_enabled;
 }
 
 static int request_sysclk(bool enable)
@@ -1399,9 +1103,9 @@ static int request_sysclk(bool enable)
 
 	r = 0;
 
-	mutex_lock(&mb3_transfer.sysclk_lock);
+	mutex_lock(&mb3.sysclk_lock);
 
-	spin_lock_irqsave(&mb3_transfer.lock, flags);
+	spin_lock_irqsave(&mb3.lock, flags);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(3))
 		cpu_relax();
@@ -1411,20 +1115,20 @@ static int request_sysclk(bool enable)
 	writeb(MB3H_SYSCLK, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB3));
 	writel(MBOX_BIT(3), PRCM_MBOX_CPU_SET);
 
-	spin_unlock_irqrestore(&mb3_transfer.lock, flags);
+	spin_unlock_irqrestore(&mb3.lock, flags);
 
 	/*
 	 * The firmware only sends an ACK if we want to enable the
 	 * SysClk, and it succeeds.
 	 */
-	if (enable && !wait_for_completion_timeout(&mb3_transfer.sysclk_work,
+	if (enable && !wait_for_completion_timeout(&mb3.sysclk_work,
 			msecs_to_jiffies(20000))) {
 		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
 			__func__);
 		r = -EIO;
 	}
 
-	mutex_unlock(&mb3_transfer.sysclk_lock);
+	mutex_unlock(&mb3.sysclk_lock);
 
 	return r;
 }
@@ -2007,7 +1711,7 @@ static int db8500_prcmu_config_esram0_deep_sleep(u8 state)
 	    (state < ESRAM0_DEEP_SLEEP_STATE_OFF))
 		return -EINVAL;
 
-	mutex_lock(&mb4_transfer.lock);
+	mutex_lock(&mb4.lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
@@ -2020,16 +1724,16 @@ static int db8500_prcmu_config_esram0_deep_sleep(u8 state)
 	writeb(state, (tcdm_legacy_base + PRCM_REQ_MB4_ESRAM0_ST));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb4_transfer.work);
+	wait_for_completion(&mb4.work);
 
-	mutex_unlock(&mb4_transfer.lock);
+	mutex_unlock(&mb4.lock);
 
 	return 0;
 }
 
 int db8500_prcmu_config_hotdog(u8 threshold)
 {
-	mutex_lock(&mb4_transfer.lock);
+	mutex_lock(&mb4.lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
@@ -2038,16 +1742,16 @@ int db8500_prcmu_config_hotdog(u8 threshold)
 	writeb(MB4H_HOTDOG, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb4_transfer.work);
+	wait_for_completion(&mb4.work);
 
-	mutex_unlock(&mb4_transfer.lock);
+	mutex_unlock(&mb4.lock);
 
 	return 0;
 }
 
 int db8500_prcmu_config_hotmon(u8 low, u8 high)
 {
-	mutex_lock(&mb4_transfer.lock);
+	mutex_lock(&mb4.lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
@@ -2059,16 +1763,16 @@ int db8500_prcmu_config_hotmon(u8 low, u8 high)
 	writeb(MB4H_HOTMON, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb4_transfer.work);
+	wait_for_completion(&mb4.work);
 
-	mutex_unlock(&mb4_transfer.lock);
+	mutex_unlock(&mb4.lock);
 
 	return 0;
 }
 
 static int config_hot_period(u16 val)
 {
-	mutex_lock(&mb4_transfer.lock);
+	mutex_lock(&mb4.lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
@@ -2077,9 +1781,9 @@ static int config_hot_period(u16 val)
 	writeb(MB4H_HOT_PERIOD, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb4_transfer.work);
+	wait_for_completion(&mb4.work);
 
-	mutex_unlock(&mb4_transfer.lock);
+	mutex_unlock(&mb4.lock);
 
 	return 0;
 }
@@ -2100,7 +1804,7 @@ int db8500_prcmu_stop_temp_sense(void)
 static int prcmu_a9wdog(u8 cmd, u8 d0, u8 d1, u8 d2, u8 d3)
 {
 
-	mutex_lock(&mb4_transfer.lock);
+	mutex_lock(&mb4.lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
@@ -2113,9 +1817,9 @@ static int prcmu_a9wdog(u8 cmd, u8 d0, u8 d1, u8 d2, u8 d3)
 	writeb(cmd, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb4_transfer.work);
+	wait_for_completion(&mb4.work);
 
-	mutex_unlock(&mb4_transfer.lock);
+	mutex_unlock(&mb4.lock);
 
 	return 0;
 
@@ -2178,7 +1882,7 @@ static int db8500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 	if (size != 1)
 		return -EINVAL;
 
-	mutex_lock(&mb5_transfer.lock);
+	mutex_lock(&mb5.lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
@@ -2192,19 +1896,19 @@ static int db8500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 
 	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
 
-	if (!wait_for_completion_timeout(&mb5_transfer.work,
+	if (!wait_for_completion_timeout(&mb5.work,
 				msecs_to_jiffies(20000))) {
 		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
 			__func__);
 		r = -EIO;
 	} else {
-		r = ((mb5_transfer.ack.status == I2C_RD_OK) ? 0 : -EIO);
+		r = ((mb5.ack.status == I2C_RD_OK) ? 0 : -EIO);
 	}
 
 	if (!r)
-		*value = mb5_transfer.ack.value;
+		*value = mb5.ack.value;
 
-	mutex_unlock(&mb5_transfer.lock);
+	mutex_unlock(&mb5.lock);
 
 	return r;
 }
@@ -2230,30 +1934,30 @@ static int db8500_prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask,
 	if (size != 1)
 		return -EINVAL;
 
-	mutex_lock(&mb5_transfer.lock);
+	mutex_lock(&mb5.lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
 
 	writeb(~*mask, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB5));
 	writeb(PRCMU_I2C_WRITE(slave),
-			(tcdm_legacy_base + PRCM_REQ_MB5_I2C_SLAVE_OP));
+			tcdm_legacy_base + PRCM_REQ_MB5_I2C_SLAVE_OP);
 	writeb(PRCMU_I2C_STOP_EN, tcdm_legacy_base + PRCM_REQ_MB5_I2C_HW_BITS);
 	writeb(reg, (tcdm_legacy_base + PRCM_REQ_MB5_I2C_REG));
 	writeb(*value, (tcdm_legacy_base + PRCM_REQ_MB5_I2C_VAL));
 
 	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
 
-	if (!wait_for_completion_timeout(&mb5_transfer.work,
+	if (!wait_for_completion_timeout(&mb5.work,
 				msecs_to_jiffies(20000))) {
 		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
 			__func__);
 		r = -EIO;
 	} else {
-		r = ((mb5_transfer.ack.status == I2C_WR_OK) ? 0 : -EIO);
+		r = ((mb5.ack.status == I2C_WR_OK) ? 0 : -EIO);
 	}
 
-	mutex_unlock(&mb5_transfer.lock);
+	mutex_unlock(&mb5.lock);
 
 	return r;
 }
@@ -2283,7 +1987,7 @@ int prcmu_ac_wake_req(void)
 	u32 val;
 	int ret = 0;
 
-	mutex_lock(&mb0_transfer.ac_wake_lock);
+	mutex_lock(&mb0.ac_wake_lock);
 
 	val = readl(PRCM_HOSTACCESS_REQ);
 	if (val & PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ)
@@ -2304,7 +2008,7 @@ int prcmu_ac_wake_req(void)
 	val |= PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ;
 	writel(val, PRCM_HOSTACCESS_REQ);
 
-	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
+	if (!wait_for_completion_timeout(&mb0.ac_wake_work,
 			msecs_to_jiffies(5000))) {
 #if defined(CONFIG_DBX500_PRCMU_DEBUG)
 		db8500_prcmu_debug_dump(__func__, true, true);
@@ -2315,7 +2019,7 @@ int prcmu_ac_wake_req(void)
 	}
 
 unlock_and_return:
-	mutex_unlock(&mb0_transfer.ac_wake_lock);
+	mutex_unlock(&mb0.ac_wake_lock);
 	return ret;
 }
 
@@ -2326,7 +2030,7 @@ void prcmu_ac_sleep_req()
 {
 	u32 val;
 
-	mutex_lock(&mb0_transfer.ac_wake_lock);
+	mutex_lock(&mb0.ac_wake_lock);
 
 	val = readl(PRCM_HOSTACCESS_REQ);
 	if (!(val & PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ))
@@ -2335,7 +2039,7 @@ void prcmu_ac_sleep_req()
 	writel((val & ~PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ),
 		PRCM_HOSTACCESS_REQ);
 
-	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
+	if (!wait_for_completion_timeout(&mb0.ac_wake_work,
 			msecs_to_jiffies(5000))) {
 		pr_crit("prcmu: %s timed out (5 s) waiting for a reply.\n",
 			__func__);
@@ -2344,7 +2048,7 @@ void prcmu_ac_sleep_req()
 	atomic_set(&ac_wake_req_state, 0);
 
 unlock_and_return:
-	mutex_unlock(&mb0_transfer.ac_wake_lock);
+	mutex_unlock(&mb0.ac_wake_lock);
 }
 
 static bool db8500_prcmu_is_ac_wake_requested(void)
@@ -2380,28 +2084,28 @@ static u16 db8500_prcmu_get_reset_code(void)
  */
 static void db8500_prcmu_modem_reset(void)
 {
-	mutex_lock(&mb1_transfer.lock);
+	mutex_lock(&mb1.lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
 	writeb(MB1H_RESET_MODEM, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1_transfer.work);
+	wait_for_completion(&mb1.work);
 
 	/*
 	 * No need to check return from PRCMU as modem should go in reset state
 	 * This state is already managed by upper layer
 	 */
 
-	mutex_unlock(&mb1_transfer.lock);
+	mutex_unlock(&mb1.lock);
 }
 
 static void ack_dbb_wakeup(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&mb0_transfer.lock, flags);
+	spin_lock_irqsave(&mb0.lock, flags);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
 		cpu_relax();
@@ -2410,7 +2114,7 @@ static void ack_dbb_wakeup(void)
 			tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB0);
 	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
 
-	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+	spin_unlock_irqrestore(&mb0.lock, flags);
 }
 
 static inline void print_unknown_header_warning(u8 n, u8 header)
@@ -2438,11 +2142,11 @@ static bool read_mailbox_0(void)
 					PRCM_ACK_MB0_WAKEUP_0_8500);
 
 		if (ev & (WAKEUP_BIT_AC_WAKE_ACK | WAKEUP_BIT_AC_SLEEP_ACK))
-			complete(&mb0_transfer.ac_wake_work);
+			complete(&mb0.ac_wake_work);
 		if (ev & WAKEUP_BIT_SYSCLK_OK)
-			complete(&mb3_transfer.sysclk_work);
+			complete(&mb3.sysclk_work);
 
-		ev &= mb0_transfer.req.dbb_irqs;
+		ev &= mb0.req.dbb_irqs;
 
 		for (n = 0; n < NUM_PRCMU_WAKEUPS; n++) {
 			if (ev & prcmu_irq_bit[n])
@@ -2461,25 +2165,25 @@ static bool read_mailbox_0(void)
 
 static bool read_mailbox_1(void)
 {
-	mb1_transfer.ack.header = readb(tcdm_legacy_base +
+	mb1.ack.header = readb(tcdm_legacy_base +
 			PRCM_MBOX_HEADER_REQ_MB1);
-	mb1_transfer.ack.arm_opp = readb(tcdm_legacy_base +
+	mb1.ack.arm_opp = readb(tcdm_legacy_base +
 		PRCM_ACK_MB1_CURRENT_ARM_OPP);
-	mb1_transfer.ack.ape_opp = readb(tcdm_legacy_base +
+	mb1.ack.ape_opp = readb(tcdm_legacy_base +
 		PRCM_ACK_MB1_CURRENT_APE_OPP);
-	mb1_transfer.ack.ape_voltage_status = readb(tcdm_legacy_base +
+	mb1.ack.ape_voltage_status = readb(tcdm_legacy_base +
 		PRCM_ACK_MB1_APE_VOLTAGE_STATUS);
 	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLR);
-	complete(&mb1_transfer.work);
+	complete(&mb1.work);
 	return false;
 }
 
 static bool read_mailbox_2(void)
 {
-	mb2_transfer.ack.status = readb(tcdm_legacy_base
+	mb2.ack.status = readb(tcdm_legacy_base
 			+ PRCM_ACK_MB2_DPS_STATUS);
 	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLR);
-	complete(&mb2_transfer.work);
+	complete(&mb2.work);
 	return false;
 }
 
@@ -2515,18 +2219,18 @@ static bool read_mailbox_4(void)
 	writel(MBOX_BIT(4), PRCM_ARM_IT1_CLR);
 
 	if (do_complete)
-		complete(&mb4_transfer.work);
+		complete(&mb4.work);
 
 	return false;
 }
 
 static bool read_mailbox_5(void)
 {
-	mb5_transfer.ack.status = readb(tcdm_legacy_base
+	mb5.ack.status = readb(tcdm_legacy_base
 			+ PRCM_ACK_MB5_I2C_STATUS);
-	mb5_transfer.ack.value = readb(tcdm_legacy_base + PRCM_ACK_MB5_I2C_VAL);
+	mb5.ack.value = readb(tcdm_legacy_base + PRCM_ACK_MB5_I2C_VAL);
 	writel(MBOX_BIT(5), PRCM_ARM_IT1_CLR);
-	complete(&mb5_transfer.work);
+	complete(&mb5.work);
 	return false;
 }
 
@@ -2584,39 +2288,39 @@ static void prcmu_mask_work(struct work_struct *work)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&mb0_transfer.lock, flags);
+	spin_lock_irqsave(&mb0.lock, flags);
 
 	config_wakeups();
 
-	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+	spin_unlock_irqrestore(&mb0.lock, flags);
 }
 
 static void prcmu_irq_mask(struct irq_data *d)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&mb0_transfer.dbb_irqs_lock, flags);
+	spin_lock_irqsave(&mb0.dbb_irqs_lock, flags);
 
-	mb0_transfer.req.dbb_irqs &= ~prcmu_irq_bit[d->hwirq];
+	mb0.req.dbb_irqs &= ~prcmu_irq_bit[d->hwirq];
 
-	spin_unlock_irqrestore(&mb0_transfer.dbb_irqs_lock, flags);
+	spin_unlock_irqrestore(&mb0.dbb_irqs_lock, flags);
 
 	if (d->irq != IRQ_PRCMU_CA_SLEEP)
-		schedule_work(&mb0_transfer.mask_work);
+		schedule_work(&mb0.mask_work);
 }
 
 static void prcmu_irq_unmask(struct irq_data *d)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&mb0_transfer.dbb_irqs_lock, flags);
+	spin_lock_irqsave(&mb0.dbb_irqs_lock, flags);
 
-	mb0_transfer.req.dbb_irqs |= prcmu_irq_bit[d->hwirq];
+	mb0.req.dbb_irqs |= prcmu_irq_bit[d->hwirq];
 
-	spin_unlock_irqrestore(&mb0_transfer.dbb_irqs_lock, flags);
+	spin_unlock_irqrestore(&mb0.dbb_irqs_lock, flags);
 
 	if (d->irq != IRQ_PRCMU_CA_SLEEP)
-		schedule_work(&mb0_transfer.mask_work);
+		schedule_work(&mb0.mask_work);
 }
 
 static void noop(struct irq_data *d)
@@ -2898,25 +2602,25 @@ struct prcmu_fops_register_data *__init
 	tcdm_base = ioremap_nocache(U8500_PRCMU_TCDM_BASE, map->tcdm_size);
 	tcdm_legacy_base = tcdm_base + map->legacy_offset;
 
-	spin_lock_init(&mb0_transfer.lock);
-	spin_lock_init(&mb0_transfer.dbb_irqs_lock);
-	mutex_init(&mb0_transfer.ac_wake_lock);
-	init_completion(&mb0_transfer.ac_wake_work);
-	mutex_init(&mb1_transfer.lock);
-	init_completion(&mb1_transfer.work);
-	mb1_transfer.ape_opp = APE_NO_CHANGE;
-	mutex_init(&mb2_transfer.lock);
-	init_completion(&mb2_transfer.work);
-	spin_lock_init(&mb2_transfer.auto_pm_lock);
-	spin_lock_init(&mb3_transfer.lock);
-	mutex_init(&mb3_transfer.sysclk_lock);
-	init_completion(&mb3_transfer.sysclk_work);
-	mutex_init(&mb4_transfer.lock);
-	init_completion(&mb4_transfer.work);
-	mutex_init(&mb5_transfer.lock);
-	init_completion(&mb5_transfer.work);
-
-	INIT_WORK(&mb0_transfer.mask_work, prcmu_mask_work);
+	spin_lock_init(&mb0.lock);
+	spin_lock_init(&mb0.dbb_irqs_lock);
+	mutex_init(&mb0.ac_wake_lock);
+	init_completion(&mb0.ac_wake_work);
+	mutex_init(&mb1.lock);
+	init_completion(&mb1.work);
+	mb1.ape_opp = APE_NO_CHANGE;
+	mutex_init(&mb2.lock);
+	init_completion(&mb2.work);
+	spin_lock_init(&mb2.auto_pm_lock);
+	spin_lock_init(&mb3.lock);
+	mutex_init(&mb3.sysclk_lock);
+	init_completion(&mb3.sysclk_work);
+	mutex_init(&mb4.lock);
+	init_completion(&mb4.work);
+	mutex_init(&mb5.lock);
+	init_completion(&mb5.work);
+
+	INIT_WORK(&mb0.mask_work, prcmu_mask_work);
 
 	/*  early init of dbx500-prcmu */
 	return &db8500_early_data;
diff --git a/drivers/mfd/dbx500-prcmu.h b/drivers/mfd/dbx500-prcmu.h
new file mode 100644
index 0000000..79cba24
--- /dev/null
+++ b/drivers/mfd/dbx500-prcmu.h
@@ -0,0 +1,378 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2012
+ *
+ * Author: Loic Pallardy <loic.pallardy@stericsson.com>
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * PRCMU legacy mailbox definition
+ */
+
+#define KHZ_TO_HZ(A) (A*1000)
+#define HZ_TO_KHZ(A) (A/1000)
+
+/* Offset for the firmware version within the TCPM */
+#define PRCMU_FW_VERSION_OFFSET 0xA4
+
+#define PRCM_BOOT_STATUS	0xFFF
+
+#define PRCM_SW_RST_REASON 0xFF8 /* 2 bytes */
+
+#define PRCM_TCDM_VOICE_CALL_FLAG 0xDD4 /* 4 bytes */
+
+#define _PRCM_MBOX_HEADER		0xFE8 /* 16 bytes */
+#define PRCM_MBOX_HEADER_REQ_MB0	(_PRCM_MBOX_HEADER + 0x0)
+#define PRCM_MBOX_HEADER_REQ_MB1	(_PRCM_MBOX_HEADER + 0x1)
+#define PRCM_MBOX_HEADER_REQ_MB2	(_PRCM_MBOX_HEADER + 0x2)
+#define PRCM_MBOX_HEADER_REQ_MB3	(_PRCM_MBOX_HEADER + 0x3)
+#define PRCM_MBOX_HEADER_REQ_MB4	(_PRCM_MBOX_HEADER + 0x4)
+#define PRCM_MBOX_HEADER_REQ_MB5	(_PRCM_MBOX_HEADER + 0x5)
+#define PRCM_MBOX_HEADER_ACK_MB0	(_PRCM_MBOX_HEADER + 0x8)
+
+/* Req Mailboxes */
+#define PRCM_REQ_MB0 0xFDC /* 12 bytes  */
+#define PRCM_REQ_MB1 0xFD0 /* 12 bytes  */
+#define PRCM_REQ_MB2 0xFC0 /* 16 bytes  */
+#define PRCM_REQ_MB3 0xE4C /* 372 bytes  */
+#define PRCM_REQ_MB4 0xE48 /* 4 bytes  */
+#define PRCM_REQ_MB5 0xE44 /* 4 bytes  */
+#define PRCM_REQ_PASR		0xE04 /* 4 bytes */
+
+/* Ack Mailboxes */
+#define PRCM_ACK_MB0 0xE08 /* 52 bytes  */
+#define PRCM_ACK_MB1 0xE04 /* 4 bytes */
+#define PRCM_ACK_MB2 0xE00 /* 4 bytes */
+#define PRCM_ACK_MB3 0xDFC /* 4 bytes */
+#define PRCM_ACK_MB4 0xDF8 /* 4 bytes */
+#define PRCM_ACK_MB5 0xDF4 /* 4 bytes */
+
+/* Mailbox 0 headers */
+#define MB0H_POWER_STATE_TRANS		0
+#define MB0H_CONFIG_WAKEUPS_EXE		1
+#define MB0H_READ_WAKEUP_ACK		3
+#define MB0H_CONFIG_WAKEUPS_SLEEP	4
+#define MB0H_CONFIG_PASR_DDR0_CS0	6
+#define MB0H_CONFIG_PASR_DDR0_CS1	7
+#define MB0H_CONFIG_PASR_DDR1_CS0	8
+#define MB0H_CONFIG_PASR_DDR1_CS1	9
+
+#define MB0H_WAKEUP_EXE 2
+#define MB0H_WAKEUP_SLEEP 5
+
+/* Mailbox 0 REQs */
+#define PRCM_REQ_MB0_AP_POWER_STATE	(PRCM_REQ_MB0 + 0x0)
+#define PRCM_REQ_MB0_AP_PLL_STATE	(PRCM_REQ_MB0 + 0x1)
+#define PRCM_REQ_MB0_ULP_CLOCK_STATE	(PRCM_REQ_MB0 + 0x2)
+#define PRCM_REQ_MB0_DO_NOT_WFI		(PRCM_REQ_MB0 + 0x3)
+#define PRCM_REQ_MB0_WAKEUP_8500	(PRCM_REQ_MB0 + 0x4)
+#define PRCM_REQ_MB0_WAKEUP_4500	(PRCM_REQ_MB0 + 0x8)
+
+/* Mailbox 0 PASR REQs */
+#define PRCM_REQ_MB0_PASR_MR16		(PRCM_REQ_PASR + 0x0)
+#define PRCM_REQ_MB0_PASR_MR17		(PRCM_REQ_PASR + 0x2)
+
+/* Mailbox 0 ACKs */
+#define PRCM_ACK_MB0_AP_PWRSTTR_STATUS	(PRCM_ACK_MB0 + 0x0)
+#define PRCM_ACK_MB0_READ_POINTER	(PRCM_ACK_MB0 + 0x1)
+#define PRCM_ACK_MB0_WAKEUP_0_8500	(PRCM_ACK_MB0 + 0x4)
+#define PRCM_ACK_MB0_WAKEUP_0_4500	(PRCM_ACK_MB0 + 0x8)
+#define PRCM_ACK_MB0_WAKEUP_1_8500	(PRCM_ACK_MB0 + 0x1C)
+#define PRCM_ACK_MB0_WAKEUP_1_4500	(PRCM_ACK_MB0 + 0x20)
+#define PRCM_ACK_MB0_EVENT_4500_NUMBERS	20
+
+/* Mailbox 1 headers */
+#define MB1H_ARM_APE_OPP 0x0
+#define MB1H_RESET_MODEM 0x2
+#define MB1H_REQUEST_APE_OPP_100_VOLT 0x3
+#define MB1H_RELEASE_APE_OPP_100_VOLT 0x4
+#define MB1H_RELEASE_USB_WAKEUP 0x5
+#define MB1H_PLL_ON_OFF 0x6
+
+/* Mailbox 1 Requests */
+#define PRCM_REQ_MB1_ARM_OPP			(PRCM_REQ_MB1 + 0x0)
+#define PRCM_REQ_MB1_APE_OPP			(PRCM_REQ_MB1 + 0x1)
+#define PRCM_REQ_MB1_PLL_ON_OFF			(PRCM_REQ_MB1 + 0x4)
+#define PLL_SOC0_OFF	0x1
+#define PLL_SOC0_ON	0x2
+#define PLL_SOC1_OFF	0x4
+#define PLL_SOC1_ON	0x8
+
+/* Mailbox 1 ACKs */
+#define PRCM_ACK_MB1_CURRENT_ARM_OPP	(PRCM_ACK_MB1 + 0x0)
+#define PRCM_ACK_MB1_CURRENT_APE_OPP	(PRCM_ACK_MB1 + 0x1)
+#define PRCM_ACK_MB1_APE_VOLTAGE_STATUS	(PRCM_ACK_MB1 + 0x2)
+#define PRCM_ACK_MB1_DVFS_STATUS	(PRCM_ACK_MB1 + 0x3)
+
+/* Mailbox 2 headers */
+#define MB2H_DPS	0x0
+#define MB2H_AUTO_PWR	0x1
+
+/* Mailbox 2 REQs */
+#define PRCM_REQ_MB2_SVA_MMDSP		(PRCM_REQ_MB2 + 0x0)
+#define PRCM_REQ_MB2_SVA_PIPE		(PRCM_REQ_MB2 + 0x1)
+#define PRCM_REQ_MB2_SIA_MMDSP		(PRCM_REQ_MB2 + 0x2)
+#define PRCM_REQ_MB2_SIA_PIPE		(PRCM_REQ_MB2 + 0x3)
+#define PRCM_REQ_MB2_SGA		(PRCM_REQ_MB2 + 0x4)
+#define PRCM_REQ_MB2_B2R2_MCDE		(PRCM_REQ_MB2 + 0x5)
+#define PRCM_REQ_MB2_ESRAM12		(PRCM_REQ_MB2 + 0x6)
+#define PRCM_REQ_MB2_ESRAM34		(PRCM_REQ_MB2 + 0x7)
+#define PRCM_REQ_MB2_AUTO_PM_SLEEP	(PRCM_REQ_MB2 + 0x8)
+#define PRCM_REQ_MB2_AUTO_PM_IDLE	(PRCM_REQ_MB2 + 0xC)
+
+/* Mailbox 2 ACKs */
+#define PRCM_ACK_MB2_DPS_STATUS (PRCM_ACK_MB2 + 0x0)
+#define HWACC_PWR_ST_OK 0xFE
+
+/* Mailbox 3 headers */
+#define MB3H_ANC	0x0
+#define MB3H_SIDETONE	0x1
+#define MB3H_SYSCLK	0xE
+
+/* Mailbox 3 Requests */
+#define PRCM_REQ_MB3_ANC_FIR_COEFF	(PRCM_REQ_MB3 + 0x0)
+#define PRCM_REQ_MB3_ANC_IIR_COEFF	(PRCM_REQ_MB3 + 0x20)
+#define PRCM_REQ_MB3_ANC_SHIFTER	(PRCM_REQ_MB3 + 0x60)
+#define PRCM_REQ_MB3_ANC_WARP		(PRCM_REQ_MB3 + 0x64)
+#define PRCM_REQ_MB3_SIDETONE_FIR_GAIN	(PRCM_REQ_MB3 + 0x68)
+#define PRCM_REQ_MB3_SIDETONE_FIR_COEFF	(PRCM_REQ_MB3 + 0x6C)
+#define PRCM_REQ_MB3_SYSCLK_MGT		(PRCM_REQ_MB3 + 0x16C)
+
+/* Mailbox 3 ACKs */
+#define PRCM_ACK_MB3_TRACE_MSG	(PRCM_ACK_MB3 + 0x00)
+#define PRCM_ACK_MB3_LOG_REQ	(PRCM_ACK_MB3 + 0x01)
+#define MB3_LOG_REQ_PRCMU_REGS	(1 << 0)
+#define MB3_LOG_REQ_TCDM	(1 << 1)
+#define MB3_LOG_REQ_AB_REGS	(1 << 2)
+
+/* Mailbox 4 headers */
+#define MB4H_DDR_INIT	0x0
+#define MB4H_MEM_ST	0x1
+#define MB4H_HOTDOG	0x12
+#define MB4H_HOTMON	0x13
+#define MB4H_HOT_PERIOD	0x14
+#define MB4H_A9WDOG_CONF 0x16
+#define MB4H_A9WDOG_EN   0x17
+#define MB4H_A9WDOG_DIS  0x18
+#define MB4H_A9WDOG_LOAD 0x19
+#define MB4H_A9WDOG_KICK 0x20
+
+/* Mailbox 4 Requests */
+#define PRCM_REQ_MB4_DDR_ST_AP_SLEEP_IDLE	(PRCM_REQ_MB4 + 0x0)
+#define PRCM_REQ_MB4_DDR_ST_AP_DEEP_IDLE	(PRCM_REQ_MB4 + 0x1)
+#define PRCM_REQ_MB4_ESRAM0_ST			(PRCM_REQ_MB4 + 0x3)
+#define PRCM_REQ_MB4_HOTDOG_THRESHOLD		(PRCM_REQ_MB4 + 0x0)
+#define PRCM_REQ_MB4_HOTMON_LOW			(PRCM_REQ_MB4 + 0x0)
+#define PRCM_REQ_MB4_HOTMON_HIGH		(PRCM_REQ_MB4 + 0x1)
+#define PRCM_REQ_MB4_HOTMON_CONFIG		(PRCM_REQ_MB4 + 0x2)
+#define PRCM_REQ_MB4_HOT_PERIOD			(PRCM_REQ_MB4 + 0x0)
+#define HOTMON_CONFIG_LOW			BIT(0)
+#define HOTMON_CONFIG_HIGH			BIT(1)
+#define PRCM_REQ_MB4_A9WDOG_0			(PRCM_REQ_MB4 + 0x0)
+#define PRCM_REQ_MB4_A9WDOG_1			(PRCM_REQ_MB4 + 0x1)
+#define PRCM_REQ_MB4_A9WDOG_2			(PRCM_REQ_MB4 + 0x2)
+#define PRCM_REQ_MB4_A9WDOG_3			(PRCM_REQ_MB4 + 0x3)
+#define A9WDOG_AUTO_OFF_EN			BIT(7)
+#define A9WDOG_AUTO_OFF_DIS			0
+#define A9WDOG_ID_MASK				0xf
+
+#define MB4TIM (HZ/10)
+
+/* Mailbox 5 Requests */
+#define PRCM_REQ_MB5_I2C_SLAVE_OP	(PRCM_REQ_MB5 + 0x0)
+#define PRCM_REQ_MB5_I2C_HW_BITS	(PRCM_REQ_MB5 + 0x1)
+#define PRCM_REQ_MB5_I2C_REG		(PRCM_REQ_MB5 + 0x2)
+#define PRCM_REQ_MB5_I2C_VAL		(PRCM_REQ_MB5 + 0x3)
+#define PRCMU_I2C_WRITE(slave) (((slave) << 1) | BIT(6))
+#define PRCMU_I2C_READ(slave) (((slave) << 1) | BIT(0) | BIT(6))
+#define PRCMU_I2C_STOP_EN		BIT(3)
+
+/* Mailbox 5 ACKs */
+#define PRCM_ACK_MB5_I2C_STATUS	(PRCM_ACK_MB5 + 0x1)
+#define PRCM_ACK_MB5_I2C_VAL	(PRCM_ACK_MB5 + 0x3)
+#define I2C_WR_OK 0x1
+#define I2C_RD_OK 0x2
+
+#define NUM_MB 8
+#define MBOX_BIT BIT
+#define ALL_MBOX_BITS (MBOX_BIT(NUM_MB) - 1)
+
+/*
+ * Wakeups/IRQs
+ */
+
+#define WAKEUP_BIT_RTC BIT(0)
+#define WAKEUP_BIT_RTT0 BIT(1)
+#define WAKEUP_BIT_RTT1 BIT(2)
+#define WAKEUP_BIT_HSI0 BIT(3)
+#define WAKEUP_BIT_HSI1 BIT(4)
+#define WAKEUP_BIT_CA_WAKE BIT(5)
+#define WAKEUP_BIT_USB BIT(6)
+#define WAKEUP_BIT_ABB BIT(7)
+#define WAKEUP_BIT_ABB_FIFO BIT(8)
+#define WAKEUP_BIT_SYSCLK_OK BIT(9)
+#define WAKEUP_BIT_CA_SLEEP BIT(10)
+#define WAKEUP_BIT_AC_WAKE_ACK BIT(11)
+#define WAKEUP_BIT_SIDE_TONE_OK BIT(12)
+#define WAKEUP_BIT_ANC_OK BIT(13)
+#define WAKEUP_BIT_SW_ERROR BIT(14)
+#define WAKEUP_BIT_AC_SLEEP_ACK BIT(15)
+#define WAKEUP_BIT_ARM BIT(17)
+#define WAKEUP_BIT_HOTMON_LOW BIT(18)
+#define WAKEUP_BIT_HOTMON_HIGH BIT(19)
+#define WAKEUP_BIT_MODEM_SW_RESET_REQ BIT(20)
+#define WAKEUP_BIT_GPIO0 BIT(23)
+#define WAKEUP_BIT_GPIO1 BIT(24)
+#define WAKEUP_BIT_GPIO2 BIT(25)
+#define WAKEUP_BIT_GPIO3 BIT(26)
+#define WAKEUP_BIT_GPIO4 BIT(27)
+#define WAKEUP_BIT_GPIO5 BIT(28)
+#define WAKEUP_BIT_GPIO6 BIT(29)
+#define WAKEUP_BIT_GPIO7 BIT(30)
+#define WAKEUP_BIT_GPIO8 BIT(31)
+
+/*
+* Used by MCDE to setup all necessary PRCMU registers
+*/
+#define PRCMU_RESET_DSIPLL		0x00004000
+#define PRCMU_UNCLAMP_DSIPLL		0x00400800
+
+#define PRCMU_CLK_PLL_DIV_SHIFT		0
+#define PRCMU_CLK_PLL_SW_SHIFT		5
+#define PRCMU_CLK_38			(1 << 9)
+#define PRCMU_CLK_38_SRC		(1 << 10)
+#define PRCMU_CLK_38_DIV		(1 << 11)
+
+/* PLLDIV=12, PLLSW=4 (PLLDDR) */
+#define PRCMU_DSI_CLOCK_SETTING		0x0000008C
+
+/* DPI 50000000 Hz */
+#define PRCMU_DPI_CLOCK_SETTING		((1 << PRCMU_CLK_PLL_SW_SHIFT) | \
+					  (16 << PRCMU_CLK_PLL_DIV_SHIFT))
+#define PRCMU_DSI_LP_CLOCK_SETTING	0x00000E00
+
+/* D=101, N=1, R=4, SELDIV2=0 */
+#define PRCMU_PLLDSI_FREQ_SETTING	0x00040165
+
+#define PRCMU_ENABLE_PLLDSI		0x00000001
+#define PRCMU_DISABLE_PLLDSI		0x00000000
+#define PRCMU_RELEASE_RESET_DSS		0x0000400C
+#define PRCMU_DSI_PLLOUT_SEL_SETTING	0x00000202
+/* ESC clk, div0=1, div1=1, div2=3 */
+#define PRCMU_ENABLE_ESCAPE_CLOCK_DIV	0x07030101
+#define PRCMU_DISABLE_ESCAPE_CLOCK_DIV	0x00030101
+#define PRCMU_DSI_RESET_SW		0x00000007
+
+#define PRCMU_PLLDSI_LOCKP_LOCKED	0x3
+
+struct clk_mgt {
+	void __iomem *reg;
+	u32 pllsw;
+	int branch;
+	bool clk38div;
+};
+
+enum {
+	PLL_RAW,
+	PLL_FIX,
+	PLL_DIV
+};
+
+/*
+ * mb0_transfer - state needed for mailbox 0 communication.
+ * @lock:		The transaction lock.
+ * @dbb_events_lock:	A lock used to handle concurrent access to (parts of)
+ *			the request data.
+ * @mask_work:		Work structure used for (un)masking wakeup interrupts.
+ * @req:		Request data that need to persist between requests.
+ */
+struct mb0_transfer {
+	spinlock_t lock;
+	spinlock_t dbb_irqs_lock;
+	struct work_struct mask_work;
+	struct mutex ac_wake_lock;
+	struct completion ac_wake_work;
+	struct {
+		u32 dbb_irqs;
+		u32 dbb_wakeups;
+		u32 abb_events;
+	} req;
+};
+
+/*
+ * mb1_transfer - state needed for mailbox 1 communication.
+ * @lock:	The transaction lock.
+ * @work:	The transaction completion structure.
+ * @ape_opp:	The current APE OPP.
+ * @ack:	Reply ("acknowledge") data.
+ */
+struct mb1_transfer {
+	struct mutex lock;
+	struct completion work;
+	u8 ape_opp;
+	struct {
+		u8 header;
+		u8 arm_opp;
+		u8 ape_opp;
+		u8 ape_voltage_status;
+	} ack;
+};
+
+/*
+ * mb2_transfer - state needed for mailbox 2 communication.
+ * @lock:            The transaction lock.
+ * @work:            The transaction completion structure.
+ * @auto_pm_lock:    The autonomous power management configuration lock.
+ * @auto_pm_enabled: A flag indicating whether autonomous PM is enabled.
+ * @req:             Request data that need to persist between requests.
+ * @ack:             Reply ("acknowledge") data.
+ */
+struct mb2_transfer {
+	struct mutex lock;
+	struct completion work;
+	spinlock_t auto_pm_lock;
+	bool auto_pm_enabled;
+	struct {
+		u8 status;
+	} ack;
+};
+
+/*
+ * mb3_transfer - state needed for mailbox 3 communication.
+ * @lock:		The request lock.
+ * @sysclk_lock:	A lock used to handle concurrent sysclk requests.
+ * @sysclk_work:	Work structure used for sysclk requests.
+ */
+struct mb3_transfer {
+	spinlock_t lock;
+	struct mutex sysclk_lock;
+	struct completion sysclk_work;
+	spinlock_t fw_log_lock;
+	struct work_struct fw_log_work;
+	u8 fw_log_req;
+};
+
+/*
+ * mb4_transfer - state needed for mailbox 4 communication.
+ * @lock:	The transaction lock.
+ * @work:	The transaction completion structure.
+ */
+struct mb4_transfer {
+	struct mutex lock;
+	struct completion work;
+};
+
+/*
+ * mb5_transfer - state needed for mailbox 5 communication.
+ * @lock:	The transaction lock.
+ * @work:	The transaction completion structure.
+ * @ack:	Reply ("acknowledge") data.
+ */
+struct mb5_transfer {
+	struct mutex lock;
+	struct completion work;
+	struct {
+		u8 status;
+		u8 value;
+	} ack;
+};
+
-- 
1.7.11.1

