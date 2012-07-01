Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab2GASbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:31:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35212 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550Ab2GASbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:31:34 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] [RFC] Fix clock_was_set so it is safe to call from atomic
Date: Sun,  1 Jul 2012 14:30:00 -0400
Message-Id: <1341167401-31342-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
References: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
x-cbid: 12070118-7282-0000-0000-00000A7ABCCC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE:This is a prerequisite patch that's required to
address the widely observed leap-second related futex/hrtimer
issues.

Currently clock_was_set() is unsafe to be called from atomic
context, as it calls on_each_cpu(). This causes problems when
we need to adjust the time from update_wall_time().

To fix this, introduce a work_struct so if we're in_atomic,
we can schedule work to do the necessary update after we're
out of the atomic section.

CC: Prarit Bhargava <prarit@redhat.com>
CC: stable@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/hrtimer.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ae34bf5..ee7a98d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -746,7 +746,7 @@ static inline void retrigger_next_event(void *arg) { }
  * resolution timer interrupts. On UP we just disable interrupts and
  * call the high resolution interrupt code.
  */
-void clock_was_set(void)
+static void do_clock_was_set(struct work_struct *work)
 {
 #ifdef CONFIG_HIGH_RES_TIMERS
 	/* Retrigger the CPU local events everywhere */
@@ -754,6 +754,20 @@ void clock_was_set(void)
 #endif
 	timerfd_clock_was_set();
 }
+static DECLARE_WORK(clock_was_set_work, do_clock_was_set);
+
+void clock_was_set(void)
+{
+	/*
+	 * We can't call on_each_cpu() from atomic context,
+	 * so if we're in_atomic, schedule the clock_was_set
+	 * for later.
+	 */
+	if (in_atomic())
+		schedule_work(&clock_was_set_work);
+	else
+		do_clock_was_set(NULL);
+}
 
 /*
  * During resume we might have to reprogram the high resolution timer
-- 
1.7.9.5

