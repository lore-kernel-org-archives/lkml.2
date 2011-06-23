Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab1FWRiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:35362 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933706Ab1FWRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 204/247] powerpc/kdump: Fix race in kdump shutdown
Date: Thu, 23 Jun 2011 13:34:32 -0400
Message-Id: <1308850515-15242-145-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Neuling <mikey@neuling.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 60adec6226bbcf061d4c2d10944fced209d1847d upstream.

When we are crashing, the crashing/primary CPU IPIs the secondaries to
turn off IRQs, go into real mode and wait in kexec_wait.  While this
is happening, the primary tears down all the MMU maps.  Unfortunately
the primary doesn't check to make sure the secondaries have entered
real mode before doing this.

On PHYP machines, the secondaries can take a long time shutting down
the IRQ controller as RTAS calls are need.  These RTAS calls need to
be serialised which resilts in the secondaries contending in
lock_rtas() and hence taking a long time to shut down.

We've hit this on large POWER7 machines, where some secondaries are
still waiting in lock_rtas(), when the primary tears down the HPTEs.

This patch makes sure all secondaries are in real mode before the
primary tears down the MMU.  It uses the new kexec_state entry in the
paca.  It times out if the secondaries don't reach real mode after
10sec.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/crash.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index cca7c8f..8c066d6 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -162,6 +162,32 @@ static void crash_kexec_prepare_cpus(int cpu)
 	/* Leave the IPI callback set */
 }
 
+/* wait for all the CPUs to hit real mode but timeout if they don't come in */
+static void crash_kexec_wait_realmode(int cpu)
+{
+	unsigned int msecs;
+	int i;
+
+	msecs = 10000;
+	for (i=0; i < NR_CPUS && msecs > 0; i++) {
+		if (i == cpu)
+			continue;
+
+		while (paca[i].kexec_state < KEXEC_STATE_REAL_MODE) {
+			barrier();
+			if (!cpu_possible(i)) {
+				break;
+			}
+			if (!cpu_online(i)) {
+				break;
+			}
+			msecs--;
+			mdelay(1);
+		}
+	}
+	mb();
+}
+
 /*
  * This function will be called by secondary cpus or by kexec cpu
  * if soft-reset is activated to stop some CPUs.
@@ -419,6 +445,7 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	crash_kexec_prepare_cpus(crashing_cpu);
 	cpu_set(crashing_cpu, cpus_in_crash);
 	crash_kexec_stop_spus();
+	crash_kexec_wait_realmode(crashing_cpu);
 	if (ppc_md.kexec_cpu_down)
 		ppc_md.kexec_cpu_down(1, 0);
 }
-- 
1.7.4.4

