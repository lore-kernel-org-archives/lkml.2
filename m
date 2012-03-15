Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761860Ab2CONFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 09:05:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761805Ab2CONFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 09:05:11 -0400
Date: Thu, 15 Mar 2012 06:04:20 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-600e145882802d6ccbfe2c4aea243d97caeb91a9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, rdunlap@xenotime.net,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, rdunlap@xenotime.net,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <1331811337.18960.179.camel@twins>
References: <1331811337.18960.179.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] printk: Make it compile with !CONFIG_PRINTK
Git-Commit-ID: 600e145882802d6ccbfe2c4aea243d97caeb91a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 15 Mar 2012 06:04:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  600e145882802d6ccbfe2c4aea243d97caeb91a9
Gitweb:     http://git.kernel.org/tip/600e145882802d6ccbfe2c4aea243d97caeb91a9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 15 Mar 2012 12:35:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Mar 2012 13:38:54 +0100

printk: Make it compile with !CONFIG_PRINTK

Commit 3ccf3e830615 ("printk/sched: Introduce special
printk_sched() for those awkward moments") overlooked
an #ifdef, so move code around to respect these directives.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Link: http://lkml.kernel.org/r/1331811337.18960.179.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/printk.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 49a2ae4..b64ce71 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1222,26 +1222,6 @@ int is_console_locked(void)
 static DEFINE_PER_CPU(int, printk_pending);
 static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
 
-int printk_sched(const char *fmt, ...)
-{
-	unsigned long flags;
-	va_list args;
-	char *buf;
-	int r;
-
-	local_irq_save(flags);
-	buf = __get_cpu_var(printk_sched_buf);
-
-	va_start(args, fmt);
-	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
-	va_end(args);
-
-	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
-	local_irq_restore(flags);
-
-	return r;
-}
-
 void printk_tick(void)
 {
 	if (__this_cpu_read(printk_pending)) {
@@ -1658,6 +1638,26 @@ late_initcall(printk_late_init);
 
 #if defined CONFIG_PRINTK
 
+int printk_sched(const char *fmt, ...)
+{
+	unsigned long flags;
+	va_list args;
+	char *buf;
+	int r;
+
+	local_irq_save(flags);
+	buf = __get_cpu_var(printk_sched_buf);
+
+	va_start(args, fmt);
+	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
+	va_end(args);
+
+	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
+	local_irq_restore(flags);
+
+	return r;
+}
+
 /*
  * printk rate limiting, lifted from the networking subsystem.
  *
