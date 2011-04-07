Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab1DGCaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:30:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50886 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab1DGCaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=R3NSs5bAsTETCNnd1PHKFycfSv+r4dmRMjei+rWyV1V/1rG0drRyMWFmjuF9aoZfG9
         3UL9L3zmHM+nEhJtTS+W+4BUL3BckD/UShxBeC4vDLIUk1yky55cpCWWRhkgcWlziSWE
         gGFk7HTrfvciUvSwlbbco57HTm5EwLtSxdEac=
Subject: printk: /dev/kmsg - properly support writev() to avoid interleaved
 printk() lines
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 07 Apr 2011 04:29:20 +0200
Message-ID: <1302143360.1143.3.camel@zag>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

printk: /dev/kmsg - properly support writev() to avoid interleaved printk lines

We should avoid calling printk() in a loop, when we pass a single
string to /dev/kmsg with writev(). 

Cc: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 mem.c |   41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

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
 

