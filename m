Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770Ab1FWRt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:49:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:35447 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737Ab1FWRiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 205/247] powerpc: Fix default_machine_crash_shutdown #ifdef botch
Date: Thu, 23 Jun 2011 13:34:33 -0400
Message-Id: <1308850515-15242-146-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c2be05481f6125254c45b78f334d4dd09c701c82 upstream.

crash_kexec_wait_realmode() is defined only if CONFIG_PPC_STD_MMU_64
and CONFIG_SMP, but is called if CONFIG_PPC_STD_MMU_64 even if !CONFIG_SMP.
Fix the conditional compilation around the invocation.

[PG: commit b3df895aebe091b1657 "powerpc/kexec: Add support for FSL-BookE"
 introduced the PPC_STD_MMU_64 check this refers to, but we don't want to
 cherry pick that whole addition to stable just for one #ifdef line.]

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/crash.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 8c066d6..ddf1fea 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -163,6 +163,7 @@ static void crash_kexec_prepare_cpus(int cpu)
 }
 
 /* wait for all the CPUs to hit real mode but timeout if they don't come in */
+#if defined(CONFIG_PPC_STD_MMU_64) && defined(CONFIG_SMP)
 static void crash_kexec_wait_realmode(int cpu)
 {
 	unsigned int msecs;
@@ -187,6 +188,7 @@ static void crash_kexec_wait_realmode(int cpu)
 	}
 	mb();
 }
+#endif
 
 /*
  * This function will be called by secondary cpus or by kexec cpu
@@ -445,7 +447,9 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	crash_kexec_prepare_cpus(crashing_cpu);
 	cpu_set(crashing_cpu, cpus_in_crash);
 	crash_kexec_stop_spus();
+#if defined(CONFIG_PPC_STD_MMU_64) && defined(CONFIG_SMP)
 	crash_kexec_wait_realmode(crashing_cpu);
+#endif
 	if (ppc_md.kexec_cpu_down)
 		ppc_md.kexec_cpu_down(1, 0);
 }
-- 
1.7.4.4

