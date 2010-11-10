Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0KJOim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:38:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60344 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756251Ab0KJOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:38:37 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Add basic trace facilities
Date: Wed, 10 Nov 2010 14:38:30 +0000
Message-Id: <1289399910-7779-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289399910-7779-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1289399910-7779-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide some basic trace facilities to the regulator API. We generate
events on regulator enable, disable and voltage setting over the actual
hardware operations (which are assumed to be the expensive ones which
require interaction with the actual device). This is intended to facilitate
debug of the performance and behaviour with consumers allowing unified
traces to be generated including the regulator operations within the
context of the other components of the system.

For enable we log the explicit delay for the voltage ramp separately to
the interaction with the hardware to highlight the time consumed in I/O.
We should add a similar delay for voltage changes, though there the
relatively small magnitude of the changes in the context of the I/O
costs makes it much less critical for most regulators.

Only hardware interactions are currently traced as the primary focus is
on the performance and synchronisation of actual hardware interactions.
Additional tracepoints for debugging of the logical operations can be
added later if required.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   17 +++++
 include/trace/events/regulator.h |  141 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/regulator.h

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6616bc9..2a7aeea 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -25,6 +25,9 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/regulator.h>
+
 #include "dummy.h"
 
 #define REGULATOR_VERSION "0.5"
@@ -1310,6 +1313,8 @@ static int _regulator_enable(struct regulator_dev *rdev)
 				delay = 0;
 			}
 
+			trace_regulator_enable(rdev_get_name(rdev));
+
 			/* Allow the regulator to ramp; it would be useful
 			 * to extend this for bulk operations so that the
 			 * regulators can ramp together.  */
@@ -1317,6 +1322,8 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			if (ret < 0)
 				return ret;
 
+			trace_regulator_enable_delay(rdev_get_name(rdev));
+
 			if (delay >= 1000) {
 				mdelay(delay / 1000);
 				udelay(delay % 1000);
@@ -1324,6 +1331,8 @@ static int _regulator_enable(struct regulator_dev *rdev)
 				udelay(delay);
 			}
 
+			trace_regulator_enable_complete(rdev_get_name(rdev));
+
 		} else if (ret < 0) {
 			printk(KERN_ERR "%s: is_enabled() failed for %s: %d\n",
 			       __func__, rdev_get_name(rdev), ret);
@@ -1379,6 +1388,8 @@ static int _regulator_disable(struct regulator_dev *rdev,
 		/* we are last user */
 		if (_regulator_can_change_status(rdev) &&
 		    rdev->desc->ops->disable) {
+			trace_regulator_disable(rdev_get_name(rdev));
+
 			ret = rdev->desc->ops->disable(rdev);
 			if (ret < 0) {
 				printk(KERN_ERR "%s: failed to disable %s\n",
@@ -1386,6 +1397,8 @@ static int _regulator_disable(struct regulator_dev *rdev,
 				return ret;
 			}
 
+			trace_regulator_disable_complete(rdev_get_name(rdev));
+
 			_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
 					     NULL);
 		}
@@ -1645,6 +1658,8 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	regulator->min_uV = min_uV;
 	regulator->max_uV = max_uV;
 
+	trace_regulator_set_voltage(rdev_get_name(rdev), min_uV, max_uV);
+
 	ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV, &selector);
 
 	if (rdev->desc->ops->list_voltage)
@@ -1652,6 +1667,8 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	else
 		selector = -1;
 
+	trace_regulator_set_voltage_complete(rdev_get_name(rdev), selector);
+
 out:
 	_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE, NULL);
 	mutex_unlock(&rdev->mutex);
diff --git a/include/trace/events/regulator.h b/include/trace/events/regulator.h
new file mode 100644
index 0000000..37502a7
--- /dev/null
+++ b/include/trace/events/regulator.h
@@ -0,0 +1,141 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM regulator
+
+#if !defined(_TRACE_REGULATOR_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_REGULATOR_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+
+/*
+ * Events which just log themselves and the regulator name for enable/disable
+ * type tracking.
+ */
+DECLARE_EVENT_CLASS(regulator_basic,
+
+	TP_PROTO(const char *name),
+
+	TP_ARGS(name),
+
+	TP_STRUCT__entry(
+		__string(	name,	name	)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+	),
+
+	TP_printk("name=%s", __get_str(name))
+
+);
+
+DEFINE_EVENT(regulator_basic, regulator_enable,
+
+	TP_PROTO(const char *name),
+
+	TP_ARGS(name)
+
+);
+
+DEFINE_EVENT(regulator_basic, regulator_enable_delay,
+
+	TP_PROTO(const char *name),
+
+	TP_ARGS(name)
+
+);
+
+DEFINE_EVENT(regulator_basic, regulator_enable_complete,
+
+	TP_PROTO(const char *name),
+
+	TP_ARGS(name)
+
+);
+
+DEFINE_EVENT(regulator_basic, regulator_disable,
+
+	TP_PROTO(const char *name),
+
+	TP_ARGS(name)
+
+);
+
+DEFINE_EVENT(regulator_basic, regulator_disable_complete,
+
+	TP_PROTO(const char *name),
+
+	TP_ARGS(name)
+
+);
+
+/*
+ * Events that take a range of numerical values, mostly for voltages
+ * and so on.
+ */
+DECLARE_EVENT_CLASS(regulator_range,
+
+	TP_PROTO(const char *name, int min, int max),
+
+	TP_ARGS(name, min, max),
+
+	TP_STRUCT__entry(
+		__string(	name,		name		)
+		__field(        int,            min             )
+		__field(        int,            max             )
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->min  = min;
+		__entry->max  = max;
+	),
+
+	TP_printk("name=%s (%d-%d)", __get_str(name),
+		  (int)__entry->min, (int)__entry->max)
+);
+
+DEFINE_EVENT(regulator_range, regulator_set_voltage,
+
+	TP_PROTO(const char *name, int min, int max),
+
+	TP_ARGS(name, min, max)
+
+);
+
+
+/*
+ * Events that take a single value, mostly for readback and refcounts.
+ */
+DECLARE_EVENT_CLASS(regulator_value,
+
+	TP_PROTO(const char *name, unsigned int val),
+
+	TP_ARGS(name, val),
+
+	TP_STRUCT__entry(
+		__string(	name,		name		)
+		__field(        unsigned int,   val             )
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->val  = val;
+	),
+
+	TP_printk("name=%s, val=%u", __get_str(name),
+		  (int)__entry->val)
+);
+
+DEFINE_EVENT(regulator_value, regulator_set_voltage_complete,
+
+	TP_PROTO(const char *name, unsigned int value),
+
+	TP_ARGS(name, value)
+
+);
+
+#endif /* _TRACE_POWER_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.1

