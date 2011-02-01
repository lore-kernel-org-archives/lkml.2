Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab1BAN4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:56:51 -0500
Received: from www.tglx.de ([62.245.132.106]:47114 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983Ab1BANvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:51:22 -0500
Message-Id: <20110201134417.938447839@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 05/28] posix-timers: Introduce clockid_to_kclock()
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-timers-introduce-clockid-to-kclock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New function to find the kclock for a given clockid.

Returns a pointer to clock_posix_cpu if clockid < 0. If clockid >=
MAXCLOCK or if the clock_getres pointer is not set it returns
-EINVAL. For valid clocks it returns a pointer to the matching
posix_clock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-timers.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -531,6 +531,16 @@ static void release_posix_timer(struct k
 	kmem_cache_free(posix_timers_cache, tmr);
 }
 
+static struct k_clock *clockid_to_kclock(const clockid_t id)
+{
+	if (id < 0)
+		return &clock_posix_cpu;
+
+	if (id >= MAX_CLOCKS || !posix_clocks[id].clock_getres)
+		return NULL;
+	return &posix_clocks[id];
+}
+
 /* Create a POSIX.1b interval timer. */
 
 SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,


