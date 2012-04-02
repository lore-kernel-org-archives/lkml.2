Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2DBL40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:26 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48115 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2DBLzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:13 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 35/69] TTY: bfin_jtag_comm, add tty_port
Date: Mon,  2 Apr 2012 13:54:19 +0200
Message-Id: <1333367693-3244-36-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use open count from there. Switch to tty from there will follow.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
---
 drivers/tty/bfin_jtag_comm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/bfin_jtag_comm.c b/drivers/tty/bfin_jtag_comm.c
index 946f799..d81013c 100644
--- a/drivers/tty/bfin_jtag_comm.c
+++ b/drivers/tty/bfin_jtag_comm.c
@@ -63,8 +63,8 @@ static inline uint32_t bfin_write_emudat_chars(char a, char b, char c, char d)
 static struct tty_driver *bfin_jc_driver;
 static struct task_struct *bfin_jc_kthread;
 static struct tty_struct * volatile bfin_jc_tty;
-static unsigned long bfin_jc_count;
 static DEFINE_MUTEX(bfin_jc_tty_mutex);
+static struct tty_port port;
 static volatile struct circ_buf bfin_jc_write_buf;
 
 static int
@@ -150,8 +150,7 @@ static int
 bfin_jc_open(struct tty_struct *tty, struct file *filp)
 {
 	mutex_lock(&bfin_jc_tty_mutex);
-	pr_debug("open %lu\n", bfin_jc_count);
-	++bfin_jc_count;
+	port.count++;
 	bfin_jc_tty = tty;
 	wake_up_process(bfin_jc_kthread);
 	mutex_unlock(&bfin_jc_tty_mutex);
@@ -162,8 +161,7 @@ static void
 bfin_jc_close(struct tty_struct *tty, struct file *filp)
 {
 	mutex_lock(&bfin_jc_tty_mutex);
-	pr_debug("close %lu\n", bfin_jc_count);
-	if (--bfin_jc_count == 0)
+	if (--port.count == 0)
 		bfin_jc_tty = NULL;
 	wake_up_process(bfin_jc_kthread);
 	mutex_unlock(&bfin_jc_tty_mutex);
@@ -242,6 +240,8 @@ static int __init bfin_jc_init(void)
 {
 	int ret;
 
+	tty_port_init(&port);
+
 	bfin_jc_kthread = kthread_create(bfin_jc_emudat_manager, NULL, DRV_NAME);
 	if (IS_ERR(bfin_jc_kthread))
 		return PTR_ERR(bfin_jc_kthread);
-- 
1.7.9.2


