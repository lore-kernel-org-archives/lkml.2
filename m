Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab0LPPmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:42:10 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:45616 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab0LPPmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:42:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jdfqAjF0aAhs4PVTTil08hOZl5asLeurUV4QFn6Wl2CBI0MBf5M+fPwaeZUAFYNzIQ
         7DqtDqCrw8OTE/r3Q0yoxnWsblMb5PT4mPIDBGcc+JAhgFK0VV8lUM60nr3Y1EQcAQxR
         jW9iNJDkcDpLpuQgWVk2Jp10eH3PTgiepUlKk=
Date: Thu, 16 Dec 2010 16:41:59 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
References: <cover.1292512461.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1292512461.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new mode bit into the timex structure. When set, the bit
instructs the kernel to add the given time value to the current time.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/timex.h |    3 ++-
 kernel/time/ntp.c     |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 32d852f..82d4b24 100644
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
@@ -101,6 +101,7 @@ struct timex {
 #define ADJ_ESTERROR		0x0008	/* estimated time error */
 #define ADJ_STATUS		0x0010	/* clock status */
 #define ADJ_TIMECONST		0x0020	/* pll time constant */
+#define ADJ_SETOFFSET		0x0040  /* add 'time' to current time */
 #define ADJ_TAI			0x0080	/* set TAI offset */
 #define ADJ_MICRO		0x1000	/* select microsecond resolution */
 #define ADJ_NANO		0x2000	/* select nanosecond resolution */
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index d232189..e9e3915 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -454,6 +454,7 @@ static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts
 int do_adjtimex(struct timex *txc)
 {
 	struct timespec ts;
+	ktime_t delta, kt;
 	int result;
 
 	/* Validate the data before disabling interrupts */
@@ -482,8 +483,33 @@ int do_adjtimex(struct timex *txc)
 			hrtimer_cancel(&leap_timer);
 	}
 
+	if (txc->modes & ADJ_SETOFFSET) {
+		/* Validate the delta value. */
+		if (txc->time.tv_sec && txc->time.tv_usec < 0)
+			return -EINVAL;
+
+		if (txc->modes & ADJ_NANO) {
+			struct timespec tmp;
+			tmp.tv_sec  = txc->time.tv_sec;
+			tmp.tv_nsec = txc->time.tv_usec;
+			delta = timespec_to_ktime(tmp);
+		} else
+			delta = timeval_to_ktime(txc->time);
+
+		/* Adding the delta should be an "atomic" operation. */
+		local_irq_disable();
+	}
+
 	getnstimeofday(&ts);
 
+	if (txc->modes & ADJ_SETOFFSET) {
+		kt = timespec_to_ktime(ts);
+		kt = ktime_add(kt, delta);
+		ts = ktime_to_timespec(kt);
+		do_settimeofday(&ts);
+		local_irq_enable();
+	}
+
 	write_seqlock_irq(&xtime_lock);
 
 	if (txc->modes & ADJ_ADJTIME) {
-- 
1.7.0.4

