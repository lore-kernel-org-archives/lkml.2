Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182Ab3AIUsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:48:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:44004 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933985Ab3AIUl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <linux@roeck-us.net>,
        Juergen Beisert <jbe@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 119/123] linux/kernel.h: fix DIV_ROUND_CLOSEST with unsigned divisors
Date: Wed,  9 Jan 2013 12:35:58 -0800
Message-Id: <20130109201513.604910016@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit c4e18497d8fd92eef2c6e7eadcc1a107ccd115ea upstream.

Commit 263a523d18bc ("linux/kernel.h: Fix warning seen with W=1 due to
change in DIV_ROUND_CLOSEST") fixes a warning seen with W=1 due to
change in DIV_ROUND_CLOSEST.

Unfortunately, the C compiler converts divide operations with unsigned
divisors to unsigned, even if the dividend is signed and negative (for
example, -10 / 5U = 858993457).  The C standard says "If one operand has
unsigned int type, the other operand is converted to unsigned int", so
the compiler is not to blame.  As a result, DIV_ROUND_CLOSEST(0, 2U) and
similar operations now return bad values, since the automatic conversion
of expressions such as "0 - 2U/2" to unsigned was not taken into
account.

Fix by checking for the divisor variable type when deciding which
operation to perform.  This fixes DIV_ROUND_CLOSEST(0, 2U), but still
returns bad values for negative dividends divided by unsigned divisors.
Mark the latter case as unsupported.

One observed effect of this problem is that the s2c_hwmon driver reports
a value of 4198403 instead of 0 if the ADC reads 0.

Other impact is unpredictable.  Problem is seen if the divisor is an
unsigned variable or constant and the dividend is less than (divisor/2).

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Juergen Beisert <jbe@pengutronix.de>
Tested-by: Juergen Beisert <jbe@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kernel.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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


