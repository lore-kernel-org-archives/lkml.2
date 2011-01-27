Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1A0O7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:59:13 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45911 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751727Ab1A0O7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:10 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+xpxZtS4qx652juaK1NPmcXdVTtd6z3sMz4q6PIY
	pcUbmJVgYJdVid
Subject: [PATCH v2 03/20] provide get_xtime_and_monotonic_offset() and use it
	in hrtimer.c
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>, yong.zhang0@gmail.com,
        hch@infradead.org
Date: Thu, 27 Jan 2011 15:59:05 +0100
Message-ID: <20110127145905.23248.30458.stgit@localhost>
In-Reply-To: <20110127145741.23248.68098.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2 places in hrtimer need to take the xtime_lock, but we want it
to be private to kernel/time...

we just provide a function, which gets the values with proper
read locking the xtime_lock.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 include/linux/time.h      |    1 +
 kernel/hrtimer.c          |   12 ++----------
 kernel/time/timekeeping.c |   21 +++++++++++++++++++++
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 86a9c48..b9b2f5b 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -127,6 +127,7 @@ struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
 struct timespec __get_wall_to_monotonic(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
+void get_xtime_and_monotonic_offset(struct timespec *xts, struct timespec *tom);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..6ef9d47 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -85,13 +85,8 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
 	ktime_t xtim, tomono;
 	struct timespec xts, tom;
-	unsigned long seq;
 
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		xts = __current_kernel_time();
-		tom = __get_wall_to_monotonic();
-	} while (read_seqretry(&xtime_lock, seq));
+	get_xtime_and_monotonic_offset(&xts, &tom);
 
 	xtim = timespec_to_ktime(xts);
 	tomono = timespec_to_ktime(tom);
@@ -617,10 +612,7 @@ static void retrigger_next_event(void *arg)
 	if (!hrtimer_hres_active())
 		return;
 
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		wtm = __get_wall_to_monotonic();
-	} while (read_seqretry(&xtime_lock, seq));
+	get_xtime_and_monotonic_offset(NULL, &wtm);
 	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
 
 	base = &__get_cpu_var(hrtimer_bases);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e4fd957..6085fa5 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -957,3 +957,24 @@ void do_timer(unsigned long ticks)
 	jiffies_64 += ticks;
 	update_wall_time();
 }
+
+/**
+ * get_xtime_and_monotonic_offset() - get xtime and wall_to_monotonic
+ * @xts: pointer to struct timespec, filled with the current_time
+ * @tom: pointer to struct timespec, filled with the wall_to_monotonic offset
+ *
+ * this function does proper locking.
+ * and it allows passing NULL, when one is not interested in the value.
+ */
+void get_xtime_and_monotonic_offset(struct timespec *xts, struct timespec *tom)
+{
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		if (xts)
+			*xts = xtime;
+		if (tom)
+			*tom = wall_to_monotonic;
+	} while (read_seqretry(&xtime_lock, seq));
+}

