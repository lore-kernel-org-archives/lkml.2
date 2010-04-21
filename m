Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0DUR7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:59:35 -0400
Received: from mail.perches.com ([173.55.12.10]:1608 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab0DUR7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:59:33 -0400
Subject: Re: [PATCH] Staging: wlan-ng: fix many style warnings in
 hfa384x_usb.c
From: Joe Perches <joe@perches.com>
To: Alessandro Ghedini <al3xbio@gmail.com>
Cc: gregkh@suse.de, Andrew.Elwell@gmail.com, mithlesh@linsyssoft.com,
       svenne@krap.dk, jkosina@suse.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1271870950-19305-1-git-send-email-al3xbio@gmail.com>
References: <1271870950-19305-1-git-send-email-al3xbio@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 10:59:31 -0700
Message-ID: <1271872771.1730.370.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 19:29 +0200, Alessandro Ghedini wrote:
> This patch fixes most of the style warnings found with checkpatch.pl in the
> hfa384x_usb.c file.
> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
> index 5df56f0..db819be 100644
> --- a/drivers/staging/wlan-ng/hfa384x_usb.c
> +++ b/drivers/staging/wlan-ng/hfa384x_usb.c
[]
> @@ -351,7 +351,9 @@ static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
>  	hw->rx_urb_skb = skb;
>  
>  	result = -ENOLINK;
> -	if (!hw->wlandev->hwremoved && !test_bit(WORK_RX_HALT, &hw->usb_flags)) {
> +	if (!hw->wlandev->hwremoved && \
> +			!test_bit(WORK_RX_HALT, &hw->usb_flags)) {
> +

Using line continuations like this is unnecessary and undesirable.

Most kernel code uses a form like:

	if (!thw->wlandev->hwremoved &&
	    !test_bit(WORK_RX_HALT, &hw->usb_flags))

(tabs to indent as much as possible, spaces to align where necessary)

> @@ -3845,8 +3852,8 @@ retry:
>  
>  		default:
>  			/* This is NOT a valid CTLX "success" state! */
> -			printk(KERN_ERR
> -			       "Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
> +			printk(KERN_ERR "Illegal CTLX[%d] success " \
> +					"state(%s, %d) in OUT URB\n",
> 

Checkpatch isn't correct here.

Another option is to use pr_<level> with
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
so logging messages identify the unit/module
like shown below.   A secondary benefit is the
code becomes slightly shorter.

A possible enhancement might be to use netdev_<level>
instead of pr_<level> where appropriate.

 drivers/staging/wlan-ng/hfa384x_usb.c |  169 ++++++++++++++-------------------
 1 files changed, 73 insertions(+), 96 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 5df56f0..0995f85 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -110,6 +110,8 @@
 * --------------------------------------------------------------------
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -356,9 +358,8 @@ static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
 
 		/* Check whether we need to reset the RX pipe */
 		if (result == -EPIPE) {
-			printk(KERN_WARNING
-			       "%s rx pipe stalled: requesting reset\n",
-			       hw->wlandev->netdev->name);
+			pr_warning("%s rx pipe stalled: requesting reset\n",
+				   hw->wlandev->netdev->name);
 			if (!test_and_set_bit(WORK_RX_HALT, &hw->usb_flags))
 				schedule_work(&hw->usb_work);
 		}
@@ -406,9 +407,8 @@ static int submit_tx_urb(hfa384x_t *hw, struct urb *tx_urb, gfp_t memflags)
 
 			/* Test whether we need to reset the TX pipe */
 			if (result == -EPIPE) {
-				printk(KERN_WARNING
-				       "%s tx pipe stalled: requesting reset\n",
-				       netdev->name);
+				pr_warning("%s tx pipe stalled: requesting reset\n",
+					   netdev->name);
 				set_bit(WORK_TX_HALT, &hw->usb_flags);
 				schedule_work(&hw->usb_work);
 			} else if (result == 0) {
@@ -455,11 +455,10 @@ static void hfa384x_usb_defer(struct work_struct *data)
 
 		ret = usb_clear_halt(hw->usb, hw->endp_in);
 		if (ret != 0) {
-			printk(KERN_ERR
-			       "Failed to clear rx pipe for %s: err=%d\n",
+			pr_err("Failed to clear rx pipe for %s: err=%d\n",
 			       netdev->name, ret);
 		} else {
-			printk(KERN_INFO "%s rx pipe reset complete.\n",
+			pr_info("%s rx pipe reset complete\n",
 			       netdev->name);
 			clear_bit(WORK_RX_HALT, &hw->usb_flags);
 			set_bit(WORK_RX_RESUME, &hw->usb_flags);
@@ -472,8 +471,7 @@ static void hfa384x_usb_defer(struct work_struct *data)
 
 		ret = submit_rx_urb(hw, GFP_KERNEL);
 		if (ret != 0) {
-			printk(KERN_ERR
-			       "Failed to resume %s rx pipe.\n", netdev->name);
+			pr_err("Failed to resume %s rx pipe\n", netdev->name);
 		} else {
 			clear_bit(WORK_RX_RESUME, &hw->usb_flags);
 		}
@@ -486,12 +484,10 @@ static void hfa384x_usb_defer(struct work_struct *data)
 		usb_kill_urb(&hw->tx_urb);
 		ret = usb_clear_halt(hw->usb, hw->endp_out);
 		if (ret != 0) {
-			printk(KERN_ERR
-			       "Failed to clear tx pipe for %s: err=%d\n",
+			pr_err("Failed to clear tx pipe for %s: err=%d\n",
 			       netdev->name, ret);
 		} else {
-			printk(KERN_INFO "%s tx pipe reset complete.\n",
-			       netdev->name);
+			pr_info("%s tx pipe reset complete\n", netdev->name);
 			clear_bit(WORK_TX_HALT, &hw->usb_flags);
 			set_bit(WORK_TX_RESUME, &hw->usb_flags);
 
@@ -718,10 +714,9 @@ static int usbctlx_rrid_completor_fn(usbctlx_completor_t *head)
 
 	/* Validate the length, note body len calculation in bytes */
 	if (rridresult.riddata_len != complete->riddatalen) {
-		printk(KERN_WARNING
-		       "RID len mismatch, rid=0x%04x hlen=%d fwlen=%d\n",
-		       rridresult.rid,
-		       complete->riddatalen, rridresult.riddata_len);
+		pr_warning("RID len mismatch, rid=0x%04x hlen=%d fwlen=%d\n",
+			   rridresult.rid,
+			   complete->riddatalen, rridresult.riddata_len);
 		return -ENODATA;
 	}
 
@@ -1211,8 +1206,7 @@ int hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis)
 
 	result = usb_reset_device(hw->usb);
 	if (result < 0) {
-		printk(KERN_ERR "usb_reset_device() failed, result=%d.\n",
-		       result);
+		pr_err("usb_reset_device() failed, result=%d.\n", result);
 	}
 
 	return result;
@@ -1311,9 +1305,9 @@ cleanup:
 		if (ctlx->state == CTLX_COMPLETE) {
 			result = completor->complete(completor);
 		} else {
-			printk(KERN_WARNING "CTLX[%d] error: state(%s)\n",
-			       le16_to_cpu(ctlx->outbuf.type),
-			       ctlxstr(ctlx->state));
+			pr_warning("CTLX[%d] error: state(%s)\n",
+				   le16_to_cpu(ctlx->outbuf.type),
+				   ctlxstr(ctlx->state));
 			result = -EIO;
 		}
 
@@ -2018,7 +2012,7 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 	if (hw->dlstate != HFA384x_DLSTATE_FLASHENABLED)
 		return -EINVAL;
 
-	printk(KERN_INFO "Download %d bytes to flash @0x%06x\n", len, daddr);
+	pr_info("Download %d bytes to flash @0x%06x\n", len, daddr);
 
 	/* Convert to flat address for arithmetic */
 	/* NOTE: dlbuffer RID stores the address in AUX format */
@@ -2028,8 +2022,8 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 		 hw->bufinfo.page, hw->bufinfo.offset, dlbufaddr);
 
 #if 0
-	printk(KERN_WARNING "dlbuf@0x%06lx len=%d to=%d\n", dlbufaddr,
-	       hw->bufinfo.len, hw->dltimeout);
+	pr_warning("dlbuf@0x%06lx len=%d to=%d\n",
+		   dlbufaddr, hw->bufinfo.len, hw->dltimeout);
 #endif
 	/* Calculations to determine how many fills of the dlbuffer to do
 	 * and how many USB wmemreq's to do for each fill.  At this point
@@ -2055,14 +2049,14 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 		burnlo = HFA384x_ADDR_CMD_MKOFF(burndaddr);
 		burnhi = HFA384x_ADDR_CMD_MKPAGE(burndaddr);
 
-		printk(KERN_INFO "Writing %d bytes to flash @0x%06x\n",
-		       burnlen, burndaddr);
+		pr_info("Writing %d bytes to flash @0x%06x\n",
+			burnlen, burndaddr);
 
 		/* Set the download mode */
 		result = hfa384x_cmd_download(hw, HFA384x_PROGMODE_NV,
 					      burnlo, burnhi, burnlen);
 		if (result) {
-			printk(KERN_ERR "download(NV,lo=%x,hi=%x,len=%x) "
+			pr_err("download(NV,lo=%x,hi=%x,len=%x) "
 			       "cmd failed, result=%d. Aborting d/l\n",
 			       burnlo, burnhi, burnlen, result);
 			goto exit_proc;
@@ -2097,8 +2091,7 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 					      HFA384x_PROGMODE_NVWRITE,
 					      0, 0, 0);
 		if (result) {
-			printk(KERN_ERR
-			       "download(NVWRITE,lo=%x,hi=%x,len=%x) "
+			pr_err("download(NVWRITE,lo=%x,hi=%x,len=%x) "
 			       "cmd failed, result=%d. Aborting d/l\n",
 			       burnlo, burnhi, burnlen, result);
 			goto exit_proc;
@@ -2286,15 +2279,14 @@ int hfa384x_drvr_ramdl_enable(hfa384x_t *hw, u32 exeaddr)
 	/* Check that a port isn't active */
 	for (i = 0; i < HFA384x_PORTID_MAX; i++) {
 		if (hw->port_enabled[i]) {
-			printk(KERN_ERR
-			       "Can't download with a macport enabled.\n");
+			pr_err("Can't download with a macport enabled\n");
 			return -EINVAL;
 		}
 	}
 
 	/* Check that we're not already in a download state */
 	if (hw->dlstate != HFA384x_DLSTATE_DISABLED) {
-		printk(KERN_ERR "Download state not disabled.\n");
+		pr_err("Download state not disabled.\n");
 		return -EINVAL;
 	}
 
@@ -2359,7 +2351,7 @@ int hfa384x_drvr_ramdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 	if (hw->dlstate != HFA384x_DLSTATE_RAMENABLED)
 		return -EINVAL;
 
-	printk(KERN_INFO "Writing %d bytes to ram @0x%06x\n", len, daddr);
+	pr_info("Writing %d bytes to ram @0x%06x\n", len, daddr);
 
 	/* How many dowmem calls?  */
 	nwrites = len / HFA384x_USB_RWMEM_MAXLEN;
@@ -2454,8 +2446,8 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 		result = hfa384x_dormem_wait(hw, currpage, curroffset, buf, len);	/* units of bytes */
 
 		if (result) {
-			printk(KERN_WARNING
-			       "Read from index %zd failed, continuing\n", i);
+			pr_warning("Read from index %zd failed, continuing\n",
+				   i);
 			continue;
 		}
 
@@ -2467,14 +2459,13 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 			pdrcode = le16_to_cpu(pda[currpdr + 1]);
 			/* Test the record length */
 			if (pdrlen > HFA384x_PDR_LEN_MAX || pdrlen == 0) {
-				printk(KERN_ERR "pdrlen invalid=%d\n", pdrlen);
+				pr_err("pdrlen invalid=%d\n", pdrlen);
 				pdaok = 0;
 				break;
 			}
 			/* Test the code */
 			if (!hfa384x_isgood_pdrcode(pdrcode)) {
-				printk(KERN_ERR "pdrcode invalid=%d\n",
-				       pdrcode);
+				pr_err("pdrcode invalid=%d\n", pdrcode);
 				pdaok = 0;
 				break;
 			}
@@ -2489,14 +2480,13 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 			}
 		}
 		if (pdaok) {
-			printk(KERN_INFO
-			       "PDA Read from 0x%08x in %s space.\n",
-			       pdaloc[i].cardaddr,
-			       pdaloc[i].auxctl == 0 ? "EXTDS" :
-			       pdaloc[i].auxctl == 1 ? "NV" :
-			       pdaloc[i].auxctl == 2 ? "PHY" :
-			       pdaloc[i].auxctl == 3 ? "ICSRAM" :
-			       "<bogus auxctl>");
+			pr_info("PDA Read from 0x%08x in %s space\n",
+				pdaloc[i].cardaddr,
+				pdaloc[i].auxctl == 0 ? "EXTDS" :
+				pdaloc[i].auxctl == 1 ? "NV" :
+				pdaloc[i].auxctl == 2 ? "PHY" :
+				pdaloc[i].auxctl == 3 ? "ICSRAM" :
+				"<bogus auxctl>");
 			break;
 		}
 	}
@@ -2569,20 +2559,20 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	result =
 	    usb_get_status(hw->usb, USB_RECIP_ENDPOINT, hw->endp_in, &status);
 	if (result < 0) {
-		printk(KERN_ERR "Cannot get bulk in endpoint status.\n");
+		pr_err("Cannot get bulk in endpoint status\n");
 		goto done;
 	}
 	if ((status == 1) && usb_clear_halt(hw->usb, hw->endp_in))
-		printk(KERN_ERR "Failed to reset bulk in endpoint.\n");
+		pr_err("Failed to reset bulk in endpoint\n");
 
 	result =
 	    usb_get_status(hw->usb, USB_RECIP_ENDPOINT, hw->endp_out, &status);
 	if (result < 0) {
-		printk(KERN_ERR "Cannot get bulk out endpoint status.\n");
+		pr_err("Cannot get bulk out endpoint status\n");
 		goto done;
 	}
 	if ((status == 1) && usb_clear_halt(hw->usb, hw->endp_out))
-		printk(KERN_ERR "Failed to reset bulk out endpoint.\n");
+		pr_err("Failed to reset bulk out endpoint\n");
 
 	/* Synchronous unlink, in case we're trying to restart the driver */
 	usb_kill_urb(&hw->rx_urb);
@@ -2590,8 +2580,7 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	/* Post the IN urb */
 	result = submit_rx_urb(hw, GFP_KERNEL);
 	if (result != 0) {
-		printk(KERN_ERR
-		       "Fatal, failed to submit RX URB, result=%d\n", result);
+		pr_err("Fatal, failed to submit RX URB, result=%d\n", result);
 		goto done;
 	}
 
@@ -2610,8 +2599,7 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	result = result2 = hfa384x_cmd_initialize(hw);
 	if (result1 != 0) {
 		if (result2 != 0) {
-			printk(KERN_ERR
-			       "cmd_initialize() failed on two attempts, results %d and %d\n",
+			pr_err("cmd_initialize() failed on two attempts, results %d and %d\n",
 			       result1, result2);
 			usb_kill_urb(&hw->rx_urb);
 			goto done;
@@ -2622,11 +2610,9 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 			    ("but second attempt succeeded. All should be ok\n");
 		}
 	} else if (result2 != 0) {
-		printk(KERN_WARNING
-		       "First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
-		       result2);
-		printk(KERN_WARNING
-		       "Most likely the card will be functional\n");
+		pr_warning("First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
+			   result2);
+		pr_warning("Most likely the card will be functional\n");
 		goto done;
 	}
 
@@ -2716,7 +2702,7 @@ int hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
 	char *ptr;
 
 	if (hw->tx_urb.status == -EINPROGRESS) {
-		printk(KERN_WARNING "TX URB already in use\n");
+		pr_warning("TX URB already in use\n");
 		result = 3;
 		goto exit;
 	}
@@ -2791,7 +2777,7 @@ int hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
 	result = 1;
 	ret = submit_tx_urb(hw, &hw->tx_urb, GFP_ATOMIC);
 	if (ret != 0) {
-		printk(KERN_ERR "submit_tx_urb() failed, error=%d\n", ret);
+		pr_err("submit_tx_urb() failed, error=%d\n", ret);
 		result = 3;
 	}
 
@@ -3014,7 +3000,7 @@ static void unlocked_usbctlx_complete(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx)
 		break;
 
 	default:
-		printk(KERN_ERR "CTLX[%d] not in a terminating state(%s)\n",
+		pr_err("CTLX[%d] not in a terminating state(%s)\n",
 		       le16_to_cpu(ctlx->outbuf.type), ctlxstr(ctlx->state));
 		break;
 	}			/* switch */
@@ -3096,9 +3082,8 @@ static void hfa384x_usbctlxq_run(hfa384x_t *hw)
 			 * this CTLX back in the "pending" queue
 			 * and schedule a reset ...
 			 */
-			printk(KERN_WARNING
-			       "%s tx pipe stalled: requesting reset\n",
-			       hw->wlandev->netdev->name);
+			pr_warning("%s tx pipe stalled: requesting reset\n",
+				   hw->wlandev->netdev->name);
 			list_move(&head->list, &hw->ctlxq.pending);
 			set_bit(WORK_TX_HALT, &hw->usb_flags);
 			schedule_work(&hw->usb_work);
@@ -3106,12 +3091,12 @@ static void hfa384x_usbctlxq_run(hfa384x_t *hw)
 		}
 
 		if (result == -ESHUTDOWN) {
-			printk(KERN_WARNING "%s urb shutdown!\n",
-			       hw->wlandev->netdev->name);
+			pr_warning("%s urb shutdown!\n",
+				   hw->wlandev->netdev->name);
 			break;
 		}
 
-		printk(KERN_ERR "Failed to submit CTLX[%d]: error=%d\n",
+		pr_err("Failed to submit CTLX[%d]: error=%d\n",
 		       le16_to_cpu(head->outbuf.type), result);
 		unlocked_usbctlx_complete(hw, head);
 	}			/* while */
@@ -3178,8 +3163,8 @@ static void hfa384x_usbin_callback(struct urb *urb)
 		break;
 
 	case -EPIPE:
-		printk(KERN_WARNING "%s rx pipe stalled: requesting reset\n",
-		       wlandev->netdev->name);
+		pr_warning("%s rx pipe stalled: requesting reset\n",
+			   wlandev->netdev->name);
 		if (!test_and_set_bit(WORK_RX_HALT, &hw->usb_flags))
 			schedule_work(&hw->usb_work);
 		++(wlandev->linux_stats.rx_errors);
@@ -3229,8 +3214,7 @@ static void hfa384x_usbin_callback(struct urb *urb)
 		result = submit_rx_urb(hw, GFP_ATOMIC);
 
 		if (result != 0) {
-			printk(KERN_ERR
-			       "Fatal, failed to resubmit rx_urb. error=%d\n",
+			pr_err("Fatal, failed to resubmit rx_urb. error=%d\n",
 			       result);
 		}
 	}
@@ -3365,10 +3349,9 @@ retry:
 		 * Check that our message is what we're expecting ...
 		 */
 		if (ctlx->outbuf.type != intype) {
-			printk(KERN_WARNING
-			       "Expected IN[%d], received IN[%d] - ignored.\n",
-			       le16_to_cpu(ctlx->outbuf.type),
-			       le16_to_cpu(intype));
+			pr_warning("Expected IN[%d], received IN[%d] - ignored\n",
+				   le16_to_cpu(ctlx->outbuf.type),
+				   le16_to_cpu(intype));
 			goto unlock;
 		}
 
@@ -3402,9 +3385,8 @@ retry:
 			/*
 			 * Throw this CTLX away ...
 			 */
-			printk(KERN_ERR
-			       "Matched IN URB, CTLX[%d] in invalid state(%s)."
-			       " Discarded.\n",
+			pr_err("Matched IN URB, CTLX[%d] in invalid state(%s)."
+			       " Discarded\n",
 			       le16_to_cpu(ctlx->outbuf.type),
 			       ctlxstr(ctlx->state));
 			if (unlocked_usbctlx_cancel_async(hw, ctlx) == 0)
@@ -3540,8 +3522,8 @@ static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 		break;
 
 	default:
-		printk(KERN_WARNING "Received frame on unsupported port=%d\n",
-		       HFA384x_RXSTATUS_MACPORT_GET(usbin->rxfrm.desc.status));
+		pr_warning("Received frame on unsupported port=%d\n",
+			   HFA384x_RXSTATUS_MACPORT_GET(usbin->rxfrm.desc.status));
 		goto done;
 		break;
 	}
@@ -3602,8 +3584,7 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 
 	skb = dev_alloc_skb(skblen);
 	if (skb == NULL) {
-		printk(KERN_ERR
-		       "alloc_skb failed trying to allocate %d bytes\n",
+		pr_err("alloc_skb failed trying to allocate %d bytes\n",
 		       skblen);
 		return;
 	}
@@ -3718,9 +3699,8 @@ static void hfa384x_usbout_callback(struct urb *urb)
 		case -EPIPE:
 			{
 				hfa384x_t *hw = wlandev->priv;
-				printk(KERN_WARNING
-				       "%s tx pipe stalled: requesting reset\n",
-				       wlandev->netdev->name);
+				pr_warning("%s tx pipe stalled: requesting reset\n",
+					   wlandev->netdev->name);
 				if (!test_and_set_bit
 				    (WORK_TX_HALT, &hw->usb_flags))
 					schedule_work(&hw->usb_work);
@@ -3751,8 +3731,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
 			break;
 
 		default:
-			printk(KERN_INFO "unknown urb->status=%d\n",
-			       urb->status);
+			pr_info("unknown urb->status=%d\n", urb->status);
 			++(wlandev->linux_stats.tx_errors);
 			break;
 		}		/* switch */
@@ -3845,8 +3824,7 @@ retry:
 
 		default:
 			/* This is NOT a valid CTLX "success" state! */
-			printk(KERN_ERR
-			       "Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
+			pr_err("Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
 			       le16_to_cpu(ctlx->outbuf.type),
 			       ctlxstr(ctlx->state), urb->status);
 			break;
@@ -3855,9 +3833,8 @@ retry:
 		/* If the pipe has stalled then we need to reset it */
 		if ((urb->status == -EPIPE) &&
 		    !test_and_set_bit(WORK_TX_HALT, &hw->usb_flags)) {
-			printk(KERN_WARNING
-			       "%s tx pipe stalled: requesting reset\n",
-			       hw->wlandev->netdev->name);
+			pr_warning("%s tx pipe stalled: requesting reset\n",
+				   hw->wlandev->netdev->name);
 			schedule_work(&hw->usb_work);
 		}
 


