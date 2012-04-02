Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2DBL4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:54 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48194 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2DBLzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jiri Kosina <jkosina@suse.cz>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 50/69] TTY: ipwireless, use tty from tty_port
Date: Mon,  2 Apr 2012 13:54:34 +0200
Message-Id: <1333367693-3244-51-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not make the driver less racy though. Close and hangup should
be rewritten and tty refcounting used properly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
---
 drivers/tty/ipwireless/tty.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index 0b4964d..f8b5fa0 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -51,7 +51,6 @@ struct ipw_tty {
 	unsigned int secondary_channel_idx;
 	int tty_type;
 	struct ipw_network *network;
-	struct tty_struct *linux_tty;
 	unsigned int control_lines;
 	struct mutex ipw_tty_mutex;
 	int tx_bytes_queued;
@@ -105,7 +104,7 @@ static int ipw_open(struct tty_struct *linux_tty, struct file *filp)
 
 	tty->port.count++;
 
-	tty->linux_tty = linux_tty;
+	tty->port.tty = linux_tty;
 	linux_tty->driver_data = tty;
 	linux_tty->low_latency = 1;
 
@@ -122,10 +121,10 @@ static void do_ipw_close(struct ipw_tty *tty)
 	tty->port.count--;
 
 	if (tty->port.count == 0) {
-		struct tty_struct *linux_tty = tty->linux_tty;
+		struct tty_struct *linux_tty = tty->port.tty;
 
 		if (linux_tty != NULL) {
-			tty->linux_tty = NULL;
+			tty->port.tty = NULL;
 			linux_tty->driver_data = NULL;
 
 			if (tty->tty_type == TTYTYPE_MODEM)
@@ -165,7 +164,7 @@ void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
 	int work = 0;
 
 	mutex_lock(&tty->ipw_tty_mutex);
-	linux_tty = tty->linux_tty;
+	linux_tty = tty->port.tty;
 	if (linux_tty == NULL) {
 		mutex_unlock(&tty->ipw_tty_mutex);
 		return;
@@ -553,9 +552,9 @@ void ipwireless_tty_free(struct ipw_tty *tty)
 				       ": deregistering %s device ttyIPWp%d\n",
 				       tty_type_name(ttyj->tty_type), j);
 			ttyj->closing = 1;
-			if (ttyj->linux_tty != NULL) {
+			if (ttyj->port.tty != NULL) {
 				mutex_unlock(&ttyj->ipw_tty_mutex);
-				tty_vhangup(ttyj->linux_tty);
+				tty_vhangup(ttyj->port.tty);
 				/* FIXME: Exactly how is the tty object locked here
 				   against a parallel ioctl etc */
 				/* FIXME2: hangup does not mean all processes
@@ -651,8 +650,8 @@ ipwireless_tty_notify_control_line_change(struct ipw_tty *tty,
 	 */
 	if ((old_control_lines & IPW_CONTROL_LINE_DCD)
 			&& !(tty->control_lines & IPW_CONTROL_LINE_DCD)
-			&& tty->linux_tty) {
-		tty_hangup(tty->linux_tty);
+			&& tty->port.tty) {
+		tty_hangup(tty->port.tty);
 	}
 }
 
-- 
1.7.9.2


