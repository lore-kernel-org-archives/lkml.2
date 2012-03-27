Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab2C0Izf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:55:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46775 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab2C0Ize (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:55:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F718007.4000401@jp.fujitsu.com>
Date: Tue, 27 Mar 2012 17:53:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>
Subject: [RFC] [PATCH 1/2] binary stream format for /proc/stat
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides another format of /proc/stat for showing data in binary and
compress sequence of Zeros to some extent.

Any other idea of formats ?
==
>From dea9521e84701631e718884d40b5c96cdcd62d7d Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 27 Mar 2012 13:40:54 +0900
Subject: [PATCH 1/2] proc: seq_file add binary stream support

/proc/stat shows all data in ascii format and it's easily readable.
But considering a program which reads /proc/stat periodically, translations
of ascii <-> binary happens a few times.

  1. binrary -> ascii at showing seq_file
  2. ascii -> binary for handling in the program.

This patch adds binstream format support in seq_file. In this format,
all data will be shown after a header

	uint32_t	type	# type of data, ZERO, STRING, ULLONG, LLONG.
	uint32_t	len	# length of string or repeat of type.

If type = ULLONG and len=8, it means an array of 8 uulong values.
If type = ZERO and len=4, it means 4 zeros are outputted.

For example, a sequence
	cpu 123 456 789 0 0 0 0 111
        cpu1
will be shows as
	offset      header     values
	0x00        STRING,3,  "cpu"	# aligned to 8bytes.
	0x10        UULONG,3,  123, 456, 789 # array of uulong.
	0x30        ZERO  ,4            # zero has no data.
	0x38        UULONG,1   111
        0x48	    STRING,4   "cpu0"

(ZERO is for representing tons of 0s in /proc/stat...)

The file provider just needs to call seq_set_binstream(). Once
seq_set_binstream() is called, following seq_put_decimal_(u)ll,
seq_puts, seq_put_nl will generate appropriate outputs.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/seq_file.c            |  143 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/seq_file.h |   36 ++++++++++++
 2 files changed, 179 insertions(+), 0 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 0cbd049..8a0e057 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -349,6 +349,114 @@ int seq_release(struct inode *inode, struct file *file)
 }
 EXPORT_SYMBOL(seq_release);
 
+
+static bool seq_binstream_continued(struct seq_file *m, int type)
+{
+	return m->binstream_head && m->binstream_head->type == type;
+}
+
+
+static int seq_binstream_align(struct seq_file *m)
+{
+	size_t pos;
+
+	pos = m->count;
+	m->count = ALIGN(m->count, SEQ_BINSTREAM_ALIGNMENT);
+	if (unlikely(m->count >=  m->size)) {
+		seq_set_overflow(m);
+		return -1;
+	}
+	while (pos != m->count) {
+		*(m->buf + pos) = 0;
+		++pos;
+	}
+	return 0;
+}
+
+static int seq_put_binstream_head(struct seq_file *m, int type)
+{
+	struct seq_binstream_head *head;
+	int payload = 0;
+
+	m->binstream_head = NULL;
+
+	if (seq_binstream_align(m))
+		return -1;
+
+	if (type == SEQ_BINSTREAM_ULLONG || type == SEQ_BINSTREAM_LLONG)
+		payload = 8;
+
+	if (m->count + sizeof(*head) + payload >= m->size) {
+		seq_set_overflow(m);
+		return -1;
+	}
+	head = (struct seq_binstream_head *)(m->buf + m->count);
+	head->type = type;
+	head->len = 1;
+	m->binstream_head = head;
+	m->count += sizeof(*head);
+	return 0;
+}
+
+static int seq_binstream_str_prepare(struct seq_file *m)
+{
+	if (!m->binstream)
+		return 0;
+	return seq_put_binstream_head(m, SEQ_BINSTREAM_STRING);
+}
+
+static void seq_binstream_str_end(struct seq_file *m, int len)
+{
+	if (m->binstream_head)
+		m->binstream_head->len = len;
+}
+
+static int seq_put_binstream_zero(struct seq_file *m)
+{
+	if (seq_binstream_continued(m, SEQ_BINSTREAM_ZERO)) {
+		m->binstream_head->len += 1;
+		return 0;
+	}
+	return seq_put_binstream_head(m, SEQ_BINSTREAM_ZERO);
+}
+
+static int seq_put_binstream_num(struct seq_file *m, int type,
+			unsigned long long val)
+{
+	if (!val)
+		return seq_put_binstream_zero(m);
+
+	if (seq_binstream_continued(m, type)) {
+		if (m->count + sizeof(val) >= m->size)
+			goto overflow;
+		m->binstream_head->len += 1;
+		*(unsigned long long *)(m->buf + m->count) = val;
+		m->count += sizeof(unsigned long long);
+		return 0;
+	}
+
+	if (seq_put_binstream_head(m, type))
+		goto overflow;
+
+	*(unsigned long long *)(m->buf + m->count) = val;
+	m->count += sizeof(val);
+	return 0;
+overflow:
+	m->binstream_head = NULL;
+	seq_set_overflow(m);
+	return -1;
+}
+
+static int seq_put_binstream_ull(struct seq_file *m, unsigned long long val)
+{
+	return seq_put_binstream_num(m, SEQ_BINSTREAM_ULLONG, val);
+}
+
+static int seq_put_binstream_ll(struct seq_file *m, unsigned long long val)
+{
+	return seq_put_binstream_num(m, SEQ_BINSTREAM_LLONG, val);
+}
+
 /**
  *	seq_escape -	print string into buffer, escaping some characters
  *	@m:	target buffer
@@ -390,12 +498,16 @@ int seq_printf(struct seq_file *m, const char *f, ...)
 	va_list args;
 	int len;
 
+	if (seq_binstream_str_prepare(m))
+		return -1;
+
 	if (m->count < m->size) {
 		va_start(args, f);
 		len = vsnprintf(m->buf + m->count, m->size - m->count, f, args);
 		va_end(args);
 		if (m->count + len < m->size) {
 			m->count += len;
+			seq_binstream_str_end(m, len);
 			return 0;
 		}
 	}
@@ -639,8 +751,12 @@ EXPORT_SYMBOL(seq_open_private);
 
 int seq_putc(struct seq_file *m, char c)
 {
+	if (seq_binstream_str_prepare(m))
+		return -1;
+
 	if (m->count < m->size) {
 		m->buf[m->count++] = c;
+		seq_binstream_str_end(m, 1);
 		return 0;
 	}
 	return -1;
@@ -650,9 +766,14 @@ EXPORT_SYMBOL(seq_putc);
 int seq_puts(struct seq_file *m, const char *s)
 {
 	int len = strlen(s);
+
+	if (seq_binstream_str_prepare(m))
+		return -1;
+
 	if (m->count + len < m->size) {
 		memcpy(m->buf + m->count, s, len);
 		m->count += len;
+		seq_binstream_str_end(m, len);
 		return 0;
 	}
 	seq_set_overflow(m);
@@ -672,6 +793,9 @@ int seq_put_decimal_ull(struct seq_file *m, char delimiter,
 {
 	int len;
 
+	if (m->binstream)
+		return seq_put_binstream_ull(m, num);
+
 	if (m->count + 2 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
@@ -697,6 +821,9 @@ EXPORT_SYMBOL(seq_put_decimal_ull);
 int seq_put_decimal_ll(struct seq_file *m, char delimiter,
 			long long num)
 {
+	if (m->binstream)
+		return seq_put_binstream_ll(m, num);
+
 	if (num < 0) {
 		if (m->count + 3 >= m->size) {
 			seq_set_overflow(m);
@@ -732,6 +859,22 @@ int seq_write(struct seq_file *seq, const void *data, size_t len)
 }
 EXPORT_SYMBOL(seq_write);
 
+void seq_set_binstream(struct seq_file *m)
+{
+	m->binstream = true;
+	return;
+}
+EXPORT_SYMBOL(seq_set_binstream);
+
+int seq_put_nl(struct seq_file *m)
+{
+	if (!m->binstream)
+		return seq_putc(m, '\n');
+	return 0;
+}
+EXPORT_SYMBOL(seq_put_nl);
+
+
 struct list_head *seq_list_start(struct list_head *head, loff_t pos)
 {
 	struct list_head *lh;
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index fc61854..aeea9c4 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -8,6 +8,36 @@
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
 
+/*
+ * In binstream format, all data will follow after seq_binstream_head.
+ * The 1st 4bytes of head shows the type of information, the next 4bytes shows
+ * the length of data including the header.
+ * All seq_binstream_heads will be aligned to 8bytes. So, if the string data
+ * is not aligned to 8bytes, padding will be added, they'll be filled with 0.
+ */
+enum {
+	SEQ_BINSTREAM_ZERO   = 1,  /* represents the number of 0 */
+	SEQ_BINSTREAM_STRING = 2,
+	SEQ_BINSTREAM_LLONG  = 3,
+	SEQ_BINSTREAM_ULLONG = 4,
+};
+#define SEQ_BINSTREAM_ALIGNMENT		(8)
+
+/*
+ * if type==string, len means the length of string. If not, len represents
+ * the number of values represented by this head.
+ *
+ * type=string,len=10 ....  a string will follow this. its length is 10bytes.
+ * type=ZERO,len=10  ...... means 0 repeated 10times.
+ * type=LLONG, len=10, .... means LLONG repeated 10 times.
+ *                          10 values will follow this header.
+ */
+struct seq_binstream_head {
+	uint32_t type;
+	uint32_t len;/* length of string or the number of repeats of type*/
+};
+
+#ifdef __KERNEL__
 struct seq_operations;
 struct file;
 struct path;
@@ -25,6 +55,8 @@ struct seq_file {
 	struct mutex lock;
 	const struct seq_operations *op;
 	int poll_event;
+	bool binstream;
+	struct seq_binstream_head *binstream_head;
 	void *private;
 };
 
@@ -127,6 +159,9 @@ int seq_put_decimal_ull(struct seq_file *m, char delimiter,
 int seq_put_decimal_ll(struct seq_file *m, char delimiter,
 			long long num);
 
+void seq_set_binstream(struct seq_file *m);
+int seq_put_nl(struct seq_file *m);
+
 #define SEQ_START_TOKEN ((void *)1)
 /*
  * Helpers for iteration over list_head-s in seq_files
@@ -157,4 +192,5 @@ extern struct hlist_node *seq_hlist_start_head_rcu(struct hlist_head *head,
 extern struct hlist_node *seq_hlist_next_rcu(void *v,
 						   struct hlist_head *head,
 						   loff_t *ppos);
+#endif /* __KERNEL__ */
 #endif
-- 
1.7.4.1


