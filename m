Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721Ab0GAWMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:12:18 -0400
Received: from kroah.org ([198.145.64.141]:47447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642Ab0GAUuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:10 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:31 2010
Message-Id: <20100701173431.884334767@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 060/164] powerpc/pseries: Make query_cpu_stopped callable outside hotplug cpu
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit f8b67691828321f5c85bb853283aa101ae673130 upstream.

This moves query_cpu_stopped() out of the hotplug cpu code and into
smp.c so it can called in other places and renames it to
smp_query_cpu_stopped().

It also cleans up the return values by adding some #defines

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   30 +++---------------------
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    8 ++++++
 arch/powerpc/platforms/pseries/smp.c            |   22 +++++++++++++++++
 3 files changed, 34 insertions(+), 26 deletions(-)

--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -154,30 +154,6 @@ static void pseries_mach_cpu_die(void)
 	for(;;);
 }
 
-static int qcss_tok;	/* query-cpu-stopped-state token */
-
-/* Get state of physical CPU.
- * Return codes:
- *	0	- The processor is in the RTAS stopped state
- *	1	- stop-self is in progress
- *	2	- The processor is not in the RTAS stopped state
- *	-1	- Hardware Error
- *	-2	- Hardware Busy, Try again later.
- */
-static int query_cpu_stopped(unsigned int pcpu)
-{
-	int cpu_status, status;
-
-	status = rtas_call(qcss_tok, 1, 2, &cpu_status, pcpu);
-	if (status != 0) {
-		printk(KERN_ERR
-		       "RTAS query-cpu-stopped-state failed: %i\n", status);
-		return status;
-	}
-
-	return cpu_status;
-}
-
 static int pseries_cpu_disable(void)
 {
 	int cpu = smp_processor_id();
@@ -224,8 +200,9 @@ static void pseries_cpu_die(unsigned int
 	} else if (get_preferred_offline_state(cpu) == CPU_STATE_OFFLINE) {
 
 		for (tries = 0; tries < 25; tries++) {
-			cpu_status = query_cpu_stopped(pcpu);
-			if (cpu_status == 0 || cpu_status == -1)
+			cpu_status = smp_query_cpu_stopped(pcpu);
+			if (cpu_status == QCSS_STOPPED ||
+			    cpu_status == QCSS_HARDWARE_ERROR)
 				break;
 			cpu_relax();
 		}
@@ -400,6 +377,7 @@ static int __init pseries_cpu_hotplug_in
 	struct device_node *np;
 	const char *typep;
 	int cpu;
+	int qcss_tok;
 
 	for_each_node_by_name(np, "interrupt-controller") {
 		typep = of_get_property(np, "compatible", NULL);
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -4,6 +4,14 @@
 #include <asm/hvcall.h>
 #include <asm/page.h>
 
+/* Get state of physical CPU from query_cpu_stopped */
+int smp_query_cpu_stopped(unsigned int pcpu);
+#define QCSS_STOPPED 0
+#define QCSS_STOPPING 1
+#define QCSS_NOT_STOPPED 2
+#define QCSS_HARDWARE_ERROR -1
+#define QCSS_HARDWARE_BUSY -2
+
 static inline long poll_pending(void)
 {
 	return plpar_hcall_norets(H_POLL_PENDING);
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -57,6 +57,28 @@
  */
 static cpumask_t of_spin_map;
 
+/* Query where a cpu is now.  Return codes #defined in plpar_wrappers.h */
+int smp_query_cpu_stopped(unsigned int pcpu)
+{
+	int cpu_status, status;
+	int qcss_tok = rtas_token("query-cpu-stopped-state");
+
+	if (qcss_tok == RTAS_UNKNOWN_SERVICE) {
+		printk(KERN_INFO "Firmware doesn't support "
+				"query-cpu-stopped-state\n");
+		return QCSS_HARDWARE_ERROR;
+	}
+
+	status = rtas_call(qcss_tok, 1, 2, &cpu_status, pcpu);
+	if (status != 0) {
+		printk(KERN_ERR
+		       "RTAS query-cpu-stopped-state failed: %i\n", status);
+		return status;
+	}
+
+	return cpu_status;
+}
+
 /**
  * smp_startup_cpu() - start the given cpu
  *


