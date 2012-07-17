Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab2GQQmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:42:03 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48236 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab2GQQmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:42:01 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] Allow CLOCK_TICK_RATE to be undefined
Date: Tue, 17 Jul 2012 17:41:40 +0100
Message-Id: <1342543300-23460-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
X-OriginalArrivalTime: 17 Jul 2012 16:43:09.0603 (UTC) FILETIME=[3F928F30:01CD643B]
X-MC-Unique: 112071717415906001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q6HGgCZb003191

This patch allows an architecture to not define CLOCK_TICK_RATE, in
which case ACTHZ defaults to (HZ << 8).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/jiffies.h |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 265e2c3..a2134be 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -39,9 +39,6 @@
 # error Invalid value of HZ.
 #endif
 
-/* LATCH is used in the interval timer and ftape setup. */
-#define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
-
 /* Suppose we want to divide two numbers NOM and DEN: NOM/DEN, then we can
  * improve accuracy by shifting LSH bits, hence calculating:
  *     (NOM << LSH) / DEN
@@ -54,8 +51,15 @@
 #define SH_DIV(NOM,DEN,LSH) (   (((NOM) / (DEN)) << (LSH))              \
                              + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
 
+#ifdef CLOCK_TICK_RATE
+/* LATCH is used in the interval timer and ftape setup. */
+#define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
+
 /* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
 #define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
+#else
+#define ACTHZ (HZ << 8)
+#endif
 
 /* TICK_NSEC is the time between ticks in nsec assuming real ACTHZ */
 #define TICK_NSEC (SH_DIV (1000000UL * 1000, ACTHZ, 8))

