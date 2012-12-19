Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2LSOka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:40:30 -0500
Received: from mail.active-venture.com ([67.228.131.205]:64046 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2LSOkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:40:23 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Wed, 19 Dec 2012 08:40:19 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        Juergen Beisert <jbe@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
Subject: [PATCH v2] linux/kernel.h: Fix DIV_ROUND_CLOSEST with unsigned divisors
Date: Wed, 19 Dec 2012 06:40:15 -0800
Message-Id: <1355928015-26212-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 263a523 fixes a warning seen with W=1 due to change in
DIV_ROUND_CLOSEST. Unfortunately, the C compiler converts divide operations
with unsigned divisors to unsigned, even if the dividend is signed and
negative (for example, -10 / 5U = 858993457). The C standard says "If one
operand has unsigned int type, the other operand is converted to unsigned
int", so the compiler is not to blame.
As a result, DIV_ROUND_CLOSEST(0, 2U) and similar operations now return
bad values, since the automatic conversion of expressions such as "0 - 2U/2"
to unsigned was not taken into account.

Fix by checking for the divisor variable type when deciding which operation
to perform. This fixes DIV_ROUND_CLOSEST(0, 2U), but still returns bad values
for negative dividends divided by unsigned divisors. Mark the latter case as
unsupported.

Reported-by: Juergen Beisert <jbe@pengutronix.de>
Tested-by: Juergen Beisert <jbe@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Description update (v1 wasn't supposed to make it to lkml)

 include/linux/kernel.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d97ed58..45726dc 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -77,13 +77,15 @@
 
 /*
  * Divide positive or negative dividend by positive divisor and round
- * to closest integer. Result is undefined for negative divisors.
+ * to closest integer. Result is undefined for negative divisors and
+ * for negative dividends if the divisor variable type is unsigned.
  */
 #define DIV_ROUND_CLOSEST(x, divisor)(			\
 {							\
 	typeof(x) __x = x;				\
 	typeof(divisor) __d = divisor;			\
-	(((typeof(x))-1) > 0 || (__x) > 0) ?		\
+	(((typeof(x))-1) > 0 ||				\
+	 ((typeof(divisor))-1) > 0 || (__x) > 0) ?	\
 		(((__x) + ((__d) / 2)) / (__d)) :	\
 		(((__x) - ((__d) / 2)) / (__d));	\
 }							\
-- 
1.7.9.7

