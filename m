Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2GJWoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:44:01 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43504 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab2GJWn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:43:58 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 4/6] hrtimers: Move lock held region in hrtimer_interrupt()
Date: Tue, 10 Jul 2012 18:43:23 -0400
Message-Id: <1341960205-56738-6-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071022-4242-0000-0000-000002474F64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

We need to update the base offsets from this code and we need to do
that under base->lock. Move the lock held region around the
ktime_get() calls. The ktime_get() calls are going to be replaced with
a function which gets the time and the offsets atomically.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/hrtimer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 7c20cb8..14a260a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1263,11 +1263,10 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	cpu_base->nr_events++;
 	dev->next_event.tv64 = KTIME_MAX;
 
+	raw_spin_lock(&cpu_base->lock);
 	entry_time = now = ktime_get();
 retry:
 	expires_next.tv64 = KTIME_MAX;
-
-	raw_spin_lock(&cpu_base->lock);
 	/*
 	 * We set expires_next to KTIME_MAX here with cpu_base->lock
 	 * held to prevent that a timer is enqueued in our queue via
@@ -1344,6 +1343,7 @@ retry:
 	 * interrupt routine. We give it 3 attempts to avoid
 	 * overreacting on some spurious event.
 	 */
+	raw_spin_lock(&cpu_base->lock);
 	now = ktime_get();
 	cpu_base->nr_retries++;
 	if (++retries < 3)
@@ -1356,6 +1356,7 @@ retry:
 	 */
 	cpu_base->nr_hangs++;
 	cpu_base->hang_detected = 1;
+	raw_spin_unlock(&cpu_base->lock);
 	delta = ktime_sub(now, entry_time);
 	if (delta.tv64 > cpu_base->max_hang_time.tv64)
 		cpu_base->max_hang_time = delta;
-- 
1.7.9.5

