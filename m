Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab1FVSmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:42:43 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:58014 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758709Ab1FVSmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:42:39 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [15/15] staging: ft1000-pcmcia: remove unused fields from struct ft1000_info
Date: Wed, 22 Jun 2011 20:42:31 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106222042.34030.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 13 unused fields from struct ft1000_info.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -324,25 +324,13 @@ struct ft1000_info {
     struct net_device_stats stats;
     u16 DrvErrNum;
     u16 AsicID;
-    int ASICResetNum;
-    int DspAsicReset;
     int PktIntfErr;
-    int DSPResetNum;
-    int NumIOCTLBufs;
-    int IOCTLBufLvl;
-    int DeviceCreated;
     int CardReady;
-    int DspHibernateFlag;
-    int DSPReady;
-    u8 DeviceName[15];
-    int DeviceMajor;
     int registered;
     int mediastate;
     u16 packetseqnum;
     u8 squeseqnum;                 // sequence number on slow queue
     spinlock_t dpram_lock;
-    u16 CurrentInterruptEnableMask;
-    int InterruptsEnabled;
     u16 fifo_cnt;
     u8 DspVer[DSPVERSZ];        // DSP version number
     u8 HwSerNum[HWSERNUMSZ];    // Hardware Serial Number
@@ -358,7 +346,6 @@ struct ft1000_info {
     u16 DSP_TIME[4];
     struct list_head prov_list;
     u16 DSPInfoBlklen;
-    u16 DrvMsgPend;
 	int (*ft1000_reset)(void *);
     void *link;
     u16 DSPInfoBlk[MAX_DSP_SESS_REC];
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -323,17 +323,14 @@ void ft1000_write_dpram_mag_32(struct net_device *dev, 
int offset, u32 value)
 //---------------------------------------------------------------------------
 static void ft1000_enable_interrupts(struct net_device *dev)
 {
-	struct ft1000_info *info = netdev_priv(dev);
 	u16 tempword;
 
 	DEBUG(1, "ft1000_hw:ft1000_enable_interrupts()\n");
-	ft1000_write_reg(dev, FT1000_REG_SUP_IMASK,
-			 info->CurrentInterruptEnableMask);
+	ft1000_write_reg(dev, FT1000_REG_SUP_IMASK, ISR_DEFAULT_MASK);
 	tempword = ft1000_read_reg(dev, FT1000_REG_SUP_IMASK);
 	DEBUG(1,
 		  "ft1000_hw:ft1000_enable_interrupts:current interrupt enable mask = 
0x%x\n",
 		  tempword);
-	info->InterruptsEnabled = TRUE;
 }
 
 //---------------------------------------------------------------------------
@@ -348,7 +345,6 @@ static void ft1000_enable_interrupts(struct net_device 
*dev)
 //---------------------------------------------------------------------------
 static void ft1000_disable_interrupts(struct net_device *dev)
 {
-	struct ft1000_info *info = netdev_priv(dev);
 	u16 tempword;
 
 	DEBUG(1, "ft1000_hw: ft1000_disable_interrupts()\n");
@@ -357,7 +353,6 @@ static void ft1000_disable_interrupts(struct net_device 
*dev)
 	DEBUG(1,
 		  "ft1000_hw:ft1000_disable_interrupts:current interrupt enable mask = 
0x%x\n",
 		  tempword);
-	info->InterruptsEnabled = FALSE;
 }
 
 //---------------------------------------------------------------------------
@@ -379,7 +374,6 @@ static void ft1000_reset_asic(struct net_device *dev)
 	DEBUG(1, "ft1000_hw:ft1000_reset_asic called\n");
 
 	(*info->ft1000_reset) (info->link);
-	info->ASICResetNum++;
 
 	// Let's use the register provided by the Magnemite ASIC to reset the
 	// ASIC and DSP.
@@ -456,14 +450,12 @@ static int ft1000_reset_card(struct net_device *dev)
 	if (ft1000_card_present == 1) {
 		spin_lock_irqsave(&info->dpram_lock, flags);
 		if (info->AsicID == ELECTRABUZZ_ID) {
-			if (info->DspHibernateFlag == 0) {
-				ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
-						 FT1000_DPRAM_RX_BASE);
-				for (i = 0; i < MAX_DSP_SESS_REC; i++) {
-					info->DSPSess.Rec[i] =
-						ft1000_read_reg(dev,
-								FT1000_REG_DPRAM_DATA);
-				}
+			ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
+					 FT1000_DPRAM_RX_BASE);
+			for (i = 0; i < MAX_DSP_SESS_REC; i++) {
+				info->DSPSess.Rec[i] =
+					ft1000_read_reg(dev,
+							FT1000_REG_DPRAM_DATA);
 			}
 		} else {
 			ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
@@ -481,8 +473,6 @@ static int ft1000_reset_card(struct net_device *dev)
 	//reset ASIC
 	ft1000_reset_asic(dev);
 
-	info->DSPResetNum++;
-
 	DEBUG(1, "ft1000_hw:ft1000_reset_card:downloading dsp image\n");
 
 	if (info->AsicID == MAGNEMITE_ID) {
@@ -1168,7 +1158,6 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 		case DSP_GET_INFO:
 			DEBUG(1, "FT1000:drivermsg:Got DSP_GET_INFO\n");
 			// copy dsp info block to dsp
-			info->DrvMsgPend = 1;
 			// allow any outstanding ioctl to finish
 			mdelay(10);
 			tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
@@ -1211,13 +1200,11 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 					htons(info->DSPInfoBlklen);
 				ft1000_send_cmd (dev, (PUSHORT)info->DSPInfoBlk, (USHORT)
(info->DSPInfoBlklen+4), 0);
 			}
-			info->DrvMsgPend = 0;
 
 			break;
 		case GET_DRV_ERR_RPT_MSG:
 			DEBUG(1, "FT1000:drivermsg:Got GET_DRV_ERR_RPT_MSG\n");
 			// copy driver error message to dsp
-			info->DrvMsgPend = 1;
 			// allow any outstanding ioctl to finish
 			mdelay(10);
 			tempword = ft1000_read_reg(dev, FT1000_REG_DOORBELL);
@@ -1272,7 +1259,6 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 				ft1000_send_cmd (dev, (PUSHORT)&tempbuffer[0], (USHORT)(0x0012), 0);
 				info->DrvErrNum = 0;
 			}
-			info->DrvMsgPend = 0;
 
 			break;
 		default:
@@ -1339,13 +1325,11 @@ int ft1000_parse_dpram_msg(struct net_device *dev)
 			ft1000_write_reg(dev, FT1000_REG_SUP_CTRL,
 					 HOST_INTF_BE);
 		}
-		info->DspAsicReset = 0;
 	}
 
 	if (doorbell & FT1000_DSP_ASIC_RESET) {
 		DEBUG(0,
 			  "FT1000:ft1000_parse_dpram_msg: Got a dsp ASIC reset message\n");
-		info->DspAsicReset = 1;
 		ft1000_write_reg(dev, FT1000_REG_DOORBELL,
 				 FT1000_DSP_ASIC_RESET);
 		udelay(200);
@@ -2198,16 +2182,11 @@ struct net_device *init_ft1000_card(struct 
pcmcia_device *link,
 
 	spin_lock_init(&info->dpram_lock);
 	info->DrvErrNum = 0;
-	info->ASICResetNum = 0;
 	info->registered = 1;
 	info->link = link;
 	info->ft1000_reset = ft1000_reset;
 	info->mediastate = 0;
 	info->fifo_cnt = 0;
-	info->DeviceCreated = FALSE;
-	info->DeviceMajor = 0;
-	info->CurrentInterruptEnableMask = ISR_DEFAULT_MASK;
-	info->InterruptsEnabled = FALSE;
 	info->CardReady = 0;
 	info->DSP_TIME[0] = 0;
 	info->DSP_TIME[1] = 0;
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
@@ -75,16 +75,14 @@ int ft1000ReadProc(char *page, char **start, off_t off,
 	/* Wrap-around */
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
-		if (info->DspHibernateFlag == 0) {
-			if (info->ProgConStat != 0xFF) {
-				info->LedStat =
-					ft1000_read_dpram(dev, FT1000_DSP_LED);
-				info->ConStat =
-					ft1000_read_dpram(dev,
-							  FT1000_DSP_CON_STATE);
-			} else {
-				info->ConStat = 0xf;
-			}
+		if (info->ProgConStat != 0xFF) {
+			info->LedStat =
+				ft1000_read_dpram(dev, FT1000_DSP_LED);
+			info->ConStat =
+				ft1000_read_dpram(dev,
+						  FT1000_DSP_CON_STATE);
+		} else {
+			info->ConStat = 0xf;
 		}
 	} else {
 		if (info->ProgConStat != 0xFF) {

-- 
Ondrej Zary
