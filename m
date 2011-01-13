Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab1AMLcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 06:32:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39048 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891Ab1AMLcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 06:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jLfLLPubSvNcUZ9wp8tx8TTwtX1FeQZgIDvTkwDOz4d2suXecYnliJiSd2gaZGlHwA
         0M5YS9QBs/WQdG7dVAQQCzEH04uBCBan/vquIgpj/AgHKeyFAPVk0dPSr4+i3FVjaQEj
         iH+MmNbKJipMcnuMpk8HcbnrDZI5UJSQRYbJ8=
Date: Thu, 13 Jan 2011 12:32:20 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH V9 02/13] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <60566a54842bcf5974d55ed39f387c32ff9cf5cb.1294917348.git.richard.cochran@omicron.at>
References: <cover.1294917347.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1294917347.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new mode bit into the timex structure. When set, the bit
instructs the kernel to add the given time value to the current time.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/timex.h |    3 ++-
 kernel/time/ntp.c     |   11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 32d852f..800a2c8 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -73,7 +73,7 @@ struct timex {
 	long tolerance;		/* clock frequency tolerance (ppm)
 				 * (read only)
 				 */
-	struct timeval time;	/* (read only) */
+	struct timeval time;	/* (read only, except for ADJ_SETOFFSET) */
 	long tick;		/* (modified) usecs between clock ticks */
 
 	long ppsfreq;           /* pps frequency (scaled ppm) (ro) */
@@ -102,6 +102,7 @@ struct timex {
 #define ADJ_STATUS		0x0010	/* clock status */
 #define ADJ_TIMECONST		0x0020	/* pll time constant */
 #define ADJ_TAI			0x0080	/* set TAI offset */
+#define ADJ_SETOFFSET		0x0100  /* add 'time' to current time */
 #define ADJ_MICRO		0x1000	/* select microsecond resolution */
 #define ADJ_NANO		0x2000	/* select nanosecond resolution */
 #define ADJ_TICK		0x4000	/* tick value */
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index d232189..0c87858 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -482,6 +482,17 @@ int do_adjtimex(struct timex *txc)
 			hrtimer_cancel(&leap_timer);
 	}
 
+	if (txc->modes & ADJ_SETOFFSET) {
+		struct timespec delta;
+		if ((unsigned long)txc->time.tv_usec >= NSEC_PER_SEC)
+			return -EINVAL;
+		delta.tv_sec  = txc->time.tv_sec;
+		delta.tv_nsec = txc->time.tv_usec;
+		if (!(txc->modes & ADJ_NANO))
+			delta.tv_nsec *= 1000;
+		timekeeping_inject_offset(&delta);
+	}
+
 	getnstimeofday(&ts);
 
 	write_seqlock_irq(&xtime_lock);
-- 
1.7.0.4

