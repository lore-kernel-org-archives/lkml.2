Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab0EQRSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:18:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:13158 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244Ab0EQRSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:18:22 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 3/3] posix_timer: move copy_to_user(created_timer_id) down in timer_create
Date: Mon, 17 May 2010 21:18:08 +0400
Message-Id: <1274116688-4037-3-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1274116688-4037-2-git-send-email-avagin@openvz.org>
References: <1274116688-4037-1-git-send-email-avagin@openvz.org>
 <1274116688-4037-2-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Oleg Nesterov:
We can move copy_to_user(created_timer_id) down after
"if (timer_event_spec)" block too. (but before CLOCK_DISPATCH(),
of course).

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/posix-timers.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index ad72342..9ca4973 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -560,11 +560,6 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->it_clock = which_clock;
 	new_timer->it_overrun = -1;
 
-	if (copy_to_user(created_timer_id,
-			 &new_timer_id, sizeof (new_timer_id))) {
-		error = -EFAULT;
-		goto out;
-	}
 	if (timer_event_spec) {
 		if (copy_from_user(&event, timer_event_spec, sizeof (event))) {
 			error = -EFAULT;
@@ -590,6 +585,12 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->sigq->info.si_tid   = new_timer->it_id;
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
+	if (copy_to_user(created_timer_id,
+			 &new_timer_id, sizeof (new_timer_id))) {
+		error = -EFAULT;
+		goto out;
+	}
+
 	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
 	if (error)
 		goto out;
-- 
1.6.6

