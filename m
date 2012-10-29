Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401Ab2J2WCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:02:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:47864 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab2J2Vht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 069/101] USB: mos7840: remove NULL-urb submission
Date: Mon, 29 Oct 2012 14:35:22 -0700
Message-Id: <20121029213247.957698308@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 28c3ae9a8cf45f439c9a0779ebd0256e2ae72813 upstream.

The private int_urb is never allocated so the submission from the
control completion handler will always fail. Remove this odd piece of
broken code.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -218,7 +218,6 @@ struct moschip_port {
 	int port_num;		/*Actual port number in the device(1,2,etc) */
 	struct urb *write_urb;	/* write URB for this port */
 	struct urb *read_urb;	/* read URB for this port */
-	struct urb *int_urb;
 	__u8 shadowLCR;		/* last LCR value received */
 	__u8 shadowMCR;		/* last MCR value received */
 	char open;
@@ -493,7 +492,6 @@ static void mos7840_control_callback(str
 	unsigned char *data;
 	struct moschip_port *mos7840_port;
 	__u8 regval = 0x0;
-	int result = 0;
 	int status = urb->status;
 
 	mos7840_port = urb->context;
@@ -512,7 +510,7 @@ static void mos7840_control_callback(str
 	default:
 		dbg("%s - nonzero urb status received: %d", __func__,
 		    status);
-		goto exit;
+		return;
 	}
 
 	dbg("%s urb buffer size is %d", __func__, urb->actual_length);
@@ -525,17 +523,6 @@ static void mos7840_control_callback(str
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


