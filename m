Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab2KZRPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:15:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab2KZRPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 251/270] USB: mos7840: remove invalid disconnect handling
Date: Mon, 26 Nov 2012 14:59:01 -0200
Message-Id: <1353949160-26803-252-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e681b66f2e19fadbe8a7e2a17900978cb6bc921f upstream.

Remove private zombie flag used to signal disconnect and to prevent
control urb from being submitted from interrupt urb completion handler.

The control urb will not be re-submitted as both the control urb and the
interrupt urb is killed on disconnect.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/mos7840.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index eab84c1..9b819c4 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -223,7 +223,6 @@ struct moschip_port {
 	__u8 shadowMCR;		/* last MCR value received */
 	char open;
 	char open_ports;
-	char zombie;
 	wait_queue_head_t wait_chase;	/* for handling sleeping while waiting for chase to finish */
 	wait_queue_head_t delta_msr_wait;	/* for handling sleeping while waiting for msr change to happen */
 	int delta_msr_cond;
@@ -692,14 +691,7 @@ static void mos7840_interrupt_callback(struct urb *urb)
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
@@ -2701,9 +2693,6 @@ static void mos7840_disconnect(struct usb_serial *serial)
 		mos7840_port = mos7840_get_port_private(serial->port[i]);
 		dbg ("mos7840_port %d = %p", i, mos7840_port);
 		if (mos7840_port) {
-			spin_lock_irqsave(&mos7840_port->pool_lock, flags);
-			mos7840_port->zombie = 1;
-			spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
 			usb_kill_urb(mos7840_port->control_urb);
 		}
 	}
-- 
1.7.9.5

