Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0KKDrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 22:47:45 -0500
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:5918 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756693Ab0KKDro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 22:47:44 -0500
Subject: [PATCH v6] Add generic exponentially weighted moving average (EWMA)
	function
To: akpm@linux-foundation.org
From: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kosaki.motohiro@jp.fujitsu.com, kevin.granade@gmail.com
Date: Thu, 11 Nov 2010 12:47:56 +0900
Message-ID: <20101111034756.15014.2156.stgit@localhost6.localdomain6>
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

Excuse me, but can I expect this to be merged anytime soon? Where do I check if
it got merged? I'm resending the patch in case it got lost.

Thanks,
bruno

--

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
 lib/Makefile            |    2 +-
 lib/average.c           |   58 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/average.h
 create mode 100644 lib/average.c

diff --git a/include/linux/average.h b/include/linux/average.h
new file mode 100644
index 0000000..f3b36d4
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
+extern struct ewma *ewma_init(struct ewma *avg, unsigned long factor,
+			      unsigned long weight);
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
diff --git a/lib/Makefile b/lib/Makefile
index e6a3763..f66acf7 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o
+	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o average.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/average.c b/lib/average.c
new file mode 100644
index 0000000..3262e04
--- /dev/null
+++ b/lib/average.c
@@ -0,0 +1,58 @@
+/*
+ * lib/average.c
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/average.h>
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
+struct ewma *ewma_init(struct ewma *avg, unsigned long factor,
+		       unsigned long weight)
+{
+	WARN_ON(weight <= 1 || factor == 0);
+	avg->internal = 0;
+	avg->weight = weight;
+	avg->factor = factor;
+	return avg;
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

