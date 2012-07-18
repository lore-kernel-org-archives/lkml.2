Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab2GRAH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:07:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58885 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab2GRAFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:05:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: [ 33/37] hrtimers: Move lock held region in hrtimer_interrupt()
Date: Tue, 17 Jul 2012 17:03:10 -0700
Message-Id: <20120717232434.162827297@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/1341960205-56738-6-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/hrtimer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1263,11 +1263,10 @@ void hrtimer_interrupt(struct clock_even
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


