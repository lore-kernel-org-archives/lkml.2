Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab0IGOoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:44:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab0IGOoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:44:17 -0400
From: Miroslav Lichvar <mlichvar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: john stultz <johnstul@us.ibm.com>, Miroslav Lichvar <mlichvar@redhat.com>
Subject: [PATCH] ntp: Clamp PLL update interval
Date: Tue,  7 Sep 2010 16:43:46 +0200
Message-Id: <1283870626-9472-1-git-send-email-mlichvar@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clamp update interval to reduce PLL gain with low sampling rate (e.g.
intermittent network connection) to avoid instability.

The clamp roughly corresponds to the loop time constant, it's 8 * poll
interval for SHIFT_PLL 2 and 32 * poll interval for SHIFT_PLL 4. This
gives good results without affecting the gain in normal conditions where
ntpd skips only up to seven consecutive samples.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
---
 kernel/time/ntp.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index c631168..d232189 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -149,10 +149,18 @@ static void ntp_update_offset(long offset)
 	time_reftime = get_seconds();
 
 	offset64    = offset;
-	freq_adj    = (offset64 * secs) <<
-			(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant));
+	freq_adj    = ntp_update_offset_fll(offset64, secs);
 
-	freq_adj    += ntp_update_offset_fll(offset64, secs);
+	/*
+	 * Clamp update interval to reduce PLL gain with low
+	 * sampling rate (e.g. intermittent network connection)
+	 * to avoid instability.
+	 */
+	if (unlikely(secs > 1 << (SHIFT_PLL + 1 + time_constant)))
+		secs = 1 << (SHIFT_PLL + 1 + time_constant);
+
+	freq_adj    += (offset64 * secs) <<
+			(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant));
 
 	freq_adj    = min(freq_adj + time_freq, MAXFREQ_SCALED);
 
-- 
1.7.2

