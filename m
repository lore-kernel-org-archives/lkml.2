Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2HHIPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:15:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28174 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab2HHIPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:15:09 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-c9-5022200b6e5a
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] PM QoS: Add a metric : Bus Throughput.
Date: Wed, 08 Aug 2012 17:14:51 +0900
Message-id: <1344413691-808-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJMWRmVeSWpSXmKPExsVy+t9jAV1uBaUAg94ma4vLu+awWXzuPcLo
	wOTxeZNcAGMUl01Kak5mWWqRvl0CV8btef4F+wUqzm16zdrA2MzXxcjJISFgInHk4n5WCFtM
	4sK99WxdjFwcQgKLGCXOLbjLAuG0MEks3NPEBFLFJqAj8X/fTXYQW0TASuL0/w5mkCJmgV2M
	EtNOrAdLCAuYS3w/+gWsgUVAVWLLh7NgcV4BN4lvT96wQ6xTkFhw7y3bBEbuBYwMqxhFUwuS
	C4qT0nON9IoTc4tL89L1kvNzNzGCvflMegfjqgaLQ4wCHIxKPLybUhUDhFgTy4orcw8xSnAw
	K4nw7jkIFOJNSaysSi3Kjy8qzUktPsQozcGiJM5r4v3VX0ggPbEkNTs1tSC1CCbLxMEp1cBo
	lc4k/LpClWuHyObDX23++HYfMu5me/L5X8GZl45s/v4uHdNcuT89XRag8PV8Qlqkx499Dkvv
	XmO2unye7WbGD4O8Yqb8jNeLJ+UdPm21uvbvXjHvrgB2AdFXnNOTZ32qF5bdePPSp+DT7x3n
	8CQb3PoYYNfWEcNgfFQrOcmuUlL9I++9iZxKLMUZiYZazEXFiQD8VveQ4gEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bus throughput metric is added to PM QoS in order to control the
frequency of memory interfaces and busses with PM QoS.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/pm_qos.h |    2 ++
 kernel/power/qos.c     |   15 ++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index 233149c..6db4939 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -15,6 +15,7 @@ enum {
 	PM_QOS_CPU_DMA_LATENCY,
 	PM_QOS_NETWORK_LATENCY,
 	PM_QOS_NETWORK_THROUGHPUT,
+	PM_QOS_BUS_DMA_THROUGHPUT,
 
 	/* insert new class ID */
 	PM_QOS_NUM_CLASSES,
@@ -26,6 +27,7 @@ enum {
 #define PM_QOS_NETWORK_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
 #define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE	0
 #define PM_QOS_DEV_LAT_DEFAULT_VALUE		0
+#define	PM_QOS_BUS_DMA_THROUGHPUT_DEFAULT_VALUE	0
 
 struct pm_qos_request {
 	struct plist_node node;
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 6a031e6..75322cc 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -100,12 +100,25 @@ static struct pm_qos_object network_throughput_pm_qos = {
 	.name = "network_throughput",
 };
 
+static BLOCKING_NOTIFIER_HEAD(bus_dma_throughput_notifier);
+static struct pm_qos_constraints bus_dma_tput_constraints = {
+	.list = PLIST_HEAD_INIT(bus_dma_tput_constraints.list),
+	.target_value = PM_QOS_BUS_DMA_THROUGHPUT_DEFAULT_VALUE,
+	.default_value = PM_QOS_BUS_DMA_THROUGHPUT_DEFAULT_VALUE,
+	.type = PM_QOS_MAX,
+	.notifiers = &bus_dma_throughput_notifier,
+};
+static struct pm_qos_object bus_dma_throughput_pm_qos = {
+	.constraints = &bus_dma_tput_constraints,
+	.name = "bus_dma_throughput",
+};
 
 static struct pm_qos_object *pm_qos_array[] = {
 	&null_pm_qos,
 	&cpu_dma_pm_qos,
 	&network_lat_pm_qos,
-	&network_throughput_pm_qos
+	&network_throughput_pm_qos,
+	&bus_dma_throughput_pm_qos,
 };
 
 static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
-- 
1.7.4.1

