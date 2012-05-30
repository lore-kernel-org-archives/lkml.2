Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2E3LaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:30:16 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61154 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2E3LaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:30:13 -0400
Message-ID: <1338377365.902.3.camel@mop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Kay Sievers <kay@vrfy.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Date: Wed, 30 May 2012 13:29:25 +0200
In-Reply-To: <CAPXgP12wBzSoH-2PQeKxTbcDCKyjWdBVVz6scA7bpWxoSut7ew@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <20120526111143.GA32304@lizard>
	 <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
	 <1338307620.886.21.camel@mop>
	 <3908561D78D1C84285E8C5FCA982C28F192F5F26@ORSMSX104.amr.corp.intel.com>
	 <CAPXgP12wBzSoH-2PQeKxTbcDCKyjWdBVVz6scA7bpWxoSut7ew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17)
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 19:22 +0200, Kay Sievers wrote:
> On Tue, May 29, 2012 at 7:11 PM, Luck, Tony <tony.luck@intel.com> wrote:
> > +/*
> > + * Fill the provided buffer with as many of the the *youngest* kmsg records
> > + * that fit into it. Repeated calls will fill the buffer with the next block
> > + * of older records, not including the former ones. A return value of FALSE
> > + * indicate that all records are read, including the oldest one.
> > + */
> >
> > I confess to not reading all of this ... but does this handle the pstore/OOPS
> > case? We'll use this call to pull as many records as will fit in the pstore
> > error record ... but almost certainly won't pull all of the console log, so
> > we won't see the FALSE return.
> 
> The loop in pstore gets the newest messages first, then another chunk
> of the older messages with every call; pstore stops to iterate when
> the defined limit it wants to store is reached, or when no messages
> are available anymore.
> 
> > The system keeps on running.
> >
> > Now another OOPS happens and pstore wants to grab the new "youngest" records,
> > it doesn't want to continue stepping to older records from the place it got
> > to on the first OOPS.  Will that work?
> 
> A new oops will init the iterator again, so it will start at the end
> with the new messages that happened in the meantime.
> 
> The iterator is only valid while used from dump(), it will return an
> error if used outside of it.
> 
> The logic *should* work; at least it should be easy to make it work if
> it doesn't. :)

Updated patch with proper kerneldoc headers, to clarify the iterator's
interface and behavior.

Tony, could you possibly give it a try with your pstore dumper, if it
behaves as expected, or what we need to fix?

Thanks,
Kay

---
 arch/powerpc/platforms/pseries/nvram.c     |   61 -------
 arch/x86/platform/mrst/early_printk_mrst.c |   13 -
 drivers/mtd/mtdoops.c                      |   22 --
 fs/pstore/platform.c                       |   34 +---
 include/linux/kmsg_dump.h                  |   45 ++++-
 kernel/printk.c                            |  222 +++++++++++++++++++++++++----
 6 files changed, 259 insertions(+), 138 deletions(-)

--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -68,9 +68,7 @@ static const char *pseries_nvram_os_part
 };
 
 static void oops_to_nvram(struct kmsg_dumper *dumper,
-		enum kmsg_dump_reason reason,
-		const char *old_msgs, unsigned long old_len,
-		const char *new_msgs, unsigned long new_len);
+			  enum kmsg_dump_reason reason);
 
 static struct kmsg_dumper nvram_kmsg_dumper = {
 	.dump = oops_to_nvram
@@ -504,28 +502,6 @@ int __init pSeries_nvram_init(void)
 }
 
 /*
- * Try to capture the last capture_len bytes of the printk buffer.  Return
- * the amount actually captured.
- */
-static size_t capture_last_msgs(const char *old_msgs, size_t old_len,
-				const char *new_msgs, size_t new_len,
-				char *captured, size_t capture_len)
-{
-	if (new_len >= capture_len) {
-		memcpy(captured, new_msgs + (new_len - capture_len),
-								capture_len);
-		return capture_len;
-	} else {
-		/* Grab the end of old_msgs. */
-		size_t old_tail_len = min(old_len, capture_len - new_len);
-		memcpy(captured, old_msgs + (old_len - old_tail_len),
-								old_tail_len);
-		memcpy(captured + old_tail_len, new_msgs, new_len);
-		return old_tail_len + new_len;
-	}
-}
-
-/*
  * Are we using the ibm,rtas-log for oops/panic reports?  And if so,
  * would logging this oops/panic overwrite an RTAS event that rtas_errd
  * hasn't had a chance to read and process?  Return 1 if so, else 0.
@@ -541,27 +517,6 @@ static int clobbering_unread_rtas_event(
 						NVRAM_RTAS_READ_TIMEOUT);
 }
 
-/* Squeeze out each line's <n> severity prefix. */
-static size_t elide_severities(char *buf, size_t len)
-{
-	char *in, *out, *buf_end = buf + len;
-	/* Assume a <n> at the very beginning marks the start of a line. */
-	int newline = 1;
-
-	in = out = buf;
-	while (in < buf_end) {
-		if (newline && in+3 <= buf_end &&
-				*in == '<' && isdigit(in[1]) && in[2] == '>') {
-			in += 3;
-			newline = 0;
-		} else {
-			newline = (*in == '\n');
-			*out++ = *in++;
-		}
-	}
-	return out - buf;
-}
-
 /* Derived from logfs_compress() */
 static int nvram_compress(const void *in, void *out, size_t inlen,
 							size_t outlen)
@@ -619,9 +574,7 @@ static int zip_oops(size_t text_len)
  * partition.  If that's too much, go back and capture uncompressed text.
  */
 static void oops_to_nvram(struct kmsg_dumper *dumper,
-		enum kmsg_dump_reason reason,
-		const char *old_msgs, unsigned long old_len,
-		const char *new_msgs, unsigned long new_len)
+			  enum kmsg_dump_reason reason)
 {
 	static unsigned int oops_count = 0;
 	static bool panicking = false;
@@ -660,14 +613,14 @@ static void oops_to_nvram(struct kmsg_du
 		return;
 
 	if (big_oops_buf) {
-		text_len = capture_last_msgs(old_msgs, old_len,
-			new_msgs, new_len, big_oops_buf, big_oops_buf_sz);
-		text_len = elide_severities(big_oops_buf, text_len);
+		kmsg_dump_get_buffer(dumper, false,
+				     big_oops_buf, big_oops_buf_sz, &text_len);
 		rc = zip_oops(text_len);
 	}
 	if (rc != 0) {
-		text_len = capture_last_msgs(old_msgs, old_len,
-				new_msgs, new_len, oops_data, oops_data_sz);
+		kmsg_dump_rewind(dumper);
+		kmsg_dump_get_buffer(dumper, true,
+				     oops_data, oops_data_sz, &text_len);
 		err_type = ERR_TYPE_KERNEL_PANIC;
 		*oops_len = (u16) text_len;
 	}
--- a/arch/x86/platform/mrst/early_printk_mrst.c
+++ b/arch/x86/platform/mrst/early_printk_mrst.c
@@ -110,19 +110,16 @@ static struct kmsg_dumper dw_dumper;
 static int dumper_registered;
 
 static void dw_kmsg_dump(struct kmsg_dumper *dumper,
-			enum kmsg_dump_reason reason,
-			const char *s1, unsigned long l1,
-			const char *s2, unsigned long l2)
+			 enum kmsg_dump_reason reason)
 {
-	int i;
+	static char line[1024];
+	size_t len;
 
 	/* When run to this, we'd better re-init the HW */
 	mrst_early_console_init();
 
-	for (i = 0; i < l1; i++)
-		early_mrst_console.write(&early_mrst_console, s1 + i, 1);
-	for (i = 0; i < l2; i++)
-		early_mrst_console.write(&early_mrst_console, s2 + i, 1);
+	while (kmsg_dump_get_line(dumper, true, line, sizeof(line), &len))
+		early_mrst_console.write(&early_mrst_console, line, len);
 }
 
 /* Set the ratio rate to 115200, 8n1, IRQ disabled */
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -304,32 +304,17 @@ static void find_next_position(struct mt
 }
 
 static void mtdoops_do_dump(struct kmsg_dumper *dumper,
-		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
-		const char *s2, unsigned long l2)
+			    enum kmsg_dump_reason reason)
 {
 	struct mtdoops_context *cxt = container_of(dumper,
 			struct mtdoops_context, dump);
-	unsigned long s1_start, s2_start;
-	unsigned long l1_cpy, l2_cpy;
-	char *dst;
-
-	if (reason != KMSG_DUMP_OOPS &&
-	    reason != KMSG_DUMP_PANIC)
-		return;
 
 	/* Only dump oopses if dump_oops is set */
 	if (reason == KMSG_DUMP_OOPS && !dump_oops)
 		return;
 
-	dst = cxt->oops_buf + MTDOOPS_HEADER_SIZE; /* Skip the header */
-	l2_cpy = min(l2, record_size - MTDOOPS_HEADER_SIZE);
-	l1_cpy = min(l1, record_size - MTDOOPS_HEADER_SIZE - l2_cpy);
-
-	s2_start = l2 - l2_cpy;
-	s1_start = l1 - l1_cpy;
-
-	memcpy(dst, s1 + s1_start, l1_cpy);
-	memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
+	kmsg_dump_get_buffer(dumper, true, cxt->oops_buf + MTDOOPS_HEADER_SIZE,
+			     record_size - MTDOOPS_HEADER_SIZE, NULL);
 
 	/* Panics must be written immediately */
 	if (reason != KMSG_DUMP_OOPS)
@@ -375,6 +360,7 @@ static void mtdoops_notify_add(struct mt
 		return;
 	}
 
+	cxt->dump.max_reason = KMSG_DUMP_OOPS;
 	cxt->dump.dump = mtdoops_do_dump;
 	err = kmsg_dump_register(&cxt->dump);
 	if (err) {
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -94,20 +94,15 @@ static const char *get_reason_str(enum k
  * as we can from the end of the buffer.
  */
 static void pstore_dump(struct kmsg_dumper *dumper,
-	    enum kmsg_dump_reason reason,
-	    const char *s1, unsigned long l1,
-	    const char *s2, unsigned long l2)
+			enum kmsg_dump_reason reason)
 {
-	unsigned long	s1_start, s2_start;
-	unsigned long	l1_cpy, l2_cpy;
-	unsigned long	size, total = 0;
-	char		*dst;
+	unsigned long	total = 0;
 	const char	*why;
 	u64		id;
-	int		hsize, ret;
 	unsigned int	part = 1;
 	unsigned long	flags = 0;
 	int		is_locked = 0;
+	int		ret;
 
 	why = get_reason_str(reason);
 
@@ -119,30 +114,25 @@ static void pstore_dump(struct kmsg_dump
 		spin_lock_irqsave(&psinfo->buf_lock, flags);
 	oopscount++;
 	while (total < kmsg_bytes) {
+		char *dst;
+		unsigned long size;
+		int hsize;
+		size_t len;
+
 		dst = psinfo->buf;
 		hsize = sprintf(dst, "%s#%d Part%d\n", why, oopscount, part);
 		size = psinfo->bufsize - hsize;
 		dst += hsize;
 
-		l2_cpy = min(l2, size);
-		l1_cpy = min(l1, size - l2_cpy);
-
-		if (l1_cpy + l2_cpy == 0)
+		if (!kmsg_dump_get_buffer(dumper, true, dst, size, &len))
 			break;
 
-		s2_start = l2 - l2_cpy;
-		s1_start = l1 - l1_cpy;
-
-		memcpy(dst, s1 + s1_start, l1_cpy);
-		memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
-
 		ret = psinfo->write(PSTORE_TYPE_DMESG, reason, &id, part,
-				   hsize + l1_cpy + l2_cpy, psinfo);
+				    hsize + len, psinfo);
 		if (ret == 0 && reason == KMSG_DUMP_OOPS && pstore_is_mounted())
 			pstore_new_entry = 1;
-		l1 -= l1_cpy;
-		l2 -= l2_cpy;
-		total += l1_cpy + l2_cpy;
+
+		total += hsize + len;
 		part++;
 	}
 	if (in_nmi()) {
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -21,6 +21,7 @@
  * is passed to the kernel.
  */
 enum kmsg_dump_reason {
+	KMSG_DUMP_UNDEF,
 	KMSG_DUMP_PANIC,
 	KMSG_DUMP_OOPS,
 	KMSG_DUMP_EMERG,
@@ -31,23 +32,37 @@ enum kmsg_dump_reason {
 
 /**
  * struct kmsg_dumper - kernel crash message dumper structure
- * @dump:	The callback which gets called on crashes. The buffer is passed
- * 		as two sections, where s1 (length l1) contains the older
- * 		messages and s2 (length l2) contains the newer.
  * @list:	Entry in the dumper list (private)
+ * @dump:	Call into dumping code which will retrieve the data with
+ * 		through the record iterator
+ * @max_reason:	filter for highest reason number that should be dumped
  * @registered:	Flag that specifies if this is already registered
  */
 struct kmsg_dumper {
-	void (*dump)(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
-			const char *s1, unsigned long l1,
-			const char *s2, unsigned long l2);
 	struct list_head list;
-	int registered;
+	void (*dump)(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason);
+	enum kmsg_dump_reason max_reason;
+	bool active;
+	bool registered;
+
+	/* private state of the kmsg iterator */
+	u32 cur_idx;
+	u32 next_idx;
+	u64 cur_seq;
+	u64 next_seq;
 };
 
 #ifdef CONFIG_PRINTK
 void kmsg_dump(enum kmsg_dump_reason reason);
 
+bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
+			char *line, size_t size, size_t *len);
+
+bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
+			  char *buf, size_t size, size_t *len);
+
+void kmsg_dump_rewind(struct kmsg_dumper *dumper);
+
 int kmsg_dump_register(struct kmsg_dumper *dumper);
 
 int kmsg_dump_unregister(struct kmsg_dumper *dumper);
@@ -56,6 +71,22 @@ static inline void kmsg_dump(enum kmsg_d
 {
 }
 
+bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
+			  const char *line, size_t size, size_t *len)
+{
+	return false;
+}
+
+bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
+			    char *buf, size_t size, size_t *len)
+{
+	return false;
+}
+
+void kmsg_dump_rewind(struct kmsg_dumper *dumper)
+{
+}
+
 static inline int kmsg_dump_register(struct kmsg_dumper *dumper)
 {
 	return -EINVAL;
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -909,7 +909,7 @@ static int syslog_print_all(char __user
 		/*
 		 * Find first record that fits, including all following records,
 		 * into the user-provided buffer for this dump.
-		*/
+		 */
 		seq = clear_seq;
 		idx = clear_idx;
 		while (seq < log_next_seq) {
@@ -919,6 +919,8 @@ static int syslog_print_all(char __user
 			idx = log_next(idx);
 			seq++;
 		}
+
+		/* move first record forward until length fits into the buffer */
 		seq = clear_seq;
 		idx = clear_idx;
 		while (len > size && seq < log_next_seq) {
@@ -929,7 +931,7 @@ static int syslog_print_all(char __user
 			seq++;
 		}
 
-		/* last message in this dump */
+		/* last message fitting into this dump */
 		next_seq = log_next_seq;
 
 		len = 0;
@@ -2300,48 +2302,210 @@ module_param_named(always_kmsg_dump, alw
  * kmsg_dump - dump kernel log to kernel message dumpers.
  * @reason: the reason (oops, panic etc) for dumping
  *
- * Iterate through each of the dump devices and call the oops/panic
- * callbacks with the log buffer.
+ * Call each of the registered dumper's dump() callback, which can
+ * retrieve the kmsg records with kmsg_dump_get_line() or
+ * kmsg_dump_get_buffer().
  */
 void kmsg_dump(enum kmsg_dump_reason reason)
 {
-	u64 idx;
 	struct kmsg_dumper *dumper;
-	const char *s1, *s2;
-	unsigned long l1, l2;
 	unsigned long flags;
 
 	if ((reason > KMSG_DUMP_OOPS) && !always_kmsg_dump)
 		return;
 
-	/* Theoretically, the log could move on after we do this, but
-	   there's not a lot we can do about that. The new messages
-	   will overwrite the start of what we dump. */
+	rcu_read_lock();
+	list_for_each_entry_rcu(dumper, &dump_list, list) {
+		if (dumper->max_reason && reason > dumper->max_reason)
+			continue;
+
+		/* initialize iterator with data about the stored records */
+		dumper->active = true;
+
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		dumper->cur_seq = clear_seq;
+		dumper->cur_idx = clear_idx;
+		dumper->next_seq = log_next_seq;
+		dumper->next_idx = log_next_idx;
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
+		/* invoke dumper which will iterate over records */
+		dumper->dump(dumper, reason);
+
+		/* reset iterator */
+		dumper->active = false;
+	}
+	rcu_read_unlock();
+}
+
+/**
+ * kmsg_dump_get_line - retrieve one kmsg log line
+ * @dumper: registered kmsg dumper
+ * @syslog: include the "<4>" prefixes
+ * @line: buffer to copy the line to
+ * @size: maximum size of the buffer
+ * @len: length of line placed into buffer
+ *
+ * Start at the beginning of the kmsg buffer, with the oldest kmsg
+ * record, and copy one record into the provided buffer.
+ *
+ * Consecutive calls will return the next available record moving
+ * towards the end of the buffer with the youngest messages.
+ *
+ * A return value of FALSE indicate that there are no more records to
+ * read.
+ */
+bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
+			char *line, size_t size, size_t *len)
+{
+	unsigned long flags;
+	struct log *msg;
+	size_t l = 0;
+	bool ret = false;
+
+	if (!dumper->active)
+		goto out;
 
 	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	if (syslog_seq < log_first_seq)
-		idx = syslog_idx;
-	else
-		idx = log_first_idx;
-
-	if (idx > log_next_idx) {
-		s1 = log_buf;
-		l1 = log_next_idx;
+	if (dumper->cur_seq < log_first_seq) {
+		/* messages are gone, move to first available one */
+		dumper->cur_seq = log_first_seq;
+		dumper->cur_idx = log_first_idx;
+	}
 
-		s2 = log_buf + idx;
-		l2 = log_buf_len - idx;
-	} else {
-		s1 = "";
-		l1 = 0;
+	/* last entry */
+	if (dumper->cur_seq >= log_next_seq) {
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		goto out;
+	}
 
-		s2 = log_buf + idx;
-		l2 = log_next_idx - idx;
+	msg = log_from_idx(dumper->cur_idx);
+	l = msg_print_text(msg, syslog,
+			      line, size);
+
+	dumper->cur_idx = log_next(dumper->cur_idx);
+	dumper->cur_seq++;
+	ret = true;
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+out:
+	if (len)
+		*len = l;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kmsg_dump_get_line);
+
+/**
+ * kmsg_dump_get_buffer - copy kmsg log lines
+ * @dumper: registered kmsg dumper
+ * @syslog: include the "<4>" prefixes
+ * @line: buffer to copy the line to
+ * @size: maximum size of the buffer
+ * @len: length of line placed into buffer
+ *
+ * Start at the end of the kmsg buffer and fill the provided buffer
+ * with as many of the the *youngest* kmsg records that fit into it.
+ * If the buffer is large enough, all available kmsg records will be
+ * copied with a single call.
+ *
+ * Consecutive calls will fill the buffer with the next block of
+ * available older records, not including the earlier retrieved ones.
+ *
+ * A return value of FALSE indicate that there are no more records to
+ * read.
+ */
+bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
+			  char *buf, size_t size, size_t *len)
+{
+	unsigned long flags;
+	u64 seq;
+	u32 idx;
+	u64 next_seq;
+	u32 next_idx;
+	size_t l = 0;
+	bool ret = false;
+
+	if (!dumper->active)
+		goto out;
+
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	if (dumper->cur_seq < log_first_seq) {
+		/* messages are gone, move to first available one */
+		dumper->cur_seq = log_first_seq;
+		dumper->cur_idx = log_first_idx;
+	}
+
+	/* last entry */
+	if (dumper->cur_seq >= dumper->next_seq) {
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		goto out;
+	}
+
+	/* calculate length of entire buffer */
+	seq = dumper->cur_seq;
+	idx = dumper->cur_idx;
+	while (seq < dumper->next_seq) {
+		struct log *msg = log_from_idx(idx);
+
+		l += msg_print_text(msg, true, NULL, 0);
+		idx = log_next(idx);
+		seq++;
+	}
+
+	/* move first record forward until length fits into the buffer */
+	seq = dumper->cur_seq;
+	idx = dumper->cur_idx;
+	while (l > size && seq < dumper->next_seq) {
+		struct log *msg = log_from_idx(idx);
+
+		l -= msg_print_text(msg, true, NULL, 0);
+		idx = log_next(idx);
+		seq++;
+	}
+
+	/* last message in next interation */
+	next_seq = seq;
+	next_idx = idx;
+
+	l = 0;
+	while (seq < dumper->next_seq) {
+		struct log *msg = log_from_idx(idx);
+
+		l += msg_print_text(msg, syslog,
+				    buf + l, size - l);
+
+		idx = log_next(idx);
+		seq++;
 	}
+
+	dumper->next_seq = next_seq;
+	dumper->next_idx = next_idx;
+	ret = true;
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+out:
+	if (len)
+		*len = l;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kmsg_dump_get_buffer);
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(dumper, &dump_list, list)
-		dumper->dump(dumper, reason, s1, l1, s2, l2);
-	rcu_read_unlock();
+/**
+ * kmsg_dump_rewind - reset the interator
+ * @dumper: registered kmsg dumper
+ *
+ * Reset the dumper's iterator so that kmsg_dump_get_line() and
+ * kmsg_dump_get_buffer() can be called again and used multiple
+ * times within the same dumper.dump() callback.
+ */
+void kmsg_dump_rewind(struct kmsg_dumper *dumper)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	dumper->cur_seq = clear_seq;
+	dumper->cur_idx = clear_idx;
+	dumper->next_seq = log_next_seq;
+	dumper->next_idx = log_next_idx;
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
+EXPORT_SYMBOL_GPL(kmsg_dump_rewind);
 #endif


