Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab1CUXzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:55:11 -0400
Received: from kroah.org ([198.145.64.141]:49156 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab1CUXOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:14:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:54 2011
Message-Id: <20110321231054.882812724@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:10:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>
Subject: [41/44] powerpc/kdump: Fix race in kdump shutdown
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Neuling <mikey@neuling.org>

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
Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/crash.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -162,6 +162,32 @@ static void crash_kexec_prepare_cpus(int
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
@@ -419,6 +445,7 @@ void default_machine_crash_shutdown(stru
 	crash_kexec_prepare_cpus(crashing_cpu);
 	cpu_set(crashing_cpu, cpus_in_crash);
 	crash_kexec_stop_spus();
+	crash_kexec_wait_realmode(crashing_cpu);
 	if (ppc_md.kexec_cpu_down)
 		ppc_md.kexec_cpu_down(1, 0);
 }


