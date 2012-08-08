Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030407Ab2HHSKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:10:46 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53626 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758513Ab2HHSKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:10:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] timer: generalize timer->base flags handling
Date: Wed,  8 Aug 2012 11:10:25 -0700
Message-Id: <1344449428-24962-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344449428-24962-1-git-send-email-tj@kernel.org>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prepare for addition of another flag, generalize timer->base flags
handling.

* Rename from TBASE_*_FLAG to TIMER_* and make them LU constants.

* Define and use TIMER_FLAG_MASK for flags masking so that multiple
  flags can be handled correctly.

* Don't dereference timer->base directly even if
  !tbase_get_deferrable().  All two such places are already passed in
  @base, so use it instead.

* Make sure tvec_base's alignment is large enough for timer->base
  flags using BUILD_BUG_ON().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/timer.h |    6 ++++--
 kernel/timer.c        |   21 +++++++++++++--------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 6abd913..cbd32ec 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -58,7 +58,9 @@ extern struct tvec_base boot_tvec_bases;
  * the timer will be serviced when the CPU eventually wakes up with a
  * subsequent non-deferrable timer.
  */
-#define TBASE_DEFERRABLE_FLAG		(0x1)
+#define TIMER_DEFERRABLE		0x1LU
+
+#define TIMER_FLAG_MASK			0x1LU
 
 #define TIMER_INITIALIZER(_function, _expires, _data) {		\
 		.entry = { .prev = TIMER_ENTRY_STATIC },	\
@@ -72,7 +74,7 @@ extern struct tvec_base boot_tvec_bases;
 	}
 
 #define TBASE_MAKE_DEFERRED(ptr) ((struct tvec_base *)		\
-		  ((unsigned char *)(ptr) + TBASE_DEFERRABLE_FLAG))
+		  ((unsigned char *)(ptr) + TIMER_DEFERRABLE))
 
 #define TIMER_DEFERRED_INITIALIZER(_function, _expires, _data) {\
 		.entry = { .prev = TIMER_ENTRY_STATIC },	\
diff --git a/kernel/timer.c b/kernel/timer.c
index a61c093..cf7af56 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -92,12 +92,12 @@ static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
 {
-	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
+	return ((unsigned int)(unsigned long)base & TIMER_DEFERRABLE);
 }
 
 static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
 {
-	return ((struct tvec_base *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
+	return ((struct tvec_base *)((unsigned long)base & ~TIMER_FLAG_MASK));
 }
 
 static inline void timer_set_deferrable(struct timer_list *timer)
@@ -108,8 +108,9 @@ static inline void timer_set_deferrable(struct timer_list *timer)
 static inline void
 timer_set_base(struct timer_list *timer, struct tvec_base *new_base)
 {
-	timer->base = (struct tvec_base *)((unsigned long)(new_base) |
-				      tbase_get_deferrable(timer->base));
+	unsigned long flags = (unsigned long)timer->base & TIMER_FLAG_MASK;
+
+	timer->base = (struct tvec_base *)((unsigned long)(new_base) | flags);
 }
 
 static unsigned long round_jiffies_common(unsigned long j, int cpu,
@@ -686,7 +687,7 @@ detach_expired_timer(struct timer_list *timer, struct tvec_base *base)
 {
 	detach_timer(timer, true);
 	if (!tbase_get_deferrable(timer->base))
-		timer->base->active_timers--;
+		base->active_timers--;
 }
 
 static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
@@ -697,7 +698,7 @@ static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
 
 	detach_timer(timer, clear_pending);
 	if (!tbase_get_deferrable(timer->base)) {
-		timer->base->active_timers--;
+		base->active_timers--;
 		if (timer->expires == base->next_timer)
 			base->next_timer = base->timer_jiffies;
 	}
@@ -1800,9 +1801,13 @@ static struct notifier_block __cpuinitdata timers_nb = {
 
 void __init init_timers(void)
 {
-	int err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
-				(void *)(long)smp_processor_id());
+	int err;
+
+	/* ensure there are enough low bits for flags in timer->base pointer */
+	BUILD_BUG_ON(__alignof__(struct tvec_base) & TIMER_FLAG_MASK);
 
+	err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
+			       (void *)(long)smp_processor_id());
 	init_timer_stats();
 
 	BUG_ON(err != NOTIFY_OK);
-- 
1.7.7.3

