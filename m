Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab2EXVEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:04:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758956Ab2EXVEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:04:47 -0400
Date: Thu, 24 May 2012 14:04:28 -0700
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-ee74d13229fb606353ff56f4927fa93b37e95bbe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com
In-Reply-To: <20120524151055.2549.64309.stgit@srivatsabhat.in.ibm.com>
References: <20120524151055.2549.64309.stgit@srivatsabhat.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] smpboot, idle:
  Optimize calls to smp_processor_id() in idle_threads_init()
Git-Commit-ID: ee74d13229fb606353ff56f4927fa93b37e95bbe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 14:04:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee74d13229fb606353ff56f4927fa93b37e95bbe
Gitweb:     http://git.kernel.org/tip/ee74d13229fb606353ff56f4927fa93b37e95bbe
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Thu, 24 May 2012 20:40:55 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 24 May 2012 22:58:08 +0200

smpboot, idle: Optimize calls to smp_processor_id() in idle_threads_init()

While trying to initialize idle threads for all cpus, idle_threads_init()
calls smp_processor_id() in a loop, which is unnecessary. The intent
is to initialize idle threads for all non-boot cpus. So just use a variable
to note the boot cpu and use it in the loop.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: suresh.b.siddha@intel.com
Cc: venki@google.com
Cc: nikunj@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/20120524151055.2549.64309.stgit@srivatsabhat.in.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/smpboot.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index e1a797e..0f2162f 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -52,10 +52,12 @@ static inline void idle_init(unsigned int cpu)
  */
 void __init idle_threads_init(void)
 {
-	unsigned int cpu;
+	unsigned int cpu, boot_cpu;
+
+	boot_cpu = smp_processor_id();
 
 	for_each_possible_cpu(cpu) {
-		if (cpu != smp_processor_id())
+		if (cpu != boot_cpu)
 			idle_init(cpu);
 	}
 }
