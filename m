Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2JQGJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:09:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51037 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755999Ab2JQGJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:09:42 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 19/23] printk: Move devkmsg bits to separate file
Date: Tue, 16 Oct 2012 23:06:23 -0700
Message-Id: <7d62136e2d9d1927e22cf534815d745d914a8b56.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the devkmsg_ functions and kmsg_fops declaration
to devkmsg.c.

Add devkmsg.o to Makefile.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/Makefile  |    1 +
 kernel/printk/devkmsg.c |  309 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/printk/printk.c  |  296 ---------------------------------------------
 3 files changed, 310 insertions(+), 296 deletions(-)
 create mode 100644 kernel/printk/devkmsg.c

diff --git a/kernel/printk/Makefile b/kernel/printk/Makefile
index a692b68..bda335f 100644
--- a/kernel/printk/Makefile
+++ b/kernel/printk/Makefile
@@ -1,3 +1,4 @@
 obj-y	= printk.o
 obj-y	+= printk_log.o
+obj-y	+= devkmsg.o
 obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)	+= braille.o
diff --git a/kernel/printk/devkmsg.c b/kernel/printk/devkmsg.c
new file mode 100644
index 0000000..af83290
--- /dev/null
+++ b/kernel/printk/devkmsg.c
@@ -0,0 +1,309 @@
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/kexec.h>
+#include <linux/slab.h>
+#include <linux/security.h>
+#include <linux/uaccess.h>
+#include <linux/poll.h>
+#include <linux/syslog.h>
+#include <linux/wait.h>
+#include <linux/uio.h>
+#include <linux/sched.h>
+
+#include "printk_log.h"
+
+/* /dev/kmsg - userspace message inject/listen interface */
+struct devkmsg_user {
+	u64 seq;
+	u32 idx;
+	enum printk_log_flags prev;
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
+	if (len > PRINTK_LOG_LINE_MAX)
+		return -EINVAL;
+	buf = kmalloc(len+1, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	line = buf;
+	for (i = 0; i < count; i++) {
+		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len)) {
+			ret = -EFAULT;
+			goto out;
+		}
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
+	struct printk_log *msg;
+	u64 ts_usec;
+	size_t i;
+	char cont = '-';
+	size_t len;
+	ssize_t ret;
+
+	if (!user)
+		return -EBADF;
+
+	ret = mutex_lock_interruptible(&user->lock);
+	if (ret)
+		return ret;
+	raw_spin_lock_irq(&printk_logbuf_lock);
+	while (user->seq == printk_log_next_seq) {
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			raw_spin_unlock_irq(&printk_logbuf_lock);
+			goto out;
+		}
+
+		raw_spin_unlock_irq(&printk_logbuf_lock);
+		ret = wait_event_interruptible(printk_log_wait,
+					       user->seq != printk_log_next_seq);
+		if (ret)
+			goto out;
+		raw_spin_lock_irq(&printk_logbuf_lock);
+	}
+
+	if (user->seq < printk_log_first_seq) {
+		/* our last seen message is gone, return error and reset */
+		user->idx = printk_log_first_idx;
+		user->seq = printk_log_first_seq;
+		ret = -EPIPE;
+		raw_spin_unlock_irq(&printk_logbuf_lock);
+		goto out;
+	}
+
+	msg = printk_log_from_idx(user->idx);
+	ts_usec = msg->ts_nsec;
+	do_div(ts_usec, 1000);
+
+	/*
+	 * If we couldn't merge continuation line fragments during the print,
+	 * export the stored flags to allow an optional external merge of the
+	 * records. Merging the records isn't always neccessarily correct, like
+	 * when we hit a race during printing. In most cases though, it produces
+	 * better readable output. 'c' in the record flags mark the first
+	 * fragment of a line, '+' the following.
+	 */
+	if (msg->flags & LOG_CONT && !(user->prev & LOG_CONT))
+		cont = 'c';
+	else if ((msg->flags & LOG_CONT) ||
+		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
+		cont = '+';
+
+	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
+		      (msg->facility << 3) | msg->level,
+		      user->seq, ts_usec, cont);
+	user->prev = msg->flags;
+
+	/* escape non-printable characters */
+	for (i = 0; i < msg->text_len; i++) {
+		unsigned char c = printk_log_text(msg)[i];
+
+		if (c < ' ' || c >= 127 || c == '\\')
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
+			unsigned char c = printk_log_dict(msg)[i];
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
+			if (c < ' ' || c >= 127 || c == '\\') {
+				len += sprintf(user->buf + len, "\\x%02x", c);
+				continue;
+			}
+
+			user->buf[len++] = c;
+		}
+		user->buf[len++] = '\n';
+	}
+
+	user->idx = printk_log_next(user->idx);
+	user->seq++;
+	raw_spin_unlock_irq(&printk_logbuf_lock);
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
+	raw_spin_lock_irq(&printk_logbuf_lock);
+	switch (whence) {
+	case SEEK_SET:
+		/* the first record */
+		user->idx = printk_log_first_idx;
+		user->seq = printk_log_first_seq;
+		break;
+	case SEEK_DATA:
+		/*
+		 * The first record after the last SYSLOG_ACTION_CLEAR,
+		 * like issued by 'dmesg -c'. Reading /dev/kmsg itself
+		 * changes no global state, and does not clear anything.
+		 */
+		user->idx = printk_log_clear_idx;
+		user->seq = printk_log_clear_seq;
+		break;
+	case SEEK_END:
+		/* after the last record */
+		user->idx = printk_log_next_idx;
+		user->seq = printk_log_next_seq;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	raw_spin_unlock_irq(&printk_logbuf_lock);
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
+	poll_wait(file, &printk_log_wait, wait);
+
+	raw_spin_lock_irq(&printk_logbuf_lock);
+	if (user->seq < printk_log_next_seq) {
+		/* return error when data has vanished underneath us */
+		if (user->seq < printk_log_first_seq)
+			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
+		ret = POLLIN|POLLRDNORM;
+	}
+	raw_spin_unlock_irq(&printk_logbuf_lock);
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
+	raw_spin_lock_irq(&printk_logbuf_lock);
+	user->idx = printk_log_first_idx;
+	user->seq = printk_log_first_seq;
+	raw_spin_unlock_irq(&printk_logbuf_lock);
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
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 43550a5..875e0dc 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -136,302 +136,6 @@ static enum printk_log_flags console_prev;
 /* cpu currently holding printk_logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
-/* /dev/kmsg - userspace message inject/listen interface */
-struct devkmsg_user {
-	u64 seq;
-	u32 idx;
-	enum printk_log_flags prev;
-	struct mutex lock;
-	char buf[8192];
-};
-
-static ssize_t devkmsg_writev(struct kiocb *iocb, const struct iovec *iv,
-			      unsigned long count, loff_t pos)
-{
-	char *buf, *line;
-	int i;
-	int level = default_message_loglevel;
-	int facility = 1;	/* LOG_USER */
-	size_t len = iov_length(iv, count);
-	ssize_t ret = len;
-
-	if (len > PRINTK_LOG_LINE_MAX)
-		return -EINVAL;
-	buf = kmalloc(len+1, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	line = buf;
-	for (i = 0; i < count; i++) {
-		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len)) {
-			ret = -EFAULT;
-			goto out;
-		}
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
-static ssize_t devkmsg_read(struct file *file, char __user *buf,
-			    size_t count, loff_t *ppos)
-{
-	struct devkmsg_user *user = file->private_data;
-	struct printk_log *msg;
-	u64 ts_usec;
-	size_t i;
-	char cont = '-';
-	size_t len;
-	ssize_t ret;
-
-	if (!user)
-		return -EBADF;
-
-	ret = mutex_lock_interruptible(&user->lock);
-	if (ret)
-		return ret;
-	raw_spin_lock_irq(&printk_logbuf_lock);
-	while (user->seq == printk_log_next_seq) {
-		if (file->f_flags & O_NONBLOCK) {
-			ret = -EAGAIN;
-			raw_spin_unlock_irq(&printk_logbuf_lock);
-			goto out;
-		}
-
-		raw_spin_unlock_irq(&printk_logbuf_lock);
-		ret = wait_event_interruptible(printk_log_wait,
-					       user->seq != printk_log_next_seq);
-		if (ret)
-			goto out;
-		raw_spin_lock_irq(&printk_logbuf_lock);
-	}
-
-	if (user->seq < printk_log_first_seq) {
-		/* our last seen message is gone, return error and reset */
-		user->idx = printk_log_first_idx;
-		user->seq = printk_log_first_seq;
-		ret = -EPIPE;
-		raw_spin_unlock_irq(&printk_logbuf_lock);
-		goto out;
-	}
-
-	msg = printk_log_from_idx(user->idx);
-	ts_usec = msg->ts_nsec;
-	do_div(ts_usec, 1000);
-
-	/*
-	 * If we couldn't merge continuation line fragments during the print,
-	 * export the stored flags to allow an optional external merge of the
-	 * records. Merging the records isn't always neccessarily correct, like
-	 * when we hit a race during printing. In most cases though, it produces
-	 * better readable output. 'c' in the record flags mark the first
-	 * fragment of a line, '+' the following.
-	 */
-	if (msg->flags & LOG_CONT && !(user->prev & LOG_CONT))
-		cont = 'c';
-	else if ((msg->flags & LOG_CONT) ||
-		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
-		cont = '+';
-
-	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
-		      (msg->facility << 3) | msg->level,
-		      user->seq, ts_usec, cont);
-	user->prev = msg->flags;
-
-	/* escape non-printable characters */
-	for (i = 0; i < msg->text_len; i++) {
-		unsigned char c = printk_log_text(msg)[i];
-
-		if (c < ' ' || c >= 127 || c == '\\')
-			len += sprintf(user->buf + len, "\\x%02x", c);
-		else
-			user->buf[len++] = c;
-	}
-	user->buf[len++] = '\n';
-
-	if (msg->dict_len) {
-		bool line = true;
-
-		for (i = 0; i < msg->dict_len; i++) {
-			unsigned char c = printk_log_dict(msg)[i];
-
-			if (line) {
-				user->buf[len++] = ' ';
-				line = false;
-			}
-
-			if (c == '\0') {
-				user->buf[len++] = '\n';
-				line = true;
-				continue;
-			}
-
-			if (c < ' ' || c >= 127 || c == '\\') {
-				len += sprintf(user->buf + len, "\\x%02x", c);
-				continue;
-			}
-
-			user->buf[len++] = c;
-		}
-		user->buf[len++] = '\n';
-	}
-
-	user->idx = printk_log_next(user->idx);
-	user->seq++;
-	raw_spin_unlock_irq(&printk_logbuf_lock);
-
-	if (len > count) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (copy_to_user(buf, user->buf, len)) {
-		ret = -EFAULT;
-		goto out;
-	}
-	ret = len;
-out:
-	mutex_unlock(&user->lock);
-	return ret;
-}
-
-static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
-{
-	struct devkmsg_user *user = file->private_data;
-	loff_t ret = 0;
-
-	if (!user)
-		return -EBADF;
-	if (offset)
-		return -ESPIPE;
-
-	raw_spin_lock_irq(&printk_logbuf_lock);
-	switch (whence) {
-	case SEEK_SET:
-		/* the first record */
-		user->idx = printk_log_first_idx;
-		user->seq = printk_log_first_seq;
-		break;
-	case SEEK_DATA:
-		/*
-		 * The first record after the last SYSLOG_ACTION_CLEAR,
-		 * like issued by 'dmesg -c'. Reading /dev/kmsg itself
-		 * changes no global state, and does not clear anything.
-		 */
-		user->idx = printk_log_clear_idx;
-		user->seq = printk_log_clear_seq;
-		break;
-	case SEEK_END:
-		/* after the last record */
-		user->idx = printk_log_next_idx;
-		user->seq = printk_log_next_seq;
-		break;
-	default:
-		ret = -EINVAL;
-	}
-	raw_spin_unlock_irq(&printk_logbuf_lock);
-	return ret;
-}
-
-static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
-{
-	struct devkmsg_user *user = file->private_data;
-	int ret = 0;
-
-	if (!user)
-		return POLLERR|POLLNVAL;
-
-	poll_wait(file, &printk_log_wait, wait);
-
-	raw_spin_lock_irq(&printk_logbuf_lock);
-	if (user->seq < printk_log_next_seq) {
-		/* return error when data has vanished underneath us */
-		if (user->seq < printk_log_first_seq)
-			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
-		ret = POLLIN|POLLRDNORM;
-	}
-	raw_spin_unlock_irq(&printk_logbuf_lock);
-
-	return ret;
-}
-
-static int devkmsg_open(struct inode *inode, struct file *file)
-{
-	struct devkmsg_user *user;
-	int err;
-
-	/* write-only does not need any file context */
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		return 0;
-
-	err = security_syslog(SYSLOG_ACTION_READ_ALL);
-	if (err)
-		return err;
-
-	user = kmalloc(sizeof(struct devkmsg_user), GFP_KERNEL);
-	if (!user)
-		return -ENOMEM;
-
-	mutex_init(&user->lock);
-
-	raw_spin_lock_irq(&printk_logbuf_lock);
-	user->idx = printk_log_first_idx;
-	user->seq = printk_log_first_seq;
-	raw_spin_unlock_irq(&printk_logbuf_lock);
-
-	file->private_data = user;
-	return 0;
-}
-
-static int devkmsg_release(struct inode *inode, struct file *file)
-{
-	struct devkmsg_user *user = file->private_data;
-
-	if (!user)
-		return 0;
-
-	mutex_destroy(&user->lock);
-	kfree(user);
-	return 0;
-}
-
-const struct file_operations kmsg_fops = {
-	.open = devkmsg_open,
-	.read = devkmsg_read,
-	.aio_write = devkmsg_writev,
-	.llseek = devkmsg_llseek,
-	.poll = devkmsg_poll,
-	.release = devkmsg_release,
-};
-
 #ifdef CONFIG_KEXEC
 /*
  * This appends the listed symbols to /proc/vmcoreinfo
-- 
1.7.10.4

