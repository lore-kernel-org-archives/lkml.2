Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1BDJe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 04:34:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:49866 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab1BDJeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 04:34:25 -0500
Date: Fri, 4 Feb 2011 09:34:00 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, nbowler@elliptictech.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, yong.zhang0@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, nbowler@elliptictech.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, yong.zhang0@gmail.com
In-Reply-To: <20110203141548.039540914@chello.nl>
References: <20110203141548.039540914@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] lockdep, timer: Fix del_timer_sync() annotation
Message-ID: <tip-f266a5110d453b7987194460ac7edd31f1a5426c@git.kernel.org>
Git-Commit-ID: f266a5110d453b7987194460ac7edd31f1a5426c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Feb 2011 09:34:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f266a5110d453b7987194460ac7edd31f1a5426c
Gitweb:     http://git.kernel.org/tip/f266a5110d453b7987194460ac7edd31f1a5426c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 3 Feb 2011 15:09:41 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 4 Feb 2011 10:31:22 +0100

lockdep, timer: Fix del_timer_sync() annotation

Calling local_bh_enable() will want to actually start processing
softirqs, which isn't a good idea since this can get called with IRQs
disabled.

Cure this by using _local_bh_enable() which doesn't start processing
softirqs, and use raw_local_irq_save() to avoid any softirqs from
happening without letting lockdep think IRQs are in fact disabled.

Reported-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
LKML-Reference: <20110203141548.039540914@chello.nl>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 43ca993..d53ce66 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -969,10 +969,14 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
 int del_timer_sync(struct timer_list *timer)
 {
 #ifdef CONFIG_LOCKDEP
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
 	local_bh_disable();
 	lock_map_acquire(&timer->lockdep_map);
 	lock_map_release(&timer->lockdep_map);
-	local_bh_enable();
+	_local_bh_enable();
+	raw_local_irq_restore(flags);
 #endif
 	/*
 	 * don't use it in hardirq context, because it
