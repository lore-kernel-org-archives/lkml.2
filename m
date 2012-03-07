Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab2CGFCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:02:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:25078 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2CGFCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:02:05 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-c6-4f56ebcb7efa
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Jones <mavej@redhat.com>
Cc: linux-pm@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3] PM / QoS: Introduce new classes: DMA-Throughput and
 DVFS-Latency
Date: Wed, 07 Mar 2012 14:02:01 +0900
Message-id: <1331096521-26026-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <13197479.540821330911965933.JavaMail.weblogic@epv6ml06>
References: <13197479.540821330911965933.JavaMail.weblogic@epv6ml06>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. CPU_DMA_THROUGHPUT

This might look simliar to CPU_DMA_LATENCY. However, there are H/W
blocks that creates QoS requirement based on DMA throughput, not
latency, while their (those QoS requester H/W blocks) services are
short-term bursts that cannot be effectively responsed by DVFS
mechanisms (CPUFreq and Devfreq).

In the Exynos4412 systems that are being tested, such H/W blocks include
MFC (multi-function codec)'s decoding and enconding features, TV-out
(including HDMI), and Cameras. When the display is operated at 60Hz,
each chunk of task should be done within 16ms and the workload on DMA is
not well spread and fluctuates between frames; some frame requires more
and some do not and within a frame, the workload also fluctuates
heavily and the tasks within a frame are usually not parallelized; they
are processed through specific H/W blocks, not CPU cores. They often
have PPMU capabilities; however, they need to be polled very frequently
in order to let DVFS mechanisms react properly. (less than 5ms).

For such specific tasks, allowing them to request QoS requirements seems
adequete because DVFS mechanisms (as long as the polling rate is 5ms or
longer) cannot follow up with them. Besides, the device drivers know
when to request and cancel QoS exactly.

2. DVFS_LATENCY

Both CPUFreq and Devfreq have response latency to a sudden workload
increase. With near-100% (e.g., 95%) up-threshold, the average response
latency is approximately 1.5 x polling-rate.

A specific polling rate (e.g., 100ms) may generally fit for its system;
however, there could be exceptions for that. For example,
- When a user input suddenly starts: typing, clicking, moving cursors, and
  such, the user might need the full performance immediately. However,
  we do not know whether the full performance is actually needed or not
  until we calculate the utilization; thus, we need to calculate it
  faster with user inputs or any similar events. Specifying QoS on CPU
  processing power or Memory bandwidth at every user input is an
  overkill because there are many cases where such speed-up isn't
  necessary.
- When a device driver needs a faster performance response from DVFS
  mechanism. This could be addressed by simply putting QoS requests.
  However, such QoS requests may keep the system running fast
  unnecessary in some cases, especially if a) the device's resource
  usage bursts with some duration (e.g., 100ms-long bursts) and
  b) the driver doesn't know when such burst come. MMC/WiFi often had
  such behaviors although there are possibilities that part (b) might
  be addressed with further efforts.

The cases shown above can be tackled with putting QoS requests on the
response time or latency of DVFS mechanism, which is directly related to
its polling interval (if the DVFS mechanism is polling based).

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

--
Changes from v2
- Rebased on the recent PM QoS patches, resolving the merge conflict.

Changes from RFC(v1)
- Added omitted part (registering new classes)
---
 include/linux/pm_qos.h |    4 ++++
 kernel/power/qos.c     |   31 ++++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index c8a541e..0ee7caa 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -14,6 +14,8 @@ enum {
 	PM_QOS_CPU_DMA_LATENCY,
 	PM_QOS_NETWORK_LATENCY,
 	PM_QOS_NETWORK_THROUGHPUT,
+	PM_QOS_CPU_DMA_THROUGHPUT,
+	PM_QOS_DVFS_RESPONSE_LATENCY,
 
 	/* insert new class ID */
 	PM_QOS_NUM_CLASSES,
@@ -24,6 +26,8 @@ enum {
 #define PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
 #define PM_QOS_NETWORK_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
 #define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE	0
+#define PM_QOS_CPU_DMA_THROUGHPUT_DEFAULT_VALUE	0
+#define PM_QOS_DVFS_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
 #define PM_QOS_DEV_LAT_DEFAULT_VALUE		0
 
 struct pm_qos_request {
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index d6d6dbd..3e122db 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -101,11 +101,40 @@ static struct pm_qos_object network_throughput_pm_qos = {
 };
 
 
+static BLOCKING_NOTIFIER_HEAD(cpu_dma_throughput_notifier);
+static struct pm_qos_constraints cpu_dma_tput_constraints = {
+	.list = PLIST_HEAD_INIT(cpu_dma_tput_constraints.list),
+	.target_value = PM_QOS_CPU_DMA_THROUGHPUT_DEFAULT_VALUE,
+	.default_value = PM_QOS_CPU_DMA_THROUGHPUT_DEFAULT_VALUE,
+	.type = PM_QOS_MAX,
+	.notifiers = &cpu_dma_throughput_notifier,
+};
+static struct pm_qos_object cpu_dma_throughput_pm_qos = {
+	.constraints = &cpu_dma_tput_constraints,
+	.name = "cpu_dma_throughput",
+};
+
+
+static BLOCKING_NOTIFIER_HEAD(dvfs_lat_notifier);
+static struct pm_qos_constraints dvfs_lat_constraints = {
+	.list = PLIST_HEAD_INIT(dvfs_lat_constraints.list),
+	.target_value = PM_QOS_DVFS_LAT_DEFAULT_VALUE,
+	.default_value = PM_QOS_DVFS_LAT_DEFAULT_VALUE,
+	.type = PM_QOS_MIN,
+	.notifiers = &dvfs_lat_notifier,
+};
+static struct pm_qos_object dvfs_lat_pm_qos = {
+	.constraints = &dvfs_lat_constraints,
+	.name = "dvfs_latency",
+};
+
 static struct pm_qos_object *pm_qos_array[] = {
 	&null_pm_qos,
 	&cpu_dma_pm_qos,
 	&network_lat_pm_qos,
-	&network_throughput_pm_qos
+	&network_throughput_pm_qos,
+	&cpu_dma_throughput_pm_qos,
+	&dvfs_lat_pm_qos,
 };
 
 static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
-- 
1.7.4.1

