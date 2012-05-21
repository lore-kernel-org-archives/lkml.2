Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2EUI6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:58:43 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:54507 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755532Ab2EUI6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:58:41 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: <linus.walleij@stericsson.com>, <arun.murthy@stericsson.com>
Subject: [PATCH 1/1] mfd: db8500-prcmu: update hostport_access enable
Date: Mon, 21 May 2012 14:28:21 +0530
Message-ID: <1337590701-17056-1-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Force the Modem wakeup by asserting the CaWakeReq signal before the
hostaccess_req/ack ping-pong sequence. The Awake_req signal is de-asserted
asserted at the same time than the hostaccess_req. Return error on failure
case so that the client using this can take appropiate steps.

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/db8500-prcmu.c       |   45 ++++++++++++++++----------------------
 drivers/mfd/dbx500-prcmu-regs.h  |    1 +
 include/linux/mfd/db8500-prcmu.h |    7 ++++-
 include/linux/mfd/dbx500-prcmu.h |    7 ++++-
 4 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 671c8bc..084d27c 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2269,10 +2269,10 @@ int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 /**
  * prcmu_ac_wake_req - should be called whenever ARM wants to wakeup Modem
  */
-void prcmu_ac_wake_req(void)
+int prcmu_ac_wake_req(void)
 {
 	u32 val;
-	u32 status;
+	int ret = 0;
 
 	mutex_lock(&mb0_transfer.ac_wake_lock);
 
@@ -2282,39 +2282,32 @@ void prcmu_ac_wake_req(void)
 
 	atomic_set(&ac_wake_req_state, 1);
 
-retry:
-	writel((val | PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ), PRCM_HOSTACCESS_REQ);
+	/*
+	 * Force Modem Wake-up before hostaccess_req ping-pong.
+	 * It prevents Modem to enter in Sleep while acking the hostaccess
+	 * request. The 31us delay has been calculated by HWI.
+	 */
+	val |= PRCM_HOSTACCESS_REQ_WAKE_REQ;
+	writel(val, PRCM_HOSTACCESS_REQ);
+
+	udelay(31);
+
+	val |= PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ;
+	writel(val, PRCM_HOSTACCESS_REQ);
 
 	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
 			msecs_to_jiffies(5000))) {
+#if defined(CONFIG_DBX500_PRCMU_DEBUG)
+		db8500_prcmu_debug_dump(__func__, true, true);
+#endif
 		pr_crit("prcmu: %s timed out (5 s) waiting for a reply.\n",
 			__func__);
-		goto unlock_and_return;
-	}
-
-	/*
-	 * The modem can generate an AC_WAKE_ACK, and then still go to sleep.
-	 * As a workaround, we wait, and then check that the modem is indeed
-	 * awake (in terms of the value of the PRCM_MOD_AWAKE_STATUS
-	 * register, which may not be the whole truth).
-	 */
-	udelay(400);
-	status = (readl(PRCM_MOD_AWAKE_STATUS) & BITS(0, 2));
-	if (status != (PRCM_MOD_AWAKE_STATUS_PRCM_MOD_AAPD_AWAKE |
-			PRCM_MOD_AWAKE_STATUS_PRCM_MOD_COREPD_AWAKE)) {
-		pr_err("prcmu: %s received ack, but modem not awake (0x%X).\n",
-			__func__, status);
-		udelay(1200);
-		writel(val, PRCM_HOSTACCESS_REQ);
-		if (wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
-				msecs_to_jiffies(5000)))
-			goto retry;
-		pr_crit("prcmu: %s timed out (5 s) waiting for AC_SLEEP_ACK.\n",
-			__func__);
+		ret = -EFAULT;
 	}
 
 unlock_and_return:
 	mutex_unlock(&mb0_transfer.ac_wake_lock);
+	return ret;
 }
 
 /**
diff --git a/drivers/mfd/dbx500-prcmu-regs.h b/drivers/mfd/dbx500-prcmu-regs.h
index 3a0bf91..23108a6 100644
--- a/drivers/mfd/dbx500-prcmu-regs.h
+++ b/drivers/mfd/dbx500-prcmu-regs.h
@@ -106,6 +106,7 @@
 
 #define PRCM_HOSTACCESS_REQ	(_PRCMU_BASE + 0x334)
 #define PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ 0x1
+#define PRCM_HOSTACCESS_REQ_WAKE_REQ	BIT(16)
 #define ARM_WAKEUP_MODEM	0x1
 
 #define PRCM_ARM_IT1_CLR	(_PRCMU_BASE + 0x48C)
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index b3a43b1..b82f6ee 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -530,7 +530,7 @@ int db8500_prcmu_stop_temp_sense(void);
 int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
 int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
 
-void prcmu_ac_wake_req(void);
+int prcmu_ac_wake_req(void);
 void prcmu_ac_sleep_req(void);
 void db8500_prcmu_modem_reset(void);
 
@@ -680,7 +680,10 @@ static inline int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 	return -ENOSYS;
 }
 
-static inline void prcmu_ac_wake_req(void) {}
+static inline int prcmu_ac_wake_req(void)
+{
+	return 0;
+}
 
 static inline void prcmu_ac_sleep_req(void) {}
 
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index 5a13f93..5b90e94 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -345,7 +345,7 @@ static inline u16 prcmu_get_reset_code(void)
 	return db8500_prcmu_get_reset_code();
 }
 
-void prcmu_ac_wake_req(void);
+int prcmu_ac_wake_req(void);
 void prcmu_ac_sleep_req(void);
 static inline void prcmu_modem_reset(void)
 {
@@ -533,7 +533,10 @@ static inline u16 prcmu_get_reset_code(void)
 	return 0;
 }
 
-static inline void prcmu_ac_wake_req(void) {}
+static inline int prcmu_ac_wake_req(void)
+{
+	return 0;
+}
 
 static inline void prcmu_ac_sleep_req(void) {}
 
-- 
1.7.4.3

