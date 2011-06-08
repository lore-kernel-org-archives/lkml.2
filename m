Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1FHU2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:28:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47340 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1FHU2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:28:31 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arne Jansen <lists@die-jansens.de>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, npiggin@kernel.dk, akpm@linux-foundation.org,
        frank.rowand@am.sony.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <BANLkTim8LY0ekPQNZasUbinKcvS78y_umw@mail.gmail.com>
References: <20110606155236.GA7374@elte.hu>
	 <1307376039.2322.164.camel@twins> <20110606160810.GA16636@elte.hu>
	 <1307376771.2322.168.camel@twins> <20110606161749.GA22157@elte.hu>
	 <4DED0292.1040605@die-jansens.de> <4DED0423.4050904@die-jansens.de>
	 <20110606170725.GD2391@elte.hu> <1307380311.2322.223.camel@twins>
	 <1307548218.3941.6.camel@twins> <20110608191758.GA12457@elte.hu>
	 <BANLkTim8LY0ekPQNZasUbinKcvS78y_umw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 22:32:05 +0200
Message-ID: <1307565125.2497.1003.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 12:27 -0700, Linus Torvalds wrote:
> Make some kind of
> 
>   void atomic_down();
>   int atomic_down_trylock();
>   void atomic_up(); 

atomic_down() is a tad iffy, it would have to wait for an actual
semaphore owner, which might sleep etc.. So I skipped it.

The other two are implemented here, and assume IRQs are disabled, we
could add _irq and _irqsave versions of both, but since there are no
users I avoided the effort.

---
 include/linux/semaphore.h |    3 +++
 kernel/semaphore.c        |   36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/semaphore.h
===================================================================
--- linux-2.6.orig/include/linux/semaphore.h
+++ linux-2.6/include/linux/semaphore.h
@@ -43,4 +43,7 @@ extern int __must_check down_trylock(str
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
 extern void up(struct semaphore *sem);
 
+extern int atomic_down_trylock(struct semaphore *sem);
+extern void atomic_up(struct semaphore *sem);
+
 #endif /* __LINUX_SEMAPHORE_H */
Index: linux-2.6/kernel/semaphore.c
===================================================================
--- linux-2.6.orig/kernel/semaphore.c
+++ linux-2.6/kernel/semaphore.c
@@ -118,7 +118,7 @@ EXPORT_SYMBOL(down_killable);
  * down_trylock - try to acquire the semaphore, without waiting
  * @sem: the semaphore to be acquired
  *
- * Try to acquire the semaphore atomically.  Returns 0 if the mutex has
+ * Try to acquire the semaphore atomically.  Returns 0 if the semaphore has
  * been acquired successfully or 1 if it it cannot be acquired.
  *
  * NOTE: This return value is inverted from both spin_trylock and
@@ -143,6 +143,29 @@ int down_trylock(struct semaphore *sem)
 EXPORT_SYMBOL(down_trylock);
 
 /**
+ * atomic_down_trylock - try to acquire the semaphore internal lock
+ * #sem: the semaphore to be acquired
+ *
+ * Try to acquire the semaphore internal lock, blocking all other semaphore
+ * operations. Returns 0 if the trylock has been acquired successfully or
+ * 1 if it cannot be acquired.
+ *
+ * NOTE: This return value is inverted from both spin_trylock and
+ * mutex_trylock!  Be careful about this when converting code.
+ *
+ * NOTE: assumes IRQs are disabled.
+ */
+int atomic_down_trylock(struct semaphore *sem)
+{
+	spin_lock(&sem->lock);
+	if (sem->count > 0)
+		return 0;
+
+	spin_unlock(&sem->lock);
+	return 1;
+}
+
+/**
  * down_timeout - acquire the semaphore within a specified time
  * @sem: the semaphore to be acquired
  * @jiffies: how long to wait before failing
@@ -188,6 +211,17 @@ void up(struct semaphore *sem)
 }
 EXPORT_SYMBOL(up);
 
+/**
+ * atomic_up - release the semaphore internal lock
+ * @sem: the semaphore to release the internal lock of
+ *
+ * Release the semaphore internal lock.
+ */
+void atomic_up(struct semaphore *sem)
+{
+	spin_unlock(&sem->lock);
+}
+
 /* Functions for the contended case */
 
 struct semaphore_waiter {


