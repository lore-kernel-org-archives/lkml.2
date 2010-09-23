Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab0IWWFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:05:05 -0400
Received: from maila.microsoft.com ([131.107.115.212]:53502 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab0IWWFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:05:01 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] Rename camel case variables in channel.c  (updated)
Thread-Topic: [PATCH 1/1] Rename camel case variables in channel.c  (updated)
Thread-Index: ActbazpiIW5evuV4R4i5lbZ6gtNChQ==
Date: Thu, 23 Sep 2010 22:04:54 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7289ED89CF@TK5EX14MBXC130.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Rename camel case variables in channel.c

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c |  733 +++++++++++++++++++++---------------------
 1 files changed, 370 insertions(+), 363 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 37b7b4c..ceeadac 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -28,10 +28,10 @@
 
 /* Internal routines */
 static int VmbusChannelCreateGpadlHeader(
-	void *Kbuffer,	/* must be phys and virt contiguous */
-	u32 Size,	/* page-size multiple */
-	struct vmbus_channel_msginfo **msgInfo,
-	u32 *MessageCount);
+	void *kbuffer,	/* must be phys and virt contiguous */
+	u32 size,	/* page-size multiple */
+	struct vmbus_channel_msginfo **msginfo,
+	u32 *messagecount);
 static void DumpVmbusChannel(struct vmbus_channel *channel);
 static void VmbusChannelSetEvent(struct vmbus_channel *channel);
 
@@ -70,25 +70,25 @@ static void DumpMonitorPage(struct hv_monitor_page *MonitorPage)
  * VmbusChannelSetEvent - Trigger an event notification on the specified
  * channel.
  */
-static void VmbusChannelSetEvent(struct vmbus_channel *Channel)
+static void VmbusChannelSetEvent(struct vmbus_channel *channel)
 {
-	struct hv_monitor_page *monitorPage;
+	struct hv_monitor_page *monitorpage;
 
-	if (Channel->OfferMsg.MonitorAllocated) {
+	if (channel->OfferMsg.MonitorAllocated) {
 		/* Each u32 represents 32 channels */
-		set_bit(Channel->OfferMsg.ChildRelId & 31,
+		set_bit(channel->OfferMsg.ChildRelId & 31,
 			(unsigned long *) gVmbusConnection.SendInterruptPage +
-			(Channel->OfferMsg.ChildRelId >> 5));
+			(channel->OfferMsg.ChildRelId >> 5));
 
-		monitorPage = gVmbusConnection.MonitorPages;
-		monitorPage++; /* Get the child to parent monitor page */
+		monitorpage = gVmbusConnection.MonitorPages;
+		monitorpage++; /* Get the child to parent monitor page */
 
-		set_bit(Channel->MonitorBit,
-			(unsigned long *)&monitorPage->TriggerGroup
-					[Channel->MonitorGroup].Pending);
+		set_bit(channel->MonitorBit,
+			(unsigned long *)&monitorpage->TriggerGroup
+					[channel->MonitorGroup].Pending);
 
 	} else {
-		VmbusSetEvent(Channel->OfferMsg.ChildRelId);
+		VmbusSetEvent(channel->OfferMsg.ChildRelId);
 	}
 }
 
@@ -117,54 +117,54 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)
 /*
  * VmbusChannelGetDebugInfo -Retrieve various channel debug info
  */
-void VmbusChannelGetDebugInfo(struct vmbus_channel *Channel,
-			      struct vmbus_channel_debug_info *DebugInfo)
+void VmbusChannelGetDebugInfo(struct vmbus_channel *channel,
+			      struct vmbus_channel_debug_info *debuginfo)
 {
-	struct hv_monitor_page *monitorPage;
-	u8 monitorGroup = (u8)Channel->OfferMsg.MonitorId / 32;
-	u8 monitorOffset = (u8)Channel->OfferMsg.MonitorId % 32;
+	struct hv_monitor_page *monitorpage;
+	u8 monitor_group = (u8)channel->OfferMsg.MonitorId / 32;
+	u8 monitor_offset = (u8)channel->OfferMsg.MonitorId % 32;
 	/* u32 monitorBit	= 1 << monitorOffset; */
 
-	DebugInfo->RelId = Channel->OfferMsg.ChildRelId;
-	DebugInfo->State = Channel->State;
-	memcpy(&DebugInfo->InterfaceType,
-	       &Channel->OfferMsg.Offer.InterfaceType, sizeof(struct hv_guid));
-	memcpy(&DebugInfo->InterfaceInstance,
-	       &Channel->OfferMsg.Offer.InterfaceInstance,
+	debuginfo->RelId = channel->OfferMsg.ChildRelId;
+	debuginfo->State = channel->State;
+	memcpy(&debuginfo->InterfaceType,
+	       &channel->OfferMsg.Offer.InterfaceType, sizeof(struct hv_guid));
+	memcpy(&debuginfo->InterfaceInstance,
+	       &channel->OfferMsg.Offer.InterfaceInstance,
 	       sizeof(struct hv_guid));
 
-	monitorPage = (struct hv_monitor_page *)gVmbusConnection.MonitorPages;
+	monitorpage = (struct hv_monitor_page *)gVmbusConnection.MonitorPages;
 
-	DebugInfo->MonitorId = Channel->OfferMsg.MonitorId;
+	debuginfo->MonitorId = channel->OfferMsg.MonitorId;
 
-	DebugInfo->ServerMonitorPending =
-			monitorPage->TriggerGroup[monitorGroup].Pending;
-	DebugInfo->ServerMonitorLatency =
-			monitorPage->Latency[monitorGroup][monitorOffset];
-	DebugInfo->ServerMonitorConnectionId =
-			monitorPage->Parameter[monitorGroup]
-					      [monitorOffset].ConnectionId.u.Id;
+	debuginfo->ServerMonitorPending =
+			monitorpage->TriggerGroup[monitor_group].Pending;
+	debuginfo->ServerMonitorLatency =
+			monitorpage->Latency[monitor_group][monitor_offset];
+	debuginfo->ServerMonitorConnectionId =
+			monitorpage->Parameter[monitor_group]
+					[monitor_offset].ConnectionId.u.Id;
 
-	monitorPage++;
+	monitorpage++;
 
-	DebugInfo->ClientMonitorPending =
-			monitorPage->TriggerGroup[monitorGroup].Pending;
-	DebugInfo->ClientMonitorLatency =
-			monitorPage->Latency[monitorGroup][monitorOffset];
-	DebugInfo->ClientMonitorConnectionId =
-			monitorPage->Parameter[monitorGroup]
-					      [monitorOffset].ConnectionId.u.Id;
+	debuginfo->ClientMonitorPending =
+			monitorpage->TriggerGroup[monitor_group].Pending;
+	debuginfo->ClientMonitorLatency =
+			monitorpage->Latency[monitor_group][monitor_offset];
+	debuginfo->ClientMonitorConnectionId =
+			monitorpage->Parameter[monitor_group]
+					[monitor_offset].ConnectionId.u.Id;
 
-	RingBufferGetDebugInfo(&Channel->Inbound, &DebugInfo->Inbound);
-	RingBufferGetDebugInfo(&Channel->Outbound, &DebugInfo->Outbound);
+	RingBufferGetDebugInfo(&channel->Inbound, &debuginfo->Inbound);
+	RingBufferGetDebugInfo(&channel->Outbound, &debuginfo->Outbound);
 }
 
 /*
  * VmbusChannelOpen - Open the specified channel.
  */
-int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
-		     u32 RecvRingBufferSize, void *UserData, u32 UserDataLen,
-		     void (*OnChannelCallback)(void *context), void *Context)
+int VmbusChannelOpen(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
+		     u32 recv_ringbuffer_size, void *userdata, u32 userdatalen,
+		     void (*onchannelcallback)(void *context), void *context)
 {
 	struct vmbus_channel_open_channel *openMsg;
 	struct vmbus_channel_msginfo *openInfo = NULL;
@@ -176,30 +176,30 @@ int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
 	/* ASSERT(!(SendRingBufferSize & (PAGE_SIZE - 1))); */
 	/* ASSERT(!(RecvRingBufferSize & (PAGE_SIZE - 1))); */
 
-	NewChannel->OnChannelCallback = OnChannelCallback;
-	NewChannel->ChannelCallbackContext = Context;
+	newchannel->OnChannelCallback = onchannelcallback;
+	newchannel->ChannelCallbackContext = context;
 
 	/* Allocate the ring buffer */
-	out = osd_PageAlloc((SendRingBufferSize + RecvRingBufferSize)
+	out = osd_PageAlloc((send_ringbuffer_size + recv_ringbuffer_size)
 			     >> PAGE_SHIFT);
 	if (!out)
 		return -ENOMEM;
 
 	/* ASSERT(((unsigned long)out & (PAGE_SIZE-1)) == 0); */
 
-	in = (void *)((unsigned long)out + SendRingBufferSize);
+	in = (void *)((unsigned long)out + send_ringbuffer_size);
 
-	NewChannel->RingBufferPages = out;
-	NewChannel->RingBufferPageCount = (SendRingBufferSize +
-					   RecvRingBufferSize) >> PAGE_SHIFT;
+	newchannel->RingBufferPages = out;
+	newchannel->RingBufferPageCount = (send_ringbuffer_size +
+					   recv_ringbuffer_size) >> PAGE_SHIFT;
 
-	ret = RingBufferInit(&NewChannel->Outbound, out, SendRingBufferSize);
+	ret = RingBufferInit(&newchannel->Outbound, out, send_ringbuffer_size);
 	if (ret != 0) {
 		err = ret;
 		goto errorout;
 	}
 
-	ret = RingBufferInit(&NewChannel->Inbound, in, RecvRingBufferSize);
+	ret = RingBufferInit(&newchannel->Inbound, in, recv_ringbuffer_size);
 	if (ret != 0) {
 		err = ret;
 		goto errorout;
@@ -208,15 +208,15 @@ int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
 
 	/* Establish the gpadl for the ring buffer */
 	DPRINT_DBG(VMBUS, "Establishing ring buffer's gpadl for channel %p...",
-		   NewChannel);
+		   newchannel);
 
-	NewChannel->RingBufferGpadlHandle = 0;
+	newchannel->RingBufferGpadlHandle = 0;
 
-	ret = VmbusChannelEstablishGpadl(NewChannel,
-					 NewChannel->Outbound.RingBuffer,
-					 SendRingBufferSize +
-					 RecvRingBufferSize,
-					 &NewChannel->RingBufferGpadlHandle);
+	ret = VmbusChannelEstablishGpadl(newchannel,
+					 newchannel->Outbound.RingBuffer,
+					 send_ringbuffer_size +
+					 recv_ringbuffer_size,
+					 &newchannel->RingBufferGpadlHandle);
 
 	if (ret != 0) {
 		err = ret;
@@ -225,13 +225,13 @@ int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
 
 	DPRINT_DBG(VMBUS, "channel %p <relid %d gpadl 0x%x send ring %p "
 		   "size %d recv ring %p size %d, downstreamoffset %d>",
-		   NewChannel, NewChannel->OfferMsg.ChildRelId,
-		   NewChannel->RingBufferGpadlHandle,
-		   NewChannel->Outbound.RingBuffer,
-		   NewChannel->Outbound.RingSize,
-		   NewChannel->Inbound.RingBuffer,
-		   NewChannel->Inbound.RingSize,
-		   SendRingBufferSize);
+		   newchannel, newchannel->OfferMsg.ChildRelId,
+		   newchannel->RingBufferGpadlHandle,
+		   newchannel->Outbound.RingBuffer,
+		   newchannel->Outbound.RingSize,
+		   newchannel->Inbound.RingBuffer,
+		   newchannel->Inbound.RingSize,
+		   send_ringbuffer_size);
 
 	/* Create and init the channel open message */
 	openInfo = kmalloc(sizeof(*openInfo) +
@@ -250,20 +250,20 @@ int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
 
 	openMsg = (struct vmbus_channel_open_channel *)openInfo->Msg;
 	openMsg->Header.MessageType = ChannelMessageOpenChannel;
-	openMsg->OpenId = NewChannel->OfferMsg.ChildRelId; /* FIXME */
-	openMsg->ChildRelId = NewChannel->OfferMsg.ChildRelId;
-	openMsg->RingBufferGpadlHandle = NewChannel->RingBufferGpadlHandle;
-	openMsg->DownstreamRingBufferPageOffset = SendRingBufferSize >>
+	openMsg->OpenId = newchannel->OfferMsg.ChildRelId; /* FIXME */
+	openMsg->ChildRelId = newchannel->OfferMsg.ChildRelId;
+	openMsg->RingBufferGpadlHandle = newchannel->RingBufferGpadlHandle;
+	openMsg->DownstreamRingBufferPageOffset = send_ringbuffer_size >>
 						  PAGE_SHIFT;
 	openMsg->ServerContextAreaGpadlHandle = 0; /* TODO */
 
-	if (UserDataLen > MAX_USER_DEFINED_BYTES) {
+	if (userdatalen > MAX_USER_DEFINED_BYTES) {
 		err = -EINVAL;
 		goto errorout;
 	}
 
-	if (UserDataLen)
-		memcpy(openMsg->UserData, UserData, UserDataLen);
+	if (userdatalen)
+		memcpy(openMsg->UserData, userdata, userdatalen);
 
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
 	list_add_tail(&openInfo->MsgListEntry,
@@ -283,10 +283,10 @@ int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
 	osd_WaitEventWait(openInfo->WaitEvent);
 
 	if (openInfo->Response.OpenResult.Status == 0)
-		DPRINT_INFO(VMBUS, "channel <%p> open success!!", NewChannel);
+		DPRINT_INFO(VMBUS, "channel <%p> open success!!", newchannel);
 	else
 		DPRINT_INFO(VMBUS, "channel <%p> open failed - %d!!",
-			    NewChannel, openInfo->Response.OpenResult.Status);
+			    newchannel, openInfo->Response.OpenResult.Status);
 
 Cleanup:
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
@@ -298,9 +298,9 @@ Cleanup:
 	return 0;
 
 errorout:
-	RingBufferCleanup(&NewChannel->Outbound);
-	RingBufferCleanup(&NewChannel->Inbound);
-	osd_PageFree(out, (SendRingBufferSize + RecvRingBufferSize)
+	RingBufferCleanup(&newchannel->Outbound);
+	RingBufferCleanup(&newchannel->Inbound);
+	osd_PageFree(out, (send_ringbuffer_size + recv_ringbuffer_size)
 		     >> PAGE_SHIFT);
 	kfree(openInfo);
 	return err;
@@ -310,126 +310,127 @@ errorout:
  * DumpGpadlBody - Dump the gpadl body message to the console for
  * debugging purposes.
  */
-static void DumpGpadlBody(struct vmbus_channel_gpadl_body *Gpadl, u32 Len)
+static void DumpGpadlBody(struct vmbus_channel_gpadl_body *gpadl, u32 len)
 {
 	int i;
-	int pfnCount;
+	int pfncount;
 
-	pfnCount = (Len - sizeof(struct vmbus_channel_gpadl_body)) /
+	pfncount = (len - sizeof(struct vmbus_channel_gpadl_body)) /
 		   sizeof(u64);
-	DPRINT_DBG(VMBUS, "gpadl body - len %d pfn count %d", Len, pfnCount);
+	DPRINT_DBG(VMBUS, "gpadl body - len %d pfn count %d", len, pfncount);
 
-	for (i = 0; i < pfnCount; i++)
+	for (i = 0; i < pfncount; i++)
 		DPRINT_DBG(VMBUS, "gpadl body  - %d) pfn %llu",
-			   i, Gpadl->Pfn[i]);
+			   i, gpadl->Pfn[i]);
 }
 
 /*
  * DumpGpadlHeader - Dump the gpadl header message to the console for
  * debugging purposes.
  */
-static void DumpGpadlHeader(struct vmbus_channel_gpadl_header *Gpadl)
+static void DumpGpadlHeader(struct vmbus_channel_gpadl_header *gpadl)
 {
 	int i, j;
-	int pageCount;
+	int pagecount;
 
 	DPRINT_DBG(VMBUS,
 		   "gpadl header - relid %d, range count %d, range buflen %d",
-		   Gpadl->ChildRelId, Gpadl->RangeCount, Gpadl->RangeBufLen);
-	for (i = 0; i < Gpadl->RangeCount; i++) {
-		pageCount = Gpadl->Range[i].ByteCount >> PAGE_SHIFT;
-		pageCount = (pageCount > 26) ? 26 : pageCount;
+		   gpadl->ChildRelId, gpadl->RangeCount, gpadl->RangeBufLen);
+	for (i = 0; i < gpadl->RangeCount; i++) {
+		pagecount = gpadl->Range[i].ByteCount >> PAGE_SHIFT;
+		pagecount = (pagecount > 26) ? 26 : pagecount;
 
 		DPRINT_DBG(VMBUS, "gpadl range %d - len %d offset %d "
-			   "page count %d", i, Gpadl->Range[i].ByteCount,
-			   Gpadl->Range[i].ByteOffset, pageCount);
+			   "page count %d", i, gpadl->Range[i].ByteCount,
+			   gpadl->Range[i].ByteOffset, pagecount);
 
-		for (j = 0; j < pageCount; j++)
+		for (j = 0; j < pagecount; j++)
 			DPRINT_DBG(VMBUS, "%d) pfn %llu", j,
-				   Gpadl->Range[i].PfnArray[j]);
+				   gpadl->Range[i].PfnArray[j]);
 	}
 }
 
 /*
  * VmbusChannelCreateGpadlHeader - Creates a gpadl for the specified buffer
  */
-static int VmbusChannelCreateGpadlHeader(void *Kbuffer, u32 Size,
-					 struct vmbus_channel_msginfo **MsgInfo,
-					 u32 *MessageCount)
+static int VmbusChannelCreateGpadlHeader(void *kbuffer, u32 size,
+					 struct vmbus_channel_msginfo **msginfo,
+					 u32 *messagecount)
 {
 	int i;
-	int pageCount;
+	int pagecount;
 	unsigned long long pfn;
-	struct vmbus_channel_gpadl_header *gpaHeader;
-	struct vmbus_channel_gpadl_body *gpadlBody;
-	struct vmbus_channel_msginfo *msgHeader;
-	struct vmbus_channel_msginfo *msgBody = NULL;
-	u32 msgSize;
+	struct vmbus_channel_gpadl_header *gpal_header;
+	struct vmbus_channel_gpadl_body *gpadl_body;
+	struct vmbus_channel_msginfo *msgheader;
+	struct vmbus_channel_msginfo *msgbody = NULL;
+	u32 msgsize;
 
-	int pfnSum, pfnCount, pfnLeft, pfnCurr, pfnSize;
+	int pfnsum, pfncount, pfnleft, pfncurr, pfnsize;
 
 	/* ASSERT((kbuffer & (PAGE_SIZE-1)) == 0); */
 	/* ASSERT((Size & (PAGE_SIZE-1)) == 0); */
 
-	pageCount = Size >> PAGE_SHIFT;
-	pfn = virt_to_phys(Kbuffer) >> PAGE_SHIFT;
+	pagecount = size >> PAGE_SHIFT;
+	pfn = virt_to_phys(kbuffer) >> PAGE_SHIFT;
 
 	/* do we need a gpadl body msg */
-	pfnSize = MAX_SIZE_CHANNEL_MESSAGE -
+	pfnsize = MAX_SIZE_CHANNEL_MESSAGE -
 		  sizeof(struct vmbus_channel_gpadl_header) -
 		  sizeof(struct gpa_range);
-	pfnCount = pfnSize / sizeof(u64);
+	pfncount = pfnsize / sizeof(u64);
 
-	if (pageCount > pfnCount) {
+	if (pagecount > pfncount) {
 		/* we need a gpadl body */
 		/* fill in the header */
-		msgSize = sizeof(struct vmbus_channel_msginfo) +
+		msgsize = sizeof(struct vmbus_channel_msginfo) +
 			  sizeof(struct vmbus_channel_gpadl_header) +
-			  sizeof(struct gpa_range) + pfnCount * sizeof(u64);
-		msgHeader =  kzalloc(msgSize, GFP_KERNEL);
-		if (!msgHeader)
+			  sizeof(struct gpa_range) + pfncount * sizeof(u64);
+		msgheader =  kzalloc(msgsize, GFP_KERNEL);
+		if (!msgheader)
 			goto nomem;
 
-		INIT_LIST_HEAD(&msgHeader->SubMsgList);
-		msgHeader->MessageSize = msgSize;
+		INIT_LIST_HEAD(&msgheader->SubMsgList);
+		msgheader->MessageSize = msgsize;
 
-		gpaHeader = (struct vmbus_channel_gpadl_header *)msgHeader->Msg;
-		gpaHeader->RangeCount = 1;
-		gpaHeader->RangeBufLen = sizeof(struct gpa_range) +
-					 pageCount * sizeof(u64);
-		gpaHeader->Range[0].ByteOffset = 0;
-		gpaHeader->Range[0].ByteCount = Size;
-		for (i = 0; i < pfnCount; i++)
-			gpaHeader->Range[0].PfnArray[i] = pfn+i;
-		*MsgInfo = msgHeader;
-		*MessageCount = 1;
+		gpal_header = (struct vmbus_channel_gpadl_header *)
+			msgheader->Msg;
+		gpal_header->RangeCount = 1;
+		gpal_header->RangeBufLen = sizeof(struct gpa_range) +
+					 pagecount * sizeof(u64);
+		gpal_header->Range[0].ByteOffset = 0;
+		gpal_header->Range[0].ByteCount = size;
+		for (i = 0; i < pfncount; i++)
+			gpal_header->Range[0].PfnArray[i] = pfn+i;
+		*msginfo = msgheader;
+		*messagecount = 1;
 
-		pfnSum = pfnCount;
-		pfnLeft = pageCount - pfnCount;
+		pfnsum = pfncount;
+		pfnleft = pagecount - pfncount;
 
 		/* how many pfns can we fit */
-		pfnSize = MAX_SIZE_CHANNEL_MESSAGE -
+		pfnsize = MAX_SIZE_CHANNEL_MESSAGE -
 			  sizeof(struct vmbus_channel_gpadl_body);
-		pfnCount = pfnSize / sizeof(u64);
+		pfncount = pfnsize / sizeof(u64);
 
 		/* fill in the body */
-		while (pfnLeft) {
-			if (pfnLeft > pfnCount)
-				pfnCurr = pfnCount;
+		while (pfnleft) {
+			if (pfnleft > pfncount)
+				pfncurr = pfncount;
 			else
-				pfnCurr = pfnLeft;
+				pfncurr = pfnleft;
 
-			msgSize = sizeof(struct vmbus_channel_msginfo) +
+			msgsize = sizeof(struct vmbus_channel_msginfo) +
 				  sizeof(struct vmbus_channel_gpadl_body) +
-				  pfnCurr * sizeof(u64);
-			msgBody = kzalloc(msgSize, GFP_KERNEL);
+				  pfncurr * sizeof(u64);
+			msgbody = kzalloc(msgsize, GFP_KERNEL);
 			/* FIXME: we probably need to more if this fails */
-			if (!msgBody)
+			if (!msgbody)
 				goto nomem;
-			msgBody->MessageSize = msgSize;
-			(*MessageCount)++;
-			gpadlBody =
-				(struct vmbus_channel_gpadl_body *)msgBody->Msg;
+			msgbody->MessageSize = msgsize;
+			(*messagecount)++;
+			gpadl_body =
+				(struct vmbus_channel_gpadl_body *)msgbody->Msg;
 
 			/*
 			 * FIXME:
@@ -437,42 +438,43 @@ static int VmbusChannelCreateGpadlHeader(void *Kbuffer, u32 Size,
 			 * be 64-bit
 			 */
 			/* gpadlBody->Gpadl = kbuffer; */
-			for (i = 0; i < pfnCurr; i++)
-				gpadlBody->Pfn[i] = pfn + pfnSum + i;
+			for (i = 0; i < pfncurr; i++)
+				gpadl_body->Pfn[i] = pfn + pfnsum + i;
 
 			/* add to msg header */
-			list_add_tail(&msgBody->MsgListEntry,
-				      &msgHeader->SubMsgList);
-			pfnSum += pfnCurr;
-			pfnLeft -= pfnCurr;
+			list_add_tail(&msgbody->MsgListEntry,
+				      &msgheader->SubMsgList);
+			pfnsum += pfncurr;
+			pfnleft -= pfncurr;
 		}
 	} else {
 		/* everything fits in a header */
-		msgSize = sizeof(struct vmbus_channel_msginfo) +
+		msgsize = sizeof(struct vmbus_channel_msginfo) +
 			  sizeof(struct vmbus_channel_gpadl_header) +
-			  sizeof(struct gpa_range) + pageCount * sizeof(u64);
-		msgHeader = kzalloc(msgSize, GFP_KERNEL);
-		if (msgHeader == NULL)
+			  sizeof(struct gpa_range) + pagecount * sizeof(u64);
+		msgheader = kzalloc(msgsize, GFP_KERNEL);
+		if (msgheader == NULL)
 			goto nomem;
-		msgHeader->MessageSize = msgSize;
-
-		gpaHeader = (struct vmbus_channel_gpadl_header *)msgHeader->Msg;
-		gpaHeader->RangeCount = 1;
-		gpaHeader->RangeBufLen = sizeof(struct gpa_range) +
-					 pageCount * sizeof(u64);
-		gpaHeader->Range[0].ByteOffset = 0;
-		gpaHeader->Range[0].ByteCount = Size;
-		for (i = 0; i < pageCount; i++)
-			gpaHeader->Range[0].PfnArray[i] = pfn+i;
-
-		*MsgInfo = msgHeader;
-		*MessageCount = 1;
+		msgheader->MessageSize = msgsize;
+
+		gpal_header = (struct vmbus_channel_gpadl_header *)
+			msgheader->Msg;
+		gpal_header->RangeCount = 1;
+		gpal_header->RangeBufLen = sizeof(struct gpa_range) +
+					 pagecount * sizeof(u64);
+		gpal_header->Range[0].ByteOffset = 0;
+		gpal_header->Range[0].ByteCount = size;
+		for (i = 0; i < pagecount; i++)
+			gpal_header->Range[0].PfnArray[i] = pfn+i;
+
+		*msginfo = msgheader;
+		*messagecount = 1;
 	}
 
 	return 0;
 nomem:
-	kfree(msgHeader);
-	kfree(msgBody);
+	kfree(msgheader);
+	kfree(msgbody);
 	return -ENOMEM;
 }
 
@@ -484,108 +486,109 @@ nomem:
  * @Size: page-size multiple
  * @GpadlHandle: some funky thing
  */
-int VmbusChannelEstablishGpadl(struct vmbus_channel *Channel, void *Kbuffer,
-			       u32 Size, u32 *GpadlHandle)
+int VmbusChannelEstablishGpadl(struct vmbus_channel *channel, void *kbuffer,
+			       u32 size, u32 *gpadl_handle)
 {
-	struct vmbus_channel_gpadl_header *gpadlMsg;
-	struct vmbus_channel_gpadl_body *gpadlBody;
+	struct vmbus_channel_gpadl_header *gpadlmsg;
+	struct vmbus_channel_gpadl_body *gpadl_body;
 	/* struct vmbus_channel_gpadl_created *gpadlCreated; */
-	struct vmbus_channel_msginfo *msgInfo = NULL;
-	struct vmbus_channel_msginfo *subMsgInfo;
-	u32 msgCount;
+	struct vmbus_channel_msginfo *msginfo = NULL;
+	struct vmbus_channel_msginfo *submsginfo;
+	u32 msgcount;
 	struct list_head *curr;
-	u32 nextGpadlHandle;
+	u32 next_gpadl_handle;
 	unsigned long flags;
 	int ret = 0;
 
-	nextGpadlHandle = atomic_read(&gVmbusConnection.NextGpadlHandle);
+	next_gpadl_handle = atomic_read(&gVmbusConnection.NextGpadlHandle);
 	atomic_inc(&gVmbusConnection.NextGpadlHandle);
 
-	ret = VmbusChannelCreateGpadlHeader(Kbuffer, Size, &msgInfo, &msgCount);
+	ret = VmbusChannelCreateGpadlHeader(kbuffer, size, &msginfo, &msgcount);
 	if (ret)
 		return ret;
 
-	msgInfo->WaitEvent = osd_WaitEventCreate();
-	if (!msgInfo->WaitEvent) {
+	msginfo->WaitEvent = osd_WaitEventCreate();
+	if (!msginfo->WaitEvent) {
 		ret = -ENOMEM;
 		goto Cleanup;
 	}
 
-	gpadlMsg = (struct vmbus_channel_gpadl_header *)msgInfo->Msg;
-	gpadlMsg->Header.MessageType = ChannelMessageGpadlHeader;
-	gpadlMsg->ChildRelId = Channel->OfferMsg.ChildRelId;
-	gpadlMsg->Gpadl = nextGpadlHandle;
+	gpadlmsg = (struct vmbus_channel_gpadl_header *)msginfo->Msg;
+	gpadlmsg->Header.MessageType = ChannelMessageGpadlHeader;
+	gpadlmsg->ChildRelId = channel->OfferMsg.ChildRelId;
+	gpadlmsg->Gpadl = next_gpadl_handle;
 
-	DumpGpadlHeader(gpadlMsg);
+	DumpGpadlHeader(gpadlmsg);
 
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_add_tail(&msgInfo->MsgListEntry,
+	list_add_tail(&msginfo->MsgListEntry,
 		      &gVmbusConnection.ChannelMsgList);
 
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
 	DPRINT_DBG(VMBUS, "buffer %p, size %d msg cnt %d",
-		   Kbuffer, Size, msgCount);
+		   kbuffer, size, msgcount);
 
 	DPRINT_DBG(VMBUS, "Sending GPADL Header - len %zd",
-		   msgInfo->MessageSize - sizeof(*msgInfo));
+		   msginfo->MessageSize - sizeof(*msginfo));
 
-	ret = VmbusPostMessage(gpadlMsg, msgInfo->MessageSize -
-			       sizeof(*msgInfo));
+	ret = VmbusPostMessage(gpadlmsg, msginfo->MessageSize -
+			       sizeof(*msginfo));
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS, "Unable to open channel - %d", ret);
 		goto Cleanup;
 	}
 
-	if (msgCount > 1) {
-		list_for_each(curr, &msgInfo->SubMsgList) {
+	if (msgcount > 1) {
+		list_for_each(curr, &msginfo->SubMsgList) {
 
 			/* FIXME: should this use list_entry() instead ? */
-			subMsgInfo = (struct vmbus_channel_msginfo *)curr;
-			gpadlBody =
-			     (struct vmbus_channel_gpadl_body *)subMsgInfo->Msg;
+			submsginfo = (struct vmbus_channel_msginfo *)curr;
+			gpadl_body =
+			     (struct vmbus_channel_gpadl_body *)submsginfo->Msg;
 
-			gpadlBody->Header.MessageType = ChannelMessageGpadlBody;
-			gpadlBody->Gpadl = nextGpadlHandle;
+			gpadl_body->Header.MessageType =
+				ChannelMessageGpadlBody;
+			gpadl_body->Gpadl = next_gpadl_handle;
 
 			DPRINT_DBG(VMBUS, "Sending GPADL Body - len %zd",
-				   subMsgInfo->MessageSize -
-				   sizeof(*subMsgInfo));
-
-			DumpGpadlBody(gpadlBody, subMsgInfo->MessageSize -
-				      sizeof(*subMsgInfo));
-			ret = VmbusPostMessage(gpadlBody,
-					       subMsgInfo->MessageSize -
-					       sizeof(*subMsgInfo));
+				   submsginfo->MessageSize -
+				   sizeof(*submsginfo));
+
+			DumpGpadlBody(gpadl_body, submsginfo->MessageSize -
+				      sizeof(*submsginfo));
+			ret = VmbusPostMessage(gpadl_body,
+					       submsginfo->MessageSize -
+					       sizeof(*submsginfo));
 			if (ret != 0)
 				goto Cleanup;
 
 		}
 	}
-	osd_WaitEventWait(msgInfo->WaitEvent);
+	osd_WaitEventWait(msginfo->WaitEvent);
 
 	/* At this point, we received the gpadl created msg */
 	DPRINT_DBG(VMBUS, "Received GPADL created "
 		   "(relid %d, status %d handle %x)",
-		   Channel->OfferMsg.ChildRelId,
-		   msgInfo->Response.GpadlCreated.CreationStatus,
-		   gpadlMsg->Gpadl);
+		   channel->OfferMsg.ChildRelId,
+		   msginfo->Response.GpadlCreated.CreationStatus,
+		   gpadlmsg->Gpadl);
 
-	*GpadlHandle = gpadlMsg->Gpadl;
+	*gpadl_handle = gpadlmsg->Gpadl;
 
 Cleanup:
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_del(&msgInfo->MsgListEntry);
+	list_del(&msginfo->MsgListEntry);
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
 
-	kfree(msgInfo->WaitEvent);
-	kfree(msgInfo);
+	kfree(msginfo->WaitEvent);
+	kfree(msginfo);
 	return ret;
 }
 
 /*
  * VmbusChannelTeardownGpadl -Teardown the specified GPADL handle
  */
-int VmbusChannelTeardownGpadl(struct vmbus_channel *Channel, u32 GpadlHandle)
+int VmbusChannelTeardownGpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 {
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
@@ -608,8 +611,8 @@ int VmbusChannelTeardownGpadl(struct vmbus_channel *Channel, u32 GpadlHandle)
 	msg = (struct vmbus_channel_gpadl_teardown *)info->Msg;
 
 	msg->Header.MessageType = ChannelMessageGpadlTeardown;
-	msg->ChildRelId = Channel->OfferMsg.ChildRelId;
-	msg->Gpadl = GpadlHandle;
+	msg->ChildRelId = channel->OfferMsg.ChildRelId;
+	msg->Gpadl = gpadl_handle;
 
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
 	list_add_tail(&info->MsgListEntry,
@@ -638,7 +641,7 @@ int VmbusChannelTeardownGpadl(struct vmbus_channel *Channel, u32 GpadlHandle)
 /*
  * VmbusChannelClose - Close the specified channel
  */
-void VmbusChannelClose(struct vmbus_channel *Channel)
+void VmbusChannelClose(struct vmbus_channel *channel)
 {
 	struct vmbus_channel_close_channel *msg;
 	struct vmbus_channel_msginfo *info;
@@ -646,8 +649,8 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
 	int ret;
 
 	/* Stop callback and cancel the timer asap */
-	Channel->OnChannelCallback = NULL;
-	del_timer_sync(&Channel->poll_timer);
+	channel->OnChannelCallback = NULL;
+	del_timer_sync(&channel->poll_timer);
 
 	/* Send a closing message */
 	info = kmalloc(sizeof(*info) +
@@ -661,7 +664,7 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
 
 	msg = (struct vmbus_channel_close_channel *)info->Msg;
 	msg->Header.MessageType = ChannelMessageCloseChannel;
-	msg->ChildRelId = Channel->OfferMsg.ChildRelId;
+	msg->ChildRelId = channel->OfferMsg.ChildRelId;
 
 	ret = VmbusPostMessage(msg, sizeof(struct vmbus_channel_close_channel));
 	if (ret != 0) {
@@ -670,17 +673,17 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
 	}
 
 	/* Tear down the gpadl for the channel's ring buffer */
-	if (Channel->RingBufferGpadlHandle)
-		VmbusChannelTeardownGpadl(Channel,
-					  Channel->RingBufferGpadlHandle);
+	if (channel->RingBufferGpadlHandle)
+		VmbusChannelTeardownGpadl(channel,
+					  channel->RingBufferGpadlHandle);
 
 	/* TODO: Send a msg to release the childRelId */
 
 	/* Cleanup the ring buffers for this channel */
-	RingBufferCleanup(&Channel->Outbound);
-	RingBufferCleanup(&Channel->Inbound);
+	RingBufferCleanup(&channel->Outbound);
+	RingBufferCleanup(&channel->Inbound);
 
-	osd_PageFree(Channel->RingBufferPages, Channel->RingBufferPageCount);
+	osd_PageFree(channel->RingBufferPages, channel->RingBufferPageCount);
 
 	kfree(info);
 
@@ -690,12 +693,12 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
 	 * caller will free the channel
 	 */
 
-	if (Channel->State == CHANNEL_OPEN_STATE) {
+	if (channel->State == CHANNEL_OPEN_STATE) {
 		spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
-		list_del(&Channel->ListEntry);
+		list_del(&channel->ListEntry);
 		spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
 
-		FreeVmbusChannel(Channel);
+		FreeVmbusChannel(channel);
 	}
 }
 
@@ -713,42 +716,43 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
  *
  * Mainly used by Hyper-V drivers.
  */
-int VmbusChannelSendPacket(struct vmbus_channel *Channel, const void *Buffer,
-			   u32 BufferLen, u64 RequestId,
-			   enum vmbus_packet_type Type, u32 Flags)
+int VmbusChannelSendPacket(struct vmbus_channel *channel, const void *buffer,
+			   u32 bufferlen, u64 requestid,
+			   enum vmbus_packet_type type, u32 flags)
 {
 	struct vmpacket_descriptor desc;
-	u32 packetLen = sizeof(struct vmpacket_descriptor) + BufferLen;
-	u32 packetLenAligned = ALIGN_UP(packetLen, sizeof(u64));
-	struct scatterlist bufferList[3];
-	u64 alignedData = 0;
+	u32 packetlen = sizeof(struct vmpacket_descriptor) + bufferlen;
+	u32 packetlen_aligned = ALIGN_UP(packetlen, sizeof(u64));
+	struct scatterlist bufferlist[3];
+	u64 aligned_data = 0;
 	int ret;
 
 	DPRINT_DBG(VMBUS, "channel %p buffer %p len %d",
-		   Channel, Buffer, BufferLen);
+		   channel, buffer, bufferlen);
 
-	DumpVmbusChannel(Channel);
+	DumpVmbusChannel(channel);
 
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
 	/* Setup the descriptor */
-	desc.Type = Type; /* VmbusPacketTypeDataInBand; */
-	desc.Flags = Flags; /* VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED; */
+	desc.Type = type; /* VmbusPacketTypeDataInBand; */
+	desc.Flags = flags; /* VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED; */
 	/* in 8-bytes granularity */
 	desc.DataOffset8 = sizeof(struct vmpacket_descriptor) >> 3;
-	desc.Length8 = (u16)(packetLenAligned >> 3);
-	desc.TransactionId = RequestId;
+	desc.Length8 = (u16)(packetlen_aligned >> 3);
+	desc.TransactionId = requestid;
 
-	sg_init_table(bufferList, 3);
-	sg_set_buf(&bufferList[0], &desc, sizeof(struct vmpacket_descriptor));
-	sg_set_buf(&bufferList[1], Buffer, BufferLen);
-	sg_set_buf(&bufferList[2], &alignedData, packetLenAligned - packetLen);
+	sg_init_table(bufferlist, 3);
+	sg_set_buf(&bufferlist[0], &desc, sizeof(struct vmpacket_descriptor));
+	sg_set_buf(&bufferlist[1], buffer, bufferlen);
+	sg_set_buf(&bufferlist[2], &aligned_data,
+		   packetlen_aligned - packetlen);
 
-	ret = RingBufferWrite(&Channel->Outbound, bufferList, 3);
+	ret = RingBufferWrite(&channel->Outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&Channel->Outbound))
-		VmbusChannelSetEvent(Channel);
+	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
+		VmbusChannelSetEvent(channel);
 
 	return ret;
 }
@@ -758,61 +762,62 @@ EXPORT_SYMBOL(VmbusChannelSendPacket);
  * VmbusChannelSendPacketPageBuffer - Send a range of single-page buffer
  * packets using a GPADL Direct packet type.
  */
-int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
-				     struct hv_page_buffer PageBuffers[],
-				     u32 PageCount, void *Buffer, u32 BufferLen,
-				     u64 RequestId)
+int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *channel,
+				     struct hv_page_buffer pagebuffers[],
+				     u32 pagecount, void *buffer, u32 bufferlen,
+				     u64 requestid)
 {
 	int ret;
 	int i;
 	struct vmbus_channel_packet_page_buffer desc;
-	u32 descSize;
-	u32 packetLen;
-	u32 packetLenAligned;
-	struct scatterlist bufferList[3];
-	u64 alignedData = 0;
+	u32 descsize;
+	u32 packetlen;
+	u32 packetlen_aligned;
+	struct scatterlist bufferlist[3];
+	u64 aligned_data = 0;
 
-	if (PageCount > MAX_PAGE_BUFFER_COUNT)
+	if (pagecount > MAX_PAGE_BUFFER_COUNT)
 		return -EINVAL;
 
-	DumpVmbusChannel(Channel);
+	DumpVmbusChannel(channel);
 
 	/*
 	 * Adjust the size down since vmbus_channel_packet_page_buffer is the
 	 * largest size we support
 	 */
-	descSize = sizeof(struct vmbus_channel_packet_page_buffer) -
-			  ((MAX_PAGE_BUFFER_COUNT - PageCount) *
+	descsize = sizeof(struct vmbus_channel_packet_page_buffer) -
+			  ((MAX_PAGE_BUFFER_COUNT - pagecount) *
 			  sizeof(struct hv_page_buffer));
-	packetLen = descSize + BufferLen;
-	packetLenAligned = ALIGN_UP(packetLen, sizeof(u64));
+	packetlen = descsize + bufferlen;
+	packetlen_aligned = ALIGN_UP(packetlen, sizeof(u64));
 
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
 	/* Setup the descriptor */
 	desc.type = VmbusPacketTypeDataUsingGpaDirect;
 	desc.flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
-	desc.dataoffset8 = descSize >> 3; /* in 8-bytes grandularity */
-	desc.length8 = (u16)(packetLenAligned >> 3);
-	desc.transactionid = RequestId;
-	desc.rangecount = PageCount;
-
-	for (i = 0; i < PageCount; i++) {
-		desc.range[i].Length = PageBuffers[i].Length;
-		desc.range[i].Offset = PageBuffers[i].Offset;
-		desc.range[i].Pfn	 = PageBuffers[i].Pfn;
+	desc.dataoffset8 = descsize >> 3; /* in 8-bytes grandularity */
+	desc.length8 = (u16)(packetlen_aligned >> 3);
+	desc.transactionid = requestid;
+	desc.rangecount = pagecount;
+
+	for (i = 0; i < pagecount; i++) {
+		desc.range[i].Length = pagebuffers[i].Length;
+		desc.range[i].Offset = pagebuffers[i].Offset;
+		desc.range[i].Pfn	 = pagebuffers[i].Pfn;
 	}
 
-	sg_init_table(bufferList, 3);
-	sg_set_buf(&bufferList[0], &desc, descSize);
-	sg_set_buf(&bufferList[1], Buffer, BufferLen);
-	sg_set_buf(&bufferList[2], &alignedData, packetLenAligned - packetLen);
+	sg_init_table(bufferlist, 3);
+	sg_set_buf(&bufferlist[0], &desc, descsize);
+	sg_set_buf(&bufferlist[1], buffer, bufferlen);
+	sg_set_buf(&bufferlist[2], &aligned_data,
+		packetlen_aligned - packetlen);
 
-	ret = RingBufferWrite(&Channel->Outbound, bufferList, 3);
+	ret = RingBufferWrite(&channel->Outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&Channel->Outbound))
-		VmbusChannelSetEvent(Channel);
+	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
+		VmbusChannelSetEvent(channel);
 
 	return ret;
 }
@@ -821,64 +826,66 @@ int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
  * VmbusChannelSendPacketMultiPageBuffer - Send a multi-page buffer packet
  * using a GPADL Direct packet type.
  */
-int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
-				struct hv_multipage_buffer *MultiPageBuffer,
-				void *Buffer, u32 BufferLen, u64 RequestId)
+int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *channel,
+				struct hv_multipage_buffer *multi_pagebuffer,
+				void *buffer, u32 bufferlen, u64 requestid)
 {
 	int ret;
 	struct vmbus_channel_packet_multipage_buffer desc;
-	u32 descSize;
-	u32 packetLen;
-	u32 packetLenAligned;
-	struct scatterlist bufferList[3];
-	u64 alignedData = 0;
-	u32 PfnCount = NUM_PAGES_SPANNED(MultiPageBuffer->Offset,
-					 MultiPageBuffer->Length);
+	u32 descsize;
+	u32 packetlen;
+	u32 packetlen_aligned;
+	struct scatterlist bufferlist[3];
+	u64 aligned_data = 0;
+	u32 pfncount = NUM_PAGES_SPANNED(multi_pagebuffer->Offset,
+					 multi_pagebuffer->Length);
 
-	DumpVmbusChannel(Channel);
+	DumpVmbusChannel(channel);
 
 	DPRINT_DBG(VMBUS, "data buffer - offset %u len %u pfn count %u",
-		   MultiPageBuffer->Offset, MultiPageBuffer->Length, PfnCount);
+		multi_pagebuffer->Offset,
+		multi_pagebuffer->Length, pfncount);
 
-	if ((PfnCount < 0) || (PfnCount > MAX_MULTIPAGE_BUFFER_COUNT))
+	if ((pfncount < 0) || (pfncount > MAX_MULTIPAGE_BUFFER_COUNT))
 		return -EINVAL;
 
 	/*
 	 * Adjust the size down since vmbus_channel_packet_multipage_buffer is
 	 * the largest size we support
 	 */
-	descSize = sizeof(struct vmbus_channel_packet_multipage_buffer) -
-			  ((MAX_MULTIPAGE_BUFFER_COUNT - PfnCount) *
+	descsize = sizeof(struct vmbus_channel_packet_multipage_buffer) -
+			  ((MAX_MULTIPAGE_BUFFER_COUNT - pfncount) *
 			  sizeof(u64));
-	packetLen = descSize + BufferLen;
-	packetLenAligned = ALIGN_UP(packetLen, sizeof(u64));
+	packetlen = descsize + bufferlen;
+	packetlen_aligned = ALIGN_UP(packetlen, sizeof(u64));
 
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
 	/* Setup the descriptor */
 	desc.type = VmbusPacketTypeDataUsingGpaDirect;
 	desc.flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
-	desc.dataoffset8 = descSize >> 3; /* in 8-bytes grandularity */
-	desc.length8 = (u16)(packetLenAligned >> 3);
-	desc.transactionid = RequestId;
+	desc.dataoffset8 = descsize >> 3; /* in 8-bytes grandularity */
+	desc.length8 = (u16)(packetlen_aligned >> 3);
+	desc.transactionid = requestid;
 	desc.rangecount = 1;
 
-	desc.range.Length = MultiPageBuffer->Length;
-	desc.range.Offset = MultiPageBuffer->Offset;
+	desc.range.Length = multi_pagebuffer->Length;
+	desc.range.Offset = multi_pagebuffer->Offset;
 
-	memcpy(desc.range.PfnArray, MultiPageBuffer->PfnArray,
-	       PfnCount * sizeof(u64));
+	memcpy(desc.range.PfnArray, multi_pagebuffer->PfnArray,
+	       pfncount * sizeof(u64));
 
-	sg_init_table(bufferList, 3);
-	sg_set_buf(&bufferList[0], &desc, descSize);
-	sg_set_buf(&bufferList[1], Buffer, BufferLen);
-	sg_set_buf(&bufferList[2], &alignedData, packetLenAligned - packetLen);
+	sg_init_table(bufferlist, 3);
+	sg_set_buf(&bufferlist[0], &desc, descsize);
+	sg_set_buf(&bufferlist[1], buffer, bufferlen);
+	sg_set_buf(&bufferlist[2], &aligned_data,
+		packetlen_aligned - packetlen);
 
-	ret = RingBufferWrite(&Channel->Outbound, bufferList, 3);
+	ret = RingBufferWrite(&channel->Outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&Channel->Outbound))
-		VmbusChannelSetEvent(Channel);
+	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
+		VmbusChannelSetEvent(channel);
 
 	return ret;
 }
@@ -897,24 +904,24 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
  *
  * Mainly used by Hyper-V drivers.
  */
-int VmbusChannelRecvPacket(struct vmbus_channel *Channel, void *Buffer,
-			   u32 BufferLen, u32 *BufferActualLen, u64 *RequestId)
+int VmbusChannelRecvPacket(struct vmbus_channel *channel, void *buffer,
+			u32 bufferlen, u32 *buffer_actual_len, u64 *requestid)
 {
 	struct vmpacket_descriptor desc;
-	u32 packetLen;
-	u32 userLen;
+	u32 packetlen;
+	u32 userlen;
 	int ret;
 	unsigned long flags;
 
-	*BufferActualLen = 0;
-	*RequestId = 0;
+	*buffer_actual_len = 0;
+	*requestid = 0;
 
-	spin_lock_irqsave(&Channel->inbound_lock, flags);
+	spin_lock_irqsave(&channel->inbound_lock, flags);
 
-	ret = RingBufferPeek(&Channel->Inbound, &desc,
+	ret = RingBufferPeek(&channel->Inbound, &desc,
 			     sizeof(struct vmpacket_descriptor));
 	if (ret != 0) {
-		spin_unlock_irqrestore(&Channel->inbound_lock, flags);
+		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
 		/* DPRINT_DBG(VMBUS, "nothing to read!!"); */
 		return 0;
@@ -922,32 +929,32 @@ int VmbusChannelRecvPacket(struct vmbus_channel *Channel, void *Buffer,
 
 	/* VmbusChannelClearEvent(Channel); */
 
-	packetLen = desc.Length8 << 3;
-	userLen = packetLen - (desc.DataOffset8 << 3);
+	packetlen = desc.Length8 << 3;
+	userlen = packetlen - (desc.DataOffset8 << 3);
 	/* ASSERT(userLen > 0); */
 
 	DPRINT_DBG(VMBUS, "packet received on channel %p relid %d <type %d "
 		   "flag %d tid %llx pktlen %d datalen %d> ",
-		   Channel, Channel->OfferMsg.ChildRelId, desc.Type,
-		   desc.Flags, desc.TransactionId, packetLen, userLen);
+		   channel, channel->OfferMsg.ChildRelId, desc.Type,
+		   desc.Flags, desc.TransactionId, packetlen, userlen);
 
-	*BufferActualLen = userLen;
+	*buffer_actual_len = userlen;
 
-	if (userLen > BufferLen) {
-		spin_unlock_irqrestore(&Channel->inbound_lock, flags);
+	if (userlen > bufferlen) {
+		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
 		DPRINT_ERR(VMBUS, "buffer too small - got %d needs %d",
-			   BufferLen, userLen);
+			   bufferlen, userlen);
 		return -1;
 	}
 
-	*RequestId = desc.TransactionId;
+	*requestid = desc.TransactionId;
 
 	/* Copy over the packet to the user buffer */
-	ret = RingBufferRead(&Channel->Inbound, Buffer, userLen,
+	ret = RingBufferRead(&channel->Inbound, buffer, userlen,
 			     (desc.DataOffset8 << 3));
 
-	spin_unlock_irqrestore(&Channel->inbound_lock, flags);
+	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
 	return 0;
 }
@@ -956,25 +963,25 @@ EXPORT_SYMBOL(VmbusChannelRecvPacket);
 /*
  * VmbusChannelRecvPacketRaw - Retrieve the raw packet on the specified channel
  */
-int VmbusChannelRecvPacketRaw(struct vmbus_channel *Channel, void *Buffer,
-			      u32 BufferLen, u32 *BufferActualLen,
-			      u64 *RequestId)
+int VmbusChannelRecvPacketRaw(struct vmbus_channel *channel, void *buffer,
+			      u32 bufferlen, u32 *buffer_actual_len,
+			      u64 *requestid)
 {
 	struct vmpacket_descriptor desc;
-	u32 packetLen;
-	u32 userLen;
+	u32 packetlen;
+	u32 userlen;
 	int ret;
 	unsigned long flags;
 
-	*BufferActualLen = 0;
-	*RequestId = 0;
+	*buffer_actual_len = 0;
+	*requestid = 0;
 
-	spin_lock_irqsave(&Channel->inbound_lock, flags);
+	spin_lock_irqsave(&channel->inbound_lock, flags);
 
-	ret = RingBufferPeek(&Channel->Inbound, &desc,
+	ret = RingBufferPeek(&channel->Inbound, &desc,
 			     sizeof(struct vmpacket_descriptor));
 	if (ret != 0) {
-		spin_unlock_irqrestore(&Channel->inbound_lock, flags);
+		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
 		/* DPRINT_DBG(VMBUS, "nothing to read!!"); */
 		return 0;
@@ -982,44 +989,44 @@ int VmbusChannelRecvPacketRaw(struct vmbus_channel *Channel, void *Buffer,
 
 	/* VmbusChannelClearEvent(Channel); */
 
-	packetLen = desc.Length8 << 3;
-	userLen = packetLen - (desc.DataOffset8 << 3);
+	packetlen = desc.Length8 << 3;
+	userlen = packetlen - (desc.DataOffset8 << 3);
 
 	DPRINT_DBG(VMBUS, "packet received on channel %p relid %d <type %d "
 		   "flag %d tid %llx pktlen %d datalen %d> ",
-		   Channel, Channel->OfferMsg.ChildRelId, desc.Type,
-		   desc.Flags, desc.TransactionId, packetLen, userLen);
+		   channel, channel->OfferMsg.ChildRelId, desc.Type,
+		   desc.Flags, desc.TransactionId, packetlen, userlen);
 
-	*BufferActualLen = packetLen;
+	*buffer_actual_len = packetlen;
 
-	if (packetLen > BufferLen) {
-		spin_unlock_irqrestore(&Channel->inbound_lock, flags);
+	if (packetlen > bufferlen) {
+		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
 		DPRINT_ERR(VMBUS, "buffer too small - needed %d bytes but "
-			   "got space for only %d bytes", packetLen, BufferLen);
+			   "got space for only %d bytes", packetlen, bufferlen);
 		return -2;
 	}
 
-	*RequestId = desc.TransactionId;
+	*requestid = desc.TransactionId;
 
 	/* Copy over the entire packet to the user buffer */
-	ret = RingBufferRead(&Channel->Inbound, Buffer, packetLen, 0);
+	ret = RingBufferRead(&channel->Inbound, buffer, packetlen, 0);
 
-	spin_unlock_irqrestore(&Channel->inbound_lock, flags);
+	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 	return 0;
 }
 
 /*
  * VmbusChannelOnChannelEvent - Channel event callback
  */
-void VmbusChannelOnChannelEvent(struct vmbus_channel *Channel)
+void VmbusChannelOnChannelEvent(struct vmbus_channel *channel)
 {
-	DumpVmbusChannel(Channel);
+	DumpVmbusChannel(channel);
 	/* ASSERT(Channel->OnChannelCallback); */
 
-	Channel->OnChannelCallback(Channel->ChannelCallbackContext);
+	channel->OnChannelCallback(channel->ChannelCallbackContext);
 
-	mod_timer(&Channel->poll_timer, jiffies + usecs_to_jiffies(100));
+	mod_timer(&channel->poll_timer, jiffies + usecs_to_jiffies(100));
 }
 
 /*
@@ -1036,9 +1043,9 @@ void VmbusChannelOnTimer(unsigned long data)
 /*
  * DumpVmbusChannel - Dump vmbus channel info to the console
  */
-static void DumpVmbusChannel(struct vmbus_channel *Channel)
+static void DumpVmbusChannel(struct vmbus_channel *channel)
 {
-	DPRINT_DBG(VMBUS, "Channel (%d)", Channel->OfferMsg.ChildRelId);
-	DumpRingInfo(&Channel->Outbound, "Outbound ");
-	DumpRingInfo(&Channel->Inbound, "Inbound ");
+	DPRINT_DBG(VMBUS, "Channel (%d)", channel->OfferMsg.ChildRelId);
+	DumpRingInfo(&channel->Outbound, "Outbound ");
+	DumpRingInfo(&channel->Inbound, "Inbound ");
 }
-- 
1.6.3.2

