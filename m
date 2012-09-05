Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab2IEVfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:35:11 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:37472 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468Ab2IEVfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:35:08 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH] ARM: exynos: mct: cache mct upper count
Date: Wed,  5 Sep 2012 14:34:54 -0700
Message-Id: <1346880894-31316-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saves one register read.

BUG=none
TEST=See below.

Before (perf report):

     1.40%  [k] exynos4_frc_read
            |
            |--87.20%-- ktime_get_ts
            |          |
            |          |--93.60%-- posix_ktime_get_ts

After (perf report):

     1.00%  [k] exynos4_frc_read
            |
            |--88.61%-- ktime_get_ts
            |          |
            |          |--92.70%-- posix_ktime_get_ts

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Sonny Rao <sonnyrao@chromium.org>
CC: Olof Johansson <olofj@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org
CC: linux-samsung-soc@vger.kernel.org
---
 arch/arm/mach-exynos/mct.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/mct.c b/arch/arm/mach-exynos/mct.c
index b601fb8..2bbd533 100644
--- a/arch/arm/mach-exynos/mct.c
+++ b/arch/arm/mach-exynos/mct.c
@@ -128,8 +128,8 @@ static void exynos4_mct_frc_start(u32 hi, u32 lo)
 
 static cycle_t exynos4_frc_read(struct clocksource *cs)
 {
-	unsigned int lo, hi;
-	u32 hi2 = __raw_readl(EXYNOS4_MCT_G_CNT_U);
+	u32 lo, hi;
+	static u32 hi2;
 
 	do {
 		hi = hi2;
-- 
1.7.7.3

