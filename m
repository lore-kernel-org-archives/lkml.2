Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2IYPHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:07:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56768 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2IYPG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:06:59 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/6] ia64: Reuse system and user vtime accounting functions on task switch
Date: Tue, 25 Sep 2012 17:06:05 +0200
Message-Id: <1348585567-2925-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
References: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid code duplication.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/ia64/kernel/time.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 351df58..80ff9ac 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -104,20 +104,15 @@ void vtime_task_switch(struct task_struct *prev)
 {
 	struct thread_info *pi = task_thread_info(prev);
 	struct thread_info *ni = task_thread_info(current);
-	cputime_t delta_stime;
-	__u64 now;
-
-	now = ia64_get_itc();
 
-	delta_stime = cycle_to_cputime(pi->ac_stime + (now - pi->ac_stamp));
 	if (idle_task(smp_processor_id()) != prev)
-		account_system_time(prev, 0, delta_stime, delta_stime);
+		vtime_account_system(prev);
 	else
-		account_idle_time(delta_stime);
+		vtime_account_idle(prev);
 
 	vtime_account_user(prev);
 
-	pi->ac_stamp = ni->ac_stamp = now;
+	pi->ac_stamp = ni->ac_stamp;
 	ni->ac_stime = ni->ac_utime = 0;
 }
 
-- 
1.7.5.4

