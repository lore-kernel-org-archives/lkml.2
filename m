Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2HXA1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 20:27:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44913 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab2HXA0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 20:26:48 -0400
Date: Thu, 23 Aug 2012 17:26:43 -0700
From: Tejun Heo <tj@kernel.org>
To: Len Brown <lenb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, acpi: Make acpi_processor_ffh_cstate_probe() use a
 work item instead of work_on_cpu()
Message-ID: <20120824002643.GA21325@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue is guaranteed to be available on the target CPU by the time
acpi_processor_ffh_cstate_probe() is invoked for it.  There's no
reason to use costly work_on_cpu() which involves creating and tearing
down a full kthread on each invocation to execute the probing function
on the target CPU.  Use a work item instead.

Tested and works as expected.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/acpi/cstate.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index d2b7f27..97259f0 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -69,10 +69,16 @@ static short mwait_supported[ACPI_PROCESSOR_MAX_POWER];
 
 #define NATIVE_CSTATE_BEYOND_HALT	(2)
 
-static long acpi_processor_ffh_cstate_probe_cpu(void *_cx)
+struct cstate_probe_arg {
+	struct work_struct work;
+	struct acpi_processor_cx *cx;
+	int ret;
+};
+
+static void acpi_processor_ffh_cstate_probe_cpu(struct work_struct *work)
 {
-	struct acpi_processor_cx *cx = _cx;
-	long retval;
+	struct cstate_probe_arg *arg = container_of(work, struct cstate_probe_arg, work);
+	struct acpi_processor_cx *cx = arg->cx;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int edx_part;
 	unsigned int cstate_type; /* C-state type and not ACPI C-state type */
@@ -86,17 +92,16 @@ static long acpi_processor_ffh_cstate_probe_cpu(void *_cx)
 	edx_part = edx >> (cstate_type * MWAIT_SUBSTATE_SIZE);
 	num_cstate_subtype = edx_part & MWAIT_SUBSTATE_MASK;
 
-	retval = 0;
 	if (num_cstate_subtype < (cx->address & MWAIT_SUBSTATE_MASK)) {
-		retval = -1;
-		goto out;
+		arg->ret = -1;
+		return;
 	}
 
 	/* mwait ecx extensions INTERRUPT_BREAK should be supported for C2/C3 */
 	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
 	    !(ecx & CPUID5_ECX_INTERRUPT_BREAK)) {
-		retval = -1;
-		goto out;
+		arg->ret = -1;
+		return;
 	}
 
 	if (!mwait_supported[cstate_type]) {
@@ -108,8 +113,7 @@ static long acpi_processor_ffh_cstate_probe_cpu(void *_cx)
 	snprintf(cx->desc,
 			ACPI_CX_DESC_LEN, "ACPI FFH INTEL MWAIT 0x%x",
 			cx->address);
-out:
-	return retval;
+	arg->ret = 0;
 }
 
 int acpi_processor_ffh_cstate_probe(unsigned int cpu,
@@ -117,7 +121,7 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 {
 	struct cstate_entry *percpu_entry;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	long retval;
+	struct cstate_probe_arg arg = { .cx = cx };
 
 	if (!cpu_cstate_entry || c->cpuid_level < CPUID_MWAIT_LEAF)
 		return -1;
@@ -130,9 +134,10 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 	percpu_entry->states[cx->index].ecx = 0;
 
 	/* Make sure we are running on right CPU */
-
-	retval = work_on_cpu(cpu, acpi_processor_ffh_cstate_probe_cpu, cx);
-	if (retval == 0) {
+	INIT_WORK_ONSTACK(&arg.work, acpi_processor_ffh_cstate_probe_cpu);
+	schedule_work_on(cpu, &arg.work);
+	flush_work(&arg.work);
+	if (arg.ret == 0) {
 		/* Use the hint in CST */
 		percpu_entry->states[cx->index].eax = cx->address;
 		percpu_entry->states[cx->index].ecx = MWAIT_ECX_INTERRUPT_BREAK;
@@ -146,7 +151,7 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 	if ((c->x86_vendor == X86_VENDOR_INTEL) && !(reg->access_size & 0x2))
 		cx->bm_sts_skip = 1;
 
-	return retval;
+	return arg.ret;
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
 
