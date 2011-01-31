Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1AaOEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:04:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:46455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab1AaOEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:04:51 -0500
Date: Mon, 31 Jan 2011 14:04:40 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110127145905.23248.30458.stgit@localhost>
References: <20110127145905.23248.30458.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Provide get_xtime_and_monotonic_offset()
Message-ID: <tip-48cf76f7104f655bbd48a75c7759dce82c3e1ab6@git.kernel.org>
Git-Commit-ID: 48cf76f7104f655bbd48a75c7759dce82c3e1ab6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:04:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48cf76f7104f655bbd48a75c7759dce82c3e1ab6
Gitweb:     http://git.kernel.org/tip/48cf76f7104f655bbd48a75c7759dce82c3e1ab6
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:05 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:42 +0100

time: Provide get_xtime_and_monotonic_offset()

The hrtimer code accesses timekeeping variables under
xtime_lock. Provide a sensible accessor function and use it.

[ tglx: Removed the conditionals, unused variable, fixed codingstyle
  	and massaged changelog ]

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: yong.zhang0@gmail.com
Cc: hch@infradead.org
LKML-Reference: <20110127145905.23248.30458.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/time.h      |    1 +
 kernel/hrtimer.c          |   13 ++-----------
 kernel/time/timekeeping.c |   16 ++++++++++++++++
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 86a9c48..4007a12 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -127,6 +127,7 @@ struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
 struct timespec __get_wall_to_monotonic(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
+void get_xtime_and_monotonic_offset(struct timespec *xtim, struct timespec *wtom);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..57c4d33 100644
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
@@ -612,15 +607,11 @@ static void retrigger_next_event(void *arg)
 {
 	struct hrtimer_cpu_base *base;
 	struct timespec realtime_offset, wtm;
-	unsigned long seq;
 
 	if (!hrtimer_hres_active())
 		return;
 
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		wtm = __get_wall_to_monotonic();
-	} while (read_seqretry(&xtime_lock, seq));
+	get_xtime_and_monotonic_offset(&realtime_offset, &wtm);
 	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
 
 	base = &__get_cpu_var(hrtimer_bases);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index c1a178c..c50aaf6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -958,3 +958,19 @@ void do_timer(unsigned long ticks)
 	update_wall_time();
 	calc_global_load(ticks);
 }
+
+/**
+ * get_xtime_and_monotonic_offset() - get xtime and wall_to_monotonic
+ * @xtim:	pointer to timespec to be set with xtime
+ * @wtom:	pointer to timespec to be set with wall_to_monotonic
+ */
+void get_xtime_and_monotonic_offset(struct timespec *xtim, struct timespec *wtom)
+{
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		*xtim = xtime;
+		*wtom = wall_to_monotonic;
+	} while (read_seqretry(&xtime_lock, seq));
+}
