Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0HXBm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 21:42:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:45206 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab0HXBm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 21:42:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,260,1280732400"; 
   d="scan'208,223";a="599507007"
Subject: [RFC -v2] kfifo writer side lock-less support
From: Huang Ying <ying.huang@intel.com>
To: Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-k8O7C1kbihQUCfRzqQz4"
Date: Tue, 24 Aug 2010 09:42:26 +0800
Message-ID: <1282614146.2708.13.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-k8O7C1kbihQUCfRzqQz4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi, Stefani,

The sample code is attached with the mail too. If it is necessary, I
can put the sample code into samples/kfifo directory if the basic
idea of the patch is accepted.

Best Regards,
Huang Ying
------------------------------>
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

v2:

- Rebased on 2.6.36

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/kfifo.h |  142 ++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/kfifo.c        |  106 +++++++++++++++++++++++++++++++++++--
 2 files changed, 239 insertions(+), 9 deletions(-)

--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -57,6 +57,7 @@
 
 struct __kfifo {
 	unsigned int	in;
+	unsigned int	reserve;
 	unsigned int	out;
 	unsigned int	mask;
 	unsigned int	esize;
@@ -138,6 +139,7 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PT
 	typeof(&(fifo)) __tmp = &(fifo); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	__kfifo->in = 0; \
+	__kfifo->reserve = 0; \
 	__kfifo->out = 0; \
 	__kfifo->mask = __is_kfifo_ptr(__tmp) ? 0 : ARRAY_SIZE(__tmp->buf) - 1;\
 	__kfifo->esize = sizeof(*__tmp->buf); \
@@ -158,6 +160,7 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PT
 		{ \
 			{ \
 			.in	= 0, \
+			.reserve = 0, \
 			.out	= 0, \
 			.mask	= __is_kfifo_ptr(&(fifo)) ? \
 				  0 : \
@@ -215,7 +218,7 @@ __kfifo_must_check_helper(unsigned int v
 #define kfifo_reset(fifo) \
 (void)({ \
 	typeof(fifo + 1) __tmp = (fifo); \
-	__tmp->kfifo.in = __tmp->kfifo.out = 0; \
+	__tmp->kfifo.reserve = __tmp->kfifo.in = __tmp->kfifo.out = 0; \
 })
 
 /**
@@ -242,6 +245,16 @@ __kfifo_must_check_helper(unsigned int v
 	__tmpl->kfifo.in - __tmpl->kfifo.out; \
 })
 
+/*
+ * __kfifo_used - internal function returns the number of used
+ * elements in the fifo (including reserved)
+ */
+#define __kfifo_used(fifo) \
+({ \
+	typeof((fifo) + 1) __tmpl = (fifo); \
+	__tmpl->kfifo.reserve - __tmpl->kfifo.out; \
+})
+
 /**
  * kfifo_is_empty - returns true if the fifo is empty
  * @fifo: address of the fifo to be used
@@ -259,7 +272,7 @@ __kfifo_must_check_helper(unsigned int v
 #define	kfifo_is_full(fifo) \
 ({ \
 	typeof(fifo + 1) __tmpq = (fifo); \
-	kfifo_len(__tmpq) > __tmpq->kfifo.mask; \
+	__kfifo_used(__tmpq) > __tmpq->kfifo.mask; \
 })
 
 /**
@@ -271,7 +284,7 @@ __kfifo_must_check_helper( \
 ({ \
 	typeof(fifo + 1) __tmpq = (fifo); \
 	const size_t __recsize = sizeof(*__tmpq->rectype); \
-	unsigned int __avail = kfifo_size(__tmpq) - kfifo_len(__tmpq); \
+	unsigned int __avail = kfifo_size(__tmpq) - __kfifo_used(__tmpq); \
 	(__recsize) ? ((__avail <= __recsize) ? 0 : \
 	__kfifo_max_r(__avail - __recsize, __recsize)) : \
 	__avail; \
@@ -294,6 +307,22 @@ __kfifo_must_check_helper( \
 })
 
 /**
+ * kfifo_skip_len - skip output data of specified length
+ * @fifo: address of the fifo to be used
+ * @len: length to skip
+ */
+#define	kfifo_skip_len(fifo, len) \
+(void)({ \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	unsigned long __len = (len); \
+	if (__len <= __kfifo->in - __kfifo->out) \
+		__kfifo->out += __len; \
+	else \
+		__kfifo->out = __kfifo->in; \
+})
+
+/**
  * kfifo_peek_len - gets the size of the next fifo record
  * @fifo: address of the fifo to be used
  *
@@ -400,6 +429,7 @@ __kfifo_must_check_helper( \
 			)[__kfifo->in & __tmp->kfifo.mask] = \
 				*(typeof(__tmp->type))__val; \
 			smp_wmb(); \
+			__kfifo->reserve++; \
 			__kfifo->in++; \
 		} \
 	} \
@@ -596,6 +626,59 @@ __kfifo_must_check_helper( \
 		kfifo_out_spinlocked(fifo, buf, n, lock)
 
 /**
+ * kfifo_reserve_continuous_ptr - reserves some continuous space in the FIFO
+ * @fifo: the fifo to be used.
+ * @len: the length of space (in number of elements) to be reserved, also
+ *       used to return actual reserved length.
+ *
+ * This function reserves some continuous space of at most @len elements
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
+#define kfifo_reserve_continuous_ptr(fifo, pn) \
+({ \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	__kfifo_reserve_continuous_ptr(__kfifo, pn); \
+})
+
+/**
+ * kfifo_commit_ptr - commits the previous reserved space in the FIFO
+ * @fifo: the fifo to be used.
+ * @ptr: pointer to the previous reserved space
+ *
+ * This functions makes the previous reserved space pointed by @ptr
+ * into FIFO and can be consumed by reader.
+ */
+#define kfifo_commit_ptr(fifo, ptr) \
+(void)({ \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	__kfifo_commit_ptr(__kfifo, ptr); \
+})
+
+/**
  * kfifo_from_user - puts some data from user space into the fifo
  * @fifo: address of the fifo to be used
  * @from: pointer to the data to be added
@@ -816,6 +899,10 @@ extern unsigned int __kfifo_in_r(struct
 extern unsigned int __kfifo_out_r(struct __kfifo *fifo,
 	void *buf, unsigned int len, size_t recsize);
 
+extern void *__kfifo_reserve_continuous_ptr(struct __kfifo *fifo,
+					    unsigned int *len);
+extern void __kfifo_commit_ptr(struct __kfifo *fifo, void *ptr);
+
 extern int __kfifo_from_user_r(struct __kfifo *fifo,
 	const void __user *from, unsigned long len, unsigned int *copied,
 	size_t recsize);
@@ -843,4 +930,53 @@ extern unsigned int __kfifo_out_peek_r(s
 
 extern unsigned int __kfifo_max_r(unsigned int len, size_t recsize);
 
+struct kfifo_iter {
+	struct __kfifo *fifo;
+	unsigned int pos;
+};
+
+/**
+ * kfifo_iter_init - initialize a FIFO iterator
+ * @iter: the iterator to be initialized
+ * @fifo: the fifo to be accessed
+ *
+ */
+#define kfifo_iter_init(iter, fifo_in) \
+(void)({ \
+	struct kfifo_iter *__iter = (iter); \
+	typeof((fifo_in) + 1) __tmp = (fifo_in); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	__iter->fifo = __kfifo; \
+	__iter->pos = __kfifo->out; \
+})
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
+	struct __kfifo *fifo = iter->fifo;
+	unsigned int pos = iter->pos;
+	if (pos == fifo->in)
+		return NULL;
+	return fifo->data + (fifo->mask & pos) * fifo->esize;
+}
 #endif
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -32,7 +32,7 @@
  */
 static inline unsigned int kfifo_unused(struct __kfifo *fifo)
 {
-	return (fifo->mask + 1) - (fifo->in - fifo->out);
+	return (fifo->mask + 1) - (fifo->reserve - fifo->out);
 }
 
 int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
@@ -46,6 +46,7 @@ int __kfifo_alloc(struct __kfifo *fifo,
 		size = rounddown_pow_of_two(size);
 
 	fifo->in = 0;
+	fifo->reserve = 0;
 	fifo->out = 0;
 	fifo->esize = esize;
 
@@ -71,6 +72,7 @@ void __kfifo_free(struct __kfifo *fifo)
 {
 	kfree(fifo->data);
 	fifo->in = 0;
+	fifo->reserve = 0;
 	fifo->out = 0;
 	fifo->esize = 0;
 	fifo->data = NULL;
@@ -87,6 +89,7 @@ int __kfifo_init(struct __kfifo *fifo, v
 		size = rounddown_pow_of_two(size);
 
 	fifo->in = 0;
+	fifo->reserve = 0;
 	fifo->out = 0;
 	fifo->esize = esize;
 	fifo->data = buffer;
@@ -135,7 +138,8 @@ unsigned int __kfifo_in(struct __kfifo *
 		len = l;
 
 	kfifo_copy_in(fifo, buf, len, fifo->in);
-	fifo->in += len;
+	fifo->reserve += len;
+	fifo->in = fifo->reserve;
 	return len;
 }
 EXPORT_SYMBOL(__kfifo_in);
@@ -187,6 +191,92 @@ unsigned int __kfifo_out(struct __kfifo
 }
 EXPORT_SYMBOL(__kfifo_out);
 
+/*
+ * Reserves some continuous spaces in the FIFO.
+ */
+static int __kfifo_reserve_continuous(struct __kfifo *fifo,
+	unsigned int *rlen, unsigned int *ppos)
+{
+	unsigned int pos, npos, l, to_end, avail, len = *rlen;
+
+	npos = fifo->reserve;
+	do {
+		pos = npos;
+		avail = fifo->mask + 1 - (pos - fifo->out);
+		if (avail < len)
+			return 0;
+		to_end = fifo->mask + 1 - (fifo->mask & pos);
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
+void *__kfifo_reserve_continuous_ptr(struct __kfifo *fifo,
+	unsigned int *len)
+{
+	unsigned int pos;
+	unsigned int esize = fifo->esize;
+
+	if (!__kfifo_reserve_continuous(fifo, len, &pos))
+		return NULL;
+	return fifo->data + (fifo->mask & pos) * esize;
+}
+EXPORT_SYMBOL_GPL(__kfifo_reserve_continuous_ptr);
+
+static void __kfifo_commit(struct __kfifo *fifo, unsigned int pos)
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
+
+void __kfifo_commit_ptr(struct __kfifo *fifo, void *ptr)
+{
+	unsigned int pos, in, esize = fifo->esize;
+
+	pos = (ptr - (void *)fifo->data) / esize;
+	BUG_ON(pos > fifo->mask);
+	in = fifo->in;
+	pos += in & ~fifo->mask;
+	if (pos < in)
+		pos += fifo->mask + 1;
+
+	__kfifo_commit(fifo, pos);
+}
+EXPORT_SYMBOL_GPL(__kfifo_commit_ptr);
+
 static unsigned long kfifo_copy_from_user(struct __kfifo *fifo,
 	const void __user *from, unsigned int len, unsigned int off,
 	unsigned int *copied)
@@ -243,7 +333,8 @@ int __kfifo_from_user(struct __kfifo *fi
 		err = -EFAULT;
 	} else
 		err = 0;
-	fifo->in += len;
+	fifo->reserve += len;
+	fifo->in = fifo->reserve;
 	return err;
 }
 EXPORT_SYMBOL(__kfifo_from_user);
@@ -460,7 +551,8 @@ unsigned int __kfifo_in_r(struct __kfifo
 	__kfifo_poke_n(fifo, len, recsize);
 
 	kfifo_copy_in(fifo, buf, len, fifo->in + recsize);
-	fifo->in += len + recsize;
+	fifo->reserve += len + recsize;
+	fifo->in = fifo->reserve;
 	return len;
 }
 EXPORT_SYMBOL(__kfifo_in_r);
@@ -531,7 +623,8 @@ int __kfifo_from_user_r(struct __kfifo *
 		*copied = 0;
 		return -EFAULT;
 	}
-	fifo->in += len + recsize;
+	fifo->reserve += len + recsize;
+	fifo->in = fifo->reserve;
 	return 0;
 }
 EXPORT_SYMBOL(__kfifo_from_user_r);
@@ -581,7 +674,8 @@ void __kfifo_dma_in_finish_r(struct __kf
 {
 	len = __kfifo_max_r(len, recsize);
 	__kfifo_poke_n(fifo, len, recsize);
-	fifo->in += len + recsize;
+	fifo->reserve += len + recsize;
+	fifo->in = fifo->reserve;
 }
 EXPORT_SYMBOL(__kfifo_dma_in_finish_r);
 


--=-k8O7C1kbihQUCfRzqQz4
Content-Disposition: attachment; filename="0009-kfifo_sample.patch"
Content-Type: text/x-patch; name="0009-kfifo_sample.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 7ea29ebb151f4822b3091c018b3b6401f2a36e3e Mon Sep 17 00:00:00 2001
From: Huang Ying <ying.huang@intel.com>
Date: Fri, 2 Jul 2010 13:51:45 +0800
Subject: [PATCH 09/30] kfifo_sample

---
 kernel/Makefile       |    1 
 kernel/kfifo_sample.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+)
 create mode 100644 kernel/kfifo_sample.c

--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-m += kfifo_sample.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
--- /dev/null
+++ b/kernel/kfifo_sample.c
@@ -0,0 +1,125 @@
+/* kfifo_sample.c */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kfifo.h>
+#include <linux/percpu.h>
+
+enum record_type {
+	/* The record is just a pad in fifo, no valid data */
+	RECORD_TYPE_PAD = 0x1,
+	RECORD_TYPE_NMI = 0x2,
+	RECORD_TYPE_IRQ = 0x3,
+};
+
+/* Variable length data structure to put into fifo */
+struct base_record {
+	unsigned short len;
+	unsigned short type;
+	unsigned char data[0];
+};
+
+/* Data collected in NMI handler */
+struct nmi_record {
+	struct base_record base;
+	int nmi_field1;
+	int nmi_field2;
+};
+
+/* Data collected in IRQ handler */
+struct irq_record {
+	struct base_record base;
+	int irq_field1;
+};
+
+static DEFINE_PER_CPU(struct kfifo, fifos);
+
+int record_fifo_write(unsigned int len,
+		      void (*fill_data)(struct base_record *rcd))
+{
+	struct kfifo *fifo;
+	struct base_record *rcd;
+	unsigned int rlen;
+	int rc = 0;
+
+	fifo = &get_cpu_var(fifos);
+	for (;;) {
+		rlen = len;
+		rcd = kfifo_reserve_continuous_ptr(fifo, &rlen);
+		/* Overflow, this record is thrown away */
+		if (!rcd) {
+			rc = -ENOBUFS;
+			goto out;
+		}
+		/*
+		 * Continuous space is not big enough, the requested
+		 * space will be marked as pad, then retry
+		 */
+		if (rlen != len) {
+			rcd->len = rlen;
+			rcd->type = RECORD_TYPE_PAD;
+			kfifo_commit_ptr(fifo, rcd);
+		} else {
+			rcd->len = len;
+			/* Fill other fields */
+			fill_data(rcd);
+			kfifo_commit_ptr(fifo, rcd);
+			break;
+		}
+	}
+out:
+	put_cpu_var(fifos);
+	return rc;
+}
+
+void nmi_fill_data(struct base_record *rcd)
+{
+	struct nmi_record *nmi_rcd = (struct nmi_record *)rcd;
+
+	rcd->type = RECORD_TYPE_NMI;
+	/* Fill other NMI specific field */
+}
+
+void nmi_handler(void)
+{
+	record_fifo_write(sizeof(struct nmi_record), nmi_fill_data);
+	/* other processing */
+}
+
+void irq_fill_data(struct base_record *rcd)
+{
+	struct irq_record *irq_rcd = (struct irq_record *)rcd;
+
+	rcd->type = RECORD_TYPE_IRQ;
+	/* Fill other IRQ specific field */
+}
+
+void irq_handler(void)
+{
+	record_fifo_write(sizeof(struct irq_record), irq_fill_data);
+	/* other processing */
+}
+
+int record_fifo_for_each(int (*func)(struct base_record *rcd))
+{
+	struct kfifo *fifo;
+	int cpu, rc;
+	struct kfifo_iter iter;
+	struct base_record *rcd;
+
+	for_each_possible_cpu(cpu) {
+		fifo = &per_cpu(fifos, cpu);
+		kfifo_iter_init(&iter, fifo);
+		while ((rcd = kfifo_iter_get_ptr(&iter))) {
+			if (rcd->type != RECORD_TYPE_PAD) {
+				rc = func(rcd);
+				if (rc)
+					return rc;
+			}
+			/* goto next record, the pad space is just skipped */
+			kfifo_iter_advance(&iter, rcd->len);
+		}
+	}
+
+	return 0;
+}

--=-k8O7C1kbihQUCfRzqQz4--

