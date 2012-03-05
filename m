Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964926Ab2CEOJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:09:39 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34637 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab2CENxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 49/68] TTY: simserial, properly refcount tty_port->tty
Date: Mon,  5 Mar 2012 14:52:36 +0100
Message-Id: <1330955575-26641-50-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we will not be surprised in the ISR anymore.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 2cd6d23..b3ec91c 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -107,7 +107,7 @@ static void receive_chars(struct tty_struct *tty)
 static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 {
 	struct serial_state *info = dev_id;
-	struct tty_struct *tty = info->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&info->port);
 
 	if (!tty) {
 		printk(KERN_INFO "simrs_interrupt_single: info|tty=0 info=%p problem\n", info);
@@ -118,6 +118,7 @@ static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 	 * on inbound traffic
 	 */
 	receive_chars(tty);
+	tty_kref_put(tty);
 	return IRQ_HANDLED;
 }
 
@@ -443,9 +444,9 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 	 */
 	shutdown(tty, info);
 	rs_flush_buffer(tty);
-	port->tty = NULL;
 
 	tty_port_close_end(port, tty);
+	tty_port_tty_set(port, NULL);
 }
 
 /*
@@ -467,7 +468,7 @@ static void rs_hangup(struct tty_struct *tty)
 
 	port->count = 0;
 	port->flags &= ~ASYNC_NORMAL_ACTIVE;
-	port->tty = NULL;
+	tty_port_tty_set(port, NULL);
 	wake_up_interruptible(&port->open_wait);
 }
 
@@ -556,7 +557,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	int retval;
 
 	port->count++;
-	port->tty = tty;
+	tty_port_tty_set(port, tty);
 	tty->driver_data = info;
 	tty->port = port;
 
-- 
1.7.9.2


