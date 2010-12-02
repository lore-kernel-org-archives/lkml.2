Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab0LBKvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:51:20 -0500
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:29398 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751517Ab0LBKvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:51:18 -0500
Subject: [PATCH v2] lib: Improve EWMA efficiency by using bitshifts
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, br1@thinktube.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com, j@w1.fi,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com,
        johannes@sipsolutions.net
Date: Thu, 02 Dec 2010 19:50:37 +0900
Message-ID: <20101202105037.5654.62835.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using bitshifts instead of division and multiplication should improve
performance. That requires weight and factor to be powers of two, but i think
this is something we can live with.

Thanks to Peter Zijlstra for the improved formula!

Signed-off-by: Bruno Randolf <br1@einfach.org>

--

v2:	use log2.h functions
---
 include/linux/average.h |    4 +---
 lib/average.c           |   20 ++++++++++++--------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/linux/average.h b/include/linux/average.h
index 7706e40..c6028fd 100644
--- a/include/linux/average.h
+++ b/include/linux/average.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_AVERAGE_H
 #define _LINUX_AVERAGE_H
 
-#include <linux/kernel.h>
-
 /* Exponentially weighted moving average (EWMA) */
 
 /* For more documentation see lib/average.c */
@@ -26,7 +24,7 @@ extern struct ewma *ewma_add(struct ewma *avg, unsigned long val);
  */
 static inline unsigned long ewma_read(const struct ewma *avg)
 {
-	return DIV_ROUND_CLOSEST(avg->internal, avg->factor);
+	return avg->internal >> avg->factor;
 }
 
 #endif /* _LINUX_AVERAGE_H */
diff --git a/lib/average.c b/lib/average.c
index f1d1b46..5576c28 100644
--- a/lib/average.c
+++ b/lib/average.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/average.h>
 #include <linux/bug.h>
+#include <linux/log2.h>
 
 /**
  * DOC: Exponentially Weighted Moving Average (EWMA)
@@ -24,18 +25,21 @@
  * ewma_init() - Initialize EWMA parameters
  * @avg: Average structure
  * @factor: Factor to use for the scaled up internal value. The maximum value
- *	of averages can be ULONG_MAX/(factor*weight).
+ *	of averages can be ULONG_MAX/(factor*weight). For performance reasons
+ *	factor has to be a power of 2.
  * @weight: Exponential weight, or decay rate. This defines how fast the
- *	influence of older values decreases. Has to be bigger than 1.
+ *	influence of older values decreases. For performance reasons weight has
+ *	to be a power of 2.
  *
  * Initialize the EWMA parameters for a given struct ewma @avg.
  */
 void ewma_init(struct ewma *avg, unsigned long factor, unsigned long weight)
 {
-	WARN_ON(weight <= 1 || factor == 0);
+	WARN_ON(!is_power_of_2(weight) || !is_power_of_2(factor));
+
+	avg->weight = ilog2(weight);
+	avg->factor = ilog2(factor);
 	avg->internal = 0;
-	avg->weight = weight;
-	avg->factor = factor;
 }
 EXPORT_SYMBOL(ewma_init);
 
@@ -49,9 +53,9 @@ EXPORT_SYMBOL(ewma_init);
 struct ewma *ewma_add(struct ewma *avg, unsigned long val)
 {
 	avg->internal = avg->internal  ?
-		(((avg->internal * (avg->weight - 1)) +
-			(val * avg->factor)) / avg->weight) :
-		(val * avg->factor);
+		(((avg->internal << avg->weight) - avg->internal) +
+			(val << avg->factor)) >> avg->weight :
+		(val << avg->factor);
 	return avg;
 }
 EXPORT_SYMBOL(ewma_add);

