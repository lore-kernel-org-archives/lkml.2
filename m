Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1ASTK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:10:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:34609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1ASTKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:10:25 -0500
Date: Wed, 19 Jan 2011 19:09:52 GMT
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
Message-ID: <tip-2d0640b47da74cff7c11642c798d40de861ed524@git.kernel.org>
Git-Commit-ID: 2d0640b47da74cff7c11642c798d40de861ed524
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 Jan 2011 19:09:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2d0640b47da74cff7c11642c798d40de861ed524
Gitweb:     http://git.kernel.org/tip/2d0640b47da74cff7c11642c798d40de861ed524
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Tue, 18 Jan 2011 22:46:34 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Jan 2011 20:08:15 +0100

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
 kernel/time/tick-sched.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..c55ea24 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -642,8 +642,7 @@ static void tick_nohz_switch_to_nohz(void)
 	}
 	local_irq_enable();
 
-	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n",
-	       smp_processor_id());
+	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
 }
 
 /*
@@ -795,8 +794,10 @@ void tick_setup_sched_timer(void)
 	}
 
 #ifdef CONFIG_NO_HZ
-	if (tick_nohz_enabled)
+	if (tick_nohz_enabled) {
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
+		printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
+	}
 #endif
 }
 #endif /* HIGH_RES_TIMERS */
