Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab1EUK6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 06:58:32 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60082 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634Ab1EUK6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 06:58:30 -0400
Date: Sat, 21 May 2011 12:58:28 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] timers: consider slack value in mod_timer()
Message-ID: <20110521105828.GA29442@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an optimization which does not update the timer if the timer
was pending and the expiration time was unchanged.
Since commit 3bbb9ec9 ("timers: Introduce the concept of timer slack for
legacy timers") this optimization is no longer applied for timers where
the expiration time got extended due to the slack value. So here it adds
the check again after the expiration time might have been updated.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 kernel/timer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index fd61986..bf09726 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -804,6 +804,8 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 		return 1;
 
 	expires = apply_slack(timer, expires);
+	if (timer_pending(timer) && timer->expires == expires)
+		return 1;
 
 	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
 }
-- 
1.7.4.4

