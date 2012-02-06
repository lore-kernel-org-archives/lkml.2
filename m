Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2BFXCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:02:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266Ab2BFXCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:02:10 -0500
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, greg@kroah.com
Subject: [PATCH] char/mem: Make /dev/port less obviously broken (v0)
Date: Mon,  6 Feb 2012 18:02:02 -0500
Message-Id: <1328569322-19165-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did you know /dev/port turns all reads and writes into a stream of inb
and outb?  Turns out hardware really does care about I/O cycle size
though, and if you're trying to do an outl four outb's is very much not
the same thing.

However, someone somewhere probably built some code and hardware that
relies on that behaviour.  Plus, userspace needs to be able to tell
whether the kernel will do the right thing, and fall back to raw port
access if not.  So add an ioctl to request new 'strict' semantics, which
allows only exactly 1/2/4 byte cycles and translates them into the
corresponding I/O cycle size.  This matches the behaviour of sysfs's
resourceN files for I/O BARs.

Known issues:

- Where should this ioctl go?  There's not a good header for it already
  installed, at least not on amd64.
- Is it worth allowing and ignoring 0-byte cycles?  Probably not.
- Does the kernel also need to reject misaligned I/O?  Probably not?
  The IA32 manual doesn't specify an exception for this case, and
  actually trying it on a C2D just returns -1, so it's probably safe
  to just pass that through.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/char/mem.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 125 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index d6e9d08..12892a1 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -571,6 +571,8 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 #endif
 
 #ifdef CONFIG_DEVPORT
+static const struct file_operations port_strict_fops, port_fops; 
+
 static ssize_t read_port(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
@@ -589,6 +591,46 @@ static ssize_t read_port(struct file *file, char __user *buf,
 	return tmp-buf;
 }
 
+static ssize_t read_port_strict(struct file *file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	unsigned long port = *ppos;
+	const char __user * tmp = buf;
+
+	switch (count) {
+		case 0:
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
+		case 0:
+			break;
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
 static ssize_t write_port(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
@@ -611,6 +653,80 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 	*ppos = i;
 	return tmp-buf;
 }
+
+static ssize_t write_port_strict(struct file *file, const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	unsigned long port = *ppos;
+	const char __user * tmp = buf;
+	u8 byte;
+	u16 word;
+	u32 dword;
+
+	switch (count) {
+		case 0:
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
+		case 0:
+			break;
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
+
+#ifndef DEVPORT_STRICT
+#define DEVPORT_STRICT _IOW(0xd0, 'p' + 0, u32)
+#endif
+
+static long ioctl_port(struct file *filp, unsigned int op, unsigned long arg)
+{
+	switch (op) {
+		case DEVPORT_STRICT: {
+			u32 val;
+
+			if (copy_from_user(&val, (void __user *)arg,
+					   _IOC_SIZE(op)))
+				return -EINVAL;
+
+			filp->f_op = val ? &port_strict_fops : &port_fops;
+			
+			break;
+		}
+
+		default:
+			return -EINVAL;
+	}
+
+	return 0;
+}
 #endif
 
 static ssize_t read_null(struct file *file, char __user *buf,
@@ -773,6 +889,15 @@ static const struct file_operations port_fops = {
 	.read		= read_port,
 	.write		= write_port,
 	.open		= open_port,
+	.unlocked_ioctl = ioctl_port,
+};
+
+static const struct file_operations port_strict_fops = {
+	.llseek		= memory_lseek,
+	.read		= read_port_strict,
+	.write		= write_port_strict,
+	.open		= open_port,
+	.unlocked_ioctl = ioctl_port,
 };
 #endif
 
-- 
1.7.8.4

