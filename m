Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab1LYVGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 16:06:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49245 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1LYVGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 16:06:11 -0500
From: Chinmay V S <cvs268@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Chinmay V S <cvs268@gmail.com>
Subject: [PATCH] Optimise apply_slack() for faster execution
Date: Mon, 26 Dec 2011 02:35:48 +0530
Message-Id: <1324847148-20834-1-git-send-email-cvs268@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies the apply_slack() function in the kernel timer
subsystem. This is frequently called in mod_timer()/add_timer() and will
thus improve the performance of both the functions.

The existing logic used an intermediate-mask and a set of bitwise
operations using the mask to round-off the expires_limit variable. This
patch discards the intermediate-mask in favour of direct
shift-operations.

Signed-off-by: Chinmay V S <cvs268@gmail.com>
---
 kernel/timer.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 9c3c62b..3fc1f48 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -739,37 +739,33 @@ EXPORT_SYMBOL(mod_timer_pending);
  * Algorithm:
  *   1) calculate the maximum (absolute) time
  *   2) calculate the highest bit where the expires and new max are different
- *   3) use this bit to make a mask
- *   4) use the bitmask to round down the maximum time, so that all last
- *      bits are zeros
+ *   3) use this bit to round down maximum time, so that all last bits are 0
  */
 static inline
 unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 {
-	unsigned long expires_limit, mask;
+	unsigned long slack = 0;
 	int bit;
 
 	if (timer->slack >= 0) {
-		expires_limit = expires + timer->slack;
+		slack = timer->slack;
 	} else {
 		long delta = expires - jiffies;
 
 		if (delta < 256)
 			return expires;
 
-		expires_limit = expires + delta / 256;
+		slack = delta/256;
 	}
-	mask = expires ^ expires_limit;
-	if (mask == 0)
-		return expires;
 
-	bit = find_last_bit(&mask, BITS_PER_LONG);
+	if (slack == 0)
+		return expires;
 
-	mask = (1 << bit) - 1;
+	bit = find_last_bit(&slack, BITS_PER_LONG);
 
-	expires_limit = expires_limit & ~(mask);
+	expires = (expires >> bit) << bit;
 
-	return expires_limit;
+	return expires;
 }
 
 /**
-- 
1.7.0.4

