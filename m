Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2I1HCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:02:34 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42140 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2I1HCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:02:33 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: paul.mckenney@linaro.org, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] timers: Avoid finding cpu for migration of running timers in __mod_timer()
Date: Fri, 28 Sep 2012 12:32:19 +0530
Message-Id: <afe8e64629bac4572c0328e8e8a651b2b7ccca7f.1348815553.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 28 Sep 2012 07:02:30.0049 (UTC) FILETIME=[39BC4110:01CD9D47]
X-MC-Unique: 112092808023105501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8S72cUx009675

Currently we don't support migration of currently running timers. Current code
flow in __mod_timer() is:
- Find a cpu where we should migrate the timer
- Check if timer is currently running
- If yes, don't migrate.

In this process, the first step is a unnecessary activiy, if the timer is
currently running. This patch tries to avoid it in such cases.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/timer.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 8c5e7b9..6e5bf98 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -755,23 +755,23 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	debug_activate(timer, expires);
 
-	cpu = smp_processor_id();
+	/*
+	 * Should we try to migrate timer?
+	 * However we can't change timer's base while it is running, otherwise
+	 * del_timer_sync() can't detect that the timer's handler yet has not
+	 * finished. This also guarantees that the timer is serialized wrt
+	 * itself.
+	 */
+	if (likely(base->running_timer != timer)) {
+		cpu = smp_processor_id();
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
-		cpu = get_nohz_timer_target();
+		if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
+			cpu = get_nohz_timer_target();
 #endif
-	new_base = per_cpu(tvec_bases, cpu);
+		new_base = per_cpu(tvec_bases, cpu);
 
-	if (base != new_base) {
-		/*
-		 * We are trying to schedule the timer on the local CPU.
-		 * However we can't change timer's base while it is running,
-		 * otherwise del_timer_sync() can't detect that the timer's
-		 * handler yet has not finished. This also guarantees that
-		 * the timer is serialized wrt itself.
-		 */
-		if (likely(base->running_timer != timer)) {
+		if (base != new_base) {
 			/* See the comment in lock_timer_base() */
 			timer_set_base(timer, NULL);
 			spin_unlock(&base->lock);
-- 
1.7.12.rc2.18.g61b472e


