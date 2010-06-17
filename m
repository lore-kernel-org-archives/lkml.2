Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436Ab0FQRkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:40:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:33910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923Ab0FQRkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:40:32 -0400
Date: Thu, 17 Jun 2010 17:39:39 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, bmb@athenacr.com, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, peterz@infradead.org, jkosina@suse.cz,
       alan@lxorguk.ukuu.org.uk, jefdriesen@telenet.be,
       hirofumi@mail.parknet.co.jp, gregkh@suse.de, tglx@linutronix.de,
       cw@f00f.org
Reply-To: mingo@redhat.com, hpa@zytor.com, bmb@athenacr.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
       jkosina@suse.cz, alan@lxorguk.ukuu.org.uk, jefdriesen@telenet.be,
       hirofumi@mail.parknet.co.jp, gregkh@suse.de, tglx@linutronix.de,
       cw@f00f.org
In-Reply-To: <1276790557.27822.516.camel@twins>
References: <1276790557.27822.516.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] nohz: Fix nohz ratelimit
Message-ID: <tip-3310d4d38fbc514e7b18bd3b1eea8effdd63b5aa@git.kernel.org>
Git-Commit-ID: 3310d4d38fbc514e7b18bd3b1eea8effdd63b5aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Jun 2010 17:39:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3310d4d38fbc514e7b18bd3b1eea8effdd63b5aa
Gitweb:     http://git.kernel.org/tip/3310d4d38fbc514e7b18bd3b1eea8effdd63b5aa
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 17 Jun 2010 18:02:37 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 17 Jun 2010 19:37:29 +0200

nohz: Fix nohz ratelimit

Chris Wedgwood reports that 39c0cbe (sched: Rate-limit nohz) causes a
serial console regression, unresponsiveness, and indeed it does. The
reason is that the nohz code is skipped even when the tick was already
stopped before the nohz_ratelimit(cpu) condition changed.

Move the nohz_ratelimit() check to the other conditions which prevent
long idle sleeps.

Reported-by: Chris Wedgwood <cw@f00f.org>
Tested-by: Brian Bloniarz <bmb@athenacr.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jef Driesen <jefdriesen@telenet.be>
LKML-Reference: <1276790557.27822.516.camel@twins>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1d7b9bc..783fbad 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -315,9 +315,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 		goto end;
 	}
 
-	if (nohz_ratelimit(cpu))
-		goto end;
-
 	ts->idle_calls++;
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
@@ -328,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	    arch_needs_cpu(cpu) || nohz_ratelimit(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {
