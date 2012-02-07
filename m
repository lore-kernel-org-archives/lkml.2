Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2BGOwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:52:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab2BGOwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:52:20 -0500
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org
Subject: [PATCH 1/2] char/mem: Add /dev/io
Date: Tue,  7 Feb 2012 09:11:40 -0500
Message-Id: <1328623901-20628-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is like /dev/port except not broken.  /dev/port will translate all
read/write into inb/outb streams, which is wrong since hardware can and
does care about cycle size.  /dev/io will only allow 1, 2, or 4 byte
access, and will translate that into the appropriate bus cycle size.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/char/mem.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index d6e9d08..276b0e5 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -611,6 +611,88 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 	*ppos = i;
 	return tmp-buf;
 }
+
+static ssize_t read_io(struct file *file, char __user *buf, size_t count,
+		       loff_t *ppos)
+{
+	unsigned long port = *ppos;
+	const char __user * tmp = buf;
+
+	switch (count) {
+		case 1:
+		case 2:
+		case 4:
+		        break;
+		default:
+			return -EINVAL;
+	}
+
+	if (!access_ok(VERIFY_WRITE, buf, count))
+		return -EFAULT;
+
+	switch (count) {
+		case 1:
+			if (__put_user(inb(port), tmp) < 0)
+				return -EFAULT;
+			break;
+		case 2:
+			if (__put_user(inw(port), tmp) < 0)
+				return -EFAULT;
+			break;
+		case 4:
+			if (__put_user(inl(port), tmp) < 0)
+				return -EFAULT;
+			break;
+	}
+
+	*ppos += count;
+	return count;
+}
+
+static ssize_t write_io(struct file *file, const char __user *buf, size_t count,
+		       	loff_t *ppos)
+{
+	unsigned long port = *ppos;
+	const char __user * tmp = buf;
+	u8 byte;
+	u16 word;
+	u32 dword;
+
+	switch (count) {
+		case 1:
+		case 2:
+		case 4:
+			break;
+		default:
+			return -EINVAL;
+	}
+
+	if (!access_ok(VERIFY_READ, buf, count))
+		return -EFAULT;
+
+	switch (count) {
+		case 1:
+			if (__get_user(byte, tmp))
+				return -EFAULT;
+			outb(byte, port);
+			break;
+		case 2:
+			if (__get_user(word, tmp))
+				return -EFAULT;
+			outw(word, port);
+			break;
+		case 4:
+			if (__get_user(dword, tmp))
+				return -EFAULT;
+			outl(dword, port);
+			break;
+		default:
+			return -EINVAL;
+	}
+
+	*ppos += count;
+	return count;
+}
 #endif
 
 static ssize_t read_null(struct file *file, char __user *buf,
@@ -774,6 +856,13 @@ static const struct file_operations port_fops = {
 	.write		= write_port,
 	.open		= open_port,
 };
+
+static const struct file_operations io_fops = {
+	.llseek		= memory_lseek,
+	.read		= read_io,
+	.write		= write_io,
+	.open		= open_port,
+};
 #endif
 
 static const struct file_operations zero_fops = {
@@ -867,6 +956,9 @@ static const struct memdev {
 #ifdef CONFIG_CRASH_DUMP
 	[12] = { "oldmem", 0, &oldmem_fops, NULL },
 #endif
+#ifdef CONFIG_DEVPORT
+	[13] = { "io", 0, &io_fops, NULL },
+#endif
 };
 
 static int memory_open(struct inode *inode, struct file *filp)
-- 
1.7.7.6

