Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab1H2Xjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:39:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:2432 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab1H2XjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:39:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,298,1312182000"; 
   d="scan'208";a="46266065"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, eric.dumazet@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/4] posix-timers: Don't disable interrupts in idr_lock
Date: Mon, 29 Aug 2011 16:39:16 -0700
Message-Id: <1314661157-22173-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

idr_lock is only used for modifying a timer and never used from
interrupts, only from process context. So don't disable interrupts
while taking that lock.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/posix-timers.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index ef6721c..320659d 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -503,10 +503,9 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
 	if (it_id_set) {
 		struct signal_struct *s = current->signal;
-		unsigned long flags;
-		spin_lock_irqsave(&s->idr_lock, flags);
+		spin_lock(&s->idr_lock);
 		idr_remove(&s->posix_timers_id, tmr->it_id);
-		spin_unlock_irqrestore(&s->idr_lock, flags);
+		spin_unlock(&s->idr_lock);
 	}
 	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
@@ -558,9 +557,9 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		error = -EAGAIN;
 		goto out;
 	}
-	spin_lock_irq(&s->idr_lock);
+	spin_lock(&s->idr_lock);
 	error = idr_get_new(&s->posix_timers_id, new_timer, &new_timer_id);
-	spin_unlock_irq(&s->idr_lock);
+	spin_unlock(&s->idr_lock);
 	if (error) {
 		if (error == -EAGAIN)
 			goto retry;
-- 
1.7.4.4

