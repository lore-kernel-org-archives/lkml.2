Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340Ab2GKVnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:43:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2GKVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:43:43 -0400
Date: Wed, 11 Jul 2012 14:43:26 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-196951e91262fccda81147d2bcf7fdab08668b40@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        johnstul@us.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, tglx@linutronix.de,
        prarit@redhat.com
In-Reply-To: <1341960205-56738-6-git-send-email-johnstul@us.ibm.com>
References: <1341960205-56738-6-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimers:
  Move lock held region in hrtimer_interrupt()
Git-Commit-ID: 196951e91262fccda81147d2bcf7fdab08668b40
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 11 Jul 2012 14:43:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  196951e91262fccda81147d2bcf7fdab08668b40
Gitweb:     http://git.kernel.org/tip/196951e91262fccda81147d2bcf7fdab08668b40
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 10 Jul 2012 18:43:23 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 11 Jul 2012 23:34:38 +0200

hrtimers: Move lock held region in hrtimer_interrupt()

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
---
 kernel/hrtimer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3c24fb2..8f320af 100644
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
