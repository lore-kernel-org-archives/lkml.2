Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab2GKVl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:41:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab2GKVlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:41:25 -0400
Date: Wed, 11 Jul 2012 14:40:41 -0700
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Message-ID: <tip-f55a6faa384304c89cfef162768e88374d3312cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, jengelh@inai.de,
        tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        jengelh@inai.de, prarit@redhat.com
In-Reply-To: <1341960205-56738-2-git-send-email-johnstul@us.ibm.com>
References: <1341960205-56738-2-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer: Provide clock_was_set_delayed()
Git-Commit-ID: f55a6faa384304c89cfef162768e88374d3312cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 11 Jul 2012 14:40:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f55a6faa384304c89cfef162768e88374d3312cb
Gitweb:     http://git.kernel.org/tip/f55a6faa384304c89cfef162768e88374d3312cb
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 10 Jul 2012 18:43:19 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 11 Jul 2012 23:34:37 +0200

hrtimer: Provide clock_was_set_delayed()

clock_was_set() cannot be called from hard interrupt context because
it calls on_each_cpu().

For fixing the widely reported leap seconds issue it is necessary to
call it from hard interrupt context, i.e. the timer tick code, which
does the timekeeping updates.

Provide a new function which denotes it in the hrtimer cpu base
structure of the cpu on which it is called and raise the hrtimer
softirq. We then execute the clock_was_set() notificiation from
softirq context in run_hrtimer_softirq(). The hrtimer softirq is
rarely used, so polling the flag there is not a performance issue.

[ tglx: Made it depend on CONFIG_HIGH_RES_TIMERS. We really should get
  rid of all this ifdeffery ASAP ]

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1341960205-56738-2-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h |    9 ++++++++-
 kernel/hrtimer.c        |   20 ++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0dc30..c9ec940 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -165,6 +165,7 @@ enum  hrtimer_base_type {
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
  * @active_bases:	Bitfield to mark bases with active timers
+ * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
  * @hres_active:	State of high resolution mode
@@ -177,7 +178,8 @@ enum  hrtimer_base_type {
  */
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
-	unsigned long			active_bases;
+	unsigned int			active_bases;
+	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
 	int				hres_active;
@@ -286,6 +288,8 @@ extern void hrtimer_peek_ahead_timers(void);
 # define MONOTONIC_RES_NSEC	HIGH_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_HIGH_RES
 
+extern void clock_was_set_delayed(void);
+
 #else
 
 # define MONOTONIC_RES_NSEC	LOW_RES_NSEC
@@ -306,6 +310,9 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 {
 	return 0;
 }
+
+static inline void clock_was_set_delayed(void) { }
+
 #endif
 
 extern void clock_was_set(void);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ae34bf5..3c24fb2 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -717,6 +717,19 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
+/*
+ * Called from timekeeping code to reprogramm the hrtimer interrupt
+ * device. If called from the timer interrupt context we defer it to
+ * softirq context.
+ */
+void clock_was_set_delayed(void)
+{
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	cpu_base->clock_was_set = 1;
+	__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+}
+
 #else
 
 static inline int hrtimer_hres_active(void) { return 0; }
@@ -1395,6 +1408,13 @@ void hrtimer_peek_ahead_timers(void)
 
 static void run_hrtimer_softirq(struct softirq_action *h)
 {
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	if (cpu_base->clock_was_set) {
+		cpu_base->clock_was_set = 0;
+		clock_was_set();
+	}
+
 	hrtimer_peek_ahead_timers();
 }
 
