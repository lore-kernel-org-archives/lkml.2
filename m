Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2FTWsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:48:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47056 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949Ab2FTWsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:48:10 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 11/15] ARM: etm: Check arch version and disable data tracing for ptm
Date: Wed, 20 Jun 2012 18:47:43 -0400
Message-Id: <1340232467-6023-12-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062022-4242-0000-0000-0000020E415A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Check arch version and disable data tracing for ptm

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/include/asm/hardware/coresight.h |    5 +++++
 arch/arm/kernel/etm.c                     |   23 ++++++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/hardware/coresight.h b/arch/arm/include/asm/hardware/coresight.h
index 6643d6c..0fad8f8 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -60,6 +60,7 @@
 
 /* ETM configuration code register */
 #define ETMR_CONFCODE		(0x04)
+#define ETMCCR_ETMIDR_PRESENT	BIT(31)
 
 /* ETM trace start/stop resource control register */
 #define ETMR_TRACESSCTRL	(0x18)
@@ -126,6 +127,10 @@
 				ETMCTRL_BRANCH_OUTPUT | \
 				ETMCTRL_DO_CONTEXTID)
 
+#define ETMR_ID			0x1e4
+#define ETMIDR_VERSION(x)	(((x) >> 4) & 0xff)
+#define ETMIDR_VERSION_PFT_1_0	0x30
+
 #define ETMR_TRACEIDR		0x200
 
 /* ETM management registers, "ETM Architecture", 3.5.24 */
diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index bad28de..e42b706 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -724,6 +724,9 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 	int ret = 0;
 	void __iomem **new_regs;
 	int new_count;
+	u32 etmccr;
+	u32 etmidr;
+	u8 etm_version = 0;
 
 	mutex_lock(&t->mutex);
 	new_count = t->etm_regs_count + 1;
@@ -758,7 +761,12 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 	/* dummy first read */
 	(void)etm_readl(&tracer, t->etm_regs_count, ETMMR_OSSRR);
 
-	t->ncmppairs = etm_readl(t, t->etm_regs_count, ETMR_CONFCODE) & 0xf;
+	etmccr = etm_readl(t, t->etm_regs_count, ETMR_CONFCODE);
+	t->ncmppairs = etmccr & 0xf;
+	if (etmccr & ETMCCR_ETMIDR_PRESENT) {
+		etmidr = etm_readl(t, t->etm_regs_count, ETMR_ID);
+		etm_version = ETMIDR_VERSION(etmidr);
+	}
 	etm_writel(t, t->etm_regs_count, 0x441, ETMR_CTRL);
 	etm_writel(t, t->etm_regs_count, new_count, ETMR_TRACEIDR);
 	etm_lock(t, t->etm_regs_count);
@@ -781,10 +789,15 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 	if (ret)
 		dev_dbg(&dev->dev, "Failed to create trace_range in sysfs\n");
 
-	ret = sysfs_create_file(&dev->dev.kobj, &trace_data_range_attr.attr);
-	if (ret)
-		dev_dbg(&dev->dev,
-			"Failed to create trace_data_range in sysfs\n");
+	if (etm_version < ETMIDR_VERSION_PFT_1_0) {
+		ret = sysfs_create_file(&dev->dev.kobj,
+					&trace_data_range_attr.attr);
+		if (ret)
+			dev_dbg(&dev->dev,
+				"Failed to create trace_data_range in sysfs\n");
+	} else {
+		tracer.flags &= ~TRACER_TRACE_DATA;
+	}
 
 	dev_dbg(&dev->dev, "ETM AMBA driver initialized.\n");
 
-- 
1.7.9.5

