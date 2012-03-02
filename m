Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524Ab2CBOh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:37:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59875 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab2CBOhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:37:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kernel.org.gnu@gmail.com designates 10.112.101.40 as permitted sender) smtp.mail=kernel.org.gnu@gmail.com; dkim=pass header.i=kernel.org.gnu@gmail.com
MIME-Version: 1.0
Date: Fri, 2 Mar 2012 22:37:23 +0800
Message-ID: <CA+U0gVgpyWvYTC+Ou0S2DN=wc2RU7o6pfs_TkpvVq+YAjZihdQ@mail.gmail.com>
Subject: [PATCH] adjust the spin_lock_ pairs in down family functions (semaphore)
From: Dennis Chen <kernel.org.gnu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current down family functions use mismatch spin_lock pairs, this will
incur some interrupt state chaos, for example,
down_interruptible --
    spin_lock_irqsave(&sem->lock, flags);              P1
          __down_common--
                spin_unlock_irq(&sem->lock);              P2
               timeout = schedule_timeout(timeout);
               spin_lock_irq(&sem->lock);                  P3

    spin_unlock_irqrestore(&sem->lock, flags);       P4

Suppose 2 kernel thread A and B in an UP system call
down_interruptible to get the semaphore, if the irq is _OFF_ before A
calls, in the section between P2 and P3,  the irq will be turned _ON_,
then B begins to call down_interruptible, it will save a flag
indicating irq is _ON_. So after A finish the path of
down_interruptible, the irq is still _OFF_, but when B wakes up and
finish the path, the irq will be _ON_. Actually, irq should be in on
state before any down_interruptible calling, so
spin_lock_irqsave/irqrestore is not necessary. Given it will make
confusion for the reason of unmatched spin_lock pairs between
down_interruptible and __down_common, so it's reason for the patch.
Any comments?

--- semaphore.bak.c     2012-03-02 21:37:50.510302064 +0800
+++ semaphore.c 2012-03-02 21:46:32.330269122 +0800
@@ -54,12 +54,12 @@
 {
       unsigned long flags;

-       raw_spin_lock_irqsave(&sem->lock, flags);
+       raw_spin_lock_irq(&sem->lock, flags);
       if (likely(sem->count > 0))
               sem->count--;
       else
               __down(sem);
-       raw_spin_unlock_irqrestore(&sem->lock, flags);
+       raw_spin_unlock_irq(&sem->lock, flags);
 }
 EXPORT_SYMBOL(down);

@@ -77,12 +77,12 @@
       unsigned long flags;
       int result = 0;

-       raw_spin_lock_irqsave(&sem->lock, flags);
+       raw_spin_lock_irq(&sem->lock, flags);
       if (likely(sem->count > 0))
               sem->count--;
       else
               result = __down_interruptible(sem);
-       raw_spin_unlock_irqrestore(&sem->lock, flags);
+       raw_spin_unlock_irq(&sem->lock, flags);

       return result;
 }
@@ -103,12 +103,12 @@
       unsigned long flags;
       int result = 0;

-       raw_spin_lock_irqsave(&sem->lock, flags);
+       raw_spin_lock_irq(&sem->lock, flags);
       if (likely(sem->count > 0))
               sem->count--;
       else
               result = __down_killable(sem);
-       raw_spin_unlock_irqrestore(&sem->lock, flags);
+       raw_spin_unlock_irq(&sem->lock, flags);

       return result;
 }
@@ -157,12 +157,12 @@
       unsigned long flags;
       int result = 0;

-       raw_spin_lock_irqsave(&sem->lock, flags);
+       raw_spin_lock_irq(&sem->lock, flags);
       if (likely(sem->count > 0))
               sem->count--;
       else
               result = __down_timeout(sem, jiffies);
-       raw_spin_unlock_irqrestore(&sem->lock, flags);
+       raw_spin_unlock_irq(&sem->lock, flags);

       return result;
 }
