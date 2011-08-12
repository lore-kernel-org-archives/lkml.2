Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1HLI3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:29:35 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:40895 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1HLI3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:29:32 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 09/23] mfd/db8500-prcmu: tweak for modem wakeup
Date: Fri, 12 Aug 2011 10:28:43 +0200
Message-ID: <1313137723-30881-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

This is a tweak for the case where the modem goes to sleep while
emitting the AC_WAKE_ACK anyway. Also print the modem errors as
critical, since they jeopardize the entire platform when they
occur.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 95498f8..cb58e44 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1745,6 +1745,7 @@ int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 void prcmu_ac_wake_req(void)
 {
 	u32 val;
+	u32 status;
 
 	mutex_lock(&mb0_transfer.ac_wake_lock);
 
@@ -1754,11 +1755,34 @@ void prcmu_ac_wake_req(void)
 
 	atomic_set(&ac_wake_req_state, 1);
 
+retry:
 	writel((val | PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ), PRCM_HOSTACCESS_REQ);
 
 	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
-			msecs_to_jiffies(20000))) {
-		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
+			msecs_to_jiffies(5000))) {
+		panic("prcmu: %s timed out (5 s) waiting for a reply.\n",
+			__func__);
+		goto unlock_and_return;
+	}
+
+	/*
+	 * The modem can generate an AC_WAKE_ACK, and then still go to sleep.
+	 * As a workaround, we wait, and then check that the modem is indeed
+	 * awake (in terms of the value of the PRCM_MOD_AWAKE_STATUS
+	 * register, which may not be the whole truth).
+	 */
+	udelay(400);
+	status = (readl(PRCM_MOD_AWAKE_STATUS) & BITS(0, 2));
+	if (status != (PRCM_MOD_AWAKE_STATUS_PRCM_MOD_AAPD_AWAKE |
+			PRCM_MOD_AWAKE_STATUS_PRCM_MOD_COREPD_AWAKE)) {
+		pr_err("prcmu: %s received ack, but modem not awake (0x%X).\n",
+			__func__, status);
+		udelay(1200);
+		writel(val, PRCM_HOSTACCESS_REQ);
+		if (wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
+				msecs_to_jiffies(5000)))
+			goto retry;
+		panic("prcmu: %s timed out (5 s) waiting for AC_SLEEP_ACK.\n",
 			__func__);
 	}
 
@@ -1783,8 +1807,8 @@ void prcmu_ac_sleep_req()
 		PRCM_HOSTACCESS_REQ);
 
 	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
-			msecs_to_jiffies(20000))) {
-		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
+			msecs_to_jiffies(5000))) {
+		panic("prcmu: %s timed out (5 s) waiting for a reply.\n",
 			__func__);
 	}
 
-- 
1.7.3.2

