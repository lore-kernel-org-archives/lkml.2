Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab0LHUmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:42:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:34639 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab0LHUmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:42:17 -0500
Date: Wed, 8 Dec 2010 20:41:52 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, cl@linux.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, cl@linux.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1290788536.2855.237.camel@edumazet-laptop>
References: <1290788536.2855.237.camel@edumazet-laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] printk: Use this_cpu_{read|write} api on printk_pending
Message-ID: <tip-40dc11ffb35e8c4e8fa71092048e0f8de9db758c@git.kernel.org>
Git-Commit-ID: 40dc11ffb35e8c4e8fa71092048e0f8de9db758c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 20:41:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40dc11ffb35e8c4e8fa71092048e0f8de9db758c
Gitweb:     http://git.kernel.org/tip/40dc11ffb35e8c4e8fa71092048e0f8de9db758c
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Fri, 26 Nov 2010 17:22:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Dec 2010 20:16:01 +0100

printk: Use this_cpu_{read|write} api on printk_pending

__get_cpu_var() is a bit inefficient, lets use __this_cpu_read() and
__this_cpu_write() to manipulate printk_pending.

printk_needs_cpu(cpu) is called only for the current cpu :
Use faster __this_cpu_read().

Remove the redundant unlikely on (cpu_is_offline(cpu)) test:

 # size kernel/printk.o*
   text	   data	    bss	    dec	    hex	filename
   9942	    756	 263488	 274186	  42f0a	kernel/printk.o.new
   9990	    756	 263488	 274234	  42f3a	kernel/printk.o.old

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290788536.2855.237.camel@edumazet-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/printk.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index a23315d..ab3ffc5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1074,17 +1074,17 @@ static DEFINE_PER_CPU(int, printk_pending);
 
 void printk_tick(void)
 {
-	if (__get_cpu_var(printk_pending)) {
-		__get_cpu_var(printk_pending) = 0;
+	if (__this_cpu_read(printk_pending)) {
+		__this_cpu_write(printk_pending, 0);
 		wake_up_interruptible(&log_wait);
 	}
 }
 
 int printk_needs_cpu(int cpu)
 {
-	if (unlikely(cpu_is_offline(cpu)))
+	if (cpu_is_offline(cpu))
 		printk_tick();
-	return per_cpu(printk_pending, cpu);
+	return __this_cpu_read(printk_pending);
 }
 
 void wake_up_klogd(void)
