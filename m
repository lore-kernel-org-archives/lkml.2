Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab1BVXYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:24:13 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53731
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752067Ab1BVXYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:24:09 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/6] Staging: hv: hv.c Removed all DPRINT and debug - using pr_err now
Date: Tue, 22 Feb 2011 15:32:41 -0800
Message-Id: <1298417565-12356-2-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1298417565-12356-1-git-send-email-hjanssen@microsoft.com>
References: <1298417565-12356-1-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This group of patches removes all DPRINT from hv_vmbus.ko.
It is divided in several patches due to size.

All DPRINT calls have been removed, and where needed have been
replaced with pr_XX native calls. Many debug DPRINT calls have
been removed outright.

The amount of clutter this driver prints has been
significantly reduced.

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/hv.c |   88 +++++++++++-----------------------------------
 1 files changed, 21 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index 2d492ad..e3ce26d 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -80,20 +80,6 @@ static int query_hypervisor_info(void)
 	op = HVCPUID_VENDOR_MAXFUNCTION;
 	cpuid(op, &eax, &ebx, &ecx, &edx);
 
-	DPRINT_INFO(VMBUS, "Vendor ID: %c%c%c%c%c%c%c%c%c%c%c%c",
-		    (ebx & 0xFF),
-		    ((ebx >> 8) & 0xFF),
-		    ((ebx >> 16) & 0xFF),
-		    ((ebx >> 24) & 0xFF),
-		    (ecx & 0xFF),
-		    ((ecx >> 8) & 0xFF),
-		    ((ecx >> 16) & 0xFF),
-		    ((ecx >> 24) & 0xFF),
-		    (edx & 0xFF),
-		    ((edx >> 8) & 0xFF),
-		    ((edx >> 16) & 0xFF),
-		    ((edx >> 24) & 0xFF));
-
 	max_leaf = eax;
 	eax = 0;
 	ebx = 0;
@@ -102,12 +88,6 @@ static int query_hypervisor_info(void)
 	op = HVCPUID_INTERFACE;
 	cpuid(op, &eax, &ebx, &ecx, &edx);
 
-	DPRINT_INFO(VMBUS, "Interface ID: %c%c%c%c",
-		    (eax & 0xFF),
-		    ((eax >> 8) & 0xFF),
-		    ((eax >> 16) & 0xFF),
-		    ((eax >> 24) & 0xFF));
-
 	if (max_leaf >= HVCPUID_VERSION) {
 		eax = 0;
 		ebx = 0;
@@ -115,14 +95,17 @@ static int query_hypervisor_info(void)
 		edx = 0;
 		op = HVCPUID_VERSION;
 		cpuid(op, &eax, &ebx, &ecx, &edx);
-		DPRINT_INFO(VMBUS, "OS Build:%d-%d.%d-%d-%d.%d",\
-			    eax,
-			    ebx >> 16,
-			    ebx & 0xFFFF,
-			    ecx,
-			    edx >> 24,
-			    edx & 0xFFFFFF);
+
+		pr_info("%s: Hyper-V Host OS Build:%d-%d.%d-%d-%d.%d",
+			VMBUS_MOD,
+			eax,
+			ebx >> 16,
+			ebx & 0xFFFF,
+			ecx,
+			edx >> 24,
+			edx & 0xFFFFFF);
 	}
+
 	return max_leaf;
 }
 
@@ -137,20 +120,12 @@ static u64 do_hypercall(u64 control, void *input, void *output)
 	u64 output_address = (output) ? virt_to_phys(output) : 0;
 	volatile void *hypercall_page = hv_context.hypercall_page;
 
-	DPRINT_DBG(VMBUS, "Hypercall <control %llx input phys %llx virt %p "
-		   "output phys %llx virt %p hypercall %p>",
-		   control, input_address, input,
-		   output_address, output, hypercall_page);
-
 	__asm__ __volatile__("mov %0, %%r8" : : "r" (output_address) : "r8");
 	__asm__ __volatile__("call *%3" : "=a" (hv_status) :
 			     "c" (control), "d" (input_address),
 			     "m" (hypercall_page));
 
-	DPRINT_DBG(VMBUS, "Hypercall <return %llx>",  hv_status);
-
 	return hv_status;
-
 #else
 
 	u32 control_hi = control >> 32;
@@ -165,18 +140,12 @@ static u64 do_hypercall(u64 control, void *input, void *output)
 	u32 output_address_lo = output_address & 0xFFFFFFFF;
 	volatile void *hypercall_page = hv_context.hypercall_page;
 
-	DPRINT_DBG(VMBUS, "Hypercall <control %llx input %p output %p>",
-		   control, input, output);
-
 	__asm__ __volatile__ ("call *%8" : "=d"(hv_status_hi),
 			      "=a"(hv_status_lo) : "d" (control_hi),
 			      "a" (control_lo), "b" (input_address_hi),
 			      "c" (input_address_lo), "D"(output_address_hi),
 			      "S"(output_address_lo), "m" (hypercall_page));
 
-	DPRINT_DBG(VMBUS, "Hypercall <return %llx>",
-		   hv_status_lo | ((u64)hv_status_hi << 32));
-
 	return hv_status_lo | ((u64)hv_status_hi << 32);
 #endif /* !x86_64 */
 }
@@ -198,13 +167,10 @@ int hv_init(void)
 	       sizeof(void *) * MAX_NUM_CPUS);
 
 	if (!query_hypervisor_presence()) {
-		DPRINT_ERR(VMBUS, "No Windows hypervisor detected!!");
+		pr_err("%s: %s No Hyper-V detected", VMBUS_MOD, __func__);
 		goto Cleanup;
 	}
 
-	DPRINT_INFO(VMBUS,
-		    "Windows hypervisor detected! Retrieving more info...");
-
 	max_leaf = query_hypervisor_info();
 	/* HvQueryHypervisorFeatures(maxLeaf); */
 
@@ -214,8 +180,8 @@ int hv_init(void)
 	rdmsrl(HV_X64_MSR_GUEST_OS_ID, hv_context.guestid);
 
 	if (hv_context.guestid != 0) {
-		DPRINT_ERR(VMBUS, "Unknown guest id (0x%llx)!!",
-				hv_context.guestid);
+		pr_err("%s: %s Unknown guest id (0x%llx)",
+		       VMBUS_MOD, __func__, hv_context.guestid);
 		goto Cleanup;
 	}
 
@@ -233,8 +199,8 @@ int hv_init(void)
 	virtaddr = __vmalloc(PAGE_SIZE, GFP_KERNEL, PAGE_KERNEL_EXEC);
 
 	if (!virtaddr) {
-		DPRINT_ERR(VMBUS,
-			   "unable to allocate hypercall page!!");
+		pr_err("%s: %s unable to allocate hypercall page",
+		       VMBUS_MOD, __func__);
 		goto Cleanup;
 	}
 
@@ -248,16 +214,13 @@ int hv_init(void)
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
 	if (!hypercall_msr.enable) {
-		DPRINT_ERR(VMBUS, "unable to set hypercall page!!");
+		pr_err("%s: %s Unable to set hypercall page",
+			VMBUS_MOD, __func__);
 		goto Cleanup;
 	}
 
 	hv_context.hypercall_page = virtaddr;
 
-	DPRINT_INFO(VMBUS, "Hypercall page VA=%p, PA=0x%0llx",
-		    hv_context.hypercall_page,
-		    (u64)hypercall_msr.guest_physical_address << PAGE_SHIFT);
-
 	/* Setup the global signal event param for the signal event hypercall */
 	hv_context.signal_event_buffer =
 			kmalloc(sizeof(struct hv_input_signal_event_buffer),
@@ -394,14 +357,12 @@ void hv_synic_init(void *irqarg)
 	/* Check the version */
 	rdmsrl(HV_X64_MSR_SVERSION, version);
 
-	DPRINT_INFO(VMBUS, "SynIC version: %llx", version);
-
 	hv_context.synic_message_page[cpu] =
 		(void *)get_zeroed_page(GFP_ATOMIC);
 
 	if (hv_context.synic_message_page[cpu] == NULL) {
-		DPRINT_ERR(VMBUS,
-			   "unable to allocate SYNIC message page!!");
+		pr_err("%s: %s Unable to allocate SYNIC message page",
+		       VMBUS_MOD, __func__);
 		goto Cleanup;
 	}
 
@@ -409,8 +370,8 @@ void hv_synic_init(void *irqarg)
 		(void *)get_zeroed_page(GFP_ATOMIC);
 
 	if (hv_context.synic_event_page[cpu] == NULL) {
-		DPRINT_ERR(VMBUS,
-			   "unable to allocate SYNIC event page!!");
+		pr_err("%s: %s Unable to allocate SYNIC event page",
+		       VMBUS_MOD, __func__);
 		goto Cleanup;
 	}
 
@@ -420,8 +381,6 @@ void hv_synic_init(void *irqarg)
 	simp.base_simp_gpa = virt_to_phys(hv_context.synic_message_page[cpu])
 		>> PAGE_SHIFT;
 
-	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIMP msr set to: %llx", simp.as_uint64);
-
 	wrmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
 
 	/* Setup the Synic's event page */
@@ -430,8 +389,6 @@ void hv_synic_init(void *irqarg)
 	siefp.base_siefp_gpa = virt_to_phys(hv_context.synic_event_page[cpu])
 		>> PAGE_SHIFT;
 
-	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIEFP msr set to: %llx", siefp.as_uint64);
-
 	wrmsrl(HV_X64_MSR_SIEFP, siefp.as_uint64);
 
 	/* Setup the interception SINT. */
@@ -446,9 +403,6 @@ void hv_synic_init(void *irqarg)
 	shared_sint.masked = false;
 	shared_sint.auto_eoi = true;
 
-	DPRINT_DBG(VMBUS, "HV_X64_MSR_SINT1 msr set to: %llx",
-		   shared_sint.as_uint64);
-
 	wrmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
 
 	/* Enable the global synic bit */
-- 
1.6.0.2

