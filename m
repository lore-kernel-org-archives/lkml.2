Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab0EJWyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:54:13 -0400
Received: from kroah.org ([198.145.64.141]:33289 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484Ab0EJWwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:39 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:24 2010
Message-Id: <20100510223324.525294385@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [079/117] powerpc: Reset kernel stack on cpu online from cede state
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

commit 8dbce53cc249a76e9450708d291fce5a7e29c6a1 upstream.

Cpu hotplug (offline) without dlpar operation will place cpu
in cede state and the extended_cede_processor() function will
return when resumed.

Kernel stack pointer needs to be reset before
start_secondary() is called to continue the online operation.

Added new function start_secondary_resume() to do the above
steps.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/head_64.S                   |   11 +++++++++++
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |    9 ++++-----
 arch/powerpc/platforms/pseries/offline_states.h |    1 +
 3 files changed, 16 insertions(+), 5 deletions(-)

--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -615,6 +615,17 @@ _GLOBAL(start_secondary_prolog)
 	std	r3,0(r1)		/* Zero the stack frame pointer	*/
 	bl	.start_secondary
 	b	.
+/*
+ * Reset stack pointer and call start_secondary
+ * to continue with online operation when woken up
+ * from cede in cpu offline.
+ */
+_GLOBAL(start_secondary_resume)
+	ld	r1,PACAKSAVE(r13)	/* Reload kernel stack pointer */
+	li	r3,0
+	std	r3,0(r1)		/* Zero the stack frame pointer	*/
+	bl	.start_secondary
+	b	.
 #endif
 
 /*
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -146,12 +146,11 @@ static void pseries_mach_cpu_die(void)
 		unregister_slb_shadow(hwcpu, __pa(get_slb_shadow()));
 
 		/*
-		 * NOTE: Calling start_secondary() here for now to
-		 * start new context.
-		 * However, need to do it cleanly by resetting the
-		 * stack pointer.
+		 * Call to start_secondary_resume() will not return.
+		 * Kernel stack will be reset and start_secondary()
+		 * will be called to continue the online operation.
 		 */
-		start_secondary();
+		start_secondary_resume();
 
 	} else if (get_preferred_offline_state(cpu) == CPU_STATE_OFFLINE) {
 
--- a/arch/powerpc/platforms/pseries/offline_states.h
+++ b/arch/powerpc/platforms/pseries/offline_states.h
@@ -35,4 +35,5 @@ static inline void set_default_offline_s
 
 extern enum cpu_state_vals get_preferred_offline_state(int cpu);
 extern int start_secondary(void);
+extern void start_secondary_resume(void);
 #endif


