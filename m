Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1AaOLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:11:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:42678 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab1AaOLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:11:17 -0500
Date: Mon, 31 Jan 2011 14:11:00 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, peterz@infradead.org, chris@zankel.net,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de,
        chris@zankel.net
In-Reply-To: <20110127150027.23248.61798.stgit@localhost>
References: <20110127150027.23248.61798.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] xtensa: Switch do_timer() to xtime_update()
Message-ID: <tip-d12b0e24c56c6fb2398609f26858e5278d688840@git.kernel.org>
Git-Commit-ID: d12b0e24c56c6fb2398609f26858e5278d688840
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:11:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d12b0e24c56c6fb2398609f26858e5278d688840
Gitweb:     http://git.kernel.org/tip/d12b0e24c56c6fb2398609f26858e5278d688840
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 16:00:27 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:46 +0100

xtensa: Switch do_timer() to xtime_update()

xtime_update() takes the xtime_lock itself.

set_linux_timer() does not need to be protected by xtime_lock.

[ tglx: This code is broken on SMP anyway. ]

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: hch@infradead.org
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127150027.23248.61798.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/xtensa/kernel/time.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 19df764..f3e5eb4 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -96,16 +96,12 @@ again:
 		update_process_times(user_mode(get_irq_regs()));
 #endif
 
-		write_seqlock(&xtime_lock);
-
-		do_timer(1); /* Linux handler in kernel/timer.c */
+		xtime_update(1); /* Linux handler in kernel/time/timekeeping */
 
 		/* Note that writing CCOMPARE clears the interrupt. */
 
 		next += CCOUNT_PER_JIFFY;
 		set_linux_timer(next);
-
-		write_sequnlock(&xtime_lock);
 	}
 
 	/* Allow platform to do something useful (Wdog). */
