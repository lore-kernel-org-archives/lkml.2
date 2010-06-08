Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0FHGpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 02:45:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:59436 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab0FHGpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 02:45:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,383,1272870000"; 
   d="scan'208";a="574271073"
Subject: [RFC] kfifo writer side lock-less support
From: Huang Ying <ying.huang@intel.com>
To: Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 14:45:13 +0800
Message-ID: <1275979513.3444.676.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add lock-less support for kfifo writer side amongst
different contexts on one CPU, such as NMI, IRQ, soft_irq, process,
etc. This makes kfifo can be used to implement per-CPU lock-less data
structure.

The different contexts on one CPU have some kind of preemption
priority as follow:

process -> soft_irq -> IRQ -> NMI

Where preemption priority increases from left to right. That is, the
right side context can preempt left side context, but not in the
reverse direction, that means the right side context will run to the
end before return to the left side context. The lock-less algorithm
used in the patch take advantage of this.

The algorithm works in reserve/commit style, where "reserve" only
allocate the space, while "commit" really makes the data into buffer,
data is prepared in between. cmpxchg is used in "reserve", this
guarantees different spaces will be allocated for different
contexts. Only the "commit" in lowest context will commit all
allocated spaces. Because all contexts preempting lowest context
between "reserve" and "commit" will run to the end, all data put into
buffer are valid.

Some idea of the lock-less algorithm in the patch comes from Steven
Rostedt's trace ring buffer implementation.

The new xxx_ptr interface and kfifo_iter makes it possible to
write/read content of kfifo in-place in addition to copying out/in.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/kfifo.h |   87 +++++++++++++++++-
 kernel/kfifo.c        |  231 ++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 305 insertions(+), 13 deletions(-)

--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -49,6 +49,7 @@ struct kfifo {
 	unsigned int size;	/* the size of the allocated buffer */
 	unsigned int in;	/* data is added at offset (in % size) */
 	unsigned int out;	/* data is extracted from off. (out % size) */
+	unsigned int reserve;	/* space is reserved at off (reserve % size) */
 };
 
 /*
@@ -60,6 +61,7 @@ struct kfifo {
 	(struct kfifo) { \
 		.size	= s, \
 		.in	= 0, \
+		.reserve = 0, \
 		.out	= 0, \
 		.buffer = b \
 	}
@@ -132,7 +134,7 @@ static inline bool kfifo_initialized(str
  */
 static inline void kfifo_reset(struct kfifo *fifo)
 {
-	fifo->in = fifo->out = 0;
+	fifo->reserve = fifo->in = fifo->out = 0;
 }
 
 /**
@@ -167,6 +169,18 @@ static inline unsigned int kfifo_len(str
 	return fifo->in - out;
 }
 
+/*
+ * returns the number of used bytes (including reserved) in the FIFO
+ */
+static inline unsigned int __kfifo_used(struct kfifo *fifo)
+{
+	register unsigned int	out;
+
+	out = fifo->out;
+	smp_rmb();
+	return fifo->reserve - out;
+}
+
 /**
  * kfifo_is_empty - returns true if the fifo is empty
  * @fifo: the fifo to be used.
@@ -182,7 +196,7 @@ static inline __must_check int kfifo_is_
  */
 static inline __must_check int kfifo_is_full(struct kfifo *fifo)
 {
-	return kfifo_len(fifo) == kfifo_size(fifo);
+	return __kfifo_used(fifo) == kfifo_size(fifo);
 }
 
 /**
@@ -191,7 +205,7 @@ static inline __must_check int kfifo_is_
  */
 static inline __must_check unsigned int kfifo_avail(struct kfifo *fifo)
 {
-	return kfifo_size(fifo) - kfifo_len(fifo);
+	return kfifo_size(fifo) - __kfifo_used(fifo);
 }
 
 /**
@@ -269,6 +283,7 @@ static inline void __kfifo_add_out(struc
 static inline void __kfifo_add_in(struct kfifo *fifo,
 				unsigned int off)
 {
+	fifo->reserve += off;
 	smp_wmb();
 	fifo->in += off;
 }
@@ -283,6 +298,15 @@ static inline unsigned int __kfifo_off(s
 }
 
 /*
+ * __kfifo_ptr internal helper function to get pointer at the position
+ * for in-place accessing
+ */
+static inline void *__kfifo_ptr(struct kfifo *fifo, unsigned int pos)
+{
+	return fifo->buffer + __kfifo_off(fifo, pos);
+}
+
+/*
  * __kfifo_peek_n internal helper function for determinate the length of
  * the next record in the fifo
  */
@@ -607,9 +631,64 @@ static inline void kfifo_skip_rec(struct
 static inline __must_check unsigned int kfifo_avail_rec(struct kfifo *fifo,
 	unsigned int recsize)
 {
-	unsigned int l = kfifo_size(fifo) - kfifo_len(fifo);
+	unsigned int l = kfifo_size(fifo) - __kfifo_used(fifo);
 
 	return (l > recsize) ? l - recsize : 0;
 }
 
+extern __must_check int kfifo_reserve(struct kfifo *fifo,
+	unsigned int len, unsigned int *ppos);
+extern void kfifo_commit(struct kfifo *fifo, unsigned int pos);
+extern void kfifo_in_data(struct kfifo *fifo, const void *from,
+	unsigned int len, unsigned int off);
+extern unsigned int kfifo_ll_in(struct kfifo *fifo, const void *from,
+	unsigned int len);
+extern __must_check void *kfifo_reserve_continuous_ptr(struct kfifo *fifo,
+	unsigned int *len);
+extern void kfifo_commit_ptr(struct kfifo *fifo, void *ptr);
+
+struct kfifo_iter {
+	struct kfifo *fifo;
+	unsigned int pos;
+};
+
+/**
+ * kfifo_iter_init - initialize a FIFO iterator
+ * @iter: the iterator to be initialized
+ * @fifo: the fifo to be accessed
+ *
+ */
+static inline void kfifo_iter_init(struct kfifo_iter *iter, struct kfifo *fifo)
+{
+	iter->fifo = fifo;
+	iter->pos = fifo->out;
+}
+
+/**
+ * kfifo_iter_advance - advances the position of iterator
+ * @iter: the iterator to be used
+ * @adv: the bytes to advance
+ *
+ * This function advances the position of iterator by @adv bytes,
+ * usually goes to the position of the next record.
+ */
+static inline void kfifo_iter_advance(struct kfifo_iter *iter, unsigned int adv)
+{
+	iter->pos += adv;
+}
+
+/**
+ * kfifo_iter_get_ptr - gets the pointer to the current position of iterator
+ * @iter: the iterator to be used
+ *
+ * This function returns the pointer to the current position of
+ * iterator. If the iterator is at the end of FIFO, NULL is
+ * returned. This is used to access the data/records in FIFO in-place.
+ */
+static inline void *kfifo_iter_get_ptr(struct kfifo_iter *iter)
+{
+	if (iter->pos == iter->fifo->in)
+		return NULL;
+	return __kfifo_ptr(iter->fifo, iter->pos);
+}
 #endif
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -116,8 +116,18 @@ void kfifo_skip(struct kfifo *fifo, unsi
 }
 EXPORT_SYMBOL(kfifo_skip);
 
-static inline void __kfifo_in_data(struct kfifo *fifo,
-		const void *from, unsigned int len, unsigned int off)
+/**
+ * kfifo_in_data - copies some data into FIFO
+ * @fifo: the fifo to be used.
+ * @from: the data to be copied
+ * @len: length of the data to be copied
+ * @off: the offset in FIFO, to which the data is copied
+ *
+ * This function copied @len bytes from the @from buffer into the @off
+ * position of the FIFO.
+ */
+void kfifo_in_data(struct kfifo *fifo, const void *from, unsigned int len,
+	unsigned int off)
 {
 	unsigned int l;
 
@@ -128,7 +138,7 @@ static inline void __kfifo_in_data(struc
 
 	smp_mb();
 
-	off = __kfifo_off(fifo, fifo->in + off);
+	off = __kfifo_off(fifo, off);
 
 	/* first put the data starting from fifo->in to buffer end */
 	l = min(len, fifo->size - off);
@@ -137,6 +147,7 @@ static inline void __kfifo_in_data(struc
 	/* then put the rest (if any) at the beginning of the buffer */
 	memcpy(fifo->buffer, from + l, len - l);
 }
+EXPORT_SYMBOL_GPL(kfifo_in_data);
 
 static inline void __kfifo_out_data(struct kfifo *fifo,
 		void *to, unsigned int len, unsigned int off)
@@ -150,7 +161,7 @@ static inline void __kfifo_out_data(stru
 
 	smp_rmb();
 
-	off = __kfifo_off(fifo, fifo->out + off);
+	off = __kfifo_off(fifo, off);
 
 	/* first get the data from fifo->out until the end of the buffer */
 	l = min(len, fifo->size - off);
@@ -232,7 +243,7 @@ unsigned int __kfifo_in_n(struct kfifo *
 	if (kfifo_avail(fifo) < len + recsize)
 		return len + 1;
 
-	__kfifo_in_data(fifo, from, len, recsize);
+	kfifo_in_data(fifo, from, len, fifo->in + recsize);
 	return 0;
 }
 EXPORT_SYMBOL(__kfifo_in_n);
@@ -255,7 +266,7 @@ unsigned int kfifo_in(struct kfifo *fifo
 {
 	len = min(kfifo_avail(fifo), len);
 
-	__kfifo_in_data(fifo, from, len, 0);
+	kfifo_in_data(fifo, from, len, fifo->in);
 	__kfifo_add_in(fifo, len);
 	return len;
 }
@@ -274,7 +285,7 @@ unsigned int __kfifo_out_n(struct kfifo
 	if (kfifo_len(fifo) < len + recsize)
 		return len;
 
-	__kfifo_out_data(fifo, to, len, recsize);
+	__kfifo_out_data(fifo, to, len, fifo->out + recsize);
 	__kfifo_add_out(fifo, len + recsize);
 	return 0;
 }
@@ -296,7 +307,7 @@ unsigned int kfifo_out(struct kfifo *fif
 {
 	len = min(kfifo_len(fifo), len);
 
-	__kfifo_out_data(fifo, to, len, 0);
+	__kfifo_out_data(fifo, to, len, fifo->out);
 	__kfifo_add_out(fifo, len);
 
 	return len;
@@ -319,7 +330,7 @@ unsigned int kfifo_out_peek(struct kfifo
 {
 	len = min(kfifo_len(fifo), len + offset);
 
-	__kfifo_out_data(fifo, to, len, offset);
+	__kfifo_out_data(fifo, to, len, fifo->out + offset);
 	return len;
 }
 EXPORT_SYMBOL(kfifo_out_peek);
@@ -443,3 +454,205 @@ void __kfifo_skip_generic(struct kfifo *
 }
 EXPORT_SYMBOL(__kfifo_skip_generic);
 
+/**
+ * kfifo_reserve - reserves some space in the FIFO
+ * @fifo: the fifo to be used.
+ * @len: the length of space to be reserved.
+ * @ppos: return position of the reserved space.
+ *
+ * This function reserves space of @len bytes in the FIFO. The
+ * position of the reserved space is returned in @ppos. After the
+ * space is reserved, the data can be copied into reserved space with
+ * kfifo_in_data, and finally put into FIFO with kfifo_commit.
+ *
+ * This function must be paired with kfifo_commit, unless 0 is
+ * returned, which means no space is reserved.
+ *
+ * If the FIFO is used only on one CPU, kfifo_reserve/kfifo_commit
+ * pair can be used by different contexts such as NMI, IRQ, soft_irq
+ * and process (with preempt off) simultaneously safely without any
+ * locking or interrupt disabling.
+ *
+ * Preempt must be disabled between kfifo_reserve and kfifo_commit in
+ * process context for lock-less usage.
+ *
+ * Return 1 if success; return 0 if no enough space, nothing will be
+ * reserved.
+ */
+int kfifo_reserve(struct kfifo *fifo,
+	unsigned int len, unsigned int *ppos)
+{
+	unsigned int pos, npos;
+
+	npos = fifo->reserve;
+	do {
+		pos = npos;
+		if (kfifo_size(fifo) - (pos - fifo->out) < len)
+			return 0;
+		npos = cmpxchg(&fifo->reserve, pos, pos + len);
+	} while (npos != pos);
+	*ppos = pos;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(kfifo_reserve);
+
+/**
+ * kfifo_commit - commits the previous reserved space in the FIFO
+ * @fifo: the fifo to be used.
+ * @pos: position of the previous reserved space
+ *
+ * This function makes the data in previous reserved space at @pos
+ * into FIFO and can be consumed by reader.
+ */
+void kfifo_commit(struct kfifo *fifo, unsigned int pos)
+{
+	unsigned int in, nin, reserve;
+
+	if (fifo->in == pos) {
+		/* fifo->in must be updated after data */
+		smp_wmb();
+		do {
+			in = fifo->in;
+			/*
+			 * fifo->in must be read before fifo->reserve,
+			 * otherwise "in" may go beyond "reserve".
+			 */
+			rmb();
+			reserve = fifo->reserve;
+			/*
+			 * If preempted here, fifo->reserve may go
+			 * beyond reserve, this must be checked after
+			 * fifo->in assignment.
+			 */
+			nin = cmpxchg(&fifo->in, in, reserve);
+			/*
+			 * If preempted here, fifo->reserve != reserve
+			 * too, fifo->in need change with cmpxchg to
+			 * prevent fifo->in go backwards.
+			 */
+		} while (reserve != fifo->reserve || in != nin);
+	}
+}
+EXPORT_SYMBOL_GPL(kfifo_commit);
+
+/**
+ * kfifo_ll_in - puts some data into the FIFO, lock-less version
+ * @fifo: the fifo to be used.
+ * @from: the data to be added.
+ * @len: the length of the data to be added.
+ *
+ * This function puts @len bytes from @from buffer into the FIFO. If
+ * it is used on one CPU, the function can be used simultaneously by
+ * multiple contexts such as NMI, IRQ, soft_irq, process, etc safely
+ * without any locking or interrupt disabling.
+ *
+ * Return @len if success, 0 if no enough space
+ */
+unsigned int kfifo_ll_in(struct kfifo *fifo, const void *from, unsigned int len)
+{
+	unsigned int pos;
+
+	preempt_disable();
+	if (!kfifo_reserve(fifo, len, &pos))
+		return 0;
+	kfifo_in_data(fifo, from, len, pos);
+	kfifo_commit(fifo, pos);
+	preempt_enable_no_resched();
+	return len;
+}
+EXPORT_SYMBOL_GPL(kfifo_ll_in);
+
+/*
+ * Reserves some continuous spaces in the FIFO.
+ */
+static int kfifo_reserve_continuous(struct kfifo *fifo,
+	unsigned int *rlen, unsigned int *ppos)
+{
+	unsigned int pos, npos, l, to_end, avail, len = *rlen;
+
+	npos = fifo->reserve;
+	do {
+		pos = npos;
+		avail = kfifo_size(fifo) - (pos - fifo->out);
+		if (avail < len)
+			return 0;
+		to_end = kfifo_size(fifo) - __kfifo_off(fifo, pos);
+		if (to_end < len) {
+			if (avail - to_end < len)
+				return 0;
+			l = to_end;
+		} else
+			l = len;
+		npos = cmpxchg(&fifo->reserve, pos, pos + l);
+	} while (npos != pos);
+	*ppos = pos;
+	*rlen = l;
+
+	return 1;
+}
+
+/**
+ * kfifo_reserve_continuous_ptr - reserves some continuous space in the FIFO
+ * @fifo: the fifo to be used.
+ * @len: the length of space to be reserved, also used to return
+ *       actual reserved length.
+ *
+ * This function reserves some continuous space of at most @len bytes
+ * in the FIFO, and return the pointer to the space. So the reserved
+ * space can be accessed "in-place", until they are committed with
+ * kfifo_commit_ptr. The resulting FIFO layout also makes it possible
+ * to be read in-place.
+ *
+ * There may be two separated free spaces in FIFO, at begin and end of
+ * the buffer. If both are not big enough, NULL will return. If the
+ * free space at end is not but the free space at begin is big enough,
+ * the free space at end will be return, with @len set to actual
+ * length. Otherwise, @len will not be changed, and free space with
+ * length @len will be returned.
+ *
+ * This function must be paired with kfifo_commit_ptr, unless NULL is
+ * returned, which means no space is reserved.
+ *
+ * If the FIFO is used only on one CPU,
+ * kfifo_reserve_continuous_ptr/kfifo_commit_ptr pair can be used by
+ * different contexts such as NMI, IRQ, soft_irq and process (with
+ * preempt off) simultaneously and safely without any locking or
+ * interrupt disabling.
+ *
+ * Preempt must be disabled between kfifo_reserve_continuous_ptr and
+ * kfifo_commit_ptr in process context for lock-less usage.
+ */
+void *kfifo_reserve_continuous_ptr(struct kfifo *fifo,
+	unsigned int *len)
+{
+	unsigned int pos;
+
+	if (!kfifo_reserve_continuous(fifo, len, &pos))
+		return NULL;
+	return __kfifo_ptr(fifo, pos);
+}
+EXPORT_SYMBOL_GPL(kfifo_reserve_continuous_ptr);
+
+/**
+ * kfifo_commit_ptr - commits the previous reserved space in the FIFO
+ * @fifo: the fifo to be used.
+ * @ptr: pointer to the previous reserved space
+ *
+ * This functions makes the previous reserved space pointed by @ptr
+ * into FIFO and can be consumed by reader.
+ */
+void kfifo_commit_ptr(struct kfifo *fifo, void *ptr)
+{
+	unsigned int pos, in;
+
+	pos = ptr - (void *)fifo->buffer;
+	BUG_ON(pos >= fifo->size);
+	in = fifo->in;
+	pos += in & ~(fifo->size - 1);
+	if (pos < in)
+		pos += fifo->size;
+
+	kfifo_commit(fifo, pos);
+}
+EXPORT_SYMBOL_GPL(kfifo_commit_ptr);


