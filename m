Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1JBQs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 12:48:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57295 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1JBQsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 12:48:52 -0400
Date: Sun, 2 Oct 2011 09:48:49 -0700
From: mark gross <markgross@thegnar.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: [markgross@thengar.org: Re: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111002164849.GE14312@mgross-G62>
Reply-To: markgross@thegnar.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding to bigger group for discussion.

----- Forwarded message from mark gross <markgross@thengar.org> -----

Subject: Re: [RFC] wake up notifications and suspend blocking (aka more wakelock stuff)
Date: Tue, 20 Sep 2011 13:36:15 -0700
From: mark gross <markgross@thengar.org>
To: mark gross <markgross@thegnar.org>
Reply-To: markgross@thegnar.org
Cc: linux-pm@lists.linux-foundation.org, arve@android.com, Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org, farrowg@sg.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>


>From a2615c59cb3b7632cf22e2c25a10b401e2151bbf Mon Sep 17 00:00:00 2001
From: mark gross <mark97229@gmail.com>
Date: Mon, 19 Sep 2011 09:48:31 -0700
Subject: [PATCH 2/2] implement suspend bock pm_qos class such that whenever the
 pm_qos_request is > 0 suspend to ram is blocked.

This is one of the 2 features the wakelock design attempts to implement.
(the other is wake even notification consumption before re-entry into
suspend)

Signed-off-by: mark gross <mark97229@gmail.com>
---
 drivers/base/power/wakeup.c   |    5 +++--
 include/linux/pm_qos_params.h |    4 +++-
 kernel/pm_qos_params.c        |   14 +++++++++++++-
 kernel/power/suspend.c        |    7 +++++++
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index eb300d7..790010d 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -10,8 +10,8 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/capability.h>
-#include <linux/freezer.h>
 #include <linux/miscdevice.h>
+#include <linux/pm_qos_params.h>
 #include <linux/suspend.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
@@ -791,7 +791,8 @@ bool pm_get_wakeup_count(unsigned int *count)
 
 	for (;;) {
 		split_counters(&cnt, &inpr);
-		if (inpr == 0 || signal_pending(current))
+		if (((pm_qos_request(PM_QOS_SUSPEND_BLOCK) < 1) && (inpr == 0))
+				|| signal_pending(current))
 			break;
 		pm_wakeup_update_hit_counts();
 		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
index a7d87f9..19b771d 100644
--- a/include/linux/pm_qos_params.h
+++ b/include/linux/pm_qos_params.h
@@ -12,13 +12,15 @@
 #define PM_QOS_CPU_DMA_LATENCY 1
 #define PM_QOS_NETWORK_LATENCY 2
 #define PM_QOS_NETWORK_THROUGHPUT 3
+#define PM_QOS_SUSPEND_BLOCK 4
 
-#define PM_QOS_NUM_CLASSES 4
+#define PM_QOS_NUM_CLASSES 5
 #define PM_QOS_DEFAULT_VALUE -1
 
 #define PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
 #define PM_QOS_NETWORK_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
 #define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE	0
+#define PM_QOS_SUSPEND_BLOCK_DEFAULT_VALUE	0
 
 struct pm_qos_request_list {
 	struct plist_node list;
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 37f05d0..838ca8a 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -104,11 +104,23 @@ static struct pm_qos_object network_throughput_pm_qos = {
 };
 
 
+static BLOCKING_NOTIFIER_HEAD(suspend_block_notifier);
+static struct pm_qos_object suspend_block_pm_qos = {
+	.requests = PLIST_HEAD_INIT(suspend_block_pm_qos.requests),
+	.notifiers = &suspend_block_notifier,
+	.name = "suspend_block",
+	.target_value = PM_QOS_SUSPEND_BLOCK_DEFAULT_VALUE,
+	.default_value = PM_QOS_SUSPEND_BLOCK_DEFAULT_VALUE,
+	.type = PM_QOS_MAX,
+};
+
+
 static struct pm_qos_object *pm_qos_array[] = {
 	&null_pm_qos,
 	&cpu_dma_pm_qos,
 	&network_lat_pm_qos,
-	&network_throughput_pm_qos
+	&network_throughput_pm_qos,
+	&suspend_block_pm_qos
 };
 
 static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index b6b71ad..e71c8d7 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mm.h>
+#include <linux/pm_qos_params.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
@@ -278,6 +279,12 @@ int enter_state(suspend_state_t state)
 	if (!valid_state(state))
 		return -ENODEV;
 
+	if (state == PM_SUSPEND_MEM)
+		if (0 < pm_qos_request(PM_QOS_SUSPEND_BLOCK)) {
+			WARN(1, "suspend blocked by pm_qos");
+			return -EBUSY;
+		}
+
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
-- 
1.7.4.1


----- End forwarded message -----
