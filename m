Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab2HGTyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:54:35 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49824 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab2HGTyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:54:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 30/41] TTY: moxa, convert to dynamic device
Date: Tue,  7 Aug 2012 21:47:55 +0200
Message-Id: <1344368886-24033-31-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to provide the tty layer with information about
tty_port for each link.

We also provide a tty_port for the service port. For this one we allow
only ioctl, so this is pretty ugly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/moxa.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 89cc934..9dffc72 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -169,6 +169,7 @@ static DEFINE_SPINLOCK(moxa_lock);
 static unsigned long baseaddr[MAX_BOARDS];
 static unsigned int type[MAX_BOARDS];
 static unsigned int numports[MAX_BOARDS];
+static struct tty_port moxa_service_port;
 
 MODULE_AUTHOR("William Chen");
 MODULE_DESCRIPTION("MOXA Intellio Family Multiport Board Device Driver");
@@ -834,7 +835,7 @@ static int moxa_init_board(struct moxa_board_conf *brd, struct device *dev)
 	const struct firmware *fw;
 	const char *file;
 	struct moxa_port *p;
-	unsigned int i;
+	unsigned int i, first_idx;
 	int ret;
 
 	brd->ports = kcalloc(MAX_PORTS_PER_BOARD, sizeof(*brd->ports),
@@ -887,6 +888,11 @@ static int moxa_init_board(struct moxa_board_conf *brd, struct device *dev)
 		mod_timer(&moxaTimer, jiffies + HZ / 50);
 	spin_unlock_bh(&moxa_lock);
 
+	first_idx = (brd - moxa_boards) * MAX_PORTS_PER_BOARD;
+	for (i = 0; i < brd->numPorts; i++)
+		tty_port_register_device(&brd->ports[i].port, moxaDriver,
+				first_idx + i, dev);
+
 	return 0;
 err_free:
 	kfree(brd->ports);
@@ -896,7 +902,7 @@ err:
 
 static void moxa_board_deinit(struct moxa_board_conf *brd)
 {
-	unsigned int a, opened;
+	unsigned int a, opened, first_idx;
 
 	mutex_lock(&moxa_openlock);
 	spin_lock_bh(&moxa_lock);
@@ -925,6 +931,10 @@ static void moxa_board_deinit(struct moxa_board_conf *brd)
 		mutex_lock(&moxa_openlock);
 	}
 
+	first_idx = (brd - moxa_boards) * MAX_PORTS_PER_BOARD;
+	for (a = 0; a < brd->numPorts; a++)
+		tty_unregister_device(moxaDriver, first_idx + a);
+
 	iounmap(brd->basemem);
 	brd->basemem = NULL;
 	kfree(brd->ports);
@@ -1031,7 +1041,12 @@ static int __init moxa_init(void)
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
 			MOXA_VERSION);
-	moxaDriver = alloc_tty_driver(MAX_PORTS + 1);
+
+	tty_port_init(&moxa_service_port);
+
+	moxaDriver = tty_alloc_driver(MAX_PORTS + 1,
+			TTY_DRIVER_REAL_RAW |
+			TTY_DRIVER_DYNAMIC_DEV);
 	if (!moxaDriver)
 		return -ENOMEM;
 
@@ -1044,8 +1059,9 @@ static int __init moxa_init(void)
 	moxaDriver->init_termios.c_cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 	moxaDriver->init_termios.c_ispeed = 9600;
 	moxaDriver->init_termios.c_ospeed = 9600;
-	moxaDriver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(moxaDriver, &moxa_ops);
+	/* Having one more port only for ioctls is ugly */
+	tty_port_link_device(&moxa_service_port, moxaDriver, MAX_PORTS);
 
 	if (tty_register_driver(moxaDriver)) {
 		printk(KERN_ERR "can't register MOXA Smartio tty driver!\n");
-- 
1.7.10.4


