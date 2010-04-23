Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab0DWQrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:47:52 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:52668 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0DWQru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ch80kHh3WsCoFn2dJxZzAtvi568fBDaFb/h2k2CT7JFotiDAc0KC60buNt844sn9AI
         bG1tks7hM+7OQqBsL4/v5f5qSNNIh+7zFrlRru9WeR68yH49Ie7go3sUkvcIK10wBgw3
         NL9N568c/vV0fuwacsYFNfrCMd9vliDiY74bg=
From: Alessandro Ghedini <al3xbio@gmail.com>
To: gregkh@suse.de, Andrew.Elwell@gmail.com, mithlesh@linsyssoft.com,
       svenne@krap.dk, jkosina@suse.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Alessandro Ghedini <al3xbio@gmail.com>
Subject: [PATCH] Staging: wlan-ng: fix many style issues in hfa384x_usb.c
Date: Fri, 23 Apr 2010 18:48:10 +0200
Message-Id: <1272041290-11977-1-git-send-email-al3xbio@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all the errors and most of the checkpatch.pl warnings
and other style issues in the hfa384x_usb.c file

Signed-off-by: Alessandro Ghedini <al3xbio@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |  228 +++++++++++++++------------------
 1 files changed, 102 insertions(+), 126 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 5df56f0..0f2a608 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -62,7 +62,7 @@
 *
 * hfa384x_drvr_xxxconfig  An example of the drvr level abstraction. These
 *			functions are wrappers for the RID get/set
-*			sequence. They 	call copy_[to|from]_bap() and
+*			sequence. They call copy_[to|from]_bap() and
 *			cmd_access().	These functions operate on the
 *			RIDs and buffers without validation.  The caller
 *			is responsible for that.
@@ -351,13 +351,13 @@ static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
 	hw->rx_urb_skb = skb;
 
 	result = -ENOLINK;
-	if (!hw->wlandev->hwremoved && !test_bit(WORK_RX_HALT, &hw->usb_flags)) {
+	if (!hw->wlandev->hwremoved &&
+	    !test_bit(WORK_RX_HALT, &hw->usb_flags)) {
 		result = SUBMIT_URB(&hw->rx_urb, memflags);
 
 		/* Check whether we need to reset the RX pipe */
 		if (result == -EPIPE) {
-			printk(KERN_WARNING
-			       "%s rx pipe stalled: requesting reset\n",
+			printk(KERN_WARNING "%s rx pipe stalled: requesting reset\n",
 			       hw->wlandev->netdev->name);
 			if (!test_and_set_bit(WORK_RX_HALT, &hw->usb_flags))
 				schedule_work(&hw->usb_work);
@@ -406,8 +406,7 @@ static int submit_tx_urb(hfa384x_t *hw, struct urb *tx_urb, gfp_t memflags)
 
 			/* Test whether we need to reset the TX pipe */
 			if (result == -EPIPE) {
-				printk(KERN_WARNING
-				       "%s tx pipe stalled: requesting reset\n",
+				printk(KERN_WARNING "%s tx pipe stalled: requesting reset\n",
 				       netdev->name);
 				set_bit(WORK_TX_HALT, &hw->usb_flags);
 				schedule_work(&hw->usb_work);
@@ -451,12 +450,12 @@ static void hfa384x_usb_defer(struct work_struct *data)
 	if (test_bit(WORK_RX_HALT, &hw->usb_flags)) {
 		int ret;
 
-		usb_kill_urb(&hw->rx_urb);	/* Cannot be holding spinlock! */
+		/* Cannot be holding spinlock! */
+		usb_kill_urb(&hw->rx_urb);
 
 		ret = usb_clear_halt(hw->usb, hw->endp_in);
 		if (ret != 0) {
-			printk(KERN_ERR
-			       "Failed to clear rx pipe for %s: err=%d\n",
+			printk(KERN_ERR "Failed to clear rx pipe for %s: err=%d\n",
 			       netdev->name, ret);
 		} else {
 			printk(KERN_INFO "%s rx pipe reset complete.\n",
@@ -472,8 +471,8 @@ static void hfa384x_usb_defer(struct work_struct *data)
 
 		ret = submit_rx_urb(hw, GFP_KERNEL);
 		if (ret != 0) {
-			printk(KERN_ERR
-			       "Failed to resume %s rx pipe.\n", netdev->name);
+			printk(KERN_ERR "Failed to resume %s rx pipe.\n",
+			       netdev->name);
 		} else {
 			clear_bit(WORK_RX_RESUME, &hw->usb_flags);
 		}
@@ -486,8 +485,7 @@ static void hfa384x_usb_defer(struct work_struct *data)
 		usb_kill_urb(&hw->tx_urb);
 		ret = usb_clear_halt(hw->usb, hw->endp_out);
 		if (ret != 0) {
-			printk(KERN_ERR
-			       "Failed to clear tx pipe for %s: err=%d\n",
+			printk(KERN_ERR "Failed to clear tx pipe for %s: err=%d\n",
 			       netdev->name, ret);
 		} else {
 			printk(KERN_INFO "%s tx pipe reset complete.\n",
@@ -645,8 +643,7 @@ usbctlx_get_status(const hfa384x_usb_cmdresp_t *cmdresp,
 	result->resp1 = le16_to_cpu(cmdresp->resp1);
 	result->resp2 = le16_to_cpu(cmdresp->resp2);
 
-	pr_debug("cmdresult:status=0x%04x "
-		 "resp0=0x%04x resp1=0x%04x resp2=0x%04x\n",
+	pr_debug("cmdresult:status=0x%04x resp0=0x%04x resp1=0x%04x resp2=0x%04x\n",
 		 result->status, result->resp0, result->resp1, result->resp2);
 
 	return result->status & HFA384x_STATUS_RESULT;
@@ -718,8 +715,7 @@ static int usbctlx_rrid_completor_fn(usbctlx_completor_t *head)
 
 	/* Validate the length, note body len calculation in bytes */
 	if (rridresult.riddata_len != complete->riddatalen) {
-		printk(KERN_WARNING
-		       "RID len mismatch, rid=0x%04x hlen=%d fwlen=%d\n",
+		printk(KERN_WARNING "RID len mismatch, rid=0x%04x hlen=%d fwlen=%d\n",
 		       rridresult.rid,
 		       complete->riddatalen, rridresult.riddata_len);
 		return -ENODATA;
@@ -991,9 +987,7 @@ int hfa384x_cmd_initialize(hfa384x_t *hw)
 
 	result = hfa384x_docmd_wait(hw, &cmd);
 
-	pr_debug("cmdresp.init: "
-		 "status=0x%04x, resp0=0x%04x, "
-		 "resp1=0x%04x, resp2=0x%04x\n",
+	pr_debug("cmdresp.init: status=0x%04x, resp0=0x%04x, resp1=0x%04x, resp2=0x%04x\n",
 		 cmd.result.status,
 		 cmd.result.resp0, cmd.result.resp1, cmd.result.resp2);
 	if (result == 0) {
@@ -1226,7 +1220,7 @@ int hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis)
 *
 * Arguments:
 *	hw		device structure
-*	ctlx	 	CTLX ptr
+*	ctlx		CTLX ptr
 *	completor	functor object to decide what to
 *			do with the CTLX's result.
 *
@@ -1381,8 +1375,7 @@ hfa384x_docmd(hfa384x_t *hw,
 
 	ctlx->outbufsize = sizeof(ctlx->outbuf.cmdreq);
 
-	pr_debug("cmdreq: cmd=0x%04x "
-		 "parm0=0x%04x parm1=0x%04x parm2=0x%04x\n",
+	pr_debug("cmdreq: cmd=0x%04x parm0=0x%04x parm1=0x%04x parm2=0x%04x\n",
 		 cmd->cmd, cmd->parm0, cmd->parm1, cmd->parm2);
 
 	ctlx->reapable = mode;
@@ -1569,8 +1562,7 @@ hfa384x_dowrid(hfa384x_t *hw,
 		usbctlx_wrid_completor_t completor;
 		hfa384x_cmdresult_t wridresult;
 
-		result = hfa384x_usbctlx_complete_sync(hw,
-						       ctlx,
+		result = hfa384x_usbctlx_complete_sync(hw, ctlx,
 						       init_wrid_completor
 						       (&completor,
 							&ctlx->inbuf.wridresp,
@@ -1751,8 +1743,7 @@ hfa384x_dowmem(hfa384x_t *hw,
 		usbctlx_wmem_completor_t completor;
 		hfa384x_cmdresult_t wmemresult;
 
-		result = hfa384x_usbctlx_complete_sync(hw,
-						       ctlx,
+		result = hfa384x_usbctlx_complete_sync(hw, ctlx,
 						       init_wmem_completor
 						       (&completor,
 							&ctlx->inbuf.wmemresp,
@@ -1958,8 +1949,10 @@ int hfa384x_drvr_flashdl_disable(hfa384x_t *hw)
 
 	pr_debug("flashdl_enable\n");
 
-	/* There isn't much we can do at this point, so I don't */
-	/*  bother  w/ the return value */
+	/*
+	 * There isn't much we can do at this point,
+	 * so I don't bother w/ the return value
+	 */
 	hfa384x_cmd_download(hw, HFA384x_PROGMODE_DISABLE, 0, 0, 0);
 	hw->dlstate = HFA384x_DLSTATE_DISABLED;
 
@@ -2020,8 +2013,10 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 
 	printk(KERN_INFO "Download %d bytes to flash @0x%06x\n", len, daddr);
 
-	/* Convert to flat address for arithmetic */
-	/* NOTE: dlbuffer RID stores the address in AUX format */
+	/*
+	 * Convert to flat address for arithmetic
+	 * NOTE: dlbuffer RID stores the address in AUX format
+	 */
 	dlbufaddr =
 	    HFA384x_ADDR_AUX_MKFLAT(hw->bufinfo.page, hw->bufinfo.offset);
 	pr_debug("dlbuf.page=0x%04x dlbuf.offset=0x%04x dlbufaddr=0x%08x\n",
@@ -2062,32 +2057,24 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 		result = hfa384x_cmd_download(hw, HFA384x_PROGMODE_NV,
 					      burnlo, burnhi, burnlen);
 		if (result) {
-			printk(KERN_ERR "download(NV,lo=%x,hi=%x,len=%x) "
-			       "cmd failed, result=%d. Aborting d/l\n",
+			printk(KERN_ERR "download(NV,lo=%x,hi=%x,len=%x) cmd failed, result=%d. Aborting d/l\n",
 			       burnlo, burnhi, burnlen, result);
 			goto exit_proc;
 		}
 
 		/* copy the data to the flash download buffer */
 		for (j = 0; j < nwrites; j++) {
-			writebuf = buf +
-			    (i * hw->bufinfo.len) +
-			    (j * HFA384x_USB_RWMEM_MAXLEN);
-
-			writepage = HFA384x_ADDR_CMD_MKPAGE(dlbufaddr +
-							    (j *
-							     HFA384x_USB_RWMEM_MAXLEN));
-			writeoffset =
-			    HFA384x_ADDR_CMD_MKOFF(dlbufaddr +
-						   (j *
-						    HFA384x_USB_RWMEM_MAXLEN));
-
-			writelen = burnlen - (j * HFA384x_USB_RWMEM_MAXLEN);
+			int pos = j * HFA384x_USB_RWMEM_MAXLEN;
+			writebuf = buf + (i * hw->bufinfo.len) + pos;
+
+			writepage = HFA384x_ADDR_CMD_MKPAGE(dlbufaddr + pos);
+			writeoffset = HFA384x_ADDR_CMD_MKOFF(dlbufaddr + pos);
+
+			writelen = burnlen - pos;
 			writelen = writelen > HFA384x_USB_RWMEM_MAXLEN ?
 			    HFA384x_USB_RWMEM_MAXLEN : writelen;
 
-			result = hfa384x_dowmem_wait(hw,
-						     writepage,
+			result = hfa384x_dowmem_wait(hw, writepage,
 						     writeoffset,
 						     writebuf, writelen);
 		}
@@ -2097,9 +2084,7 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 					      HFA384x_PROGMODE_NVWRITE,
 					      0, 0, 0);
 		if (result) {
-			printk(KERN_ERR
-			       "download(NVWRITE,lo=%x,hi=%x,len=%x) "
-			       "cmd failed, result=%d. Aborting d/l\n",
+			printk(KERN_ERR "download(NVWRITE,lo=%x,hi=%x,len=%x) cmd failed, result=%d. Aborting d/l\n",
 			       burnlo, burnhi, burnlen, result);
 			goto exit_proc;
 		}
@@ -2109,9 +2094,12 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 
 exit_proc:
 
-	/* Leave the firmware in the 'post-prog' mode.  flashdl_disable will */
-	/*  actually disable programming mode.  Remember, that will cause the */
-	/*  the firmware to effectively reset itself. */
+	/*
+	 * Leave the firmware in the 'post-prog' mode.
+	 * flashdl_disable will actually disable programming mode.
+	 * Remember, that will cause the the firmware to
+	 * effectively reset itself.
+	 */
 
 	return result;
 }
@@ -2133,7 +2121,7 @@ exit_proc:
 *	0		success
 *	>0		f/w reported error - f/w status code
 *	<0		driver reported error
-*	-ENODATA 	length mismatch between argument and retrieved
+*	-ENODATA	length mismatch between argument and retrieved
 *			record.
 *
 * Side effects:
@@ -2177,9 +2165,8 @@ int hfa384x_drvr_getconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len)
  * Call context:
  *       Any
  ----------------------------------------------------------------*/
-int
-hfa384x_drvr_getconfig_async(hfa384x_t *hw,
-			     u16 rid, ctlx_usercb_t usercb, void *usercb_data)
+int hfa384x_drvr_getconfig_async(hfa384x_t *hw, u16 rid,
+				 ctlx_usercb_t usercb, void *usercb_data)
 {
 	return hfa384x_dorrid_async(hw, rid, NULL, 0,
 				    hfa384x_cb_rrid, usercb, usercb_data);
@@ -2208,14 +2195,11 @@ hfa384x_drvr_getconfig_async(hfa384x_t *hw,
  * Call context:
  *       process
  ----------------------------------------------------------------*/
-int
-hfa384x_drvr_setconfig_async(hfa384x_t *hw,
-			     u16 rid,
-			     void *buf,
-			     u16 len, ctlx_usercb_t usercb, void *usercb_data)
+int hfa384x_drvr_setconfig_async(hfa384x_t *hw, u16 rid, void *buf, u16 len,
+				 ctlx_usercb_t usercb, void *usercb_data)
 {
-	return hfa384x_dowrid_async(hw, rid, buf, len,
-				    hfa384x_cb_status, usercb, usercb_data);
+	return hfa384x_dowrid_async(hw, rid, buf, len, hfa384x_cb_status,
+				    usercb, usercb_data);
 }
 
 /*----------------------------------------------------------------
@@ -2244,8 +2228,10 @@ int hfa384x_drvr_ramdl_disable(hfa384x_t *hw)
 
 	pr_debug("ramdl_disable()\n");
 
-	/* There isn't much we can do at this point, so I don't */
-	/*  bother  w/ the return value */
+	/*
+	 * There isn't much we can do at this point,
+	 * so I don't bother  w/ the return value
+	 */
 	hfa384x_cmd_download(hw, HFA384x_PROGMODE_DISABLE, 0, 0, 0);
 	hw->dlstate = HFA384x_DLSTATE_DISABLED;
 
@@ -2286,8 +2272,7 @@ int hfa384x_drvr_ramdl_enable(hfa384x_t *hw, u32 exeaddr)
 	/* Check that a port isn't active */
 	for (i = 0; i < HFA384x_PORTID_MAX; i++) {
 		if (hw->port_enabled[i]) {
-			printk(KERN_ERR
-			       "Can't download with a macport enabled.\n");
+			printk(KERN_ERR "Can't download with a macport enabled.\n");
 			return -EINVAL;
 		}
 	}
@@ -2368,20 +2353,17 @@ int hfa384x_drvr_ramdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 	/* Do blocking wmem's */
 	for (i = 0; i < nwrites; i++) {
 		/* make address args */
-		curraddr = daddr + (i * HFA384x_USB_RWMEM_MAXLEN);
+		int pos = i * HFA384x_USB_RWMEM_MAXLEN;
+		curraddr = daddr + pos;
 		currpage = HFA384x_ADDR_CMD_MKPAGE(curraddr);
 		curroffset = HFA384x_ADDR_CMD_MKOFF(curraddr);
-		currlen = len - (i * HFA384x_USB_RWMEM_MAXLEN);
+		currlen = len - pos;
 		if (currlen > HFA384x_USB_RWMEM_MAXLEN)
 			currlen = HFA384x_USB_RWMEM_MAXLEN;
 
 		/* Do blocking ctlx */
-		result = hfa384x_dowmem_wait(hw,
-					     currpage,
-					     curroffset,
-					     data +
-					     (i * HFA384x_USB_RWMEM_MAXLEN),
-					     currlen);
+		result = hfa384x_dowmem_wait(hw, currpage, curroffset,
+					     data + pos, currlen);
 
 		if (result)
 			break;
@@ -2451,11 +2433,12 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 		currpage = HFA384x_ADDR_CMD_MKPAGE(pdaloc[i].cardaddr);
 		curroffset = HFA384x_ADDR_CMD_MKOFF(pdaloc[i].cardaddr);
 
-		result = hfa384x_dormem_wait(hw, currpage, curroffset, buf, len);	/* units of bytes */
+		result = hfa384x_dormem_wait(hw, currpage, curroffset, buf,
+					     len); /* units of bytes */
 
 		if (result) {
-			printk(KERN_WARNING
-			       "Read from index %zd failed, continuing\n", i);
+			printk(KERN_WARNING "Read from index %zd failed, continuing\n",
+			       i);
 			continue;
 		}
 
@@ -2489,8 +2472,7 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 			}
 		}
 		if (pdaok) {
-			printk(KERN_INFO
-			       "PDA Read from 0x%08x in %s space.\n",
+			printk(KERN_INFO "PDA Read from 0x%08x in %s space.\n",
 			       pdaloc[i].cardaddr,
 			       pdaloc[i].auxctl == 0 ? "EXTDS" :
 			       pdaloc[i].auxctl == 1 ? "NV" :
@@ -2556,7 +2538,9 @@ int hfa384x_drvr_setconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len)
 
 int hfa384x_drvr_start(hfa384x_t *hw)
 {
-	int result, result1, result2;
+	int result;
+	int result1;
+	int result2;
 	u16 status;
 
 	might_sleep();
@@ -2590,8 +2574,8 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	/* Post the IN urb */
 	result = submit_rx_urb(hw, GFP_KERNEL);
 	if (result != 0) {
-		printk(KERN_ERR
-		       "Fatal, failed to submit RX URB, result=%d\n", result);
+		printk(KERN_ERR "Fatal, failed to submit RX URB, result=%d\n",
+		       result);
 		goto done;
 	}
 
@@ -2610,23 +2594,19 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	result = result2 = hfa384x_cmd_initialize(hw);
 	if (result1 != 0) {
 		if (result2 != 0) {
-			printk(KERN_ERR
-			       "cmd_initialize() failed on two attempts, results %d and %d\n",
+			printk(KERN_ERR "cmd_initialize() failed on two attempts, results %d and %d\n",
 			       result1, result2);
 			usb_kill_urb(&hw->rx_urb);
 			goto done;
 		} else {
 			pr_debug("First cmd_initialize() failed (result %d),\n",
 				 result1);
-			pr_debug
-			    ("but second attempt succeeded. All should be ok\n");
+			pr_debug("but second attempt succeeded. All should be ok\n");
 		}
 	} else if (result2 != 0) {
-		printk(KERN_WARNING
-		       "First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
+		printk(KERN_WARNING "First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
 		       result2);
-		printk(KERN_WARNING
-		       "Most likely the card will be functional\n");
+		printk(KERN_WARNING "Most likely the card will be functional\n");
 		goto done;
 	}
 
@@ -3066,8 +3046,7 @@ static void hfa384x_usbctlxq_run(hfa384x_t *hw)
 		list_move_tail(&head->list, &hw->ctlxq.active);
 
 		/* Fill the out packet */
-		usb_fill_bulk_urb(&(hw->ctlx_urb), hw->usb,
-				  hw->endp_out,
+		usb_fill_bulk_urb(&(hw->ctlx_urb), hw->usb, hw->endp_out,
 				  &(head->outbuf), ROUNDUP64(head->outbufsize),
 				  hfa384x_ctlxout_callback, hw);
 		hw->ctlx_urb.transfer_flags |= USB_QUEUE_BULK;
@@ -3096,8 +3075,7 @@ static void hfa384x_usbctlxq_run(hfa384x_t *hw)
 			 * this CTLX back in the "pending" queue
 			 * and schedule a reset ...
 			 */
-			printk(KERN_WARNING
-			       "%s tx pipe stalled: requesting reset\n",
+			printk(KERN_WARNING "%s tx pipe stalled: requesting reset\n",
 			       hw->wlandev->netdev->name);
 			list_move(&head->list, &hw->ctlxq.pending);
 			set_bit(WORK_TX_HALT, &hw->usb_flags);
@@ -3229,15 +3207,14 @@ static void hfa384x_usbin_callback(struct urb *urb)
 		result = submit_rx_urb(hw, GFP_ATOMIC);
 
 		if (result != 0) {
-			printk(KERN_ERR
-			       "Fatal, failed to resubmit rx_urb. error=%d\n",
+			printk(KERN_ERR "Fatal, failed to resubmit rx_urb. error=%d\n",
 			       result);
 		}
 	}
 
 	/* Handle any USB-IN packet */
-	/* Note: the check of the sw_support field, the type field doesn't
-	 *       have bit 12 set like the docs suggest.
+	/* Note: the check of the sw_support field,
+	 * the type field doesn't have bit 12 set like the docs suggest.
 	 */
 	type = le16_to_cpu(usbin->type);
 	if (HFA384x_USB_ISRXFRM(type)) {
@@ -3365,8 +3342,7 @@ retry:
 		 * Check that our message is what we're expecting ...
 		 */
 		if (ctlx->outbuf.type != intype) {
-			printk(KERN_WARNING
-			       "Expected IN[%d], received IN[%d] - ignored.\n",
+			printk(KERN_WARNING "Expected IN[%d], received IN[%d] - ignored.\n",
 			       le16_to_cpu(ctlx->outbuf.type),
 			       le16_to_cpu(intype));
 			goto unlock;
@@ -3379,11 +3355,11 @@ retry:
 		case CTLX_REQ_SUBMITTED:
 			/*
 			 * We have received our response URB before
-			 * our request has been acknowledged. Odd,
-			 * but our OUT URB is still alive...
+			 * our request has been acknowledged.
+			 * Odd, but our OUT URB is still alive...
 			 */
 			pr_debug
-			    ("Causality violation: please reboot Universe, or email linux-wlan-devel@lists.linux-wlan.com\n");
+			    ("Causality violation: please reboot Universe\n");
 			ctlx->state = CTLX_RESP_COMPLETE;
 			break;
 
@@ -3402,9 +3378,7 @@ retry:
 			/*
 			 * Throw this CTLX away ...
 			 */
-			printk(KERN_ERR
-			       "Matched IN URB, CTLX[%d] in invalid state(%s)."
-			       " Discarded.\n",
+			printk(KERN_ERR "Matched IN URB, CTLX[%d] in invalid state(%s). Discarded.\n",
 			       le16_to_cpu(ctlx->outbuf.type),
 			       ctlxstr(ctlx->state));
 			if (unlocked_usbctlx_cancel_async(hw, ctlx) == 0)
@@ -3442,7 +3416,7 @@ static void hfa384x_usbin_txcompl(wlandevice_t *wlandev,
 {
 	u16 status;
 
-	status = le16_to_cpu(usbin->type);	/* yeah I know it says type... */
+	status = le16_to_cpu(usbin->type); /* yeah I know it says type... */
 
 	/* Was there an error? */
 	if (HFA384x_TXSTATUS_ISERROR(status))
@@ -3583,8 +3557,10 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 	struct sk_buff *skb;
 	hfa384x_t *hw = wlandev->priv;
 
-	/* Don't forget the status, time, and data_len fields are in host order */
-	/* Figure out how big the frame is */
+	/*
+	 * The status, time, and data_len fields are in host order
+	 * Figure out how big the frame is
+	 */
 	fc = le16_to_cpu(rxdesc->frame_control);
 	hdrlen = p80211_headerlen(fc);
 	datalen = le16_to_cpu(rxdesc->data_len);
@@ -3602,8 +3578,7 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 
 	skb = dev_alloc_skb(skblen);
 	if (skb == NULL) {
-		printk(KERN_ERR
-		       "alloc_skb failed trying to allocate %d bytes\n",
+		printk(KERN_ERR "alloc_skb failed trying to allocate %d bytes\n",
 		       skblen);
 		return;
 	}
@@ -3632,7 +3607,10 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		caphdr->encoding = htonl(1);	/* cck */
 	}
 
-	/* Copy the 802.11 header to the skb (ctl frames may be less than a full header) */
+	/*
+	 * Copy the 802.11 header to the skb
+	 * (ctl frames may be less than a full header)
+	 */
 	datap = skb_put(skb, hdrlen);
 	memcpy(datap, &(rxdesc->frame_control), hdrlen);
 
@@ -3644,7 +3622,8 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		/* check for unencrypted stuff if WEP bit set. */
 		if (*(datap - hdrlen + 1) & 0x40)	/* wep set */
 			if ((*(datap) == 0xaa) && (*(datap + 1) == 0xaa))
-				*(datap - hdrlen + 1) &= 0xbf;	/* clear wep; it's the 802.2 header! */
+				/* clear wep; it's the 802.2 header! */
+				*(datap - hdrlen + 1) &= 0xbf;
 	}
 
 	if (hw->sniff_fcs) {
@@ -3718,8 +3697,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
 		case -EPIPE:
 			{
 				hfa384x_t *hw = wlandev->priv;
-				printk(KERN_WARNING
-				       "%s tx pipe stalled: requesting reset\n",
+				printk(KERN_WARNING "%s tx pipe stalled: requesting reset\n",
 				       wlandev->netdev->name);
 				if (!test_and_set_bit
 				    (WORK_TX_HALT, &hw->usb_flags))
@@ -3845,8 +3823,7 @@ retry:
 
 		default:
 			/* This is NOT a valid CTLX "success" state! */
-			printk(KERN_ERR
-			       "Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
+			printk(KERN_ERR "Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
 			       le16_to_cpu(ctlx->outbuf.type),
 			       ctlxstr(ctlx->state), urb->status);
 			break;
@@ -3855,8 +3832,7 @@ retry:
 		/* If the pipe has stalled then we need to reset it */
 		if ((urb->status == -EPIPE) &&
 		    !test_and_set_bit(WORK_TX_HALT, &hw->usb_flags)) {
-			printk(KERN_WARNING
-			       "%s tx pipe stalled: requesting reset\n",
+			printk(KERN_WARNING "%s tx pipe stalled: requesting reset\n",
 			       hw->wlandev->netdev->name);
 			schedule_work(&hw->usb_work);
 		}
@@ -4154,13 +4130,13 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode)
 	default:
 		if (pdrcode < 0x1000) {
 			/* code is OK, but we don't know exactly what it is */
-			pr_debug("Encountered unknown PDR#=0x%04x, "
-				 "assuming it's ok.\n", pdrcode);
+			pr_debug("Encountered unknown PDR#=0x%04x, assuming it's ok.\n",
+				 pdrcode);
 			return 1;
 		} else {
 			/* bad code */
-			pr_debug("Encountered unknown PDR#=0x%04x, "
-				 "(>=0x1000), assuming it's bad.\n", pdrcode);
+			pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
+				 pdrcode);
 			return 0;
 		}
 		break;
-- 
1.7.0.5

