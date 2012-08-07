Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab2HGT52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:57:28 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49901 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab2HGT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:57:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 03/41] TTY: n_gsm, use tty_port_install
Date: Tue,  7 Aug 2012 21:47:28 +0200
Message-Id: <1344368886-24033-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to link a port to a tty in install. And since dlci is
allocated even in open, we need to create gsmtty_install, allocate
dlci there and create also the link.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/n_gsm.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 7a4bf30..3778687 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2868,14 +2868,14 @@ static const struct tty_port_operations gsm_port_ops = {
 	.dtr_rts = gsm_dtr_rts,
 };
 
-
-static int gsmtty_open(struct tty_struct *tty, struct file *filp)
+static int gsmtty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	struct gsm_mux *gsm;
 	struct gsm_dlci *dlci;
-	struct tty_port *port;
 	unsigned int line = tty->index;
 	unsigned int mux = line >> 6;
+	bool alloc = false;
+	int ret;
 
 	line = line & 0x3F;
 
@@ -2890,13 +2890,30 @@ static int gsmtty_open(struct tty_struct *tty, struct file *filp)
 	if (gsm->dead)
 		return -EL2HLT;
 	dlci = gsm->dlci[line];
-	if (dlci == NULL)
+	if (dlci == NULL) {
+		alloc = true;
 		dlci = gsm_dlci_alloc(gsm, line);
+	}
 	if (dlci == NULL)
 		return -ENOMEM;
-	port = &dlci->port;
-	port->count++;
+	ret = tty_port_install(&dlci->port, driver, tty);
+	if (ret) {
+		if (alloc)
+			dlci_put(dlci);
+		return ret;
+	}
+
 	tty->driver_data = dlci;
+
+	return 0;
+}
+
+static int gsmtty_open(struct tty_struct *tty, struct file *filp)
+{
+	struct gsm_dlci *dlci = tty->driver_data;
+	struct tty_port *port = &dlci->port;
+
+	port->count++;
 	dlci_get(dlci);
 	dlci_get(dlci->gsm->dlci[0]);
 	mux_get(dlci->gsm);
@@ -3085,6 +3102,7 @@ static int gsmtty_break_ctl(struct tty_struct *tty, int state)
 
 /* Virtual ttys for the demux */
 static const struct tty_operations gsmtty_ops = {
+	.install		= gsmtty_install,
 	.open			= gsmtty_open,
 	.close			= gsmtty_close,
 	.write			= gsmtty_write,
-- 
1.7.10.4


