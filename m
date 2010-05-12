Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab0ELDd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:33:27 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48935 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0ELDdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:33:25 -0400
Date: Wed, 12 May 2010 09:03:15 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Cc: David Gibson <dwg@au1.ibm.com>, Roland McGrath <roland@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Michael Neuling <mikey@neuling.org>,
       Alan Stern <stern@rowland.harvard.edu>, paulus@samba.org,
       shaggy@linux.vnet.ibm.com, Benjamin Herrenschmidt <benh@au1.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Patch 2/3] Allow arch-specific cleanup before breakpoint
	unregistration
Message-ID: <20100512033315.GC6384@in.ibm.com>
References: <20100512022527.857904312@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=arch_unregister_hbp_02
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain architectures (such as PowerPC Book III S) have a need to cleanup
data-structures before the breakpoint is unregistered. This patch introduces
an arch-specific hook in release_bp_slot() along with a weak definition in
the form of a stub funciton.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/hw_breakpoint.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6.ppc64_test/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6.ppc64_test.orig/kernel/hw_breakpoint.c
+++ linux-2.6.ppc64_test/kernel/hw_breakpoint.c
@@ -203,6 +203,17 @@ static void toggle_bp_slot(struct perf_e
 }
 
 /*
+ * Function to perform processor-specific cleanup during unregistration
+ */
+__weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
+{
+	/*
+	 * A weak stub function here for those archs that don't define
+	 * it inside arch/.../kernel/hw_breakpoint.c
+	 */
+}
+
+/*
  * Contraints to check before allowing this new breakpoint counter:
  *
  *  == Non-pinned counter == (Considered as pinned for now)
@@ -280,6 +291,7 @@ void release_bp_slot(struct perf_event *
 {
 	mutex_lock(&nr_bp_mutex);
 
+	arch_unregister_hw_breakpoint(bp);
 	__release_bp_slot(bp);
 
 	mutex_unlock(&nr_bp_mutex);

