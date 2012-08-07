Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2HGTx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:53:28 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:52863 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2HGTx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:53:26 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2012 15:53:25 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 33/41] TTY: con3215, add tty install
Date: Tue,  7 Aug 2012 21:47:58 +0200
Message-Id: <1344368886-24033-34-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has two outcomes:
* we give the TTY layer a tty_port
* we do not find the info structure every time open is called on that
  tty

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/con3215.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 1655498..9ffb6d5 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -942,6 +942,19 @@ static int __init con3215_init(void)
 console_initcall(con3215_init);
 #endif
 
+static int tty3215_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct raw3215_info *raw;
+
+	raw = raw3215[tty->index];
+	if (raw == NULL)
+		return -ENODEV;
+
+	tty->driver_data = raw;
+
+	return tty_port_install(&raw->port, driver, tty);
+}
+
 /*
  * tty3215_open
  *
@@ -949,14 +962,9 @@ console_initcall(con3215_init);
  */
 static int tty3215_open(struct tty_struct *tty, struct file * filp)
 {
-	struct raw3215_info *raw;
+	struct raw3215_info *raw = tty->driver_data;
 	int retval;
 
-	raw = raw3215[tty->index];
-	if (raw == NULL)
-		return -ENODEV;
-
-	tty->driver_data = raw;
 	tty_port_tty_set(&raw->port, tty);
 
 	tty->low_latency = 0;  /* don't use bottom half for pushing chars */
@@ -1117,6 +1125,7 @@ static void tty3215_start(struct tty_struct *tty)
 }
 
 static const struct tty_operations tty3215_ops = {
+	.install = tty3215_install,
 	.open = tty3215_open,
 	.close = tty3215_close,
 	.write = tty3215_write,
-- 
1.7.10.4


