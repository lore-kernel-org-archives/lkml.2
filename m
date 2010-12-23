Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab0LWN36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:29:58 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53124 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0LWN35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:29:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=a2m2K9tFpn121BkYSBWoAp8eUGcYTuGFFYmvpYMSdP0mJV+4FHFW47V7MSG4HOWg7E
         95/dxvIs0vrlcZiyG74dKpVHCzPnThcS00qVWyifuLRIO1ld16FycJQPRp19hYFnA+7C
         fZKd2vLQFBa9EDYc1YuJjPV2zOkMEswFOHSP8=
MIME-Version: 1.0
Date: Thu, 23 Dec 2010 21:29:55 +0800
Message-ID: <AANLkTinvHP4rZ6PSyEOJ_ZJ2chRJX0ZyzuhNoCRrO1wK@mail.gmail.com>
Subject: [PATCH] fix unsafe operation in high resolution timer
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After calling the callback function of hrtimer, the timer could become
unreliable in corner cases where the timer will no longer be queued
and the mm segment, in which the timer is embedded, could be reclaimed
in the callback.

The unreliability is fixed by checking the result of callback before
operating the timer again.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/hrtimer.c	2010-11-01 19:54:12.000000000 +0800
+++ b/kernel/hrtimer.c	2010-12-23 21:17:02.000000000 +0800
@@ -1225,6 +1225,7 @@ static void __run_hrtimer(struct hrtimer
 	raw_spin_unlock(&cpu_base->lock);
 	trace_hrtimer_expire_entry(timer, now);
 	restart = fn(timer);
+	if (restart != HRTIMER_NORESTART)
 	trace_hrtimer_expire_exit(timer);
 	raw_spin_lock(&cpu_base->lock);

@@ -1236,11 +1237,8 @@ static void __run_hrtimer(struct hrtimer
 	if (restart != HRTIMER_NORESTART) {
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
 		enqueue_hrtimer(timer, base);
+		timer->state &= ~HRTIMER_STATE_CALLBACK;
 	}
-
-	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
-
-	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }

 #ifdef CONFIG_HIGH_RES_TIMERS
