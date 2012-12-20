Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2LTEP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 23:15:58 -0500
Received: from intranet.asianux.com ([58.214.24.6]:52210 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab2LTEPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 23:15:52 -0500
X-Spam-Score: -100.7
Message-ID: <50D29129.6020003@asianux.com>
Date: Thu, 20 Dec 2012 12:16:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Paul Fulghum <paulkf@microgate.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: [PATCH] drivers/tty/synclink: let receive buffer size match max frame
 size
References: <50B8DDAC.8070901@microgate.com> <50B90D0D.9040401@microgate.com> <20121202151332.3b6a6504@pyramind.ukuu.org.uk> <F6B8A325-7DBF-4623-B16C-CDC5642EFD16@microgate.com> <20121202181057.097012c6@pyramind.ukuu.org.uk> <989CB961-79F8-479B-B16C-41358A60AC94@microgate.com> <50BC0C84.4060802@asianux.com> <50BCCD4C.8050209@microgate.com> <50BEAA0E.9000603@asianux.com> <50D12521.8010808@asianux.com> <20121219040907.GA22719@kroah.com>
In-Reply-To: <20121219040907.GA22719@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By Paul Fulghum:
  Fix call to line discipline receive_buf by synclink drivers.
  Dummy flag buffer argument is ignored by N_HDLC line discipline but might
  be of insufficient size if accessed by a different line discipline
  selected by mistake. flag buffer allocation now matches max size of data
  buffer. Unused char_buf buffers are removed.

By Chen Gang:
  Give a comment for rx_get_buf
    the receive buffer size is DMABUFSIZE limited, which alloc in alloc_bufs
    it is always less than max_frame_size
    so do not need check the length whether larger than max_frame_size.
  Extern the limitation.
    the maxframe parameter (which input from outside) has value limitition
    so define macro in include/linux/synclink.h to extern the limitation
    and use macro instead of hard code numbers in all relative c source files
  Beautify source code:
    for function mgslpc_probe in drivers/char/pcmcia/synclink_cs.c
    use tab instead of 4 spaces for each line header.

  Unit test:
    for "Give a comment for rx_get_buf":
      only a comment, not need test.
      also can reference free_buf, so can confirm our conclusion.
    for "Extern the limitation":
      modify source code, call the relative function when insmod module.
        pass maxframe=6000, for synclink_gt, synclink_cs, synclink, synclinkmp.
        pass maxframe=3000, for synclink_gt, synclink_cs, synclink, synclinkmp.
        pass maxframe=70000, for synclink_gt, synclink_cs, synclink, synclinkmp.
    for "Beautify source code":
      vimdiff the new file and the original file.
        restore the new file to the original file, word by word.
      make sure that we only use tab instead of 4 spaces for each line header.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Paul Fulghum <paulkf@microgate.com>
---
 drivers/char/pcmcia/synclink_cs.c |  102 ++++++++++++++++++++-----------------
 drivers/tty/synclink.c            |   23 ++++++---
 drivers/tty/synclink_gt.c         |   29 ++++++++---
 drivers/tty/synclinkmp.c          |   22 +++++---
 include/linux/synclink.h          |    3 ++
 5 files changed, 111 insertions(+), 68 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index b66eaa0..4f78e30 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -210,7 +210,7 @@ typedef struct _mgslpc_info {
 	char testing_irq;
 	unsigned int init_error;	/* startup error (DIAGS)	*/
 
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
+	char *flag_buf;
 	bool drop_rts_on_tx_done;
 
 	struct	_input_signal_events	input_signal_events;
@@ -514,49 +514,49 @@ static const struct tty_port_operations mgslpc_port_ops = {
 
 static int mgslpc_probe(struct pcmcia_device *link)
 {
-    MGSLPC_INFO *info;
-    int ret;
+	MGSLPC_INFO *info;
+	int ret;
 
-    if (debug_level >= DEBUG_LEVEL_INFO)
-	    printk("mgslpc_attach\n");
-
-    info = kzalloc(sizeof(MGSLPC_INFO), GFP_KERNEL);
-    if (!info) {
-	    printk("Error can't allocate device instance data\n");
-	    return -ENOMEM;
-    }
-
-    info->magic = MGSLPC_MAGIC;
-    tty_port_init(&info->port);
-    info->port.ops = &mgslpc_port_ops;
-    INIT_WORK(&info->task, bh_handler);
-    info->max_frame_size = 4096;
-    info->port.close_delay = 5*HZ/10;
-    info->port.closing_wait = 30*HZ;
-    init_waitqueue_head(&info->status_event_wait_q);
-    init_waitqueue_head(&info->event_wait_q);
-    spin_lock_init(&info->lock);
-    spin_lock_init(&info->netlock);
-    memcpy(&info->params,&default_params,sizeof(MGSL_PARAMS));
-    info->idle_mode = HDLC_TXIDLE_FLAGS;
-    info->imra_value = 0xffff;
-    info->imrb_value = 0xffff;
-    info->pim_value = 0xff;
-
-    info->p_dev = link;
-    link->priv = info;
-
-    /* Initialize the struct pcmcia_device structure */
-
-    ret = mgslpc_config(link);
-    if (ret) {
-	    tty_port_destroy(&info->port);
-	    return ret;
-    }
-
-    mgslpc_add_device(info);
+	if (debug_level >= DEBUG_LEVEL_INFO)
+		printk("mgslpc_attach\n");
 
-    return 0;
+	info = kzalloc(sizeof(MGSLPC_INFO), GFP_KERNEL);
+	if (!info) {
+		printk("Error can't allocate device instance data\n");
+		return -ENOMEM;
+	}
+
+	info->magic = MGSLPC_MAGIC;
+	tty_port_init(&info->port);
+	info->port.ops = &mgslpc_port_ops;
+	INIT_WORK(&info->task, bh_handler);
+	info->max_frame_size = SYNCLINK_MIN_FRAME_SIZE;
+	info->port.close_delay = 5*HZ/10;
+	info->port.closing_wait = 30*HZ;
+	init_waitqueue_head(&info->status_event_wait_q);
+	init_waitqueue_head(&info->event_wait_q);
+	spin_lock_init(&info->lock);
+	spin_lock_init(&info->netlock);
+	memcpy(&info->params,&default_params,sizeof(MGSL_PARAMS));
+	info->idle_mode = HDLC_TXIDLE_FLAGS;
+	info->imra_value = 0xffff;
+	info->imrb_value = 0xffff;
+	info->pim_value = 0xff;
+
+	info->p_dev = link;
+	link->priv = info;
+
+	/* Initialize the struct pcmcia_device structure */
+
+	ret = mgslpc_config(link);
+	if (ret) {
+		tty_port_destroy(&info->port);
+		return ret;
+	}
+
+	mgslpc_add_device(info);
+
+	return 0;
 }
 
 /* Card has been inserted.
@@ -2674,6 +2674,14 @@ static int rx_alloc_buffers(MGSLPC_INFO *info)
 	if (info->rx_buf == NULL)
 		return -ENOMEM;
 
+	/* unused flag buffer to satisfy receive_buf calling interface */
+	info->flag_buf = kzalloc(info->max_frame_size, GFP_KERNEL);
+	if (!info->flag_buf) {
+		kfree(info->rx_buf);
+		info->rx_buf = NULL;
+		return -ENOMEM;
+	}
+
 	rx_reset_buffers(info);
 	return 0;
 }
@@ -2682,6 +2690,8 @@ static void rx_free_buffers(MGSLPC_INFO *info)
 {
 	kfree(info->rx_buf);
 	info->rx_buf = NULL;
+	kfree(info->flag_buf);
+	info->flag_buf = NULL;
 }
 
 static int claim_resources(MGSLPC_INFO *info)
@@ -2728,10 +2738,10 @@ static void mgslpc_add_device(MGSLPC_INFO *info)
 		current_dev->next_device = info;
 	}
 
-	if (info->max_frame_size < 4096)
-		info->max_frame_size = 4096;
-	else if (info->max_frame_size > 65535)
-		info->max_frame_size = 65535;
+	if (info->max_frame_size < SYNCLINK_MIN_FRAME_SIZE)
+		info->max_frame_size = SYNCLINK_MIN_FRAME_SIZE;
+	else if (info->max_frame_size > SYNCLINK_MAX_FRAME_SIZE)
+		info->max_frame_size = SYNCLINK_MAX_FRAME_SIZE;
 
 	printk( "SyncLink PC Card %s:IO=%04X IRQ=%d\n",
 		info->device_name, info->io_base, info->irq_level);
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 9e071f6..94ce422 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -291,8 +291,7 @@ struct mgsl_struct {
 	bool lcr_mem_requested;
 
 	u32 misc_ctrl_value;
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
-	char char_buf[MAX_ASYNC_BUFFER_SIZE];	
+	char *flag_buf;
 	bool drop_rts_on_tx_done;
 
 	bool loopmode_insert_requested;
@@ -3898,7 +3897,13 @@ static int mgsl_alloc_intermediate_rxbuffer_memory(struct mgsl_struct *info)
 	info->intermediate_rxbuffer = kmalloc(info->max_frame_size, GFP_KERNEL | GFP_DMA);
 	if ( info->intermediate_rxbuffer == NULL )
 		return -ENOMEM;
-
+	/* unused flag buffer to satisfy receive_buf calling interface */
+	info->flag_buf = kzalloc(info->max_frame_size, GFP_KERNEL);
+	if (!info->flag_buf) {
+		kfree(info->intermediate_rxbuffer);
+		info->intermediate_rxbuffer = NULL;
+		return -ENOMEM;
+	}
 	return 0;
 
 }	/* end of mgsl_alloc_intermediate_rxbuffer_memory() */
@@ -3917,6 +3922,8 @@ static void mgsl_free_intermediate_rxbuffer_memory(struct mgsl_struct *info)
 {
 	kfree(info->intermediate_rxbuffer);
 	info->intermediate_rxbuffer = NULL;
+	kfree(info->flag_buf);
+	info->flag_buf = NULL;
 
 }	/* end of mgsl_free_intermediate_rxbuffer_memory() */
 
@@ -4237,10 +4244,10 @@ static void mgsl_add_device( struct mgsl_struct *info )
 		current_dev->next_device = info;
 	}
 	
-	if ( info->max_frame_size < 4096 )
-		info->max_frame_size = 4096;
-	else if ( info->max_frame_size > 65535 )
-		info->max_frame_size = 65535;
+	if (info->max_frame_size < SYNCLINK_MIN_FRAME_SIZE)
+		info->max_frame_size = SYNCLINK_MIN_FRAME_SIZE;
+	else if (info->max_frame_size > SYNCLINK_MAX_FRAME_SIZE)
+		info->max_frame_size = SYNCLINK_MAX_FRAME_SIZE;
 	
 	if ( info->bus_type == MGSL_BUS_TYPE_PCI ) {
 		printk( "SyncLink PCI v%d %s: IO=%04X IRQ=%d Mem=%08X,%08X MaxFrameSize=%u\n",
@@ -4286,7 +4293,7 @@ static struct mgsl_struct* mgsl_allocate_device(void)
 		info->port.ops = &mgsl_port_ops;
 		info->magic = MGSL_MAGIC;
 		INIT_WORK(&info->task, mgsl_bh_handler);
-		info->max_frame_size = 4096;
+		info->max_frame_size = SYNCLINK_MIN_FRAME_SIZE;
 		info->port.close_delay = 5*HZ/10;
 		info->port.closing_wait = 30*HZ;
 		init_waitqueue_head(&info->status_event_wait_q);
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index aba1e59..4dda746 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -317,8 +317,7 @@ struct slgt_info {
 	unsigned char *tx_buf;
 	int tx_count;
 
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
-	char char_buf[MAX_ASYNC_BUFFER_SIZE];
+	char *flag_buf;
 	bool drop_rts_on_tx_done;
 	struct	_input_signal_events	input_signal_events;
 
@@ -3355,11 +3354,24 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	return retval;
 }
 
+/*
+ * allocate buffers used for calling line discipline receive_buf
+ * directly in synchronous mode
+ * note: add 5 bytes to max frame size to allow appending
+ * 32-bit CRC and status byte when configured to do so
+ */
 static int alloc_tmp_rbuf(struct slgt_info *info)
 {
 	info->tmp_rbuf = kmalloc(info->max_frame_size + 5, GFP_KERNEL);
 	if (info->tmp_rbuf == NULL)
 		return -ENOMEM;
+	/* unused flag buffer to satisfy receive_buf calling interface */
+	info->flag_buf = kzalloc(info->max_frame_size + 5, GFP_KERNEL);
+	if (!info->flag_buf) {
+		kfree(info->tmp_rbuf);
+		info->tmp_rbuf = NULL;
+		return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -3367,6 +3379,8 @@ static void free_tmp_rbuf(struct slgt_info *info)
 {
 	kfree(info->tmp_rbuf);
 	info->tmp_rbuf = NULL;
+	kfree(info->flag_buf);
+	info->flag_buf = NULL;
 }
 
 /*
@@ -3547,10 +3561,10 @@ static void add_device(struct slgt_info *info)
 		current_dev->next_device = info;
 	}
 
-	if (info->max_frame_size < 4096)
-		info->max_frame_size = 4096;
-	else if (info->max_frame_size > 65535)
-		info->max_frame_size = 65535;
+	if (info->max_frame_size < SYNCLINK_MIN_FRAME_SIZE)
+		info->max_frame_size = SYNCLINK_MIN_FRAME_SIZE;
+	else if (info->max_frame_size > SYNCLINK_MAX_FRAME_SIZE)
+		info->max_frame_size = SYNCLINK_MAX_FRAME_SIZE;
 
 	switch(info->pdev->device) {
 	case SYNCLINK_GT_DEVICE_ID:
@@ -3600,7 +3614,7 @@ static struct slgt_info *alloc_dev(int adapter_num, int port_num, struct pci_dev
 		info->port.ops = &slgt_port_ops;
 		info->magic = MGSL_MAGIC;
 		INIT_WORK(&info->task, bh_handler);
-		info->max_frame_size = 4096;
+		info->max_frame_size = SYNCLINK_MIN_FRAME_SIZE;
 		info->base_clock = 14745600;
 		info->rbuf_fill_level = DMABUFSIZE;
 		info->port.close_delay = 5*HZ/10;
@@ -4778,6 +4792,7 @@ cleanup:
 
 /*
  * pass receive buffer (RAW synchronous mode) to tty layer
+ * the receive buffer size is DMABUFSIZE limited
  * return true if buffer available, otherwise false
  */
 static bool rx_get_buf(struct slgt_info *info)
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index fd43fb6..621c562 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -262,8 +262,7 @@ typedef struct _synclinkmp_info {
 	bool sca_statctrl_requested;
 
 	u32 misc_ctrl_value;
-	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
-	char char_buf[MAX_ASYNC_BUFFER_SIZE];
+	char *flag_buf;
 	bool drop_rts_on_tx_done;
 
 	struct	_input_signal_events	input_signal_events;
@@ -3553,6 +3552,13 @@ static int alloc_tmp_rx_buf(SLMP_INFO *info)
 	info->tmp_rx_buf = kmalloc(info->max_frame_size, GFP_KERNEL);
 	if (info->tmp_rx_buf == NULL)
 		return -ENOMEM;
+	/* unused flag buffer to satisfy receive_buf calling interface */
+	info->flag_buf = kzalloc(info->max_frame_size, GFP_KERNEL);
+	if (!info->flag_buf) {
+		kfree(info->tmp_rx_buf);
+		info->tmp_rx_buf = NULL;
+		return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -3560,6 +3566,8 @@ static void free_tmp_rx_buf(SLMP_INFO *info)
 {
 	kfree(info->tmp_rx_buf);
 	info->tmp_rx_buf = NULL;
+	kfree(info->flag_buf);
+	info->flag_buf = NULL;
 }
 
 static int claim_resources(SLMP_INFO *info)
@@ -3729,10 +3737,10 @@ static void add_device(SLMP_INFO *info)
 		current_dev->next_device = info;
 	}
 
-	if ( info->max_frame_size < 4096 )
-		info->max_frame_size = 4096;
-	else if ( info->max_frame_size > 65535 )
-		info->max_frame_size = 65535;
+	if (info->max_frame_size < SYNCLINK_MIN_FRAME_SIZE)
+		info->max_frame_size = SYNCLINK_MIN_FRAME_SIZE;
+	else if (info->max_frame_size > SYNCLINK_MAX_FRAME_SIZE)
+		info->max_frame_size = SYNCLINK_MAX_FRAME_SIZE;
 
 	printk( "SyncLink MultiPort %s: "
 		"Mem=(%08x %08X %08x %08X) IRQ=%d MaxFrameSize=%u\n",
@@ -3773,7 +3781,7 @@ static SLMP_INFO *alloc_dev(int adapter_num, int port_num, struct pci_dev *pdev)
 		info->port.ops = &port_ops;
 		info->magic = MGSL_MAGIC;
 		INIT_WORK(&info->task, bh_handler);
-		info->max_frame_size = 4096;
+		info->max_frame_size = SYNCLINK_MIN_FRAME_SIZE;
 		info->port.close_delay = 5*HZ/10;
 		info->port.closing_wait = 30*HZ;
 		init_waitqueue_head(&info->status_event_wait_q);
diff --git a/include/linux/synclink.h b/include/linux/synclink.h
index f1405b1..61ac4b2 100644
--- a/include/linux/synclink.h
+++ b/include/linux/synclink.h
@@ -13,6 +13,9 @@
 
 #include <uapi/linux/synclink.h>
 
+#define SYNCLINK_MIN_FRAME_SIZE		4096
+#define SYNCLINK_MAX_FRAME_SIZE		65535
+
 /* provide 32 bit ioctl compatibility on 64 bit systems */
 #ifdef CONFIG_COMPAT
 #include <linux/compat.h>
-- 
1.7.10.4
