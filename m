Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab2J1X11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:27:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41883 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756501Ab2J1X1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:23 -0400
Message-Id: <20121028231604.657093197@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:05 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 089/105] USB: mos7840: remove invalid disconnect handling
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

commit e681b66f2e19fadbe8a7e2a17900978cb6bc921f upstream.

Remove private zombie flag used to signal disconnect and to prevent
control urb from being submitted from interrupt urb completion handler.

The control urb will not be re-submitted as both the control urb and the
interrupt urb is killed on disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mos7840.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -239,7 +239,6 @@ struct moschip_port {
 	__u8 shadowMCR;		/* last MCR value received */
 	char open;
 	char open_ports;
-	char zombie;
 	wait_queue_head_t wait_chase;	/* for handling sleeping while waiting for chase to finish */
 	wait_queue_head_t delta_msr_wait;	/* for handling sleeping while waiting for msr change to happen */
 	int delta_msr_cond;
@@ -642,14 +641,7 @@ static void mos7840_interrupt_callback(s
 					wreg = MODEM_STATUS_REGISTER;
 					break;
 				}
-				spin_lock(&mos7840_port->pool_lock);
-				if (!mos7840_port->zombie) {
-					rv = mos7840_get_reg(mos7840_port, wval, wreg, &Data);
-				} else {
-					spin_unlock(&mos7840_port->pool_lock);
-					return;
-				}
-				spin_unlock(&mos7840_port->pool_lock);
+				rv = mos7840_get_reg(mos7840_port, wval, wreg, &Data);
 			}
 		}
 	}
@@ -2611,9 +2603,6 @@ static void mos7840_disconnect(struct us
 		mos7840_port = mos7840_get_port_private(serial->port[i]);
 		dbg ("mos7840_port %d = %p", i, mos7840_port);
 		if (mos7840_port) {
-			spin_lock_irqsave(&mos7840_port->pool_lock, flags);
-			mos7840_port->zombie = 1;
-			spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
 			usb_kill_urb(mos7840_port->control_urb);
 		}
 	}


