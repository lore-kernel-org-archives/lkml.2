Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2HaAKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 20:10:36 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53643 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2HaAKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 20:10:35 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Thu, 30 Aug 2012 19:10:35 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jean Delvare <khali@linux-fr.org>,
        lm-sensors@lm-sensors.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3] linux/kernel.h: Fix DIV_ROUND_CLOSEST to support negative operands
Date: Thu, 30 Aug 2012 17:10:47 -0700
Message-Id: <1346371847-21384-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DIV_ROUND_CLOSEST returns a bad result for dividends with different sign:
	DIV_ROUND_CLOSEST(-2, 2) = 0

Most of the time this does not matter. However, in the hardware monitoring
subsystem, DIV_ROUND_CLOSEST is sometimes used on integers which can be
negative (such as temperatures).

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3: Instead of adding a new macro, fix DIV_ROUND_CLOSEST.
    This version works for negative dividend and divisor.

v2: v1 did not work if typeof(divisor) was an unsigned variable type
    (which can obviously not be negative).
    Rework to revert to DIV_ROUND_CLOSEST if the dividend is unsigned,
    or if it is signed but non-negative.

 include/linux/kernel.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 6043821..4b180de 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -84,8 +84,11 @@
 )
 #define DIV_ROUND_CLOSEST(x, divisor)(			\
 {							\
-	typeof(divisor) __divisor = divisor;		\
-	(((x) + ((__divisor) / 2)) / (__divisor));	\
+	typeof(x) __x = x;				\
+	typeof(divisor) __d = divisor;			\
+	((__x) < 0) == ((__d) < 0) ?			\
+		(((__x) + ((__d) / 2)) / (__d)) :	\
+		(((__x) - ((__d) / 2)) / (__d));	\
 }							\
 )
 
-- 
1.7.9.7

