Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab2JAXAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:00:37 -0400
Received: from 1wt.eu ([62.212.114.60]:35165 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643Ab2JAXA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:29 -0400
Message-Id: <20121001225158.251922085@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 015/180] 2.6.32.x: hrtimers: Move lock held region in hrtimer_interrupt()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/hrtimer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index c4acec7..8ba6d31 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1263,11 +1263,10 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	cpu_base->nr_events++;
 	dev->next_event.tv64 = KTIME_MAX;
 
+	spin_lock(&cpu_base->lock);
 	entry_time = now = ktime_get();
 retry:
 	expires_next.tv64 = KTIME_MAX;
-
-	spin_lock(&cpu_base->lock);
 	/*
 	 * We set expires_next to KTIME_MAX here with cpu_base->lock
 	 * held to prevent that a timer is enqueued in our queue via
@@ -1342,6 +1341,7 @@ retry:
 	 * interrupt routine. We give it 3 attempts to avoid
 	 * overreacting on some spurious event.
 	 */
+	spin_lock(&cpu_base->lock);
 	now = ktime_get();
 	cpu_base->nr_retries++;
 	if (++retries < 3)
@@ -1354,6 +1354,7 @@ retry:
 	 */
 	cpu_base->nr_hangs++;
 	cpu_base->hang_detected = 1;
+	spin_unlock(&cpu_base->lock);
 	delta = ktime_sub(now, entry_time);
 	if (delta.tv64 > cpu_base->max_hang_time.tv64)
 		cpu_base->max_hang_time = delta;
-- 
1.7.2.1.45.g54fbc



