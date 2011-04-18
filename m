Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1DRLic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:38:32 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60383 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab1DRLiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:38:20 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/1] Implement /dev/byte (a generic byte source similiar to /dev/zero)
Date: Mon, 18 Apr 2011 13:37:56 +0200
Message-Id: <1303126676-3456-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1303126676-3456-1-git-send-email-holler@ahsoftware.de>
References: <1303126676-3456-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This device outputs by default 0xff instead 0 which makes more sense
than 0 to clear e.g. FLASH based devices.

To make the device more general usable, the value it outputs is changeable
on a per file descriptor basis through simple writes to it.
Values can be decimal (0 - 255), octal (00 - 0377) or hex (0x0 - 0xff).
For other values (or strings) written to it, the write operation returns an
error and the subsequent output is undefined.

Usage examples:

 # Fill /dev/sdX with 0xff.
dd </dev/byte of=/dev/sdX bs=4M

 # Create a file of size 10GB and filled with 0xaa.
exec 5<>/dev/byte # Open /dev/byte and assign fd 5 to it
echo 0xaa >&5     # Instruct the device to output 0xaa
dd <&5 of=foo.img bs=10M count=1024 # create and fill the file
exec 5>&-         # Close fd 5

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 Documentation/byte.txt    |   24 +++++++++++
 Documentation/devices.txt |    1 +
 drivers/char/Kconfig      |   10 ++++
 drivers/char/mem.c        |  101 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 136 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/byte.txt

diff --git a/Documentation/byte.txt b/Documentation/byte.txt
new file mode 100644
index 0000000..c132e7d
--- /dev/null
+++ b/Documentation/byte.txt
@@ -0,0 +1,24 @@
+/dev/byte is a generic byte source (similiar to /dev/zero) which uses
+0xff as the default value.
+
+The idea was to have a source for 0xff to erase FLASH based devices like
+SSDs and SD-Cards for which 0xff makes more sense than 0.
+
+To make the device more general usable, the value it outputs is changeable
+on a per file descriptor basis through simple writes to it.
+Values can be decimal (0 - 255), octal (00 - 0377) or hex (0x0 - 0xff).
+For other values (or strings) written to it, the write operation returns an
+error and the subsequent output is undefined.
+
+Usage examples:
+
+# Fill /dev/sdX with 0xff.
+dd </dev/byte of=/dev/sdX bs=4M
+
+# Create a file of size 10GB and filled with 0xaa.
+exec 5<>/dev/byte # Open /dev/byte and assign fd 5 to it
+echo 0xaa >&5     # Instruct the device to output 0xaa
+dd <&5 of=foo.img bs=10M count=1024 # create and fill the file
+exec 5>&-         # Close fd 5
+
+Apr 2011, Alexander Holler <holler@ahsoftware.de>
diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index eccffe7..b34439e 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -101,6 +101,7 @@ Your cooperation is appreciated.
 		 11 = /dev/kmsg		Writes to this come out as printk's
 		 12 = /dev/oldmem	Used by crashdump kernels to access
 					the memory of the kernel that crashed.
+		 13 = /dev/byte		Generic byte source (default 0xff).
 
   1 block	RAM disk
 		  0 = /dev/ram0		First RAM disk
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index b7980a83..c745bcf 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -97,6 +97,16 @@ config DEVKMEM
 	  kind of kernel debugging operations.
 	  When in doubt, say "N".
 
+config DEV_BYTE
+	bool "/dev/byte virtual device support"
+	default y
+	help
+	  Say Y here if you want to support the /dev/byte device. The
+	  /dev/byte device is a generic byte source (similiar to /dev/zero),
+	  but uses 0xff as a default value which is changeable on a per
+	  file descriptor basis.
+	  Read <file:Documentation/byte.txt> for a usage description.
+
 config BFIN_JTAG_COMM
 	tristate "Blackfin JTAG Communication"
 	depends on BLACKFIN
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1256454..7a1d558 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -6,6 +6,7 @@
  *  Added devfs support.
  *    Jan-11-1998, C. Scott Ananian <cananian@alumni.princeton.edu>
  *  Shared /dev/zero mmapping support, Feb 2000, Kanoj Sarcar <kanoj@sgi.com>
+ *  Added /dev/byte support, Apr 2011, Alexander Holler <holler@ahsoftware.de>
  */
 
 #include <linux/mm.h>
@@ -26,6 +27,7 @@
 #include <linux/bootmem.h>
 #include <linux/splice.h>
 #include <linux/pfn.h>
+#include <linux/radix-tree.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -736,6 +738,7 @@ static int open_port(struct inode * inode, struct file * filp)
 
 #define zero_lseek	null_lseek
 #define full_lseek      null_lseek
+#define byte_lseek	null_lseek
 #define write_zero	write_null
 #define read_full       read_zero
 #define open_mem	open_port
@@ -835,6 +838,101 @@ static const struct file_operations kmsg_fops = {
 	.llseek = noop_llseek,
 };
 
+#ifdef CONFIG_DEV_BYTE
+static u16 byte_items[1] = {}; /* must be aligned even */
+static RADIX_TREE(byte_tree, GFP_KERNEL);
+static spinlock_t byte_lock;
+
+/*
+ * Read a value the device should output afterwards.
+ * Values can be decimal (0 - 255), octal (00 - 0377) or hex (0x0 - 0xff).
+ */
+static ssize_t write_byte(struct file *filp, const char __user *buffer,
+		   size_t count, loff_t *off)
+{
+	u16 *val;
+	unsigned long num;
+	char buff[5];
+
+	num = (count < sizeof(buff)-1) ? count : sizeof(buff)-1;
+	if (copy_from_user(buff, buffer, num))
+		return -EFAULT;
+	buff[num] = '\0';
+	if (strict_strtoul(buff, 0, &num) || num > 255)
+		return -EFAULT;
+	rcu_read_lock();
+	val = radix_tree_lookup(&byte_tree, (unsigned long)filp);
+	rcu_read_unlock();
+	spin_lock(&byte_lock);
+	if (val != NULL)
+		radix_tree_delete(&byte_tree, (unsigned long)filp);
+	num = radix_tree_insert(&byte_tree, (unsigned long)filp,
+		byte_items+num);
+	spin_unlock(&byte_lock);
+	if (num)
+		return -EFAULT;
+	return count;
+}
+
+static ssize_t read_byte(struct file *file, char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	size_t written;
+	u16 *val;
+	unsigned char byte = 0xff;
+
+	if (!count)
+		return 0;
+
+	if (!access_ok(VERIFY_WRITE, buf, count))
+		return -EFAULT;
+
+	rcu_read_lock();
+	val = radix_tree_lookup(&byte_tree, (unsigned long)file);
+	rcu_read_unlock();
+	if (val != NULL)
+		byte = (unsigned char)(val-byte_items);
+
+	written = 0;
+	while (count) {
+		size_t chunk = count;
+
+		if (chunk > PAGE_SIZE)
+			chunk = PAGE_SIZE;	/* Just for latency reasons */
+		memset(buf, byte, chunk);
+		written += chunk;
+		if (signal_pending(current))
+			return written;
+		buf += chunk;
+		count -= chunk;
+		cond_resched();
+	}
+	return written;
+}
+
+static int release_byte(struct inode *inode, struct file *filp)
+{
+	u16 *val;
+
+	rcu_read_lock();
+	val = radix_tree_lookup(&byte_tree, (unsigned long)filp);
+	rcu_read_unlock();
+	if (val != NULL) {
+		spin_lock(&byte_lock);
+		radix_tree_delete(&byte_tree, (unsigned long)filp);
+		spin_unlock(&byte_lock);
+	}
+	return 0;
+}
+
+static const struct file_operations byte_fops = {
+	.llseek		= byte_lseek,
+	.read		= read_byte,
+	.write		= write_byte,
+	.release	= release_byte,
+};
+#endif /* CONFIG_DEV_BYTE */
+
 static const struct memdev {
 	const char *name;
 	mode_t mode;
@@ -857,6 +955,9 @@ static const struct memdev {
 #ifdef CONFIG_CRASH_DUMP
 	[12] = { "oldmem", 0, &oldmem_fops, NULL },
 #endif
+#ifdef CONFIG_DEV_BYTE
+	[13] = { "byte", 0666, &byte_fops, NULL },
+#endif
 };
 
 static int memory_open(struct inode *inode, struct file *filp)
-- 
1.7.3.4

