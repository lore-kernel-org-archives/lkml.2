Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0JUOUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:20:44 -0400
Received: from www.tglx.de ([62.245.132.106]:41813 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab0JUOUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:20:42 -0400
Date: Thu, 21 Oct 2010 16:20:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timer updates for 2.6.37
Message-ID: <alpine.LFD.2.00.1010211619470.2418@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

Thanks,

	tglx

------------------>
Miroslav Lichvar (1):
      ntp: Clamp PLL update interval


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
 
