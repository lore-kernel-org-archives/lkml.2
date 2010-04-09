Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0DITVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:21:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19726 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab0DITVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:21:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 09 Apr 2010 21:21:18 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv2 1/8] wait_event_interruptible_locked() interface
In-reply-to: <cover.1270835924.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Davide Libenzi <davidel@xmailserver.org>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.0
References: <cover.1270835924.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New wait_event_interruptible{,_exclusive}_locked{,_irq,_irqsave}
macros added.  They work just like versions without _locked* suffix
but require the wait queue's lock to be held.  Also __wake_up_locked()
is now exported as to pair it with the above macros.

The use case of this new facility is when one uses wait queue's lock
to protect a data structure.  This may be advantageous if the
structure needs to be protected by a spinlock anyway.  In particular,
with additional spinlock the following code has to be used to wait for
an condition:

#v+
spin_lock(&data.lock);
...
for (ret = 0; !ret && !(condition); ) {
	spin_unlock(&data.lock);
	ret = wait_event_interruptible(data.wqh, (condition));
	spin_lock(&data.lock);
}
...
spin_unlock(&data.lock);
#v-

This looks bizarre plus wait_event_interruptible() locks the wait
queue's lock anyway so there is a unlock+lock sequence where it could
be avoided.

To avoid those problems and benefit from wait queue's lock, a code
similar to the following should be used:

#v+
/* Waiting */
spin_lock(&data.wqh.lock);
...
ret = wait_event_interruptible_locked(data.wqh, (condition));
...
spin_unlock(&data.wqh.lock);

/* Waiting exclusively */
spin_lock(&data.whq.lock);
...
ret = wait_event_interruptible_exclusive_locked(data.whq, (condition));
...
spin_unlock(&data.whq.lock);

/* Waking up */
spin_lock(&data.wqh.lock);
...
wake_up_locked(&data.wqh);
...
spin_unlock(&data.wqh.lock);
#v-

When spin_lock_irq() or spin_lock_irqsave() is used matching versions
of macros need to be used (*_locked_irq() or * _locked_irqsave()).

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 include/linux/wait.h |  231 +++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched.c       |    1 +
 2 files changed, 231 insertions(+), 1 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index a48e16b..1f97306 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -362,6 +362,235 @@ do {									\
 	__ret;								\
 })
 
+
+#define __wait_event_interruptible_locked(wq, condition, ret, exclusive, lock, unlock, lock_args) \
+do {									\
+	DEFINE_WAIT(__wait);						\
+									\
+	if (exclusive)							\
+		__wait.flags |= WQ_FLAG_EXCLUSIVE;			\
+	else								\
+		__wait.flags &= ~WQ_FLAG_EXCLUSIVE;			\
+	__add_wait_queue_tail(&(wq), &__wait);				\
+									\
+	do {								\
+		set_current_state(TASK_INTERRUPTIBLE);			\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+		spin_unlock ##unlock lock_args;				\
+		schedule();						\
+		spin_lock ##lock lock_args;				\
+	} while (!(condition));						\
+	__remove_wait_queue(&(wq), &__wait);				\
+	__set_current_state(TASK_RUNNING);				\
+} while (0)
+
+
+/**
+ * wait_event_interruptible_locked - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received.
+ * The @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * It must be called with wq.lock being held.  This spinlock is
+ * unlocked while sleeping but @condition testing is done while lock
+ * is held and when this macro exits the lock is held.
+ *
+ * The lock is locked/unlocked using spin_lock()/spin_unlock()
+ * functions which must match the way they are locked/unlocked outside
+ * of this macro.
+ *
+ * wake_up_locked() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function will return -ERESTARTSYS if it was interrupted by a
+ * signal and 0 if @condition evaluated to true.
+ */
+#define wait_event_interruptible_locked(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__wait_event_interruptible_locked(wq, condition, __ret, 0, , , (&(wq).lock)); \
+	__ret;								\
+})
+
+/**
+ * wait_event_interruptible_locked_irq - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received.
+ * The @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * It must be called with wq.lock being held.  This spinlock is
+ * unlocked while sleeping but @condition testing is done while lock
+ * is held and when this macro exits the lock is held.
+ *
+ * The lock is locked/unlocked using spin_lock_irq()/spin_unlock_irq()
+ * functions which must match the way they are locked/unlocked outside
+ * of this macro.
+ *
+ * wake_up_locked() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function will return -ERESTARTSYS if it was interrupted by a
+ * signal and 0 if @condition evaluated to true.
+ */
+#define wait_event_interruptible_locked_irq(wq, condition)		\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__wait_event_interruptible_locked(wq, condition, __ret, 0, _irq, _irq, (&(wq).lock)); \
+	__ret;								\
+})
+
+/**
+ * wait_event_interruptible_locked_irq - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @flags: variable to restore/save IRQ state from/to
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received.
+ * The @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * It must be called with wq.lock being held.  This spinlock is
+ * unlocked while sleeping but @condition testing is done while lock
+ * is held and when this macro exits the lock is held.
+ *
+ * The lock is locked/unlocked using
+ * spin_lock_irqsave()/spin_unlock_irqrestore() functions which must
+ * match the way they are locked/unlocked outside of this macro.
+ *
+ * wake_up_locked() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function will return -ERESTARTSYS if it was interrupted by a
+ * signal and 0 if @condition evaluated to true.
+ */
+#define wait_event_interruptible_locked_irqsave(wq, condition, flags)	\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__wait_event_interruptible_locked(wq, condition, __ret, 0, _irqsave, _irqrestore, (&(wq).lock, flags)); \
+	__ret;								\
+})
+
+
+/**
+ * wait_event_interruptible_exclusive_locked - sleep exclusively until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received.
+ * The @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * It must be called with wq.lock being held.  This spinlock is
+ * unlocked while sleeping but @condition testing is done while lock
+ * is held and when this macro exits the lock is held.
+ *
+ * The lock is locked/unlocked using spin_lock()/spin_unlock()
+ * functions which must match the way they are locked/unlocked outside
+ * of this macro.
+ *
+ * The process is put on the wait queue with an WQ_FLAG_EXCLUSIVE flag
+ * set thus when other process waits process on the list if this
+ * process is awaken further processes are not considered.
+ *
+ * wake_up_locked() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function will return -ERESTARTSYS if it was interrupted by a
+ * signal and 0 if @condition evaluated to true.
+ */
+#define wait_event_interruptible_exclusive_locked(wq, condition)	\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__wait_event_interruptible_locked(wq, condition, __ret, 1, , , (&(wq).lock)); \
+	__ret;								\
+})
+
+/**
+ * wait_event_interruptible_exclusive_locked_irq - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received.
+ * The @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * It must be called with wq.lock being held.  This spinlock is
+ * unlocked while sleeping but @condition testing is done while lock
+ * is held and when this macro exits the lock is held.
+ *
+ * The lock is locked/unlocked using spin_lock_irq()/spin_unlock_irq()
+ * functions which must match the way they are locked/unlocked outside
+ * of this macro.
+ *
+ * The process is put on the wait queue with an WQ_FLAG_EXCLUSIVE flag
+ * set thus when other process waits process on the list if this
+ * process is awaken further processes are not considered.
+ *
+ * wake_up_locked() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function will return -ERESTARTSYS if it was interrupted by a
+ * signal and 0 if @condition evaluated to true.
+ */
+#define wait_event_interruptible_exclusive_locked_irq(wq, condition)	\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__wait_event_interruptible_locked(wq, condition, __ret, 1, _irq, _irq, (&(wq).lock)); \
+	__ret;								\
+})
+
+/**
+ * wait_event_interruptible_locked_irq - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @flags: variable to restore/save IRQ state from/to
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received.
+ * The @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * It must be called with wq.lock being held.  This spinlock is
+ * unlocked while sleeping but @condition testing is done while lock
+ * is held and when this macro exits the lock is held.
+ *
+ * The lock is locked/unlocked using
+ * spin_lock_irqsave()/spin_unlock_irqrestore() functions which must
+ * match the way they are locked/unlocked outside of this macro.
+ *
+ * The process is put on the wait queue with an WQ_FLAG_EXCLUSIVE flag
+ * set thus when other process waits process on the list if this
+ * process is awaken further processes are not considered.
+ *
+ * wake_up_locked() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function will return -ERESTARTSYS if it was interrupted by a
+ * signal and 0 if @condition evaluated to true.
+ */
+#define wait_event_interruptible_exclusive_locked_irqsave(wq, condition, flags)	\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__wait_event_interruptible_locked(wq, condition, __ret, 1, _irqsave, _irqrestore, (&(wq).lock, flags)); \
+	__ret;								\
+})
+
+
+
 #define __wait_event_killable(wq, condition, ret)			\
 do {									\
 	DEFINE_WAIT(__wait);						\
@@ -517,7 +746,7 @@ static inline int wait_on_bit_lock(void *word, int bit,
 		return 0;
 	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
 }
-	
+
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 6ca5490..226e9ec 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3940,6 +3940,7 @@ void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
 {
 	__wake_up_common(q, mode, 1, 0, NULL);
 }
+EXPORT_SYMBOL_GPL(__wake_up_locked);
 
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
 {
