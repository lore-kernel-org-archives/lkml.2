Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1AaOFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:05:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:46496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab1AaOFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:05:41 -0500
Date: Mon, 31 Jan 2011 14:05:29 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110127145910.23248.21379.stgit@localhost>
References: <20110127145910.23248.21379.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Provide xtime_update()
Message-ID: <tip-f0af911a9dec9de702645182c8d269449e24d24b@git.kernel.org>
Git-Commit-ID: f0af911a9dec9de702645182c8d269449e24d24b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:05:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0af911a9dec9de702645182c8d269449e24d24b
Gitweb:     http://git.kernel.org/tip/f0af911a9dec9de702645182c8d269449e24d24b
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:10 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:43 +0100

time: Provide xtime_update()

xtime_update() takes xtime_lock write locked and calls
do_timer(). Provided to replace the do_timer() calls in the
architecture code.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: yong.zhang0@gmail.com
Cc: hch@infradead.org
LKML-Reference: <20110127145910.23248.21379.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h     |    1 +
 kernel/time/timekeeping.c |   13 +++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..9d9a078 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2050,6 +2050,7 @@ extern void release_uids(struct user_namespace *ns);
 #include <asm/current.h>
 
 extern void do_timer(unsigned long ticks);
+extern void xtime_update(unsigned long ticks);
 
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8da35d1..02c13a3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -969,3 +969,16 @@ void get_xtime_and_monotonic_offset(struct timespec *xtim, struct timespec *wtom
 		*wtom = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 }
+
+/**
+ * xtime_update() - advances the timekeeping infrastructure
+ * @ticks:	number of ticks, that have elapsed since the last call.
+ *
+ * Must be called with interrupts disabled.
+ */
+void xtime_update(unsigned long ticks)
+{
+	write_seqlock(&xtime_lock);
+	do_timer(ticks);
+	write_sequnlock(&xtime_lock);
+}
