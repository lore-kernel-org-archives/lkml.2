Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab2FTWsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:48:38 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41188 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab2FTWsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:48:35 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 12/15] ARM: etm: Add sysfs entry to enable timestamps if supported
Date: Wed, 20 Jun 2012 18:47:44 -0400
Message-Id: <1340232467-6023-13-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062022-1780-0000-0000-000006A6DD43
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000003; SDB=6.00149807; UDB=6.00034058; UTC=2012-06-20
 22:48:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Add sysfs entry to enable timestamps if supported

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/include/asm/hardware/coresight.h |    7 +++++
 arch/arm/kernel/etm.c                     |   44 +++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/arch/arm/include/asm/hardware/coresight.h b/arch/arm/include/asm/hardware/coresight.h
index 0fad8f8..42059d3 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -18,10 +18,12 @@
 #define TRACER_RUNNING_BIT	1
 #define TRACER_CYCLE_ACC_BIT	2
 #define TRACER_TRACE_DATA_BIT	3
+#define TRACER_TIMESTAMP_BIT	4
 #define TRACER_ACCESSED		BIT(TRACER_ACCESSED_BIT)
 #define TRACER_RUNNING		BIT(TRACER_RUNNING_BIT)
 #define TRACER_CYCLE_ACC	BIT(TRACER_CYCLE_ACC_BIT)
 #define TRACER_TRACE_DATA	BIT(TRACER_TRACE_DATA_BIT)
+#define TRACER_TIMESTAMP	BIT(TRACER_TIMESTAMP_BIT)
 
 #define TRACER_TIMEOUT 10000
 
@@ -57,6 +59,7 @@
 #define ETMCTRL_DATA_DO_BOTH	(ETMCTRL_DATA_DO_DATA | ETMCTRL_DATA_DO_ADDR)
 #define ETMCTRL_BRANCH_OUTPUT	(1 << 8)
 #define ETMCTRL_CYCLEACCURATE	(1 << 12)
+#define ETMCTRL_TIMESTAMP_EN	(1 << 28)
 
 /* ETM configuration code register */
 #define ETMR_CONFCODE		(0x04)
@@ -129,8 +132,12 @@
 
 #define ETMR_ID			0x1e4
 #define ETMIDR_VERSION(x)	(((x) >> 4) & 0xff)
+#define ETMIDR_VERSION_3_1	0x21
 #define ETMIDR_VERSION_PFT_1_0	0x30
 
+#define ETMR_CCE		0x1e8
+#define ETMCCER_TIMESTAMPING_IMPLEMENTED	BIT(22)
+
 #define ETMR_TRACEIDR		0x200
 
 /* ETM management registers, "ETM Architecture", 3.5.24 */
diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index e42b706..460a7d8 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -116,6 +116,9 @@ static int trace_start_etm(struct tracectx *t, int id)
 	if (t->flags & TRACER_TRACE_DATA)
 		v |= ETMCTRL_DATA_DO_ADDR;
 
+	if (t->flags & TRACER_TIMESTAMP)
+		v |= ETMCTRL_TIMESTAMP_EN;
+
 	etm_unlock(t, id);
 
 	etm_writel(t, id, v, ETMR_CTRL);
@@ -647,6 +650,36 @@ static ssize_t trace_mode_store(struct kobject *kobj,
 static struct kobj_attribute trace_mode_attr =
 	__ATTR(trace_mode, 0644, trace_mode_show, trace_mode_store);
 
+static ssize_t trace_timestamp_show(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  char *buf)
+{
+	return sprintf(buf, "%d\n", !!(tracer.flags & TRACER_TIMESTAMP));
+}
+
+static ssize_t trace_timestamp_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t n)
+{
+	unsigned int timestamp;
+
+	if (sscanf(buf, "%u", &timestamp) != 1)
+		return -EINVAL;
+
+	mutex_lock(&tracer.mutex);
+	if (timestamp)
+		tracer.flags |= TRACER_TIMESTAMP;
+	else
+		tracer.flags &= ~TRACER_TIMESTAMP;
+	mutex_unlock(&tracer.mutex);
+
+	return n;
+}
+
+static struct kobj_attribute trace_timestamp_attr =
+	__ATTR(trace_timestamp, 0644,
+		trace_timestamp_show, trace_timestamp_store);
+
 static ssize_t trace_range_show(struct kobject *kobj,
 				  struct kobj_attribute *attr,
 				  char *buf)
@@ -726,6 +759,7 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 	int new_count;
 	u32 etmccr;
 	u32 etmidr;
+	u32 etmccer = 0;
 	u8 etm_version = 0;
 
 	mutex_lock(&t->mutex);
@@ -766,6 +800,8 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 	if (etmccr & ETMCCR_ETMIDR_PRESENT) {
 		etmidr = etm_readl(t, t->etm_regs_count, ETMR_ID);
 		etm_version = ETMIDR_VERSION(etmidr);
+		if (etm_version >= ETMIDR_VERSION_3_1)
+			etmccer = etm_readl(t, t->etm_regs_count, ETMR_CCE);
 	}
 	etm_writel(t, t->etm_regs_count, 0x441, ETMR_CTRL);
 	etm_writel(t, t->etm_regs_count, new_count, ETMR_TRACEIDR);
@@ -785,6 +821,14 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 	if (ret)
 		dev_dbg(&dev->dev, "Failed to create trace_mode in sysfs\n");
 
+	if (etmccer & ETMCCER_TIMESTAMPING_IMPLEMENTED) {
+		ret = sysfs_create_file(&dev->dev.kobj,
+					&trace_timestamp_attr.attr);
+		if (ret)
+			dev_dbg(&dev->dev,
+				"Failed to create trace_timestamp in sysfs\n");
+	}
+
 	ret = sysfs_create_file(&dev->dev.kobj, &trace_range_attr.attr);
 	if (ret)
 		dev_dbg(&dev->dev, "Failed to create trace_range in sysfs\n");
-- 
1.7.9.5

