Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab2ARDsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 22:48:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab2ARDrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 22:47:02 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=jVT9SK_jWMcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=w8_DxKhSGg0PB-R0absA:9 a=XFavaKiU2MbogS2wqX0A:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=cE6YDZXAX_NKWRN39RUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120118034700.245278561@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 17 Jan 2012 22:45:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 2/4] wait-simple: Simple waitqueue implementation
References: <20120118034531.335521323@goodmis.org>
Content-Disposition: inline; filename=0002-wait-simple-Simple-waitqueue-implementation.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Thomas Gleixner <tglx@linutronix.de>

wait_queue is a swiss army knife and in most of the cases the
complexity is not needed. For RT waitqueues are a constant source of
trouble as we can't convert the head lock to a raw spinlock due to
fancy and long lasting callbacks.

Provide a slim version, which allows RT to replace wait queues. This
should go mainline as well, as it lowers memory consumption and
runtime overhead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/wait-simple.h |  152 +++++++++++++++++++++++++++++++++++++++=
++++
 kernel/Makefile             |    2 +-
 kernel/wait-simple.c        |   62 +++++++++++++++++
 3 files changed, 215 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/wait-simple.h
 create mode 100644 kernel/wait-simple.c

diff --git a/include/linux/wait-simple.h b/include/linux/wait-simple.h
new file mode 100644
index 0000000..de69d8a
--- /dev/null
+++ b/include/linux/wait-simple.h
@@ -0,0 +1,152 @@
+#ifndef _LINUX_WAIT_SIMPLE_H
+#define _LINUX_WAIT_SIMPLE_H
+
+#include <linux/spinlock.h>
+#include <linux/list.h>
+
+#include <asm/current.h>
+
+struct swaiter {
+	struct task_struct	*task;
+	struct list_head	node;
+};
+
+#define DEFINE_SWAITER(name)					\
+	struct swaiter name =3D {					\
+		.task	=3D current,				\
+		.node	=3D LIST_HEAD_INIT((name).node),		\
+	}
+
+struct swait_head {
+	raw_spinlock_t		lock;
+	struct list_head	list;
+};
+
+#define DEFINE_SWAIT_HEAD(name)					\
+	struct swait_head name =3D {				\
+		.lock	=3D __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
+		.list	=3D LIST_HEAD_INIT((name).list),		\
+	}
+
+extern void __init_swait_head(struct swait_head *h, struct lock_class_key =
*key);
+
+#define init_swait_head(swh)					\
+	do {							\
+		static struct lock_class_key __key;		\
+								\
+		__init_swait_head((swh), &__key);		\
+	} while (0)
+
+/*
+ * Waiter functions
+ */
+static inline bool swaiter_enqueued(struct swaiter *w)
+{
+	return w->task !=3D NULL;
+}
+
+extern void swait_prepare(struct swait_head *head, struct swaiter *w, int =
state);
+extern void swait_finish(struct swait_head *head, struct swaiter *w);
+
+/*
+ * Adds w to head->list. Must be called with head->lock locked.
+ */
+static inline void __swait_enqueue(struct swait_head *head, struct swaiter=
 *w)
+{
+	list_add(&w->node, &head->list);
+}
+
+/*
+ * Removes w from head->list. Must be called with head->lock locked.
+ */
+static inline void __swait_dequeue(struct swaiter *w)
+{
+	list_del_init(&w->node);
+}
+
+/*
+ * Wakeup functions
+ */
+extern void __swait_wake(struct swait_head *head, unsigned int state);
+
+static inline void swait_wake(struct swait_head *head)
+{
+	__swait_wake(head, TASK_NORMAL);
+}
+
+/*
+ * Event API
+ */
+
+#define __swait_event(wq, condition)					\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		schedule();						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define swait_event(wq, condition)					\
+do {									\
+	if (condition)							\
+		break;							\
+	__swait_event(wq, condition);					\
+} while (0)
+
+#define __swait_event_timeout(wq, condition, ret)			\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		ret =3D schedule_timeout(ret);				\
+		if (!ret)						\
+			break;						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event_timeout - sleep until a condition gets true or a timeout el=
apses
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function returns 0 if the @timeout elapsed, and the remaining
+ * jiffies if the condition evaluated to true before the timeout elapsed.
+ */
+#define swait_event_timeout(wq, condition, timeout)			\
+({									\
+	long __ret =3D timeout;						\
+	if (!(condition))						\
+		__swait_event_timeout(wq, condition, __ret);		\
+	__ret;								\
+})
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index 11949f1..6a9558b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     =3D sched.o fork.o exec_domain.o panic.o printk=
.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o jump_label.o
+	    async.o range.o wait-simple.o jump_label.o
 obj-y +=3D groups.o
=20
 ifdef CONFIG_FUNCTION_TRACER
diff --git a/kernel/wait-simple.c b/kernel/wait-simple.c
new file mode 100644
index 0000000..7f1cb72
--- /dev/null
+++ b/kernel/wait-simple.c
@@ -0,0 +1,62 @@
+/*
+ * Simple waitqueues without fancy flags and callbacks
+ *
+ * (C) 2011 Thomas Gleixner <tglx@linutronix.de>
+ *
+ * Based on kernel/wait.c
+ *
+ * For licencing details see kernel-base/COPYING
+ */
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/wait-simple.h>
+
+void __init_swait_head(struct swait_head *head, struct lock_class_key *key)
+{
+	raw_spin_lock_init(&head->lock);
+	lockdep_set_class(&head->lock, key);
+	INIT_LIST_HEAD(&head->list);
+}
+EXPORT_SYMBOL_GPL(__init_swait_head);
+
+void swait_prepare(struct swait_head *head, struct swaiter *w, int state)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+	w->task =3D current;
+	__swait_enqueue(head, w);
+	set_current_state(state);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+}
+EXPORT_SYMBOL_GPL(swait_prepare);
+
+void swait_finish(struct swait_head *head, struct swaiter *w)
+{
+	unsigned long flags;
+
+	__set_current_state(TASK_RUNNING);
+	if (w->task) {
+		raw_spin_lock_irqsave(&head->lock, flags);
+		__swait_dequeue(w);
+		raw_spin_unlock_irqrestore(&head->lock, flags);
+	}
+}
+EXPORT_SYMBOL_GPL(swait_finish);
+
+void __swait_wake(struct swait_head *head, unsigned int state)
+{
+	struct swaiter *curr, *next;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+
+	list_for_each_entry_safe(curr, next, &head->list, node) {
+		if (wake_up_state(curr->task, state)) {
+			__swait_dequeue(curr);
+			curr->task =3D NULL;
+		}
+	}
+
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+}
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPFkC0AAoJEIy3vGnGbaoAS0oQAMmGVjBneGMfU4p+x2m0PlSg
h7T/Ovhm5XXHs0ggaFfWKEEMbm4NZOeShqNZX1eQUfLzTFN9JmDS9FFy98Qa+NfB
pSjwG73AnqSl/vQzHa8ZWOsJhkq5pVZdfXbehDi4wV9p3Xcm57aoU9oDxYAcAhvp
eymuHwnijE3+DIgxlIhOfXFZsKpAqLE50AZoE++/4VyuQEN/eR5ixceT6+8DJThl
MzPiS28PkUroc/wmFUpe6LcmMJTKPhhW6i4M/gZqckkNfDLzFBmV0ZDD94aJ6nN5
MrY7CmfD7J4xwV/peQ1/QRr14i7GHVBDVchOTfG3Y8uEuSgUy+DOzPdhIGcveN/h
8ZDrnR8TRM1CmOeruqehWOSizGTslRVYLtxl8oaSgyYHnQRh9q4xNISS9Vto6wUL
lSa2pEFU0dMtP+xZU/5zBnZ2RTwNMKa7VqUcKhndTDPLYwULmlLF0rWdikt3v8HO
I1bb7d0S2xqM0dDfCaFbA4jbPYZyKhvzp3+EEij2IXCDghP4Bg56s6IMYAUipMBO
rXdBuD3TQwvBLSn0rnggxvLnKpeE3bPGisfb2iDq6jNTNWCv+xRaIoqyqaq/9QVc
Jv/ekL0ds5WBPsy1OQiK6ycqr4w64kPLABZoNBIGvcYTp6yP1TvsnbSeLoJrQPyH
KxtwXChlpG6K5VxGEqjQ
=aMdF
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
