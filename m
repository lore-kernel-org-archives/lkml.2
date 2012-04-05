Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2DETrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 15:47:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48909 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2DETrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 15:47:22 -0400
Message-ID: <1333655231.725.27.camel@mop>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
From: Kay Sievers <kay@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Date: Thu, 05 Apr 2012 21:47:11 +0200
In-Reply-To: <CA+55aFyMO=xx0xNvggR-1fs-jKi_zaayNfgCa3HCNkvH0yA16g@mail.gmail.com>
References: <1333569554.864.3.camel@mop>
	 <CA+55aFyMO=xx0xNvggR-1fs-jKi_zaayNfgCa3HCNkvH0yA16g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.3.91 (3.3.91-1.fc17)
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-05 at 10:09 -0700, Linus Torvalds wrote:
> On Wed, Apr 4, 2012 at 12:59 PM, Kay Sievers <kay@vrfy.org> wrote:
> > From: Kay Sievers <kay@vrfy.org>
> > Subject: printk: support structured and multi-facility log messages

> Other than this issue, I actually don't have any problems with the
> code. Most of it seems fairly reasonable. But this one just made me go
> "wtf, how can something so reasonable then be so completely crazy in
> this regard".

Binary support is just what we are required to support in userspace
logging. We can surely live without that in the kernel.

What we are looking for is mainly the 'context' of the message, and not
possible binary data; and that will still be provided the same way with
the now simpler and more line-based output.

Better?

  [root@mop ~]# cat /dev/kmsg
  5,0,0;Linux version 3.4.0-rc1+ (kay@mop) (gcc version 4.7.0 20120315 ...
  6,1,0;Command line: root=/dev/sda1 console=tty0 console=ttyS0
  6,2,0;BIOS-provided physical RAM map:
  6,3,0; BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
  6,4,0; BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
  6,5,0; BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  6,6,0; BIOS-e820: 0000000000100000 - 000000001fffd000 (usable)
  6 ,7,0; BIOS-e820: 000000001fffd000 - 0000000020000000 (reserved)
  6,8,0; BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserved)
  6,9,0; BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
  6,10,0;NX (Execute Disable) protection: active
  6,11,0;DMI 2.4 present.
  [...]
  4,382,6189353;sr0: scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
  6,383,6190667;cdrom: Uniform CD-ROM driver Revision: 3.20
  7,384,6193747;sr 1:0:0:0: Attached scsi CD-ROM sr0
   SUBSYSTEM=scsi
   DEVICE=+scsi:1:0:0:0
  6,385,9202973;EXT4-fs (sda1): re-mounted. Opts: (null)
  6,386,10929285;Bluetooth: Core ver 2.16
  6,387,10930852;NET: Registered protocol family 31
  6,388,10932686;Bluetooth: HCI device and connection manager initialized
  6,389,10935723;Bluetooth: HCI socket layer initialized
  6,390,10937847;Bluetooth: L2CAP socket layer initialized
  ...


Thanks,
Kay



From: Kay Sievers <kay@vrfy.org>
Subject: printk: support structured and multi-facility log messages

Kernel log messages are the primary source of information about the overall
state of the system and connected devices. Traditional kernel messages are
mostly human language, targeted at a human reading them. This part of the
picture works very well since a very long time.

However, most machines run unattended almost all of their time, and
software, and not humans, need to process the kernel messages. Having
a machine making sense out of human language messages is inefficient,
unreliable, and sometimes plain impossible to get right. With human
language messages all useful information about their context,
available at the time of creation of the messages, is just thrown
away. Later, software consumers of the messages will need to apply
magic to reconstruct what the context might have been, to be able to
interpret the messages.

This patch extends printk() to be able to attach arbitrary key/value
pairs to logged messages, to carry machine-readable data which
describes the context of the log message at time of its
creation. Users of the log can retrieve, along with the human-readable
message, a key/value dictionary to reliably identify specific devices,
drivers, subsystems, classes and types of messages.

Various features of this patch:

- Record-based stream instead of the traditional byte stream
  buffer. All records carry a 64 bit timestamp, the syslog facility
  and priority in the record header.

- Records consume almost the same amount, sometimes less memory than
  the traditional byte stream buffer (if printk_time is enabled). The record
  header is 16 bytes long, plus some padding bytes at the end if needed.
  The byte-stream buffer needed 3 chars for the syslog prefix, 15 char for
  the timestamp and a newline.

- Buffer management is based on message sequence numbers. When records
  need to be discarded, the reading heads move on to the next full
  record. Unlike the byte-stream buffer, no old logged lines get
  truncated or partly overwritten by new ones. Sequence numbers also
  allow consumers of the log stream to get notified if any message in
  the stream they are about to read gets discarded during the time
  of reading.

- Better buffered IO support for KERN_CONT continuation lines, when printk()
  is called multiple times for a single line. The use of KERN_CONT is now
  mandatory to use continuation; a few places in the kernel need trivial fixes
  here. The buffering could possibly be extended to per-cpu variables to allow
  better thread-safety for multiple printk() invocations for a single line.

- Full-featured syslog facility value support. Different facilities
  can tag their messages. All userspace-injected messages enforce a
  facility value > 0 now, to be able to reliably distinguish them from
  the kernel-generated messages. Independent subsystems like a
  baseband processor running its own firmware, or a kernel-related
  userspace process can use their own unique facility values. Multiple
  independent log streams can co-exist that way in the same
  buffer. All share the same global sequence number counter to ensure
  proper ordering (and interleaving) and to allow the consumers of the
  log to reliably correlate the events from different facilities.

- Output of dev_printk() is reliably machine-readable now. In addition
  to the printed plain text message, it creates a log dictionary with the
  following properties:
    SUBSYSTEM=     - the driver-core subsytem name
    DEVICE=
      b12:8        - block dev_t
      c127:3       - char dev_t
      n8           - netdev ifindex
      +sound:card0 - subsystem:devname

- Support for multiple concurrent readers of /dev/kmsg, with read(),
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

Tested-by: William Douglas <william.douglas@intel.com>
Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 drivers/base/core.c    |   52 +
 drivers/char/mem.c     |   40 -
 include/linux/printk.h |   13 
 kernel/printk.c        | 1333 +++++++++++++++++++++++++++++++++----------------
 4 files changed, 969 insertions(+), 469 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -25,6 +25,7 @@
 #include <linux/mutex.h>
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
+#include <linux/netdevice.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -1843,15 +1844,60 @@ void device_shutdown(void)
  */
 
 #ifdef CONFIG_PRINTK
-
 int __dev_printk(const char *level, const struct device *dev,
 		 struct va_format *vaf)
 {
+	char dict[128];
+	size_t dictlen = 0;
+	const char *subsys;
+
 	if (!dev)
 		return printk("%s(NULL device *): %pV", level, vaf);
 
-	return printk("%s%s %s: %pV",
-		      level, dev_driver_string(dev), dev_name(dev), vaf);
+	if (dev->class)
+		subsys = dev->class->name;
+	else if (dev->bus)
+		subsys = dev->bus->name;
+	else
+		subsys = "(NULL subsystem)";
+
+	dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
+			    "SUBSYSTEM=%s", subsys);
+
+	/*
+	 * Add device identifier DEVICE=:
+	 *   b12:8         block dev_t
+	 *   c127:3        char dev_t
+	 *   n8            netdev ifindex
+	 *   +sound:card0  subsystem:devname
+	 */
+	if (MAJOR(dev->devt)) {
+		char c;
+
+		if (strcmp(subsys, "block") == 0)
+			c = 'b';
+		else
+			c = 'c';
+		dictlen++;
+		dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
+				   "DEVICE=%c%u:%u",
+				   c, MAJOR(dev->devt), MINOR(dev->devt));
+	} else if (strcmp(subsys, "net") == 0) {
+		struct net_device *net = to_net_dev(dev);
+
+		dictlen++;
+		dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
+				    "DEVICE=n%u", net->ifindex);
+	} else {
+		dictlen++;
+		dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
+				    "DEVICE=+%s:%s", subsys, dev_name(dev));
+	}
+
+	return printk_emit(0, level[1] - '0',
+			   dict, dictlen,
+			   "%s %s: %pV",
+			   dev_driver_string(dev), dev_name(dev), vaf);
 }
 EXPORT_SYMBOL(__dev_printk);
 
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -807,44 +807,6 @@ static const struct file_operations oldm
 };
 #endif
 
-static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
-			   unsigned long count, loff_t pos)
-{
-	char *line, *p;
-	int i;
-	ssize_t ret = -EFAULT;
-	size_t len = iov_length(iv, count);
-
-	line = kmalloc(len + 1, GFP_KERNEL);
-	if (line == NULL)
-		return -ENOMEM;
-
-	/*
-	 * copy all vectors into a single string, to ensure we do
-	 * not interleave our log line with other printk calls
-	 */
-	p = line;
-	for (i = 0; i < count; i++) {
-		if (copy_from_user(p, iv[i].iov_base, iv[i].iov_len))
-			goto out;
-		p += iv[i].iov_len;
-	}
-	p[0] = '\0';
-
-	ret = printk("%s", line);
-	/* printk can add a prefix */
-	if (ret > len)
-		ret = len;
-out:
-	kfree(line);
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
@@ -863,7 +825,7 @@ static const struct memdev {
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
@@ -95,8 +95,19 @@ extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
 
 #ifdef CONFIG_PRINTK
+asmlinkage __printf(5, 0)
+int vprintk_emit(int facility, int level,
+		 const char *dict, size_t dictlen,
+		 const char *fmt, va_list args);
+
 asmlinkage __printf(1, 0)
 int vprintk(const char *fmt, va_list args);
+
+asmlinkage __printf(5, 6) __cold
+asmlinkage int printk_emit(int facility, int level,
+			   const char *dict, size_t dictlen,
+			   const char *fmt, ...);
+
 asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
 
@@ -289,6 +300,8 @@ extern void dump_stack(void) __cold;
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
 
@@ -54,8 +55,6 @@ void asmlinkage __attribute__((weak)) ea
 {
 }
 
-#define __LOG_BUF_LEN	(1 << CONFIG_LOG_BUF_SHIFT)
-
 /* printk's without a loglevel use this.. */
 #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
@@ -99,24 +98,6 @@ EXPORT_SYMBOL_GPL(console_drivers);
 static int console_locked, console_suspended;
 
 /*
- * logbuf_lock protects log_buf, log_start, log_end, con_start and logged_chars
- * It is also used in interesting ways to provide interlocking in
- * console_unlock();.
- */
-static DEFINE_RAW_SPINLOCK(logbuf_lock);
-
-#define LOG_BUF_MASK (log_buf_len-1)
-#define LOG_BUF(idx) (log_buf[(idx) & LOG_BUF_MASK])
-
-/*
- * The indices into log_buf are not constrained to log_buf_len - they
- * must be masked before subscripting
- */
-static unsigned log_start;	/* Index into log_buf: next char to be read by syslog() */
-static unsigned con_start;	/* Index into log_buf: next char to be sent to consoles */
-static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
-
-/*
  * If exclusive_console is non-NULL then only this console is to be printed to.
  */
 static struct console *exclusive_console;
@@ -146,12 +127,488 @@ EXPORT_SYMBOL(console_set_on_cmdline);
 static int console_may_schedule;
 
 #ifdef CONFIG_PRINTK
+/*
+ * The printk log buffer consists of a chain of concatenated variable
+ * length records. Every record starts with a record header, containing
+ * the overall length of the record.
+ *
+ * The heads to the first and last entry in the buffer, as well as the
+ * sequence numbers of these both entries are maintained when messages
+ * are stored..
+ *
+ * If the heads indicate available messages, the length in the header
+ * tells the start next message. A length == 0 for the next message
+ * indicates a wrap-around to the beginning of the buffer.
+ *
+ * Every record carries the monotonic timestamp in microseconds, as well as
+ * the standard userspace syslog level and syslog facility. The usual
+ * kernel messages use LOG_KERN; userspace-injected messages always carry
+ * a matching syslog facility, by default LOG_USER. The origin of every
+ * message can be reliably determined that way.
+ *
+ * The human readable log message directly follows the message header. The
+ * length of the message text is stored in the header, the stored message
+ * is not terminated.
+ *
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
+ * non-printable characters are escaped in the "\xff" notation.
+ *
+ * Users of the export format should ignore possible additional values
+ * separated by ',', and find the message after the ';' character.
+ */
+
+struct log {
+	u64 ts_nsec;		/* timestamp in nanoseconds */
+	u16 len;		/* length of entire record */
+	u16 text_len;		/* length of text buffer */
+	u16 dict_len;		/* length of dictionary buffer */
+	u16 level;		/* syslog level + facility */
+};
 
+/*
+ * The logbuf_lock protects kmsg buffer, indices, counters. It is also
+ * used in interesting ways to provide interlocking in console_unlock();
+ */
+static DEFINE_RAW_SPINLOCK(logbuf_lock);
+
+/* cpu currently holding logbuf_lock */
+static volatile unsigned int logbuf_cpu = UINT_MAX;
+
+#define LOG_LINE_MAX 1024
+
+/* record buffer */
+#define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN];
 static char *log_buf = __log_buf;
-static int log_buf_len = __LOG_BUF_LEN;
-static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
-static int saved_console_loglevel = -1;
+static u32 log_buf_len = __LOG_BUF_LEN;
+
+/* index and sequence number of the first record stored in the buffer */
+static u64 log_first_seq;
+static u32 log_first_idx;
+
+/* index and sequence number of the next record to store in the buffer */
+static u64 log_next_seq;
+static u32 log_next_idx;
+
+/* the next printk record to read after the last 'clear' command */
+static u64 clear_seq;
+static u32 clear_idx;
+
+/* the next printk record to read by syslog(READ) or /proc/kmsg */
+static u64 syslog_seq;
+static u32 syslog_idx;
+
+/* human readable text of the record */
+static char *log_text(const struct log *msg)
+{
+	return (char *)msg + sizeof(struct log);
+}
+
+/* optional key/value pair dictionary attached to the record */
+static char *log_dict(const struct log *msg)
+{
+	return (char *)msg + sizeof(struct log) + msg->text_len;
+}
+
+/* get record by index; idx must point to valid msg */
+static struct log *log_from_idx(u32 idx)
+{
+	struct log *msg = (struct log *)(log_buf + idx);
+
+	/*
+	 * A length == 0 record is the end of buffer marker. Wrap around and
+	 * read the message at the start of the buffer.
+	 */
+	if (!msg->len)
+		return (struct log *)log_buf;
+	return msg;
+}
+
+/* get next record; idx must point to valid msg */
+static u32 log_next(u32 idx)
+{
+	struct log *msg = (struct log *)(log_buf + idx);
+
+	/* length == 0 indicates the end of the buffer; wrap */
+	/*
+	 * A length == 0 record is the end of buffer marker. Wrap around and
+	 * read the message at the start of the buffer as *this* one, and
+	 * return the one after that.
+	 */
+	if (!msg->len) {
+		msg = (struct log *)log_buf;
+		return msg->len;
+	}
+	return idx + msg->len;
+}
+
+#if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+#define LOG_ALIGN 4
+#else
+#define LOG_ALIGN 8
+#endif
+
+/* insert record into the buffer, discard old ones, update heads */
+static void log_store(int facility, int level,
+		      const char *dict, u16 dict_len,
+		      const char *text, u16 text_len)
+{
+	struct log *msg;
+	u32 size, pad_len;
+
+	/* number of '\0' padding bytes to next message */
+	size = sizeof(struct log) + text_len + dict_len;
+	pad_len = (-size) & (LOG_ALIGN - 1);
+	size += pad_len;
+
+	while (log_first_seq < log_next_seq) {
+		u32 free;
+
+		if (log_next_idx > log_first_idx)
+			free = max(log_buf_len - log_next_idx, log_first_idx);
+		else
+			free = log_first_idx - log_next_idx;
+
+		if (free > size + sizeof(struct log))
+			break;
+
+		/* drop old messages until we have enough contiuous space */
+		log_first_idx = log_next(log_first_idx);
+		log_first_seq++;
+	}
+
+	if (log_next_idx + size + sizeof(struct log) >= log_buf_len) {
+		/*
+		 * This message + an additional empty header does not fit
+		 * at the end of the buffer. Add an empty header with len == 0
+		 * to signify a wrap around.
+		 */
+		memset(log_buf + log_next_idx, 0, sizeof(struct log));
+		log_next_idx = 0;
+	}
+
+	/* fill message */
+	msg = (struct log *)(log_buf + log_next_idx);
+	memcpy(log_text(msg), text, text_len);
+	msg->text_len = text_len;
+	memcpy(log_dict(msg), dict, dict_len);
+	msg->dict_len = dict_len;
+	msg->level = (facility << 3) | (level & 7);
+	msg->ts_nsec = local_clock();
+	memset(log_dict(msg) + dict_len, 0, pad_len);
+	msg->len = sizeof(struct log) + text_len + dict_len + pad_len;
+
+	/* insert message */
+	log_next_idx += msg->len;
+	log_next_seq++;
+}
+
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
 
 #ifdef CONFIG_KEXEC
 /*
@@ -165,9 +622,9 @@ static int saved_console_loglevel = -1;
 void log_buf_kexec_setup(void)
 {
 	VMCOREINFO_SYMBOL(log_buf);
-	VMCOREINFO_SYMBOL(log_end);
 	VMCOREINFO_SYMBOL(log_buf_len);
-	VMCOREINFO_SYMBOL(logged_chars);
+	VMCOREINFO_SYMBOL(log_first_idx);
+	VMCOREINFO_SYMBOL(log_next_idx);
 }
 #endif
 
@@ -191,7 +648,6 @@ early_param("log_buf_len", log_buf_len_s
 void __init setup_log_buf(int early)
 {
 	unsigned long flags;
-	unsigned start, dest_idx, offset;
 	char *new_log_buf;
 	int free;
 
@@ -219,20 +675,8 @@ void __init setup_log_buf(int early)
 	log_buf_len = new_log_buf_len;
 	log_buf = new_log_buf;
 	new_log_buf_len = 0;
-	free = __LOG_BUF_LEN - log_end;
-
-	offset = start = min(con_start, log_start);
-	dest_idx = 0;
-	while (start != log_end) {
-		unsigned log_idx_mask = start & (__LOG_BUF_LEN - 1);
-
-		log_buf[dest_idx] = __log_buf[log_idx_mask];
-		start++;
-		dest_idx++;
-	}
-	log_start -= offset;
-	con_start -= offset;
-	log_end -= offset;
+	free = __LOG_BUF_LEN - log_next_idx;
+	memcpy(log_buf, __log_buf, __LOG_BUF_LEN);
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 	pr_info("log_buf_len: %d\n", log_buf_len);
@@ -332,11 +776,165 @@ static int check_syslog_permissions(int
 	return 0;
 }
 
+#if defined(CONFIG_PRINTK_TIME)
+static bool printk_time = 1;
+#else
+static bool printk_time;
+#endif
+module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
+
+static int syslog_print_line(u32 idx, char *text, size_t size)
+{
+	struct log *msg;
+	size_t len;
+
+	msg = log_from_idx(idx);
+	if (!text) {
+		/* calculate length only */
+		len = 3;
+
+		if (msg->level > 9)
+			len++;
+		if (msg->level > 99)
+			len++;
+
+		if (printk_time)
+			len += 15;
+
+		len += msg->text_len;
+		len++;
+		return len;
+	}
+
+	len = sprintf(text, "<%u>", msg->level);
+
+	if (printk_time) {
+		unsigned long long t = msg->ts_nsec;
+		unsigned long rem_ns = do_div(t, 1000000000);
+
+		len += sprintf(text + len, "[%5lu.%06lu] ",
+				   (unsigned long) t, rem_ns / 1000);
+	}
+
+	if (len + msg->text_len > size)
+		return -EINVAL;
+	memcpy(text + len, log_text(msg), msg->text_len);
+	len += msg->text_len;
+	text[len++] = '\n';
+	return len;
+}
+
+static int syslog_print(char __user *buf, int size)
+{
+	char *text;
+	int len;
+
+	text = kmalloc(LOG_LINE_MAX, GFP_KERNEL);
+	if (!text)
+		return -ENOMEM;
+
+	raw_spin_lock_irq(&logbuf_lock);
+	if (syslog_seq < log_first_seq) {
+		/* messages are gone, move to first one */
+		syslog_seq = log_first_seq;
+		syslog_idx = log_first_idx;
+	}
+	len = syslog_print_line(syslog_idx, text, LOG_LINE_MAX);
+	syslog_idx = log_next(syslog_idx);
+	syslog_seq++;
+	raw_spin_unlock_irq(&logbuf_lock);
+
+	if (len > 0 && copy_to_user(buf, text, len))
+		len = -EFAULT;
+
+	kfree(text);
+	return len;
+}
+
+static int syslog_print_all(char __user *buf, int size, bool clear)
+{
+	char *text;
+	int len = 0;
+
+	text = kmalloc(LOG_LINE_MAX, GFP_KERNEL);
+	if (!text)
+		return -ENOMEM;
+
+	raw_spin_lock_irq(&logbuf_lock);
+	if (buf) {
+		u64 next_seq;
+		u64 seq;
+		u32 idx;
+
+		if (clear_seq < log_first_seq) {
+			/* messages are gone, move to first available one */
+			clear_seq = log_first_seq;
+			clear_idx = log_first_idx;
+		}
+
+		/*
+		 * Find first record that fits, including all following records,
+		 * into the user-provided buffer for this dump.
+		*/
+		seq = clear_seq;
+		idx = clear_idx;
+		while (seq < log_next_seq) {
+			len += syslog_print_line(idx, NULL, 0);
+			idx = log_next(idx);
+			seq++;
+		}
+		seq = clear_seq;
+		idx = clear_idx;
+		while (len > size && seq < log_next_seq) {
+			len -= syslog_print_line(idx, NULL, 0);
+			idx = log_next(idx);
+			seq++;
+		}
+
+		/* last message in this dump */
+		next_seq = log_next_seq;
+
+		len = 0;
+		while (len >= 0 && seq < next_seq) {
+			int textlen;
+
+			textlen = syslog_print_line(idx, text, LOG_LINE_MAX);
+			if (textlen < 0) {
+				len = textlen;
+				break;
+			}
+			idx = log_next(idx);
+			seq++;
+
+			raw_spin_unlock_irq(&logbuf_lock);
+			if (copy_to_user(buf + len, text, textlen))
+				len = -EFAULT;
+			else
+				len += textlen;
+			raw_spin_lock_irq(&logbuf_lock);
+
+			if (seq < log_first_seq) {
+				/* messages are gone, move to next one */
+				seq = log_first_seq;
+				idx = log_first_idx;
+			}
+		}
+	}
+
+	if (clear) {
+		clear_seq = log_next_seq;
+		clear_idx = log_next_idx;
+	}
+	raw_spin_unlock_irq(&logbuf_lock);
+
+	kfree(text);
+	return len;
+}
+
 int do_syslog(int type, char __user *buf, int len, bool from_file)
 {
-	unsigned i, j, limit, count;
-	int do_clear = 0;
-	char c;
+	bool clear = false;
+	static int saved_console_loglevel = -1;
 	int error;
 
 	error = check_syslog_permissions(type, from_file);
@@ -364,28 +962,14 @@ int do_syslog(int type, char __user *buf
 			goto out;
 		}
 		error = wait_event_interruptible(log_wait,
-							(log_start - log_end));
+						 syslog_seq != log_next_seq);
 		if (error)
 			goto out;
-		i = 0;
-		raw_spin_lock_irq(&logbuf_lock);
-		while (!error && (log_start != log_end) && i < len) {
-			c = LOG_BUF(log_start);
-			log_start++;
-			raw_spin_unlock_irq(&logbuf_lock);
-			error = __put_user(c,buf);
-			buf++;
-			i++;
-			cond_resched();
-			raw_spin_lock_irq(&logbuf_lock);
-		}
-		raw_spin_unlock_irq(&logbuf_lock);
-		if (!error)
-			error = i;
+		error = syslog_print(buf, len);
 		break;
 	/* Read/clear last kernel messages */
 	case SYSLOG_ACTION_READ_CLEAR:
-		do_clear = 1;
+		clear = true;
 		/* FALL THRU */
 	/* Read last kernel messages */
 	case SYSLOG_ACTION_READ_ALL:
@@ -399,52 +983,11 @@ int do_syslog(int type, char __user *buf
 			error = -EFAULT;
 			goto out;
 		}
-		count = len;
-		if (count > log_buf_len)
-			count = log_buf_len;
-		raw_spin_lock_irq(&logbuf_lock);
-		if (count > logged_chars)
-			count = logged_chars;
-		if (do_clear)
-			logged_chars = 0;
-		limit = log_end;
-		/*
-		 * __put_user() could sleep, and while we sleep
-		 * printk() could overwrite the messages
-		 * we try to copy to user space. Therefore
-		 * the messages are copied in reverse. <manfreds>
-		 */
-		for (i = 0; i < count && !error; i++) {
-			j = limit-1-i;
-			if (j + log_buf_len < log_end)
-				break;
-			c = LOG_BUF(j);
-			raw_spin_unlock_irq(&logbuf_lock);
-			error = __put_user(c,&buf[count-1-i]);
-			cond_resched();
-			raw_spin_lock_irq(&logbuf_lock);
-		}
-		raw_spin_unlock_irq(&logbuf_lock);
-		if (error)
-			break;
-		error = i;
-		if (i != count) {
-			int offset = count-error;
-			/* buffer overflow during copy, correct user buffer. */
-			for (i = 0; i < error; i++) {
-				if (__get_user(c,&buf[i+offset]) ||
-				    __put_user(c,&buf[i])) {
-					error = -EFAULT;
-					break;
-				}
-				cond_resched();
-			}
-		}
+		error = syslog_print_all(buf, len, clear);
 		break;
 	/* Clear ring buffer */
 	case SYSLOG_ACTION_CLEAR:
-		logged_chars = 0;
-		break;
+		syslog_print_all(NULL, 0, true);
 	/* Disable logging to console */
 	case SYSLOG_ACTION_CONSOLE_OFF:
 		if (saved_console_loglevel == -1)
@@ -472,7 +1015,33 @@ int do_syslog(int type, char __user *buf
 		break;
 	/* Number of chars in the log buffer */
 	case SYSLOG_ACTION_SIZE_UNREAD:
-		error = log_end - log_start;
+		raw_spin_lock_irq(&logbuf_lock);
+		if (syslog_seq < log_first_seq) {
+			/* messages are gone, move to first one */
+			syslog_seq = log_first_seq;
+			syslog_idx = log_first_idx;
+		}
+		if (from_file) {
+			/*
+			 * Short-cut for poll(/"proc/kmsg") which simply checks
+			 * for pending data, not the size; return the count of
+			 * records, not the length.
+			 */
+			error = log_next_idx - syslog_idx;
+		} else {
+			u64 seq;
+			u32 idx;
+
+			error = 0;
+			seq = syslog_seq;
+			idx = syslog_idx;
+			while (seq < log_next_seq) {
+				error += syslog_print_line(idx, NULL, 0);
+				idx = log_next(idx);
+				seq++;
+			}
+		}
+		raw_spin_unlock_irq(&logbuf_lock);
 		break;
 	/* Size of the log buffer */
 	case SYSLOG_ACTION_SIZE_BUFFER:
@@ -501,29 +1070,11 @@ void kdb_syslog_data(char *syslog_data[4
 {
 	syslog_data[0] = log_buf;
 	syslog_data[1] = log_buf + log_buf_len;
-	syslog_data[2] = log_buf + log_end -
-		(logged_chars < log_buf_len ? logged_chars : log_buf_len);
-	syslog_data[3] = log_buf + log_end;
+	syslog_data[2] = log_buf + log_first_idx;
+	syslog_data[3] = log_buf + log_next_idx;
 }
 #endif	/* CONFIG_KGDB_KDB */
 
-/*
- * Call the console drivers on a range of log_buf
- */
-static void __call_console_drivers(unsigned start, unsigned end)
-{
-	struct console *con;
-
-	for_each_console(con) {
-		if (exclusive_console && con != exclusive_console)
-			continue;
-		if ((con->flags & CON_ENABLED) && con->write &&
-				(cpu_online(smp_processor_id()) ||
-				(con->flags & CON_ANYTIME)))
-			con->write(con, &LOG_BUF(start), end - start);
-	}
-}
-
 static bool __read_mostly ignore_loglevel;
 
 static int __init ignore_loglevel_setup(char *str)
@@ -540,142 +1091,33 @@ MODULE_PARM_DESC(ignore_loglevel, "ignor
 	"print all kernel messages to the console.");
 
 /*
- * Write out chars from start to end - 1 inclusive
- */
-static void _call_console_drivers(unsigned start,
-				unsigned end, int msg_log_level)
-{
-	trace_console(&LOG_BUF(0), start, end, log_buf_len);
-
-	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
-			console_drivers && start != end) {
-		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
-			/* wrapped write */
-			__call_console_drivers(start & LOG_BUF_MASK,
-						log_buf_len);
-			__call_console_drivers(0, end & LOG_BUF_MASK);
-		} else {
-			__call_console_drivers(start, end);
-		}
-	}
-}
-
-/*
- * Parse the syslog header <[0-9]*>. The decimal value represents 32bit, the
- * lower 3 bit are the log level, the rest are the log facility. In case
- * userspace passes usual userspace syslog messages to /dev/kmsg or
- * /dev/ttyprintk, the log prefix might contain the facility. Printk needs
- * to extract the correct log level for in-kernel processing, and not mangle
- * the original value.
- *
- * If a prefix is found, the length of the prefix is returned. If 'level' is
- * passed, it will be filled in with the log level without a possible facility
- * value. If 'special' is passed, the special printk prefix chars are accepted
- * and returned. If no valid header is found, 0 is returned and the passed
- * variables are not touched.
- */
-static size_t log_prefix(const char *p, unsigned int *level, char *special)
-{
-	unsigned int lev = 0;
-	char sp = '\0';
-	size_t len;
-
-	if (p[0] != '<' || !p[1])
-		return 0;
-	if (p[2] == '>') {
-		/* usual single digit level number or special char */
-		switch (p[1]) {
-		case '0' ... '7':
-			lev = p[1] - '0';
-			break;
-		case 'c': /* KERN_CONT */
-		case 'd': /* KERN_DEFAULT */
-			sp = p[1];
-			break;
-		default:
-			return 0;
-		}
-		len = 3;
-	} else {
-		/* multi digit including the level and facility number */
-		char *endp = NULL;
-
-		lev = (simple_strtoul(&p[1], &endp, 10) & 7);
-		if (endp == NULL || endp[0] != '>')
-			return 0;
-		len = (endp + 1) - p;
-	}
-
-	/* do not accept special char if not asked for */
-	if (sp && !special)
-		return 0;
-
-	if (special) {
-		*special = sp;
-		/* return special char, do not touch level */
-		if (sp)
-			return len;
-	}
-
-	if (level)
-		*level = lev;
-	return len;
-}
-
-/*
  * Call the console drivers, asking them to write out
  * log_buf[start] to log_buf[end - 1].
  * The console_lock must be held.
  */
-static void call_console_drivers(unsigned start, unsigned end)
+static void call_console_drivers(int level, const char *text, size_t len)
 {
-	unsigned cur_index, start_print;
-	static int msg_level = -1;
+	struct console *con;
 
-	BUG_ON(((int)(start - end)) > 0);
+	trace_console(text, 0, len, len);
 
-	cur_index = start;
-	start_print = start;
-	while (cur_index != end) {
-		if (msg_level < 0 && ((end - cur_index) > 2)) {
-			/* strip log prefix */
-			cur_index += log_prefix(&LOG_BUF(cur_index), &msg_level, NULL);
-			start_print = cur_index;
-		}
-		while (cur_index != end) {
-			char c = LOG_BUF(cur_index);
-
-			cur_index++;
-			if (c == '\n') {
-				if (msg_level < 0) {
-					/*
-					 * printk() has already given us loglevel tags in
-					 * the buffer.  This code is here in case the
-					 * log buffer has wrapped right round and scribbled
-					 * on those tags
-					 */
-					msg_level = default_message_loglevel;
-				}
-				_call_console_drivers(start_print, cur_index, msg_level);
-				msg_level = -1;
-				start_print = cur_index;
-				break;
-			}
-		}
-	}
-	_call_console_drivers(start_print, end, msg_level);
-}
+	if (level >= console_loglevel && !ignore_loglevel)
+		return;
+	if (!console_drivers)
+		return;
 
-static void emit_log_char(char c)
-{
-	LOG_BUF(log_end) = c;
-	log_end++;
-	if (log_end - log_start > log_buf_len)
-		log_start = log_end - log_buf_len;
-	if (log_end - con_start > log_buf_len)
-		con_start = log_end - log_buf_len;
-	if (logged_chars < log_buf_len)
-		logged_chars++;
+	for_each_console(con) {
+		if (exclusive_console && con != exclusive_console)
+			continue;
+		if (!(con->flags & CON_ENABLED))
+			continue;
+		if (!con->write)
+			continue;
+		if (!cpu_online(smp_processor_id()) &&
+		    !(con->flags & CON_ANYTIME))
+			continue;
+		con->write(con, text, len);
+	}
 }
 
 /*
@@ -700,16 +1142,6 @@ static void zap_locks(void)
 	sema_init(&console_sem, 1);
 }
 
-#if defined(CONFIG_PRINTK_TIME)
-static bool printk_time = 1;
-#else
-static bool printk_time = 0;
-#endif
-module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
-
-static bool always_kmsg_dump;
-module_param_named(always_kmsg_dump, always_kmsg_dump, bool, S_IRUGO | S_IWUSR);
-
 /* Check if we have any console registered that can be called early in boot. */
 static int have_callable_console(void)
 {
@@ -722,51 +1154,6 @@ static int have_callable_console(void)
 	return 0;
 }
 
-/**
- * printk - print a kernel message
- * @fmt: format string
- *
- * This is printk().  It can be called from any context.  We want it to work.
- *
- * We try to grab the console_lock.  If we succeed, it's easy - we log the output and
- * call the console drivers.  If we fail to get the semaphore we place the output
- * into the log buffer and return.  The current holder of the console_sem will
- * notice the new output in console_unlock(); and will send it to the
- * consoles before releasing the lock.
- *
- * One effect of this deferred printing is that code which calls printk() and
- * then changes console_loglevel may break. This is because console_loglevel
- * is inspected when the actual printing occurs.
- *
- * See also:
- * printf(3)
- *
- * See the vsnprintf() documentation for format string extensions over C99.
- */
-
-asmlinkage int printk(const char *fmt, ...)
-{
-	va_list args;
-	int r;
-
-#ifdef CONFIG_KGDB_KDB
-	if (unlikely(kdb_trap_printk)) {
-		va_start(args, fmt);
-		r = vkdb_printf(fmt, args);
-		va_end(args);
-		return r;
-	}
-#endif
-	va_start(args, fmt);
-	r = vprintk(fmt, args);
-	va_end(args);
-
-	return r;
-}
-
-/* cpu currently holding logbuf_lock */
-static volatile unsigned int printk_cpu = UINT_MAX;
-
 /*
  * Can we actually use the console at this time on this cpu?
  *
@@ -810,17 +1197,12 @@ static int console_trylock_for_printk(un
 			retval = 0;
 		}
 	}
-	printk_cpu = UINT_MAX;
+	logbuf_cpu = UINT_MAX;
 	if (wake)
 		up(&console_sem);
 	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
-static const char recursion_bug_msg [] =
-		KERN_CRIT "BUG: recent printk recursion!\n";
-static int recursion_bug;
-static int new_text_line = 1;
-static char printk_buf[1024];
 
 int printk_delay_msec __read_mostly;
 
@@ -836,15 +1218,22 @@ static inline void printk_delay(void)
 	}
 }
 
-asmlinkage int vprintk(const char *fmt, va_list args)
-{
-	int printed_len = 0;
-	int current_log_level = default_message_loglevel;
+asmlinkage int vprintk_emit(int facility, int level,
+			    const char *dict, size_t dictlen,
+			    const char *fmt, va_list args)
+{
+	static int recursion_bug;
+	static char buf[LOG_LINE_MAX];
+	static size_t buflen;
+	static int buflevel;
+	static char textbuf[LOG_LINE_MAX];
+	char *text = textbuf;
+	size_t textlen;
 	unsigned long flags;
 	int this_cpu;
-	char *p;
-	size_t plen;
-	char special;
+	bool newline = false;
+	bool cont = false;
+	int printed_len = 0;
 
 	boot_delay_msec();
 	printk_delay();
@@ -856,7 +1245,7 @@ asmlinkage int vprintk(const char *fmt,
 	/*
 	 * Ouch, printk recursed into itself!
 	 */
-	if (unlikely(printk_cpu == this_cpu)) {
+	if (unlikely(logbuf_cpu == this_cpu)) {
 		/*
 		 * If a crash is occurring during printk() on this CPU,
 		 * then try to get the crash message out but make sure
@@ -873,97 +1262,92 @@ asmlinkage int vprintk(const char *fmt,
 
 	lockdep_off();
 	raw_spin_lock(&logbuf_lock);
-	printk_cpu = this_cpu;
+	logbuf_cpu = this_cpu;
 
 	if (recursion_bug) {
+		static const char recursion_msg[] =
+			"BUG: recent printk recursion!";
+
 		recursion_bug = 0;
-		strcpy(printk_buf, recursion_bug_msg);
-		printed_len = strlen(recursion_bug_msg);
-	}
-	/* Emit the output into the temporary buffer */
-	printed_len += vscnprintf(printk_buf + printed_len,
-				  sizeof(printk_buf) - printed_len, fmt, args);
-
-	p = printk_buf;
-
-	/* Read log level and handle special printk prefix */
-	plen = log_prefix(p, &current_log_level, &special);
-	if (plen) {
-		p += plen;
-
-		switch (special) {
-		case 'c': /* Strip <c> KERN_CONT, continue line */
-			plen = 0;
-			break;
-		case 'd': /* Strip <d> KERN_DEFAULT, start new line */
-			plen = 0;
-		default:
-			if (!new_text_line) {
-				emit_log_char('\n');
-				new_text_line = 1;
-			}
-		}
+		printed_len += strlen(recursion_msg);
+		/* emit KERN_CRIT message */
+		log_store(0, 2, NULL, 0, recursion_msg, printed_len);
 	}
 
 	/*
-	 * Copy the output into log_buf. If the caller didn't provide
-	 * the appropriate log prefix, we insert them here
+	 * The printf needs to come first; we need the syslog
+	 * prefix which might be passed-in as a parameter.
 	 */
-	for (; *p; p++) {
-		if (new_text_line) {
-			new_text_line = 0;
-
-			if (plen) {
-				/* Copy original log prefix */
-				int i;
-
-				for (i = 0; i < plen; i++)
-					emit_log_char(printk_buf[i]);
-				printed_len += plen;
-			} else {
-				/* Add log prefix */
-				emit_log_char('<');
-				emit_log_char(current_log_level + '0');
-				emit_log_char('>');
-				printed_len += 3;
-			}
+	textlen = vscnprintf(text, sizeof(textbuf), fmt, args);
 
-			if (printk_time) {
-				/* Add the current time stamp */
-				char tbuf[50], *tp;
-				unsigned tlen;
-				unsigned long long t;
-				unsigned long nanosec_rem;
-
-				t = cpu_clock(printk_cpu);
-				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
-						(unsigned long) t,
-						nanosec_rem / 1000);
-
-				for (tp = tbuf; tp < tbuf + tlen; tp++)
-					emit_log_char(*tp);
-				printed_len += tlen;
-			}
+	/* mark and strip a trailing newline */
+	if (textlen && text[textlen-1] == '\n') {
+		textlen--;
+		newline = true;
+	}
 
-			if (!*p)
-				break;
+	/* strip syslog prefix and extract log level or flags */
+	if (text[0] == '<' && text[1] && text[2] == '>') {
+		switch (text[1]) {
+		case '0' ... '7':
+			if (level == -1)
+				level = text[1] - '0';
+			text += 3;
+			textlen -= 3;
+			break;
+		case 'c':	/* KERN_CONT */
+			cont = true;
+		case 'd':	/* KERN_DEFAULT */
+			text += 3;
+			textlen -= 3;
+			break;
 		}
+	}
 
-		emit_log_char(*p);
-		if (*p == '\n')
-			new_text_line = 1;
+	if (buflen && (!cont || dict)) {
+		/* no continuation; flush existing buffer */
+		log_store(facility, buflevel, NULL, 0, buf, buflen);
+		printed_len += buflen;
+		buflen = 0;
+	}
+
+	if (buflen == 0) {
+		/* remember level for first message in the buffer */
+		if (level == -1)
+			buflevel = default_message_loglevel;
+		else
+			buflevel = level;
+	}
+
+	if (buflen || !newline) {
+		/* append to existing buffer, or buffer until next message */
+		if (buflen + textlen > sizeof(buf))
+			textlen = sizeof(buf) - buflen;
+		memcpy(buf + buflen, text, textlen);
+		buflen += textlen;
+	}
+
+	if (newline) {
+		/* end of line; flush buffer */
+		if (buflen) {
+			log_store(facility, buflevel,
+				  dict, dictlen, buf, buflen);
+			printed_len += buflen;
+			buflen = 0;
+		} else {
+			log_store(facility, buflevel,
+				  dict, dictlen, text, textlen);
+			printed_len += textlen;
+		}
 	}
 
 	/*
-	 * Try to acquire and then immediately release the
-	 * console semaphore. The release will do all the
-	 * actual magic (print out buffers, wake up klogd,
-	 * etc). 
+	 * Try to acquire and then immediately release the console semaphore.
+	 * The release will print out buffers and wake up /dev/kmsg and syslog()
+	 * users.
 	 *
-	 * The console_trylock_for_printk() function
-	 * will release 'logbuf_lock' regardless of whether it
-	 * actually gets the semaphore or not.
+	 * The console_trylock_for_printk() function will release 'logbuf_lock'
+	 * regardless of whether it actually gets the console semaphore or not.
 	 */
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
@@ -974,12 +1358,73 @@ out_restore_irqs:
 
 	return printed_len;
 }
-EXPORT_SYMBOL(printk);
+EXPORT_SYMBOL(vprintk_emit);
+
+asmlinkage int vprintk(const char *fmt, va_list args)
+{
+	return vprintk_emit(0, -1, NULL, 0, fmt, args);
+}
 EXPORT_SYMBOL(vprintk);
 
+asmlinkage int printk_emit(int facility, int level,
+			   const char *dict, size_t dictlen,
+			   const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	r = vprintk_emit(facility, level, dict, dictlen, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(printk_emit);
+
+/**
+ * printk - print a kernel message
+ * @fmt: format string
+ *
+ * This is printk(). It can be called from any context. We want it to work.
+ *
+ * We try to grab the console_lock. If we succeed, it's easy - we log the
+ * output and call the console drivers.  If we fail to get the semaphore, we
+ * place the output into the log buffer and return. The current holder of
+ * the console_sem will notice the new output in console_unlock(); and will
+ * send it to the consoles before releasing the lock.
+ *
+ * One effect of this deferred printing is that code which calls printk() and
+ * then changes console_loglevel may break. This is because console_loglevel
+ * is inspected when the actual printing occurs.
+ *
+ * See also:
+ * printf(3)
+ *
+ * See the vsnprintf() documentation for format string extensions over C99.
+ */
+asmlinkage int printk(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+#ifdef CONFIG_KGDB_KDB
+	if (unlikely(kdb_trap_printk)) {
+		va_start(args, fmt);
+		r = vkdb_printf(fmt, args);
+		va_end(args);
+		return r;
+	}
+#endif
+	va_start(args, fmt);
+	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(printk);
 #else
 
-static void call_console_drivers(unsigned start, unsigned end)
+static void call_console_drivers(int level, const char *text, size_t len)
 {
 }
 
@@ -1217,7 +1662,7 @@ int is_console_locked(void)
 }
 
 /*
- * Delayed printk facility, for scheduler-internal messages:
+ * Delayed printk version, for scheduler-internal messages:
  */
 #define PRINTK_BUF_SIZE		512
 
@@ -1253,6 +1698,10 @@ void wake_up_klogd(void)
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
 }
 
+/* the next printk record to write to the console */
+static u64 console_seq;
+static u32 console_idx;
+
 /**
  * console_unlock - unlock the console system
  *
@@ -1263,15 +1712,16 @@ void wake_up_klogd(void)
  * by printk().  If this is the case, console_unlock(); emits
  * the output prior to releasing the lock.
  *
- * If there is output waiting for klogd, we wake it up.
+ * If there is output waiting, we wake it /dev/kmsg and syslog() users.
  *
  * console_unlock(); may be called from any context.
  */
 void console_unlock(void)
 {
+	static u64 seen_seq;
 	unsigned long flags;
-	unsigned _con_start, _log_end;
-	unsigned wake_klogd = 0, retry = 0;
+	bool wake_klogd = false;
+	bool retry;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -1281,17 +1731,41 @@ void console_unlock(void)
 	console_may_schedule = 0;
 
 again:
-	for ( ; ; ) {
+	for (;;) {
+		struct log *msg;
+		static char text[LOG_LINE_MAX];
+		size_t len;
+		int level;
+
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		wake_klogd |= log_start - log_end;
-		if (con_start == log_end)
-			break;			/* Nothing to print */
-		_con_start = con_start;
-		_log_end = log_end;
-		con_start = log_end;		/* Flush */
+		if (seen_seq != log_next_seq) {
+			wake_klogd = true;
+			seen_seq = log_next_seq;
+		}
+
+		if (console_seq < log_first_seq) {
+			/* messages are gone, move to first one */
+			console_seq = log_first_seq;
+			console_idx = log_first_idx;
+		}
+
+		if (console_seq == log_next_seq)
+			break;
+
+		msg = log_from_idx(console_idx);
+		level = msg->level & 7;
+		len = msg->text_len;
+		if (len+1 >= sizeof(text))
+			len = sizeof(text)-1;
+		memcpy(text, log_text(msg), len);
+		text[len++] = '\n';
+
+		console_idx = log_next(console_idx);
+		console_seq++;
 		raw_spin_unlock(&logbuf_lock);
+
 		stop_critical_timings();	/* don't trace print latency */
-		call_console_drivers(_con_start, _log_end);
+		call_console_drivers(level, text, len);
 		start_critical_timings();
 		local_irq_restore(flags);
 	}
@@ -1312,8 +1786,7 @@ again:
 	 * flush, no worries.
 	 */
 	raw_spin_lock(&logbuf_lock);
-	if (con_start != log_end)
-		retry = 1;
+	retry = console_seq != log_next_seq;
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 	if (retry && console_trylock())
@@ -1549,7 +2022,8 @@ void register_console(struct console *ne
 		 * for us.
 		 */
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		con_start = log_start;
+		console_seq = syslog_seq;
+		console_idx = syslog_idx;
 		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
@@ -1758,6 +2232,9 @@ int kmsg_dump_unregister(struct kmsg_dum
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
 
+static bool always_kmsg_dump;
+module_param_named(always_kmsg_dump, always_kmsg_dump, bool, S_IRUGO | S_IWUSR);
+
 /**
  * kmsg_dump - dump kernel log to kernel message dumpers.
  * @reason: the reason (oops, panic etc) for dumping
@@ -1767,8 +2244,7 @@ EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
  */
 void kmsg_dump(enum kmsg_dump_reason reason)
 {
-	unsigned long end;
-	unsigned chars;
+	u64 idx;
 	struct kmsg_dumper *dumper;
 	const char *s1, *s2;
 	unsigned long l1, l2;
@@ -1780,24 +2256,27 @@ void kmsg_dump(enum kmsg_dump_reason rea
 	/* Theoretically, the log could move on after we do this, but
 	   there's not a lot we can do about that. The new messages
 	   will overwrite the start of what we dump. */
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	end = log_end & LOG_BUF_MASK;
-	chars = logged_chars;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (chars > end) {
-		s1 = log_buf + log_buf_len - chars + end;
-		l1 = chars - end;
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	if (syslog_seq < log_first_seq)
+		idx = syslog_idx;
+	else
+		idx = log_first_idx;
+
+	if (idx > log_next_idx) {
+		s1 = log_buf;
+		l1 = log_next_idx;
 
-		s2 = log_buf;
-		l2 = end;
+		s2 = log_buf + idx;
+		l2 = log_buf_len - idx;
 	} else {
 		s1 = "";
 		l1 = 0;
 
-		s2 = log_buf + end - chars;
-		l2 = chars;
+		s2 = log_buf + idx;
+		l2 = log_next_idx - idx;
 	}
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(dumper, &dump_list, list)


