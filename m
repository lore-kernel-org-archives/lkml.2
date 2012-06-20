Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab2FTWsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:48:24 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47062 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab2FTWsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:48:11 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 14/15] ARM: etm: Add sysfs entry to disable branch_output flag
Date: Wed, 20 Jun 2012 18:47:46 -0400
Message-Id: <1340232467-6023-15-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062022-4242-0000-0000-0000020E4161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Add sysfs entry to disable branch_output flag

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/include/asm/hardware/coresight.h |    5 ++--
 arch/arm/kernel/etm.c                     |   41 ++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/hardware/coresight.h b/arch/arm/include/asm/hardware/coresight.h
index 47b7696..727ba0f 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -19,11 +19,13 @@
 #define TRACER_CYCLE_ACC_BIT	2
 #define TRACER_TRACE_DATA_BIT	3
 #define TRACER_TIMESTAMP_BIT	4
+#define TRACER_BRANCHOUTPUT_BIT	5
 #define TRACER_ACCESSED		BIT(TRACER_ACCESSED_BIT)
 #define TRACER_RUNNING		BIT(TRACER_RUNNING_BIT)
 #define TRACER_CYCLE_ACC	BIT(TRACER_CYCLE_ACC_BIT)
 #define TRACER_TRACE_DATA	BIT(TRACER_TRACE_DATA_BIT)
 #define TRACER_TIMESTAMP	BIT(TRACER_TIMESTAMP_BIT)
+#define TRACER_BRANCHOUTPUT	BIT(TRACER_BRANCHOUTPUT_BIT)
 
 #define TRACER_TIMEOUT 10000
 
@@ -126,8 +128,7 @@
 #define ETMR_VIEWDATACTRL3	0x3c
 #define ETMVDC3_EXCLONLY	BIT(16)
 
-#define ETMCTRL_OPTS		(ETMCTRL_DO_CPRT | \
-				ETMCTRL_BRANCH_OUTPUT)
+#define ETMCTRL_OPTS		(ETMCTRL_DO_CPRT)
 
 #define ETMR_ID			0x1e4
 #define ETMIDR_VERSION(x)	(((x) >> 4) & 0xff)
diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index f00a3f39..8e84d5c 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -115,6 +115,9 @@ static int trace_start_etm(struct tracectx *t, int id)
 	if (t->flags & TRACER_CYCLE_ACC)
 		v |= ETMCTRL_CYCLEACCURATE;
 
+	if (t->flags & TRACER_BRANCHOUTPUT)
+		v |= ETMCTRL_BRANCH_OUTPUT;
+
 	if (t->flags & TRACER_TRACE_DATA)
 		v |= ETMCTRL_DATA_DO_ADDR;
 
@@ -683,6 +686,36 @@ static struct kobj_attribute trace_contextid_size_attr =
 	__ATTR(trace_contextid_size, 0644,
 		trace_contextid_size_show, trace_contextid_size_store);
 
+static ssize_t trace_branch_output_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					char *buf)
+{
+	return sprintf(buf, "%d\n", !!(tracer.flags & TRACER_BRANCHOUTPUT));
+}
+
+static ssize_t trace_branch_output_store(struct kobject *kobj,
+					 struct kobj_attribute *attr,
+					 const char *buf, size_t n)
+{
+	unsigned int branch_output;
+
+	if (sscanf(buf, "%u", &branch_output) != 1)
+		return -EINVAL;
+
+	mutex_lock(&tracer.mutex);
+	if (branch_output)
+		tracer.flags |= TRACER_BRANCHOUTPUT;
+	else
+		tracer.flags &= ~TRACER_BRANCHOUTPUT;
+	mutex_unlock(&tracer.mutex);
+
+	return n;
+}
+
+static struct kobj_attribute trace_branch_output_attr =
+	__ATTR(trace_branch_output, 0644,
+		trace_branch_output_show, trace_branch_output_store);
+
 static ssize_t trace_timestamp_show(struct kobject *kobj,
 				  struct kobj_attribute *attr,
 				  char *buf)
@@ -820,7 +853,7 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 
 	amba_set_drvdata(dev, t->etm_regs[t->etm_regs_count]);
 
-	t->flags = TRACER_CYCLE_ACC | TRACER_TRACE_DATA;
+	t->flags = TRACER_CYCLE_ACC | TRACER_TRACE_DATA | TRACER_BRANCHOUTPUT;
 	t->etm_portsz = 1;
 	t->etm_contextid_size = 3;
 
@@ -861,6 +894,12 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 		dev_dbg(&dev->dev,
 			"Failed to create trace_contextid_size in sysfs\n");
 
+	ret = sysfs_create_file(&dev->dev.kobj,
+				&trace_branch_output_attr.attr);
+	if (ret)
+		dev_dbg(&dev->dev,
+			"Failed to create trace_branch_output in sysfs\n");
+
 	if (etmccer & ETMCCER_TIMESTAMPING_IMPLEMENTED) {
 		ret = sysfs_create_file(&dev->dev.kobj,
 					&trace_timestamp_attr.attr);
-- 
1.7.9.5

