Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2DRTrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2DRTrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:47:51 -0400
Message-ID: <1334778451.15535.18.camel@mop>
Subject: [PATCH] kmsg: export printk records to the /dev/kmsg interface
From: Kay Sievers <kay@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>, Karel Zak <kzak@redhat.com>
Date: Wed, 18 Apr 2012 21:47:31 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay@vrfy.org>
Subject: kmsg: export printk records to the /dev/kmsg interface

Support for multiple concurrent readers of /dev/kmsg, with read(),
seek(), poll() support. Output of message sequence numbers, to allow
userspace log consumers to reliably reconnect and reconstruct their
state at any given time. After open("/dev/kmsg"), read() always
returns *all* buffered records. If only future messages should be
read, SEEK_END can be used. In case records get overwritten while
/dev/kmsg is held open, or records get faster overwritten than they
are read, the next read() will return -EPIPE and the current reading
position gets updated to the next available record. The passed
sequence numbers allow the log consumer to calculate the amount of
lost messages.

  [root@mop ~]# cat /dev/kmsg
  5,0,0;Linux version 3.4.0-rc1+ (kay@mop) (gcc version 4.7.0 20120315 ...
  6,159,423091;ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
  7,160,424069;pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
   SUBSYSTEM=acpi
   DEVICE=+acpi:PNP0A03:00
  6,339,5140900;NET: Registered protocol family 10
  30,340,5690716;udevd[80]: starting version 181
  6,341,6081421;FDC 0 is a S82078B
  6,345,6154686;microcode: CPU0 sig=0x623, pf=0x0, revision=0x0
  7,346,6156968;sr 1:0:0:0: Attached scsi CD-ROM sr0
   SUBSYSTEM=scsi
   DEVICE=+scsi:1:0:0:0
  6,347,6289375;microcode: CPU1 sig=0x623, pf=0x0, revision=0x0

Cc: Karel Zak <kzak@redhat.com>
Tested-by: William Douglas <william.douglas@intel.com>
Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 drivers/char/mem.c     |   61 ---------
 include/linux/printk.h |    2 
 kernel/printk.c        |  313 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 316 insertions(+), 60 deletions(-)

--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -807,65 +807,6 @@ static const struct file_operations oldm
 };
 #endif
 
-static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
-			   unsigned long count, loff_t pos)
-{
-	char *buf, *line;
-	int i;
-	int level = default_message_loglevel;
-	int facility = 1;	/* LOG_USER */
-	size_t len = iov_length(iv, count);
-	ssize_t ret = len;
-
-	if (len > 1024)
-		return -EINVAL;
-	buf = kmalloc(len+1, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	line = buf;
-	for (i = 0; i < count; i++) {
-		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len))
-			goto out;
-		line += iv[i].iov_len;
-	}
-
-	/*
-	 * Extract and skip the syslog prefix <[0-9]*>. Coming from userspace
-	 * the decimal value represents 32bit, the lower 3 bit are the log
-	 * level, the rest are the log facility.
-	 *
-	 * If no prefix or no userspace facility is specified, we
-	 * enforce LOG_USER, to be able to reliably distinguish
-	 * kernel-generated messages from userspace-injected ones.
-	 */
-	line = buf;
-	if (line[0] == '<') {
-		char *endp = NULL;
-
-		i = simple_strtoul(line+1, &endp, 10);
-		if (endp && endp[0] == '>') {
-			level = i & 7;
-			if (i >> 3)
-				facility = i >> 3;
-			endp++;
-			len -= endp - line;
-			line = endp;
-		}
-	}
-	line[len] = '\0';
-
-	printk_emit(facility, level, NULL, 0, "%s", line);
-out:
-	kfree(buf);
-	return ret;
-}
-
-static const struct file_operations kmsg_fops = {
-	.aio_write = kmsg_writev,
-	.llseek = noop_llseek,
-};
-
 static const struct memdev {
 	const char *name;
 	umode_t mode;
@@ -884,7 +825,7 @@ static const struct memdev {
 	 [7] = { "full", 0666, &full_fops, NULL },
 	 [8] = { "random", 0666, &random_fops, NULL },
 	 [9] = { "urandom", 0666, &urandom_fops, NULL },
-	[11] = { "kmsg", 0, &kmsg_fops, NULL },
+	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
 #ifdef CONFIG_CRASH_DUMP
 	[12] = { "oldmem", 0, &oldmem_fops, NULL },
 #endif
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -300,6 +300,8 @@ extern void dump_stack(void) __cold;
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
+extern const struct file_operations kmsg_fops;
+
 enum {
 	DUMP_PREFIX_NONE,
 	DUMP_PREFIX_ADDRESS,
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -41,6 +41,7 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/rculist.h>
+#include <linux/poll.h>
 
 #include <asm/uaccess.h>
 
@@ -149,6 +150,48 @@ static int console_may_schedule;
  * length of the message text is stored in the header, the stored message
  * is not terminated.
  *
+ * Optionally, a message can carry a dictionary of properties (key/value pairs),
+ * to provide userspace with a machine-readable message context.
+ *
+ * Examples for well-defined, commonly used property names are:
+ *   DEVICE=b12:8               device identifier
+ *                                b12:8         block dev_t
+ *                                c127:3        char dev_t
+ *                                n8            netdev ifindex
+ *                                +sound:card0  subsystem:devname
+ *   SUBSYSTEM=pci              driver-core subsystem name
+ *
+ * Valid characters in property names are [a-zA-Z0-9.-_]. The plain text value
+ * follows directly after a '=' character. Every property is terminated by
+ * a '\0' character. The last property is not terminated.
+ *
+ * Example of a message structure:
+ *   0000  ff 8f 00 00 00 00 00 00      monotonic time in nsec
+ *   0008  34 00                        record is 52 bytes long
+ *   000a        0b 00                  text is 11 bytes long
+ *   000c              1f 00            dictionary is 23 bytes long
+ *   000e                    03 00      LOG_KERN (facility) LOG_ERR (level)
+ *   0010  69 74 27 73 20 61 20 6c      "it's a l"
+ *         69 6e 65                     "ine"
+ *   001b           44 45 56 49 43      "DEVIC"
+ *         45 3d 62 38 3a 32 00 44      "E=b8:2\0D"
+ *         52 49 56 45 52 3d 62 75      "RIVER=bu"
+ *         67                           "g"
+ *   0032     00 00 00                  padding to next message header
+ *
+ * The 'struct log' buffer header must never be directly exported to
+ * userspace, it is a kernel-private implementation detail that might
+ * need to be changed in the future, when the requirements change.
+ *
+ * /dev/kmsg exports the structured data in the following line format:
+ *   "level,sequnum,timestamp;<message text>\n"
+ *
+ * The optional key/value pairs are attached as continuation lines starting
+ * with a space character and terminated by a newline. All possible
+ * non-prinatable characters are escaped in the "\xff" notation.
+ *
+ * Users of the export format should ignore possible additional values
+ * separated by ',', and find the message after the ';' character.
  */
 
 struct log {
@@ -297,6 +340,276 @@ static void log_store(int facility, int
 	log_next_seq++;
 }
 
+/* /dev/kmsg - userspace message inject/listen interface */
+struct devkmsg_user {
+	u64 seq;
+	u32 idx;
+	struct mutex lock;
+	char buf[8192];
+};
+
+static ssize_t devkmsg_writev(struct kiocb *iocb, const struct iovec *iv,
+			      unsigned long count, loff_t pos)
+{
+	char *buf, *line;
+	int i;
+	int level = default_message_loglevel;
+	int facility = 1;	/* LOG_USER */
+	size_t len = iov_length(iv, count);
+	ssize_t ret = len;
+
+	if (len > LOG_LINE_MAX)
+		return -EINVAL;
+	buf = kmalloc(len+1, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	line = buf;
+	for (i = 0; i < count; i++) {
+		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len))
+			goto out;
+		line += iv[i].iov_len;
+	}
+
+	/*
+	 * Extract and skip the syslog prefix <[0-9]*>. Coming from userspace
+	 * the decimal value represents 32bit, the lower 3 bit are the log
+	 * level, the rest are the log facility.
+	 *
+	 * If no prefix or no userspace facility is specified, we
+	 * enforce LOG_USER, to be able to reliably distinguish
+	 * kernel-generated messages from userspace-injected ones.
+	 */
+	line = buf;
+	if (line[0] == '<') {
+		char *endp = NULL;
+
+		i = simple_strtoul(line+1, &endp, 10);
+		if (endp && endp[0] == '>') {
+			level = i & 7;
+			if (i >> 3)
+				facility = i >> 3;
+			endp++;
+			len -= endp - line;
+			line = endp;
+		}
+	}
+	line[len] = '\0';
+
+	printk_emit(facility, level, NULL, 0, "%s", line);
+out:
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t devkmsg_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	struct devkmsg_user *user = file->private_data;
+	struct log *msg;
+	size_t i;
+	size_t len;
+	ssize_t ret;
+
+	if (!user)
+		return -EBADF;
+
+	mutex_lock(&user->lock);
+	raw_spin_lock(&logbuf_lock);
+	while (user->seq == log_next_seq) {
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			raw_spin_unlock(&logbuf_lock);
+			goto out;
+		}
+
+		raw_spin_unlock(&logbuf_lock);
+		ret = wait_event_interruptible(log_wait,
+					       user->seq != log_next_seq);
+		if (ret)
+			goto out;
+		raw_spin_lock(&logbuf_lock);
+	}
+
+	if (user->seq < log_first_seq) {
+		/* our last seen message is gone, return error and reset */
+		user->idx = log_first_idx;
+		user->seq = log_first_seq;
+		ret = -EPIPE;
+		raw_spin_unlock(&logbuf_lock);
+		goto out;
+	}
+
+	msg = log_from_idx(user->idx);
+	len = sprintf(user->buf, "%u,%llu,%llu;",
+		      msg->level, user->seq, msg->ts_nsec / 1000);
+
+	/* escape non-printable characters */
+	for (i = 0; i < msg->text_len; i++) {
+		char c = log_text(msg)[i];
+
+		if (c < ' ' || c >= 128)
+			len += sprintf(user->buf + len, "\\x%02x", c);
+		else
+			user->buf[len++] = c;
+	}
+	user->buf[len++] = '\n';
+
+	if (msg->dict_len) {
+		bool line = true;
+
+		for (i = 0; i < msg->dict_len; i++) {
+			char c = log_dict(msg)[i];
+
+			if (line) {
+				user->buf[len++] = ' ';
+				line = false;
+			}
+
+			if (c == '\0') {
+				user->buf[len++] = '\n';
+				line = true;
+				continue;
+			}
+
+			if (c < ' ' || c >= 128) {
+				len += sprintf(user->buf + len, "\\x%02x", c);
+				continue;
+			}
+
+			user->buf[len++] = c;
+		}
+		user->buf[len++] = '\n';
+	}
+
+	user->idx = log_next(user->idx);
+	user->seq++;
+	raw_spin_unlock(&logbuf_lock);
+
+	if (len > count) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (copy_to_user(buf, user->buf, len)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	ret = len;
+out:
+	mutex_unlock(&user->lock);
+	return ret;
+}
+
+static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct devkmsg_user *user = file->private_data;
+	loff_t ret = 0;
+
+	if (!user)
+		return -EBADF;
+	if (offset)
+		return -ESPIPE;
+
+	raw_spin_lock(&logbuf_lock);
+	switch (whence) {
+	case SEEK_SET:
+		/* the first record */
+		user->idx = log_first_idx;
+		user->seq = log_first_seq;
+		break;
+	case SEEK_DATA:
+		/*
+		 * The first record after the last SYSLOG_ACTION_CLEAR,
+		 * like issued by 'dmesg -c'. Reading /dev/kmsg itself
+		 * changes no global state, and does not clear anything.
+		 */
+		user->idx = clear_idx;
+		user->seq = clear_seq;
+		break;
+	case SEEK_END:
+		/* after the last record */
+		user->idx = log_next_idx;
+		user->seq = log_next_seq;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	raw_spin_unlock(&logbuf_lock);
+	return ret;
+}
+
+static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
+{
+	struct devkmsg_user *user = file->private_data;
+	int ret = 0;
+
+	if (!user)
+		return POLLERR|POLLNVAL;
+
+	poll_wait(file, &log_wait, wait);
+
+	raw_spin_lock(&logbuf_lock);
+	if (user->seq < log_next_seq) {
+		/* return error when data has vanished underneath us */
+		if (user->seq < log_first_seq)
+			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
+		ret = POLLIN|POLLRDNORM;
+	}
+	raw_spin_unlock(&logbuf_lock);
+
+	return ret;
+}
+
+static int devkmsg_open(struct inode *inode, struct file *file)
+{
+	struct devkmsg_user *user;
+	int err;
+
+	/* write-only does not need any file context */
+	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
+		return 0;
+
+	err = security_syslog(SYSLOG_ACTION_READ_ALL);
+	if (err)
+		return err;
+
+	user = kmalloc(sizeof(struct devkmsg_user), GFP_KERNEL);
+	if (!user)
+		return -ENOMEM;
+
+	mutex_init(&user->lock);
+
+	raw_spin_lock(&logbuf_lock);
+	user->idx = log_first_idx;
+	user->seq = log_first_seq;
+	raw_spin_unlock(&logbuf_lock);
+
+	file->private_data = user;
+	return 0;
+}
+
+static int devkmsg_release(struct inode *inode, struct file *file)
+{
+	struct devkmsg_user *user = file->private_data;
+
+	if (!user)
+		return 0;
+
+	mutex_destroy(&user->lock);
+	kfree(user);
+	return 0;
+}
+
+const struct file_operations kmsg_fops = {
+	.open = devkmsg_open,
+	.read = devkmsg_read,
+	.aio_write = devkmsg_writev,
+	.llseek = devkmsg_llseek,
+	.poll = devkmsg_poll,
+	.release = devkmsg_release,
+};
+
 #ifdef CONFIG_KEXEC
 /*
  * This appends the listed symbols to /proc/vmcoreinfo


