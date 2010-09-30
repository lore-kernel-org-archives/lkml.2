Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0I3IYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:24:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab0I3IYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:24:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/6] staging/bcm: fix most build warnings
Date: Thu, 30 Sep 2010 10:24:11 +0200
Message-Id: <1285835052-11880-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285835052-11880-1-git-send-email-arnd@arndb.de>
References: <1285835052-11880-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Klf/Kz31rFp5v/rQuefCvgd+93UfQD529Fa/bRL3Mjf
 Cxymqvn2njTdHfNy27UVLAjkjhMF1JwLwBwNjiwybR6h5I4+Lv
 wlbPzdqzOW4ZwLHJZf+MmD3qX6ceCI7Tge1vHK1qpW79F/EW24
 fwncx84/PiFG9792yVj4e4rcLbF6FGiJW5dSmJBLSd6TN+3/x7
 awAoL1RG+9L2+aq9ikT5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes all warnings I get on a 64 bit build except
for those that look unfixable, where we convert a pointer
to a 32 bit integer and change its byte order!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/bcm/Bcmchar.c       |   15 +++++++--------
 drivers/staging/bcm/Bcmnet.c        |    4 ++--
 drivers/staging/bcm/CmHost.c        |   10 +++++-----
 drivers/staging/bcm/InterfaceInit.c |    4 ++--
 drivers/staging/bcm/LeakyBucket.c   |   20 ++++++++++----------
 drivers/staging/bcm/Macros.h        |    2 +-
 drivers/staging/bcm/Misc.c          |    2 +-
 drivers/staging/bcm/PHSDefines.h    |    2 +-
 drivers/staging/bcm/Transmit.c      |    4 +++-
 9 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index afde77a..2248ae5 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -100,7 +100,7 @@ static int bcm_char_release(struct inode *inode, struct file *filp)
     return 0;
 }
 
-static int bcm_char_read(struct file *filp, PCHAR buf, size_t size, loff_t *f_pos)
+static ssize_t bcm_char_read(struct file *filp, char __user *buf, size_t size, loff_t *f_pos)
 {
     PPER_TARANG_DATA pTarang = (PPER_TARANG_DATA)filp->private_data;
 	PMINI_ADAPTER	Adapter = pTarang->Adapter;
@@ -153,8 +153,7 @@ static int bcm_char_read(struct file *filp, PCHAR buf, size_t size, loff_t *f_po
     return PktLen;
 }
 
-static INT bcm_char_ioctl(struct inode *inode, struct file *filp,
-					UINT cmd, ULONG arg)
+static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
     PPER_TARANG_DATA  pTarang = (PPER_TARANG_DATA)filp->private_data;
 	PMINI_ADAPTER 	Adapter = pTarang->Adapter;
@@ -2359,11 +2358,11 @@ static INT bcm_char_ioctl(struct inode *inode, struct file *filp,
 
 
 static struct file_operations bcm_fops = {
-    .owner    = THIS_MODULE,
-    .open     = bcm_char_open,
-    .release  = bcm_char_release,
-    .read     = bcm_char_read,
-    .unlocked_ioctl    = bcm_char_ioctl,
+	.owner    = THIS_MODULE,
+	.open     = bcm_char_open,
+	.release  = bcm_char_release,
+	.read     = bcm_char_read,
+	.unlocked_ioctl    = bcm_char_ioctl,
 	.llseek = no_llseek,
 };
 
diff --git a/drivers/staging/bcm/Bcmnet.c b/drivers/staging/bcm/Bcmnet.c
index d4f4800..c619f91 100644
--- a/drivers/staging/bcm/Bcmnet.c
+++ b/drivers/staging/bcm/Bcmnet.c
@@ -126,7 +126,7 @@ int register_networkdev(PMINI_ADAPTER Adapter)
 {
 	int result=0;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
-	int *temp = NULL ;
+	void **temp = NULL; /* actually we're *allocating* the device in alloc_etherdev */
 #endif
 	Adapter->dev = alloc_etherdev(sizeof(PMINI_ADAPTER));
 	if(!Adapter->dev)
@@ -139,7 +139,7 @@ int register_networkdev(PMINI_ADAPTER Adapter)
 	Adapter->dev->priv      			= Adapter;
 #else
 	temp = netdev_priv(Adapter->dev);
-	*temp = (UINT)Adapter;
+	*temp = (void *)Adapter;
 #endif
 	//BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "init adapterptr: %x %x\n", (UINT)Adapter, temp);
 
diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index 328fd1b..f8e9e32 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1792,8 +1792,8 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *p
 				(ULONG)pstAddIndication->psfAuthorizedSet)!= 1)
 		return 0;
 
-	pstAddIndication->psfAuthorizedSet = (stServiceFlowParamSI *)
-				ntohl((ULONG)pstAddIndication->psfAuthorizedSet);
+	/* this can't possibly be right */
+	pstAddIndication->psfAuthorizedSet = (stServiceFlowParamSI *)ntohl((ULONG)pstAddIndication->psfAuthorizedSet);
 
 	if(pstAddIndicationAlt->u8Type == DSA_REQ)
 	{
@@ -1886,9 +1886,9 @@ static inline stLocalSFAddIndicationAlt
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "AddIndication-u8TID : 0x%X",ntohs(pstAddIndication->u16TID));
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "AddIndication-u8CID : 0x%X",ntohs(pstAddIndication->u16CID));
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "AddIndication-u16VCID : 0x%X",ntohs(pstAddIndication->u16VCID));
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "AddIndication-autorized set loc : 0x%x",ntohl(pstAddIndication->psfAuthorizedSet));
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "AddIndication-admitted set loc : 0x%x",ntohl(pstAddIndication->psfAdmittedSet));
-	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "AddIndication-Active set loc : 0x%x",ntohl(pstAddIndication->psfActiveSet));
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "AddIndication-autorized set loc : %p",pstAddIndication->psfAuthorizedSet);
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "AddIndication-admitted set loc : %p",pstAddIndication->psfAdmittedSet);
+	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL,  "AddIndication-Active set loc : %p",pstAddIndication->psfActiveSet);
 
 	pstAddIndicationDest->u8Type = pstAddIndication->u8Type;
 	pstAddIndicationDest->u8Direction = pstAddIndication->eConnectionDir;
diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index 67d8572..8bf900b 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -241,7 +241,7 @@ usbbcm_device_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	psIntfAdapter->interface = intf;
 	usb_set_intfdata(intf, psIntfAdapter);
 
-	BCM_DEBUG_PRINT(psAdapter,DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "psIntfAdapter 0x%x",(unsigned int)psIntfAdapter);
+	BCM_DEBUG_PRINT(psAdapter,DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "psIntfAdapter 0x%p",psIntfAdapter);
 	retval = InterfaceAdapterInit(psIntfAdapter);
 	if(retval)
 	{
@@ -323,7 +323,7 @@ static void usbbcm_disconnect (struct usb_interface *intf)
 		return;
 	}
 	psIntfAdapter = usb_get_intfdata(intf);
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "psIntfAdapter 0x%x",(unsigned int)psIntfAdapter);
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "psIntfAdapter 0x%p",psIntfAdapter);
 	if(psIntfAdapter == NULL)
 	{
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "InterfaceAdapter pointer is NULL");
diff --git a/drivers/staging/bcm/LeakyBucket.c b/drivers/staging/bcm/LeakyBucket.c
index 1875c82..b407938 100644
--- a/drivers/staging/bcm/LeakyBucket.c
+++ b/drivers/staging/bcm/LeakyBucket.c
@@ -80,9 +80,9 @@ static __inline ULONG GetSFTokenCount(PMINI_ADAPTER Adapter, PacketInfo *psSF)
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IsPacketAllowedForFlow ===>");
 	/* Validate the parameters */
 	if(NULL == Adapter || (psSF < Adapter->PackInfo &&
-		(UINT)psSF > (UINT) &Adapter->PackInfo[HiPriority]))
+		(uintptr_t)psSF > (uintptr_t) &Adapter->PackInfo[HiPriority]))
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IPAFF: Got wrong Parameters:Adapter: %p, QIndex: %d\n", Adapter, (psSF-Adapter->PackInfo));
+		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IPAFF: Got wrong Parameters:Adapter: %p, QIndex: %ld\n", Adapter, (psSF-Adapter->PackInfo));
 		return 0;
 	}
 
@@ -94,14 +94,14 @@ static __inline ULONG GetSFTokenCount(PMINI_ADAPTER Adapter, PacketInfo *psSF)
 		}
 		else
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "Not enough tokens in queue %d Available %u\n",
+			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "Not enough tokens in queue %ld Available %u\n",
 				psSF-Adapter->PackInfo, psSF->uiCurrentTokenCount);
 			psSF->uiPendedLast = 1;
 		}
 	}
 	else
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IPAFF: Queue %d not valid\n", psSF-Adapter->PackInfo);
+		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IPAFF: Queue %ld not valid\n", psSF-Adapter->PackInfo);
 	}
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TOKEN_COUNTS, DBG_LVL_ALL, "IsPacketAllowedForFlow <===");
 	return 0;
@@ -113,12 +113,12 @@ static __inline void RemovePacketFromQueue(PacketInfo *pPackInfo , struct sk_buf
 	psQueueCurrent = pPackInfo->FirstTxQueue;
 	while(psQueueCurrent)
 	{
-		if((UINT)Packet == (UINT)psQueueCurrent)
+		if(Packet == psQueueCurrent)
 		{
-			if((UINT)psQueueCurrent == (UINT)pPackInfo->FirstTxQueue)
+			if(psQueueCurrent == pPackInfo->FirstTxQueue)
 			{
 				pPackInfo->FirstTxQueue=psQueueCurrent->next;
-				if((UINT)psQueueCurrent==(UINT)pPackInfo->LastTxQueue)
+				if(psQueueCurrent==pPackInfo->LastTxQueue)
 					pPackInfo->LastTxQueue=NULL;
 			}
 			else
@@ -189,8 +189,8 @@ static __inline VOID CheckAndSendPacketFromIndex
 	int				iPacketLen=0;
 
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "%d ====>", (psSF-Adapter->PackInfo));
-	if(((UINT)psSF != (UINT)&Adapter->PackInfo[HiPriority]) && Adapter->LinkUpStatus && atomic_read(&psSF->uiPerSFTxResourceCount))//Get data packet
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "%ld ====>", (psSF-Adapter->PackInfo));
+	if((psSF != &Adapter->PackInfo[HiPriority]) && Adapter->LinkUpStatus && atomic_read(&psSF->uiPerSFTxResourceCount))//Get data packet
   	{
 		if(!psSF->ucDirection )
 			return;
@@ -240,7 +240,7 @@ static __inline VOID CheckAndSendPacketFromIndex
 			}
 			else
 			{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "For Queue: %d\n", psSF-Adapter->PackInfo);
+				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "For Queue: %ld\n", psSF-Adapter->PackInfo);
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "\nAvailable Tokens = %d required = %d\n",
 					psSF->uiCurrentTokenCount, iPacketLen);
 				//this part indicates that becuase of non-availability of the tokens
diff --git a/drivers/staging/bcm/Macros.h b/drivers/staging/bcm/Macros.h
index f559b59..6ee1480 100644
--- a/drivers/staging/bcm/Macros.h
+++ b/drivers/staging/bcm/Macros.h
@@ -382,7 +382,7 @@ enum eAbortPattern {
 	#define GET_BCM_ADAPTER(net_dev) ({\
     PMINI_ADAPTER __Adapter = NULL;	\
     if (net_dev)    {   \
-         __Adapter = (PMINI_ADAPTER)(*((UINT *)netdev_priv(net_dev)));  \
+         __Adapter = (PMINI_ADAPTER)(*((unsigned long *)netdev_priv(net_dev)));  \
     } \
     else    {   \
          __Adapter = NULL;  \
diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index 5ed58a8..994132f 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -26,7 +26,7 @@ InitAdapter(PMINI_ADAPTER psAdapter)
 {
     int i = 0;
 	INT Status = STATUS_SUCCESS ;
-	BCM_DEBUG_PRINT(psAdapter,DBG_TYPE_INITEXIT, MP_INIT,  DBG_LVL_ALL,  "Initialising Adapter = 0x%x",(unsigned int) psAdapter);
+	BCM_DEBUG_PRINT(psAdapter,DBG_TYPE_INITEXIT, MP_INIT,  DBG_LVL_ALL,  "Initialising Adapter = %p", psAdapter);
 
 	if(psAdapter == NULL)
 	{
diff --git a/drivers/staging/bcm/PHSDefines.h b/drivers/staging/bcm/PHSDefines.h
index 9889a99..eed4cfc 100644
--- a/drivers/staging/bcm/PHSDefines.h
+++ b/drivers/staging/bcm/PHSDefines.h
@@ -4,7 +4,7 @@
 #define PHS_INVALID_TABLE_INDEX 0xffffffff
 
 /************************* MACROS **********************************************/
-#define PHS_MEM_TAG '_SHP'
+#define PHS_MEM_TAG "_SHP"
 
 
 
diff --git a/drivers/staging/bcm/Transmit.c b/drivers/staging/bcm/Transmit.c
index 9a076b5..12f9e13 100644
--- a/drivers/staging/bcm/Transmit.c
+++ b/drivers/staging/bcm/Transmit.c
@@ -282,7 +282,9 @@ INT SetupNextSend(PMINI_ADAPTER Adapter, /**<Logical Adapter*/
 					USHORT Vcid)			/**<VCID for this packet*/
 {
 	int		status=0;
+#ifdef GDMA_INTERFACE
 	int dontfree = 0;
+#endif
 	BOOLEAN bHeaderSupressionEnabled = FALSE;
 	B_UINT16            uiClassifierRuleID;
 	int QueueIndex = NO_OF_QUEUES + 1;
@@ -423,7 +425,7 @@ int tx_pkt_handler(PMINI_ADAPTER Adapter  /**< pointer to adapter object*/
 #endif
 
 	UINT calltransmit = 1;
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Entring to wait for signal from the interrupt service thread!Adapter = 0x%x",(unsigned int) Adapter);
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "Entring to wait for signal from the interrupt service thread!Adapter = %p",Adapter);
 
 
 	while(1)
-- 
1.7.1

