Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab2FTWuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:50:07 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41899 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758452Ab2FTWuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:50:02 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 10/15] ARM: etm: Wait for etm/ptm(s) to stop before requesting PowerDown
Date: Wed, 20 Jun 2012 18:47:42 -0400
Message-Id: <1340232467-6023-11-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062022-7282-0000-0000-00000A239346
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

When PowerDown was requested at the same time as ProgBit, the
formatter flush command that follows could get stuck.

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/kernel/etm.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 66bf592..bad28de 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -200,11 +200,13 @@ static int trace_stop_etm(struct tracectx *t, int id)
 
 	etm_unlock(t, id);
 
-	etm_writel(t, id, 0x441, ETMR_CTRL);
+	etm_writel(t, id, 0x440, ETMR_CTRL);
 	while (!(etm_readl(t, id, ETMR_CTRL) & ETMCTRL_PROGRAM) && --timeout)
 		;
 	if (!timeout) {
-		dev_dbg(t->dev, "Waiting for progbit to assert timed out\n");
+		dev_err(t->dev,
+			"etm%d: Waiting for progbit to assert timed out\n",
+			id);
 		etm_lock(t, id);
 		return -EFAULT;
 	}
@@ -213,18 +215,36 @@ static int trace_stop_etm(struct tracectx *t, int id)
 	return 0;
 }
 
+static int trace_power_down_etm(struct tracectx *t, int id)
+{
+	unsigned long timeout = TRACER_TIMEOUT;
+	etm_unlock(t, id);
+	while (!(etm_readl(t, id, ETMR_STATUS) & ETMST_PROGBIT) && --timeout)
+		;
+	if (!timeout) {
+		dev_err(t->dev, "etm%d: Waiting for status progbit to assert timed out\n",
+			id);
+		etm_lock(t, id);
+		return -EFAULT;
+	}
+
+	etm_writel(t, id, 0x441, ETMR_CTRL);
+
+	etm_lock(t, id);
+	return 0;
+}
+
 static int trace_stop(struct tracectx *t)
 {
 	int id;
-	int ret;
 	unsigned long timeout = TRACER_TIMEOUT;
 	u32 etb_fc = t->etb_fc;
 
-	for (id = 0; id < t->etm_regs_count; id++) {
-		ret = trace_stop_etm(t, id);
-		if (ret)
-			return ret;
-	}
+	for (id = 0; id < t->etm_regs_count; id++)
+		trace_stop_etm(t, id);
+
+	for (id = 0; id < t->etm_regs_count; id++)
+		trace_power_down_etm(t, id);
 
 	etb_unlock(t);
 	if (etb_fc) {
-- 
1.7.9.5

