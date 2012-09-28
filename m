Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946305Ab2I1Vi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:38:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58980 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423371Ab2I1Vg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:36:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 12/12] time/jiffies: bring back unconditional LATCH definition
Date: Fri, 28 Sep 2012 23:36:17 +0200
Message-Id: <1348868177-21205-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348868177-21205-1-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:z+i04FELI9ViJEc3dVE+85Eaap8xKYmZ7c0UyQiQlQe
 3IUIHtAQpokjXP29K+2hUmdwr/2U+8ZgSw6zJjxdTIb/teUJV1
 Vnbdvs0aWtVdOofOkieLzd1lOf4SFEQ1NUJqH4mCTKRc8bvMfp
 sscYT07jV8sZGUDcdYFTmNeLrkzSUvPtb7qTXN9C8VTPW9IcUF
 httd3ph7Pdj4cw7N+Je98jc4uGnVzqBmGNhiSqBVsNW0vRJtPL
 7rCQKS8Dsa8nY9nYkZa7d/eWZFSCfaeGl81hkreseXkPK1auEo
 1agm7IYzOInwm1O4Gk339AMf03dBo2AfhZEIAU/eAkS8hkhDEP
 mIDBpcAQOjuldX7NJYIGjtgT92CKFvMsR1u8eCQyQC3DAzzMj5
 x6BfReiEThdtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch a7ea3bbf5d "time/jiffies: Allow CLOCK_TICK_RATE to be undefined"
breaks the compilation of targets that rely on the LATCH definition,
because of recursive header file inclusion not defining CLOCK_TICK_RATE
before it is checked here.

This fixes the problem by moving LATCH back to where it was, but it
seems that there are still cases where SHIFTED_HZ is defined incorrectly
because of the same problem. Need to investigate further.

Without this patch, building h7201_defconfig results in:

arch/arm/mach-h720x/common.c: In function 'h720x_gettimeoffset':
arch/arm/mach-h720x/common.c:50:73: error: 'LATCH' undeclared (first use in this function)
arch/arm/mach-h720x/common.c:50:73: note: each undeclared identifier is reported only once for each function it appears in
arch/arm/mach-h720x/common.c:51:1: warning: control reaches end of non-void function [-Wreturn-type]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/jiffies.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 05e3c2c7..d229ada 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -51,9 +51,10 @@
 #define SH_DIV(NOM,DEN,LSH) (   (((NOM) / (DEN)) << (LSH))              \
                              + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
 
-#ifdef CLOCK_TICK_RATE
 /* LATCH is used in the interval timer and ftape setup. */
-# define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
+#define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
+
+#ifdef CLOCK_TICK_RATE
 
 /*
  * HZ is the requested value. However the CLOCK_TICK_RATE may not allow
-- 
1.7.10

