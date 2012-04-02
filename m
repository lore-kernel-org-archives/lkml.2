Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2DBLzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:48 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48048 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 14/69] TTY: isdn, use xmit_buf from tty_port
Date: Mon,  2 Apr 2012 13:53:58 +0200
Message-Id: <1333367693-3244-15-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |   16 +++++++++-------
 include/linux/isdn.h        |    1 -
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 8698856..dfb83e6 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -333,7 +333,7 @@ isdn_tty_countDLE(unsigned char *buf, int len)
 static int
 isdn_tty_handleDLEdown(modem_info *info, atemu *m, int len)
 {
-	unsigned char *p = &info->xmit_buf[info->xmit_count];
+	unsigned char *p = &info->port.xmit_buf[info->xmit_count];
 	int count = 0;
 
 	while (len > 0) {
@@ -477,7 +477,7 @@ isdn_tty_senddown(modem_info *info)
 		return;
 	}
 	skb_reserve(skb, skb_res);
-	memcpy(skb_put(skb, buflen), info->xmit_buf, buflen);
+	memcpy(skb_put(skb, buflen), info->port.xmit_buf, buflen);
 	info->xmit_count = 0;
 #ifdef CONFIG_ISDN_AUDIO
 	if (info->vonline & 2) {
@@ -1152,7 +1152,7 @@ isdn_tty_write(struct tty_struct *tty, const u_char *buf, int count)
 				isdn_tty_check_esc(buf, m->mdmreg[REG_ESC], c,
 						   &(m->pluscount),
 						   &(m->lastplus));
-			memcpy(&(info->xmit_buf[info->xmit_count]), buf, c);
+			memcpy(&info->port.xmit_buf[info->xmit_count], buf, c);
 #ifdef CONFIG_ISDN_AUDIO
 			if (info->vonline) {
 				int cc = isdn_tty_handleDLEdown(info, m, c);
@@ -1906,13 +1906,15 @@ isdn_tty_modem_init(void)
 #ifdef CONFIG_ISDN_AUDIO
 		skb_queue_head_init(&info->dtmf_queue);
 #endif
-		if (!(info->xmit_buf = kmalloc(ISDN_SERIAL_XMIT_MAX + 5, GFP_KERNEL))) {
+		info->port.xmit_buf = kmalloc(ISDN_SERIAL_XMIT_MAX + 5,
+				GFP_KERNEL);
+		if (!info->port.xmit_buf) {
 			printk(KERN_ERR "Could not allocate modem xmit-buffer\n");
 			retval = -ENOMEM;
 			goto err_unregister;
 		}
 		/* Make room for T.70 header */
-		info->xmit_buf += 4;
+		info->port.xmit_buf += 4;
 	}
 	return 0;
 err_unregister:
@@ -1921,7 +1923,7 @@ err_unregister:
 #ifdef CONFIG_ISDN_TTY_FAX
 		kfree(info->fax);
 #endif
-		kfree(info->xmit_buf - 4);
+		kfree(info->port.xmit_buf - 4);
 	}
 	tty_unregister_driver(m->tty_modem);
 err:
@@ -1942,7 +1944,7 @@ isdn_tty_exit(void)
 #ifdef CONFIG_ISDN_TTY_FAX
 		kfree(info->fax);
 #endif
-		kfree(info->xmit_buf - 4);
+		kfree(info->port.xmit_buf - 4);
 	}
 	tty_unregister_driver(dev->mdm.tty_modem);
 	put_tty_driver(dev->mdm.tty_modem);
diff --git a/include/linux/isdn.h b/include/linux/isdn.h
index 95883ac..215c416 100644
--- a/include/linux/isdn.h
+++ b/include/linux/isdn.h
@@ -461,7 +461,6 @@ typedef struct modem_info {
   int                   send_outstanding;/* # of outstanding send-requests */
   int                   xmit_size;       /* max. # of chars in xmit_buf    */
   int                   xmit_count;      /* # of chars in xmit_buf         */
-  unsigned char         *xmit_buf;       /* transmit buffer                */
   struct sk_buff_head   xmit_queue;      /* transmit queue                 */
   atomic_t              xmit_lock;       /* Semaphore for isdn_tty_write   */
 #ifdef CONFIG_ISDN_AUDIO
-- 
1.7.9.2


