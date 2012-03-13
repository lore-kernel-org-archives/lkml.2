Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab2CMAs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:48:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:48210 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758839Ab2CMAXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 117/196] Staging: rtl8192su: check for skb == NULL
Date: Mon, 12 Mar 2012 20:20:30 -0400
Message-Id: <1331598109-31424-72-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Schilhabel <florian.c.schilhabel@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 199ef62a287b429a8fa3b7dc5ae6b69f607bf324 upstream.

added 2 checks for skb == NULL.
plus cosmetics

Signed-off-by: Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/rtl8192su/r8192S_firmware.c |  135 ++++++++++++---------------
 drivers/staging/rtl8192su/r8192U_core.c     |    2 -
 drivers/staging/rtl8192su/r819xU_cmdpkt.c   |    6 ++
 3 files changed, 68 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/rtl8192su/r8192S_firmware.c b/drivers/staging/rtl8192su/r8192S_firmware.c
index 752a3f1..f7dd7e7 100644
--- a/drivers/staging/rtl8192su/r8192S_firmware.c
+++ b/drivers/staging/rtl8192su/r8192S_firmware.c
@@ -31,44 +31,46 @@
 //			   Code size
 // Created by Roger, 2008.04.10.
 //
-bool FirmwareDownloadCode(struct net_device *dev, u8 *	code_virtual_address,u32 buffer_len)
+bool FirmwareDownloadCode(struct net_device *dev,
+				u8 *code_virtual_address,
+				u32 buffer_len)
 {
-	struct r8192_priv   *priv = ieee80211_priv(dev);
-	bool 		    rt_status = true;
-	u16		    frag_threshold = MAX_FIRMWARE_CODE_SIZE; //Fragmentation might be required in 90/92 but not in 92S
-	u16		    frag_length, frag_offset = 0;
-	struct sk_buff	    *skb;
-	unsigned char	    *seg_ptr;
-	cb_desc		    *tcb_desc;
-	u8                  	    bLastIniPkt = 0;
-	u16 			    ExtraDescOffset = 0;
-
-
-	RT_TRACE(COMP_FIRMWARE, "--->FirmwareDownloadCode()\n" );
-
-	//MAX_TRANSMIT_BUFFER_SIZE
-	if(buffer_len >= MAX_FIRMWARE_CODE_SIZE-USB_HWDESC_HEADER_LEN)
-	{
-		RT_TRACE(COMP_ERR, "Size over MAX_FIRMWARE_CODE_SIZE! \n");
+	struct r8192_priv *priv = ieee80211_priv(dev);
+	bool rt_status = true;
+	/* Fragmentation might be required in 90/92 but not in 92S */
+	u16 frag_threshold = MAX_FIRMWARE_CODE_SIZE;
+	u16 frag_length, frag_offset = 0;
+	struct sk_buff *skb;
+	unsigned char *seg_ptr;
+	cb_desc *tcb_desc;
+	u8 bLastIniPkt = 0;
+	u16 ExtraDescOffset = 0;
+
+	if (buffer_len >= MAX_FIRMWARE_CODE_SIZE - USB_HWDESC_HEADER_LEN) {
+		RT_TRACE(COMP_ERR, "(%s): Firmware exceeds"
+					" MAX_FIRMWARE_CODE_SIZE\n", __func__);
 		goto cmdsend_downloadcode_fail;
 	}
-
 	ExtraDescOffset = USB_HWDESC_HEADER_LEN;
-
 	do {
 		if((buffer_len-frag_offset) > frag_threshold)
-		{
 			frag_length = frag_threshold + ExtraDescOffset;
+		else {
+			frag_length = (u16)(buffer_len -
+						frag_offset + ExtraDescOffset);
+			bLastIniPkt = 1;
 		}
-		else
-		{
-			frag_length = (u16)(buffer_len - frag_offset + ExtraDescOffset);
-		bLastIniPkt = 1;
-		}
-
-		/* Allocate skb buffer to contain firmware info and tx descriptor info. */
+		/*
+		 * Allocate skb buffer to contain firmware info
+		 * and tx descriptor info.
+		 */
 		skb  = dev_alloc_skb(frag_length);
-		memcpy((unsigned char *)(skb->cb),&dev,sizeof(dev));
+		if (skb == NULL) {
+			RT_TRACE(COMP_ERR, "(%s): unable to alloc skb buffer\n",
+								__func__);
+			goto cmdsend_downloadcode_fail;
+		}
+		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 
 		tcb_desc = (cb_desc*)(skb->cb + MAX_DEV_ADDR_SIZE);
 		tcb_desc->queue_index = TXCMD_QUEUE;
@@ -76,73 +78,60 @@ bool FirmwareDownloadCode(struct net_device *dev, u8 *	code_virtual_address,u32
 		tcb_desc->bLastIniPkt = bLastIniPkt;
 
 		skb_reserve(skb, ExtraDescOffset);
-		seg_ptr = (u8 *)skb_put(skb, (u32)(frag_length-ExtraDescOffset));
-		memcpy(seg_ptr, code_virtual_address+frag_offset, (u32)(frag_length-ExtraDescOffset));
 
-		tcb_desc->txbuf_size= frag_length;
+		seg_ptr = (u8 *)skb_put(skb,
+					(u32)(frag_length - ExtraDescOffset));
 
-		if(!priv->ieee80211->check_nic_enough_desc(dev,tcb_desc->queue_index)||
-			(!skb_queue_empty(&priv->ieee80211->skb_waitQ[tcb_desc->queue_index]))||\
-			(priv->ieee80211->queue_stop) )
-		{
+		memcpy(seg_ptr, code_virtual_address + frag_offset,
+					(u32)(frag_length-ExtraDescOffset));
+
+		tcb_desc->txbuf_size = frag_length;
+
+		if (!priv->ieee80211->check_nic_enough_desc(dev, tcb_desc->queue_index) ||
+			(!skb_queue_empty(&priv->ieee80211->skb_waitQ[tcb_desc->queue_index])) ||
+			(priv->ieee80211->queue_stop)) {
 			RT_TRACE(COMP_FIRMWARE,"=====================================================> tx full!\n");
 			skb_queue_tail(&priv->ieee80211->skb_waitQ[tcb_desc->queue_index], skb);
-		}
-		else
-		{
-			priv->ieee80211->softmac_hard_start_xmit(skb,dev);
-		}
+		} else
+			priv->ieee80211->softmac_hard_start_xmit(skb, dev);
 
 		frag_offset += (frag_length - ExtraDescOffset);
 
-	}while(frag_offset < buffer_len);
-
+	} while (frag_offset < buffer_len);
 	return rt_status ;
 
-
 cmdsend_downloadcode_fail:
 	rt_status = false;
-	RT_TRACE(COMP_ERR, "CmdSendDownloadCode fail !!\n");
+	RT_TRACE(COMP_ERR, "(%s): failed\n", __func__);
 	return rt_status;
-
 }
 
 
-RT_STATUS
-FirmwareEnableCPU(struct net_device *dev)
+RT_STATUS FirmwareEnableCPU(struct net_device *dev)
 {
+	RT_STATUS rtStatus = RT_STATUS_SUCCESS;
+	u8 tmpU1b, CPUStatus = 0;
+	u16 tmpU2b;
+	u32 iCheckTime = 200;
 
-	RT_STATUS	rtStatus = RT_STATUS_SUCCESS;
-	u8		tmpU1b, CPUStatus = 0;
-	u16		tmpU2b;
-	u32		iCheckTime = 200;
-
-	RT_TRACE(COMP_FIRMWARE, "-->FirmwareEnableCPU()\n" );
-	// Enable CPU.
+	/* Enable CPU. */
 	tmpU1b = read_nic_byte(dev, SYS_CLKR);
-	write_nic_byte(dev,  SYS_CLKR, (tmpU1b|SYS_CPU_CLKSEL)); //AFE source
-
+	/* AFE source */
+	write_nic_byte(dev,  SYS_CLKR, (tmpU1b|SYS_CPU_CLKSEL));
 	tmpU2b = read_nic_word(dev, SYS_FUNC_EN);
 	write_nic_word(dev, SYS_FUNC_EN, (tmpU2b|FEN_CPUEN));
-
-	//Polling IMEM Ready after CPU has refilled.
-	do
-	{
+	/* Poll IMEM Ready after CPU has refilled. */
+	do {
 		CPUStatus = read_nic_byte(dev, TCR);
-		if(CPUStatus& IMEM_RDY)
-		{
-			RT_TRACE(COMP_FIRMWARE, "IMEM Ready after CPU has refilled.\n");
+		if (CPUStatus & IMEM_RDY)
+			/* success */
 			break;
-		}
-
-		//usleep(100);
 		udelay(100);
-	}while(iCheckTime--);
-
-	if(!(CPUStatus & IMEM_RDY))
-		return RT_STATUS_FAILURE;
-
-	RT_TRACE(COMP_FIRMWARE, "<--FirmwareEnableCPU(): rtStatus(%#x)\n", rtStatus);
+	} while (iCheckTime--);
+	if (!(CPUStatus & IMEM_RDY)) {
+		RT_TRACE(COMP_ERR, "(%s): failed to enable CPU\n", __func__);
+		rtStatus = RT_STATUS_FAILURE;
+	}
 	return rtStatus;
 }
 
diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index 04d9b85..04f8516 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -1278,7 +1278,6 @@ static int rtl8192_rx_initiate(struct net_device*dev)
                         kfree_skb(skb);
                         break;
                 }
-//		printk("nomal packet IN request!\n");
                 usb_fill_bulk_urb(entry, priv->udev,
                                   usb_rcvbulkpipe(priv->udev, 3), skb_tail_pointer(skb),
                                   RX_URB_SIZE, rtl8192_rx_isr, skb);
@@ -1292,7 +1291,6 @@ static int rtl8192_rx_initiate(struct net_device*dev)
 
 	/* command packet rx procedure */
         while (skb_queue_len(&priv->rx_queue) < MAX_RX_URB + 3) {
-//		printk("command packet IN request!\n");
                 skb = __dev_alloc_skb(RX_URB_SIZE ,GFP_KERNEL);
                 if (!skb)
                         break;
diff --git a/drivers/staging/rtl8192su/r819xU_cmdpkt.c b/drivers/staging/rtl8192su/r819xU_cmdpkt.c
index 3ebfe79..e69c3b4 100644
--- a/drivers/staging/rtl8192su/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192su/r819xU_cmdpkt.c
@@ -56,6 +56,12 @@ SendTxCommandPacket(
 
 	//Get TCB and local buffer from common pool. (It is shared by CmdQ, MgntQ, and USB coalesce DataQ)
 	skb  = dev_alloc_skb(USB_HWDESC_HEADER_LEN + DataLen + 4);
+	if (skb == NULL) {
+		RT_TRACE(COMP_ERR, "(%s): unable to alloc skb buffer\n",
+								__func__);
+		rtStatus = false;
+		return rtStatus;
+	}
 	memcpy((unsigned char *)(skb->cb),&dev,sizeof(dev));
 	tcb_desc = (cb_desc*)(skb->cb + MAX_DEV_ADDR_SIZE);
 	tcb_desc->queue_index = TXCMD_QUEUE;
-- 
1.7.9.3

