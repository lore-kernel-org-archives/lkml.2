Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab2DBL4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:33 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48125 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2DBLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jiri Kosina <jkosina@suse.cz>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 49/69] TTY: ipwireless, add tty_port
Date: Mon,  2 Apr 2012 13:54:33 +0200
Message-Id: <1333367693-3244-50-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use count from that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
---
 drivers/tty/ipwireless/tty.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index 4270bfd..0b4964d 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -44,6 +44,7 @@
 #define TTYTYPE_RAS_RAW  (2)
 
 struct ipw_tty {
+	struct tty_port port;
 	int index;
 	struct ipw_hardware *hardware;
 	unsigned int channel_idx;
@@ -51,7 +52,6 @@ struct ipw_tty {
 	int tty_type;
 	struct ipw_network *network;
 	struct tty_struct *linux_tty;
-	int open_count;
 	unsigned int control_lines;
 	struct mutex ipw_tty_mutex;
 	int tx_bytes_queued;
@@ -100,10 +100,10 @@ static int ipw_open(struct tty_struct *linux_tty, struct file *filp)
 		mutex_unlock(&tty->ipw_tty_mutex);
 		return -ENODEV;
 	}
-	if (tty->open_count == 0)
+	if (tty->port.count == 0)
 		tty->tx_bytes_queued = 0;
 
-	tty->open_count++;
+	tty->port.count++;
 
 	tty->linux_tty = linux_tty;
 	linux_tty->driver_data = tty;
@@ -119,9 +119,9 @@ static int ipw_open(struct tty_struct *linux_tty, struct file *filp)
 
 static void do_ipw_close(struct ipw_tty *tty)
 {
-	tty->open_count--;
+	tty->port.count--;
 
-	if (tty->open_count == 0) {
+	if (tty->port.count == 0) {
 		struct tty_struct *linux_tty = tty->linux_tty;
 
 		if (linux_tty != NULL) {
@@ -142,7 +142,7 @@ static void ipw_hangup(struct tty_struct *linux_tty)
 		return;
 
 	mutex_lock(&tty->ipw_tty_mutex);
-	if (tty->open_count == 0) {
+	if (tty->port.count == 0) {
 		mutex_unlock(&tty->ipw_tty_mutex);
 		return;
 	}
@@ -171,7 +171,7 @@ void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
 		return;
 	}
 
-	if (!tty->open_count) {
+	if (!tty->port.count) {
 		mutex_unlock(&tty->ipw_tty_mutex);
 		return;
 	}
@@ -213,7 +213,7 @@ static int ipw_write(struct tty_struct *linux_tty,
 		return -ENODEV;
 
 	mutex_lock(&tty->ipw_tty_mutex);
-	if (!tty->open_count) {
+	if (!tty->port.count) {
 		mutex_unlock(&tty->ipw_tty_mutex);
 		return -EINVAL;
 	}
@@ -253,7 +253,7 @@ static int ipw_write_room(struct tty_struct *linux_tty)
 	if (!tty)
 		return -ENODEV;
 
-	if (!tty->open_count)
+	if (!tty->port.count)
 		return -EINVAL;
 
 	room = IPWIRELESS_TX_QUEUE_SIZE - tty->tx_bytes_queued;
@@ -295,7 +295,7 @@ static int ipw_chars_in_buffer(struct tty_struct *linux_tty)
 	if (!tty)
 		return 0;
 
-	if (!tty->open_count)
+	if (!tty->port.count)
 		return 0;
 
 	return tty->tx_bytes_queued;
@@ -376,7 +376,7 @@ static int ipw_tiocmget(struct tty_struct *linux_tty)
 	if (!tty)
 		return -ENODEV;
 
-	if (!tty->open_count)
+	if (!tty->port.count)
 		return -EINVAL;
 
 	return get_control_lines(tty);
@@ -392,7 +392,7 @@ ipw_tiocmset(struct tty_struct *linux_tty,
 	if (!tty)
 		return -ENODEV;
 
-	if (!tty->open_count)
+	if (!tty->port.count)
 		return -EINVAL;
 
 	return set_control_lines(tty, set, clear);
@@ -406,7 +406,7 @@ static int ipw_ioctl(struct tty_struct *linux_tty,
 	if (!tty)
 		return -ENODEV;
 
-	if (!tty->open_count)
+	if (!tty->port.count)
 		return -EINVAL;
 
 	/* FIXME: Exactly how is the tty object locked here .. */
@@ -475,6 +475,7 @@ static int add_tty(int j,
 	ttys[j]->network = network;
 	ttys[j]->tty_type = tty_type;
 	mutex_init(&ttys[j]->ipw_tty_mutex);
+	tty_port_init(&ttys[j]->port);
 
 	tty_register_device(ipw_tty_driver, j, NULL);
 	ipwireless_associate_network_tty(network, channel_idx, ttys[j]);
@@ -561,7 +562,7 @@ void ipwireless_tty_free(struct ipw_tty *tty)
 				 * are gone */
 				mutex_lock(&ttyj->ipw_tty_mutex);
 			}
-			while (ttyj->open_count)
+			while (ttyj->port.count)
 				do_ipw_close(ttyj);
 			ipwireless_disassociate_network_ttys(network,
 							     ttyj->channel_idx);
-- 
1.7.9.2


