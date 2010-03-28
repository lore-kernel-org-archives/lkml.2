Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0C1V5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 17:57:30 -0400
Received: from mail.perches.com ([173.55.12.10]:1184 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab0C1V53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 17:57:29 -0400
Subject: [PATCH] treewide: Add and use ADD_MOD macro
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Mar 2010 14:57:27 -0700
Message-ID: <1269813447.1500.69.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a macro for the somewhat common use of

	(something + value) % value

drivers/net/sundance.c includes a change from
a for(;test;add) loop to while (test) {... add};
because the test uses ADD_MOD

Compile tested only

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h                  |    1 +
 drivers/ata/libata-eh.c                 |    2 +-
 drivers/media/video/ov511.c             |    2 +-
 drivers/media/video/usbvideo/usbvideo.c |    2 +-
 drivers/net/dl2k.c                      |    8 ++++----
 drivers/net/sundance.c                  |    4 ++--
 drivers/pci/dmar.c                      |    6 +++---
 drivers/scsi/3w-9xxx.c                  |    2 +-
 drivers/staging/wavelan/wavelan_cs.c    |   10 +++++-----
 drivers/usb/misc/sisusbvga/sisusb_con.c |    4 ++--
 drivers/video/console/vgacon.c          |    4 ++--
 sound/oss/vwsnd.c                       |    6 +++---
 12 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7f07074..c96b1ac 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -63,6 +63,7 @@ extern const char linux_proc_banner[];
 	(((x) + ((__divisor) / 2)) / (__divisor));	\
 }							\
 )
+#define ADD_MOD(x, y) (((x) + (y)) % (y))
 
 #define _RET_IP_		(unsigned long)__builtin_return_address(0)
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 9f6cfac..23d4544 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -416,7 +416,7 @@ static int ata_ering_map(struct ata_ering *ering,
 		rc = map_fn(ent, arg);
 		if (rc)
 			break;
-		idx = (idx - 1 + ATA_ERING_SIZE) % ATA_ERING_SIZE;
+		idx = ADD_MOD(idx - 1, ATA_ERING_SIZE);
 	} while (idx != ering->cursor);
 
 	return rc;
diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index e0bce8d..5df9bb2 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -3751,7 +3751,7 @@ ov51x_new_frame(struct usb_ov511 *ov, int framenum)
 	/* If we're not grabbing a frame right now and the other frame is */
 	/* ready to be grabbed into, then use it instead */
 	if (ov->curframe == -1) {
-		newnum = (framenum - 1 + OV511_NUMFRAMES) % OV511_NUMFRAMES;
+		newnum = ADD_MOD(framenum - 1, OV511_NUMFRAMES);
 		if (ov->frame[newnum].grabstate == FRAME_READY)
 			framenum = newnum;
 	} else
diff --git a/drivers/media/video/usbvideo/usbvideo.c b/drivers/media/video/usbvideo/usbvideo.c
index 5ac37c6..8220aa0 100644
--- a/drivers/media/video/usbvideo/usbvideo.c
+++ b/drivers/media/video/usbvideo/usbvideo.c
@@ -1926,7 +1926,7 @@ static int usbvideo_NewFrame(struct uvd *uvd, int framenum)
 	 */
 	if (!(uvd->flags & FLAGS_SEPARATE_FRAMES)) {
 		/* This copies previous frame into this one to mask losses */
-		int prev = (framenum - 1 + USBVIDEO_NUMFRAMES) % USBVIDEO_NUMFRAMES;
+		int prev = ADD_MOD(framenum - 1, USBVIDEO_NUMFRAMES);
 		memmove(frame->data, uvd->frame[prev].data, uvd->max_frame_size);
 	} else {
 		if (uvd->flags & FLAGS_CLEAN_FRAMES) {
diff --git a/drivers/net/dl2k.c b/drivers/net/dl2k.c
index b05bad8..a49fd5a 100644
--- a/drivers/net/dl2k.c
+++ b/drivers/net/dl2k.c
@@ -652,8 +652,8 @@ start_xmit (struct sk_buff *skb, struct net_device *dev)
 	/* Schedule ISR */
 	writel(10000, ioaddr + CountDown);
 	np->cur_tx = (np->cur_tx + 1) % TX_RING_SIZE;
-	if ((np->cur_tx - np->old_tx + TX_RING_SIZE) % TX_RING_SIZE
-			< TX_QUEUE_LEN - 1 && np->speed != 10) {
+	if (ADD_MOD(np->cur_tx - np->old_tx, TX_RING_SIZE) < TX_QUEUE_LEN - 1 &&
+	    np->speed != 10) {
 		/* do nothing */
 	} else if (!netif_queue_stopped(dev)) {
 		netif_stop_queue (dev);
@@ -758,8 +758,8 @@ rio_free_tx (struct net_device *dev, int irq)
 	   call netif_wake_queue() */
 
 	if (netif_queue_stopped(dev) &&
-	    ((np->cur_tx - np->old_tx + TX_RING_SIZE) % TX_RING_SIZE
-	    < TX_QUEUE_LEN - 1 || np->speed == 10)) {
+	    (ADD_MOD(np->cur_tx - np->old_tx, TX_RING_SIZE) <
+	     TX_QUEUE_LEN - 1 || np->speed == 10)) {
 		netif_wake_queue (dev);
 	}
 }
diff --git a/drivers/net/sundance.c b/drivers/net/sundance.c
index a855934..0f8af2d 100644
--- a/drivers/net/sundance.c
+++ b/drivers/net/sundance.c
@@ -1390,8 +1390,7 @@ static void refill_rx (struct net_device *dev)
 	int cnt = 0;
 
 	/* Refill the Rx ring buffers. */
-	for (;(np->cur_rx - np->dirty_rx + RX_RING_SIZE) % RX_RING_SIZE > 0;
-		np->dirty_rx = (np->dirty_rx + 1) % RX_RING_SIZE) {
+	while (ADD_MOD(np->cur_rx - np->dirty_rx, RX_RING_SIZE) > 0) {
 		struct sk_buff *skb;
 		entry = np->dirty_rx % RX_RING_SIZE;
 		if (np->rx_skbuff[entry] == NULL) {
@@ -1410,6 +1409,7 @@ static void refill_rx (struct net_device *dev)
 			cpu_to_le32(np->rx_buf_sz | LastFrag);
 		np->rx_ring[entry].status = 0;
 		cnt++;
+		np->dirty_rx = (np->dirty_rx + 1) % RX_RING_SIZE;
 	}
 	return;
 }
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 83aae47..f9d1e54 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -889,17 +889,17 @@ static int qi_check_fault(struct intel_iommu *iommu, int index)
 	 */
 	if (fault & DMA_FSTS_ITE) {
 		head = readl(iommu->reg + DMAR_IQH_REG);
-		head = ((head >> DMAR_IQ_SHIFT) - 1 + QI_LENGTH) % QI_LENGTH;
+		head = ADD_MOD((head >> DMAR_IQ_SHIFT) - 1, QI_LENGTH);
 		head |= 1;
 		tail = readl(iommu->reg + DMAR_IQT_REG);
-		tail = ((tail >> DMAR_IQ_SHIFT) - 1 + QI_LENGTH) % QI_LENGTH;
+		tail = ADD_MOD((tail >> DMAR_IQ_SHIFT) - 1, QI_LENGTH);
 
 		writel(DMA_FSTS_ITE, iommu->reg + DMAR_FSTS_REG);
 
 		do {
 			if (qi->desc_status[head] == QI_IN_USE)
 				qi->desc_status[head] = QI_ABORT;
-			head = (head - 2 + QI_LENGTH) % QI_LENGTH;
+			head = ADD_MOD(head - 2, QI_LENGTH);
 		} while (head != tail);
 
 		if (qi->desc_status[wait_index] == QI_ABORT)
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 84d3bba..be14e09 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -755,7 +755,7 @@ static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int
 			}
 			tw_ioctl->driver_command.status = 0;
 		}
-		event_index = (tw_dev->error_index - 1 + TW_Q_LENGTH) % TW_Q_LENGTH;
+		event_index = ADD_MOD(tw_dev->error_index - 1, TW_Q_LENGTH);
 		memcpy(tw_ioctl->data_buffer, tw_dev->event_queue[event_index], sizeof(TW_Event));
 		tw_dev->event_queue[event_index]->retrieved = TW_AEN_RETRIEVED;
 		break;
diff --git a/drivers/staging/wavelan/wavelan_cs.c b/drivers/staging/wavelan/wavelan_cs.c
index 04f691d..e259117 100644
--- a/drivers/staging/wavelan/wavelan_cs.c
+++ b/drivers/staging/wavelan/wavelan_cs.c
@@ -685,7 +685,7 @@ static void wl_update_history(wavepoint_history *wavepoint, unsigned char sigqua
   wavepoint->last_seq=seq;	
   wavepoint->sigqual[wavepoint->qualptr++]=sigqual;          
   wavepoint->qualptr %=WAVEPOINT_HISTORY;
-  ptr=(wavepoint->qualptr-WAVEPOINT_FAST_HISTORY+WAVEPOINT_HISTORY)%WAVEPOINT_HISTORY;
+  ptr=ADD_MOD(wavepoint->qualptr-WAVEPOINT_FAST_HISTORY, WAVEPOINT_HISTORY);
   
   for(i=0;i<WAVEPOINT_FAST_HISTORY;i++)       /* Update running averages */
     {
@@ -2728,7 +2728,7 @@ wv_start_of_frame(struct net_device *	dev,
   int		rp;
   int		len;
 
-  rp = (rfp - 5 + RX_SIZE) % RX_SIZE;
+  rp = ADD_MOD(rfp - 5, RX_SIZE);
   outb(rp & 0xff, PIORL(base));
   outb(((rp >> 8) & PIORH_MASK), PIORH(base));
   len = inb(PIOP(base));
@@ -2756,7 +2756,7 @@ wv_start_of_frame(struct net_device *	dev,
     }
   
   /* Wrap around buffer */
-  if(len > ((wrap - (rfp - len) + RX_SIZE) % RX_SIZE))	/* magic formula ! */
+  if (len > ADD_MOD(wrap - (rfp - len), RX_SIZE))	/* magic formula ! */
     {
 #ifdef DEBUG_RX_ERROR
       printk(KERN_INFO "%s: wv_start_of_frame: wrap around buffer, wrap %d rfp %d len 0x%x\n",
@@ -2765,7 +2765,7 @@ wv_start_of_frame(struct net_device *	dev,
       return(-1);
     }
 
-  return((rp - len + RX_SIZE) % RX_SIZE);
+  return ADD_MOD(rp - len, RX_SIZE);
 } /* wv_start_of_frame */
 
 /*------------------------------------------------------------------*/
@@ -2956,7 +2956,7 @@ wv_packet_rcv(struct net_device *	dev)
        * and rp to the beggining of the next one */
 
       /* Read status & length of the frame */
-      stat_ptr = (rp - 7 + RX_SIZE) % RX_SIZE;
+      stat_ptr = ADD_MOD(rp - 7, RX_SIZE);
       stat_ptr = read_ringbuf(dev, stat_ptr, c, 4);
       status = c[0] | (c[1] << 8);
       len = c[2] | (c[3] << 8);
diff --git a/drivers/usb/misc/sisusbvga/sisusb_con.c b/drivers/usb/misc/sisusbvga/sisusb_con.c
index b624320..0abaaeb 100644
--- a/drivers/usb/misc/sisusbvga/sisusb_con.c
+++ b/drivers/usb/misc/sisusbvga/sisusb_con.c
@@ -749,10 +749,10 @@ sisusbcon_scrolldelta(struct vc_data *c, int lines)
 
 		}
 
-		p = (c->vc_visible_origin - sisusb->scrbuf - ul + we) % we +
+		p = ADD_MOD(c->vc_visible_origin - sisusb->scrbuf - ul, we) +
 				lines * c->vc_size_row;
 
-		st = (c->vc_origin - sisusb->scrbuf - ul + we) % we;
+		st = ADD_MOD(c->vc_origin - sisusb->scrbuf - ul, we);
 
 		if (st < 2 * margin)
 			margin = 0;
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 182dd6f..af83238 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -354,9 +354,9 @@ static int vgacon_scrolldelta(struct vc_data *c, int lines)
 			ul = 0;
 			we = vga_vram_size;
 		}
-		p = (c->vc_visible_origin - vga_vram_base - ul + we) % we +
+		p = ADD_MOD(c->vc_visible_origin - vga_vram_base - ul, we) +
 		    lines * c->vc_size_row;
-		st = (c->vc_origin - vga_vram_base - ul + we) % we;
+		st = ADD_MOD(c->vc_origin - vga_vram_base - ul, we);
 		if (st < 2 * margin)
 			margin = 0;
 		if (p < margin)
diff --git a/sound/oss/vwsnd.c b/sound/oss/vwsnd.c
index 6713110..7b36b6a 100644
--- a/sound/oss/vwsnd.c
+++ b/sound/oss/vwsnd.c
@@ -1970,7 +1970,7 @@ static void pcm_output(vwsnd_dev_t *devc, int erflown, int nb)
 
 		hwptr = li_read_hwptr(&wport->chan);
 		swptr = li_read_swptr(&wport->chan);
-		hw_unavail = (swptr - hwptr + hwsize) % hwsize;
+		hw_unavail = ADD_MOD(swptr - hwptr, hwsize);
 		hw_avail = (hwmax - hw_unavail) & -fragsize;
 		sw_avail = wport->swb_i_avail & -fragsize;
 		if (sw_avail && swstate == SW_RUN) {
@@ -2093,7 +2093,7 @@ static void pcm_input(vwsnd_dev_t *devc, int erflown, int nb)
 
 		hwptr = li_read_hwptr(&rport->chan);
 		swptr = li_read_swptr(&rport->chan);
-		hw_avail = (hwptr - swptr + hwsize) % hwsize & -fragsize;
+		hw_avail = ADD_MOD(hwptr - swptr, hwsize) & -fragsize;
 		if (hw_avail > hwmax)
 			hw_avail = hwmax;
 		sw_avail = rport->swb_i_avail & -fragsize;
@@ -2776,7 +2776,7 @@ static int vwsnd_audio_do_ioctl(struct inode *inode,
 				hwframes = ustmsc.msc - wport->MSC_offset;
 				totalhwbytes = hwframes * fsize;
 				hwptr = totalhwbytes % hwsize;
-				hwbytes = (swptr - hwptr + hwsize) % hwsize;
+				hwbytes = ADD_MOD(swptr - hwptr, hwsize);
 				ival += hwbytes / fsize;
 			}
 		}


