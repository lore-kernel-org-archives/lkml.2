Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2GIJnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:43:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2GIJna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:43:30 -0400
Date: Mon, 9 Jul 2012 02:43:01 -0700
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Message-ID: <tip-adf374cf61394dd41c027c74a81f9bef90f7a640@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        johnstul@us.ibm.com, jengelh@inai.de, tglx@linutronix.de,
        prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, jengelh@inai.de,
        prarit@redhat.com
In-Reply-To: <1341515538-5100-2-git-send-email-johnstul@us.ibm.com>
References: <1341515538-5100-2-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer:
  Fix clock_was_set so it is safe to call from irq context
Git-Commit-ID: adf374cf61394dd41c027c74a81f9bef90f7a640
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 09 Jul 2012 02:43:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  adf374cf61394dd41c027c74a81f9bef90f7a640
Gitweb:     http://git.kernel.org/tip/adf374cf61394dd41c027c74a81f9bef90f7a640
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Thu, 5 Jul 2012 15:12:16 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 9 Jul 2012 11:35:38 +0200

hrtimer: Fix clock_was_set so it is safe to call from irq context

NOTE: This is a prerequisite patch that's required to
address the widely observed leap-second related futex/hrtimer
issues.

Currently clock_was_set() is unsafe to be called from irq
context, as it calls on_each_cpu(). This causes problems when
we need to adjust the time from update_wall_time().

To fix this, if clock_was_set is called when irqs are
disabled, we schedule a timer to fire for immedately after
we're out of interrupt context to then notify the hrtimer
subsystem.

Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Prarit Bhargava <prarit@redhat.com>
CC: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1341515538-5100-2-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ae34bf5..d730678 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -746,7 +746,7 @@ static inline void retrigger_next_event(void *arg) { }
  * resolution timer interrupts. On UP we just disable interrupts and
  * call the high resolution interrupt code.
  */
-void clock_was_set(void)
+static void do_clock_was_set(unsigned long data)
 {
 #ifdef CONFIG_HIGH_RES_TIMERS
 	/* Retrigger the CPU local events everywhere */
@@ -755,6 +755,21 @@ void clock_was_set(void)
 	timerfd_clock_was_set();
 }
 
+static DEFINE_TIMER(clock_was_set_timer, do_clock_was_set , 0, 0);
+
+void clock_was_set(void)
+{
+	/*
+	 * We can't call on_each_cpu() from irq context,
+	 * so if irqs are disabled , schedule the clock_was_set
+	 * via a timer_list timer for right after.
+	 */
+	if (irqs_disabled())
+		mod_timer(&clock_was_set_timer, jiffies);
+	else
+		do_clock_was_set(0);
+}
+
 /*
  * During resume we might have to reprogram the high resolution timer
  * interrupt (on the local CPU):
