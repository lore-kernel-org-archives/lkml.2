Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab0ENNdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 09:33:52 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:13799 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab0ENNdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 09:33:51 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>,
       Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 2/2] posix_timer: clean up properly if anything fails after *_timer_create
Date: Fri, 14 May 2010 17:28:51 +0400
Message-Id: <1273843731-12595-2-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1273843731-12595-1-git-send-email-avagin@openvz.org>
References: <1273843731-12595-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*_timer_create may allocate/get some resources, so need call *_timer_cleanup.

https://bugzilla.sw.ru/show_bug.cgi?id=473702

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/posix-timers.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 1195668..8d7cb0e 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -574,19 +574,19 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	if (copy_to_user(created_timer_id,
 			 &new_timer_id, sizeof (new_timer_id))) {
 		error = -EFAULT;
-		goto out;
+		goto out_cleanup;
 	}
 	if (timer_event_spec) {
 		if (copy_from_user(&event, timer_event_spec, sizeof (event))) {
 			error = -EFAULT;
-			goto out;
+			goto out_cleanup;
 		}
 		rcu_read_lock();
 		new_timer->it_pid = get_pid(good_sigevent(&event));
 		rcu_read_unlock();
 		if (!new_timer->it_pid) {
 			error = -EINVAL;
-			goto out;
+			goto out_cleanup;
 		}
 	} else {
 		event.sigev_notify = SIGEV_SIGNAL;
@@ -613,6 +613,8 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	 * and may cease to exist at any time.  Don't use or modify
 	 * new_timer after the unlock call.
 	 */
+out_cleanup:
+	CLOCK_DISPATCH(new_timer->it_clock, timer_cleanup, (new_timer));
 out:
 	release_posix_timer(new_timer, it_id_set);
 	return error;
-- 
1.6.6

