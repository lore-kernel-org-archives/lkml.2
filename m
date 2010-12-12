Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab0LMA3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:29:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44707 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0LLXpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:24 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: tilman@imap.cc, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [27/223] isdn/gigaset: fix bas_gigaset AT read error handling
Message-Id: <20101212234523.47BE1B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tilman Schmidt <tilman@imap.cc>

commit c8701a08d6a4efeae45d84d0aa87172f23b14e3c upstream.

Rework the handling of USB errors in AT response reads
to fix a possible infinite retry loop and a memory leak,
and silence a few overly verbose kernel messages.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/isdn/gigaset/bas-gigaset.c |   83 ++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 50 deletions(-)

Index: linux/drivers/isdn/gigaset/bas-gigaset.c
===================================================================
--- linux.orig/drivers/isdn/gigaset/bas-gigaset.c
+++ linux/drivers/isdn/gigaset/bas-gigaset.c
@@ -438,23 +438,27 @@ static void cmd_in_timeout(unsigned long
 		return;
 	}
 
-	if (ucs->retry_cmd_in++ < BAS_RETRY) {
-		dev_notice(cs->dev, "control read: timeout, retry %d\n",
-			   ucs->retry_cmd_in);
-		rc = atread_submit(cs, BAS_TIMEOUT);
-		if (rc >= 0 || rc == -ENODEV)
-			/* resubmitted or disconnected */
-			/* - bypass regular exit block */
-			return;
-	} else {
+	if (ucs->retry_cmd_in++ >= BAS_RETRY) {
 		dev_err(cs->dev,
 			"control read: timeout, giving up after %d tries\n",
 			ucs->retry_cmd_in);
+		kfree(ucs->rcvbuf);
+		ucs->rcvbuf = NULL;
+		ucs->rcvbuf_size = 0;
+		error_reset(cs);
+		return;
+	}
+
+	gig_dbg(DEBUG_USBREQ, "%s: timeout, retry %d",
+		__func__, ucs->retry_cmd_in);
+	rc = atread_submit(cs, BAS_TIMEOUT);
+	if (rc < 0) {
+		kfree(ucs->rcvbuf);
+		ucs->rcvbuf = NULL;
+		ucs->rcvbuf_size = 0;
+		if (rc != -ENODEV)
+			error_reset(cs);
 	}
-	kfree(ucs->rcvbuf);
-	ucs->rcvbuf = NULL;
-	ucs->rcvbuf_size = 0;
-	error_reset(cs);
 }
 
 /* read_ctrl_callback
@@ -470,18 +474,11 @@ static void read_ctrl_callback(struct ur
 	struct cardstate *cs = inbuf->cs;
 	struct bas_cardstate *ucs = cs->hw.bas;
 	int status = urb->status;
-	int have_data = 0;
 	unsigned numbytes;
 	int rc;
 
 	update_basstate(ucs, 0, BS_ATRDPEND);
 	wake_up(&ucs->waitqueue);
-
-	if (!ucs->rcvbuf_size) {
-		dev_warn(cs->dev, "%s: no receive in progress\n", __func__);
-		return;
-	}
-
 	del_timer(&ucs->timer_cmd_in);
 
 	switch (status) {
@@ -495,19 +492,10 @@ static void read_ctrl_callback(struct ur
 				numbytes = ucs->rcvbuf_size;
 		}
 
-		/* copy received bytes to inbuf */
-		have_data = gigaset_fill_inbuf(inbuf, ucs->rcvbuf, numbytes);
-
-		if (unlikely(numbytes < ucs->rcvbuf_size)) {
-			/* incomplete - resubmit for remaining bytes */
-			ucs->rcvbuf_size -= numbytes;
-			ucs->retry_cmd_in = 0;
-			rc = atread_submit(cs, BAS_TIMEOUT);
-			if (rc >= 0 || rc == -ENODEV)
-				/* resubmitted or disconnected */
-				/* - bypass regular exit block */
-				return;
-			error_reset(cs);
+		/* copy received bytes to inbuf, notify event layer */
+		if (gigaset_fill_inbuf(inbuf, ucs->rcvbuf, numbytes)) {
+			gig_dbg(DEBUG_INTR, "%s-->BH", __func__);
+			gigaset_schedule_event(cs);
 		}
 		break;
 
@@ -516,37 +504,32 @@ static void read_ctrl_callback(struct ur
 	case -EINPROGRESS:		/* pending */
 	case -ENODEV:			/* device removed */
 	case -ESHUTDOWN:		/* device shut down */
-		/* no action necessary */
+		/* no further action necessary */
 		gig_dbg(DEBUG_USBREQ, "%s: %s",
 			__func__, get_usb_statmsg(status));
 		break;
 
-	default:			/* severe trouble */
-		dev_warn(cs->dev, "control read: %s\n",
-			 get_usb_statmsg(status));
+	default:			/* other errors: retry */
 		if (ucs->retry_cmd_in++ < BAS_RETRY) {
-			dev_notice(cs->dev, "control read: retry %d\n",
-				   ucs->retry_cmd_in);
+			gig_dbg(DEBUG_USBREQ, "%s: %s, retry %d", __func__,
+				get_usb_statmsg(status), ucs->retry_cmd_in);
 			rc = atread_submit(cs, BAS_TIMEOUT);
-			if (rc >= 0 || rc == -ENODEV)
-				/* resubmitted or disconnected */
-				/* - bypass regular exit block */
+			if (rc >= 0)
+				/* successfully resubmitted, skip freeing */
 				return;
-		} else {
-			dev_err(cs->dev,
-				"control read: giving up after %d tries\n",
-				ucs->retry_cmd_in);
+			if (rc == -ENODEV)
+				/* disconnect, no further action necessary */
+				break;
 		}
+		dev_err(cs->dev, "control read: %s, giving up after %d tries\n",
+			get_usb_statmsg(status), ucs->retry_cmd_in);
 		error_reset(cs);
 	}
 
+	/* read finished, free buffer */
 	kfree(ucs->rcvbuf);
 	ucs->rcvbuf = NULL;
 	ucs->rcvbuf_size = 0;
-	if (have_data) {
-		gig_dbg(DEBUG_INTR, "%s-->BH", __func__);
-		gigaset_schedule_event(cs);
-	}
 }
 
 /* atread_submit
