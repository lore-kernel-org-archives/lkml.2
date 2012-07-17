Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab2GQVwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:52:08 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45337 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab2GQVtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:49:53 -0400
From: John Stultz <johnstul@us.ibm.com>
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/11] 2.6.34.x: hrtimers: Move lock held region in hrtimer_interrupt()
Date: Tue, 17 Jul 2012 17:49:28 -0400
Message-Id: <1342561771-55678-9-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342561771-55678-1-git-send-email-johnstul@us.ibm.com>
References: <1342561771-55678-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071721-7606-0000-0000-0000021489C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

This is a backport of 196951e91262fccda81147d2bcf7fdab08668b40

We need to update the base offsets from this code and we need to do
that under base->lock. Move the lock held region around the
ktime_get() calls. The ktime_get() calls are going to be replaced with
a function which gets the time and the offsets atomically.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/1341960205-56738-6-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/hrtimer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index dc41268..039db35 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1279,11 +1279,10 @@ void hrtimer_interrupt(struct clock_event_device *dev)
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
@@ -1358,6 +1357,7 @@ retry:
 	 * interrupt routine. We give it 3 attempts to avoid
 	 * overreacting on some spurious event.
 	 */
+	raw_spin_lock(&cpu_base->lock);
 	now = ktime_get();
 	cpu_base->nr_retries++;
 	if (++retries < 3)
@@ -1370,6 +1370,7 @@ retry:
 	 */
 	cpu_base->nr_hangs++;
 	cpu_base->hang_detected = 1;
+	raw_spin_unlock(&cpu_base->lock);
 	delta = ktime_sub(now, entry_time);
 	if (delta.tv64 > cpu_base->max_hang_time.tv64)
 		cpu_base->max_hang_time = delta;
-- 
1.7.9.5

