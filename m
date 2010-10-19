Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453Ab0JSIgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:36:41 -0400
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:20885 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932230Ab0JSIgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:36:39 -0400
Subject: [PATCH v2] Add generic exponentially weighted moving average function
To: randy.dunlap@oracle.com, br1@einfach.org, akpm@linux-foundation.org,
        kevin.granade@gmail.com
From: Bruno Randolf <br1@einfach.org>
Cc: blp@cs.stanford.edu, linux-kernel@vger.kernel.org
Date: Tue, 19 Oct 2010 17:36:35 +0900
Message-ID: <20101019083635.32294.67087.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a generic exponentially weighted moving average function. This
implementation makes use of a structure which keeps a scaled up internal
representation to reduce rounding errors.

The idea for this implementation comes from the rt2x00 driver (rt2x00link.c)
and I would like to use it in several places in the mac80211 and ath5k code.

Signed-off-by: Bruno Randolf <br1@einfach.org>

--
v2: Renamed 'samples' to 'weight'. Added more documentation. Use avg_val
    pointer. Add a WARN_ON_ONCE for invalid values of 'weight'. Divide
    and round up/down.
---
 include/linux/average.h |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/average.h

diff --git a/include/linux/average.h b/include/linux/average.h
new file mode 100644
index 0000000..55e4317
--- /dev/null
+++ b/include/linux/average.h
@@ -0,0 +1,37 @@
+#ifndef _LINUX_AVERAGE_H
+#define _LINUX_AVERAGE_H
+
+#define AVG_FACTOR	1000
+
+struct avg_val {
+	int value;
+	int internal;
+};
+
+/**
+ * moving_average() -  Exponentially weighted moving average (EWMA)
+ * @avg: Average structure
+ * @val: Current value
+ * @weight: This defines how fast the influence of older values decreases.
+ *	Has to be higher than 1. Use the same number every time you call this
+ *	function for a single struct avg_val!
+ *
+ * This implementation make use of a struct avg_val which keeps a scaled up
+ * internal representation to prevent rounding errors. Due to this, the maximum
+ * range of values is MAX_INT/(AVG_FACTOR*weight).
+ *
+ * The current average value can be accessed by using avg_val.value.
+ */
+static inline void
+moving_average(struct avg_val *avg, const int val, const int weight)
+{
+	if (WARN_ON_ONCE(weight <= 1))
+		return;
+	avg->internal = avg->internal  ?
+		(((avg->internal * (weight - 1)) +
+			(val * AVG_FACTOR)) / weight) :
+		(val * AVG_FACTOR);
+	avg->value = DIV_ROUND_CLOSEST(avg->internal, AVG_FACTOR);
+}
+
+#endif /* _LINUX_AVERAGE_H */

