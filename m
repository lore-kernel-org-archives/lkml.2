Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1FZUuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 16:50:00 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:39296 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755283Ab1FZUsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 16:48:43 -0400
Subject: [RFC, RFT] [PATCH] staging: ft1000: unify struct ft1000_info between USB and PCMCIA drivers
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
From: Ondrej Zary <linux@rainbow-software.org>
Date: Sun, 26 Jun 2011 22:48:26 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106262248.29630.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify struct ft1000_info between ft1000-usb and ft1000-pcmcia and move it to
common ft1000.h.

ft1000-pcmcia seems to work. Please test ft1000-usb.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |   33 +-----
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   21 ++-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |   10 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   |  147 ++++++++++----------
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   70 +++++-----
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   99 +++++++-------
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |    4 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   30 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   89 +++---------
 drivers/staging/ft1000/ft1000.h                    |   35 +++++
 10 files changed, 251 insertions(+), 287 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index 3b0130f..7676523 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -31,41 +31,10 @@
 #define SUCCESS	0x00
 #define FAILURE	0x01
 
-struct ft1000_info {
-	struct net_device_stats stats;
-	u16 DrvErrNum;
-	u16 AsicID;
+struct ft1000_pcmcia {
 	int PktIntfErr;
-	int CardReady;
-	int registered;
-	int mediastate;
 	u16 packetseqnum;
-	u8 squeseqnum;			/* sequence number on slow queue */
-	spinlock_t dpram_lock;
-	u16 fifo_cnt;
-	u8 DspVer[DSPVERSZ];		/* DSP version number */
-	u8 HwSerNum[HWSERNUMSZ];	/* Hardware Serial Number */
-	u8 Sku[SKUSZ];			/* SKU */
-	u8 eui64[EUISZ];		/* EUI64 */
-	time_t ConTm;			/* Connection Time */
-	u16 LedStat;
-	u16 ConStat;
-	u16 ProgConStat;
-	u8 ProductMode[MODESZ];
-	u8 RfCalVer[CALVERSZ];
-	u8 RfCalDate[CALDATESZ];
-	u16 DSP_TIME[4];
-	struct list_head prov_list;
-	u16 DSPInfoBlklen;
-	int (*ft1000_reset)(void *);
 	void *link;
-	u16 DSPInfoBlk[MAX_DSP_SESS_REC];
-	union {
-		u16 Rec[MAX_DSP_SESS_REC];
-		u32 MagRec[MAX_DSP_SESS_REC/2];
-	} DSPSess;
-	struct proc_dir_entry *proc_ft1000;
-	char netdevname[IFNAMSIZ];
 };
 
 extern u16 ft1000_read_dpram(struct net_device *dev, int offset);
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 990b2af..f891c74 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -335,11 +335,12 @@ static void ft1000_disable_interrupts(struct net_device *dev)
 static void ft1000_reset_asic(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
+	struct ft1000_pcmcia *pcmcia = info->priv;
 	u16 tempword;
 
 	DEBUG(1, "ft1000_hw:ft1000_reset_asic called\n");
 
-	(*info->ft1000_reset) (info->link);
+	(*info->ft1000_reset) (pcmcia->link);
 
 	// Let's use the register provided by the Magnemite ASIC to reset the
 	// ASIC and DSP.
@@ -1403,12 +1404,13 @@ int ft1000_parse_dpram_msg(struct net_device *dev)
 static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 {
 	struct ft1000_info *info = netdev_priv(dev);
+	struct ft1000_pcmcia *pcmcia = info->priv;
 	u16 i;
 	u32 templong;
 	u16 tempword;
 
 	DEBUG(1, "ft1000:ft1000_hw:ft1000_flush_fifo called\n");
-	if (info->PktIntfErr > MAX_PH_ERR) {
+	if (pcmcia->PktIntfErr > MAX_PH_ERR) {
 		if (info->AsicID == ELECTRABUZZ_ID) {
 			info->DSP_TIME[0] =
 				ft1000_read_dpram(dev, FT1000_DSP_TIMER0);
@@ -1497,7 +1499,7 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 							FIFO_FLUSH_BADCNT;
 					} else {
 						// Let's assume that we really flush the FIFO
-						info->PktIntfErr++;
+						pcmcia->PktIntfErr++;
 						return;
 					}
 				} else {
@@ -1528,7 +1530,7 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 			DEBUG(0, "FT1000_REG_MAG_DFSR = 0x%x\n", tempword);
 		}
 		if (DrvErrNum) {
-			info->PktIntfErr++;
+			pcmcia->PktIntfErr++;
 		}
 	}
 }
@@ -1737,6 +1739,7 @@ int ft1000_copy_up_pkt(struct net_device *dev)
 int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
 {
 	struct ft1000_info *info = netdev_priv(dev);
+	struct ft1000_pcmcia *pcmcia = info->priv;
 	union {
 		struct pseudo_hdr blk;
 		u16 buff[sizeof(struct pseudo_hdr) >> 1];
@@ -1786,7 +1789,7 @@ int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
 	pseudo.blk.control = 0;
 	pseudo.blk.rsvd1 = 0;
 	pseudo.blk.seq_num = 0;
-	pseudo.blk.rsvd2 = info->packetseqnum++;
+	pseudo.blk.rsvd2 = pcmcia->packetseqnum++;
 	pseudo.blk.qos_class = 0;
 	/* Calculate pseudo header checksum */
 	pseudo.blk.checksum = pseudo.buff[0];
@@ -2063,6 +2066,8 @@ void stop_ft1000_card(struct net_device *dev)
 		kfree(ptr);
 	}
 
+	kfree(info->priv);
+
 	if (info->registered) {
 		unregister_netdev(dev);
 		info->registered = 0;
@@ -2105,6 +2110,7 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 					void *ft1000_reset)
 {
 	struct ft1000_info *info;
+	struct ft1000_pcmcia *pcmcia;
 	struct net_device *dev;
 
 	static const struct net_device_ops ft1000ops =		// Slavius 21.10.2009 due to kernel changes
@@ -2146,10 +2152,13 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 
 	memset(&info->stats, 0, sizeof(struct net_device_stats));
 
+	info->priv = kzalloc(sizeof(struct ft1000_pcmcia), GFP_KERNEL);
+	pcmcia = info->priv;
+	pcmcia->link = link;
+
 	spin_lock_init(&info->dpram_lock);
 	info->DrvErrNum = 0;
 	info->registered = 1;
-	info->link = link;
 	info->ft1000_reset = ft1000_reset;
 	info->mediastate = 0;
 	info->fifo_cnt = 0;
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
index 627a98b..eb20e0b 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
@@ -176,8 +176,8 @@ static int ft1000NotifyProc(struct notifier_block *this, unsigned long event,
 
 	switch (event) {
 	case NETDEV_CHANGENAME:
-		remove_proc_entry(info->netdevname, info->proc_ft1000);
-		create_proc_read_entry(dev->name, 0644, info->proc_ft1000,
+		remove_proc_entry(info->netdevname, info->ft1000_proc_dir);
+		create_proc_read_entry(dev->name, 0644, info->ft1000_proc_dir,
 					   ft1000ReadProc, dev);
 		snprintf(info->netdevname, IFNAMSIZ, "%s", dev->name);
 		break;
@@ -195,8 +195,8 @@ void ft1000InitProc(struct net_device *dev)
 
 	info = netdev_priv(dev);
 
-	info->proc_ft1000 = proc_mkdir(FT1000_PROC, init_net.proc_net);
-	create_proc_read_entry(dev->name, 0644, info->proc_ft1000,
+	info->ft1000_proc_dir = proc_mkdir(FT1000_PROC, init_net.proc_net);
+	create_proc_read_entry(dev->name, 0644, info->ft1000_proc_dir,
 				   ft1000ReadProc, dev);
 	snprintf(info->netdevname, IFNAMSIZ, "%s", dev->name);
 	register_netdevice_notifier(&ft1000_netdev_notifier);
@@ -208,7 +208,7 @@ void ft1000CleanupProc(struct net_device *dev)
 
 	info = netdev_priv(dev);
 
-	remove_proc_entry(dev->name, info->proc_ft1000);
+	remove_proc_entry(dev->name, info->ft1000_proc_dir);
 	remove_proc_entry(FT1000_PROC, init_net.proc_net);
 	unregister_netdevice_notifier(&ft1000_netdev_notifier);
 }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 19db23f..229f0a8 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -139,27 +139,26 @@ void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist)
 //---------------------------------------------------------------------------
 int ft1000_create_dev(struct ft1000_device *dev)
 {
-	struct ft1000_info *info = netdev_priv(dev->net);
     int result;
     int i;
 	struct dentry *dir, *file;
 	struct ft1000_debug_dirs *tmp;
 
     // make a new device name
-    sprintf(info->DeviceName, "%s%d", "FT1000_", info->CardNumber);
+    sprintf(dev->DeviceName, "%s%d", "FT1000_", dev->CardNumber);
 
     DEBUG("%s: number of instance = %d\n", __func__, ft1000_flarion_cnt);
-    DEBUG("DeviceCreated = %x\n", info->DeviceCreated);
+    DEBUG("DeviceCreated = %x\n", dev->DeviceCreated);
 
-    if (info->DeviceCreated)
+    if (dev->DeviceCreated)
     {
-	DEBUG("%s: \"%s\" already registered\n", __func__, info->DeviceName);
+	DEBUG("%s: \"%s\" already registered\n", __func__, dev->DeviceName);
 	return -EIO;
     }
 
 
     // register the device
-    DEBUG("%s: \"%s\" debugfs device registration\n", __func__, info->DeviceName);
+    DEBUG("%s: \"%s\" debugfs device registration\n", __func__, dev->DeviceName);
 
 	tmp = kmalloc(sizeof(struct ft1000_debug_dirs), GFP_KERNEL);
 	if (tmp == NULL) {
@@ -167,7 +166,7 @@ int ft1000_create_dev(struct ft1000_device *dev)
 		goto fail;
 	}
 
-	dir = debugfs_create_dir(info->DeviceName, 0);
+	dir = debugfs_create_dir(dev->DeviceName, 0);
 	if (IS_ERR(dir)) {
 		result = PTR_ERR(dir);
 		goto debug_dir_fail;
@@ -182,27 +181,27 @@ int ft1000_create_dev(struct ft1000_device *dev)
 
 	tmp->dent = dir;
 	tmp->file = file;
-	tmp->int_number = info->CardNumber;
-	list_add(&(tmp->list), &(info->nodes.list));
+	tmp->int_number = dev->CardNumber;
+	list_add(&(tmp->list), &(dev->nodes.list));
 
-    DEBUG("%s: registered debugfs directory \"%s\"\n", __func__, info->DeviceName);
+    DEBUG("%s: registered debugfs directory \"%s\"\n", __func__, dev->DeviceName);
 
     // initialize application information
-    info->appcnt = 0;
+    dev->appcnt = 0;
     for (i=0; i<MAX_NUM_APP; i++) {
-        info->app_info[i].nTxMsg = 0;
-        info->app_info[i].nRxMsg = 0;
-        info->app_info[i].nTxMsgReject = 0;
-        info->app_info[i].nRxMsgMiss = 0;
-        info->app_info[i].fileobject = NULL;
-        info->app_info[i].app_id = i+1;
-        info->app_info[i].DspBCMsgFlag = 0;
-        info->app_info[i].NumOfMsg = 0;
-        init_waitqueue_head(&info->app_info[i].wait_dpram_msg);
-        INIT_LIST_HEAD (&info->app_info[i].app_sqlist);
+        dev->app_info[i].nTxMsg = 0;
+        dev->app_info[i].nRxMsg = 0;
+        dev->app_info[i].nTxMsgReject = 0;
+        dev->app_info[i].nRxMsgMiss = 0;
+        dev->app_info[i].fileobject = NULL;
+        dev->app_info[i].app_id = i+1;
+        dev->app_info[i].DspBCMsgFlag = 0;
+        dev->app_info[i].NumOfMsg = 0;
+        init_waitqueue_head(&dev->app_info[i].wait_dpram_msg);
+        INIT_LIST_HEAD (&dev->app_info[i].app_sqlist);
     }
 
-    info->DeviceCreated = TRUE;
+    dev->DeviceCreated = TRUE;
     ft1000_flarion_cnt++;
 
 	return 0;
@@ -225,9 +224,10 @@ fail:
 // Notes:       Only called by cleanup_module().
 //
 //---------------------------------------------------------------------------
-void ft1000_destroy_dev(struct net_device *dev)
+void ft1000_destroy_dev(struct net_device *netdev)
 {
-	struct ft1000_info *info = netdev_priv(dev);
+	struct ft1000_info *info = netdev_priv(netdev);
+	struct ft1000_device *dev = info->priv;
 		int i;
 	struct dpram_blk *pdpram_blk;
 	struct dpram_blk *ptr;
@@ -238,12 +238,12 @@ void ft1000_destroy_dev(struct net_device *dev)
 
 
 
-    if (info->DeviceCreated)
+    if (dev->DeviceCreated)
 	{
         ft1000_flarion_cnt--;
-		list_for_each_safe(pos, q, &info->nodes.list) {
+		list_for_each_safe(pos, q, &dev->nodes.list) {
 			dir = list_entry(pos, struct ft1000_debug_dirs, list);
-			if (dir->int_number == info->CardNumber) {
+			if (dir->int_number == dev->CardNumber) {
 				debugfs_remove(dir->file);
 				debugfs_remove(dir->dent);
 				list_del(pos);
@@ -251,17 +251,17 @@ void ft1000_destroy_dev(struct net_device *dev)
 			}
 		}
 		DEBUG("%s: unregistered device \"%s\"\n", __func__,
-					   info->DeviceName);
+					   dev->DeviceName);
 
         // Make sure we free any memory reserve for slow Queue
         for (i=0; i<MAX_NUM_APP; i++) {
-            while (list_empty(&info->app_info[i].app_sqlist) == 0) {
-                pdpram_blk = list_entry(info->app_info[i].app_sqlist.next, struct dpram_blk, list);
+            while (list_empty(&dev->app_info[i].app_sqlist) == 0) {
+                pdpram_blk = list_entry(dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
                 list_del(&pdpram_blk->list);
                 ft1000_free_buffer(pdpram_blk, &freercvpool);
 
             }
-            wake_up_interruptible(&info->app_info[i].wait_dpram_msg);
+            wake_up_interruptible(&dev->app_info[i].wait_dpram_msg);
         }
 
         // Remove buffer allocated for receive command data
@@ -273,7 +273,7 @@ void ft1000_destroy_dev(struct net_device *dev)
                 kfree(ptr);
             }
         }
-		info->DeviceCreated = FALSE;
+		dev->DeviceCreated = FALSE;
 	}
 
 
@@ -301,17 +301,17 @@ static int ft1000_open (struct inode *inode, struct file *file)
 
 	info = file->private_data = netdev_priv(dev->net);
 
-    DEBUG("f_owner = %p number of application = %d\n", (&file->f_owner), info->appcnt );
+    DEBUG("f_owner = %p number of application = %d\n", (&file->f_owner), dev->appcnt );
 
     // Check if maximum number of application exceeded
-    if (info->appcnt > MAX_NUM_APP) {
+    if (dev->appcnt > MAX_NUM_APP) {
         DEBUG("Maximum number of application exceeded\n");
         return -EACCES;
     }
 
     // Search for available application info block
     for (i=0; i<MAX_NUM_APP; i++) {
-        if ( (info->app_info[i].fileobject == NULL) ) {
+        if ( (dev->app_info[i].fileobject == NULL) ) {
             break;
         }
     }
@@ -322,12 +322,12 @@ static int ft1000_open (struct inode *inode, struct file *file)
         return -EACCES;
     }
 
-    info->appcnt++;
-    info->app_info[i].fileobject = &file->f_owner;
-    info->app_info[i].nTxMsg = 0;
-    info->app_info[i].nRxMsg = 0;
-    info->app_info[i].nTxMsgReject = 0;
-    info->app_info[i].nRxMsgMiss = 0;
+    dev->appcnt++;
+    dev->app_info[i].fileobject = &file->f_owner;
+    dev->app_info[i].nTxMsg = 0;
+    dev->app_info[i].nRxMsg = 0;
+    dev->app_info[i].nTxMsgReject = 0;
+    dev->app_info[i].nRxMsgMiss = 0;
 
 	nonseekable_open(inode, file);
     return 0;
@@ -347,8 +347,9 @@ static int ft1000_open (struct inode *inode, struct file *file)
 
 static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
 {
-    struct net_device *dev = file->private_data;
-	struct ft1000_info *info;
+    struct net_device *netdev = file->private_data;
+	struct ft1000_info *info = netdev_priv(netdev);
+	struct ft1000_device *dev = info->priv;
     int i;
 
     //DEBUG("ft1000_poll_dev called\n");
@@ -357,12 +358,10 @@ static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
         return (-EBADF);
     }
 
-	info = netdev_priv(dev);
-
     // Search for matching file object
     for (i=0; i<MAX_NUM_APP; i++) {
-        if ( info->app_info[i].fileobject == &file->f_owner) {
-            //DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", info->app_info[i].app_id);
+        if ( dev->app_info[i].fileobject == &file->f_owner) {
+            //DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", dev->app_info[i].app_id);
             break;
         }
     }
@@ -373,12 +372,12 @@ static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
         return ( -EACCES );
     }
 
-    if (list_empty(&info->app_info[i].app_sqlist) == 0) {
+    if (list_empty(&dev->app_info[i].app_sqlist) == 0) {
         DEBUG("FT1000:ft1000_poll_dev:Message detected in slow queue\n");
         return(POLLIN | POLLRDNORM | POLLPRI);
     }
 
-    poll_wait (file, &info->app_info[i].wait_dpram_msg, wait);
+    poll_wait (file, &dev->app_info[i].wait_dpram_msg, wait);
     //DEBUG("FT1000:ft1000_poll_dev:Polling for data from DSP\n");
 
     return (0);
@@ -428,7 +427,7 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
     //DEBUG("FT1000:ft1000_ioctl:command = 0x%x argument = 0x%8x\n", command, (u32)argument);
 
 	info = file->private_data;
-	ft1000dev = info->pFt1000Dev;
+	ft1000dev = info->priv;
     cmd = _IOC_NR(command);
     //DEBUG("FT1000:ft1000_ioctl:cmd = 0x%x\n", cmd);
 
@@ -444,8 +443,8 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
             if (tempword == DSPBCMSGID) {
                 // Search for matching file object
                 for (i=0; i<MAX_NUM_APP; i++) {
-                    if ( info->app_info[i].fileobject == &file->f_owner) {
-                        info->app_info[i].DspBCMsgFlag = 1;
+                    if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
+                        ft1000dev->app_info[i].DspBCMsgFlag = 1;
                         DEBUG("FT1000:ft1000_ioctl:Registered for broadcast messages\n");
                         break;
                     }
@@ -534,15 +533,15 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
                 return (-EBADF);
             }
 
-            if (info->DrvMsgPend) {
+            if (ft1000dev->DrvMsgPend) {
                 return (-ENOTTY);
             }
 
-            if ( (info->DspAsicReset) || (info->fProvComplete == 0) ) {
+            if (ft1000dev->fProvComplete == 0) {
                 return (-EACCES);
             }
 
-            info->fAppMsgPend = 1;
+            ft1000dev->fAppMsgPend = 1;
 
             if (info->CardReady) {
 
@@ -571,7 +570,7 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
                 else {
                     // Check if this message came from a registered application
                     for (i=0; i<MAX_NUM_APP; i++) {
-                        if ( info->app_info[i].fileobject == &file->f_owner) {
+                        if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
                             break;
                         }
                     }
@@ -632,7 +631,7 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
 
                             // Insert slow queue sequence number
                             ppseudo_hdr->seq_num = info->squeseqnum++;
-                            ppseudo_hdr->portsrc = info->app_info[app_index].app_id;
+                            ppseudo_hdr->portsrc = ft1000dev->app_info[app_index].app_id;
                             // Calculate new checksum
                             ppseudo_hdr->checksum = *pmsg++;
                             //DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum);
@@ -645,7 +644,7 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
                            card_send_command(ft1000dev,(unsigned short*)dpram_data,total_len+2);
 
 
-                            info->app_info[app_index].nTxMsg++;
+                            ft1000dev->app_info[app_index].nTxMsg++;
                         }
                         else {
                             result = -EINVAL;
@@ -675,8 +674,8 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
 
             // Search for matching file object
             for (i=0; i<MAX_NUM_APP; i++) {
-                if ( info->app_info[i].fileobject == &file->f_owner) {
-                    //DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", info->app_info[i].app_id);
+                if (ft1000dev->app_info[i].fileobject == &file->f_owner) {
+                    //DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id);
                     break;
                 }
             }
@@ -690,13 +689,13 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
 
             result = 0;
             pioctl_dpram = argp;
-            if (list_empty(&info->app_info[i].app_sqlist) == 0) {
+            if (list_empty(&ft1000dev->app_info[i].app_sqlist) == 0) {
                 //DEBUG("FT1000:ft1000_ioctl:Message detected in slow queue\n");
                 spin_lock_irqsave(&free_buff_lock, flags);
-                pdpram_blk = list_entry(info->app_info[i].app_sqlist.next, struct dpram_blk, list);
+                pdpram_blk = list_entry(ft1000dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
                 list_del(&pdpram_blk->list);
-                info->app_info[i].NumOfMsg--;
-                //DEBUG("FT1000:ft1000_ioctl:NumOfMsg for app %d = %d\n", i, info->app_info[i].NumOfMsg);
+                ft1000dev->app_info[i].NumOfMsg--;
+                //DEBUG("FT1000:ft1000_ioctl:NumOfMsg for app %d = %d\n", i, ft1000dev->app_info[i].NumOfMsg);
                 spin_unlock_irqrestore(&free_buff_lock, flags);
                 msglen = ntohs(*(u16 *)pdpram_blk->pbuffer) + PSEUDOSZ;
                 result = get_user(msglen, &pioctl_dpram->total_len);
@@ -723,7 +722,7 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
         result = -ENOTTY;
         break;
     }
-    info->fAppMsgPend = 0;
+    ft1000dev->fAppMsgPend = 0;
     return result;
 }
 
@@ -741,6 +740,7 @@ static int ft1000_release (struct inode *inode, struct file *file)
 {
 	struct ft1000_info *info;
     struct net_device *dev;
+    struct ft1000_device *ft1000dev;
     int i;
 	struct dpram_blk *pdpram_blk;
 
@@ -748,16 +748,17 @@ static int ft1000_release (struct inode *inode, struct file *file)
 
     dev = file->private_data;
 	info = netdev_priv(dev);
+	ft1000dev = info->priv;
 
     if (ft1000_flarion_cnt == 0) {
-        info->appcnt--;
+        ft1000dev->appcnt--;
         return (-EBADF);
     }
 
     // Search for matching file object
     for (i=0; i<MAX_NUM_APP; i++) {
-        if ( info->app_info[i].fileobject == &file->f_owner) {
-            //DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", info->app_info[i].app_id);
+        if ( ft1000dev->app_info[i].fileobject == &file->f_owner) {
+            //DEBUG("FT1000:ft1000_ioctl: Message is for AppId = %d\n", ft1000dev->app_info[i].app_id);
             break;
         }
     }
@@ -765,17 +766,17 @@ static int ft1000_release (struct inode *inode, struct file *file)
     if (i==MAX_NUM_APP)
 	    return 0;
 
-    while (list_empty(&info->app_info[i].app_sqlist) == 0) {
+    while (list_empty(&ft1000dev->app_info[i].app_sqlist) == 0) {
         DEBUG("Remove and free memory queue up on slow queue\n");
-        pdpram_blk = list_entry(info->app_info[i].app_sqlist.next, struct dpram_blk, list);
+        pdpram_blk = list_entry(ft1000dev->app_info[i].app_sqlist.next, struct dpram_blk, list);
         list_del(&pdpram_blk->list);
         ft1000_free_buffer(pdpram_blk, &freercvpool);
     }
 
     // initialize application information
-    info->appcnt--;
-    DEBUG("ft1000_chdev:%s:appcnt = %d\n", __FUNCTION__, info->appcnt);
-    info->app_info[i].fileobject = NULL;
+    ft1000dev->appcnt--;
+    DEBUG("ft1000_chdev:%s:appcnt = %d\n", __FUNCTION__, ft1000dev->appcnt);
+    ft1000dev->app_info[i].fileobject = NULL;
 
     return 0;
 }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 1972b72..cc00e94 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -188,7 +188,6 @@ static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
 	u16 handshake;
 	int loopcnt;
 	u32 status = 0;
-	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
 	loopcnt = 0;
 
@@ -196,10 +195,10 @@ static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
 		/* Need to clear downloader doorbell if Hartley ASIC */
 		status = ft1000_write_register(ft1000dev,  FT1000_DB_DNLD_RX,
 						FT1000_REG_DOORBELL);
-		if (pft1000info->fcodeldr) {
+		if (ft1000dev->fcodeldr) {
 			DEBUG(" get_handshake: fcodeldr is %d\n",
-				pft1000info->fcodeldr);
-			pft1000info->fcodeldr = 0;
+				ft1000dev->fcodeldr);
+			ft1000dev->fcodeldr = 0;
 			status = check_usb_db(ft1000dev);
 			if (status != STATUS_SUCCESS) {
 				DEBUG("get_handshake: check_usb_db failed\n");
@@ -270,29 +269,28 @@ static u16 get_handshake_usb(struct ft1000_device *ft1000dev, u16 expected_value
 	u16 temp;
 	u32 status = 0;
 
-	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 	loopcnt = 0;
 	handshake = 0;
 
 	while (loopcnt < 100) {
-		if (pft1000info->usbboot == 2) {
+		if (ft1000dev->usbboot == 2) {
 			status = ft1000_read_dpram32(ft1000dev, 0,
-					(u8 *)&(pft1000info->tempbuf[0]), 64);
+					(u8 *)&(ft1000dev->tempbuf[0]), 64);
 			for (temp = 0; temp < 16; temp++) {
 				DEBUG("tempbuf %d = 0x%x\n", temp,
-					pft1000info->tempbuf[temp]);
+					ft1000dev->tempbuf[temp]);
 			}
 			status = ft1000_read_dpram16(ft1000dev,
 						DWNLD_MAG1_HANDSHAKE_LOC,
 						(u8 *)&handshake, 1);
 			DEBUG("handshake from read_dpram16 = 0x%x\n",
 				handshake);
-			if (pft1000info->dspalive == pft1000info->tempbuf[6]) {
+			if (ft1000dev->dspalive == ft1000dev->tempbuf[6]) {
 				handshake = 0;
 			} else {
-				handshake = pft1000info->tempbuf[1];
-				pft1000info->dspalive =
-						pft1000info->tempbuf[6];
+				handshake = ft1000dev->tempbuf[1];
+				ft1000dev->dspalive =
+						ft1000dev->tempbuf[6];
 			}
 		} else {
 			status = ft1000_read_dpram16(ft1000dev,
@@ -336,9 +334,8 @@ static u16 get_request_type(struct ft1000_device *ft1000dev)
 	u32 status;
 	u16 tempword;
 	u32 tempx;
-	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
-	if (pft1000info->bootmode == 1) {
+	if (ft1000dev->bootmode == 1) {
 		status = fix_ft1000_read_dpram32(ft1000dev,
 				DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
 		tempx = ntohl(tempx);
@@ -360,16 +357,15 @@ static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
 	u32 status;
 	u16 tempword;
 	u32 tempx;
-	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
-	if (pft1000info->bootmode == 1) {
+	if (ft1000dev->bootmode == 1) {
 		status = fix_ft1000_read_dpram32(ft1000dev,
 				DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
 		tempx = ntohl(tempx);
 	} else {
-		if (pft1000info->usbboot == 2) {
-			tempx = pft1000info->tempbuf[2];
-			tempword = pft1000info->tempbuf[3];
+		if (ft1000dev->usbboot == 2) {
+			tempx = ft1000dev->tempbuf[2];
+			tempword = ft1000dev->tempbuf[3];
 		} else {
 			tempx = 0;
 			status = ft1000_read_dpram16(ft1000dev,
@@ -401,9 +397,8 @@ static long get_request_value(struct ft1000_device *ft1000dev)
 	u32 value;
 	u16 tempword;
 	u32 status;
-	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
-	if (pft1000info->bootmode == 1) {
+	if (ft1000dev->bootmode == 1) {
 		status = fix_ft1000_read_dpram32(ft1000dev,
 				DWNLD_MAG1_SIZE_LOC, (u8 *)&value);
 		value = ntohl(value);
@@ -507,7 +502,6 @@ static u32 write_blk (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFi
    u16 tempword;
    u16 tempbuffer[64];
    u16 resultbuffer[64];
-	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
    //DEBUG("FT1000:download:start word_length = %d\n",(int)word_length);
    dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
@@ -548,7 +542,7 @@ static u32 write_blk (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFi
               //DEBUG("write_blk: loopcnt is %d\n", loopcnt);
               //DEBUG("write_blk: bootmode = %d\n", bootmode);
               //DEBUG("write_blk: dpram = %x\n", dpram);
-	      if (pft1000info->bootmode == 0)
+	      if (ft1000dev->bootmode == 0)
 	      {
 		 if (dpram >= 0x3F4)
                      Status = ft1000_write_dpram32 (ft1000dev, dpram, (u8 *)&tempbuffer[0], 8);
@@ -718,9 +712,9 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 
 	DEBUG("Entered   scram_dnldr...\n");
 
-	pft1000info->fcodeldr = 0;
-	pft1000info->usbboot = 0;
-	pft1000info->dspalive = 0xffff;
+	ft1000dev->fcodeldr = 0;
+	ft1000dev->usbboot = 0;
+	ft1000dev->dspalive = 0xffff;
 
 	//
 	// Get version id of file, at first 4 bytes of file, for newer files.
@@ -745,7 +739,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 		switch (state) {
 		case STATE_START_DWNLD:
 			DEBUG("FT1000:STATE_START_DWNLD\n");
-			if (pft1000info->usbboot)
+			if (ft1000dev->usbboot)
 				handshake =
 				    get_handshake_usb(ft1000dev,
 						      HANDSHAKE_DSP_BL_READY);
@@ -771,7 +765,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 
 		case STATE_BOOT_DWNLD:
 			DEBUG("FT1000:STATE_BOOT_DWNLD\n");
-			pft1000info->bootmode = 1;
+			ft1000dev->bootmode = 1;
 			handshake = get_handshake(ft1000dev, HANDSHAKE_REQUEST);
 			if (handshake == HANDSHAKE_REQUEST) {
 				/*
@@ -797,7 +791,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 					//DEBUG("FT1000:download:s_file = 0x%8x\n", (int)s_file);
 					//DEBUG("FT1000:download:c_file = 0x%8x\n", (int)c_file);
 					state = STATE_CODE_DWNLD;
-					pft1000info->fcodeldr = 1;
+					ft1000dev->fcodeldr = 1;
 					break;
 				case REQUEST_CODE_SEGMENT:
 					//DEBUG("FT1000:REQUEST_CODE_SEGMENT\n");
@@ -842,7 +836,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 					status = STATUS_FAILURE;
 					break;
 				}
-				if (pft1000info->usbboot)
+				if (ft1000dev->usbboot)
 					put_handshake_usb(ft1000dev,
 							  HANDSHAKE_RESPONSE);
 				else
@@ -858,8 +852,8 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 
 		case STATE_CODE_DWNLD:
 			//DEBUG("FT1000:STATE_CODE_DWNLD\n");
-			pft1000info->bootmode = 0;
-			if (pft1000info->usbboot)
+			ft1000dev->bootmode = 0;
+			if (ft1000dev->usbboot)
 				handshake =
 				    get_handshake_usb(ft1000dev,
 						      HANDSHAKE_REQUEST);
@@ -870,7 +864,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 				/*
 				 * Get type associated with the request.
 				 */
-				if (pft1000info->usbboot)
+				if (ft1000dev->usbboot)
 					request =
 					    get_request_type_usb(ft1000dev);
 				else
@@ -916,7 +910,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 					}
 					break;
 				case REQUEST_DONE_CL:
-					pft1000info->usbboot = 3;
+					ft1000dev->usbboot = 3;
 					/* Reposition ptrs to beginning of provisioning section */
 					s_file =
 					    (u16 *) (pFileStart +
@@ -965,9 +959,9 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 
 					write_blk_fifo(ft1000dev, &s_file,
 						       &c_file, word_length);
-					if (pft1000info->usbboot == 0)
-						pft1000info->usbboot++;
-					if (pft1000info->usbboot == 1) {
+					if (ft1000dev->usbboot == 0)
+						ft1000dev->usbboot++;
+					if (ft1000dev->usbboot == 1) {
 						tempword = 0;
 						ft1000_write_dpram16(ft1000dev,
 								     DWNLD_MAG1_PS_HDR_LOC,
@@ -1117,7 +1111,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
 					status = STATUS_FAILURE;
 					break;
 				}
-				if (pft1000info->usbboot)
+				if (ft1000dev->usbboot)
 					put_handshake_usb(ft1000dev,
 							  HANDSHAKE_RESPONSE);
 				else
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index b0a4211..f968c6a 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -29,7 +29,7 @@
 
 //#define JDEBUG
 
-static int ft1000_reset(struct net_device *ft1000dev);
+static int ft1000_reset(void *ft1000dev);
 static int ft1000_submit_rx_urb(struct ft1000_info *info);
 static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int ft1000_open (struct net_device *dev);
@@ -588,7 +588,7 @@ int dsp_reload(struct ft1000_device *ft1000dev)
 static void ft1000_reset_asic(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
-	struct ft1000_device *ft1000dev = info->pFt1000Dev;
+	struct ft1000_device *ft1000dev = info->priv;
 	u16 tempword;
 
 	DEBUG("ft1000_hw:ft1000_reset_asic called\n");
@@ -627,15 +627,15 @@ static void ft1000_reset_asic(struct net_device *dev)
 static int ft1000_reset_card(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
-	struct ft1000_device *ft1000dev = info->pFt1000Dev;
+	struct ft1000_device *ft1000dev = info->priv;
 	u16 tempword;
 	struct prov_record *ptr;
 
 	DEBUG("ft1000_hw:ft1000_reset_card called.....\n");
 
-	info->fCondResetPend = 1;
+	ft1000dev->fCondResetPend = 1;
 	info->CardReady = 0;
-	info->fProvComplete = 0;
+	ft1000dev->fProvComplete = 0;
 
 	/* Make sure we free any memory reserve for provisioning */
 	while (list_empty(&info->prov_list) == 0) {
@@ -666,7 +666,7 @@ static int ft1000_reset_card(struct net_device *dev)
 
 	info->CardReady = 1;
 
-	info->fCondResetPend = 0;
+	ft1000dev->fCondResetPend = 0;
 
 	return TRUE;
 }
@@ -731,8 +731,8 @@ int init_ft1000_netdev(struct ft1000_device *ft1000dev)
 			goto err_net;
 		}
 
-		pInfo->CardNumber = gCardIndex;
-		DEBUG("card number = %d\n", pInfo->CardNumber);
+		ft1000dev->CardNumber = gCardIndex;
+		DEBUG("card number = %d\n", ft1000dev->CardNumber);
 	} else {
 		printk(KERN_ERR "ft1000: Invalid device name\n");
 		ret_val = -ENXIO;
@@ -742,27 +742,27 @@ int init_ft1000_netdev(struct ft1000_device *ft1000dev)
 	memset(&pInfo->stats, 0, sizeof(struct net_device_stats));
 
 	spin_lock_init(&pInfo->dpram_lock);
-	pInfo->pFt1000Dev = ft1000dev;
+	pInfo->priv = ft1000dev;
 	pInfo->DrvErrNum = 0;
 	pInfo->registered = 1;
 	pInfo->ft1000_reset = ft1000_reset;
 	pInfo->mediastate = 0;
 	pInfo->fifo_cnt = 0;
-	pInfo->DeviceCreated = FALSE;
+	ft1000dev->DeviceCreated = FALSE;
 	pInfo->CardReady = 0;
 	pInfo->DSP_TIME[0] = 0;
 	pInfo->DSP_TIME[1] = 0;
 	pInfo->DSP_TIME[2] = 0;
 	pInfo->DSP_TIME[3] = 0;
-	pInfo->fAppMsgPend = 0;
-	pInfo->fCondResetPend = 0;
-	pInfo->usbboot = 0;
-	pInfo->dspalive = 0;
-	memset(&pInfo->tempbuf[0], 0, sizeof(pInfo->tempbuf));
+	ft1000dev->fAppMsgPend = 0;
+	ft1000dev->fCondResetPend = 0;
+	ft1000dev->usbboot = 0;
+	ft1000dev->dspalive = 0;
+	memset(&ft1000dev->tempbuf[0], 0, sizeof(ft1000dev->tempbuf));
 
 	INIT_LIST_HEAD(&pInfo->prov_list);
 
-	INIT_LIST_HEAD(&pInfo->nodes.list);
+	INIT_LIST_HEAD(&ft1000dev->nodes.list);
 
 #ifdef HAVE_NET_DEVICE_OPS
 	netdev->netdev_ops = &ftnet_ops;
@@ -863,7 +863,7 @@ int reg_ft1000_netdev(struct ft1000_device *ft1000dev,
 	return 0;
 }
 
-static int ft1000_reset(struct net_device *dev)
+int ft1000_reset(void *dev)
 {
 	ft1000_reset_card(dev);
 	return 0;
@@ -911,7 +911,7 @@ static void ft1000_usb_transmit_complete(struct urb *urb)
 static int ft1000_copy_down_pkt(struct net_device *netdev, u8 * packet, u16 len)
 {
 	struct ft1000_info *pInfo = netdev_priv(netdev);
-	struct ft1000_device *pFt1000Dev = pInfo->pFt1000Dev;
+	struct ft1000_device *pFt1000Dev = pInfo->priv;
 
 	int count, ret;
 	u8 *t;
@@ -990,7 +990,7 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 * packet, u16 len)
 static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ft1000_info *pInfo = netdev_priv(dev);
-	struct ft1000_device *pFt1000Dev = pInfo->pFt1000Dev;
+	struct ft1000_device *pFt1000Dev = pInfo->priv;
 	u8 *pdata;
 	int maxlen, pipe;
 
@@ -1048,7 +1048,7 @@ err:
 static int ft1000_copy_up_pkt(struct urb *urb)
 {
 	struct ft1000_info *info = urb->context;
-	struct ft1000_device *ft1000dev = info->pFt1000Dev;
+	struct ft1000_device *ft1000dev = info->priv;
 	struct net_device *net = ft1000dev->net;
 
 	u16 tempword;
@@ -1143,7 +1143,7 @@ static int ft1000_copy_up_pkt(struct urb *urb)
 static int ft1000_submit_rx_urb(struct ft1000_info *info)
 {
 	int result;
-	struct ft1000_device *pFt1000Dev = info->pFt1000Dev;
+	struct ft1000_device *pFt1000Dev = info->priv;
 
 	if (pFt1000Dev->status & FT1000_STATUS_CLOSING) {
 		DEBUG("network driver is closed, return\n");
@@ -1189,8 +1189,6 @@ static int ft1000_open(struct net_device *dev)
 	struct timeval tv;
 	int ret;
 
-	DEBUG("ft1000_open is called for card %d\n", pInfo->CardNumber);
-
 	pInfo->stats.rx_bytes = 0;
 	pInfo->stats.tx_bytes = 0;
 	pInfo->stats.rx_packets = 0;
@@ -1225,7 +1223,7 @@ static int ft1000_open(struct net_device *dev)
 int ft1000_close(struct net_device *net)
 {
 	struct ft1000_info *pInfo = netdev_priv(net);
-	struct ft1000_device *ft1000dev = pInfo->pFt1000Dev;
+	struct ft1000_device *ft1000dev = pInfo->priv;
 
 	ft1000dev->status |= FT1000_STATUS_CLOSING;
 
@@ -1263,9 +1261,8 @@ static int ft1000_chkcard(struct ft1000_device *dev)
 {
 	u16 tempword;
 	u16 status;
-	struct ft1000_info *info = netdev_priv(dev->net);
 
-	if (info->fCondResetPend) {
+	if (dev->fCondResetPend) {
 		DEBUG
 		    ("ft1000_hw:ft1000_chkcard:Card is being reset, return FALSE\n");
 		return TRUE;
@@ -1453,7 +1450,7 @@ static int ft1000_dsp_prov(void *arg)
 
 	msleep(100);
 
-	info->fProvComplete = 1;
+	dev->fProvComplete = 1;
 	info->CardReady = 1;
 
 	return STATUS_SUCCESS;
@@ -1510,7 +1507,7 @@ static int ft1000_proc_drvmsg(struct ft1000_device *dev, u16 size)
 				if (pmediamsg->state) {
 					DEBUG("Media is up\n");
 					if (info->mediastate == 0) {
-						if (info->NetDevRegDone) {
+						if (dev->NetDevRegDone) {
 							netif_wake_queue(dev->
 									 net);
 						}
@@ -1520,7 +1517,7 @@ static int ft1000_proc_drvmsg(struct ft1000_device *dev, u16 size)
 					DEBUG("Media is down\n");
 					if (info->mediastate == 1) {
 						info->mediastate = 0;
-						if (info->NetDevRegDone) {
+						if (dev->NetDevRegDone) {
 						}
 						info->ConTm = 0;
 					}
@@ -1579,12 +1576,12 @@ static int ft1000_proc_drvmsg(struct ft1000_device *dev, u16 size)
 			 * Send provisioning data to DSP
 			 */
 			if (list_empty(&info->prov_list) == 0) {
-				info->fProvComplete = 0;
+				dev->fProvComplete = 0;
 				status = ft1000_dsp_prov(dev);
 				if (status != STATUS_SUCCESS)
 					goto out;
 			} else {
-				info->fProvComplete = 1;
+				dev->fProvComplete = 1;
 				status =
 				    ft1000_write_register(dev, FT1000_DB_HB,
 							  FT1000_REG_DOORBELL);
@@ -1617,7 +1614,7 @@ static int ft1000_proc_drvmsg(struct ft1000_device *dev, u16 size)
 	case DSP_GET_INFO:{
 			DEBUG("FT1000:drivermsg:Got DSP_GET_INFO\n");
 			/* copy dsp info block to dsp */
-			info->DrvMsgPend = 1;
+			dev->DrvMsgPend = 1;
 			/* allow any outstanding ioctl to finish */
 			mdelay(10);
 			status =
@@ -1679,7 +1676,7 @@ static int ft1000_proc_drvmsg(struct ft1000_device *dev, u16 size)
 			status =
 			    ft1000_write_register(dev, FT1000_DB_DPRAM_TX,
 						  FT1000_REG_DOORBELL);
-			info->DrvMsgPend = 0;
+			dev->DrvMsgPend = 0;
 
 			break;
 		}
@@ -1687,7 +1684,7 @@ static int ft1000_proc_drvmsg(struct ft1000_device *dev, u16 size)
 	case GET_DRV_ERR_RPT_MSG:{
 			DEBUG("FT1000:drivermsg:Got GET_DRV_ERR_RPT_MSG\n");
 			/* copy driver error message to dsp */
-			info->DrvMsgPend = 1;
+			dev->DrvMsgPend = 1;
 			/* allow any outstanding ioctl to finish */
 			mdelay(10);
 			status =
@@ -1747,7 +1744,7 @@ static int ft1000_proc_drvmsg(struct ft1000_device *dev, u16 size)
 						 (u16) (0x0012 + PSEUDOSZ));
 				info->DrvErrNum = 0;
 			}
-			info->DrvMsgPend = 0;
+			dev->DrvMsgPend = 0;
 
 			break;
 		}
@@ -1816,8 +1813,8 @@ int ft1000_poll(void* dev_id) {
                         // Check which application has registered for dsp broadcast messages
 
     	    	        for (i=0; i<MAX_NUM_APP; i++) {
-        	           if ( (info->app_info[i].DspBCMsgFlag) && (info->app_info[i].fileobject) &&
-                                         (info->app_info[i].NumOfMsg < MAX_MSG_LIMIT)  )
+        	           if ( (dev->app_info[i].DspBCMsgFlag) && (dev->app_info[i].fileobject) &&
+                                         (dev->app_info[i].NumOfMsg < MAX_MSG_LIMIT)  )
 			   {
 			       nxtph = FT1000_DPRAM_RX_BASE + 2;
 			       pdpram_blk = ft1000_get_buffer (&freercvpool);
@@ -1825,15 +1822,15 @@ int ft1000_poll(void* dev_id) {
 			           if ( ft1000_receive_cmd(dev, pdpram_blk->pbuffer, MAX_CMD_SQSIZE, &nxtph) ) {
 					ppseudo_hdr = (struct pseudo_hdr *)pdpram_blk->pbuffer;
 				       // Put message into the appropriate application block
-				       info->app_info[i].nRxMsg++;
+				       dev->app_info[i].nRxMsg++;
 				       spin_lock_irqsave(&free_buff_lock, flags);
-				       list_add_tail(&pdpram_blk->list, &info->app_info[i].app_sqlist);
-				       info->app_info[i].NumOfMsg++;
+				       list_add_tail(&pdpram_blk->list, &dev->app_info[i].app_sqlist);
+				       dev->app_info[i].NumOfMsg++;
 				       spin_unlock_irqrestore(&free_buff_lock, flags);
-				       wake_up_interruptible(&info->app_info[i].wait_dpram_msg);
+				       wake_up_interruptible(&dev->app_info[i].wait_dpram_msg);
                                    }
                                    else {
-				       info->app_info[i].nRxMsgMiss++;
+				       dev->app_info[i].nRxMsgMiss++;
 				       // Put memory back to free pool
 				       ft1000_free_buffer(pdpram_blk, &freercvpool);
 				       DEBUG("pdpram_blk::ft1000_get_buffer NULL\n");
@@ -1841,7 +1838,7 @@ int ft1000_poll(void* dev_id) {
                                }
                                else {
                                    DEBUG("Out of memory in free receive command pool\n");
-                                   info->app_info[i].nRxMsgMiss++;
+                                   dev->app_info[i].nRxMsgMiss++;
                                }
                            }
 	                }
@@ -1854,7 +1851,7 @@ int ft1000_poll(void* dev_id) {
 				ppseudo_hdr = (struct pseudo_hdr *)pdpram_blk->pbuffer;
                                // Search for correct application block
                                for (i=0; i<MAX_NUM_APP; i++) {
-                                   if (info->app_info[i].app_id == ppseudo_hdr->portdest) {
+                                   if (dev->app_info[i].app_id == ppseudo_hdr->portdest) {
                                        break;
                                    }
                                }
@@ -1865,15 +1862,15 @@ int ft1000_poll(void* dev_id) {
                                    ft1000_free_buffer(pdpram_blk, &freercvpool);
                                }
                                else {
-                                   if (info->app_info[i].NumOfMsg > MAX_MSG_LIMIT) {
+                                   if (dev->app_info[i].NumOfMsg > MAX_MSG_LIMIT) {
 	                               // Put memory back to free pool
 	                               ft1000_free_buffer(pdpram_blk, &freercvpool);
                                    }
                                    else {
-                                       info->app_info[i].nRxMsg++;
+                                       dev->app_info[i].nRxMsg++;
                                        // Put message into the appropriate application block
-                                       list_add_tail(&pdpram_blk->list, &info->app_info[i].app_sqlist);
-            			       info->app_info[i].NumOfMsg++;
+                                       list_add_tail(&pdpram_blk->list, &dev->app_info[i].app_sqlist);
+            			       dev->app_info[i].NumOfMsg++;
                                    }
                                }
                            }
@@ -1933,7 +1930,7 @@ int ft1000_poll(void* dev_id) {
         else if (tempword & FT1000_DB_COND_RESET) {
             DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type:  FT1000_DB_COND_RESET\n");
 
-	    if (info->fAppMsgPend == 0) {
+	    if (dev->fAppMsgPend == 0) {
                // Reset ASIC and DSP
 
                 status    = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER0, (u8 *)&(info->DSP_TIME[0]), FT1000_MAG_DSP_TIMER0_INDX);
@@ -1946,8 +1943,8 @@ int ft1000_poll(void* dev_id) {
                 info->ft1000_reset(dev->net);
             }
             else {
-                info->fProvComplete = 0;
-                info->fCondResetPend = 1;
+                dev->fProvComplete = 0;
+                dev->fCondResetPend = 1;
             }
 
             ft1000_write_register(dev, FT1000_DB_COND_RESET, FT1000_REG_DOORBELL);
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index 5ae3967..c290b66 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -94,11 +94,11 @@ ft1000ReadProc(char *page, char **start, off_t off, int count, int *eof,
 
 
 	if (info->ProgConStat != 0xFF) {
-		ft1000_read_dpram16(info->pFt1000Dev, FT1000_MAG_DSP_LED,
+		ft1000_read_dpram16(info->priv, FT1000_MAG_DSP_LED,
 			   (u8 *)&ledStat, FT1000_MAG_DSP_LED_INDX);
 		info->LedStat = ntohs(ledStat);
 
-		ft1000_read_dpram16(info->pFt1000Dev, FT1000_MAG_DSP_CON_STATE,
+		ft1000_read_dpram16(info->priv, FT1000_MAG_DSP_CON_STATE,
 			(u8 *)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
 		info->ConStat = ntohs(conStat);
 		do_gettimeofday(&tv);
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 79482ac..5aed8f0 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -173,11 +173,11 @@ static int ft1000_probe(struct usb_interface *interface,
 	}
 
 	gPollingfailed = FALSE;
-	pft1000info->pPollThread =
+	ft1000dev->pPollThread =
 	    kthread_run(ft1000_poll_thread, ft1000dev, "ft1000_poll");
 
-	if (IS_ERR(pft1000info->pPollThread)) {
-		ret = PTR_ERR(pft1000info->pPollThread);
+	if (IS_ERR(ft1000dev->pPollThread)) {
+		ret = PTR_ERR(ft1000dev->pPollThread);
 		goto err_load;
 	}
 
@@ -202,7 +202,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	if (ret)
 		goto err_proc;
 
-	pft1000info->NetDevRegDone = 1;
+	ft1000dev->NetDevRegDone = 1;
 
 	return 0;
 
@@ -210,7 +210,7 @@ err_proc:
 	unregister_netdev(ft1000dev->net);
 	free_netdev(ft1000dev->net);
 err_thread:
-	kthread_stop(pft1000info->pPollThread);
+	kthread_stop(ft1000dev->pPollThread);
 err_load:
 	kfree(pFileStart);
 err_fw:
@@ -221,6 +221,7 @@ err_fw:
 static void ft1000_disconnect(struct usb_interface *interface)
 {
 	struct ft1000_info *pft1000info;
+	struct ft1000_device *ft1000dev;
 
 	DEBUG("ft1000_disconnect is called\n");
 
@@ -228,28 +229,29 @@ static void ft1000_disconnect(struct usb_interface *interface)
 	DEBUG("In disconnect pft1000info=%p\n", pft1000info);
 
 	if (pft1000info) {
+		ft1000dev = pft1000info->priv;
 		ft1000_cleanup_proc(pft1000info);
-		if (pft1000info->pPollThread)
-			kthread_stop(pft1000info->pPollThread);
+		if (ft1000dev->pPollThread)
+			kthread_stop(ft1000dev->pPollThread);
 
 		DEBUG("ft1000_disconnect: threads are terminated\n");
 
-		if (pft1000info->pFt1000Dev->net) {
+		if (ft1000dev->net) {
 			DEBUG("ft1000_disconnect: destroy char driver\n");
-			ft1000_destroy_dev(pft1000info->pFt1000Dev->net);
-			unregister_netdev(pft1000info->pFt1000Dev->net);
+			ft1000_destroy_dev(ft1000dev->net);
+			unregister_netdev(ft1000dev->net);
 			DEBUG
 			    ("ft1000_disconnect: network device unregisterd\n");
-			free_netdev(pft1000info->pFt1000Dev->net);
+			free_netdev(ft1000dev->net);
 
 		}
 
-		usb_free_urb(pft1000info->pFt1000Dev->rx_urb);
-		usb_free_urb(pft1000info->pFt1000Dev->tx_urb);
+		usb_free_urb(ft1000dev->rx_urb);
+		usb_free_urb(ft1000dev->tx_urb);
 
 		DEBUG("ft1000_disconnect: urb freed\n");
 
-		kfree(pft1000info->pFt1000Dev);
+		kfree(ft1000dev);
 	}
 	kfree(pFileStart);
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 51c0847..47b83af 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -59,6 +59,13 @@ struct app_info_block {
 
 #define MAX_BUF_SIZE            4096
 
+struct ft1000_debug_dirs {
+	struct list_head list;
+	struct dentry *dent;
+	struct dentry *file;
+	int int_number;
+};
+
 struct ft1000_device
 {
 	struct usb_device *dev;
@@ -75,75 +82,25 @@ struct ft1000_device
 	u8 bulk_in_endpointAddr;
 	u8 bulk_out_endpointAddr;
 
-	//struct ft1000_ethernet_configuration configuration;
-
-//	struct net_device_stats stats; //mbelian
-} __attribute__ ((packed));
-
-struct ft1000_debug_dirs {
-	struct list_head list;
-	struct dentry *dent;
-	struct dentry *file;
-	int int_number;
-};
-
-struct ft1000_info {
-    struct ft1000_device *pFt1000Dev;
-    struct net_device_stats stats;
-
-    struct task_struct *pPollThread;
-
-    unsigned char fcodeldr;
-    unsigned char bootmode;
+	struct task_struct *pPollThread;
+	unsigned char fcodeldr;
+	unsigned char bootmode;
 	unsigned char usbboot;
-    unsigned short dspalive;
-    u16 ASIC_ID;
-    bool fProvComplete;
-    bool fCondResetPend;
-    bool fAppMsgPend;
-    u16 DrvErrNum;
-    u16 AsicID;
-    int DspAsicReset;
-    int DeviceCreated;
-    int CardReady;
-    int NetDevRegDone;
-    u8 CardNumber;
-    u8 DeviceName[15];
-    struct ft1000_debug_dirs nodes;
-    int registered;
-    int mediastate;
-    u8 squeseqnum;                 // sequence number on slow queue
-    spinlock_t dpram_lock;
-    spinlock_t fifo_lock;
-    u16 fifo_cnt;
-    u8 DspVer[DSPVERSZ];        // DSP version number
-    u8 HwSerNum[HWSERNUMSZ];    // Hardware Serial Number
-    u8 Sku[SKUSZ];              // SKU
-    u8 eui64[EUISZ];            // EUI64
-    time_t ConTm;               // Connection Time
-    u8 ProductMode[MODESZ];
-    u8 RfCalVer[CALVERSZ];
-    u8 RfCalDate[CALDATESZ];
-    u16 DSP_TIME[4];
-    u16 LedStat;	//mbelian
-    u16 ConStat;	//mbelian
-    u16 ProgConStat;
-    struct list_head prov_list;
-    int appcnt;
+	unsigned short dspalive;
+	bool fProvComplete;
+	bool fCondResetPend;
+	bool fAppMsgPend;
+	int DeviceCreated;
+	int NetDevRegDone;
+	u8 CardNumber;
+	u8 DeviceName[15];
+	struct ft1000_debug_dirs nodes;
+	spinlock_t fifo_lock;
+	int appcnt;
 	struct app_info_block app_info[MAX_NUM_APP];
-    u16 DSPInfoBlklen;
-    u16 DrvMsgPend;
-    int (*ft1000_reset)(struct net_device *dev);
-    u16 DSPInfoBlk[MAX_DSP_SESS_REC];
-    union {
-        u16 Rec[MAX_DSP_SESS_REC];
-        u32 MagRec[MAX_DSP_SESS_REC/2];
-    } DSPSess;
+	u16 DrvMsgPend;
 	unsigned short tempbuf[32];
-	char netdevname[IFNAMSIZ];
-	struct proc_dir_entry *ft1000_proc_dir; //mbelian
-};
-
+} __attribute__ ((packed));
 
 struct dpram_blk {
     struct list_head list;
diff --git a/drivers/staging/ft1000/ft1000.h b/drivers/staging/ft1000/ft1000.h
index 03baa57..175abfa 100644
--- a/drivers/staging/ft1000/ft1000.h
+++ b/drivers/staging/ft1000/ft1000.h
@@ -250,3 +250,38 @@ struct prov_record {
 	struct list_head list;
 	u8 *pprov_data;
 };
+
+struct ft1000_info {
+	void *priv;
+	struct net_device_stats stats;
+	u16 DrvErrNum;
+	u16 AsicID;
+	int CardReady;
+	int registered;
+	int mediastate;
+	u8 squeseqnum;			/* sequence number on slow queue */
+	spinlock_t dpram_lock;
+	u16 fifo_cnt;
+	u8 DspVer[DSPVERSZ];		/* DSP version number */
+	u8 HwSerNum[HWSERNUMSZ];	/* Hardware Serial Number */
+	u8 Sku[SKUSZ];			/* SKU */
+	u8 eui64[EUISZ];		/* EUI64 */
+	time_t ConTm;			/* Connection Time */
+	u8 ProductMode[MODESZ];
+	u8 RfCalVer[CALVERSZ];
+	u8 RfCalDate[CALDATESZ];
+	u16 DSP_TIME[4];
+	u16 LedStat;
+	u16 ConStat;
+	u16 ProgConStat;
+	struct list_head prov_list;
+	u16 DSPInfoBlklen;
+	int (*ft1000_reset)(void *);
+	u16 DSPInfoBlk[MAX_DSP_SESS_REC];
+	union {
+		u16 Rec[MAX_DSP_SESS_REC];
+		u32 MagRec[MAX_DSP_SESS_REC/2];
+	} DSPSess;
+	struct proc_dir_entry *ft1000_proc_dir;
+	char netdevname[IFNAMSIZ];
+};
-- 
Ondrej Zary

