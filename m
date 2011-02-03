Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1BCCzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:55:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56042 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab1BCCzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:55:39 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Shishkin <virtuoso@slind.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ARM: etm: Allow range selection
Date: Wed,  2 Feb 2011 18:54:22 -0800
Message-Id: <1296701663-12168-4-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1296701663-12168-1-git-send-email-arve@android.com>
References: <1296701663-12168-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace kernel text segment by default as before, allow tracing of other
ranges by writing a range to /sys/devices/etm/trace_range, or to trace
everything by writing 0 0.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 arch/arm/kernel/etm.c |   48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 7652e9f..6ff1004 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -40,12 +40,17 @@ struct tracectx {
 	unsigned long	flags;
 	int		ncmppairs;
 	int		etm_portsz;
+	unsigned long	range_start;
+	unsigned long	range_end;
 	struct device	*dev;
 	struct clk	*emu_clk;
 	struct mutex	mutex;
 };
 
-static struct tracectx tracer;
+static struct tracectx tracer = {
+	.range_start = (unsigned long)_stext,
+	.range_end = (unsigned long)_etext,
+};
 
 static inline bool trace_isrunning(struct tracectx *t)
 {
@@ -114,8 +119,12 @@ static int trace_start(struct tracectx *t)
 		return -EFAULT;
 	}
 
-	etm_setup_address_range(t, 1, (unsigned long)_stext,
-			(unsigned long)_etext, 0, 0);
+	if (t->range_start || t->range_end)
+		etm_setup_address_range(t, 1,
+					t->range_start, t->range_end, 0, 0);
+	else
+		etm_writel(t, ETMTE_INCLEXCL, ETMR_TRACEENCTRL);
+
 	etm_writel(t, 0, ETMR_TRACEENCTRL2);
 	etm_writel(t, 0, ETMR_TRACESSCTRL);
 	etm_writel(t, 0x6f, ETMR_TRACEENEVT);
@@ -532,6 +541,35 @@ static ssize_t trace_mode_store(struct kobject *kobj,
 static struct kobj_attribute trace_mode_attr =
 	__ATTR(trace_mode, 0644, trace_mode_show, trace_mode_store);
 
+static ssize_t trace_range_show(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  char *buf)
+{
+	return sprintf(buf, "%08lx %08lx\n",
+			tracer.range_start, tracer.range_end);
+}
+
+static ssize_t trace_range_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t n)
+{
+	unsigned long range_start, range_end;
+
+	if (sscanf(buf, "%lx %lx", &range_start, &range_end) != 2)
+		return -EINVAL;
+
+	mutex_lock(&tracer.mutex);
+	tracer.range_start = range_start;
+	tracer.range_end = range_end;
+	mutex_unlock(&tracer.mutex);
+
+	return n;
+}
+
+
+static struct kobj_attribute trace_range_attr =
+	__ATTR(trace_range, 0644, trace_range_show, trace_range_store);
+
 static int __init etm_probe(struct amba_device *dev, struct amba_id *id)
 {
 	struct tracectx *t = &tracer;
@@ -583,6 +621,10 @@ static int __init etm_probe(struct amba_device *dev, struct amba_id *id)
 	if (ret)
 		dev_dbg(&dev->dev, "Failed to create trace_mode in sysfs\n");
 
+	ret = sysfs_create_file(&dev->dev.kobj, &trace_range_attr.attr);
+	if (ret)
+		dev_dbg(&dev->dev, "Failed to create trace_range in sysfs\n");
+
 	dev_dbg(t->dev, "ETM AMBA driver initialized.\n");
 
 out:
-- 
1.7.3.1

