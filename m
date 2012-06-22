Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab2FVPkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:40:13 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51624 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762413Ab2FVPf1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 22 Jun 2012 11:35:27 -0400
Message-Id: <4FE4AD09020000780008B77F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 22 Jun 2012 16:36:09 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <gregkh@linuxfoundation.org>
Cc: <yuanhan.liu@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <kay@vrfy.org>
Subject: [PATCH] syslog: fill buffer with more than a single message
 for SYSLOG_ACTION_READ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent changes to the printk buffer management resulted in
SYSLOG_ACTION_READ to only return a single message, whereas previously
the buffer would get filled as much as possible. As, when too small to
fit everything, filling it to the last byte would be pretty ugly with
the new code, the patch arranges for as many messages as possible to
get returned in a single invocation. User space tools in at least all
SLES versions depend on the old behavior.

This at once addresses the issue attempted to get fixed with commit
b56a39ac263e5b8cafedd551a49c2105e68b98c2 ("printk: return -EINVAL if
the message len is bigger than the buf size"), and since that commit
widened the possibility for losing a message altogether, the patch
here assumes that this other commit would get reverted first
(otherwise the patch here won't apply).

Furthermore, this patch also addresses the problem dealt with in
commit 4a77a5a06ec66ed05199b301e7c25f42f979afdc ("printk: use mutex
lock to stop syslog_seq from going wild"), so I'd recommend reverting
that one too (albeit there's no direct collision between the two).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>

---
 kernel/printk.c |   51 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 14 deletions(-)

--- 3.5-rc3/kernel/printk.c
+++ 3.5-rc3-syslog-read/kernel/printk.c
@@ -860,26 +860,49 @@ static int syslog_print(char __user *buf
 {
 	char *text;
 	struct log *msg;
-	int len;
+	int len = 0;
 
 	text = kmalloc(LOG_LINE_MAX, GFP_KERNEL);
 	if (!text)
 		return -ENOMEM;
 
-	raw_spin_lock_irq(&logbuf_lock);
-	if (syslog_seq < log_first_seq) {
-		/* messages are gone, move to first one */
-		syslog_seq = log_first_seq;
-		syslog_idx = log_first_idx;
-	}
-	msg = log_from_idx(syslog_idx);
-	len = msg_print_text(msg, true, text, LOG_LINE_MAX);
-	syslog_idx = log_next(syslog_idx);
-	syslog_seq++;
-	raw_spin_unlock_irq(&logbuf_lock);
+	while (size > 0) {
+		size_t n;
+
+		raw_spin_lock_irq(&logbuf_lock);
+		if (syslog_seq < log_first_seq) {
+			/* messages are gone, move to first one */
+			syslog_seq = log_first_seq;
+			syslog_idx = log_first_idx;
+		}
+		if (syslog_seq == log_next_seq) {
+			raw_spin_unlock_irq(&logbuf_lock);
+			break;
+		}
+		msg = log_from_idx(syslog_idx);
+		n = msg_print_text(msg, true, text, LOG_LINE_MAX);
+		if (n <= size) {
+			syslog_idx = log_next(syslog_idx);
+			syslog_seq++;
+		} else
+			n = 0;
+		raw_spin_unlock_irq(&logbuf_lock);
+
+		if (!n)
+			break;
 
-	if (len > 0 && copy_to_user(buf, text, len))
-		len = -EFAULT;
+		len += n;
+		size -= n;
+		buf += n;
+		n = copy_to_user(buf - n, text, n);
+
+		if (n) {
+			len -= n;
+			if (!len)
+				len = -EFAULT;
+			break;
+		}
+	}
 
 	kfree(text);
 	return len;



