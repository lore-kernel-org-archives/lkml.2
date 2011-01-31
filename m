Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1AaOJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:09:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:42592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab1AaOJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:09:24 -0500
Date: Mon, 31 Jan 2011 14:09:03 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tony.luck@intel.com, torbenh@gmx.de,
        fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tony.luck@intel.com, torbenh@gmx.de,
        fenghua.yu@intel.com, tglx@linutronix.de
In-Reply-To: <20110127145956.23248.49107.stgit@localhost>
References: <20110127145956.23248.49107.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] ia64: Switch do_timer() to xtime_update()
Message-ID: <tip-1aabd67d2e97e6affdf5a7c65f442ac91ace3f85@git.kernel.org>
Git-Commit-ID: 1aabd67d2e97e6affdf5a7c65f442ac91ace3f85
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:09:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1aabd67d2e97e6affdf5a7c65f442ac91ace3f85
Gitweb:     http://git.kernel.org/tip/1aabd67d2e97e6affdf5a7c65f442ac91ace3f85
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:56 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:45 +0100

ia64: Switch do_timer() to xtime_update()

local_cpu_data->itm_next = new_itm; does not need to be protected by
xtime_lock. xtime_update() takes the lock itself.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: hch@infradead.org
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127145956.23248.49107.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/kernel/time.c |   19 +++++--------------
 arch/ia64/xen/time.c    |   13 +++++--------
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 9702fa9..156ad80 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -190,19 +190,10 @@ timer_interrupt (int irq, void *dev_id)
 
 		new_itm += local_cpu_data->itm_delta;
 
-		if (smp_processor_id() == time_keeper_id) {
-			/*
-			 * Here we are in the timer irq handler. We have irqs locally
-			 * disabled, but we don't know if the timer_bh is running on
-			 * another CPU. We need to avoid to SMP race by acquiring the
-			 * xtime_lock.
-			 */
-			write_seqlock(&xtime_lock);
-			do_timer(1);
-			local_cpu_data->itm_next = new_itm;
-			write_sequnlock(&xtime_lock);
-		} else
-			local_cpu_data->itm_next = new_itm;
+		if (smp_processor_id() == time_keeper_id)
+			xtime_update(1);
+
+		local_cpu_data->itm_next = new_itm;
 
 		if (time_after(new_itm, ia64_get_itc()))
 			break;
@@ -222,7 +213,7 @@ skip_process_time_accounting:
 		 * comfort, we increase the safety margin by
 		 * intentionally dropping the next tick(s).  We do NOT
 		 * update itm.next because that would force us to call
-		 * do_timer() which in turn would let our clock run
+		 * xtime_update() which in turn would let our clock run
 		 * too fast (with the potentially devastating effect
 		 * of losing monotony of time).
 		 */
diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
index c1c5445..1f8244a 100644
--- a/arch/ia64/xen/time.c
+++ b/arch/ia64/xen/time.c
@@ -139,14 +139,11 @@ consider_steal_time(unsigned long new_itm)
 		run_posix_cpu_timers(p);
 		delta_itm += local_cpu_data->itm_delta * (stolen + blocked);
 
-		if (cpu == time_keeper_id) {
-			write_seqlock(&xtime_lock);
-			do_timer(stolen + blocked);
-			local_cpu_data->itm_next = delta_itm + new_itm;
-			write_sequnlock(&xtime_lock);
-		} else {
-			local_cpu_data->itm_next = delta_itm + new_itm;
-		}
+		if (cpu == time_keeper_id)
+			xtime_update(stolen + blocked);
+
+		local_cpu_data->itm_next = delta_itm + new_itm;
+
 		per_cpu(xen_stolen_time, cpu) += NS_PER_TICK * stolen;
 		per_cpu(xen_blocked_time, cpu) += NS_PER_TICK * blocked;
 	}
