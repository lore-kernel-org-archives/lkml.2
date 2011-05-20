Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1ETATc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:19:32 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57817 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934529Ab1ETAL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:26 -0400
X-Sasl-enc: eV4mO0GhYX1suz9wE3G8WDOu6CRaIcQrb3JHw7/jNVzR 1305850285
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/44] printk: /dev/kmsg - properly support writev() to avoid interleaved printk() lines
Date: Thu, 19 May 2011 17:10:30 -0700
Message-Id: <1305850262-9575-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

printk: /dev/kmsg - properly support writev() to avoid interleaved printk lines

We should avoid calling printk() in a loop, when we pass a single
string to /dev/kmsg with writev().

Cc: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/mem.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 436a990..78923a9 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -806,29 +806,40 @@ static const struct file_operations oldmem_fops = {
 };
 #endif
 
-static ssize_t kmsg_write(struct file *file, const char __user *buf,
-			  size_t count, loff_t *ppos)
+static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
+			   unsigned long count, loff_t pos)
 {
-	char *tmp;
-	ssize_t ret;
+	char *line, *p;
+	int len, i;
+	ssize_t ret = -EFAULT;
 
-	tmp = kmalloc(count + 1, GFP_KERNEL);
-	if (tmp == NULL)
+	len = iov_length(iv, count);
+	line = p = kmalloc(len + 1, GFP_KERNEL);
+	if (line == NULL)
 		return -ENOMEM;
-	ret = -EFAULT;
-	if (!copy_from_user(tmp, buf, count)) {
-		tmp[count] = 0;
-		ret = printk("%s", tmp);
-		if (ret > count)
-			/* printk can add a prefix */
-			ret = count;
+
+	/*
+	 * copy all vectors into a single string, to ensure we do
+	 * not interleave our log line with other printk calls
+	 */
+	for (i = 0; i < count; i++) {
+		if (copy_from_user(p, iv[i].iov_base, iv[i].iov_len))
+			goto out;
+		p += iv[i].iov_len;
 	}
-	kfree(tmp);
+	p[0] = '\0';
+
+	ret = printk("%s", line);
+	/* printk can add a prefix */
+	if (ret > len)
+		ret = len;
+out:
+	kfree(line);
 	return ret;
 }
 
 static const struct file_operations kmsg_fops = {
-	.write = kmsg_write,
+	.aio_write = kmsg_writev,
 	.llseek = noop_llseek,
 };
 
-- 
1.7.4.2

