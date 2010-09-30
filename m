Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0I3I02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:26:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49276 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab0I3IYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:24:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/6] staging/ft1000-usb: fix build warnings
Date: Thu, 30 Sep 2010 10:24:09 +0200
Message-Id: <1285835052-11880-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285835052-11880-1-git-send-email-arnd@arndb.de>
References: <1285835052-11880-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1AsC3iRS6ULUzZqg4GIl7wAb5aNn7JXRjVYjx1bpY1L
 ulw8Wwqiwjs4RHEkD63ElVNGCB7uc+KCVw4ijJrGIb6inXDY/L
 Bcd8wxv+3ESeyveRwli3NTmiLjjZLVmchuSNqa6XfPvNGLTGqj
 1OF507X57k9nCyAXMuodOwLTLNzgTfFIHSU1wDCCXLlbMIxv3e
 /9NrBdC5MYiFULXhK31rw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets us see clearer when stuff breaks.

Most of the changes are fixes for casts between int and pointer
that don't work on 64 bit.

The ioctl function uses a large amount of stack, which gets
fixed by allocating the buffer dynamically.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |   44 +++++++++++--------
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    4 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    6 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    4 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    2 +-
 5 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 44b037c..282deeb 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -263,7 +263,7 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
     //save the device info to global array
     pdevobj[info->CardNumber] = dev;
 
-    DEBUG("ft1000_CreateDevice: ******SAVED pdevobj[%d]=%x\n", info->CardNumber, (unsigned int)pdevobj[info->CardNumber]);	//aelias [+] reason:up
+    DEBUG("ft1000_CreateDevice: ******SAVED pdevobj[%d]=%p\n", info->CardNumber, pdevobj[info->CardNumber]);	//aelias [+] reason:up
 
     if (info->DeviceCreated)
     {
@@ -430,7 +430,7 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
     DEBUG("ft1000_ChOpen: minor number=%d\n", num);
 
     for (i=0; i<5; i++)
-        DEBUG("pdevobj[%d]=%x\n", i, (unsigned int)pdevobj[i]); //aelias [+] reason: down
+        DEBUG("pdevobj[%d]=%p\n", i, pdevobj[i]); //aelias [+] reason: down
 
     if ( pdevobj[num] != NULL )
         //info = (PFT1000_INFO)(pdevobj[num]->net->priv);
@@ -441,7 +441,7 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
         return -1;
     }
 
-    DEBUG("f_owner = 0x%8x number of application = %d\n", (u32)(&File->f_owner), info->appcnt );
+    DEBUG("f_owner = %p number of application = %d\n", (&File->f_owner), info->appcnt );
 
     // Check if maximum number of application exceeded
     if (info->appcnt > MAX_NUM_APP) {
@@ -451,7 +451,7 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
 
     // Search for available application info block
     for (i=0; i<MAX_NUM_APP; i++) {
-        if ( (info->app_info[i].fileobject == 0) ) {
+        if ( (info->app_info[i].fileobject == NULL) ) {
             break;
         }
     }
@@ -463,7 +463,7 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
     }
 
     info->appcnt++;
-    info->app_info[i].fileobject = (u32)(&File->f_owner);
+    info->app_info[i].fileobject = &File->f_owner;
     info->app_info[i].nTxMsg = 0;
     info->app_info[i].nRxMsg = 0;
     info->app_info[i].nTxMsgReject = 0;
@@ -503,7 +503,7 @@ static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait)
 
     // Search for matching file object
     for (i=0; i<MAX_NUM_APP; i++) {
-        if ( info->app_info[i].fileobject == (u32)(&file->f_owner) ) {
+        if ( info->app_info[i].fileobject == &file->f_owner) {
             //DEBUG("FT1000:ft1000_ChIoctl: Message is for AppId = %d\n", info->app_info[i].app_id);
             break;
         }
@@ -587,7 +587,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
             if (tempword == DSPBCMSGID) {
                 // Search for matching file object
                 for (i=0; i<MAX_NUM_APP; i++) {
-                    if ( info->app_info[i].fileobject == (u32)(&File->f_owner) ) {
+                    if ( info->app_info[i].fileobject == &File->f_owner) {
                         info->app_info[i].DspBCMsgFlag = 1;
                         DEBUG("FT1000:ft1000_ChIoctl:Registered for broadcast messages\n");
                         break;
@@ -660,7 +660,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
         break;
     case IOCTL_SET_DPRAM_CMD:
         {
-            IOCTL_DPRAM_BLK dpram_data;
+            IOCTL_DPRAM_BLK *dpram_data;
             //IOCTL_DPRAM_COMMAND dpram_command;
             USHORT qtype;
             USHORT msgsz;
@@ -702,6 +702,11 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                     break;
                 }
 
+		result = -ENOMEM;
+		dpram_data = kmalloc(msgsz + 2, GFP_KERNEL);
+		if (!dpram_data)
+			break;
+
                 //if ( copy_from_user(&(dpram_command.dpram_blk), (PIOCTL_DPRAM_BLK)Argument, msgsz+2) ) {
                 if ( copy_from_user(&dpram_data, (PIOCTL_DPRAM_BLK)Argument, msgsz+2) ) {
                     DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
@@ -717,20 +722,21 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 #endif
                     // Check if this message came from a registered application
                     for (i=0; i<MAX_NUM_APP; i++) {
-                        if ( info->app_info[i].fileobject == (u32)(&File->f_owner) ) {
+                        if ( info->app_info[i].fileobject == &File->f_owner) {
                             break;
                         }
                     }
                     if (i==MAX_NUM_APP) {
                         DEBUG("FT1000:No matching application fileobject\n");
                         result = -EINVAL;
+			kfree(dpram_data);
                         break;
                     }
                     app_index = i;
 
                     // Check message qtype type which is the lower byte within qos_class
                     //qtype = ntohs(dpram_command.dpram_blk.pseudohdr.qos_class) & 0xff;
-                    qtype = ntohs(dpram_data.pseudohdr.qos_class) & 0xff;
+                    qtype = ntohs(dpram_data->pseudohdr.qos_class) & 0xff;
                     //DEBUG("FT1000_ft1000_ChIoctl: qtype = %d\n", qtype);
                     if (qtype) {
                     }
@@ -756,6 +762,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                                         if (tempword & FT1000_DB_DPRAM_TX) {
                                             DEBUG("FT1000:ft1000_ChIoctl:Doorbell not available\n");
                                             result = -ENOTTY;
+						kfree(dpram_data);
                                             break;
                                         }
                                     }
@@ -769,7 +776,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                         if ( (msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ) ) {
                             // Need to put sequence number plus new checksum for message
                             //pmsg = (PUSHORT)&dpram_command.dpram_blk.pseudohdr;
-                            pmsg = (PUSHORT)&dpram_data.pseudohdr;
+                            pmsg = (PUSHORT)&dpram_data->pseudohdr;
                             ppseudo_hdr = (PPSEUDO_HDR)pmsg;
                             total_len = msgsz+2;
                             if (total_len & 0x1) {
@@ -789,7 +796,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                             pmsg++;
                             ppseudo_hdr = (PPSEUDO_HDR)pmsg;
 #if 0
-                            ptr = (char *)&dpram_data;
+                            ptr = dpram_data;
                             DEBUG("FT1000:ft1000_ChIoctl: Command Send\n");
                             for (i=0; i<total_len; i++) {
                                 DEBUG("FT1000:ft1000_ChIoctl: data %d = 0x%x\n", i, *ptr++);
@@ -798,15 +805,13 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                             //dpram_command.extra = 0;
 
                             //CardSendCommand(ft1000dev,(unsigned char*)&dpram_command,total_len+2);
-                            CardSendCommand(ft1000dev,(unsigned short*)&dpram_data,total_len+2);
+                            CardSendCommand(ft1000dev,(unsigned short*)dpram_data,total_len+2);
 
 
                             info->app_info[app_index].nTxMsg++;
-                            break;
                         }
                         else {
                             result = -EINVAL;
-                            break;
                         }
                     }
                 }
@@ -815,13 +820,14 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                 DEBUG("FT1000:ft1000_ChIoctl: Card not ready take messages\n");
                 result = -EACCES;
             }
+	    kfree(dpram_data);
 
         }
         break;
     case IOCTL_GET_DPRAM_CMD:
         {
             PDPRAM_BLK pdpram_blk;
-            PIOCTL_DPRAM_BLK pioctl_dpram;
+            IOCTL_DPRAM_BLK __user *pioctl_dpram;
             int msglen;
 
             //DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_GET_DPRAM called\n");
@@ -832,7 +838,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 
             // Search for matching file object
             for (i=0; i<MAX_NUM_APP; i++) {
-                if ( info->app_info[i].fileobject == (u32)(&File->f_owner) ) {
+                if ( info->app_info[i].fileobject == &File->f_owner) {
                     //DEBUG("FT1000:ft1000_ChIoctl: Message is for AppId = %d\n", info->app_info[i].app_id);
                     break;
                 }
@@ -856,7 +862,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                 //DEBUG("FT1000:ft1000_ChIoctl:NumOfMsg for app %d = %d\n", i, info->app_info[i].NumOfMsg);
                 spin_unlock_irqrestore(&free_buff_lock, flags);
                 msglen = ntohs(*(u16 *)pdpram_blk->pbuffer) + PSEUDOSZ;
-                pioctl_dpram->total_len = htons(msglen);
+                pioctl_dpram->total_len = htons(msglen); /* XXX exploit here */
                 //DEBUG("FT1000:ft1000_ChIoctl:msg length = %x\n", msglen);
                 if(copy_to_user (&pioctl_dpram->pseudohdr, pdpram_blk->pbuffer, msglen))
 				{
@@ -910,7 +916,7 @@ static int ft1000_ChRelease (struct inode *Inode, struct file *File)
 
     // Search for matching file object
     for (i=0; i<MAX_NUM_APP; i++) {
-        if ( info->app_info[i].fileobject == (u32)(&File->f_owner) ) {
+        if ( info->app_info[i].fileobject == &File->f_owner) {
             //DEBUG("FT1000:ft1000_ChIoctl: Message is for AppId = %d\n", info->app_info[i].app_id);
             break;
         }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 93f75b1..c71a1f4 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -1356,8 +1356,8 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                     pprov_record->pprov_data = pbuffer;
                     list_add_tail (&pprov_record->list, &pft1000info->prov_list);
                     // Move to next entry if available
-                    pUcFile = (UCHAR *)((UINT)pUcFile + (UINT)((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(PSEUDO_HDR));
-                    if ( (UINT)(pUcFile) - (UINT)(pFileStart) >= (UINT)FileLength) {
+                    pUcFile = (UCHAR *)((unsigned long)pUcFile + (UINT)((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(PSEUDO_HDR));
+                    if ( (unsigned long)(pUcFile) - (unsigned long)(pFileStart) >= (unsigned long)FileLength) {
                        uiState = STATE_DONE_FILE;
                     }
                 }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 51ed0dd..4c3b1db 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1350,7 +1350,7 @@ static int ft1000_read_fifo_reg(struct ft1000_device *ft1000dev,unsigned int pip
 
         if(urb->status)
         {
-            printk("ft1000 control message failed (urb addr: %x) with error number: %i\n", (int)urb, (int)status);
+            printk("ft1000 control message failed (urb addr: %p) with error number: %i\n", urb, (int)status);
 
             usb_clear_halt(ft1000dev->dev, usb_rcvctrlpipe(ft1000dev->dev, 0));
             usb_clear_halt(ft1000dev->dev, usb_sndctrlpipe(ft1000dev->dev, 0));
@@ -1390,7 +1390,7 @@ static inline u16 ft1000_read_fifo_len (struct net_device *dev)
 	FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev);
     struct ft1000_device *ft1000dev = info->pFt1000Dev;
 //    DEBUG("ft1000_read_fifo_len: enter ft1000dev %x\n", ft1000dev);			//aelias [-] reason: warning: format ???%x??? expects type ???unsigned int???, but argument 2 has type ???struct ft1000_device *???
-    DEBUG("ft1000_read_fifo_len: enter ft1000dev %x\n", (unsigned int)ft1000dev);	//aelias [+] reason: up
+    DEBUG("ft1000_read_fifo_len: enter ft1000dev %p\n", ft1000dev);	//aelias [+] reason: up
     //ft1000_read_register(ft1000dev, &temp, FT1000_REG_MAG_UFSR);
 
     ret = STATUS_SUCCESS;
@@ -1882,7 +1882,7 @@ int ft1000_close(struct net_device *net)
     //usb_kill_urb(ft1000dev->tx_urb);
 
 
-    DEBUG("ft1000_close: pInfo=%x, ft1000dev=%x\n", (int)pInfo, (int)ft1000dev);
+    DEBUG("ft1000_close: pInfo=%p, ft1000dev=%p\n", pInfo, ft1000dev);
     netif_carrier_off(net);//mbelian
     netif_stop_queue(net);
     //DEBUG("ft1000_close: netif_stop_queue called\n");
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 4dbc98b..f708c09 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -184,7 +184,7 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
     pft1000info = (FT1000_INFO *) netdev_priv (ft1000dev->net);
 
 //    DEBUG("In probe: pft1000info=%x\n", pft1000info);				// aelias [-] reason: warning: format ???%x??? expects type ???unsigned int???, but argument 2 has type ???struct FT1000_INFO *???
-    DEBUG("In probe: pft1000info=%x\n", (unsigned int)pft1000info);		// aelias [+] reason: up
+    DEBUG("In probe: pft1000info=%p\n", pft1000info);		// aelias [+] reason: up
 
     dsp_reload(ft1000dev);
     gPollingfailed = FALSE;  //mbelian
@@ -245,7 +245,7 @@ static void ft1000_disconnect(struct usb_interface *interface)
 
     pft1000info = (PFT1000_INFO)usb_get_intfdata(interface);
 //    DEBUG("In disconnect pft1000info=%x\n", pft1000info);	// aelias [-] reason: warning: format ???%x??? expects type ???unsigned int???, but argument 2 has type ???struct FT1000_INFO *???
-    DEBUG("In disconnect pft1000info=%x\n", (unsigned int) pft1000info);	// aelias [+] reason: up
+    DEBUG("In disconnect pft1000info=%p\n", pft1000info);	// aelias [+] reason: up
 
 
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index b0c611b..a64d468 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -83,7 +83,7 @@ typedef struct _APP_INFO_BLOCK
     u32 nRxMsg;                    // DPRAM msg rcv from dsp with app_id
     u32 nTxMsgReject;              // DPRAM msg rejected due to DSP doorbell set
     u32 nRxMsgMiss;                // DPRAM msg dropped due to overflow
-    u32 fileobject;                // Application's file object
+    struct fown_struct *fileobject;// Application's file object
     u16 app_id;                    // Application id
     int DspBCMsgFlag;
     int NumOfMsg;                   // number of messages queued up
-- 
1.7.1

