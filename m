Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1I0R4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:56:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34929 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1I0R4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:56:52 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=qESY86PY70oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=EgT1AKJx1_iBBSMqwtQA:9 a=19ZcLvjRT7GOcwytZoMA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: [PATCH][RT] ring-buffer: Convert reader_lock from raw_spin_lock
 into spin_lock
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark@redhat.com>
Date: Tue, 27 Sep 2011 13:56:50 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317146210.26514.33.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reader_lock is mostly taken in normal context with interrupts enabled.
But because ftrace_dump() can happen anywhere, it is used as a spin lock
and in some cases a check to in_nmi() is performed to determine if the
ftrace_dump() was initiated from an NMI and if it is, the lock is not taken.

But having the lock as a raw_spin_lock() causes issues with the real-time
kernel as the lock is held during allocation and freeing of the buffer.
As memory locks convert into mutexes, keeping the reader_lock as a spin_lock
causes problems.

Converting the reader_lock is not straight forward as we must still deal
with the ftrace_dump() happening not only from an NMI but also from
true interrupt context in PREEPMT_RT.

Two wrapper functions are created to take and release the reader lock:

  int read_buffer_lock(cpu_buffer, unsigned long *flags)
  void read_buffer_unlock(cpu_buffer, unsigned long flags, int locked)

The read_buffer_lock() returns 1 if it actually took the lock, disables
interrupts and updates the flags. The only time it returns 0 is in the
case of a ftrace_dump() happening in an unsafe context.

The read_buffer_unlock() checks the return of locked and will simply
unlock the spin lock if it was successfully taken.

Instead of just having this in specific cases that the NMI might call
into, all instances of the reader_lock is converted to the wrapper
functions to make this a bit simpler to read and less error prone.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>



Index: linux-rt.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-rt.git.orig/kernel/trace/ring_buffer.c
+++ linux-rt.git/kernel/trace/ring_buffer.c
@@ -478,7 +478,7 @@ struct ring_buffer_per_cpu {
 	int				cpu;
 	atomic_t			record_disabled;
 	struct ring_buffer		*buffer;
-	raw_spinlock_t			reader_lock;	/* serialize readers */
+	spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct list_head		*pages;
@@ -1040,6 +1040,46 @@ static int rb_allocate_pages(struct ring
 	return -ENOMEM;
 }
 
+static inline int ok_to_lock(void)
+{
+	if (in_nmi())
+		return 0;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (in_atomic())
+		return 0;
+#endif
+	return 1;
+}
+
+static int
+read_buffer_lock(struct ring_buffer_per_cpu *cpu_buffer,
+		 unsigned long *flags)
+{
+	/*
+	 * If an NMI die dumps out the content of the ring buffer
+	 * do not grab locks. We also permanently disable the ring
+	 * buffer too. A one time deal is all you get from reading
+	 * the ring buffer from an NMI.
+	 */
+	if (!ok_to_lock()) {
+		if (spin_trylock_irqsave(&cpu_buffer->reader_lock, *flags))
+			return 1;
+		printk("Dumping ring buffer from unsafe context\n");
+		printk("Disabling new ring buffer writes\n");
+		tracing_off_permanent();
+		return 0;
+	}
+	spin_lock_irqsave(&cpu_buffer->reader_lock, *flags);
+	return 1;
+}
+
+static void
+read_buffer_unlock(struct ring_buffer_per_cpu *cpu_buffer,
+		   unsigned long flags, int locked)
+{
+	if (locked)
+		spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+}
 static struct ring_buffer_per_cpu *
 rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 {
@@ -1055,7 +1095,7 @@ rb_allocate_cpu_buffer(struct ring_buffe
 
 	cpu_buffer->cpu = cpu;
 	cpu_buffer->buffer = buffer;
-	raw_spin_lock_init(&cpu_buffer->reader_lock);
+	spin_lock_init(&cpu_buffer->reader_lock);
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
@@ -1250,9 +1290,11 @@ rb_remove_pages(struct ring_buffer_per_c
 {
 	struct buffer_page *bpage;
 	struct list_head *p;
+	unsigned long flags;
 	unsigned i;
+	int locked;
 
-	raw_spin_lock_irq(&cpu_buffer->reader_lock);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1270,7 +1312,7 @@ rb_remove_pages(struct ring_buffer_per_c
 	rb_check_pages(cpu_buffer);
 
 out:
-	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 }
 
 static void
@@ -1279,9 +1321,11 @@ rb_insert_pages(struct ring_buffer_per_c
 {
 	struct buffer_page *bpage;
 	struct list_head *p;
+	unsigned long flags;
 	unsigned i;
+	int locked;
 
-	raw_spin_lock_irq(&cpu_buffer->reader_lock);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1296,7 +1340,7 @@ rb_insert_pages(struct ring_buffer_per_c
 	rb_check_pages(cpu_buffer);
 
 out:
-	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 }
 
 /**
@@ -2784,15 +2828,16 @@ void ring_buffer_iter_reset(struct ring_
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
+	int locked;
 
 	if (!iter)
 		return;
 
 	cpu_buffer = iter->cpu_buffer;
 
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	rb_iter_reset(iter);
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_iter_reset);
 
@@ -3210,21 +3255,6 @@ rb_iter_peek(struct ring_buffer_iter *it
 }
 EXPORT_SYMBOL_GPL(ring_buffer_iter_peek);
 
-static inline int rb_ok_to_lock(void)
-{
-	/*
-	 * If an NMI die dumps out the content of the ring buffer
-	 * do not grab locks. We also permanently disable the ring
-	 * buffer too. A one time deal is all you get from reading
-	 * the ring buffer from an NMI.
-	 */
-	if (likely(!in_nmi()))
-		return 1;
-
-	tracing_off_permanent();
-	return 0;
-}
-
 /**
  * ring_buffer_peek - peek at the next event to be read
  * @buffer: The ring buffer to read
@@ -3242,22 +3272,17 @@ ring_buffer_peek(struct ring_buffer *buf
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct ring_buffer_event *event;
 	unsigned long flags;
-	int dolock;
+	int locked;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
-	dolock = rb_ok_to_lock();
  again:
-	local_irq_save(flags);
-	if (dolock)
-		raw_spin_lock(&cpu_buffer->reader_lock);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		rb_advance_reader(cpu_buffer);
-	if (dolock)
-		raw_spin_unlock(&cpu_buffer->reader_lock);
-	local_irq_restore(flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
@@ -3279,11 +3304,12 @@ ring_buffer_iter_peek(struct ring_buffer
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	struct ring_buffer_event *event;
 	unsigned long flags;
+	int locked;
 
  again:
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	event = rb_iter_peek(iter, ts);
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
@@ -3309,9 +3335,7 @@ ring_buffer_consume(struct ring_buffer *
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event = NULL;
 	unsigned long flags;
-	int dolock;
-
-	dolock = rb_ok_to_lock();
+	int locked;
 
  again:
 	/* might be called in atomic */
@@ -3321,9 +3345,7 @@ ring_buffer_consume(struct ring_buffer *
 		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
-	local_irq_save(flags);
-	if (dolock)
-		raw_spin_lock(&cpu_buffer->reader_lock);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 
 	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
 	if (event) {
@@ -3331,9 +3353,8 @@ ring_buffer_consume(struct ring_buffer *
 		rb_advance_reader(cpu_buffer);
 	}
 
-	if (dolock)
-		raw_spin_unlock(&cpu_buffer->reader_lock);
-	local_irq_restore(flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
+
 
  out:
 	preempt_enable();
@@ -3418,17 +3439,18 @@ ring_buffer_read_start(struct ring_buffe
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
+	int locked;
 
 	if (!iter)
 		return;
 
 	cpu_buffer = iter->cpu_buffer;
 
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	arch_spin_lock(&cpu_buffer->lock);
 	rb_iter_reset(iter);
 	arch_spin_unlock(&cpu_buffer->lock);
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_start);
 
@@ -3462,8 +3484,9 @@ ring_buffer_read(struct ring_buffer_iter
 	struct ring_buffer_event *event;
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	unsigned long flags;
+	int locked;
 
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
  again:
 	event = rb_iter_peek(iter, ts);
 	if (!event)
@@ -3474,7 +3497,7 @@ ring_buffer_read(struct ring_buffer_iter
 
 	rb_advance_iter(iter);
  out:
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
 	return event;
 }
@@ -3537,13 +3560,14 @@ void ring_buffer_reset_cpu(struct ring_b
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	unsigned long flags;
+	int locked;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
 	atomic_inc(&cpu_buffer->record_disabled);
 
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 
 	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
 		goto out;
@@ -3555,7 +3579,7 @@ void ring_buffer_reset_cpu(struct ring_b
 	arch_spin_unlock(&cpu_buffer->lock);
 
  out:
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
 	atomic_dec(&cpu_buffer->record_disabled);
 }
@@ -3582,22 +3606,16 @@ int ring_buffer_empty(struct ring_buffer
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
-	int dolock;
+	int locked;
 	int cpu;
 	int ret;
 
-	dolock = rb_ok_to_lock();
-
 	/* yes this is racy, but if you don't like the race, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		local_irq_save(flags);
-		if (dolock)
-			raw_spin_lock(&cpu_buffer->reader_lock);
+		locked = read_buffer_lock(cpu_buffer, &flags);
 		ret = rb_per_cpu_empty(cpu_buffer);
-		if (dolock)
-			raw_spin_unlock(&cpu_buffer->reader_lock);
-		local_irq_restore(flags);
+		read_buffer_unlock(cpu_buffer, flags, locked);
 
 		if (!ret)
 			return 0;
@@ -3616,22 +3634,16 @@ int ring_buffer_empty_cpu(struct ring_bu
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
-	int dolock;
+	int locked;
 	int ret;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 1;
 
-	dolock = rb_ok_to_lock();
-
 	cpu_buffer = buffer->buffers[cpu];
-	local_irq_save(flags);
-	if (dolock)
-		raw_spin_lock(&cpu_buffer->reader_lock);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 	ret = rb_per_cpu_empty(cpu_buffer);
-	if (dolock)
-		raw_spin_unlock(&cpu_buffer->reader_lock);
-	local_irq_restore(flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
 	return ret;
 }
@@ -3805,6 +3817,7 @@ int ring_buffer_read_page(struct ring_bu
 	unsigned int commit;
 	unsigned int read;
 	u64 save_timestamp;
+	int locked;
 	int ret = -1;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -3826,7 +3839,7 @@ int ring_buffer_read_page(struct ring_bu
 	if (!bpage)
 		goto out;
 
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	locked = read_buffer_lock(cpu_buffer, &flags);
 
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
@@ -3949,7 +3962,7 @@ int ring_buffer_read_page(struct ring_bu
 		memset(&bpage->data[commit], 0, BUF_PAGE_SIZE - commit);
 
  out_unlock:
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	read_buffer_unlock(cpu_buffer, flags, locked);
 
  out:
 	return ret;


