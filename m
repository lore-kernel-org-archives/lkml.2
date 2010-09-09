Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0IISwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:52:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:55688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab0IISwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:52:06 -0400
Date: Thu, 9 Sep 2010 18:51:48 GMT
From: tip-bot for Miroslav Lichvar <mlichvar@redhat.com>
Cc: linux-kernel@vger.kernel.org, mlichvar@redhat.com, hpa@zytor.com,
        mingo@redhat.com, johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, mlichvar@redhat.com,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1283870626-9472-1-git-send-email-mlichvar@redhat.com>
References: <1283870626-9472-1-git-send-email-mlichvar@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] ntp: Clamp PLL update interval
Message-ID: <tip-8af3c153baf95374eff20a37f00c59a295b52756@git.kernel.org>
Git-Commit-ID: 8af3c153baf95374eff20a37f00c59a295b52756
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 18:51:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8af3c153baf95374eff20a37f00c59a295b52756
Gitweb:     http://git.kernel.org/tip/8af3c153baf95374eff20a37f00c59a295b52756
Author:     Miroslav Lichvar <mlichvar@redhat.com>
AuthorDate: Tue, 7 Sep 2010 16:43:46 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Sep 2010 20:48:37 +0200

ntp: Clamp PLL update interval

Clamp update interval to reduce PLL gain with low sampling rate (e.g.
intermittent network connection) to avoid instability.

The clamp roughly corresponds to the loop time constant, it's 8 * poll
interval for SHIFT_PLL 2 and 32 * poll interval for SHIFT_PLL 4. This
gives good results without affecting the gain in normal conditions where
ntpd skips only up to seven consecutive samples.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Acked-by: john stultz <johnstul@us.ibm.com>
LKML-Reference: <1283870626-9472-1-git-send-email-mlichvar@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
