Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2JHOAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 10:00:12 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:31901 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab2JHOAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 10:00:09 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Oct 2012 10:00:08 EDT
From: "Hildner, Christian" <christian.hildner@siemens.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Mon, 8 Oct 2012 15:49:03 +0200
Subject: [PATCH] Fix endless looping between cascade() and
 internal_add_timer()
Thread-Topic: [PATCH] Fix endless looping between cascade() and
 internal_add_timer()
Thread-Index: Ac2lW61cie6zVh6YQeWnG2CUTeZXiQ==
Message-ID: <98673C87CB31274881CFFE0B65ECC87B0F5FC1963E@DEFTHW99EA4MSX.ww902.siemens.net>
Accept-Language: de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Hildner <christian.hildner@siemens.com>

This patch ensures that when cascade() is called timers within tv5 are not added endlessly to their own list again, instead they are added to the next lower tv level tv4 (as expected).

Signed-off-by: Christian Hildner <christian.hildner@siemens.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
---
Adding two (or more) timers with large values for "expires" (they have to reside within tv5 in the same list) leads to endless looping between cascade() and internal_add_timer() in case CONFIG_BASE_SMALL is one and jiffies are crossing the value 1 << 18. The bug was introduced between 2.6.11 and 2.6.12 (and survived for quite some time).

Tested with 2.6.14, patch is for 3.6.1 - see below.


diff -urN linux-3.6.1_orig/kernel/timer.c linux-3.6.1/kernel/timer.c
--- linux-3.6.1_orig/kernel/timer.c	2012-10-07 17:41:28.000000000 +0200
+++ linux-3.6.1/kernel/timer.c	2012-10-08 09:34:40.000000000 +0200
@@ -63,6 +63,7 @@
 #define TVR_SIZE (1 << TVR_BITS)
 #define TVN_MASK (TVN_SIZE - 1)
 #define TVR_MASK (TVR_SIZE - 1)
+#define MAX_TVAL ((unsigned long)((1ULL << (TVR_BITS + 4*TVN_BITS)) - 1))
 
 struct tvec {
 	struct list_head vec[TVN_SIZE];
@@ -358,11 +359,12 @@
 		vec = base->tv1.vec + (base->timer_jiffies & TVR_MASK);
 	} else {
 		int i;
-		/* If the timeout is larger than 0xffffffff on 64-bit
-		 * architectures then we use the maximum timeout:
+		/* If the timeout is larger than MAX_TVAL (on 64-bit
+		 * architectures or with CONFIG_BASE_SMALL=1) then we
+		 * use the maximum timeout.
 		 */
-		if (idx > 0xffffffffUL) {
-			idx = 0xffffffffUL;
+		if (idx > MAX_TVAL) {
+			idx = MAX_TVAL;
 			expires = idx + base->timer_jiffies;
 		}
 		i = (expires >> (TVR_BITS + 3 * TVN_BITS)) & TVN_MASK;