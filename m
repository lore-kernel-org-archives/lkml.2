Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab1DZB4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 21:56:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57459 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab1DZB4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 21:56:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: (resend) [PATCH 3/4] blackfin: don't touch task->cpus_allowed directly
Cc: kosaki.motohiro@jp.fujitsu.com, uclinux-dist-devel@blackfin.uclinux.org,
        Mike Frysinger <vapier.adi@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110426105518.F35D.A69D9226@jp.fujitsu.com>
References: <20110426105045.F359.A69D9226@jp.fujitsu.com> <20110426105518.F35D.A69D9226@jp.fujitsu.com>
Message-Id: <20110426105823.F368.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 10:56:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every callter (except kthread_bind) should use proper
set_cpus_allowed_ptr() APIs.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
---

I'm curious why this mysterious code is necessary. Why sys_clone()
restrict allowed cpus automatically and why don't it restore the restriction
when do_fork() is finished.

ps: I sent this parch to wrong address (device-driver-devel@blackfin.uclinux.org).
thus now I'm resending it.


 arch/blackfin/kernel/process.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index b407bc8..6a660fa 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -171,10 +171,8 @@ asmlinkage int bfin_clone(struct pt_regs *regs)
 	unsigned long newsp;
 
 #ifdef __ARCH_SYNC_CORE_DCACHE
-	if (current->rt.nr_cpus_allowed == num_possible_cpus()) {
-		current->cpus_allowed = cpumask_of_cpu(smp_processor_id());
-		current->rt.nr_cpus_allowed = 1;
-	}
+	if (current->rt.nr_cpus_allowed == num_possible_cpus())
+		set_cpus_allowed_ptr(current, cpumask_of(smp_processor_id()));
 #endif
 
 	/* syscall2 puts clone_flags in r0 and usp in r1 */
-- 
1.7.3.1





