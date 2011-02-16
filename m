Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab1BPNuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:50:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:52690 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab1BPNuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:50:03 -0500
Date: Wed, 16 Feb 2011 13:49:43 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize throttling code
Message-ID: <tip-163ec4354a5135c6c38c3f4a9b46a31900ebdf48@git.kernel.org>
Git-Commit-ID: 163ec4354a5135c6c38c3f4a9b46a31900ebdf48
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 13:49:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  163ec4354a5135c6c38c3f4a9b46a31900ebdf48
Gitweb:     http://git.kernel.org/tip/163ec4354a5135c6c38c3f4a9b46a31900ebdf48
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Feb 2011 11:22:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 13:30:55 +0100

perf: Optimize throttling code

By pre-computing the maximum number of samples per tick we can avoid a
multiplication and a conditional since MAX_INTERRUPTS >
max_samples_per_tick.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    4 ++++
 kernel/perf_event.c        |   43 ++++++++++++++++++++++++-------------------
 kernel/sysctl.c            |    2 +-
 3 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 38c8b25..8ceb5a6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1110,6 +1110,10 @@ extern int sysctl_perf_event_paranoid;
 extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
 
+extern int perf_proc_update_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
 static inline bool perf_paranoid_tracepoint_raw(void)
 {
 	return sysctl_perf_event_paranoid > -1;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 65dcdc7..e03be08 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -150,7 +150,24 @@ int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
 /*
  * max perf event sample rate
  */
-int sysctl_perf_event_sample_rate __read_mostly = 100000;
+#define DEFAULT_MAX_SAMPLE_RATE 100000
+int sysctl_perf_event_sample_rate __read_mostly = DEFAULT_MAX_SAMPLE_RATE;
+static int max_samples_per_tick __read_mostly =
+	DIV_ROUND_UP(DEFAULT_MAX_SAMPLE_RATE, HZ);
+
+int perf_proc_update_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret = proc_dointvec(table, write, buffer, lenp, ppos);
+
+	if (ret || !write)
+		return ret;
+
+	max_samples_per_tick = DIV_ROUND_UP(sysctl_perf_event_sample_rate, HZ);
+
+	return 0;
+}
 
 static atomic64_t perf_event_id;
 
@@ -4941,26 +4958,14 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 	if (unlikely(!is_sampling_event(event)))
 		return 0;
 
-	if (!throttle) {
-		hwc->interrupts++;
-	} else {
-		if (hwc->interrupts != MAX_INTERRUPTS) {
-			hwc->interrupts++;
-			if (HZ * hwc->interrupts >
-					(u64)sysctl_perf_event_sample_rate) {
-				hwc->interrupts = MAX_INTERRUPTS;
-				perf_log_throttle(event, 0);
-				ret = 1;
-			}
-		} else {
-			/*
-			 * Keep re-disabling events even though on the previous
-			 * pass we disabled it - just in case we raced with a
-			 * sched-in and the event got enabled again:
-			 */
+	if (unlikely(hwc->interrupts >= max_samples_per_tick)) {
+		if (throttle) {
+			hwc->interrupts = MAX_INTERRUPTS;
+			perf_log_throttle(event, 0);
 			ret = 1;
 		}
-	}
+	} else
+		hwc->interrupts++;
 
 	if (event->attr.freq) {
 		u64 now = perf_clock();
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0f1bd83..daef911 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -948,7 +948,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_perf_event_sample_rate,
 		.maxlen		= sizeof(sysctl_perf_event_sample_rate),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= perf_proc_update_handler,
 	},
 #endif
 #ifdef CONFIG_KMEMCHECK
