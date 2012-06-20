Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363Ab2FTWt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:49:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56248 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439Ab2FTWtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:49:53 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 13/15] ARM: etm: Add sysfs entry to set context-id-size
Date: Wed, 20 Jun 2012 18:47:45 -0400
Message-Id: <1340232467-6023-14-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062022-5518-0000-0000-0000055C61E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Add sysfs entry to set context-id-size

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/include/asm/hardware/coresight.h |    5 ++--
 arch/arm/kernel/etm.c                     |   40 +++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/hardware/coresight.h b/arch/arm/include/asm/hardware/coresight.h
index 42059d3..47b7696 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -47,7 +47,7 @@
 #define ETMCTRL_POWERDOWN	1
 #define ETMCTRL_PROGRAM		(1 << 10)
 #define ETMCTRL_PORTSEL		(1 << 11)
-#define ETMCTRL_DO_CONTEXTID	(3 << 14)
+#define ETMCTRL_CONTEXTIDSIZE(x) (((x) & 3) << 14)
 #define ETMCTRL_PORTMASK1	(7 << 4)
 #define ETMCTRL_PORTMASK2	(1 << 21)
 #define ETMCTRL_PORTMASK	(ETMCTRL_PORTMASK1 | ETMCTRL_PORTMASK2)
@@ -127,8 +127,7 @@
 #define ETMVDC3_EXCLONLY	BIT(16)
 
 #define ETMCTRL_OPTS		(ETMCTRL_DO_CPRT | \
-				ETMCTRL_BRANCH_OUTPUT | \
-				ETMCTRL_DO_CONTEXTID)
+				ETMCTRL_BRANCH_OUTPUT)
 
 #define ETMR_ID			0x1e4
 #define ETMIDR_VERSION(x)	(((x) >> 4) & 0xff)
diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 460a7d8..f00a3f39 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -43,6 +43,7 @@ struct tracectx {
 	unsigned long	flags;
 	int		ncmppairs;
 	int		etm_portsz;
+	int		etm_contextid_size;
 	u32		etb_fc;
 	unsigned long	range_start;
 	unsigned long	range_end;
@@ -109,6 +110,7 @@ static int trace_start_etm(struct tracectx *t, int id)
 	unsigned long timeout = TRACER_TIMEOUT;
 
 	v = ETMCTRL_OPTS | ETMCTRL_PROGRAM | ETMCTRL_PORTSIZE(t->etm_portsz);
+	v |= ETMCTRL_CONTEXTIDSIZE(t->etm_contextid_size);
 
 	if (t->flags & TRACER_CYCLE_ACC)
 		v |= ETMCTRL_CYCLEACCURATE;
@@ -650,6 +652,37 @@ static ssize_t trace_mode_store(struct kobject *kobj,
 static struct kobj_attribute trace_mode_attr =
 	__ATTR(trace_mode, 0644, trace_mode_show, trace_mode_store);
 
+static ssize_t trace_contextid_size_show(struct kobject *kobj,
+					 struct kobj_attribute *attr,
+					 char *buf)
+{
+	/* 0: No context id tracing, 1: One byte, 2: Two bytes, 3: Four bytes */
+	return sprintf(buf, "%d\n", (1 << tracer.etm_contextid_size) >> 1);
+}
+
+static ssize_t trace_contextid_size_store(struct kobject *kobj,
+					  struct kobj_attribute *attr,
+					  const char *buf, size_t n)
+{
+	unsigned int contextid_size;
+
+	if (sscanf(buf, "%u", &contextid_size) != 1)
+		return -EINVAL;
+
+	if (contextid_size == 3 || contextid_size > 4)
+		return -EINVAL;
+
+	mutex_lock(&tracer.mutex);
+	tracer.etm_contextid_size = fls(contextid_size);
+	mutex_unlock(&tracer.mutex);
+
+	return n;
+}
+
+static struct kobj_attribute trace_contextid_size_attr =
+	__ATTR(trace_contextid_size, 0644,
+		trace_contextid_size_show, trace_contextid_size_store);
+
 static ssize_t trace_timestamp_show(struct kobject *kobj,
 				  struct kobj_attribute *attr,
 				  char *buf)
@@ -789,6 +822,7 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 
 	t->flags = TRACER_CYCLE_ACC | TRACER_TRACE_DATA;
 	t->etm_portsz = 1;
+	t->etm_contextid_size = 3;
 
 	etm_unlock(t, t->etm_regs_count);
 	(void)etm_readl(t, t->etm_regs_count, ETMMR_PDSR);
@@ -821,6 +855,12 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 	if (ret)
 		dev_dbg(&dev->dev, "Failed to create trace_mode in sysfs\n");
 
+	ret = sysfs_create_file(&dev->dev.kobj,
+				&trace_contextid_size_attr.attr);
+	if (ret)
+		dev_dbg(&dev->dev,
+			"Failed to create trace_contextid_size in sysfs\n");
+
 	if (etmccer & ETMCCER_TIMESTAMPING_IMPLEMENTED) {
 		ret = sysfs_create_file(&dev->dev.kobj,
 					&trace_timestamp_attr.attr);
-- 
1.7.9.5

