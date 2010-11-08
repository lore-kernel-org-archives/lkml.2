Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab0KHWDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:03:07 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45987
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755771Ab0KHWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:03:01 -0500
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 03/10] staging: hv: Convert camel cased struct fields in hv.h to lower cases
Date: Mon,  8 Nov 2010 14:04:40 -0800
Message-Id: <1289253887-2596-3-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1289253887-2596-2-git-send-email-haiyangz@linuxonhyperv.com>
References: <1289253887-2596-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-2-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

staging: hv: Convert camel cased struct fields in hv.h to lower cases

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/hv.c    |   95 +++++++++++++++++++++++---------------------
 drivers/staging/hv/hv.h    |   20 +++++-----
 drivers/staging/hv/vmbus.c |    6 +-
 3 files changed, 63 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index ab03327..d0e8c85 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -28,11 +28,11 @@
 #include "vmbus_private.h"
 
 /* The one and only */
-struct hv_context gHvContext = {
-	.SynICInitialized	= false,
-	.HypercallPage		= NULL,
-	.SignalEventParam	= NULL,
-	.SignalEventBuffer	= NULL,
+struct hv_context hv_context = {
+	.synic_initialized	= false,
+	.hypercall_page		= NULL,
+	.signal_event_param	= NULL,
+	.signal_event_buffer	= NULL,
 };
 
 /*
@@ -134,7 +134,7 @@ static u64 HvDoHypercall(u64 Control, void *Input, void *Output)
 	u64 hvStatus = 0;
 	u64 inputAddress = (Input) ? virt_to_phys(Input) : 0;
 	u64 outputAddress = (Output) ? virt_to_phys(Output) : 0;
-	volatile void *hypercallPage = gHvContext.HypercallPage;
+	volatile void *hypercallPage = hv_context.hypercall_page;
 
 	DPRINT_DBG(VMBUS, "Hypercall <control %llx input phys %llx virt %p "
 		   "output phys %llx virt %p hypercall %p>",
@@ -162,7 +162,7 @@ static u64 HvDoHypercall(u64 Control, void *Input, void *Output)
 	u64 outputAddress = (Output) ? virt_to_phys(Output) : 0;
 	u32 outputAddressHi = outputAddress >> 32;
 	u32 outputAddressLo = outputAddress & 0xFFFFFFFF;
-	volatile void *hypercallPage = gHvContext.HypercallPage;
+	volatile void *hypercallPage = hv_context.hypercall_page;
 
 	DPRINT_DBG(VMBUS, "Hypercall <control %llx input %p output %p>",
 		   Control, Input, Output);
@@ -192,8 +192,9 @@ int HvInit(void)
 	union hv_x64_msr_hypercall_contents hypercallMsr;
 	void *virtAddr = NULL;
 
-	memset(gHvContext.synICEventPage, 0, sizeof(void *) * MAX_NUM_CPUS);
-	memset(gHvContext.synICMessagePage, 0, sizeof(void *) * MAX_NUM_CPUS);
+	memset(hv_context.synic_event_page, 0, sizeof(void *) * MAX_NUM_CPUS);
+	memset(hv_context.synic_message_page, 0,
+	       sizeof(void *) * MAX_NUM_CPUS);
 
 	if (!HvQueryHypervisorPresence()) {
 		DPRINT_ERR(VMBUS, "No Windows hypervisor detected!!");
@@ -209,17 +210,17 @@ int HvInit(void)
 	/*
 	 * We only support running on top of Hyper-V
 	 */
-	rdmsrl(HV_X64_MSR_GUEST_OS_ID, gHvContext.GuestId);
+	rdmsrl(HV_X64_MSR_GUEST_OS_ID, hv_context.guestid);
 
-	if (gHvContext.GuestId != 0) {
+	if (hv_context.guestid != 0) {
 		DPRINT_ERR(VMBUS, "Unknown guest id (0x%llx)!!",
-				gHvContext.GuestId);
+				hv_context.guestid);
 		goto Cleanup;
 	}
 
 	/* Write our OS info */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, HV_LINUX_GUEST_ID);
-	gHvContext.GuestId = HV_LINUX_GUEST_ID;
+	hv_context.guestid = HV_LINUX_GUEST_ID;
 
 	/* See if the hypercall page is already set */
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
@@ -250,28 +251,29 @@ int HvInit(void)
 		goto Cleanup;
 	}
 
-	gHvContext.HypercallPage = virtAddr;
+	hv_context.hypercall_page = virtAddr;
 
 	DPRINT_INFO(VMBUS, "Hypercall page VA=%p, PA=0x%0llx",
-		    gHvContext.HypercallPage,
+		    hv_context.hypercall_page,
 		    (u64)hypercallMsr.guest_physical_address << PAGE_SHIFT);
 
 	/* Setup the global signal event param for the signal event hypercall */
-	gHvContext.SignalEventBuffer =
+	hv_context.signal_event_buffer =
 			kmalloc(sizeof(struct hv_input_signal_event_buffer),
 				GFP_KERNEL);
-	if (!gHvContext.SignalEventBuffer)
+	if (!hv_context.signal_event_buffer)
 		goto Cleanup;
 
-	gHvContext.SignalEventParam =
+	hv_context.signal_event_param =
 		(struct hv_input_signal_event *)
-			(ALIGN_UP((unsigned long)gHvContext.SignalEventBuffer,
+			(ALIGN_UP((unsigned long)
+				  hv_context.signal_event_buffer,
 				  HV_HYPERCALL_PARAM_ALIGN));
-	gHvContext.SignalEventParam->connectionid.asu32 = 0;
-	gHvContext.SignalEventParam->connectionid.u.id =
+	hv_context.signal_event_param->connectionid.asu32 = 0;
+	hv_context.signal_event_param->connectionid.u.id =
 						VMBUS_EVENT_CONNECTION_ID;
-	gHvContext.SignalEventParam->flag_number = 0;
-	gHvContext.SignalEventParam->rsvdz = 0;
+	hv_context.signal_event_param->flag_number = 0;
+	hv_context.signal_event_param->rsvdz = 0;
 
 	return ret;
 
@@ -297,15 +299,15 @@ void HvCleanup(void)
 {
 	union hv_x64_msr_hypercall_contents hypercallMsr;
 
-	kfree(gHvContext.SignalEventBuffer);
-	gHvContext.SignalEventBuffer = NULL;
-	gHvContext.SignalEventParam = NULL;
+	kfree(hv_context.signal_event_buffer);
+	hv_context.signal_event_buffer = NULL;
+	hv_context.signal_event_param = NULL;
 
-	if (gHvContext.HypercallPage) {
+	if (hv_context.hypercall_page) {
 		hypercallMsr.as_uint64 = 0;
 		wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.as_uint64);
-		vfree(gHvContext.HypercallPage);
-		gHvContext.HypercallPage = NULL;
+		vfree(hv_context.hypercall_page);
+		hv_context.hypercall_page = NULL;
 	}
 }
 
@@ -359,7 +361,8 @@ u16 HvSignalEvent(void)
 {
 	u16 status;
 
-	status = HvDoHypercall(HVCALL_SIGNAL_EVENT, gHvContext.SignalEventParam,
+	status = HvDoHypercall(HVCALL_SIGNAL_EVENT,
+			       hv_context.signal_event_param,
 			       NULL) & 0xFFFF;
 	return status;
 }
@@ -382,7 +385,7 @@ void HvSynicInit(void *irqarg)
 	u32 irqVector = *((u32 *)(irqarg));
 	int cpu = smp_processor_id();
 
-	if (!gHvContext.HypercallPage)
+	if (!hv_context.hypercall_page)
 		return;
 
 	/* Check the version */
@@ -390,17 +393,19 @@ void HvSynicInit(void *irqarg)
 
 	DPRINT_INFO(VMBUS, "SynIC version: %llx", version);
 
-	gHvContext.synICMessagePage[cpu] = (void *)get_zeroed_page(GFP_ATOMIC);
+	hv_context.synic_message_page[cpu] =
+		(void *)get_zeroed_page(GFP_ATOMIC);
 
-	if (gHvContext.synICMessagePage[cpu] == NULL) {
+	if (hv_context.synic_message_page[cpu] == NULL) {
 		DPRINT_ERR(VMBUS,
 			   "unable to allocate SYNIC message page!!");
 		goto Cleanup;
 	}
 
-	gHvContext.synICEventPage[cpu] = (void *)get_zeroed_page(GFP_ATOMIC);
+	hv_context.synic_event_page[cpu] =
+		(void *)get_zeroed_page(GFP_ATOMIC);
 
-	if (gHvContext.synICEventPage[cpu] == NULL) {
+	if (hv_context.synic_event_page[cpu] == NULL) {
 		DPRINT_ERR(VMBUS,
 			   "unable to allocate SYNIC event page!!");
 		goto Cleanup;
@@ -409,7 +414,7 @@ void HvSynicInit(void *irqarg)
 	/* Setup the Synic's message page */
 	rdmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
 	simp.simp_enabled = 1;
-	simp.base_simp_gpa = virt_to_phys(gHvContext.synICMessagePage[cpu])
+	simp.base_simp_gpa = virt_to_phys(hv_context.synic_message_page[cpu])
 		>> PAGE_SHIFT;
 
 	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIMP msr set to: %llx", simp.as_uint64);
@@ -419,7 +424,7 @@ void HvSynicInit(void *irqarg)
 	/* Setup the Synic's event page */
 	rdmsrl(HV_X64_MSR_SIEFP, siefp.as_uint64);
 	siefp.siefp_enabled = 1;
-	siefp.base_siefp_gpa = virt_to_phys(gHvContext.synICEventPage[cpu])
+	siefp.base_siefp_gpa = virt_to_phys(hv_context.synic_event_page[cpu])
 		>> PAGE_SHIFT;
 
 	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIEFP msr set to: %llx", siefp.as_uint64);
@@ -449,15 +454,15 @@ void HvSynicInit(void *irqarg)
 
 	wrmsrl(HV_X64_MSR_SCONTROL, sctrl.as_uint64);
 
-	gHvContext.SynICInitialized = true;
+	hv_context.synic_initialized = true;
 	return;
 
 Cleanup:
-	if (gHvContext.synICEventPage[cpu])
-		osd_PageFree(gHvContext.synICEventPage[cpu], 1);
+	if (hv_context.synic_event_page[cpu])
+		osd_PageFree(hv_context.synic_event_page[cpu], 1);
 
-	if (gHvContext.synICMessagePage[cpu])
-		osd_PageFree(gHvContext.synICMessagePage[cpu], 1);
+	if (hv_context.synic_message_page[cpu])
+		osd_PageFree(hv_context.synic_message_page[cpu], 1);
 	return;
 }
 
@@ -471,7 +476,7 @@ void HvSynicCleanup(void *arg)
 	union hv_synic_siefp siefp;
 	int cpu = smp_processor_id();
 
-	if (!gHvContext.SynICInitialized)
+	if (!hv_context.synic_initialized)
 		return;
 
 	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.as_uint64);
@@ -494,6 +499,6 @@ void HvSynicCleanup(void *arg)
 
 	wrmsrl(HV_X64_MSR_SIEFP, siefp.as_uint64);
 
-	osd_PageFree(gHvContext.synICMessagePage[cpu], 1);
-	osd_PageFree(gHvContext.synICEventPage[cpu], 1);
+	osd_PageFree(hv_context.synic_message_page[cpu], 1);
+	osd_PageFree(hv_context.synic_event_page[cpu], 1);
 }
diff --git a/drivers/staging/hv/hv.h b/drivers/staging/hv/hv.h
index 41f5ebb..6e396fc 100644
--- a/drivers/staging/hv/hv.h
+++ b/drivers/staging/hv/hv.h
@@ -92,33 +92,33 @@ static const struct hv_guid VMBUS_SERVICE_ID = {
 
 
 struct hv_input_signal_event_buffer {
-	u64 Align8;
-	struct hv_input_signal_event Event;
+	u64 align8;
+	struct hv_input_signal_event event;
 };
 
 struct hv_context {
 	/* We only support running on top of Hyper-V
 	* So at this point this really can only contain the Hyper-V ID
 	*/
-	u64 GuestId;
+	u64 guestid;
 
-	void *HypercallPage;
+	void *hypercall_page;
 
-	bool SynICInitialized;
+	bool synic_initialized;
 
 	/*
 	 * This is used as an input param to HvCallSignalEvent hypercall. The
 	 * input param is immutable in our usage and must be dynamic mem (vs
 	 * stack or global). */
-	struct hv_input_signal_event_buffer *SignalEventBuffer;
+	struct hv_input_signal_event_buffer *signal_event_buffer;
 	/* 8-bytes aligned of the buffer above */
-	struct hv_input_signal_event *SignalEventParam;
+	struct hv_input_signal_event *signal_event_param;
 
-	void *synICMessagePage[MAX_NUM_CPUS];
-	void *synICEventPage[MAX_NUM_CPUS];
+	void *synic_message_page[MAX_NUM_CPUS];
+	void *synic_event_page[MAX_NUM_CPUS];
 };
 
-extern struct hv_context gHvContext;
+extern struct hv_context hv_context;
 
 
 /* Hv Interface */
diff --git a/drivers/staging/hv/vmbus.c b/drivers/staging/hv/vmbus.c
index 7c54ca9..b1ec876 100644
--- a/drivers/staging/hv/vmbus.c
+++ b/drivers/staging/hv/vmbus.c
@@ -147,7 +147,7 @@ static void VmbusOnCleanup(struct hv_driver *drv)
 static void VmbusOnMsgDPC(struct hv_driver *drv)
 {
 	int cpu = smp_processor_id();
-	void *page_addr = gHvContext.synICMessagePage[cpu];
+	void *page_addr = hv_context.synic_message_page[cpu];
 	struct hv_message *msg = (struct hv_message *)page_addr +
 				  VMBUS_MESSAGE_SINT;
 	struct hv_message *copied;
@@ -208,7 +208,7 @@ static int VmbusOnISR(struct hv_driver *drv)
 	struct hv_message *msg;
 	union hv_synic_event_flags *event;
 
-	page_addr = gHvContext.synICMessagePage[cpu];
+	page_addr = hv_context.synic_message_page[cpu];
 	msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Check if there are actual msgs to be process */
@@ -220,7 +220,7 @@ static int VmbusOnISR(struct hv_driver *drv)
 	}
 
 	/* TODO: Check if there are events to be process */
-	page_addr = gHvContext.synICEventPage[cpu];
+	page_addr = hv_context.synic_event_page[cpu];
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Since we are a child, we only need to check bit 0 */
-- 
1.6.3.2

