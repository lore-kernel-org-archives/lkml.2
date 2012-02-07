Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2BGXjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 18:39:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab2BGXjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 18:39:51 -0500
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org
Subject: [PATCH 1/2] char/mem: Add /dev/io (v2)
Date: Tue,  7 Feb 2012 18:39:45 -0500
Message-Id: <1328657985-13942-1-git-send-email-ajax@redhat.com>
In-Reply-To: <1328623901-20628-1-git-send-email-ajax@redhat.com>
References: <1328623901-20628-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is like /dev/port except not broken.  /dev/port will translate all
read/write into inb/outb streams, which is wrong since hardware can and
does care about cycle size.  /dev/io will only allow 1, 2, or 4 byte
access, and will translate that into the appropriate bus cycle size.

v2: Fix get/put_user types.

Signed-off-by: Adam Jackson <ajax@redhat.com>

fixup
---
 drivers/char/mem.c |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index d6e9d08..9fc3847 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -611,6 +611,92 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 	*ppos = i;
 	return tmp-buf;
 }
+
+static ssize_t read_io(struct file *file, char __user *buf, size_t count,
+		       loff_t *ppos)
+{
+	unsigned long port = *ppos;
+	const u8 __user *btmp = (void __user *)buf;
+	const u16 __user *wtmp = (void __user *)buf;
+	const u32 __user *ltmp = (void __user *)buf;
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
+			if (__put_user(inb(port), btmp) < 0)
+				return -EFAULT;
+			break;
+		case 2:
+			if (__put_user(inw(port), wtmp) < 0)
+				return -EFAULT;
+			break;
+		case 4:
+			if (__put_user(inl(port), ltmp) < 0)
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
+	const u8 __user *btmp = (void __user *)buf;
+	const u16 __user *wtmp = (void __user *)buf;
+	const u32 __user *ltmp = (void __user *)buf;
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
+			if (__get_user(byte, btmp))
+				return -EFAULT;
+			outb(byte, port);
+			break;
+		case 2:
+			if (__get_user(word, wtmp))
+				return -EFAULT;
+			outw(word, port);
+			break;
+		case 4:
+			if (__get_user(dword, ltmp))
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
@@ -774,6 +860,13 @@ static const struct file_operations port_fops = {
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
@@ -867,6 +960,9 @@ static const struct memdev {
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

