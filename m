Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0LaTMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 14:12:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45845 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0LaTMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 14:12:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e/LCis22shNTCOc/OR0srTR7R90Af//jdmxOwqJyhmSsILBroj75JEhH+wbphdtNJ7
         CBblGrdkvcywpuyMwxcvFqbbU2OHOaQYKhxoQrHvnVj0Smz9M3oLBREHpgRJQf9feE2P
         vaCoGXPVNDCvWi+ClN6+VP+hND6zLZ3vX/xn8=
Date: Fri, 31 Dec 2010 20:12:06 +0100
From: John Stultz <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH V8 01/13] time: Introduce timekeeping_inject_offset
Message-ID: <15a12892b0bfc17327d2b3a7695c81fbe6f34337.1293820862.git.richard.cochran@omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1293820862.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a kernel-internal timekeeping interface to add or subtract
a fixed amount from CLOCK_REALTIME. This makes it so kernel users or
interfaces trying to do so do not have to read the time, then add an
offset and then call settimeofday(), which adds some extra error in
comparision to just simply adding the offset in the kernel timekeeping
core.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Cochran <richard.cochran@omicron.at>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/time.h      |    1 +
 kernel/time/timekeeping.c |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 9f15ac7..b402134 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -166,6 +166,7 @@ extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
 extern void update_wall_time(void);
 extern void timekeeping_leap_insert(int leapsecond);
+extern int timekeeping_inject_offset(struct timespec *ts);
 
 struct tms;
 extern void do_sys_times(struct tms *);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 49010d8..77e79b3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -340,6 +340,42 @@ int do_settimeofday(struct timespec *tv)
 
 EXPORT_SYMBOL(do_settimeofday);
 
+
+/**
+ * timekeeping_inject_offset - Adds or subtracts from the current time.
+ * @tv:		pointer to the timespec variable containing the offset
+ *
+ * Adds or subtracts an offset value from the current time.
+ */
+int timekeeping_inject_offset(struct timespec *ts)
+{
+	unsigned long flags;
+
+	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
+		return -EINVAL;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	timekeeping_forward_now();
+
+	xtime = timespec_add(xtime, *ts);
+	wall_to_monotonic = timespec_sub(wall_to_monotonic, *ts);
+
+	timekeeper.ntp_error = 0;
+	ntp_clear();
+
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	/* signal hrtimers about time change */
+	clock_was_set();
+
+	return 0;
+}
+EXPORT_SYMBOL(timekeeping_inject_offset);
+
 /**
  * change_clocksource - Swaps clocksources if a new one is available
  *
-- 
1.7.0.4

