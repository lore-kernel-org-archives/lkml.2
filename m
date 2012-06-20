Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340Ab2FTWsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:48:45 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41456 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab2FTWsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:48:40 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 15/15] ARM: etm: Add sysfs entry to enable return stack if supported
Date: Wed, 20 Jun 2012 18:47:47 -0400
Message-Id: <1340232467-6023-16-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062022-7282-0000-0000-00000A239097
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Add sysfs entry to enable return stack if supported

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/include/asm/hardware/coresight.h |    4 +++
 arch/arm/kernel/etm.c                     |   51 +++++++++++++++++++++++++++--
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/hardware/coresight.h b/arch/arm/include/asm/hardware/coresight.h
index 727ba0f..dcf74d7 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -20,12 +20,14 @@
 #define TRACER_TRACE_DATA_BIT	3
 #define TRACER_TIMESTAMP_BIT	4
 #define TRACER_BRANCHOUTPUT_BIT	5
+#define TRACER_RETURN_STACK_BIT	6
 #define TRACER_ACCESSED		BIT(TRACER_ACCESSED_BIT)
 #define TRACER_RUNNING		BIT(TRACER_RUNNING_BIT)
 #define TRACER_CYCLE_ACC	BIT(TRACER_CYCLE_ACC_BIT)
 #define TRACER_TRACE_DATA	BIT(TRACER_TRACE_DATA_BIT)
 #define TRACER_TIMESTAMP	BIT(TRACER_TIMESTAMP_BIT)
 #define TRACER_BRANCHOUTPUT	BIT(TRACER_BRANCHOUTPUT_BIT)
+#define TRACER_RETURN_STACK	BIT(TRACER_RETURN_STACK_BIT)
 
 #define TRACER_TIMEOUT 10000
 
@@ -62,6 +64,7 @@
 #define ETMCTRL_BRANCH_OUTPUT	(1 << 8)
 #define ETMCTRL_CYCLEACCURATE	(1 << 12)
 #define ETMCTRL_TIMESTAMP_EN	(1 << 28)
+#define ETMCTRL_RETURN_STACK_EN	(1 << 29)
 
 /* ETM configuration code register */
 #define ETMR_CONFCODE		(0x04)
@@ -136,6 +139,7 @@
 #define ETMIDR_VERSION_PFT_1_0	0x30
 
 #define ETMR_CCE		0x1e8
+#define ETMCCER_RETURN_STACK_IMPLEMENTED	BIT(23)
 #define ETMCCER_TIMESTAMPING_IMPLEMENTED	BIT(22)
 
 #define ETMR_TRACEIDR		0x200
diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8e84d5c..c5fb6c9 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -124,6 +124,9 @@ static int trace_start_etm(struct tracectx *t, int id)
 	if (t->flags & TRACER_TIMESTAMP)
 		v |= ETMCTRL_TIMESTAMP_EN;
 
+	if (t->flags & TRACER_RETURN_STACK)
+		v |= ETMCTRL_RETURN_STACK_EN;
+
 	etm_unlock(t, id);
 
 	etm_writel(t, id, v, ETMR_CTRL);
@@ -703,10 +706,13 @@ static ssize_t trace_branch_output_store(struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&tracer.mutex);
-	if (branch_output)
+	if (branch_output) {
 		tracer.flags |= TRACER_BRANCHOUTPUT;
-	else
+		/* Branch broadcasting is incompatible with the return stack */
+		tracer.flags &= ~TRACER_RETURN_STACK;
+	} else {
 		tracer.flags &= ~TRACER_BRANCHOUTPUT;
+	}
 	mutex_unlock(&tracer.mutex);
 
 	return n;
@@ -716,6 +722,39 @@ static struct kobj_attribute trace_branch_output_attr =
 	__ATTR(trace_branch_output, 0644,
 		trace_branch_output_show, trace_branch_output_store);
 
+static ssize_t trace_return_stack_show(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  char *buf)
+{
+	return sprintf(buf, "%d\n", !!(tracer.flags & TRACER_RETURN_STACK));
+}
+
+static ssize_t trace_return_stack_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t n)
+{
+	unsigned int return_stack;
+
+	if (sscanf(buf, "%u", &return_stack) != 1)
+		return -EINVAL;
+
+	mutex_lock(&tracer.mutex);
+	if (return_stack) {
+		tracer.flags |= TRACER_RETURN_STACK;
+		/* Return stack is incompatible with branch broadcasting */
+		tracer.flags &= ~TRACER_BRANCHOUTPUT;
+	} else {
+		tracer.flags &= ~TRACER_RETURN_STACK;
+	}
+	mutex_unlock(&tracer.mutex);
+
+	return n;
+}
+
+static struct kobj_attribute trace_return_stack_attr =
+	__ATTR(trace_return_stack, 0644,
+		trace_return_stack_show, trace_return_stack_store);
+
 static ssize_t trace_timestamp_show(struct kobject *kobj,
 				  struct kobj_attribute *attr,
 				  char *buf)
@@ -900,6 +939,14 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 		dev_dbg(&dev->dev,
 			"Failed to create trace_branch_output in sysfs\n");
 
+	if (etmccer & ETMCCER_RETURN_STACK_IMPLEMENTED) {
+		ret = sysfs_create_file(&dev->dev.kobj,
+					&trace_return_stack_attr.attr);
+		if (ret)
+			dev_dbg(&dev->dev,
+			      "Failed to create trace_return_stack in sysfs\n");
+	}
+
 	if (etmccer & ETMCCER_TIMESTAMPING_IMPLEMENTED) {
 		ret = sysfs_create_file(&dev->dev.kobj,
 					&trace_timestamp_attr.attr);
-- 
1.7.9.5

