Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0GMC0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:26:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab0GMC0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:26:17 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: [PATCH 15/18] Implement getnsboottime kernel API
Date: Mon, 12 Jul 2010 16:25:35 -1000
Message-Id: <1278987938-23873-16-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a kernel call to get the number of nanoseconds since boot.  This
is generally useful enough to make it a generic call.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 include/linux/time.h      |    1 +
 kernel/time/timekeeping.c |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index ea3559f..5d04108 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -145,6 +145,7 @@ extern void getnstimeofday(struct timespec *tv);
 extern void getrawmonotonic(struct timespec *ts);
 extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
+extern s64 getnsboottime(void);
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index caf8d4d..d250f0a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -285,6 +285,33 @@ void ktime_get_ts(struct timespec *ts)
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
 
+
+/**
+ * getnsboottime - get the bootbased clock in nsec format
+ *
+ * The function calculates the bootbased clock from the realtime
+ * clock and the wall_to_monotonic offset and stores the result
+ * in normalized timespec format in the variable pointed to by @ts.
+ */
+s64 getnsboottime(void)
+{
+	unsigned int seq;
+	s64 secs, nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
+		secs += total_sleep_time.tv_sec;
+		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
+		nsecs += total_sleep_time.tv_nsec + timekeeping_get_ns();
+
+	} while (read_seqretry(&xtime_lock, seq));
+	return nsecs + (secs * NSEC_PER_SEC);
+}
+EXPORT_SYMBOL_GPL(getnsboottime);
+
 /**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
-- 
1.7.1

