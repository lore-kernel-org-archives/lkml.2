Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab2J1X1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:27:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41884 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532Ab2J1X1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:23 -0400
Message-Id: <20121028231604.341572770@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:04 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 088/105] USB: mos7840: remove NULL-urb submission
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 28c3ae9a8cf45f439c9a0779ebd0256e2ae72813 upstream.

The private int_urb is never allocated so the submission from the
control completion handler will always fail. Remove this odd piece of
broken code.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mos7840.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -235,7 +235,6 @@ struct moschip_port {
 	int port_num;		/*Actual port number in the device(1,2,etc) */
 	struct urb *write_urb;	/* write URB for this port */
 	struct urb *read_urb;	/* read URB for this port */
-	struct urb *int_urb;
 	__u8 shadowLCR;		/* last LCR value received */
 	__u8 shadowMCR;		/* last MCR value received */
 	char open;
@@ -505,7 +504,6 @@ static void mos7840_control_callback(str
 	unsigned char *data;
 	struct moschip_port *mos7840_port;
 	__u8 regval = 0x0;
-	int result = 0;
 	int status = urb->status;
 
 	mos7840_port = urb->context;
@@ -524,7 +522,7 @@ static void mos7840_control_callback(str
 	default:
 		dbg("%s - nonzero urb status received: %d", __func__,
 		    status);
-		goto exit;
+		return;
 	}
 
 	dbg("%s urb buffer size is %d", __func__, urb->actual_length);
@@ -537,17 +535,6 @@ static void mos7840_control_callback(str
 		mos7840_handle_new_msr(mos7840_port, regval);
 	else if (mos7840_port->MsrLsr == 1)
 		mos7840_handle_new_lsr(mos7840_port, regval);
-
-exit:
-	spin_lock(&mos7840_port->pool_lock);
-	if (!mos7840_port->zombie)
-		result = usb_submit_urb(mos7840_port->int_urb, GFP_ATOMIC);
-	spin_unlock(&mos7840_port->pool_lock);
-	if (result) {
-		dev_err(&urb->dev->dev,
-			"%s - Error %d submitting interrupt urb\n",
-			__func__, result);
-	}
 }
 
 static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,


