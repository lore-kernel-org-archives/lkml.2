Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2KTPn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:43:27 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33162 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2KTPnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:43:04 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 5/5] vtime: Warn if irqs aren't disabled on system time accounting APIs
Date: Tue, 20 Nov 2012 16:42:41 +0100
Message-Id: <1353426161-18866-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353426161-18866-1-git-send-email-fweisbec@gmail.com>
References: <1353426161-18866-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System time accounting APIs such as vtime_account_system() and
vtime_account_idle() need to be irqsafe. Current callers include
irq entry, exit and kvm, all of which have been checked against that
requirement. Now it's better to grow that with an automatic check
in case we have further callers or we missed something.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/ia64/kernel/time.c    |    2 ++
 arch/powerpc/kernel/time.c |    2 ++
 arch/s390/kernel/vtime.c   |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index c9a7d2e..b1995ef 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -119,6 +119,8 @@ static cputime_t vtime_delta(struct task_struct *tsk)
 	cputime_t delta_stime;
 	__u64 now;
 
+	WARN_ON_ONCE(!irqs_disabled());
+
 	now = ia64_get_itc();
 
 	delta_stime = cycle_to_cputime(ti->ac_stime + (now - ti->ac_stamp));
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 3486cfa..b3b1435 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -297,6 +297,8 @@ static u64 vtime_delta(struct task_struct *tsk,
 	u64 now, nowscaled, deltascaled;
 	u64 udelta, delta, user_scaled;
 
+	WARN_ON_ONCE(!irqs_disabled());
+
 	now = mftb();
 	nowscaled = read_spurr(now);
 	get_paca()->system_time += now - get_paca()->starttime;
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 7c6d861..e84b8b6 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -132,6 +132,8 @@ void vtime_account(struct task_struct *tsk)
 	struct thread_info *ti = task_thread_info(tsk);
 	u64 timer, system;
 
+	WARN_ON_ONCE(!irqs_disabled());
+
 	timer = S390_lowcore.last_update_timer;
 	S390_lowcore.last_update_timer = get_vtimer();
 	S390_lowcore.system_timer += timer - S390_lowcore.last_update_timer;
-- 
1.7.5.4

