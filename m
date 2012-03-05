Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965165Ab2CEOAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:00:55 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34784 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964796Ab2CENxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 34/68] TTY: amiserial, simplify set_serial_info
Date: Mon,  5 Mar 2012 14:52:21 +0100
Message-Id: <1330955575-26641-35-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not copy whole serial_state. We only need to know whether the speed
is to be changed. Hence store the info in advance and use it later.
A simple bool is enough.

Also remove reduntant assignments and move the tests directly to the
'if'.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/tty/amiserial.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 410e8e7..165cd79 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1042,21 +1042,19 @@ static int set_serial_info(struct serial_state *state,
 			   struct serial_struct __user * new_info)
 {
 	struct serial_struct new_serial;
-	struct serial_state old_state;
-	unsigned int		change_irq,change_port;
+	bool change_spd;
 	int 			retval = 0;
 
 	if (copy_from_user(&new_serial,new_info,sizeof(new_serial)))
 		return -EFAULT;
 
 	tty_lock();
-	old_state = *state;
-  
-	change_irq = new_serial.irq != state->irq;
-	change_port = (new_serial.port != state->port);
-	if(change_irq || change_port || (new_serial.xmit_fifo_size != state->xmit_fifo_size)) {
-	  tty_unlock();
-	  return -EINVAL;
+	change_spd = ((new_serial.flags ^ state->flags) & ASYNC_SPD_MASK) ||
+		new_serial.custom_divisor != state->custom_divisor;
+	if (new_serial.irq != state->irq || new_serial.port != state->port ||
+			new_serial.xmit_fifo_size != state->xmit_fifo_size) {
+		tty_unlock();
+		return -EINVAL;
 	}
   
 	if (!serial_isroot()) {
@@ -1092,9 +1090,7 @@ static int set_serial_info(struct serial_state *state,
 
 check_and_exit:
 	if (state->flags & ASYNC_INITIALIZED) {
-		if (((old_state.flags & ASYNC_SPD_MASK) !=
-		     (state->flags & ASYNC_SPD_MASK)) ||
-		    (old_state.custom_divisor != state->custom_divisor)) {
+		if (change_spd) {
 			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 				state->tty->alt_speed = 57600;
 			if ((state->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-- 
1.7.9.2


