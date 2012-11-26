Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188Ab2KZRWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:22:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061Ab2KZRPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 250/270] USB: mos7840: remove NULL-urb submission
Date: Mon, 26 Nov 2012 14:59:00 -0200
Message-Id: <1353949160-26803-251-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 28c3ae9a8cf45f439c9a0779ebd0256e2ae72813 upstream.

The private int_urb is never allocated so the submission from the
control completion handler will always fail. Remove this odd piece of
broken code.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ herton: adjusted context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/mos7840.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index f717db4..eab84c1 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -219,7 +219,6 @@ struct moschip_port {
 	int port_num;		/*Actual port number in the device(1,2,etc) */
 	struct urb *write_urb;	/* write URB for this port */
 	struct urb *read_urb;	/* read URB for this port */
-	struct urb *int_urb;
 	__u8 shadowLCR;		/* last LCR value received */
 	__u8 shadowMCR;		/* last MCR value received */
 	char open;
@@ -494,7 +493,6 @@ static void mos7840_control_callback(struct urb *urb)
 	unsigned char *data;
 	struct moschip_port *mos7840_port;
 	__u8 regval = 0x0;
-	int result = 0;
 	int status = urb->status;
 
 	mos7840_port = urb->context;
@@ -513,7 +511,7 @@ static void mos7840_control_callback(struct urb *urb)
 	default:
 		dbg("%s - nonzero urb status received: %d", __func__,
 		    status);
-		goto exit;
+		return;
 	}
 
 	dbg("%s urb buffer size is %d", __func__, urb->actual_length);
@@ -526,17 +524,6 @@ static void mos7840_control_callback(struct urb *urb)
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
-- 
1.7.9.5

