Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1G0KMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:12:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56533 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab1G0KMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:12:32 -0400
Message-ID: <4E2FE47F.1080406@2net.co.uk>
Date: Wed, 27 Jul 2011 11:12:15 +0100
From: Chris Simmonds <chris.simmonds@2net.co.uk>
Reply-To: chris@2net.co.uk
Organization: 2net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: stern@rowland.harvard.edu, mingo@redhat.com, Chris <chris@2net.co.uk>
Subject: [RFC] [PATCH] Lightweight kernel condition variables: faster code,
 fewer bugs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:r4DTj4TkH4F+q24s9IJFcWIBaJOdskrpaoEWFv/kYLb
 xOP+M2+FPXjlrmr4toIutFDWWRyRNxY75O5D4SrkCowmlG2Mkq
 Ypy/5ssxv2FY4hugGxc4QHtdtk4hx6W6OFslXiHrntJ/xJeYte
 FlKETbVnvfDIFtiWNgUZSMcfZh8F4jXyEYJgKpn5SGHxMKalXj
 5mQ6tGkLEwvNQNbNP0a/+AOxk/5tgHdQyO6EtZU4AE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds lightweight condition variables to the kernel to reduce 
complexity and improve the efficiency of some synchronisation tasks. 
They are very similar to POSIX condition variables.

Take the following code as an example. It is from 
drivers/usb/host/uhci-hcd.c, and this is how it looks at the moment:

/* Wait until a particular device/endpoint's QH is idle, and free it */
static void uhci_hcd_endpoint_disable(struct usb_hcd *hcd,
                 struct usb_host_endpoint *hep)
{
         struct uhci_hcd *uhci = hcd_to_uhci(hcd);
         struct uhci_qh *qh;

         spin_lock_irq(&uhci->lock);
         qh = (struct uhci_qh *) hep->hcpriv;
         if (qh == NULL)
                 goto done;

         while (qh->state != QH_STATE_IDLE) {
                 ++uhci->num_waiting;
                 spin_unlock_irq(&uhci->lock);
                 wait_event_interruptible(uhci->waitqh,
                                 qh->state == QH_STATE_IDLE);
                 spin_lock_irq(&uhci->lock);
                 --uhci->num_waiting;
         }

         uhci_free_qh(uhci, qh);
done:
         spin_unlock_irq(&uhci->lock);
}


The spinlock is needed to make sure that although several threads may 
unblock from the wait_event, only one of them can be calling 
uhci_free_qh at a time.

The condition here is qh->state and it has to be tested in two different 
places. Combining the condition and the wait into a single entity makes 
the code cleaner and faster, as shown below:

/* Wait until a particular device/endpoint's QH is idle, and free it */
static void uhci_hcd_endpoint_disable(struct usb_hcd *hcd,
                 struct usb_host_endpoint *hep)
{
         struct uhci_hcd *uhci = hcd_to_uhci(hcd);
         struct uhci_qh *qh;

         spin_lock_irq(&uhci->lock);
         qh = (struct uhci_qh *) hep->hcpriv;
         if (qh == NULL)
                 goto done;

         while (qh->state != QH_STATE_IDLE) {
                 ++uhci->num_waiting;
		cond_wait_spinlock_irq (uhci->waitqh, &uhci->lock);
                 --uhci->num_waiting;
         }

         uhci_free_qh(uhci, qh);
done:
         spin_unlock_irq(&uhci->lock);
}


Now the test on qh->state is done in one place only. The function 
cond_wait_spinlock_irq takes a locked spin_lock_irq and releases it 
after the thread is sleeping. When it wakes up it re-acquires the 
spinlock so the state is the same when you get back to the caller.

To wake up a thread sleeping on a condition variable you just use the 
normal wakeup calls, nothing new there. Except of course that you need 
to consider the locking round the variables (condition) that was just 
modified, but that should be in place already. There are many other 
examples in the code which could be improved in this way.

The patch that follows implements condition variables using mutexes and 
various sorts of spinlock as the locking primitive. I am aware that I 
have not covered all possibilities and that the code could be neater. At 
this point I just want to show the idea and get feedback.


diff --git a/include/linux/wait.h b/include/linux/wait.h
index 3efc9f3..76f9c25 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -662,7 +662,89 @@ static inline int wait_on_bit_lock(void *word, int bit,
  		return 0;
  	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
  }
-	
+
+/**
+ * cond_wait - wait for a condition variable
+ * @wq: the wait queue to wait on
+ * @mutex: a locked mutex
+ *
+ * Safely put the calling task into a non-interruptible sleep on the
+ * wait queue then unlock the mutex. Re-acquire the mutex after waking up
+ */
+void cond_wait (wait_queue_head_t *wq, struct mutex *mutex)
+{
+	DEFINE_WAIT(__wait);
+
+	prepare_to_wait(wq, &__wait, TASK_UNINTERRUPTIBLE);
+	mutex_unlock (mutex);
+	schedule();
+	mutex_lock (mutex);
+	finish_wait(wq, &__wait);
+}
+
+/**
+ * cond_wait_interruptible - wait for a condition variable
+ * @wq: the wait queue to wait on
+ * @mutex: a locked mutex
+ *
+ * Safely put the calling task into an interruptible sleep on the
+ * wait queue then unlock the mutex. Re-acquire the mutex after waking up
+ */
+int cond_wait_interruptible (wait_queue_head_t *wq, struct mutex *mutex)
+{
+	int ret = 0;
+	DEFINE_WAIT(__wait);
+
+	prepare_to_wait(wq, &__wait, TASK_INTERRUPTIBLE);
+	mutex_unlock (mutex);
+	if (signal_pending(current))
+		ret = -ERESTARTSYS;
+	else
+		schedule();
+	mutex_lock (mutex);
+	finish_wait(wq, &__wait);
+	return ret;
+}
+
+/**
+ * cond_wait_spinlock - wait for a condition variable
+ * @wq: the wait queue to wait on
+ * @sl: a locked spinlock
+ *
+ * Safely put the calling task into an interruptible sleep on the
+ * wait queue then unlock the spinlock. Re-acquire after waking up
+ */
+void cond_wait_spinlock (wait_queue_head_t *wq, spinlock_t *sl)
+{
+	DEFINE_WAIT(__wait);
+
+	prepare_to_wait(wq, &__wait, TASK_UNINTERRUPTIBLE);
+	spin_unlock (sl);
+	schedule();
+	spin_lock (sl);
+	finish_wait(wq, &__wait);
+}
+
+/**
+ * cond_wait_spinlock_irq - wait for a condition variable
+ * @wq: the wait queue to wait on
+ * @sl: a locked spinlock
+ *
+ * Safely put the calling task into an interruptible sleep on the
+ * wait queue then unlock the spinlock and enable irqs. Re-acquire
+ * spinlock and disable irqs after waking up
+ */
+void cond_wait_spinlock_irq (wait_queue_head_t *wq, spinlock_t *sl)
+{
+	DEFINE_WAIT(__wait);
+
+	prepare_to_wait(wq, &__wait, TASK_UNINTERRUPTIBLE);
+	spin_unlock_irq (sl);
+	schedule();
+	spin_lock_irq (sl);
+	finish_wait(wq, &__wait);
+}
+
  #endif /* __KERNEL__ */

  #endif



