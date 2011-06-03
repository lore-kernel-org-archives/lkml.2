Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab1FCNHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:07:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:36364 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab1FCNHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:07:02 -0400
Date: Fri, 3 Jun 2011 13:06:47 GMT
From: tip-bot for Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Message-ID: <tip-1c3cc11602111d1318c2a5743bd2e88c82813927@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sebastian@breakpoint.cc, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sebastian@breakpoint.cc
In-Reply-To: <20110521105828.GA29442@Chamillionaire.breakpoint.cc>
References: <20110521105828.GA29442@Chamillionaire.breakpoint.cc>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timers: Consider slack value in mod_timer()
Git-Commit-ID: 1c3cc11602111d1318c2a5743bd2e88c82813927
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 13:06:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c3cc11602111d1318c2a5743bd2e88c82813927
Gitweb:     http://git.kernel.org/tip/1c3cc11602111d1318c2a5743bd2e88c82813927
Author:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
AuthorDate: Sat, 21 May 2011 12:58:28 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 3 Jun 2011 15:02:32 +0200

timers: Consider slack value in mod_timer()

There is an optimization which does not update the timer if the timer
was pending and the expiration time was unchanged.

Since commit 3bbb9ec9 ("timers: Introduce the concept of timer slack
for legacy timers") this optimization is no longer applied for timers
where the expiration time got extended due to the slack value. So we
need to check again after the expiration time might have been updated.

[ tglx: Made it a single check by applying slack first and sorting
  out the slack = 0 value (all timeouts < 256 jiffies) early ]

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Link: http://lkml.kernel.org/r/20110521105828.GA29442@Chamillionaire.breakpoint.cc
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index fd61986..8cff361 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -749,16 +749,15 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 	unsigned long expires_limit, mask;
 	int bit;
 
-	expires_limit = expires;
-
 	if (timer->slack >= 0) {
 		expires_limit = expires + timer->slack;
 	} else {
-		unsigned long now = jiffies;
+		long delta = expires - jiffies;
+
+		if (delta < 256)
+			return expires;
 
-		/* No slack, if already expired else auto slack 0.4% */
-		if (time_after(expires, now))
-			expires_limit = expires + (expires - now)/256;
+		expires_limit = expires + delta / 256;
 	}
 	mask = expires ^ expires_limit;
 	if (mask == 0)
@@ -795,6 +794,8 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
  */
 int mod_timer(struct timer_list *timer, unsigned long expires)
 {
+	expires = apply_slack(timer, expires);
+
 	/*
 	 * This is a common optimization triggered by the
 	 * networking code - if the timer is re-modified
@@ -803,8 +804,6 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 	if (timer_pending(timer) && timer->expires == expires)
 		return 1;
 
-	expires = apply_slack(timer, expires);
-
 	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
 }
 EXPORT_SYMBOL(mod_timer);
