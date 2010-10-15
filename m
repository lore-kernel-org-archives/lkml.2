Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0JOJOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:14:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38403 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab0JOJOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:14:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PspqbY7ycp8cjF7mWbopud3PC3X6VTsbT1SaK6SLwuMSSkrHdb6r/YLbf40VjIjULi
         Bt3jfbrmbUhoDCrDITkNLrbaESX+z5LyoEBDgR7a1Ssy3caJC9fNwcFdgVw8R9/vdV8L
         ExXXBjr9qOcTVzdqLsY0vGK19ipSvd1QaGhlM=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] staging:ft1000: Remove unused function ft1000_hbchk()
Date: Fri, 15 Oct 2010 10:51:22 +0200
Message-Id: <1287132682-18567-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |  148 +------------------------
 1 files changed, 1 insertions(+), 147 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 3e1a6bf..915c95c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -37,11 +37,9 @@
 
 static int ft1000_reset(struct net_device *ft1000dev);
 static int ft1000_submit_rx_urb(PFT1000_INFO info);
-static void ft1000_hbchk(u_long data);
 static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int ft1000_open (struct net_device *dev);
 static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev);
-static struct timer_list poll_timer[MAX_NUM_CARDS];
 static int ft1000_chkcard (struct ft1000_device *dev);
 /*
 static const struct net_device_ops ft1000net_ops = {
@@ -801,9 +799,6 @@ static int ft1000_reset_card (struct net_device *dev)
     info->fProvComplete = 0;
     //ft1000_disable_interrupts(dev);
 
-    // Cancel heartbeat task since we are reloading the dsp
-    //del_timer(&poll_timer[info->CardNumber]);
-
     // Make sure we free any memory reserve for provisioning
     while (list_empty(&info->prov_list) == 0) {
         DEBUG("ft1000_hw:ft1000_reset_card:deleting provisioning record\n");
@@ -906,10 +901,6 @@ static int ft1000_reset_card (struct net_device *dev)
 
     info->CardReady = 1;
     //ft1000_enable_interrupts(dev);
-    /* Schedule heartbeat process to run every 2 seconds */
-    //poll_timer[info->CardNumber].expires = jiffies + (2*HZ);
-    //poll_timer[info->CardNumber].data = (u_long)dev;
-    //add_timer(&poll_timer[info->CardNumber]);
 
     info->fCondResetPend = 0;
     return TRUE;
@@ -1116,7 +1107,7 @@ int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *int
 {
     struct net_device *netdev;
     FT1000_INFO *pInfo;
-    int i, rc;
+	int rc;
 
     netdev = ft1000dev->net;
     pInfo = netdev_priv(ft1000dev->net);
@@ -1142,10 +1133,6 @@ int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *int
 
     //INIT_LIST_HEAD(&pInfo->prov_list);
 
-    for (i=0; i<MAX_NUM_CARDS; i++) {
-        poll_timer[i].function = ft1000_hbchk;
-    }
-
 
     //hard code MAC address for now
 /**
@@ -1918,140 +1905,7 @@ static int ft1000_chkcard (struct ft1000_device *dev) {
     return TRUE;
 }
 
-//---------------------------------------------------------------------------
-//
-// Function:   ft1000_hbchk
-// Descripton: This function will perform the heart beat check of the DSP as
-//             well as the ASIC.
-// Input:
-//     dev    - device structure
-// Output:
-//     none
-//
-//---------------------------------------------------------------------------
-static void ft1000_hbchk(u_long data)
-{
-    struct ft1000_device *dev = (struct ft1000_device *)data;
-
-    FT1000_INFO *info;
-    USHORT tempword;
-        u16 status;
-	info = (FT1000_INFO *) netdev_priv (dev->net);
-
-    DEBUG("ft1000_hbchk called for CardNumber = %d CardReady = %d\n", info->CardNumber, info->CardReady);
-
-    if (info->fCondResetPend == 1) {
-        // Reset ASIC and DSP
-        status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER0, (PUCHAR)&(info->DSP_TIME[0]), FT1000_MAG_DSP_TIMER0_INDX);
-        status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER1, (PUCHAR)&(info->DSP_TIME[1]), FT1000_MAG_DSP_TIMER1_INDX);
-        status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER2, (PUCHAR)&(info->DSP_TIME[2]), FT1000_MAG_DSP_TIMER2_INDX);
-        status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER3, (PUCHAR)&(info->DSP_TIME[3]), FT1000_MAG_DSP_TIMER3_INDX);
-
-        info->DrvErrNum = DSP_CONDRESET_INFO;
-        DEBUG("ft1000_hw:DSP conditional reset requested\n");
-        ft1000_reset_card(dev->net);
-        info->fCondResetPend = 0;
-        /* Schedule this module to run every 2 seconds */
-
-        poll_timer[info->CardNumber].expires = jiffies + (2*HZ);
-        poll_timer[info->CardNumber].data = (u_long)dev;
-        add_timer(&poll_timer[info->CardNumber]);
-
-
 
-        return;
-    }
-
-    if (info->CardReady == 1) {
-        // Perform dsp heartbeat check
-            status = ntohs(ft1000_read_dpram16(dev, FT1000_MAG_HI_HO, (PUCHAR)&tempword, FT1000_MAG_HI_HO_INDX));
-        DEBUG("ft1000_hw:ft1000_hbchk:hi_ho value = 0x%x\n", tempword);
-        // Let's perform another check if ho is not detected
-        if (tempword != ho) {
-              status  = ntohs(ft1000_read_dpram16(dev, FT1000_MAG_HI_HO, (PUCHAR)&tempword,FT1000_MAG_HI_HO_INDX));
-        }
-        if (tempword != ho) {
-            printk(KERN_INFO "ft1000: heartbeat failed - no ho detected\n");
-                status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER0, (PUCHAR)&(info->DSP_TIME[0]), FT1000_MAG_DSP_TIMER0_INDX);
-                status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER1, (PUCHAR)&(info->DSP_TIME[1]), FT1000_MAG_DSP_TIMER1_INDX);
-                status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER2, (PUCHAR)&(info->DSP_TIME[2]), FT1000_MAG_DSP_TIMER2_INDX);
-                status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER3, (PUCHAR)&(info->DSP_TIME[3]), FT1000_MAG_DSP_TIMER3_INDX);
-            info->DrvErrNum = DSP_HB_INFO;
-            if (ft1000_reset_card(dev->net) == 0) {
-               printk(KERN_INFO "ft1000: Hardware Failure Detected - PC Card disabled\n");
-               info->ProgConStat = 0xff;
-               return;
-            }
-            /* Schedule this module to run every 2 seconds */
-            poll_timer[info->CardNumber].expires = jiffies + (2*HZ);
-            poll_timer[info->CardNumber].data = (u_long)dev;
-            add_timer(&poll_timer[info->CardNumber]);
-            return;
-        }
-
-        status = ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
-        // Let's check doorbell again if fail
-        if (tempword & FT1000_DB_HB) {
-                status = ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
-        }
-        if (tempword & FT1000_DB_HB) {
-            printk(KERN_INFO "ft1000: heartbeat doorbell not clear by firmware\n");
-            status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER0, (PUCHAR)&(info->DSP_TIME[0]), FT1000_MAG_DSP_TIMER0_INDX);
-            status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER1, (PUCHAR)&(info->DSP_TIME[1]), FT1000_MAG_DSP_TIMER1_INDX);
-            status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER2, (PUCHAR)&(info->DSP_TIME[2]), FT1000_MAG_DSP_TIMER2_INDX);
-            status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER3, (PUCHAR)&(info->DSP_TIME[3]), FT1000_MAG_DSP_TIMER3_INDX);
-            info->DrvErrNum = DSP_HB_INFO;
-            if (ft1000_reset_card(dev->net) == 0) {
-               printk(KERN_INFO "ft1000: Hardware Failure Detected - PC Card disabled\n");
-               info->ProgConStat = 0xff;
-               return;
-            }
-            /* Schedule this module to run every 2 seconds */
-            poll_timer[info->CardNumber].expires = jiffies + (2*HZ);
-            poll_timer[info->CardNumber].data = (u_long)dev;
-            add_timer(&poll_timer[info->CardNumber]);
-            return;
-        }
-
-        // Set dedicated area to hi and ring appropriate doorbell according
-        // to hi/ho heartbeat protocol
-        ft1000_write_dpram16(dev, FT1000_MAG_HI_HO, hi_mag, FT1000_MAG_HI_HO_INDX);
-
-        status = ntohs(ft1000_read_dpram16(dev, FT1000_MAG_HI_HO, (PUCHAR)&tempword, FT1000_MAG_HI_HO_INDX));
-        // Let's write hi again if fail
-        if (tempword != hi) {
-               ft1000_write_dpram16(dev, FT1000_MAG_HI_HO, hi_mag, FT1000_MAG_HI_HO_INDX);
-                   status = ntohs(ft1000_read_dpram16(dev, FT1000_MAG_HI_HO, (PUCHAR)&tempword, FT1000_MAG_HI_HO_INDX));
-
-        }
-        if (tempword != hi) {
-            printk(KERN_INFO "ft1000: heartbeat failed - cannot write hi into DPRAM\n");
-            status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER0, (PUCHAR)&(info->DSP_TIME[0]), FT1000_MAG_DSP_TIMER0_INDX);
-            status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER1, (PUCHAR)&(info->DSP_TIME[1]), FT1000_MAG_DSP_TIMER1_INDX);
-            status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER2, (PUCHAR)&(info->DSP_TIME[2]), FT1000_MAG_DSP_TIMER2_INDX);
-            status = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER3, (PUCHAR)&(info->DSP_TIME[3]), FT1000_MAG_DSP_TIMER3_INDX);
-
-            info->DrvErrNum = DSP_HB_INFO;
-            if (ft1000_reset_card(dev->net) == 0) {
-               printk(KERN_INFO "ft1000: Hardware Failure Detected - PC Card disabled\n");
-               info->ProgConStat = 0xff;
-               return;
-            }
-            /* Schedule this module to run every 2 seconds */
-            poll_timer[info->CardNumber].expires = jiffies + (2*HZ);
-            poll_timer[info->CardNumber].data = (u_long)dev;
-            add_timer(&poll_timer[info->CardNumber]);
-            return;
-        }
-        ft1000_write_register(dev, FT1000_DB_HB, FT1000_REG_DOORBELL);
-
-    }
-
-    /* Schedule this module to run every 2 seconds */
-    poll_timer[info->CardNumber].expires = jiffies + (2*HZ);
-    poll_timer[info->CardNumber].data = (u_long)dev;
-    add_timer(&poll_timer[info->CardNumber]);
-}
 
 //---------------------------------------------------------------------------
 //
-- 
1.7.1

