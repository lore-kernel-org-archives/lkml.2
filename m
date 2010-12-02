Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab0LBKNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:13:19 -0500
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:8191 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751517Ab0LBKNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:13:17 -0500
Subject: [PATCH 2/3] lib: Improve EWMA efficiency by using bitshifts
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, br1@thinktube.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com, j@w1.fi,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com,
        johannes@sipsolutions.net
Date: Thu, 02 Dec 2010 19:12:36 +0900
Message-ID: <20101202101236.22988.1691.stgit@localhost6.localdomain6>
In-Reply-To: <20101202101231.22988.33396.stgit@localhost6.localdomain6>
References: <20101202101231.22988.33396.stgit@localhost6.localdomain6>
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
---
 include/linux/average.h |    4 +---
 lib/average.c           |   29 +++++++++++++++++++++--------
 2 files changed, 22 insertions(+), 11 deletions(-)

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
index f1d1b46..f438b40 100644
--- a/lib/average.c
+++ b/lib/average.c
@@ -24,18 +24,31 @@
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
+	int n;
+
+	/* get bitshift for weight */
+	for (n = 0; !(weight & 1); n++)
+		weight = weight >> 1;
+	WARN_ON(weight > 1 || n < 1);
+	avg->weight = n;
+
+	/* get bitshift for factor */
+	for (n = 0; !(factor & 1); n++)
+		factor = factor >> 1;
+	WARN_ON(factor > 1);
+	avg->factor = n;
+
 	avg->internal = 0;
-	avg->weight = weight;
-	avg->factor = factor;
 }
 EXPORT_SYMBOL(ewma_init);
 
@@ -49,9 +62,9 @@ EXPORT_SYMBOL(ewma_init);
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

