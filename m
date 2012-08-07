Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2HGTxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:53:22 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:52854 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2HGTxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:53:19 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 36/41] TTY: synclinkmp, add tty install
Date: Tue,  7 Aug 2012 21:48:01 +0200
Message-Id: <1344368886-24033-37-git-send-email-jslaby@suse.cz>
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
 drivers/tty/synclinkmp.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index ae75a3c..b7c0a53 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -711,15 +711,11 @@ static void ldisc_receive_buf(struct tty_struct *tty,
 
 /* tty callbacks */
 
-/* Called when a port is opened.  Init and enable port.
- */
-static int open(struct tty_struct *tty, struct file *filp)
+static int install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	SLMP_INFO *info;
-	int retval, line;
-	unsigned long flags;
+	int line = tty->index;
 
-	line = tty->index;
 	if (line >= synclinkmp_device_count) {
 		printk("%s(%d): open with invalid line #%d.\n",
 			__FILE__,__LINE__,line);
@@ -727,17 +723,30 @@ static int open(struct tty_struct *tty, struct file *filp)
 	}
 
 	info = synclinkmp_device_list;
-	while(info && info->line != line)
+	while (info && info->line != line)
 		info = info->next_device;
 	if (sanity_check(info, tty->name, "open"))
 		return -ENODEV;
-	if ( info->init_error ) {
+	if (info->init_error) {
 		printk("%s(%d):%s device is not allocated, init error=%d\n",
-			__FILE__,__LINE__,info->device_name,info->init_error);
+			__FILE__, __LINE__, info->device_name,
+			info->init_error);
 		return -ENODEV;
 	}
 
 	tty->driver_data = info;
+
+	return tty_port_install(&info->port, driver, tty);
+}
+
+/* Called when a port is opened.  Init and enable port.
+ */
+static int open(struct tty_struct *tty, struct file *filp)
+{
+	SLMP_INFO *info = tty->driver_data;
+	unsigned long flags;
+	int retval;
+
 	info->port.tty = tty;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
@@ -3881,6 +3890,7 @@ static void device_init(int adapter_num, struct pci_dev *pdev)
 }
 
 static const struct tty_operations ops = {
+	.install = install,
 	.open = open,
 	.close = close,
 	.write = write,
-- 
1.7.10.4


