Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab1EXAMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 20:12:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37995 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753285Ab1EXAMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 20:12:48 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Do bulk enables of regulators in parallel
Date: Tue, 24 May 2011 08:12:40 +0800
Message-Id: <1306195960-5897-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to reduce the impact of ramp times rather than enabling the
regulators for a device in series use async tasks to run the actual
enables. This means that the delays which the enables implement can all
run in parallel, though it does mean that the order in which the
supplies come on may be unstable.

For super bonus fun points if any of the regulators are shared between
multiple supplies on the same device (as is rather likely) then this
will test our locking.  Note that in this case we only delay once for
each physical regulator so the threads shouldn't block each other while
delaying.

It'd be even nicer if we could coalesce writes to a shared enable registers
in PMICs but that's definitely future work, and it may also be useful
and is certainly more achievable to optimise out the parallelism if none
of the regulators implement ramp delays.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Targetted at 2.6.41 obviously.

 drivers/regulator/core.c           |   32 ++++++++++++++++++++++++++------
 include/linux/regulator/consumer.h |    3 +++
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2484dbe..60ae920 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -20,6 +20,7 @@
 #include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/slab.h>
+#include <linux/async.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/suspend.h>
@@ -2233,6 +2234,13 @@ err:
 }
 EXPORT_SYMBOL_GPL(regulator_bulk_get);
 
+static void regulator_bulk_enable_async(void *data, async_cookie_t cookie)
+{
+	struct regulator_bulk_data *bulk = data;
+
+	bulk->ret = regulator_enable(bulk->consumer);
+}
+
 /**
  * regulator_bulk_enable - enable multiple regulator consumers
  *
@@ -2248,21 +2256,33 @@ EXPORT_SYMBOL_GPL(regulator_bulk_get);
 int regulator_bulk_enable(int num_consumers,
 			  struct regulator_bulk_data *consumers)
 {
+	LIST_HEAD(async_domain);
 	int i;
-	int ret;
+	int ret = 0;
+
+	for (i = 0; i < num_consumers; i++)
+		async_schedule_domain(regulator_bulk_enable_async,
+				      &consumers[i], &async_domain);
+
+	async_synchronize_full_domain(&async_domain);
 
+	/* If any consumer failed we need to unwind any that succeeded */
 	for (i = 0; i < num_consumers; i++) {
-		ret = regulator_enable(consumers[i].consumer);
-		if (ret != 0)
+		if (consumers[i].ret != 0) {
+			ret = consumers[i].ret;
 			goto err;
+		}
 	}
 
 	return 0;
 
 err:
-	pr_err("Failed to enable %s: %d\n", consumers[i].supply, ret);
-	for (--i; i >= 0; --i)
-		regulator_disable(consumers[i].consumer);
+	for (i = 0; i < num_consumers; i++)
+		if (consumers[i].ret == 0)
+			regulator_disable(consumers[i].consumer);
+		else
+			pr_err("Failed to enable %s: %d\n",
+			       consumers[i].supply, consumers[i].ret);
 
 	return ret;
 }
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 9e87c1c..26f6ea4 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -122,6 +122,9 @@ struct regulator;
 struct regulator_bulk_data {
 	const char *supply;
 	struct regulator *consumer;
+
+	/* Internal use */
+	int ret;
 };
 
 #if defined(CONFIG_REGULATOR)
-- 
1.7.5.1

