Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2HGTxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:53:15 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:52847 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2HGTxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:53:14 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2012 15:53:13 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 35/41] TTY: synclink, add tty install
Date: Tue,  7 Aug 2012 21:48:00 +0200
Message-Id: <1344368886-24033-36-git-send-email-jslaby@suse.cz>
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
---
 drivers/tty/synclink.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index bdeeb31..f147ccb 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3362,6 +3362,29 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	
 }	/* end of block_til_ready() */
 
+static int mgsl_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct mgsl_struct *info;
+	int line = tty->index;
+
+	/* verify range of specified line number */
+	if (line >= mgsl_device_count) {
+		printk("%s(%d):mgsl_open with invalid line #%d.\n",
+			__FILE__, __LINE__, line);
+		return -ENODEV;
+	}
+
+	/* find the info structure for the specified line */
+	info = mgsl_device_list;
+	while (info && info->line != line)
+		info = info->next_device;
+	if (mgsl_paranoia_check(info, tty->name, "mgsl_open"))
+		return -ENODEV;
+	tty->driver_data = info;
+
+	return tty_port_install(&info->port, driver, tty);
+}
+
 /* mgsl_open()
  *
  *	Called when a port is opened.  Init and enable port.
@@ -3374,26 +3397,10 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
  */
 static int mgsl_open(struct tty_struct *tty, struct file * filp)
 {
-	struct mgsl_struct	*info;
-	int 			retval, line;
+	struct mgsl_struct *info = tty->driver_data;
 	unsigned long flags;
+	int retval;
 
-	/* verify range of specified line number */	
-	line = tty->index;
-	if (line >= mgsl_device_count) {
-		printk("%s(%d):mgsl_open with invalid line #%d.\n",
-			__FILE__,__LINE__,line);
-		return -ENODEV;
-	}
-
-	/* find the info structure for the specified line */
-	info = mgsl_device_list;
-	while(info && info->line != line)
-		info = info->next_device;
-	if (mgsl_paranoia_check(info, tty->name, "mgsl_open"))
-		return -ENODEV;
-	
-	tty->driver_data = info;
 	info->port.tty = tty;
 		
 	if (debug_level >= DEBUG_LEVEL_INFO)
@@ -4297,6 +4304,7 @@ static struct mgsl_struct* mgsl_allocate_device(void)
 }	/* end of mgsl_allocate_device()*/
 
 static const struct tty_operations mgsl_ops = {
+	.install = mgsl_install,
 	.open = mgsl_open,
 	.close = mgsl_close,
 	.write = mgsl_write,
-- 
1.7.10.4


