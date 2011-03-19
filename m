Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab1CSSOo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 14:14:44 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60975 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab1CSSOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 14:14:40 -0400
Date: Sat, 19 Mar 2011 23:44:33 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: greg@kroah.com
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, anton@samba.org,
        benh@kernel.crashing.org, mananth@in.ibm.com
Subject: [2/3] powerpc/kdump: Fix race in kdump shutdown
Message-ID: <20110319181433.GC23832@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	powerpc/kdump: Fix race in kdump shutdown

	Commit: 60adec6226bbcf061d4c2d10944fced209d1847d upstream

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
	Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
	cc: Anton Blanchard <anton@samba.org>
---
 arch/powerpc/kernel/crash.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index b779818..706b622 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -153,6 +153,7 @@ static void crash_kexec_prepare_cpus(int cpu)
		while (cpus_weight(cpus_in_crash) < ncpus)
			cpu_relax();
	}
+
	/*
	 * Make sure all CPUs are entered via soft-reset if the kdump is
	 * invoked using soft-reset.
@@ -162,6 +163,32 @@ static void crash_kexec_prepare_cpus(int cpu)
	/* Leave the IPI callback set */
 }

+/* wait for all the CPUs to hit real mode but timeout if they don't come in */
+static void crash_kexec_wait_realmode(int cpu)
+{
+	unsigned int msecs;
+	int i;
+
+	msecs = 10000;
+	for (i = 0; i < NR_CPUS && msecs > 0; i++) {
+		if (i == cpu)
+			continue;
+
+		while (paca[i].kexec_state < KEXEC_STATE_REAL_MODE) {
+			barrier();
+			if (!cpu_possible(i))
+				break;
+
+			if (!cpu_online(i))
+				break;
+
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
@@ -419,6 +446,7 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
	crash_kexec_prepare_cpus(crashing_cpu);
	cpu_set(crashing_cpu, cpus_in_crash);
	crash_kexec_stop_spus();
+	crash_kexec_wait_realmode(crashing_cpu);
	if (ppc_md.kexec_cpu_down)
		ppc_md.kexec_cpu_down(1, 0);
 }
