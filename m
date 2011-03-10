Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1CJKwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:52:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52950 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1CJKwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:52:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=NAjYl/FloQZVTYZbnh2/rao2w/774+ZEA4pNf6oyll+Zf7h7GENKo5HK0Iqb2TWz9I
         7XY5pKWKazKp8iDnHMrCmJJTX42BnsoR9l2oQIpLDlD72FzJIRLd3OO+6GlqNNC0WiT3
         OMWTKEHbgRurbEBlNYcwdo2F+Zkks1RJCmuBg=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 20/21] staging: ft1000: Fix coding style in ft1000_dsp_prov function.
Date: Thu, 10 Mar 2011 11:51:34 +0100
Message-Id: <1299754295-8493-21-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |  161 +++++++++++++------------
 1 files changed, 83 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index f1b4ce1..0187758 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1439,92 +1439,97 @@ static bool ft1000_receive_cmd(struct ft1000_device *dev, u16 *pbuffer,
 	}
 }
 
-
 static int ft1000_dsp_prov(void *arg)
 {
-    struct ft1000_device *dev = (struct ft1000_device *)arg;
+	struct ft1000_device *dev = (struct ft1000_device *)arg;
 	struct ft1000_info *info = netdev_priv(dev->net);
-    u16 tempword;
-    u16 len;
-    u16 i=0;
+	u16 tempword;
+	u16 len;
+	u16 i = 0;
 	struct prov_record *ptr;
 	struct pseudo_hdr *ppseudo_hdr;
-    u16 *pmsg;
-    u16 status;
-    u16 TempShortBuf [256];
+	u16 *pmsg;
+	u16 status;
+	u16 TempShortBuf[256];
 
-    DEBUG("*** DspProv Entered\n");
+	DEBUG("*** DspProv Entered\n");
 
-    while (list_empty(&info->prov_list) == 0)
-    {
-	DEBUG("DSP Provisioning List Entry\n");
-
-        // Check if doorbell is available
-        DEBUG("check if doorbell is cleared\n");
-        status = ft1000_read_register (dev, &tempword, FT1000_REG_DOORBELL);
-        if (status)
-	{
-		DEBUG("ft1000_dsp_prov::ft1000_read_register error\n");
-            break;
-        }
+	while (list_empty(&info->prov_list) == 0) {
+		DEBUG("DSP Provisioning List Entry\n");
+
+		/* Check if doorbell is available */
+		DEBUG("check if doorbell is cleared\n");
+		status =
+		    ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
+		if (status) {
+			DEBUG("ft1000_dsp_prov::ft1000_read_register error\n");
+			break;
+		}
 
-        while (tempword & FT1000_DB_DPRAM_TX) {
-            mdelay(10);
-            i++;
-            if (i==10) {
-               DEBUG("FT1000:ft1000_dsp_prov:message drop\n");
-               return STATUS_FAILURE;
-            }
-            ft1000_read_register(dev, &tempword, FT1000_REG_DOORBELL);
-        }
+		while (tempword & FT1000_DB_DPRAM_TX) {
+			mdelay(10);
+			i++;
+			if (i == 10) {
+				DEBUG("FT1000:ft1000_dsp_prov:message drop\n");
+				return STATUS_FAILURE;
+			}
+			ft1000_read_register(dev, &tempword,
+					     FT1000_REG_DOORBELL);
+		}
 
-        if ( !(tempword & FT1000_DB_DPRAM_TX) ) {
-            DEBUG("*** Provision Data Sent to DSP\n");
-
-            // Send provisioning data
-		ptr = list_entry(info->prov_list.next, struct prov_record, list);
-            len = *(u16 *)ptr->pprov_data;
-            len = htons(len);
-            len += PSEUDOSZ;
-
-            pmsg = (u16 *)ptr->pprov_data;
-		ppseudo_hdr = (struct pseudo_hdr *)pmsg;
-            // Insert slow queue sequence number
-            ppseudo_hdr->seq_num = info->squeseqnum++;
-            ppseudo_hdr->portsrc = 0;
-            // Calculate new checksum
-            ppseudo_hdr->checksum = *pmsg++;
-            //DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum);
-            for (i=1; i<7; i++) {
-                ppseudo_hdr->checksum ^= *pmsg++;
-                //DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum);
-            }
+		if (!(tempword & FT1000_DB_DPRAM_TX)) {
+			DEBUG("*** Provision Data Sent to DSP\n");
 
-            TempShortBuf[0] = 0;
-            TempShortBuf[1] = htons (len);
-            memcpy(&TempShortBuf[2], ppseudo_hdr, len);
+			/* Send provisioning data */
+			ptr =
+			    list_entry(info->prov_list.next, struct prov_record,
+				       list);
+			len = *(u16 *) ptr->pprov_data;
+			len = htons(len);
+			len += PSEUDOSZ;
 
-            status = ft1000_write_dpram32 (dev, 0, (u8 *)&TempShortBuf[0], (unsigned short)(len+2));
-            status = ft1000_write_register (dev, FT1000_DB_DPRAM_TX, FT1000_REG_DOORBELL);
+			pmsg = (u16 *) ptr->pprov_data;
+			ppseudo_hdr = (struct pseudo_hdr *)pmsg;
+			/* Insert slow queue sequence number */
+			ppseudo_hdr->seq_num = info->squeseqnum++;
+			ppseudo_hdr->portsrc = 0;
+			/* Calculate new checksum */
+			ppseudo_hdr->checksum = *pmsg++;
+			//DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum);
+			for (i = 1; i < 7; i++) {
+				ppseudo_hdr->checksum ^= *pmsg++;
+				//DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum);
+			}
 
-            list_del(&ptr->list);
-            kfree(ptr->pprov_data);
-            kfree(ptr);
-        }
-        msleep(10);
-    }
+			TempShortBuf[0] = 0;
+			TempShortBuf[1] = htons(len);
+			memcpy(&TempShortBuf[2], ppseudo_hdr, len);
+
+			status =
+			    ft1000_write_dpram32(dev, 0,
+						 (u8 *) &TempShortBuf[0],
+						 (unsigned short)(len + 2));
+			status =
+			    ft1000_write_register(dev, FT1000_DB_DPRAM_TX,
+						  FT1000_REG_DOORBELL);
+
+			list_del(&ptr->list);
+			kfree(ptr->pprov_data);
+			kfree(ptr);
+		}
+		msleep(10);
+	}
 
-    DEBUG("DSP Provisioning List Entry finished\n");
+	DEBUG("DSP Provisioning List Entry finished\n");
 
-    msleep(100);
+	msleep(100);
 
-    info->fProvComplete = 1;
-    info->CardReady = 1;
-    return STATUS_SUCCESS;
+	info->fProvComplete = 1;
+	info->CardReady = 1;
 
+	return STATUS_SUCCESS;
 }
 
-
 static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
 	struct ft1000_info *info = netdev_priv(dev->net);
     u16 msgtype;
-- 
1.7.1

