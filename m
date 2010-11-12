Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0KLDAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:00:13 -0500
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:8892 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755076Ab0KLDAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:00:10 -0500
Subject: [PATCH v7 1/3] Add generic exponentially weighted moving average
	(EWMA) function
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, br1@thinktube.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
Date: Fri, 12 Nov 2010 12:00:25 +0900
Message-ID: <20101112030025.28522.68634.stgit@localhost6.localdomain6>
In-Reply-To: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds generic functions for calculating Exponentially Weighted Moving
Averages (EWMA). This implementation makes use of a structure which keeps the
EWMA parameters and a scaled up internal representation to reduce rounding
errors.

The original idea for this implementation came from the rt2x00 driver
(rt2x00link.c). I would like to use it in several places in the mac80211 and
ath5k code and I hope it can be useful in many other places in the kernel code.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

--

v7: Include bug.h. ewma_init() returns void. Use CONFIG_AVERAGE.

v6: Fixed ULONG_MAX in comment. Add reviewed by KOSAKI Motohiro.

v5: Use unsigned long instead of insigned int.

v4: Initialize internal variable to 0. Remove unneeded const qualifiers.

v3: Addressing Andrew Mortons comments: Implement in lib/average.c and make
    access and initalization functions. Use unsigned int for values. Rename
    functions to ewma_* since there might be other moving average
    implementations which are not exponentially weighted.

v2: Renamed 'samples' to 'weight'. Added more documentation. Use avg_val
    pointer. Add a WARN_ON_ONCE for invalid values of 'weight'. Divide
    and round up/down.
---
 include/linux/average.h |   32 ++++++++++++++++++++++++++
 lib/Kconfig             |    3 ++
 lib/Makefile            |    2 ++
 lib/average.c           |   57 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/average.h
 create mode 100644 lib/average.c

diff --git a/include/linux/average.h b/include/linux/average.h
new file mode 100644
index 0000000..ee3da51
--- /dev/null
+++ b/include/linux/average.h
@@ -0,0 +1,32 @@
+#ifndef _LINUX_AVERAGE_H
+#define _LINUX_AVERAGE_H
+
+#include <linux/kernel.h>
+
+/* Exponentially weighted moving average (EWMA) */
+
+/* For more documentation see lib/average.c */
+
+struct ewma {
+	unsigned long internal;
+	unsigned long factor;
+	unsigned long weight;
+};
+
+extern void ewma_init(struct ewma *avg, unsigned long factor,
+		      unsigned long weight);
+
+extern struct ewma *ewma_add(struct ewma *avg, unsigned long val);
+
+/**
+ * ewma_get() - Get average value
+ * @avg: Average structure
+ *
+ * Returns the average value held in @avg.
+ */
+static inline unsigned long ewma_get(const struct ewma *avg)
+{
+	return DIV_ROUND_CLOSEST(avg->internal, avg->factor);
+}
+
+#endif /* _LINUX_AVERAGE_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index fa9bf2c..3116aa6 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -210,4 +210,7 @@ config GENERIC_ATOMIC64
 config LRU_CACHE
 	tristate
 
+config AVERAGE
+	bool
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index e6a3763..76d3b85 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -106,6 +106,8 @@ obj-$(CONFIG_GENERIC_ATOMIC64) += atomic64.o
 
 obj-$(CONFIG_ATOMIC64_SELFTEST) += atomic64_test.o
 
+obj-$(CONFIG_AVERAGE) += average.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/average.c b/lib/average.c
new file mode 100644
index 0000000..f1d1b46
--- /dev/null
+++ b/lib/average.c
@@ -0,0 +1,57 @@
+/*
+ * lib/average.c
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/average.h>
+#include <linux/bug.h>
+
+/**
+ * DOC: Exponentially Weighted Moving Average (EWMA)
+ *
+ * These are generic functions for calculating Exponentially Weighted Moving
+ * Averages (EWMA). We keep a structure with the EWMA parameters and a scaled
+ * up internal representation of the average value to prevent rounding errors.
+ * The factor for scaling up and the exponential weight (or decay rate) have to
+ * be specified thru the init fuction. The structure should not be accessed
+ * directly but only thru the helper functions.
+ */
+
+/**
+ * ewma_init() - Initialize EWMA parameters
+ * @avg: Average structure
+ * @factor: Factor to use for the scaled up internal value. The maximum value
+ *	of averages can be ULONG_MAX/(factor*weight).
+ * @weight: Exponential weight, or decay rate. This defines how fast the
+ *	influence of older values decreases. Has to be bigger than 1.
+ *
+ * Initialize the EWMA parameters for a given struct ewma @avg.
+ */
+void ewma_init(struct ewma *avg, unsigned long factor, unsigned long weight)
+{
+	WARN_ON(weight <= 1 || factor == 0);
+	avg->internal = 0;
+	avg->weight = weight;
+	avg->factor = factor;
+}
+EXPORT_SYMBOL(ewma_init);
+
+/**
+ * ewma_add() - Exponentially weighted moving average (EWMA)
+ * @avg: Average structure
+ * @val: Current value
+ *
+ * Add a sample to the average.
+ */
+struct ewma *ewma_add(struct ewma *avg, unsigned long val)
+{
+	avg->internal = avg->internal  ?
+		(((avg->internal * (avg->weight - 1)) +
+			(val * avg->factor)) / avg->weight) :
+		(val * avg->factor);
+	return avg;
+}
+EXPORT_SYMBOL(ewma_add);

