Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2DBL4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:50 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48204 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2DBLzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 36/69] TTY: bfin_jtag_comm, use tty from tty_port
Date: Mon,  2 Apr 2012 13:54:20 +0200
Message-Id: <1333367693-3244-37-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from mutex to tty_port->lock and to tty refcounting. This needs
a 'continue' to be added to re-grab a tty after schedule returns.

And since tty is not protected by bfin_jc_tty_mutex remove it as well.
But this needs tty_port->count to be protected by tty_port->lock now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
---
 drivers/tty/bfin_jtag_comm.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/bfin_jtag_comm.c b/drivers/tty/bfin_jtag_comm.c
index d81013c..61fc74f 100644
--- a/drivers/tty/bfin_jtag_comm.c
+++ b/drivers/tty/bfin_jtag_comm.c
@@ -62,8 +62,6 @@ static inline uint32_t bfin_write_emudat_chars(char a, char b, char c, char d)
 
 static struct tty_driver *bfin_jc_driver;
 static struct task_struct *bfin_jc_kthread;
-static struct tty_struct * volatile bfin_jc_tty;
-static DEFINE_MUTEX(bfin_jc_tty_mutex);
 static struct tty_port port;
 static volatile struct circ_buf bfin_jc_write_buf;
 
@@ -73,18 +71,21 @@ bfin_jc_emudat_manager(void *arg)
 	uint32_t inbound_len = 0, outbound_len = 0;
 
 	while (!kthread_should_stop()) {
+		struct tty_struct *tty = tty_port_tty_get(&port);
 		/* no one left to give data to, so sleep */
-		if (bfin_jc_tty == NULL && circ_empty(&bfin_jc_write_buf)) {
+		if (tty == NULL && circ_empty(&bfin_jc_write_buf)) {
 			pr_debug("waiting for readers\n");
 			__set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule();
 			__set_current_state(TASK_RUNNING);
+			continue;
 		}
 
 		/* no data available, so just chill */
 		if (!(bfin_read_DBGSTAT() & EMUDIF) && circ_empty(&bfin_jc_write_buf)) {
 			pr_debug("waiting for data (in_len = %i) (circ: %i %i)\n",
 				inbound_len, bfin_jc_write_buf.tail, bfin_jc_write_buf.head);
+			tty_kref_put(tty);
 			if (inbound_len)
 				schedule();
 			else
@@ -94,9 +95,6 @@ bfin_jc_emudat_manager(void *arg)
 
 		/* if incoming data is ready, eat it */
 		if (bfin_read_DBGSTAT() & EMUDIF) {
-			struct tty_struct *tty;
-			mutex_lock(&bfin_jc_tty_mutex);
-			tty = (struct tty_struct *)bfin_jc_tty;
 			if (tty != NULL) {
 				uint32_t emudat = bfin_read_emudat();
 				if (inbound_len == 0) {
@@ -110,7 +108,6 @@ bfin_jc_emudat_manager(void *arg)
 					tty_flip_buffer_push(tty);
 				}
 			}
-			mutex_unlock(&bfin_jc_tty_mutex);
 		}
 
 		/* if outgoing data is ready, post it */
@@ -120,7 +117,6 @@ bfin_jc_emudat_manager(void *arg)
 				bfin_write_emudat(outbound_len);
 				pr_debug("outgoing length: 0x%08x\n", outbound_len);
 			} else {
-				struct tty_struct *tty;
 				int tail = bfin_jc_write_buf.tail;
 				size_t ate = (4 <= outbound_len ? 4 : outbound_len);
 				uint32_t emudat =
@@ -132,14 +128,12 @@ bfin_jc_emudat_manager(void *arg)
 				);
 				bfin_jc_write_buf.tail += ate;
 				outbound_len -= ate;
-				mutex_lock(&bfin_jc_tty_mutex);
-				tty = (struct tty_struct *)bfin_jc_tty;
 				if (tty)
 					tty_wakeup(tty);
-				mutex_unlock(&bfin_jc_tty_mutex);
 				pr_debug("  outgoing data: 0x%08x (pushing %zu)\n", emudat, ate);
 			}
 		}
+		tty_kref_put(tty);
 	}
 
 	__set_current_state(TASK_RUNNING);
@@ -149,22 +143,28 @@ bfin_jc_emudat_manager(void *arg)
 static int
 bfin_jc_open(struct tty_struct *tty, struct file *filp)
 {
-	mutex_lock(&bfin_jc_tty_mutex);
+	unsigned long flags;
+
+	spin_lock_irqsave(&port.lock, flags);
 	port.count++;
-	bfin_jc_tty = tty;
+	spin_unlock_irqrestore(&port.lock, flags);
+	tty_port_tty_set(&port, tty);
 	wake_up_process(bfin_jc_kthread);
-	mutex_unlock(&bfin_jc_tty_mutex);
 	return 0;
 }
 
 static void
 bfin_jc_close(struct tty_struct *tty, struct file *filp)
 {
-	mutex_lock(&bfin_jc_tty_mutex);
-	if (--port.count == 0)
-		bfin_jc_tty = NULL;
+	unsigned long flags;
+	bool last;
+
+	spin_lock_irqsave(&port.lock, flags);
+	last = --port.count == 0;
+	spin_unlock_irqrestore(&port.lock, flags);
+	if (last)
+		tty_port_tty_set(&port, NULL);
 	wake_up_process(bfin_jc_kthread);
-	mutex_unlock(&bfin_jc_tty_mutex);
 }
 
 /* XXX: we dont handle the put_char() case where we must handle count = 1 */
-- 
1.7.9.2


