Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555Ab2J2WEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:04:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:47800 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761330Ab2J2Vhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 070/101] USB: mos7840: remove invalid disconnect handling
Date: Mon, 29 Oct 2012 14:35:23 -0700
Message-Id: <20121029213248.065841214@linuxfoundation.org>
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

commit e681b66f2e19fadbe8a7e2a17900978cb6bc921f upstream.

Remove private zombie flag used to signal disconnect and to prevent
control urb from being submitted from interrupt urb completion handler.

The control urb will not be re-submitted as both the control urb and the
interrupt urb is killed on disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -222,7 +222,6 @@ struct moschip_port {
 	__u8 shadowMCR;		/* last MCR value received */
 	char open;
 	char open_ports;
-	char zombie;
 	wait_queue_head_t wait_chase;	/* for handling sleeping while waiting for chase to finish */
 	wait_queue_head_t delta_msr_wait;	/* for handling sleeping while waiting for msr change to happen */
 	int delta_msr_cond;
@@ -691,14 +690,7 @@ static void mos7840_interrupt_callback(s
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
@@ -2700,9 +2692,6 @@ static void mos7840_disconnect(struct us
 		mos7840_port = mos7840_get_port_private(serial->port[i]);
 		dbg ("mos7840_port %d = %p", i, mos7840_port);
 		if (mos7840_port) {
-			spin_lock_irqsave(&mos7840_port->pool_lock, flags);
-			mos7840_port->zombie = 1;
-			spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
 			usb_kill_urb(mos7840_port->control_urb);
 		}
 	}


