Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2H1Qau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:30:50 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51327 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2H1Qat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:30:49 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 28 Aug 2012 11:30:48 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jean Delvare <khali@linux-fr.org>,
        lm-sensors@lm-sensors.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 1/2] linux/kernel.h: Introduce IDIV_ROUND_CLOSEST
Date: Tue, 28 Aug 2012 09:30:55 -0700
Message-Id: <1346171456-29255-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DIV_ROUND_CLOSEST returns a bad result for negative dividends:
	DIV_ROUND_CLOSEST(-2, 2) = 0

Most of the time this does not matter. However, in the hardware monitoring
subsystem, it is sometimes used on integers which can be negative (such as
temperatures). Introduce new macro IDIV_ROUND_CLOSEST which also supports
negative dividends.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: v1 did not work if typeof(divisor) was an unsigned variable type
    (which can obviously not be negative).
    Rework to revert to DIV_ROUND_CLOSEST if the dividend is unsigned,
    or if it is signed but non-negative.

Plan is to merge this patch through my hwmon tree unless there is an objection.

 include/linux/kernel.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 6043821..42f1fd6 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -89,6 +89,16 @@
 }							\
 )
 
+#define IDIV_ROUND_CLOSEST(x, divisor)(			\
+{							\
+	typeof(x) __x = x;				\
+	typeof(divisor) __d = divisor;			\
+	(((typeof(x))-1) >= 0 || (__x) >= 0) ?		\
+		DIV_ROUND_CLOSEST((__x), (__d)) :	\
+		(((__x) - ((__d) / 2)) / (__d));	\
+}							\
+)
+
 /*
  * Multiplies an integer by a fraction, while avoiding unnecessary
  * overflow or loss of precision.
-- 
1.7.9.7

