Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab1A0PD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:03:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:47836 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751913Ab1A0O7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:20 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+aDAAJXema8EqBLku76dfSCQdNybrNQwt3vsAaeY
	+6LGlxbVjVcAXm
Subject: [PATCH v2 04/20] provide xtime_update() which does not require the
	caller to hold xtime_lock
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>, yong.zhang0@gmail.com,
        hch@infradead.org
Date: Thu, 27 Jan 2011 15:59:10 +0100
Message-ID: <20110127145910.23248.21379.stgit@localhost>
In-Reply-To: <20110127145741.23248.68098.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

like do_timer().
this change avoids having this code sequence all over the place:

seq_writelock( &xtime_lock );
do_timer();
seq_writeunlock( &xtime_lock );

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 include/linux/sched.h     |    1 +
 kernel/time/timekeeping.c |   13 +++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 738ec15..c0b0bb7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2045,6 +2045,7 @@ extern void release_uids(struct user_namespace *ns);
 #include <asm/current.h>
 
 extern void do_timer(unsigned long ticks);
+extern void xtime_update(unsigned long ticks);
 
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6085fa5..8dd6e38 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -978,3 +978,16 @@ void get_xtime_and_monotonic_offset(struct timespec *xts, struct timespec *tom)
 			*tom = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 }
+
+/**
+ * xtime_update() - advances the timekeeping infrastructure
+ * @ticks:	number of ticks, that have elapsed since the last call.
+ *
+ * this function needs to be called with interrupts disabled.
+ */
+void xtime_update(unsigned long ticks)
+{
+	write_seqlock(&xtime_lock);
+	do_timer(ticks);
+	write_sequnlock(&xtime_lock);
+}

