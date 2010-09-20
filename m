Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab0ITVNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:13:44 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:7600 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab0ITVNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:13:42 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 2/2] staging: hv: Remove camel cases from vmbus channel
 functions
Thread-Topic: [PATCH 2/2] staging: hv: Remove camel cases from vmbus channel
 functions
Thread-Index: AQHLWQixMaGUjEdPd06Cf8+WB9z/TA==
Date: Mon, 20 Sep 2010 21:13:39 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7289E499E4@TK5EX14MBXC121.redmond.corp.microsoft.com>
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

Remove camel cases from vmbus channel functions
Converted the function names, local variables to lower cases.
More patches will be submitted soon to remove the remaining camel cases.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c           |  793 +++++++++++++++-----------------
 drivers/staging/hv/channel.h           |   94 ++--
 drivers/staging/hv/channel_interface.c |   20 +-
 drivers/staging/hv/channel_mgmt.c      |    8 +-
 drivers/staging/hv/connection.c        |    4 +-
 drivers/staging/hv/hv_utils.c          |   12 +-
 6 files changed, 441 insertions(+), 490 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 37b7b4c..af0e86a 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -27,50 +27,20 @@
 #include "vmbus_private.h"
 
 /* Internal routines */
-static int VmbusChannelCreateGpadlHeader(
-	void *Kbuffer,	/* must be phys and virt contiguous */
-	u32 Size,	/* page-size multiple */
-	struct vmbus_channel_msginfo **msgInfo,
-	u32 *MessageCount);
-static void DumpVmbusChannel(struct vmbus_channel *channel);
-static void VmbusChannelSetEvent(struct vmbus_channel *channel);
+static int vmbuschannel_creategpadlheader(
+	void *kbuffer,	/* must be phys and virt contiguous */
+	u32 size,	/* page-size multiple */
+	struct vmbus_channel_msginfo **msginfo,
+	u32 *messagecount);
+static void dumpvmbuschannel(struct vmbus_channel *channel);
+static void vmbuschannel_setevent(struct vmbus_channel *channel);
 
 
-#if 0
-static void DumpMonitorPage(struct hv_monitor_page *MonitorPage)
-{
-	int i = 0;
-	int j = 0;
-
-	DPRINT_DBG(VMBUS, "monitorPage - %p, trigger state - %d",
-		   MonitorPage, MonitorPage->TriggerState);
-
-	for (i = 0; i < 4; i++)
-		DPRINT_DBG(VMBUS, "trigger group (%d) - %llx", i,
-			   MonitorPage->TriggerGroup[i].AsUINT64);
-
-	for (i = 0; i < 4; i++) {
-		for (j = 0; j < 32; j++) {
-			DPRINT_DBG(VMBUS, "latency (%d)(%d) - %llx", i, j,
-				   MonitorPage->Latency[i][j]);
-		}
-	}
-	for (i = 0; i < 4; i++) {
-		for (j = 0; j < 32; j++) {
-			DPRINT_DBG(VMBUS, "param-conn id (%d)(%d) - %d", i, j,
-			       MonitorPage->Parameter[i][j].ConnectionId.Asu32);
-			DPRINT_DBG(VMBUS, "param-flag (%d)(%d) - %d", i, j,
-				MonitorPage->Parameter[i][j].FlagNumber);
-		}
-	}
-}
-#endif
-
 /*
  * VmbusChannelSetEvent - Trigger an event notification on the specified
  * channel.
  */
-static void VmbusChannelSetEvent(struct vmbus_channel *Channel)
+static void vmbuschannel_setevent(struct vmbus_channel *Channel)
 {
 	struct hv_monitor_page *monitorPage;
 
@@ -92,82 +62,60 @@ static void VmbusChannelSetEvent(struct vmbus_channel *Channel)
 	}
 }
 
-#if 0
-static void VmbusChannelClearEvent(struct vmbus_channel *channel)
-{
-	struct hv_monitor_page *monitorPage;
-
-	if (Channel->OfferMsg.MonitorAllocated) {
-		/* Each u32 represents 32 channels */
-		clear_bit(Channel->OfferMsg.ChildRelId & 31,
-			  (unsigned long *)gVmbusConnection.SendInterruptPage +
-			  (Channel->OfferMsg.ChildRelId >> 5));
-
-		monitorPage =
-			(struct hv_monitor_page *)gVmbusConnection.MonitorPages;
-		monitorPage++; /* Get the child to parent monitor page */
-
-		clear_bit(Channel->MonitorBit,
-			  (unsigned long *)&monitorPage->TriggerGroup
-					[Channel->MonitorGroup].Pending);
-	}
-}
-
-#endif
 /*
- * VmbusChannelGetDebugInfo -Retrieve various channel debug info
+ * vmbuschannel_getdebuginfo -Retrieve various channel debug info
  */
-void VmbusChannelGetDebugInfo(struct vmbus_channel *Channel,
-			      struct vmbus_channel_debug_info *DebugInfo)
+void vmbuschannel_getdebuginfo(struct vmbus_channel *channel,
+			      struct vmbus_channel_debug_info *debuginfo)
 {
 	struct hv_monitor_page *monitorPage;
-	u8 monitorGroup = (u8)Channel->OfferMsg.MonitorId / 32;
-	u8 monitorOffset = (u8)Channel->OfferMsg.MonitorId % 32;
+	u8 monitorGroup = (u8)channel->OfferMsg.MonitorId / 32;
+	u8 monitorOffset = (u8)channel->OfferMsg.MonitorId % 32;
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
 
 	monitorPage = (struct hv_monitor_page *)gVmbusConnection.MonitorPages;
 
-	DebugInfo->MonitorId = Channel->OfferMsg.MonitorId;
+	debuginfo->MonitorId = channel->OfferMsg.MonitorId;
 
-	DebugInfo->ServerMonitorPending =
+	debuginfo->ServerMonitorPending =
 			monitorPage->TriggerGroup[monitorGroup].Pending;
-	DebugInfo->ServerMonitorLatency =
+	debuginfo->ServerMonitorLatency =
 			monitorPage->Latency[monitorGroup][monitorOffset];
-	DebugInfo->ServerMonitorConnectionId =
+	debuginfo->ServerMonitorConnectionId =
 			monitorPage->Parameter[monitorGroup]
 					      [monitorOffset].ConnectionId.u.Id;
 
 	monitorPage++;
 
-	DebugInfo->ClientMonitorPending =
+	debuginfo->ClientMonitorPending =
 			monitorPage->TriggerGroup[monitorGroup].Pending;
-	DebugInfo->ClientMonitorLatency =
+	debuginfo->ClientMonitorLatency =
 			monitorPage->Latency[monitorGroup][monitorOffset];
-	DebugInfo->ClientMonitorConnectionId =
+	debuginfo->ClientMonitorConnectionId =
 			monitorPage->Parameter[monitorGroup]
 					      [monitorOffset].ConnectionId.u.Id;
 
-	RingBufferGetDebugInfo(&Channel->Inbound, &DebugInfo->Inbound);
-	RingBufferGetDebugInfo(&Channel->Outbound, &DebugInfo->Outbound);
+	RingBufferGetDebugInfo(&channel->Inbound, &debuginfo->Inbound);
+	RingBufferGetDebugInfo(&channel->Outbound, &debuginfo->Outbound);
 }
 
 /*
- * VmbusChannelOpen - Open the specified channel.
+ * vmbuschannel_open - Open the specified channel.
  */
-int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
-		     u32 RecvRingBufferSize, void *UserData, u32 UserDataLen,
-		     void (*OnChannelCallback)(void *context), void *Context)
+int vmbuschannel_open(struct vmbus_channel *newchannel, u32 sendringbuffersize,
+		     u32 recvringbuffersize, void *userdata, u32 userdatalen,
+		     void (*onchannelcallback)(void *context), void *context)
 {
-	struct vmbus_channel_open_channel *openMsg;
-	struct vmbus_channel_msginfo *openInfo = NULL;
+	struct vmbus_channel_open_channel *openmsg;
+	struct vmbus_channel_msginfo *openinfo = NULL;
 	void *in, *out;
 	unsigned long flags;
 	int ret, err = 0;
@@ -176,30 +124,30 @@ int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
 	/* ASSERT(!(SendRingBufferSize & (PAGE_SIZE - 1))); */
 	/* ASSERT(!(RecvRingBufferSize & (PAGE_SIZE - 1))); */
 
-	NewChannel->OnChannelCallback = OnChannelCallback;
-	NewChannel->ChannelCallbackContext = Context;
+	newchannel->OnChannelCallback = onchannelcallback;
+	newchannel->ChannelCallbackContext = context;
 
 	/* Allocate the ring buffer */
-	out = osd_PageAlloc((SendRingBufferSize + RecvRingBufferSize)
+	out = osd_PageAlloc((sendringbuffersize + recvringbuffersize)
 			     >> PAGE_SHIFT);
 	if (!out)
 		return -ENOMEM;
 
 	/* ASSERT(((unsigned long)out & (PAGE_SIZE-1)) == 0); */
 
-	in = (void *)((unsigned long)out + SendRingBufferSize);
+	in = (void *)((unsigned long)out + sendringbuffersize);
 
-	NewChannel->RingBufferPages = out;
-	NewChannel->RingBufferPageCount = (SendRingBufferSize +
-					   RecvRingBufferSize) >> PAGE_SHIFT;
+	newchannel->RingBufferPages = out;
+	newchannel->RingBufferPageCount = (sendringbuffersize +
+					   recvringbuffersize) >> PAGE_SHIFT;
 
-	ret = RingBufferInit(&NewChannel->Outbound, out, SendRingBufferSize);
+	ret = RingBufferInit(&newchannel->Outbound, out, sendringbuffersize);
 	if (ret != 0) {
 		err = ret;
 		goto errorout;
 	}
 
-	ret = RingBufferInit(&NewChannel->Inbound, in, RecvRingBufferSize);
+	ret = RingBufferInit(&newchannel->Inbound, in, recvringbuffersize);
 	if (ret != 0) {
 		err = ret;
 		goto errorout;
@@ -208,15 +156,15 @@ int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
 
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
+	ret = vmbuschannel_establishgpadl(newchannel,
+					 newchannel->Outbound.RingBuffer,
+					 sendringbuffersize +
+					 recvringbuffersize,
+					 &newchannel->RingBufferGpadlHandle);
 
 	if (ret != 0) {
 		err = ret;
@@ -225,54 +173,54 @@ int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
 
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
+		   sendringbuffersize);
 
 	/* Create and init the channel open message */
-	openInfo = kmalloc(sizeof(*openInfo) +
+	openinfo = kmalloc(sizeof(*openinfo) +
 			   sizeof(struct vmbus_channel_open_channel),
 			   GFP_KERNEL);
-	if (!openInfo) {
+	if (!openinfo) {
 		err = -ENOMEM;
 		goto errorout;
 	}
 
-	openInfo->WaitEvent = osd_WaitEventCreate();
-	if (!openInfo->WaitEvent) {
+	openinfo->WaitEvent = osd_WaitEventCreate();
+	if (!openinfo->WaitEvent) {
 		err = -ENOMEM;
 		goto errorout;
 	}
 
-	openMsg = (struct vmbus_channel_open_channel *)openInfo->Msg;
-	openMsg->Header.MessageType = ChannelMessageOpenChannel;
-	openMsg->OpenId = NewChannel->OfferMsg.ChildRelId; /* FIXME */
-	openMsg->ChildRelId = NewChannel->OfferMsg.ChildRelId;
-	openMsg->RingBufferGpadlHandle = NewChannel->RingBufferGpadlHandle;
-	openMsg->DownstreamRingBufferPageOffset = SendRingBufferSize >>
+	openmsg = (struct vmbus_channel_open_channel *)openinfo->Msg;
+	openmsg->Header.MessageType = ChannelMessageOpenChannel;
+	openmsg->OpenId = newchannel->OfferMsg.ChildRelId; /* FIXME */
+	openmsg->ChildRelId = newchannel->OfferMsg.ChildRelId;
+	openmsg->RingBufferGpadlHandle = newchannel->RingBufferGpadlHandle;
+	openmsg->DownstreamRingBufferPageOffset = sendringbuffersize >>
 						  PAGE_SHIFT;
-	openMsg->ServerContextAreaGpadlHandle = 0; /* TODO */
+	openmsg->ServerContextAreaGpadlHandle = 0; /* TODO */
 
-	if (UserDataLen > MAX_USER_DEFINED_BYTES) {
+	if (userdatalen > MAX_USER_DEFINED_BYTES) {
 		err = -EINVAL;
 		goto errorout;
 	}
 
-	if (UserDataLen)
-		memcpy(openMsg->UserData, UserData, UserDataLen);
+	if (userdatalen)
+		memcpy(openmsg->UserData, userdata, userdatalen);
 
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_add_tail(&openInfo->MsgListEntry,
+	list_add_tail(&openinfo->MsgListEntry,
 		      &gVmbusConnection.ChannelMsgList);
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
 
 	DPRINT_DBG(VMBUS, "Sending channel open msg...");
 
-	ret = VmbusPostMessage(openMsg,
+	ret = VmbusPostMessage(openmsg,
 			       sizeof(struct vmbus_channel_open_channel));
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS, "unable to open channel - %d", ret);
@@ -280,29 +228,29 @@ int VmbusChannelOpen(struct vmbus_channel *NewChannel, u32 SendRingBufferSize,
 	}
 
 	/* FIXME: Need to time-out here */
-	osd_WaitEventWait(openInfo->WaitEvent);
+	osd_WaitEventWait(openinfo->WaitEvent);
 
-	if (openInfo->Response.OpenResult.Status == 0)
-		DPRINT_INFO(VMBUS, "channel <%p> open success!!", NewChannel);
+	if (openinfo->Response.OpenResult.Status == 0)
+		DPRINT_INFO(VMBUS, "channel <%p> open success!!", newchannel);
 	else
 		DPRINT_INFO(VMBUS, "channel <%p> open failed - %d!!",
-			    NewChannel, openInfo->Response.OpenResult.Status);
+			    newchannel, openinfo->Response.OpenResult.Status);
 
 Cleanup:
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_del(&openInfo->MsgListEntry);
+	list_del(&openinfo->MsgListEntry);
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
 
-	kfree(openInfo->WaitEvent);
-	kfree(openInfo);
+	kfree(openinfo->WaitEvent);
+	kfree(openinfo);
 	return 0;
 
 errorout:
-	RingBufferCleanup(&NewChannel->Outbound);
-	RingBufferCleanup(&NewChannel->Inbound);
-	osd_PageFree(out, (SendRingBufferSize + RecvRingBufferSize)
+	RingBufferCleanup(&newchannel->Outbound);
+	RingBufferCleanup(&newchannel->Inbound);
+	osd_PageFree(out, (sendringbuffersize + recvringbuffersize)
 		     >> PAGE_SHIFT);
-	kfree(openInfo);
+	kfree(openinfo);
 	return err;
 }
 
@@ -328,108 +276,109 @@ static void DumpGpadlBody(struct vmbus_channel_gpadl_body *Gpadl, u32 Len)
  * DumpGpadlHeader - Dump the gpadl header message to the console for
  * debugging purposes.
  */
-static void DumpGpadlHeader(struct vmbus_channel_gpadl_header *Gpadl)
+static void dumpgpadlheader(struct vmbus_channel_gpadl_header *gpadl)
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
+static int vmbuschannel_creategpadlheader(void *kbuffer, u32 size,
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
+	struct vmbus_channel_gpadl_header *gpalheader;
+	struct vmbus_channel_gpadl_body *gpadlbody;
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
+		gpalheader =
+			(struct vmbus_channel_gpadl_header *)msgheader->Msg;
+		gpalheader->RangeCount = 1;
+		gpalheader->RangeBufLen = sizeof(struct gpa_range) +
+					 pagecount * sizeof(u64);
+		gpalheader->Range[0].ByteOffset = 0;
+		gpalheader->Range[0].ByteCount = size;
+		for (i = 0; i < pfncount; i++)
+			gpalheader->Range[0].PfnArray[i] = pfn+i;
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
+			gpadlbody =
+				(struct vmbus_channel_gpadl_body *)msgbody->Msg;
 
 			/*
 			 * FIXME:
@@ -437,155 +386,157 @@ static int VmbusChannelCreateGpadlHeader(void *Kbuffer, u32 Size,
 			 * be 64-bit
 			 */
 			/* gpadlBody->Gpadl = kbuffer; */
-			for (i = 0; i < pfnCurr; i++)
-				gpadlBody->Pfn[i] = pfn + pfnSum + i;
+			for (i = 0; i < pfncurr; i++)
+				gpadlbody->Pfn[i] = pfn + pfnsum + i;
 
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
+		gpalheader =
+			(struct vmbus_channel_gpadl_header *)msgheader->Msg;
+		gpalheader->RangeCount = 1;
+		gpalheader->RangeBufLen = sizeof(struct gpa_range) +
+					 pagecount * sizeof(u64);
+		gpalheader->Range[0].ByteOffset = 0;
+		gpalheader->Range[0].ByteCount = size;
+		for (i = 0; i < pagecount; i++)
+			gpalheader->Range[0].PfnArray[i] = pfn+i;
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
 
 /*
- * VmbusChannelEstablishGpadl - Estabish a GPADL for the specified buffer
+ * vmbuschannel_establishgpadl - Estabish a GPADL for the specified buffer
  *
- * @Channel: a channel
- * @Kbuffer: from kmalloc
- * @Size: page-size multiple
- * @GpadlHandle: some funky thing
+ * @channel: a channel
+ * @kbuffer: from kmalloc
+ * @size: page-size multiple
+ * @gpadlhandle: some funky thing
  */
-int VmbusChannelEstablishGpadl(struct vmbus_channel *Channel, void *Kbuffer,
-			       u32 Size, u32 *GpadlHandle)
+int vmbuschannel_establishgpadl(struct vmbus_channel *channel, void *kbuffer,
+			       u32 size, u32 *gpadlhandle)
 {
-	struct vmbus_channel_gpadl_header *gpadlMsg;
-	struct vmbus_channel_gpadl_body *gpadlBody;
+	struct vmbus_channel_gpadl_header *gpadlmsg;
+	struct vmbus_channel_gpadl_body *gpadlbody;
 	/* struct vmbus_channel_gpadl_created *gpadlCreated; */
-	struct vmbus_channel_msginfo *msgInfo = NULL;
-	struct vmbus_channel_msginfo *subMsgInfo;
-	u32 msgCount;
+	struct vmbus_channel_msginfo *msginfo = NULL;
+	struct vmbus_channel_msginfo *submsginfo;
+	u32 msgcount;
 	struct list_head *curr;
-	u32 nextGpadlHandle;
+	u32 nextgpadlhandle;
 	unsigned long flags;
 	int ret = 0;
 
-	nextGpadlHandle = atomic_read(&gVmbusConnection.NextGpadlHandle);
+	nextgpadlhandle = atomic_read(&gVmbusConnection.NextGpadlHandle);
 	atomic_inc(&gVmbusConnection.NextGpadlHandle);
 
-	ret = VmbusChannelCreateGpadlHeader(Kbuffer, Size, &msgInfo, &msgCount);
+	ret = vmbuschannel_creategpadlheader(kbuffer, size,
+			&msginfo, &msgcount);
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
+	gpadlmsg->Gpadl = nextgpadlhandle;
 
-	DumpGpadlHeader(gpadlMsg);
+	dumpgpadlheader(gpadlmsg);
 
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
+			gpadlbody =
+			     (struct vmbus_channel_gpadl_body *)submsginfo->Msg;
 
-			gpadlBody->Header.MessageType = ChannelMessageGpadlBody;
-			gpadlBody->Gpadl = nextGpadlHandle;
+			gpadlbody->Header.MessageType = ChannelMessageGpadlBody;
+			gpadlbody->Gpadl = nextgpadlhandle;
 
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
+			DumpGpadlBody(gpadlbody, submsginfo->MessageSize -
+				      sizeof(*submsginfo));
+			ret = VmbusPostMessage(gpadlbody,
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
+	*gpadlhandle = gpadlmsg->Gpadl;
 
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
- * VmbusChannelTeardownGpadl -Teardown the specified GPADL handle
+ * vmbuschannel_teardowngpadl -Teardown the specified GPADL handle
  */
-int VmbusChannelTeardownGpadl(struct vmbus_channel *Channel, u32 GpadlHandle)
+int vmbuschannel_teardowngpadl(struct vmbus_channel *channel, u32 gpadlhandle)
 {
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
@@ -608,8 +559,8 @@ int VmbusChannelTeardownGpadl(struct vmbus_channel *Channel, u32 GpadlHandle)
 	msg = (struct vmbus_channel_gpadl_teardown *)info->Msg;
 
 	msg->Header.MessageType = ChannelMessageGpadlTeardown;
-	msg->ChildRelId = Channel->OfferMsg.ChildRelId;
-	msg->Gpadl = GpadlHandle;
+	msg->ChildRelId = channel->OfferMsg.ChildRelId;
+	msg->Gpadl = gpadlhandle;
 
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
 	list_add_tail(&info->MsgListEntry,
@@ -636,9 +587,9 @@ int VmbusChannelTeardownGpadl(struct vmbus_channel *Channel, u32 GpadlHandle)
 }
 
 /*
- * VmbusChannelClose - Close the specified channel
+ * vmbuschannel_close - Close the specified channel
  */
-void VmbusChannelClose(struct vmbus_channel *Channel)
+void vmbuschannel_close(struct vmbus_channel *channel)
 {
 	struct vmbus_channel_close_channel *msg;
 	struct vmbus_channel_msginfo *info;
@@ -646,8 +597,8 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
 	int ret;
 
 	/* Stop callback and cancel the timer asap */
-	Channel->OnChannelCallback = NULL;
-	del_timer_sync(&Channel->poll_timer);
+	channel->OnChannelCallback = NULL;
+	del_timer_sync(&channel->poll_timer);
 
 	/* Send a closing message */
 	info = kmalloc(sizeof(*info) +
@@ -661,7 +612,7 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
 
 	msg = (struct vmbus_channel_close_channel *)info->Msg;
 	msg->Header.MessageType = ChannelMessageCloseChannel;
-	msg->ChildRelId = Channel->OfferMsg.ChildRelId;
+	msg->ChildRelId = channel->OfferMsg.ChildRelId;
 
 	ret = VmbusPostMessage(msg, sizeof(struct vmbus_channel_close_channel));
 	if (ret != 0) {
@@ -670,17 +621,17 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
 	}
 
 	/* Tear down the gpadl for the channel's ring buffer */
-	if (Channel->RingBufferGpadlHandle)
-		VmbusChannelTeardownGpadl(Channel,
-					  Channel->RingBufferGpadlHandle);
+	if (channel->RingBufferGpadlHandle)
+		vmbuschannel_teardowngpadl(channel,
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
 
@@ -690,21 +641,21 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
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
 
 /**
- * VmbusChannelSendPacket() - Send the specified buffer on the given channel
- * @Channel: Pointer to vmbus_channel structure.
- * @Buffer: Pointer to the buffer you want to receive the data into.
- * @BufferLen: Maximum size of what the the buffer will hold
- * @RequestId: Identifier of the request
+ * vmbuschannel_sendpacket() - Send the specified buffer on the given channel
+ * @channel: Pointer to vmbus_channel structure.
+ * @buffer: Pointer to the buffer you want to receive the data into.
+ * @bufferlen: Maximum size of what the the buffer will hold
+ * @requestid: Identifier of the request
  * @vmbus_packet_type: Type of packet that is being send e.g. negotiate, time
  * packet etc.
  *
@@ -713,192 +664,192 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
  *
  * Mainly used by Hyper-V drivers.
  */
-int VmbusChannelSendPacket(struct vmbus_channel *Channel, const void *Buffer,
-			   u32 BufferLen, u64 RequestId,
-			   enum vmbus_packet_type Type, u32 Flags)
+int vmbuschannel_sendpacket(struct vmbus_channel *channel, const void *buffer,
+			   u32 bufferlen, u64 requestid,
+			   enum vmbus_packet_type type, u32 flags)
 {
 	struct vmpacket_descriptor desc;
-	u32 packetLen = sizeof(struct vmpacket_descriptor) + BufferLen;
+	u32 packetLen = sizeof(struct vmpacket_descriptor) + bufferlen;
 	u32 packetLenAligned = ALIGN_UP(packetLen, sizeof(u64));
 	struct scatterlist bufferList[3];
 	u64 alignedData = 0;
 	int ret;
 
 	DPRINT_DBG(VMBUS, "channel %p buffer %p len %d",
-		   Channel, Buffer, BufferLen);
+		   channel, buffer, bufferlen);
 
-	DumpVmbusChannel(Channel);
+	dumpvmbuschannel(channel);
 
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
 	/* Setup the descriptor */
-	desc.Type = Type; /* VmbusPacketTypeDataInBand; */
-	desc.Flags = Flags; /* VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED; */
+	desc.Type = type; /* VmbusPacketTypeDataInBand; */
+	desc.Flags = flags; /* VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED; */
 	/* in 8-bytes granularity */
 	desc.DataOffset8 = sizeof(struct vmpacket_descriptor) >> 3;
 	desc.Length8 = (u16)(packetLenAligned >> 3);
-	desc.TransactionId = RequestId;
+	desc.TransactionId = requestid;
 
 	sg_init_table(bufferList, 3);
 	sg_set_buf(&bufferList[0], &desc, sizeof(struct vmpacket_descriptor));
-	sg_set_buf(&bufferList[1], Buffer, BufferLen);
+	sg_set_buf(&bufferList[1], buffer, bufferlen);
 	sg_set_buf(&bufferList[2], &alignedData, packetLenAligned - packetLen);
 
-	ret = RingBufferWrite(&Channel->Outbound, bufferList, 3);
+	ret = RingBufferWrite(&channel->Outbound, bufferList, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&Channel->Outbound))
-		VmbusChannelSetEvent(Channel);
+	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
+		vmbuschannel_setevent(channel);
 
 	return ret;
 }
-EXPORT_SYMBOL(VmbusChannelSendPacket);
+EXPORT_SYMBOL(vmbuschannel_sendpacket);
 
 /*
- * VmbusChannelSendPacketPageBuffer - Send a range of single-page buffer
+ * vmbuschannel_sendpacketpagebuffer - Send a range of single-page buffer
  * packets using a GPADL Direct packet type.
  */
-int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
-				     struct hv_page_buffer PageBuffers[],
-				     u32 PageCount, void *Buffer, u32 BufferLen,
-				     u64 RequestId)
+int vmbuschannel_sendpacketpagebuffer(struct vmbus_channel *channel,
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
+	u32 packetlenaligned;
+	struct scatterlist bufferlist[3];
+	u64 aligneddata = 0;
 
-	if (PageCount > MAX_PAGE_BUFFER_COUNT)
+	if (pagecount > MAX_PAGE_BUFFER_COUNT)
 		return -EINVAL;
 
-	DumpVmbusChannel(Channel);
+	dumpvmbuschannel(channel);
 
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
+	packetlenaligned = ALIGN_UP(packetlen, sizeof(u64));
 
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
+	desc.length8 = (u16)(packetlenaligned >> 3);
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
+	sg_set_buf(&bufferlist[2], &aligneddata, packetlenaligned - packetlen);
 
-	ret = RingBufferWrite(&Channel->Outbound, bufferList, 3);
+	ret = RingBufferWrite(&channel->Outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&Channel->Outbound))
-		VmbusChannelSetEvent(Channel);
+	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
+		vmbuschannel_setevent(channel);
 
 	return ret;
 }
 
 /*
- * VmbusChannelSendPacketMultiPageBuffer - Send a multi-page buffer packet
+ * vmbuschannel_sendpacketmultipagebuffer - Send a multi-page buffer packet
  * using a GPADL Direct packet type.
  */
-int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
-				struct hv_multipage_buffer *MultiPageBuffer,
-				void *Buffer, u32 BufferLen, u64 RequestId)
+int vmbuschannel_sendpacketmultipagebuffer(struct vmbus_channel *channel,
+				struct hv_multipage_buffer *multipagebuffer,
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
+	u32 packetlenaligned;
+	struct scatterlist bufferlist[3];
+	u64 aligneddata = 0;
+	u32 pfncount = NUM_PAGES_SPANNED(multipagebuffer->Offset,
+					 multipagebuffer->Length);
 
-	DumpVmbusChannel(Channel);
+	dumpvmbuschannel(channel);
 
 	DPRINT_DBG(VMBUS, "data buffer - offset %u len %u pfn count %u",
-		   MultiPageBuffer->Offset, MultiPageBuffer->Length, PfnCount);
+		   multipagebuffer->Offset, multipagebuffer->Length, pfncount);
 
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
+	packetlenaligned = ALIGN_UP(packetlen, sizeof(u64));
 
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
 	/* Setup the descriptor */
 	desc.type = VmbusPacketTypeDataUsingGpaDirect;
 	desc.flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
-	desc.dataoffset8 = descSize >> 3; /* in 8-bytes grandularity */
-	desc.length8 = (u16)(packetLenAligned >> 3);
-	desc.transactionid = RequestId;
+	desc.dataoffset8 = descsize >> 3; /* in 8-bytes grandularity */
+	desc.length8 = (u16)(packetlenaligned >> 3);
+	desc.transactionid = requestid;
 	desc.rangecount = 1;
 
-	desc.range.Length = MultiPageBuffer->Length;
-	desc.range.Offset = MultiPageBuffer->Offset;
+	desc.range.Length = multipagebuffer->Length;
+	desc.range.Offset = multipagebuffer->Offset;
 
-	memcpy(desc.range.PfnArray, MultiPageBuffer->PfnArray,
-	       PfnCount * sizeof(u64));
+	memcpy(desc.range.PfnArray, multipagebuffer->PfnArray,
+	       pfncount * sizeof(u64));
 
-	sg_init_table(bufferList, 3);
-	sg_set_buf(&bufferList[0], &desc, descSize);
-	sg_set_buf(&bufferList[1], Buffer, BufferLen);
-	sg_set_buf(&bufferList[2], &alignedData, packetLenAligned - packetLen);
+	sg_init_table(bufferlist, 3);
+	sg_set_buf(&bufferlist[0], &desc, descsize);
+	sg_set_buf(&bufferlist[1], buffer, bufferlen);
+	sg_set_buf(&bufferlist[2], &aligneddata, packetlenaligned - packetlen);
 
-	ret = RingBufferWrite(&Channel->Outbound, bufferList, 3);
+	ret = RingBufferWrite(&channel->Outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&Channel->Outbound))
-		VmbusChannelSetEvent(Channel);
+	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
+		vmbuschannel_setevent(channel);
 
 	return ret;
 }
 
 
 /**
- * VmbusChannelRecvPacket() - Retrieve the user packet on the specified channel
- * @Channel: Pointer to vmbus_channel structure.
- * @Buffer: Pointer to the buffer you want to receive the data into.
- * @BufferLen: Maximum size of what the the buffer will hold
- * @BufferActualLen: The actual size of the data after it was received
- * @RequestId: Identifier of the request
+ * vmbuschannel_recvpacket() - Retrieve the user packet on the specified channel
+ * @channel: Pointer to vmbus_channel structure.
+ * @buffer: Pointer to the buffer you want to receive the data into.
+ * @bufferlen: Maximum size of what the the buffer will hold
+ * @bufferactuallen: The actual size of the data after it was received
+ * @requestid: Identifier of the request
  *
  * Receives directly from the hyper-v vmbus and puts the data it received
  * into Buffer. This will receive the data unparsed from hyper-v.
  *
  * Mainly used by Hyper-V drivers.
  */
-int VmbusChannelRecvPacket(struct vmbus_channel *Channel, void *Buffer,
-			   u32 BufferLen, u32 *BufferActualLen, u64 *RequestId)
+int vmbuschannel_recvpacket(struct vmbus_channel *channel, void *buffer,
+			   u32 bufferlen, u32 *bufferactuallen, u64 *requestid)
 {
 	struct vmpacket_descriptor desc;
 	u32 packetLen;
@@ -906,15 +857,15 @@ int VmbusChannelRecvPacket(struct vmbus_channel *Channel, void *Buffer,
 	int ret;
 	unsigned long flags;
 
-	*BufferActualLen = 0;
-	*RequestId = 0;
+	*bufferactuallen = 0;
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
@@ -928,53 +879,53 @@ int VmbusChannelRecvPacket(struct vmbus_channel *Channel, void *Buffer,
 
 	DPRINT_DBG(VMBUS, "packet received on channel %p relid %d <type %d "
 		   "flag %d tid %llx pktlen %d datalen %d> ",
-		   Channel, Channel->OfferMsg.ChildRelId, desc.Type,
+		   channel, channel->OfferMsg.ChildRelId, desc.Type,
 		   desc.Flags, desc.TransactionId, packetLen, userLen);
 
-	*BufferActualLen = userLen;
+	*bufferactuallen = userLen;
 
-	if (userLen > BufferLen) {
-		spin_unlock_irqrestore(&Channel->inbound_lock, flags);
+	if (userLen > bufferlen) {
+		spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
 		DPRINT_ERR(VMBUS, "buffer too small - got %d needs %d",
-			   BufferLen, userLen);
+			   bufferlen, userLen);
 		return -1;
 	}
 
-	*RequestId = desc.TransactionId;
+	*requestid = desc.TransactionId;
 
 	/* Copy over the packet to the user buffer */
-	ret = RingBufferRead(&Channel->Inbound, Buffer, userLen,
+	ret = RingBufferRead(&channel->Inbound, buffer, userLen,
 			     (desc.DataOffset8 << 3));
 
-	spin_unlock_irqrestore(&Channel->inbound_lock, flags);
+	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
 	return 0;
 }
-EXPORT_SYMBOL(VmbusChannelRecvPacket);
+EXPORT_SYMBOL(vmbuschannel_recvpacket);
 
 /*
- * VmbusChannelRecvPacketRaw - Retrieve the raw packet on the specified channel
+ * vmbuschannel_recvpacketraw - Retrieve the raw packet on the specified channel
  */
-int VmbusChannelRecvPacketRaw(struct vmbus_channel *Channel, void *Buffer,
-			      u32 BufferLen, u32 *BufferActualLen,
-			      u64 *RequestId)
+int vmbuschannel_recvpacketraw(struct vmbus_channel *channel, void *buffer,
+			      u32 bufferlen, u32 *bufferactuallen,
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
+	*bufferactuallen = 0;
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
@@ -982,50 +933,50 @@ int VmbusChannelRecvPacketRaw(struct vmbus_channel *Channel, void *Buffer,
 
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
+	*bufferactuallen = packetlen;
 
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
- * VmbusChannelOnChannelEvent - Channel event callback
+ * vmbuschannel_onchannelevent - Channel event callback
  */
-void VmbusChannelOnChannelEvent(struct vmbus_channel *Channel)
+void vmbuschannel_onchannelevent(struct vmbus_channel *channel)
 {
-	DumpVmbusChannel(Channel);
+	dumpvmbuschannel(channel);
 	/* ASSERT(Channel->OnChannelCallback); */
 
-	Channel->OnChannelCallback(Channel->ChannelCallbackContext);
+	channel->OnChannelCallback(channel->ChannelCallbackContext);
 
-	mod_timer(&Channel->poll_timer, jiffies + usecs_to_jiffies(100));
+	mod_timer(&channel->poll_timer, jiffies + usecs_to_jiffies(100));
 }
 
 /*
- * VmbusChannelOnTimer - Timer event callback
+ * vmbuschannel_ontimer - Timer event callback
  */
-void VmbusChannelOnTimer(unsigned long data)
+void vmbuschannel_ontimer(unsigned long data)
 {
 	struct vmbus_channel *channel = (struct vmbus_channel *)data;
 
@@ -1036,7 +987,7 @@ void VmbusChannelOnTimer(unsigned long data)
 /*
  * DumpVmbusChannel - Dump vmbus channel info to the console
  */
-static void DumpVmbusChannel(struct vmbus_channel *Channel)
+static void dumpvmbuschannel(struct vmbus_channel *Channel)
 {
 	DPRINT_DBG(VMBUS, "Channel (%d)", Channel->OfferMsg.ChildRelId);
 	DumpRingInfo(&Channel->Outbound, "Outbound ");
diff --git a/drivers/staging/hv/channel.h b/drivers/staging/hv/channel.h
index 85c5079..50ee36a 100644
--- a/drivers/staging/hv/channel.h
+++ b/drivers/staging/hv/channel.h
@@ -52,61 +52,61 @@ struct vmbus_channel_packet_multipage_buffer {
 } __attribute__((packed));
 
 
-extern int VmbusChannelOpen(struct vmbus_channel *channel,
-			    u32 SendRingBufferSize,
-			    u32 RecvRingBufferSize,
-			    void *UserData,
-			    u32 UserDataLen,
-			    void(*OnChannelCallback)(void *context),
-			    void *Context);
-
-extern void VmbusChannelClose(struct vmbus_channel *channel);
-
-extern int VmbusChannelSendPacket(struct vmbus_channel *channel,
-				  const void *Buffer,
-				  u32 BufferLen,
-				  u64 RequestId,
-				  enum vmbus_packet_type Type,
-				  u32 Flags);
-
-extern int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *channel,
-					    struct hv_page_buffer PageBuffers[],
-					    u32 PageCount,
-					    void *Buffer,
-					    u32 BufferLen,
-					    u64 RequestId);
-
-extern int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *channel,
+extern int vmbuschannel_open(struct vmbus_channel *channel,
+			    u32 sendringbuffersize,
+			    u32 recvringbuffersize,
+			    void *userdata,
+			    u32 userdatalen,
+			    void(*onchannelcallback)(void *context),
+			    void *context);
+
+extern void vmbuschannel_close(struct vmbus_channel *channel);
+
+extern int vmbuschannel_sendpacket(struct vmbus_channel *channel,
+				  const void *buffer,
+				  u32 bufferlen,
+				  u64 requestid,
+				  enum vmbus_packet_type type,
+				  u32 flags);
+
+extern int vmbuschannel_sendpacketpagebuffer(struct vmbus_channel *channel,
+					    struct hv_page_buffer pagebuffers[],
+					    u32 pagecount,
+					    void *buffer,
+					    u32 bufferlen,
+					    u64 requestid);
+
+extern int vmbuschannel_sendpacketmultipagebuffer(struct vmbus_channel *channel,
 					struct hv_multipage_buffer *mpb,
-					void *Buffer,
-					u32 BufferLen,
-					u64 RequestId);
+					void *buffer,
+					u32 bufferlen,
+					u64 requestid);
 
-extern int VmbusChannelEstablishGpadl(struct vmbus_channel *channel,
-				      void *Kbuffer,
-				      u32 Size,
-				      u32 *GpadlHandle);
+extern int vmbuschannel_establishgpadl(struct vmbus_channel *channel,
+				      void *kbuffer,
+				      u32 size,
+				      u32 *gpadlhandle);
 
-extern int VmbusChannelTeardownGpadl(struct vmbus_channel *channel,
-				     u32 GpadlHandle);
+extern int vmbuschannel_teardowngpadl(struct vmbus_channel *channel,
+				     u32 gpadlhandle);
 
-extern int VmbusChannelRecvPacket(struct vmbus_channel *channel,
-				  void *Buffer,
-				  u32 BufferLen,
-				  u32 *BufferActualLen,
-				  u64 *RequestId);
+extern int vmbuschannel_recvpacket(struct vmbus_channel *channel,
+				  void *buffer,
+				  u32 bufferlen,
+				  u32 *bufferactuallen,
+				  u64 *requestid);
 
-extern int VmbusChannelRecvPacketRaw(struct vmbus_channel *channel,
-				     void *Buffer,
-				     u32 BufferLen,
-				     u32 *BufferActualLen,
-				     u64 *RequestId);
+extern int vmbuschannel_recvpacketraw(struct vmbus_channel *channel,
+				     void *buffer,
+				     u32 bufferlen,
+				     u32 *bufferactuallen,
+				     u64 *requestid);
 
-extern void VmbusChannelOnChannelEvent(struct vmbus_channel *channel);
+extern void vmbuschannel_onchannelevent(struct vmbus_channel *channel);
 
-extern void VmbusChannelGetDebugInfo(struct vmbus_channel *channel,
+extern void vmbuschannel_getdebuginfo(struct vmbus_channel *channel,
 				     struct vmbus_channel_debug_info *debug);
 
-extern void VmbusChannelOnTimer(unsigned long data);
+extern void vmbuschannel_ontimer(unsigned long data);
 
 #endif /* _CHANNEL_H_ */
diff --git a/drivers/staging/hv/channel_interface.c b/drivers/staging/hv/channel_interface.c
index 3f6a1cb..68c374b 100644
--- a/drivers/staging/hv/channel_interface.c
+++ b/drivers/staging/hv/channel_interface.c
@@ -31,21 +31,21 @@ static int IVmbusChannelOpen(struct hv_device *device, u32 SendBufferSize,
 			     void (*ChannelCallback)(void *context),
 			     void *Context)
 {
-	return VmbusChannelOpen(device->context, SendBufferSize,
+	return vmbuschannel_open(device->context, SendBufferSize,
 				RecvRingBufferSize, UserData, UserDataLen,
 				ChannelCallback, Context);
 }
 
 static void IVmbusChannelClose(struct hv_device *device)
 {
-	VmbusChannelClose(device->context);
+	vmbuschannel_close(device->context);
 }
 
 static int IVmbusChannelSendPacket(struct hv_device *device, const void *Buffer,
 				   u32 BufferLen, u64 RequestId, u32 Type,
 				   u32 Flags)
 {
-	return VmbusChannelSendPacket(device->context, Buffer, BufferLen,
+	return vmbuschannel_sendpacket(device->context, Buffer, BufferLen,
 				      RequestId, Type, Flags);
 }
 
@@ -54,7 +54,7 @@ static int IVmbusChannelSendPacketPageBuffer(struct hv_device *device,
 				u32 PageCount, void *Buffer,
 				u32 BufferLen, u64 RequestId)
 {
-	return VmbusChannelSendPacketPageBuffer(device->context, PageBuffers,
+	return vmbuschannel_sendpacketpagebuffer(device->context, PageBuffers,
 						PageCount, Buffer, BufferLen,
 						RequestId);
 }
@@ -63,7 +63,7 @@ static int IVmbusChannelSendPacketMultiPageBuffer(struct hv_device *device,
 				struct hv_multipage_buffer *MultiPageBuffer,
 				void *Buffer, u32 BufferLen, u64 RequestId)
 {
-	return VmbusChannelSendPacketMultiPageBuffer(device->context,
+	return vmbuschannel_sendpacketmultipagebuffer(device->context,
 						     MultiPageBuffer, Buffer,
 						     BufferLen, RequestId);
 }
@@ -72,7 +72,7 @@ static int IVmbusChannelRecvPacket(struct hv_device *device, void *Buffer,
 				   u32 BufferLen, u32 *BufferActualLen,
 				   u64 *RequestId)
 {
-	return VmbusChannelRecvPacket(device->context, Buffer, BufferLen,
+	return vmbuschannel_recvpacket(device->context, Buffer, BufferLen,
 				      BufferActualLen, RequestId);
 }
 
@@ -80,20 +80,20 @@ static int IVmbusChannelRecvPacketRaw(struct hv_device *device, void *Buffer,
 				      u32 BufferLen, u32 *BufferActualLen,
 				      u64 *RequestId)
 {
-	return VmbusChannelRecvPacketRaw(device->context, Buffer, BufferLen,
+	return vmbuschannel_recvpacketraw(device->context, Buffer, BufferLen,
 					 BufferActualLen, RequestId);
 }
 
 static int IVmbusChannelEstablishGpadl(struct hv_device *device, void *Buffer,
 				       u32 BufferLen, u32 *GpadlHandle)
 {
-	return VmbusChannelEstablishGpadl(device->context, Buffer, BufferLen,
+	return vmbuschannel_establishgpadl(device->context, Buffer, BufferLen,
 					  GpadlHandle);
 }
 
 static int IVmbusChannelTeardownGpadl(struct hv_device *device, u32 GpadlHandle)
 {
-	return VmbusChannelTeardownGpadl(device->context, GpadlHandle);
+	return vmbuschannel_teardowngpadl(device->context, GpadlHandle);
 
 }
 
@@ -105,7 +105,7 @@ void GetChannelInfo(struct hv_device *device, struct hv_device_info *info)
 	if (!device->context)
 		return;
 
-	VmbusChannelGetDebugInfo(device->context, &debugInfo);
+	vmbuschannel_getdebuginfo(device->context, &debugInfo);
 
 	info->ChannelId = debugInfo.RelId;
 	info->ChannelState = debugInfo.State;
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 6ccf505..55bc2a4 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -172,7 +172,7 @@ void chn_cb_negotiate(void *context)
 	buflen = PAGE_SIZE;
 	buf = kmalloc(buflen, GFP_ATOMIC);
 
-	VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+	vmbuschannel_recvpacket(channel, buf, buflen, &recvlen, &requestid);
 
 	if (recvlen > 0) {
 		icmsghdrp = (struct icmsg_hdr *)&buf[
@@ -183,7 +183,7 @@ void chn_cb_negotiate(void *context)
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
 
-		VmbusChannelSendPacket(channel, buf,
+		vmbuschannel_sendpacket(channel, buf,
 				       recvlen, requestid,
 				       VmbusPacketTypeDataInBand, 0);
 	}
@@ -249,7 +249,7 @@ struct vmbus_channel *AllocVmbusChannel(void)
 
 	init_timer(&channel->poll_timer);
 	channel->poll_timer.data = (unsigned long)channel;
-	channel->poll_timer.function = VmbusChannelOnTimer;
+	channel->poll_timer.function = vmbuschannel_ontimer;
 
 	channel->ControlWQ = create_workqueue("hv_vmbus_ctl");
 	if (!channel->ControlWQ) {
@@ -392,7 +392,7 @@ static void VmbusChannelProcessOffer(void *context)
 			if (memcmp(&newChannel->OfferMsg.Offer.InterfaceType,
 				   &hv_cb_utils[cnt].data,
 				   sizeof(struct hv_guid)) == 0 &&
-				VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
+				vmbuschannel_open(newChannel, 2 * PAGE_SIZE,
 						 2 * PAGE_SIZE, NULL, 0,
 						 hv_cb_utils[cnt].callback,
 						 newChannel) == 0) {
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 1f4d668..508572f 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -254,10 +254,10 @@ static void VmbusProcessChannelEvent(void *context)
 	channel = GetChannelFromRelId(relId);
 
 	if (channel) {
-		VmbusChannelOnChannelEvent(channel);
+		vmbuschannel_onchannelevent(channel);
 		/*
 		 * WorkQueueQueueWorkItem(channel->dataWorkQueue,
-		 *			  VmbusChannelOnChannelEvent,
+		 *			  vmbuschannel_onchannelevent,
 		 *			  (void*)channel);
 		 */
 	} else {
diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
index 6eb79fe..2416f50 100644
--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -55,7 +55,7 @@ static void shutdown_onchannelcallback(void *context)
 	buflen = PAGE_SIZE;
 	buf = kmalloc(buflen, GFP_ATOMIC);
 
-	VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+	vmbuschannel_recvpacket(channel, buf, buflen, &recvlen, &requestid);
 
 	if (recvlen > 0) {
 		DPRINT_DBG(VMBUS, "shutdown packet: len=%d, requestid=%lld",
@@ -93,7 +93,7 @@ static void shutdown_onchannelcallback(void *context)
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
 
-		VmbusChannelSendPacket(channel, buf,
+		vmbuschannel_sendpacket(channel, buf,
 				       recvlen, requestid,
 				       VmbusPacketTypeDataInBand, 0);
 	}
@@ -159,7 +159,7 @@ static void timesync_onchannelcallback(void *context)
 	buflen = PAGE_SIZE;
 	buf = kmalloc(buflen, GFP_ATOMIC);
 
-	VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+	vmbuschannel_recvpacket(channel, buf, buflen, &recvlen, &requestid);
 
 	if (recvlen > 0) {
 		DPRINT_DBG(VMBUS, "timesync packet: recvlen=%d, requestid=%lld",
@@ -180,7 +180,7 @@ static void timesync_onchannelcallback(void *context)
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
 
-		VmbusChannelSendPacket(channel, buf,
+		vmbuschannel_sendpacket(channel, buf,
 				recvlen, requestid,
 				VmbusPacketTypeDataInBand, 0);
 	}
@@ -205,7 +205,7 @@ static void heartbeat_onchannelcallback(void *context)
 	buflen = PAGE_SIZE;
 	buf = kmalloc(buflen, GFP_ATOMIC);
 
-	VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+	vmbuschannel_recvpacket(channel, buf, buflen, &recvlen, &requestid);
 
 	if (recvlen > 0) {
 		DPRINT_DBG(VMBUS, "heartbeat packet: len=%d, requestid=%lld",
@@ -233,7 +233,7 @@ static void heartbeat_onchannelcallback(void *context)
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
 
-		VmbusChannelSendPacket(channel, buf,
+		vmbuschannel_sendpacket(channel, buf,
 				       recvlen, requestid,
 				       VmbusPacketTypeDataInBand, 0);
 	}
-- 
1.6.3.2

