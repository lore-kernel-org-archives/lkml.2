Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab0JLIYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:24:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55625 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab0JLIYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lxJUd8hYqfCrojc8Zj3MEzuPFuM0H8NJvsq8GC4ZC1MWOtDrcErAvSgx7HLEH9tU97
         F++TOg90eGrI5nppRAOCFhuHdiCLQWwCyjNziMI6XejkwyL4EXE6hqstxHoCxjv+tZrt
         k14l3zG1cMXfDyzpcwsmjDei6ERUgSevX3bIc=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vasiliy Kulikov <segooon@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 1/4] staging: ft1000-usb: Remove global flag DSP_loading.
Date: Tue, 12 Oct 2010 10:26:40 +0200
Message-Id: <1286872003-12449-2-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286872003-12449-1-git-send-email-marek.belisko@gmail.com>
References: <1286872003-12449-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove global flag DSP_loading which was checked
only on one place. Instead check return value for dsp_reload() function.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c  |   12 ++++--------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |   16 ++++++++--------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    3 +--
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 1f3317c..d0637c3 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -685,7 +685,7 @@ void CardSendCommand(struct ft1000_device *ft1000dev, void *ptempbuffer, int siz
 //
 //  Returns:    None
 //-----------------------------------------------------------------------
-void dsp_reload (struct ft1000_device *ft1000dev)
+int dsp_reload(struct ft1000_device *ft1000dev)
 {
     u16 status;
     USHORT tempword;
@@ -696,7 +696,6 @@ void dsp_reload (struct ft1000_device *ft1000dev)
     pft1000info = netdev_priv(ft1000dev->net);
 
     pft1000info->CardReady = 0;
-    pft1000info->DSP_loading= 1;
 
     // Program Interrupt Mask register
     status = ft1000_write_register (ft1000dev, 0xffff, FT1000_REG_SUP_IMASK);
@@ -723,14 +722,13 @@ void dsp_reload (struct ft1000_device *ft1000dev)
     // call codeloader
     status = scram_dnldr(ft1000dev, pFileStart, FileLength);
 
-    if ( status != STATUS_SUCCESS)
-       return;
+	if (status != STATUS_SUCCESS)
+		return -EIO;
 
     msleep(1000);
-    pft1000info->DSP_loading= 0;
 
     DEBUG("dsp_reload returned\n");
-
+	return 0;
 
 }
 
@@ -1054,7 +1052,6 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     pInfo->CurrentInterruptEnableMask = ISR_DEFAULT_MASK;
     pInfo->InterruptsEnabled = FALSE;
     pInfo->CardReady = 0;
-    pInfo->DSP_loading = 0;
     pInfo->DSP_TIME[0] = 0;
     pInfo->DSP_TIME[1] = 0;
     pInfo->DSP_TIME[2] = 0;
@@ -2252,7 +2249,6 @@ static int ft1000_dsp_prov(void *arg)
 
     info->fProvComplete = 1;
     info->CardReady = 1;
-    info->DSP_loading= 0;
     return STATUS_SUCCESS;
 
 }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 3c9bb6d..cf041f3 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -182,18 +182,16 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 //    DEBUG("In probe: pft1000info=%x\n", pft1000info);				// aelias [-] reason: warning: format ???%x??? expects type ???unsigned int???, but argument 2 has type ???struct FT1000_INFO *???
     DEBUG("In probe: pft1000info=%p\n", pft1000info);		// aelias [+] reason: up
 
-    dsp_reload(ft1000dev);
+	ret = dsp_reload(ft1000dev);
+	if (ret) {
+		printk(KERN_ERR "Problem with DSP image loading\n");
+		goto err_load;
+	}
+
     gPollingfailed = FALSE;  //mbelian
     pft1000info->pPollThread = kthread_run(ft1000_poll_thread, ft1000dev, "ft1000_poll");
 	msleep(500); //mbelian
 
-
-    if ( pft1000info->DSP_loading )
-    {
-        DEBUG("ERROR!!!! RETURN FROM ft1000_probe **********************\n");
-        return 0;
-    }
-
     while (!pft1000info->CardReady)
     {
         if ( gPollingfailed )
@@ -220,6 +218,8 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 
        return 0;
 
+err_load:
+	kfree(pFileStart);
 err_fw:
 	kfree(ft1000dev);
 	return ret;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index b0ab918..764e9f2 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -554,7 +554,6 @@ typedef struct _FT1000_INFO {
     int IOCTLBufLvl;
     int DeviceCreated;
     int CardReady;
-    int DSP_loading;
     int NetDevRegDone;
     u8 CardNumber;
     u8 DeviceName[15];
@@ -632,7 +631,7 @@ void ft1000_free_buffer (PDPRAM_BLK pdpram_blk, struct list_head *plist);
 
 char *getfw (char *fn, size_t *pimgsz);
 
-void dsp_reload(struct ft1000_device *ft1000dev);
+int dsp_reload(struct ft1000_device *ft1000dev);
 u16 init_ft1000_netdev(struct ft1000_device *ft1000dev);
 struct usb_interface;
 u16 reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf);
-- 
1.7.1

