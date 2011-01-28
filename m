Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1A1EFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:05 -0500
Received: from mail.perches.com ([173.55.12.10]:3423 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab1A1EEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:49 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] staging: ath6kl: Remove A_SUCCESS macro
Date: Thu, 27 Jan 2011 20:04:20 -0800
Message-Id: <a716b62cdac00059e48a14c0bf151e0695007636.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove obfuscating A_SUCCESS(foo) macro.
Just test for !foo instead.

Reformat a few macros that used A_SUCCESS for better readability.
Add do { foo } while (0) surrounds to those macros too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/bmi/src/bmi.c               |    2 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |    4 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |    6 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |   16 +++++++++-----
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |    4 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |    6 ++--
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |   21 ++++++++++++-------
 drivers/staging/ath6kl/htc2/htc_recv.c             |   10 ++++----
 drivers/staging/ath6kl/include/common/athdefs.h    |    3 +-
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   10 ++++----
 11 files changed, 46 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/ath6kl/bmi/src/bmi.c b/drivers/staging/ath6kl/bmi/src/bmi.c
index a782166..ccec7c4 100644
--- a/drivers/staging/ath6kl/bmi/src/bmi.c
+++ b/drivers/staging/ath6kl/bmi/src/bmi.c
@@ -985,7 +985,7 @@ BMIFastDownload(HIF_DEVICE *device, A_UINT32 address, A_UCHAR *buffer, A_UINT32
         status = BMILZData(device, (A_UINT8 *)&lastWord, 4);
     }
 
-    if (A_SUCCESS(status)) {
+    if (!status) {
         //
         // Close compressed stream and open a new (fake) one.  This serves mainly to flush Target caches.
         //
diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 61166a5..56f6a07 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -1120,7 +1120,7 @@ static int hifDeviceResume(struct device *dev)
     }
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifDeviceResume\n"));
 
-    return A_SUCCESS(status) ? 0 : status;
+    return status;
 }
 #endif /* CONFIG_PM */
 
@@ -1167,7 +1167,7 @@ int hifWaitForPendingRecv(HIF_DEVICE *device)
 	    status = HIFReadWrite(device, HOST_INT_STATUS_ADDRESS,
 				    (A_UINT8 *)&host_int_status, sizeof(host_int_status),
 			  	     HIF_RD_SYNC_BYTE_INC, NULL);
-	    host_int_status = A_SUCCESS(status) ? (host_int_status & (1 << 0)) : 0;
+	    host_int_status = !status ? (host_int_status & (1 << 0)) : 0;
 		if (host_int_status) {
 	        schedule(); /* schedule for next dsrHandler */
 		}
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
index 8c6d659..65c5d9b 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.c
@@ -516,7 +516,7 @@ int DevWaitForPendingRecv(AR6K_DEVICE *pDev,A_UINT32 TimeoutInMs,A_BOOL *pbIsRec
             break;
         }
 
-        host_int_status = A_SUCCESS(status) ? (host_int_status & (1 << 0)):0;
+        host_int_status = !status ? (host_int_status & (1 << 0)):0;
         if(!host_int_status)
         {
             status          = A_OK;
@@ -832,7 +832,7 @@ int DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer)
             /* we can try to use a virtual DMA scatter mechanism using legacy HIFReadWrite() */
         status = DevSetupVirtualScatterSupport(pDev);
 
-        if (A_SUCCESS(status)) {
+        if (!status) {
              AR_DEBUG_PRINTF(ATH_DEBUG_ANY,
                 ("AR6K: virtual scatter transfers enabled (max scatter items:%d: maxlen:%d) \n",
                     DEV_GET_MAX_MSG_PER_BUNDLE(pDev), DEV_GET_MAX_BUNDLE_LENGTH(pDev)));
@@ -844,7 +844,7 @@ int DevSetupMsgBundling(AR6K_DEVICE *pDev, int MaxMsgsPerTransfer)
                     DEV_GET_MAX_MSG_PER_BUNDLE(pDev), DEV_GET_MAX_BUNDLE_LENGTH(pDev)));
     }
 
-    if (A_SUCCESS(status)) {
+    if (!status) {
             /* for the recv path, the maximum number of bytes per recv bundle is just limited
              * by the maximum transfer size at the HIF layer */
         pDev->MaxRecvBundleSize = pDev->HifScatterInfo.MaxTransferSizePerScatterReq;
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index 7578e91..2eced10 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -275,12 +275,16 @@ static INLINE int DevRecvPacket(AR6K_DEVICE *pDev, HTC_PACKET *pPacket, A_UINT32
 int DevCopyScatterListToFromDMABuffer(HIF_SCATTER_REQ *pReq, A_BOOL FromDMA);
     
     /* copy any READ data back into scatter list */        
-#define DEV_FINISH_SCATTER_OPERATION(pR)                      \
-    if (A_SUCCESS((pR)->CompletionStatus) &&                  \
-        !((pR)->Request & HIF_WRITE) &&                       \
-         ((pR)->ScatterMethod == HIF_SCATTER_DMA_BOUNCE)) {   \
-         (pR)->CompletionStatus = DevCopyScatterListToFromDMABuffer((pR),FROM_DMA_BUFFER); \
-    }
+#define DEV_FINISH_SCATTER_OPERATION(pR)				\
+do {									\
+	if (!((pR)->CompletionStatus) &&				\
+	    !((pR)->Request & HIF_WRITE) &&				\
+	    ((pR)->ScatterMethod == HIF_SCATTER_DMA_BOUNCE)) {		\
+		(pR)->CompletionStatus =				\
+			DevCopyScatterListToFromDMABuffer((pR),		\
+							  FROM_DMA_BUFFER); \
+	}								\
+} while (0)
     
     /* copy any WRITE data to bounce buffer */
 static INLINE int DEV_PREPARE_SCATTER_OPERATION(HIF_SCATTER_REQ *pReq)  {
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
index 21d88f1..f12ae42 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
@@ -372,7 +372,7 @@ static void DevGetEventAsyncHandler(void *Context, HTC_PACKET *pPacket)
                  * go get the next message */
             status = pDev->MessagePendingCallback(pDev->HTCContext, &lookAhead, 1, NULL, &fetched);
 
-            if (A_SUCCESS(status) && !fetched) {
+            if (!status && !fetched) {
                     /* HTC layer could not pull out messages due to lack of resources, stop IRQ processing */
                 AR_DEBUG_PRINTF(ATH_DEBUG_IRQ,("MessagePendingCallback did not pull any messages, force-ack \n"));
                 DevAsyncIrqProcessComplete(pDev);
@@ -725,7 +725,7 @@ int DevDsrHandler(void *context)
 
     }
 
-    if (A_SUCCESS(status) && !asyncProc) {
+    if (!status && !asyncProc) {
             /* Ack the interrupt only if :
              *  1. we did not get any errors in processing interrupts
              *  2. there are no outstanding async processing requests */
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
index d6b18ee..4c4c8fb 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
@@ -589,7 +589,7 @@ int DevGMboxReadCreditCounter(AR6K_DEVICE *pDev, A_BOOL AsyncMode, int *pCredits
     }
     
     if (pIOPacket != NULL) {
-        if (A_SUCCESS(status)) {
+        if (!status) {
                 /* sync mode processing */
             *pCredits = ProcessCreditCounterReadBuffer(pIOPacket->pBuffer, AR6K_REG_IO_BUFFER_SIZE);     
         }
@@ -614,7 +614,7 @@ int DevGMboxReadCreditSize(AR6K_DEVICE *pDev, int *pCreditSize)
                           HIF_RD_SYNC_BYTE_FIX, /* hit the register 4 times to align the I/O */
                           NULL);    
     
-    if (A_SUCCESS(status)) {
+    if (!status) {
         if (buffer[0] == 0) {
             *pCreditSize = 256;    
         } else {   
@@ -708,7 +708,7 @@ int DevGMboxSetTargetInterrupt(AR6K_DEVICE *pDev, int Signal, int AckTimeoutMS)
     } while (FALSE);
     
     
-    if (A_SUCCESS(status)) {        
+    if (!status) {
             /* now read back the register to see if the bit cleared */
         while (AckTimeoutMS) {        
             status = HIFReadWrite(pDev->HIFDevice,
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index 6b61dc4..8c801b0 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -82,11 +82,16 @@ typedef struct {
 #define LOCK_HCI_TX(t)   A_MUTEX_LOCK(&(t)->HCITxLock);
 #define UNLOCK_HCI_TX(t) A_MUTEX_UNLOCK(&(t)->HCITxLock);
 
-#define DO_HCI_RECV_INDICATION(p,pt) \
-{   AR_DEBUG_PRINTF(ATH_DEBUG_RECV,("HCI: Indicate Recv on packet:0x%lX status:%d len:%d type:%d \n",  \
-      (unsigned long)(pt),(pt)->Status, A_SUCCESS((pt)->Status) ? (pt)->ActualLength : 0, HCI_GET_PACKET_TYPE(pt))); \
-    (p)->HCIConfig.pHCIPktRecv((p)->HCIConfig.pContext, (pt));                                 \
-}
+#define DO_HCI_RECV_INDICATION(p, pt)				\
+do {								\
+	AR_DEBUG_PRINTF(ATH_DEBUG_RECV,					\
+			("HCI: Indicate Recv on packet:0x%lX status:%d len:%d type:%d \n", \
+			 (unsigned long)(pt),				\
+			 (pt)->Status,					\
+			 !(pt)->Status ? (pt)->ActualLength : 0,	\
+			 HCI_GET_PACKET_TYPE(pt)));			\
+	(p)->HCIConfig.pHCIPktRecv((p)->HCIConfig.pContext, (pt));	\
+} while (0)
 
 #define DO_HCI_SEND_INDICATION(p,pt) \
 {   AR_DEBUG_PRINTF(ATH_DEBUG_SEND,("HCI: Indicate Send on packet:0x%lX status:%d type:%d \n",  \
@@ -175,7 +180,7 @@ static int InitTxCreditState(GMBOX_PROTO_HCI_UART *pProt)
                
     } while (FALSE);
     
-    if (A_SUCCESS(status)) {
+    if (!status) {
         pProt->CreditsAvailable = pProt->CreditsMax;
         AR_DEBUG_PRINTF(ATH_DEBUG_ANY,("HCI : InitTxCreditState - credits avail: %d, size: %d \n",
             pProt->CreditsAvailable, pProt->CreditSize));    
@@ -768,7 +773,7 @@ static int HCITrySend(GMBOX_PROTO_HCI_UART *pProt, HTC_PACKET *pPacket, A_BOOL S
     
     if (Synchronous) {
         A_ASSERT(pPacket != NULL);
-        if (A_SUCCESS(status) && (!synchSendComplete)) {
+        if (!status && (!synchSendComplete)) {
             status = A_EBUSY;
             A_ASSERT(FALSE);
             LOCK_HCI_TX(pProt);
@@ -865,7 +870,7 @@ int GMboxProtocolInstall(AR6K_DEVICE *pDev)
      
     } while (FALSE);
     
-    if (A_SUCCESS(status)) {
+    if (!status) {
         LOCK_AR6K(pDev);
         DEV_GMBOX_SET_PROTOCOL(pDev,
                                HCIUartMessagePending,
diff --git a/drivers/staging/ath6kl/htc2/htc_recv.c b/drivers/staging/ath6kl/htc2/htc_recv.c
index 189d510..9762109 100644
--- a/drivers/staging/ath6kl/htc2/htc_recv.c
+++ b/drivers/staging/ath6kl/htc2/htc_recv.c
@@ -410,7 +410,7 @@ static INLINE void HTCAsyncRecvCheckMorePackets(HTC_TARGET  *target,
                             "BAD lookaheads from lookahead report");
 #endif
         }
-        if (A_SUCCESS(nextStatus) && !fetched) {
+        if (!nextStatus && !fetched) {
                 /* we could not fetch any more packets due to resources */
             DevAsyncIrqProcessComplete(&target->Device);        
         }
@@ -923,14 +923,14 @@ static void HTCAsyncRecvScatterCompletion(HIF_SCATTER_REQ *pScatterReq)
              * break out of this loop */
         numLookAheads = 0;
         
-        if (A_SUCCESS(pScatterReq->CompletionStatus)) {      
+        if (!pScatterReq->CompletionStatus) {
                 /* process header for each of the recv packets */            
             status = HTCProcessRecvHeader(target,pPacket,lookAheads,&numLookAheads);
         } else {
             status = A_ERROR;    
         }
         
-        if (A_SUCCESS(status)) {    
+        if (!status) {
 #ifdef HTC_EP_STAT_PROFILING
             LOCK_HTC_RX(target);              
             HTC_RX_STAT_PROFILE(target,pEndpoint,numLookAheads);
@@ -1085,7 +1085,7 @@ static int HTCIssueRecvPacketBundle(HTC_TARGET        *target,
         
         status = DevSubmitScatterRequest(&target->Device, pScatterReq, DEV_SCATTER_READ, asyncMode);
         
-        if (A_SUCCESS(status)) {
+        if (!status) {
             *pNumPacketsFetched = i;    
         }
         
@@ -1261,7 +1261,7 @@ int HTCRecvMessagePendingHandler(void *Context, A_UINT32 MsgLookAheads[], int Nu
             
         }
 
-        if (A_SUCCESS(status)) {  
+        if (!status) {
             CheckRecvWaterMark(pEndpoint);
         }
             
diff --git a/drivers/staging/ath6kl/include/common/athdefs.h b/drivers/staging/ath6kl/include/common/athdefs.h
index 2cd0720..ef60754 100644
--- a/drivers/staging/ath6kl/include/common/athdefs.h
+++ b/drivers/staging/ath6kl/include/common/athdefs.h
@@ -73,8 +73,7 @@
 #define A_PHY_ERROR		27	/* RX PHY error */
 #define A_CONSUMED		28	/* Object was consumed */
 
-#define A_SUCCESS(x)        (x == A_OK)
-#define A_FAILED(x)         (!A_SUCCESS(x))
+#define A_FAILED(x)         (!!x)
 
 #ifndef TRUE
 #define TRUE 1
diff --git a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
index 687f963..fa6b43f 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kconfig.c
@@ -288,7 +288,7 @@ static int AR3KExitMinBoot(AR3K_CONFIG_INFO *pConfig)
                                                &pEvent,
                                                &pBufferToFree);
     
-    if (A_SUCCESS(status)) {
+    if (!status) {
         if (pEvent[EXIT_MIN_BOOT_COMMAND_STATUS_OFFSET] != 0) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                 ("AR3K Config: MinBoot exit command event status failed: %d \n", 
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index c171be5..4ad78f2 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1674,8 +1674,8 @@ ar6000_avail_ev(void *context, void *hif_handle)
     if (ar_netif) { 
         HIF_DEVICE_OS_DEVICE_INFO osDevInfo;
         A_MEMZERO(&osDevInfo, sizeof(osDevInfo));
-        if ( A_SUCCESS( HIFConfigureDevice(hif_handle, HIF_DEVICE_GET_OS_DEVICE,
-                        &osDevInfo, sizeof(osDevInfo))) ) {
+        if (!HIFConfigureDevice(hif_handle, HIF_DEVICE_GET_OS_DEVICE,
+				&osDevInfo, sizeof(osDevInfo))) {
             SET_NETDEV_DEV(dev, osDevInfo.pOSDevice);
         }
     }
@@ -3115,7 +3115,7 @@ ar6000_data_tx(struct sk_buff *skb, struct net_device *dev)
                 if (ac == HCI_TRANSPORT_STREAM_NUM) {
                         /* pass this to HCI */
 #ifndef EXPORT_HCI_BRIDGE_INTERFACE
-                    if (A_SUCCESS(hci_test_send(ar,skb))) {
+                    if (!hci_test_send(ar,skb)) {
                         return 0;
                     }
 #endif
@@ -3428,7 +3428,7 @@ ar6000_tx_complete(void *Context, HTC_PACKET_QUEUE *pPacketQueue)
             /* add this to the list, use faster non-lock API */
         __skb_queue_tail(&skb_queue,pktSkb);
 
-        if (A_SUCCESS(status)) {
+        if (!status) {
             A_ASSERT(pPacket->ActualLength == A_NETBUF_LEN(pktSkb));
         }
 
@@ -3597,7 +3597,7 @@ ar6000_rx(void *Context, HTC_PACKET *pPacket)
          * and adaptive power throughput state */
     AR6000_SPIN_LOCK(&ar->arLock, 0);
 
-    if (A_SUCCESS(status)) {
+    if (!status) {
         AR6000_STAT_INC(ar, rx_packets);
         ar->arNetStats.rx_bytes += pPacket->ActualLength;
 #ifdef ADAPTIVE_POWER_THROUGHPUT_CONTROL
-- 
1.7.4.rc3

