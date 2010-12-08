Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0LHBur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:50:47 -0500
Received: from kroah.org ([198.145.64.141]:48639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab0LHA7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:54 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:27 2010
Message-Id: <20101208005727.427978669@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [061/289] isdn/gigaset: fix bas_gigaset AT read error handling
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit c8701a08d6a4efeae45d84d0aa87172f23b14e3c upstream.

Rework the handling of USB errors in AT response reads
to fix a possible infinite retry loop and a memory leak,
and silence a few overly verbose kernel messages.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/bas-gigaset.c |   83 ++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 50 deletions(-)

--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
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


