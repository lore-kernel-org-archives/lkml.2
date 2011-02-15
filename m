Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab1BOGNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:13:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46533 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab1BOGL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:11:57 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-omap@vger.kernel.org,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Shishkin <virtuoso@slind.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] ARM: etm: Configure data tracing
Date: Mon, 14 Feb 2011 22:11:13 -0800
Message-Id: <1297750276-12475-5-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1296701663-12168-1-git-send-email-arve@android.com>
References: <1296701663-12168-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old code enabled data tracing, but did not configure the
range. We now configure it to trace all data addresses by default,
and add a trace_data_range attribute to change the range or disable
data tracing.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 arch/arm/include/asm/hardware/coresight.h |   10 +++-
 arch/arm/kernel/etm.c                     |   77 +++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/hardware/coresight.h b/arch/arm/include/asm/hardware/coresight.h
index 7ecd793..6ea507f 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -17,9 +17,11 @@
 #define TRACER_ACCESSED_BIT	0
 #define TRACER_RUNNING_BIT	1
 #define TRACER_CYCLE_ACC_BIT	2
+#define TRACER_TRACE_DATA_BIT	3
 #define TRACER_ACCESSED		BIT(TRACER_ACCESSED_BIT)
 #define TRACER_RUNNING		BIT(TRACER_RUNNING_BIT)
 #define TRACER_CYCLE_ACC	BIT(TRACER_CYCLE_ACC_BIT)
+#define TRACER_TRACE_DATA	BIT(TRACER_TRACE_DATA_BIT)
 
 #define TRACER_TIMEOUT 10000
 
@@ -113,8 +115,14 @@
 #define ETMR_TRACEENCTRL	0x24
 #define ETMTE_INCLEXCL		BIT(24)
 #define ETMR_TRACEENEVT		0x20
+
+#define ETMR_VIEWDATAEVT	0x30
+#define ETMR_VIEWDATACTRL1	0x34
+#define ETMR_VIEWDATACTRL2	0x38
+#define ETMR_VIEWDATACTRL3	0x3c
+#define ETMVDC3_EXCLONLY	BIT(16)
+
 #define ETMCTRL_OPTS		(ETMCTRL_DO_CPRT | \
-				ETMCTRL_DATA_DO_ADDR | \
 				ETMCTRL_BRANCH_OUTPUT | \
 				ETMCTRL_DO_CONTEXTID)
 
diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8a1c422..96b1abb 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -42,6 +42,8 @@ struct tracectx {
 	int		etm_portsz;
 	unsigned long	range_start;
 	unsigned long	range_end;
+	unsigned long	data_range_start;
+	unsigned long	data_range_end;
 	struct device	*dev;
 	struct clk	*emu_clk;
 	struct mutex	mutex;
@@ -83,8 +85,15 @@ static int etm_setup_address_range(struct tracectx *t, int n,
 	etm_writel(t, flags, ETMR_COMP_ACC_TYPE(n * 2 + 1));
 	etm_writel(t, end, ETMR_COMP_VAL(n * 2 + 1));
 
-	flags = exclude ? ETMTE_INCLEXCL : 0;
-	etm_writel(t, flags | (1 << n), ETMR_TRACEENCTRL);
+	if (data) {
+		flags = exclude ? ETMVDC3_EXCLONLY : 0;
+		if (exclude)
+			n += 8;
+		etm_writel(t, flags | BIT(n), ETMR_VIEWDATACTRL3);
+	} else {
+		flags = exclude ? ETMTE_INCLEXCL : 0;
+		etm_writel(t, flags | (1 << n), ETMR_TRACEENCTRL);
+	}
 
 	return 0;
 }
@@ -108,6 +117,9 @@ static int trace_start(struct tracectx *t)
 	if (t->flags & TRACER_CYCLE_ACC)
 		v |= ETMCTRL_CYCLEACCURATE;
 
+	if (t->flags & TRACER_TRACE_DATA)
+		v |= ETMCTRL_DATA_DO_ADDR;
+
 	etm_unlock(t);
 
 	etm_writel(t, v, ETMR_CTRL);
@@ -130,6 +142,17 @@ static int trace_start(struct tracectx *t)
 	etm_writel(t, 0, ETMR_TRACESSCTRL);
 	etm_writel(t, 0x6f, ETMR_TRACEENEVT);
 
+	etm_writel(t, 0, ETMR_VIEWDATACTRL1);
+	etm_writel(t, 0, ETMR_VIEWDATACTRL2);
+
+	if (t->data_range_start || t->data_range_end)
+		etm_setup_address_range(t, 2, t->data_range_start,
+					t->data_range_end, 0, 1);
+	else
+		etm_writel(t, ETMVDC3_EXCLONLY, ETMR_VIEWDATACTRL3);
+
+	etm_writel(t, 0x6f, ETMR_VIEWDATAEVT);
+
 	v &= ~ETMCTRL_PROGRAM;
 	v |= ETMCTRL_PORTSEL;
 
@@ -563,6 +586,48 @@ static ssize_t trace_range_store(struct kobject *kobj,
 static struct kobj_attribute trace_range_attr =
 	__ATTR(trace_range, 0644, trace_range_show, trace_range_store);
 
+static ssize_t trace_data_range_show(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  char *buf)
+{
+	unsigned long range_start;
+	u64 range_end;
+	mutex_lock(&tracer.mutex);
+	range_start = tracer.data_range_start;
+	range_end = tracer.data_range_end;
+	if (!range_end && (tracer.flags & TRACER_TRACE_DATA))
+		range_end = 0x100000000ULL;
+	mutex_unlock(&tracer.mutex);
+	return sprintf(buf, "%08lx %08llx\n", range_start, range_end);
+}
+
+static ssize_t trace_data_range_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t n)
+{
+	unsigned long range_start;
+	u64 range_end;
+
+	if (sscanf(buf, "%lx %llx", &range_start, &range_end) != 2)
+		return -EINVAL;
+
+	mutex_lock(&tracer.mutex);
+	tracer.data_range_start = range_start;
+	tracer.data_range_end = (unsigned long)range_end;
+	if (range_end)
+		tracer.flags |= TRACER_TRACE_DATA;
+	else
+		tracer.flags &= ~TRACER_TRACE_DATA;
+	mutex_unlock(&tracer.mutex);
+
+	return n;
+}
+
+
+static struct kobj_attribute trace_data_range_attr =
+	__ATTR(trace_data_range, 0644,
+		trace_data_range_show, trace_data_range_store);
+
 static int __init etm_probe(struct amba_device *dev, struct amba_id *id)
 {
 	struct tracectx *t = &tracer;
@@ -588,7 +653,7 @@ static int __init etm_probe(struct amba_device *dev, struct amba_id *id)
 
 	mutex_init(&t->mutex);
 	t->dev = &dev->dev;
-	t->flags = TRACER_CYCLE_ACC;
+	t->flags = TRACER_CYCLE_ACC | TRACER_TRACE_DATA;
 	t->etm_portsz = 1;
 
 	etm_unlock(t);
@@ -618,6 +683,11 @@ static int __init etm_probe(struct amba_device *dev, struct amba_id *id)
 	if (ret)
 		dev_dbg(&dev->dev, "Failed to create trace_range in sysfs\n");
 
+	ret = sysfs_create_file(&dev->dev.kobj, &trace_data_range_attr.attr);
+	if (ret)
+		dev_dbg(&dev->dev,
+			"Failed to create trace_data_range in sysfs\n");
+
 	dev_dbg(t->dev, "ETM AMBA driver initialized.\n");
 
 out:
@@ -648,6 +718,7 @@ static int etm_remove(struct amba_device *dev)
 	sysfs_remove_file(&dev->dev.kobj, &trace_info_attr.attr);
 	sysfs_remove_file(&dev->dev.kobj, &trace_mode_attr.attr);
 	sysfs_remove_file(&dev->dev.kobj, &trace_range_attr.attr);
+	sysfs_remove_file(&dev->dev.kobj, &trace_data_range_attr.attr);
 
 	return 0;
 }
-- 
1.7.3.1

