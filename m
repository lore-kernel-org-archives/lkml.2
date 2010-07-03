Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0GCHys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 03:54:48 -0400
Received: from ozlabs.org ([203.10.76.45]:37874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0GCHyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 03:54:47 -0400
From: Michael Neuling <mikey@neuling.org>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 054/149] powerpc/pseries: Only call start-cpu when a CPU is stopped
In-reply-to: <20100703015713.GC16229@suse.de>
References: <20100701173211.356448329@clark.site> <24044.1278029021@neuling.org> <20100703015713.GC16229@suse.de>
Comments: In-reply-to Greg KH <gregkh@suse.de>
   message dated "Fri, 02 Jul 2010 18:57:13 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Sat, 03 Jul 2010 17:54:45 +1000
Message-ID: <32137.1278143685@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is not going to work without:
> > f8b67691828321f5c85bb853283aa101ae673130
> > 
> > It'll get a build failure.
> 
> That is because that patch does not apply to the .32 series.  If it is
> needed, can you please send me a backported version to apply?

Sure... Compile and boot tested only.

Thanks,
Mikey


From: Michael Neuling <mikey@neuling.org>

powerpc/pseries: Make query_cpu_stopped callable outside hotplug cpu

This moves query_cpu_stopped() out of the hotplug cpu code and into
smp.c so it can called in other places and renames it to
smp_query_cpu_stopped().

It also cleans up the return values by adding some #defines

Cc: <stable@kernel.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Index: clone1/arch/powerpc/platforms/pseries/hotplug-cpu.c
===================================================================
--- clone1.orig/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ clone1/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -66,30 +66,6 @@ static void pseries_mach_cpu_die(void)
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
@@ -113,8 +89,9 @@ static void pseries_cpu_die(unsigned int
 	unsigned int pcpu = get_hard_smp_processor_id(cpu);
 
 	for (tries = 0; tries < 25; tries++) {
-		cpu_status = query_cpu_stopped(pcpu);
-		if (cpu_status == 0 || cpu_status == -1)
+		cpu_status = smp_query_cpu_stopped(pcpu);
+		if (cpu_status == QCSS_STOPPED ||
+		    cpu_status == QCSS_HARDWARE_ERROR)
 			break;
 		cpu_relax();
 	}
@@ -256,6 +233,7 @@ static int __init pseries_cpu_hotplug_in
 {
 	struct device_node *np;
 	const char *typep;
+	int qcss_tok;
 
 	for_each_node_by_name(np, "interrupt-controller") {
 		typep = of_get_property(np, "compatible", NULL);
Index: clone1/arch/powerpc/platforms/pseries/plpar_wrappers.h
===================================================================
--- clone1.orig/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ clone1/arch/powerpc/platforms/pseries/plpar_wrappers.h
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
Index: clone1/arch/powerpc/platforms/pseries/smp.c
===================================================================
--- clone1.orig/arch/powerpc/platforms/pseries/smp.c
+++ clone1/arch/powerpc/platforms/pseries/smp.c
@@ -56,6 +56,28 @@
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
