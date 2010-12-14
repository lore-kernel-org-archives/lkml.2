Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab0LNBCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:02:17 -0500
Received: from 232.Red-88-26-245.staticIP.rima-tde.net ([88.26.245.232]:41484
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758733Ab0LNBCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:02:16 -0500
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
Subject: [PATCH 1/2][RESEND] Staging: rt2860: include KERN_* in printk
Date: Tue, 14 Dec 2010 02:01:54 +0100
Message-Id: <1292288515-20179-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101213221749.GA22029@kroah.com>
References: <20101213221749.GA22029@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch complains.

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/staging/rt2860/common/ee_efuse.c |   15 ++++++++++---
 drivers/staging/rt2860/pci_main_dev.c    |    2 +-
 drivers/staging/rt2860/rt_linux.c        |   21 +++++++++----------
 drivers/staging/rt2860/rt_main_dev.c     |    2 +-
 drivers/staging/rt2860/rt_usb.c          |   32 +++++++++++++++---------------
 drivers/staging/rt2860/usb_main_dev.c    |   12 +++++-----
 6 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/rt2860/common/ee_efuse.c b/drivers/staging/rt2860/common/ee_efuse.c
index 03412f5..fed0ba4 100644
--- a/drivers/staging/rt2860/common/ee_efuse.c
+++ b/drivers/staging/rt2860/common/ee_efuse.c
@@ -264,7 +264,7 @@ int set_eFuseGetFreeBlockCount_Proc(struct rt_rtmp_adapter *pAd, char *arg)
 		if (i == EFUSE_USAGE_MAP_END)
 			efusefreenum = 0;
 	}
-	printk("efuseFreeNumber is %d\n", efusefreenum);
+	printk(KERN_DEBUG "efuseFreeNumber is %d\n", efusefreenum);
 	return TRUE;
 }
 
@@ -274,16 +274,23 @@ int set_eFusedump_Proc(struct rt_rtmp_adapter *pAd, char *arg)
 	int i = 0;
 	if (!pAd->bUseEfuse)
 		return FALSE;
+
+	printk(KERN_DEBUG "Block 0: ");
+
 	for (i = 0; i < EFUSE_USAGE_MAP_END / 2; i++) {
 		InBuf[0] = 2 * i;
 		InBuf[1] = 2;
 		InBuf[2] = 0x0;
 
 		eFuseReadPhysical(pAd, &InBuf[0], 4, &InBuf[2], 2);
-		if (i % 4 == 0)
-			printk("\nBlock %x:", i / 8);
-		printk("%04x ", InBuf[2]);
+		if (i && i % 4 == 0) {
+			printk(KERN_CONT "\n");
+			printk(KERN_DEBUG "Block %x:", i / 8);
+		}
+		printk(KERN_CONT "%04x ", InBuf[2]);
 	}
+	printk(KERN_CONT "\n");
+
 	return TRUE;
 }
 
diff --git a/drivers/staging/rt2860/pci_main_dev.c b/drivers/staging/rt2860/pci_main_dev.c
index 628559d..1949acd 100644
--- a/drivers/staging/rt2860/pci_main_dev.c
+++ b/drivers/staging/rt2860/pci_main_dev.c
@@ -202,7 +202,7 @@ static int rt2860_resume(struct pci_dev *pci_dev)
 
 	/* initialize device before it's used by a driver */
 	if (pci_enable_device(pci_dev)) {
-		printk("pci enable fail!\n");
+		printk(KERN_ERR "rt2860: pci enable fail!\n");
 		return 0;
 	}
 
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index abfeea1..e95db46 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -321,7 +321,7 @@ int RTMPCloneNdisPacket(struct rt_rtmp_adapter *pAd,
 
 	RTMP_SET_PACKET_SOURCE(OSPKT_TO_RTPKT(pkt), PKTSRC_NDIS);
 
-	printk("###Clone###\n");
+	printk(KERN_DEBUG "###Clone###\n");
 
 	return NDIS_STATUS_SUCCESS;
 }
@@ -343,9 +343,8 @@ int RTMPAllocateNdisPacket(struct rt_rtmp_adapter *pAd,
 					   RTMP_PKT_TAIL_PADDING);
 	if (pPacket == NULL) {
 		*ppPacket = NULL;
-#ifdef DEBUG
-		printk("RTMPAllocateNdisPacket Fail\n");
-#endif
+		pr_devel("RTMPAllocateNdisPacket Fail\n");
+
 		return NDIS_STATUS_FAILURE;
 	}
 	/* 2. clone the frame content */
@@ -601,15 +600,15 @@ void hex_dump(char *str, unsigned char *pSrcBufVA, unsigned int SrcBufLen)
 		return;
 
 	pt = pSrcBufVA;
-	printk("%s: %p, len = %d\n", str, pSrcBufVA, SrcBufLen);
+	printk(KERN_DEBUG "%s: %p, len = %d\n", str, pSrcBufVA, SrcBufLen);
 	for (x = 0; x < SrcBufLen; x++) {
 		if (x % 16 == 0)
-			printk("0x%04x : ", x);
-		printk("%02x ", ((unsigned char)pt[x]));
+			printk(KERN_DEBUG "0x%04x : ", x);
+		printk(KERN_DEBUG "%02x ", ((unsigned char)pt[x]));
 		if (x % 16 == 15)
-			printk("\n");
+			printk(KERN_DEBUG "\n");
 	}
-	printk("\n");
+	printk(KERN_DEBUG "\n");
 }
 
 /*
@@ -926,7 +925,7 @@ int RtmpOSIRQRequest(struct net_device *pNetDev)
 		    request_irq(_pObj->pci_dev->irq, rt2860_interrupt, SA_SHIRQ,
 				(net_dev)->name, (net_dev));
 		if (retval != 0)
-			printk("RT2860: request_irq  ERROR(%d)\n", retval);
+			printk(KERN_ERR "rt2860: request_irq  ERROR(%d)\n", retval);
 	}
 
 	return retval;
@@ -1022,7 +1021,7 @@ int RtmpOSTaskKill(struct rt_rtmp_os_task *pTask)
 	}
 #else
 	CHECK_PID_LEGALITY(pTask->taskPID) {
-		printk("Terminate the task(%s) with pid(%d)!\n",
+		printk(KERN_INFO "Terminate the task(%s) with pid(%d)!\n",
 		       pTask->taskName, GET_PID_NUMBER(pTask->taskPID));
 		mb();
 		pTask->task_killed = 1;
diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index ad60cea..8f0ff94 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -420,7 +420,7 @@ int rt28xx_open(struct net_device *dev)
 	{
 		u32 reg = 0;
 		RTMP_IO_READ32(pAd, 0x1300, &reg);	/* clear garbage interrupts */
-		printk("0x1300 = %08x\n", reg);
+		printk(KERN_DEBUG "0x1300 = %08x\n", reg);
 	}
 
 	{
diff --git a/drivers/staging/rt2860/rt_usb.c b/drivers/staging/rt2860/rt_usb.c
index bcfc0f5..f879a75 100644
--- a/drivers/staging/rt2860/rt_usb.c
+++ b/drivers/staging/rt2860/rt_usb.c
@@ -40,25 +40,25 @@
 
 void dump_urb(struct urb *purb)
 {
-	printk("urb                  :0x%08lx\n", (unsigned long)purb);
-	printk("\tdev                   :0x%08lx\n", (unsigned long)purb->dev);
-	printk("\t\tdev->state          :0x%d\n", purb->dev->state);
-	printk("\tpipe                  :0x%08x\n", purb->pipe);
-	printk("\tstatus                :%d\n", purb->status);
-	printk("\ttransfer_flags        :0x%08x\n", purb->transfer_flags);
-	printk("\ttransfer_buffer       :0x%08lx\n",
+	printk(KERN_DEBUG "urb                  :0x%08lx\n", (unsigned long)purb);
+	printk(KERN_DEBUG "\tdev                   :0x%08lx\n", (unsigned long)purb->dev);
+	printk(KERN_DEBUG "\t\tdev->state          :0x%d\n", purb->dev->state);
+	printk(KERN_DEBUG "\tpipe                  :0x%08x\n", purb->pipe);
+	printk(KERN_DEBUG "\tstatus                :%d\n", purb->status);
+	printk(KERN_DEBUG "\ttransfer_flags        :0x%08x\n", purb->transfer_flags);
+	printk(KERN_DEBUG "\ttransfer_buffer       :0x%08lx\n",
 	       (unsigned long)purb->transfer_buffer);
-	printk("\ttransfer_buffer_length:%d\n", purb->transfer_buffer_length);
-	printk("\tactual_length         :%d\n", purb->actual_length);
-	printk("\tsetup_packet          :0x%08lx\n",
+	printk(KERN_DEBUG "\ttransfer_buffer_length:%d\n", purb->transfer_buffer_length);
+	printk(KERN_DEBUG "\tactual_length         :%d\n", purb->actual_length);
+	printk(KERN_DEBUG "\tsetup_packet          :0x%08lx\n",
 	       (unsigned long)purb->setup_packet);
-	printk("\tstart_frame           :%d\n", purb->start_frame);
-	printk("\tnumber_of_packets     :%d\n", purb->number_of_packets);
-	printk("\tinterval              :%d\n", purb->interval);
-	printk("\terror_count           :%d\n", purb->error_count);
-	printk("\tcontext               :0x%08lx\n",
+	printk(KERN_DEBUG "\tstart_frame           :%d\n", purb->start_frame);
+	printk(KERN_DEBUG "\tnumber_of_packets     :%d\n", purb->number_of_packets);
+	printk(KERN_DEBUG "\tinterval              :%d\n", purb->interval);
+	printk(KERN_DEBUG "\terror_count           :%d\n", purb->error_count);
+	printk(KERN_DEBUG "\tcontext               :0x%08lx\n",
 	       (unsigned long)purb->context);
-	printk("\tcomplete              :0x%08lx\n\n",
+	printk(KERN_DEBUG "\tcomplete              :0x%08lx\n\n",
 	       (unsigned long)purb->complete);
 }
 
diff --git a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/usb_main_dev.c
index cd15daa..1803267 100644
--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -233,7 +233,7 @@ BOOLEAN RT28XXChipsetCheck(IN void *_dev_p)
 	for (i = 0; i < rtusb_usb_id_len; i++) {
 		if (dev_p->descriptor.idVendor == rtusb_usb_id[i].idVendor &&
 		    dev_p->descriptor.idProduct == rtusb_usb_id[i].idProduct) {
-			printk("rt2870: idVendor = 0x%x, idProduct = 0x%x\n",
+			printk(KERN_INFO "rt2870: idVendor = 0x%x, idProduct = 0x%x\n",
 			       dev_p->descriptor.idVendor,
 			       dev_p->descriptor.idProduct);
 			break;
@@ -241,7 +241,7 @@ BOOLEAN RT28XXChipsetCheck(IN void *_dev_p)
 	}
 
 	if (i == rtusb_usb_id_len) {
-		printk("rt2870: Error! Device Descriptor not matching!\n");
+		printk(KERN_ERR "rt2870: Error! Device Descriptor not matching!\n");
 		return FALSE;
 	}
 
@@ -323,7 +323,7 @@ static BOOLEAN USBDevConfigInit(IN struct usb_device *dev,
 
 	if (!(pAd->BulkInEpAddr && pAd->BulkOutEpAddr[0])) {
 		printk
-		    ("%s: Could not find both bulk-in and bulk-out endpoints\n",
+		    (KERN_ERR "%s: Could not find both bulk-in and bulk-out endpoints\n",
 		     __FUNCTION__);
 		return FALSE;
 	}
@@ -423,7 +423,7 @@ static int rt2870_resume(struct usb_interface *intf)
 /* Init driver module */
 int __init rtusb_init(void)
 {
-	printk("rtusb init --->\n");
+	printk(KERN_DEBUG "rtusb init --->\n");
 	return usb_register(&rtusb_driver);
 }
 
@@ -431,7 +431,7 @@ int __init rtusb_init(void)
 void __exit rtusb_exit(void)
 {
 	usb_deregister(&rtusb_driver);
-	printk("<--- rtusb exit\n");
+	printk(KERN_DEBUG "<--- rtusb exit\n");
 }
 
 module_init(rtusb_init);
@@ -814,7 +814,7 @@ static void rt2870_disconnect(struct usb_device *dev, struct rt_rtmp_adapter *pA
 		  dev->bus->bus_name, dev->devpath));
 	if (!pAd) {
 		usb_put_dev(dev);
-		printk("rtusb_disconnect: pAd == NULL!\n");
+		printk(KERN_ERR "rtusb_disconnect: pAd == NULL!\n");
 		return;
 	}
 	RTMP_SET_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST);
-- 
1.7.2.3

