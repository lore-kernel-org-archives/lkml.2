Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1ASTEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:04:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:36542 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1ASTEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:04:39 -0500
Date: Wed, 19 Jan 2011 19:03:46 GMT
From: tip-bot for Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, sboyd@codeaurora.org,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, sboyd@codeaurora.org,
        mingo@elte.hu
In-Reply-To: <1295419594-13085-1-git-send-email-sboyd@codeaurora.org>
References: <1295419594-13085-1-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimers: Notify hrtimer users of switches to NOHZ mode
Message-ID: <tip-fe96565ce90aca25786d709ebb5fb5e49b8bbafe@git.kernel.org>
Git-Commit-ID: fe96565ce90aca25786d709ebb5fb5e49b8bbafe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 Jan 2011 19:03:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe96565ce90aca25786d709ebb5fb5e49b8bbafe
Gitweb:     http://git.kernel.org/tip/fe96565ce90aca25786d709ebb5fb5e49b8bbafe
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Tue, 18 Jan 2011 22:46:34 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Jan 2011 12:08:44 +0100

hrtimers: Notify hrtimer users of switches to NOHZ mode

When NOHZ=y and high res timers are disabled (via cmdline or
Kconfig) tick_nohz_switch_to_nohz() will notify the user about
switching into NOHZ mode. Nothing is printed for the case where
HIGH_RES_TIMERS=y. Fix this for the HIGH_RES_TIMERS=y case by
duplicating the printk from the low res NOHZ path in the high
res NOHZ path.

This confused me since I was thinking 'dmesg | grep -i NOHZ' would
tell me if NOHZ was enabled, but if I have hrtimers there is
nothing.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1295419594-13085-1-git-send-email-sboyd@codeaurora.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-sched.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..9760f4f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -640,10 +640,8 @@ static void tick_nohz_switch_to_nohz(void)
 			break;
 		next = ktime_add(next, tick_period);
 	}
+	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
 	local_irq_enable();
-
-	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n",
-	       smp_processor_id());
 }
 
 /*
@@ -795,8 +793,11 @@ void tick_setup_sched_timer(void)
 	}
 
 #ifdef CONFIG_NO_HZ
-	if (tick_nohz_enabled)
+	if (tick_nohz_enabled) {
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
+		pr_info("Switched to NOHz mode on CPU #%d\n",
+				smp_processor_id());
+	}
 #endif
 }
 #endif /* HIGH_RES_TIMERS */
