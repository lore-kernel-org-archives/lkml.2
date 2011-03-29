Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1C2UsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:48:12 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:55903
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751285Ab1C2UsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:48:09 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 01/07] Remove all unneeded DPRINT from hv_vmbus
Date: Tue, 29 Mar 2011 13:58:44 -0700
Message-Id: <1301432330-1705-2-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
References: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all un-needed DPRINT calls from hv_vmbus. Several
are remaining that will be cleaned up in my next set of patches.
They deal with printing out the ringbuffer debugging which is
going to be implemented slightly differently.

This patch deals with hv_vmbus only.

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/channel.c      |   70 ++++---------------------------------
 drivers/staging/hv/channel_mgmt.c |   51 ++-------------------------
 drivers/staging/hv/connection.c   |    9 -----
 drivers/staging/hv/hv.c           |   54 ++++------------------------
 drivers/staging/hv/ring_buffer.c  |   20 ----------
 drivers/staging/hv/vmbus_drv.c    |   69 +-----------------------------------
 6 files changed, 21 insertions(+), 252 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 775a52a..c90dbaf 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -213,9 +213,6 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 
 	/* Establish the gpadl for the ring buffer */
-	DPRINT_DBG(VMBUS, "Establishing ring buffer's gpadl for channel %p...",
-		   newchannel);
-
 	newchannel->ringbuffer_gpadlhandle = 0;
 
 	ret = vmbus_establish_gpadl(newchannel,
@@ -229,16 +226,6 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		goto errorout;
 	}
 
-	DPRINT_DBG(VMBUS, "channel %p <relid %d gpadl 0x%x send ring %p "
-		   "size %d recv ring %p size %d, downstreamoffset %d>",
-		   newchannel, newchannel->offermsg.child_relid,
-		   newchannel->ringbuffer_gpadlhandle,
-		   newchannel->outbound.ring_buffer,
-		   newchannel->outbound.ring_size,
-		   newchannel->inbound.ring_buffer,
-		   newchannel->inbound.ring_size,
-		   send_ringbuffer_size);
-
 	/* Create and init the channel open message */
 	openInfo = kmalloc(sizeof(*openInfo) +
 			   sizeof(struct vmbus_channel_open_channel),
@@ -272,14 +259,11 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		      &vmbus_connection.chn_msg_list);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
-	DPRINT_DBG(VMBUS, "Sending channel open msg...");
-
 	ret = vmbus_post_msg(openMsg,
 			       sizeof(struct vmbus_channel_open_channel));
-	if (ret != 0) {
-		DPRINT_ERR(VMBUS, "unable to open channel - %d", ret);
+
+	if (ret != 0)
 		goto Cleanup;
-	}
 
 	openInfo->wait_condition = 0;
 	wait_event_timeout(openInfo->waitevent,
@@ -291,11 +275,8 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	}
 
 
-	if (openInfo->response.open_result.status == 0)
-		DPRINT_INFO(VMBUS, "channel <%p> open success!!", newchannel);
-	else
-		DPRINT_INFO(VMBUS, "channel <%p> open failed - %d!!",
-			    newchannel, openInfo->response.open_result.status);
+	if (openInfo->response.open_result.status)
+		err = openInfo->response.open_result.status;
 
 Cleanup:
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
@@ -303,7 +284,7 @@ Cleanup:
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	kfree(openInfo);
-	return 0;
+	return err;
 
 errorout:
 	ringbuffer_cleanup(&newchannel->outbound);
@@ -326,6 +307,7 @@ static void dump_gpadl_body(struct vmbus_channel_gpadl_body *gpadl, u32 len)
 
 	pfncount = (len - sizeof(struct vmbus_channel_gpadl_body)) /
 		   sizeof(u64);
+
 	DPRINT_DBG(VMBUS, "gpadl body - len %d pfn count %d", len, pfncount);
 
 	for (i = 0; i < pfncount; i++)
@@ -530,19 +512,12 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 		      &vmbus_connection.chn_msg_list);
 
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-	DPRINT_DBG(VMBUS, "buffer %p, size %d msg cnt %d",
-		   kbuffer, size, msgcount);
-
-	DPRINT_DBG(VMBUS, "Sending GPADL Header - len %zd",
-		   msginfo->msgsize - sizeof(*msginfo));
 
 	msginfo->wait_condition = 0;
 	ret = vmbus_post_msg(gpadlmsg, msginfo->msgsize -
 			       sizeof(*msginfo));
-	if (ret != 0) {
-		DPRINT_ERR(VMBUS, "Unable to open channel - %d", ret);
+	if (ret != 0)
 		goto Cleanup;
-	}
 
 	if (msgcount > 1) {
 		list_for_each(curr, &msginfo->submsglist) {
@@ -556,10 +531,6 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 				CHANNELMSG_GPADL_BODY;
 			gpadl_body->gpadl = next_gpadl_handle;
 
-			DPRINT_DBG(VMBUS, "Sending GPADL Body - len %zd",
-				   submsginfo->msgsize -
-				   sizeof(*submsginfo));
-
 			dump_gpadl_body(gpadl_body, submsginfo->msgsize -
 				      sizeof(*submsginfo));
 			ret = vmbus_post_msg(gpadl_body,
@@ -577,12 +548,6 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 
 
 	/* At this point, we received the gpadl created msg */
-	DPRINT_DBG(VMBUS, "Received GPADL created "
-		   "(relid %d, status %d handle %x)",
-		   channel->offermsg.child_relid,
-		   msginfo->response.gpadl_created.creation_status,
-		   gpadlmsg->gpadl);
-
 	*gpadl_handle = gpadlmsg->gpadl;
 
 Cleanup:
@@ -730,9 +695,6 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 	u64 aligned_data = 0;
 	int ret;
 
-	DPRINT_DBG(VMBUS, "channel %p buffer %p len %d",
-		   channel, buffer, bufferlen);
-
 	dump_vmbus_channel(channel);
 
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
@@ -846,10 +808,6 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 
 	dump_vmbus_channel(channel);
 
-	DPRINT_DBG(VMBUS, "data buffer - offset %u len %u pfn count %u",
-		multi_pagebuffer->offset,
-		multi_pagebuffer->len, pfncount);
-
 	if ((pfncount < 0) || (pfncount > MAX_MULTIPAGE_BUFFER_COUNT))
 		return -EINVAL;
 
@@ -926,8 +884,6 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 			     sizeof(struct vmpacket_descriptor));
 	if (ret != 0) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
-
-		/* DPRINT_DBG(VMBUS, "nothing to read!!"); */
 		return 0;
 	}
 
@@ -937,11 +893,6 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 	userlen = packetlen - (desc.offset8 << 3);
 	/* ASSERT(userLen > 0); */
 
-	DPRINT_DBG(VMBUS, "packet received on channel %p relid %d <type %d "
-		   "flag %d tid %llx pktlen %d datalen %d> ",
-		   channel, channel->offermsg.child_relid, desc.type,
-		   desc.flags, desc.trans_id, packetlen, userlen);
-
 	*buffer_actual_len = userlen;
 
 	if (userlen > bufferlen) {
@@ -986,8 +937,6 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 			     sizeof(struct vmpacket_descriptor));
 	if (ret != 0) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
-
-		/* DPRINT_DBG(VMBUS, "nothing to read!!"); */
 		return 0;
 	}
 
@@ -996,11 +945,6 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	packetlen = desc.len8 << 3;
 	userlen = packetlen - (desc.offset8 << 3);
 
-	DPRINT_DBG(VMBUS, "packet received on channel %p relid %d <type %d "
-		   "flag %d tid %llx pktlen %d datalen %d> ",
-		   channel, channel->offermsg.child_relid, desc.type,
-		   desc.flags, desc.trans_id, packetlen, userlen);
-
 	*buffer_actual_len = packetlen;
 
 	if (packetlen > bufferlen) {
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index bc0393a..ebdd9d8 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -290,9 +290,7 @@ static void release_channel(struct work_struct *work)
 						     struct vmbus_channel,
 						     work);
 
-	DPRINT_DBG(VMBUS, "releasing channel (%p)", channel);
 	destroy_workqueue(channel->controlwq);
-	DPRINT_DBG(VMBUS, "channel released (%p)", channel);
 
 	kfree(channel);
 }
@@ -384,8 +382,6 @@ static void vmbus_process_offer(struct work_struct *work)
 	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 
 	if (!fnew) {
-		DPRINT_DBG(VMBUS, "Ignoring duplicate offer for relid (%d)",
-			   newchannel->offermsg.child_relid);
 		free_channel(newchannel);
 		return;
 	}
@@ -400,9 +396,6 @@ static void vmbus_process_offer(struct work_struct *work)
 		&newchannel->offermsg.offer.if_instance,
 		newchannel);
 
-	DPRINT_DBG(VMBUS, "child device object allocated - %p",
-		   newchannel->device_obj);
-
 	/*
 	 * Add the new device to the bus. This will kick off device-driver
 	 * binding which eventually invokes the device driver's AddDevice()
@@ -470,40 +463,12 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 		}
 	}
 
-	if (!fsupported) {
-		DPRINT_DBG(VMBUS, "Ignoring channel offer notification for "
-			   "child relid %d", offer->child_relid);
+	if (!fsupported)
 		return;
-	}
 
 	guidtype = &offer->offer.if_type;
 	guidinstance = &offer->offer.if_instance;
 
-	DPRINT_INFO(VMBUS, "Channel offer notification - "
-		    "child relid %d monitor id %d allocated %d, "
-		    "type {%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-		    "%02x%02x%02x%02x%02x%02x%02x%02x} "
-		    "instance {%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-		    "%02x%02x%02x%02x%02x%02x%02x%02x}",
-		    offer->child_relid, offer->monitorid,
-		    offer->monitor_allocated,
-		    guidtype->data[3], guidtype->data[2],
-		    guidtype->data[1], guidtype->data[0],
-		    guidtype->data[5], guidtype->data[4],
-		    guidtype->data[7], guidtype->data[6],
-		    guidtype->data[8], guidtype->data[9],
-		    guidtype->data[10], guidtype->data[11],
-		    guidtype->data[12], guidtype->data[13],
-		    guidtype->data[14], guidtype->data[15],
-		    guidinstance->data[3], guidinstance->data[2],
-		    guidinstance->data[1], guidinstance->data[0],
-		    guidinstance->data[5], guidinstance->data[4],
-		    guidinstance->data[7], guidinstance->data[6],
-		    guidinstance->data[8], guidinstance->data[9],
-		    guidinstance->data[10], guidinstance->data[11],
-		    guidinstance->data[12], guidinstance->data[13],
-		    guidinstance->data[14], guidinstance->data[15]);
-
 	/* Allocate the channel object and save this offer. */
 	newchannel = alloc_channel();
 	if (!newchannel) {
@@ -511,8 +476,6 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 		return;
 	}
 
-	DPRINT_DBG(VMBUS, "channel object allocated - %p", newchannel);
-
 	memcpy(&newchannel->offermsg, offer,
 	       sizeof(struct vmbus_channel_offer_channel));
 	newchannel->monitor_grp = (u8)offer->monitorid / 32;
@@ -535,11 +498,10 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
 
 	rescind = (struct vmbus_channel_rescind_offer *)hdr;
 	channel = relid2channel(rescind->child_relid);
-	if (channel == NULL) {
-		DPRINT_DBG(VMBUS, "channel not found for relId %d",
-			   rescind->child_relid);
+
+	if (channel == NULL)
+		/* Just return here, no channel found */
 		return;
-	}
 
 	/* work is initialized for vmbus_process_rescind_offer() from
 	 * vmbus_process_offer() where the channel got created */
@@ -573,7 +535,6 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 	unsigned long flags;
 
 	result = (struct vmbus_channel_open_result *)hdr;
-	DPRINT_DBG(VMBUS, "vmbus open result - %d", result->status);
 
 	/*
 	 * Find the open msg, copy the result and signal/unblock the wait event
@@ -618,8 +579,6 @@ static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 	unsigned long flags;
 
 	gpadlcreated = (struct vmbus_channel_gpadl_created *)hdr;
-	DPRINT_DBG(VMBUS, "vmbus gpadl created result - %d",
-		   gpadlcreated->creation_status);
 
 	/*
 	 * Find the establish msg, copy the result and signal/unblock the wait
@@ -770,8 +729,6 @@ void vmbus_onmessage(void *context)
 	hdr = (struct vmbus_channel_message_header *)msg->u.payload;
 	size = msg->header.payload_size;
 
-	DPRINT_DBG(VMBUS, "message type %d size %d", hdr->msgtype, size);
-
 	if (hdr->msgtype >= CHANNELMSG_COUNT) {
 		DPRINT_ERR(VMBUS,
 			   "Received invalid channel message type %d size %d",
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 44b203b..ed2a7a8 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -121,11 +121,6 @@ int vmbus_connect(void)
 
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
-	DPRINT_DBG(VMBUS, "Vmbus connection - interrupt pfn %llx, "
-		   "monitor1 pfn %llx,, monitor2 pfn %llx",
-		   msg->interrupt_page, msg->monitor_page1, msg->monitor_page2);
-
-	DPRINT_DBG(VMBUS, "Sending channel initiate msg...");
 	ret = vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_initiate_contact));
 	if (ret != 0) {
@@ -156,9 +151,7 @@ int vmbus_connect(void)
 
 	/* Check if successful */
 	if (msginfo->response.version_response.version_supported) {
-		DPRINT_INFO(VMBUS, "Vmbus connected!!");
 		vmbus_connection.conn_state = CONNECTED;
-
 	} else {
 		DPRINT_ERR(VMBUS, "Vmbus connection failed!!..."
 			   "current version (%d) not supported",
@@ -300,11 +293,9 @@ void vmbus_on_event(unsigned long data)
 						(unsigned long *)
 						&recv_int_page[dword])) {
 						relid = (dword << 5) + bit;
-						DPRINT_DBG(VMBUS, "event detected for relid - %d", relid);
 
 						if (relid == 0) {
 							/* special case - vmbus channel protocol msg */
-							DPRINT_DBG(VMBUS, "invalid relid - %d", relid);
 							continue;
 						} else {
 							/* QueueWorkItem(VmbusProcessEvent, (void*)relid); */
diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index 2d492ad..d627a83 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -80,7 +80,7 @@ static int query_hypervisor_info(void)
 	op = HVCPUID_VENDOR_MAXFUNCTION;
 	cpuid(op, &eax, &ebx, &ecx, &edx);
 
-	DPRINT_INFO(VMBUS, "Vendor ID: %c%c%c%c%c%c%c%c%c%c%c%c",
+/*	DPRINT_INFO(VMBUS, "Vendor ID: %c%c%c%c%c%c%c%c%c%c%c%c",
 		    (ebx & 0xFF),
 		    ((ebx >> 8) & 0xFF),
 		    ((ebx >> 16) & 0xFF),
@@ -93,9 +93,9 @@ static int query_hypervisor_info(void)
 		    ((edx >> 8) & 0xFF),
 		    ((edx >> 16) & 0xFF),
 		    ((edx >> 24) & 0xFF));
-
+*/
 	max_leaf = eax;
-	eax = 0;
+/*	eax = 0;
 	ebx = 0;
 	ecx = 0;
 	edx = 0;
@@ -107,6 +107,7 @@ static int query_hypervisor_info(void)
 		    ((eax >> 8) & 0xFF),
 		    ((eax >> 16) & 0xFF),
 		    ((eax >> 24) & 0xFF));
+*/
 
 	if (max_leaf >= HVCPUID_VERSION) {
 		eax = 0;
@@ -137,18 +138,11 @@ static u64 do_hypercall(u64 control, void *input, void *output)
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
 
 #else
@@ -165,18 +159,12 @@ static u64 do_hypercall(u64 control, void *input, void *output)
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
@@ -197,13 +185,8 @@ int hv_init(void)
 	memset(hv_context.synic_message_page, 0,
 	       sizeof(void *) * MAX_NUM_CPUS);
 
-	if (!query_hypervisor_presence()) {
-		DPRINT_ERR(VMBUS, "No Windows hypervisor detected!!");
+	if (!query_hypervisor_presence())
 		goto Cleanup;
-	}
-
-	DPRINT_INFO(VMBUS,
-		    "Windows hypervisor detected! Retrieving more info...");
 
 	max_leaf = query_hypervisor_info();
 	/* HvQueryHypervisorFeatures(maxLeaf); */
@@ -213,11 +196,8 @@ int hv_init(void)
 	 */
 	rdmsrl(HV_X64_MSR_GUEST_OS_ID, hv_context.guestid);
 
-	if (hv_context.guestid != 0) {
-		DPRINT_ERR(VMBUS, "Unknown guest id (0x%llx)!!",
-				hv_context.guestid);
+	if (hv_context.guestid != 0)
 		goto Cleanup;
-	}
 
 	/* Write our OS info */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, HV_LINUX_GUEST_ID);
@@ -232,11 +212,8 @@ int hv_init(void)
 	*/
 	virtaddr = __vmalloc(PAGE_SIZE, GFP_KERNEL, PAGE_KERNEL_EXEC);
 
-	if (!virtaddr) {
-		DPRINT_ERR(VMBUS,
-			   "unable to allocate hypercall page!!");
+	if (!virtaddr)
 		goto Cleanup;
-	}
 
 	hypercall_msr.enable = 1;
 
@@ -247,17 +224,11 @@ int hv_init(void)
 	hypercall_msr.as_uint64 = 0;
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
-	if (!hypercall_msr.enable) {
-		DPRINT_ERR(VMBUS, "unable to set hypercall page!!");
+	if (!hypercall_msr.enable)
 		goto Cleanup;
-	}
 
 	hv_context.hypercall_page = virtaddr;
 
-	DPRINT_INFO(VMBUS, "Hypercall page VA=%p, PA=0x%0llx",
-		    hv_context.hypercall_page,
-		    (u64)hypercall_msr.guest_physical_address << PAGE_SHIFT);
-
 	/* Setup the global signal event param for the signal event hypercall */
 	hv_context.signal_event_buffer =
 			kmalloc(sizeof(struct hv_input_signal_event_buffer),
@@ -394,8 +365,6 @@ void hv_synic_init(void *irqarg)
 	/* Check the version */
 	rdmsrl(HV_X64_MSR_SVERSION, version);
 
-	DPRINT_INFO(VMBUS, "SynIC version: %llx", version);
-
 	hv_context.synic_message_page[cpu] =
 		(void *)get_zeroed_page(GFP_ATOMIC);
 
@@ -420,8 +389,6 @@ void hv_synic_init(void *irqarg)
 	simp.base_simp_gpa = virt_to_phys(hv_context.synic_message_page[cpu])
 		>> PAGE_SHIFT;
 
-	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIMP msr set to: %llx", simp.as_uint64);
-
 	wrmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
 
 	/* Setup the Synic's event page */
@@ -430,8 +397,6 @@ void hv_synic_init(void *irqarg)
 	siefp.base_siefp_gpa = virt_to_phys(hv_context.synic_event_page[cpu])
 		>> PAGE_SHIFT;
 
-	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIEFP msr set to: %llx", siefp.as_uint64);
-
 	wrmsrl(HV_X64_MSR_SIEFP, siefp.as_uint64);
 
 	/* Setup the interception SINT. */
@@ -446,9 +411,6 @@ void hv_synic_init(void *irqarg)
 	shared_sint.masked = false;
 	shared_sint.auto_eoi = true;
 
-	DPRINT_DBG(VMBUS, "HV_X64_MSR_SINT1 msr set to: %llx",
-		   shared_sint.as_uint64);
-
 	wrmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
 
 	/* Enable the global synic bit */
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 66688fb..9bd5218 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -372,20 +372,12 @@ int ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
-	DPRINT_DBG(VMBUS, "Writing %u bytes...", totalbytes_towrite);
-
 	/* Dumpring_info(Outring_info, "BEFORE "); */
 
 	/* If there is only room for the packet, assume it is full. */
 	/* Otherwise, the next time around, we think the ring buffer */
 	/* is empty since the read index == write index */
 	if (bytes_avail_towrite <= totalbytes_towrite) {
-		DPRINT_DBG(VMBUS,
-			"No more space left on outbound ring buffer "
-			"(needed %u, avail %u)",
-			totalbytes_towrite,
-			bytes_avail_towrite);
-
 		spin_unlock_irqrestore(&outring_info->ring_lock, flags);
 		return -1;
 	}
@@ -499,18 +491,10 @@ int ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
-	DPRINT_DBG(VMBUS, "Reading %u bytes...", buflen);
-
 	/* Dumpring_info(Inring_info, "BEFORE "); */
 
 	/* Make sure there is something to read */
 	if (bytes_avail_toread < buflen) {
-		DPRINT_DBG(VMBUS,
-			"got callback but not enough to read "
-			"<avail to read %d read size %d>!!",
-			bytes_avail_toread,
-			buflen);
-
 		spin_unlock_irqrestore(&inring_info->ring_lock, flags);
 
 		return -1;
@@ -568,8 +552,6 @@ copyto_ringbuffer(
 
 	/* wrap-around detected! */
 	if (srclen > ring_buffer_size - start_write_offset) {
-		DPRINT_DBG(VMBUS, "wrap-around detected!");
-
 		frag_len = ring_buffer_size - start_write_offset;
 		memcpy(ring_buffer + start_write_offset, src, frag_len);
 		memcpy(ring_buffer, src + frag_len, srclen - frag_len);
@@ -607,8 +589,6 @@ copyfrom_ringbuffer(
 
 	/* wrap-around detected at the src */
 	if (destlen > ring_buffer_size - start_read_offset) {
-		DPRINT_DBG(VMBUS, "src wrap-around detected!");
-
 		frag_len = ring_buffer_size - start_read_offset;
 
 		memcpy(dest, ring_buffer + start_read_offset, frag_len);
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 3263fc8..b320f71 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -245,21 +245,6 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 	struct hv_device *dev = device_to_hv_device(device);
 	int ret;
 
-	DPRINT_INFO(VMBUS_DRV, "generating uevent - VMBUS_DEVICE_CLASS_GUID={"
-		    "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-		    "%02x%02x%02x%02x%02x%02x%02x%02x}",
-		    dev->dev_type.data[3], dev->dev_type.data[2],
-		    dev->dev_type.data[1], dev->dev_type.data[0],
-		    dev->dev_type.data[5], dev->dev_type.data[4],
-		    dev->dev_type.data[7], dev->dev_type.data[6],
-		    dev->dev_type.data[8], dev->dev_type.data[9],
-		    dev->dev_type.data[10],
-		    dev->dev_type.data[11],
-		    dev->dev_type.data[12],
-		    dev->dev_type.data[13],
-		    dev->dev_type.data[14],
-		    dev->dev_type.data[15]);
-
 	ret = add_uevent_var(env, "VMBUS_DEVICE_CLASS_GUID={"
 			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
@@ -323,10 +308,6 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 		   sizeof(struct hv_guid)) == 0) {
 
 		device_ctx->drv = drv->priv;
-		DPRINT_INFO(VMBUS_DRV,
-			    "device object (%p) set to driver object (%p)",
-			    &device_ctx,
-			    device_ctx->drv);
 
 		match = 1;
 	}
@@ -539,22 +520,16 @@ static int vmbus_on_isr(void)
 	msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Check if there are actual msgs to be process */
-	if (msg->header.message_type != HVMSG_NONE) {
-		DPRINT_DBG(VMBUS, "received msg type %d size %d",
-				msg->header.message_type,
-				msg->header.payload_size);
+	if (msg->header.message_type != HVMSG_NONE)
 		ret |= 0x1;
-	}
 
 	/* TODO: Check if there are events to be process */
 	page_addr = hv_context.synic_event_page[cpu];
 	event = (union hv_synic_event_flags *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Since we are a child, we only need to check bit 0 */
-	if (test_and_clear_bit(0, (unsigned long *) &event->flags32[0])) {
-		DPRINT_DBG(VMBUS, "received event %d", event->flags32[0]);
+	if (test_and_clear_bit(0, (unsigned long *) &event->flags32[0]))
 		ret |= 0x2;
-	}
 
 	return ret;
 }
@@ -594,18 +569,6 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 	int ret;
 	unsigned int vector;
 
-	DPRINT_INFO(VMBUS, "+++++++ HV Driver version = %s +++++++",
-		    HV_DRV_VERSION);
-	DPRINT_INFO(VMBUS, "+++++++ Vmbus supported version = %d +++++++",
-			VMBUS_REVISION_NUMBER);
-	DPRINT_INFO(VMBUS, "+++++++ Vmbus using SINT %d +++++++",
-			VMBUS_MESSAGE_SINT);
-	DPRINT_DBG(VMBUS, "sizeof(vmbus_channel_packet_page_buffer)=%zd, "
-			"sizeof(VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER)=%zd",
-			sizeof(struct vmbus_channel_packet_page_buffer),
-			sizeof(struct vmbus_channel_packet_multipage_buffer));
-
-
 	/* Hypervisor initialization...setup hypercall page..etc */
 	ret = hv_init();
 	if (ret != 0) {
@@ -646,8 +609,6 @@ static int vmbus_bus_init(struct pci_dev *pdev)
 	}
 
 	vector = IRQ0_VECTOR + pdev->irq;
-	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", pdev->irq,
-			vector);
 
 	/*
 	 * Notify the hypervisor of our irq and
@@ -761,25 +722,6 @@ struct hv_device *vmbus_child_device_create(struct hv_guid *type,
 		return NULL;
 	}
 
-	DPRINT_DBG(VMBUS_DRV, "child device (%p) allocated - "
-		"type {%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-		"%02x%02x%02x%02x%02x%02x%02x%02x},"
-		"id {%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-		"%02x%02x%02x%02x%02x%02x%02x%02x}",
-		&child_device_obj->device,
-		type->data[3], type->data[2], type->data[1], type->data[0],
-		type->data[5], type->data[4], type->data[7], type->data[6],
-		type->data[8], type->data[9], type->data[10], type->data[11],
-		type->data[12], type->data[13], type->data[14], type->data[15],
-		instance->data[3], instance->data[2],
-		instance->data[1], instance->data[0],
-		instance->data[5], instance->data[4],
-		instance->data[7], instance->data[6],
-		instance->data[8], instance->data[9],
-		instance->data[10], instance->data[11],
-		instance->data[12], instance->data[13],
-		instance->data[14], instance->data[15]);
-
 	child_device_obj->channel = channel;
 	memcpy(&child_device_obj->dev_type, type, sizeof(struct hv_guid));
 	memcpy(&child_device_obj->dev_instance, instance,
@@ -798,9 +740,6 @@ int vmbus_child_device_register(struct hv_device *child_device_obj)
 
 	static atomic_t device_num = ATOMIC_INIT(0);
 
-	DPRINT_DBG(VMBUS_DRV, "child device (%p) registering",
-		   child_device_obj);
-
 	/* Set the device name. Otherwise, device_register() will fail. */
 	dev_set_name(&child_device_obj->device, "vmbus_0_%d",
 		     atomic_inc_return(&device_num));
@@ -835,10 +774,6 @@ int vmbus_child_device_register(struct hv_device *child_device_obj)
  */
 void vmbus_child_device_unregister(struct hv_device *device_obj)
 {
-
-	DPRINT_INFO(VMBUS_DRV, "unregistering child device (%p)",
-		    &device_obj->device);
-
 	/*
 	 * Kick off the process of unregistering the device.
 	 * This will call vmbus_remove() and eventually vmbus_device_release()
-- 
1.6.0.2

