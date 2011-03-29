Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1C2Qi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:38:59 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:49762 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab1C2Qi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:38:58 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fix msecs_to_jiffies() to not return values greater than MAX_JIFFY_OFFSET
Date: Tue, 29 Mar 2011 18:38:46 +0200
Message-Id: <2120287.WTetKHanc4@donald.sf-tec.de>
User-Agent: KMail/4.6 beta4 (Linux/2.6.37-12-desktop; KDE/4.6.1; i686; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation of msecs_to_jiffies() says:

 * - negative values mean 'infinite timeout' (MAX_JIFFY_OFFSET)
 *
 * - 'too large' values [that would result in larger than
 *   MAX_JIFFY_OFFSET values] mean 'infinite timeout' too.

But when you pass in e.g. MAX_JIFFY_OFFSET + 1000 for HZ = 1000 it will not
return MAX_JIFFY_OFFSET, but the bigger value. This makes sure that the value
returned from this function can never be bigger than MAX_JIFFY_OFFSET. Also
use DIV_ROUND_UP() in one place where that is open coded.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 kernel/time.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 8e8dc6d..1ccec53 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -433,6 +433,7 @@ EXPORT_SYMBOL(ns_to_timeval);
  */
 unsigned long msecs_to_jiffies(const unsigned int m)
 {
+	unsigned long r;
 	/*
 	 * Negative value, means infinite timeout:
 	 */
@@ -445,7 +446,7 @@ unsigned long msecs_to_jiffies(const unsigned int m)
 	 * round multiple of HZ, divide with the factor between them,
 	 * but round upwards:
 	 */
-	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
+	r = DIV_ROUND_UP(m, MSEC_PER_SEC / HZ);
 #elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
 	/*
 	 * HZ is larger than 1000, and HZ is a nice round multiple of
@@ -457,7 +458,7 @@ unsigned long msecs_to_jiffies(const unsigned int m)
 	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
 		return MAX_JIFFY_OFFSET;
 
-	return m * (HZ / MSEC_PER_SEC);
+	r = m * (HZ / MSEC_PER_SEC);
 #else
 	/*
 	 * Generic case - multiply, round and divide. But first
@@ -467,9 +468,10 @@ unsigned long msecs_to_jiffies(const unsigned int m)
 	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
 		return MAX_JIFFY_OFFSET;
 
-	return (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
+	r = (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
 		>> MSEC_TO_HZ_SHR32;
 #endif
+	return min_t(unsigned long, r, MAX_JIFFY_OFFSET);
 }
 EXPORT_SYMBOL(msecs_to_jiffies);
 
-- 
1.7.3.2


