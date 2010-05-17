Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0EQI2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:28:22 -0400
Received: from www.tglx.de ([62.245.132.106]:60641 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab0EQI2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:28:20 -0400
Date: Mon, 17 May 2010 10:28:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olaf Hering <olaf@aepfle.de>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: qemu/nfsroot: BUG: sleeping function called from invalid context
 at 2.6.33.3-rt19-i686-pc/kernel/rtmutex.c:684
In-Reply-To: <20100516213333.GA27132@aepfle.de>
Message-ID: <alpine.LFD.2.00.1005171018100.3368@localhost.localdomain>
References: <20100516213333.GA27132@aepfle.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 May 2010, Olaf Hering wrote:
> 
> Running 2.6.33.3-rt19 in qemu with nfsroot floods dmesg with lots of
> warnings like
> 
> BUG: sleeping function called from invalid context at /opt/cross/sys-root/i686-linux/usr/src/linux-2.6.33-i686-kernel-source/kernel/rtmutex.c:684
> 
> This happens already when the kernel mounts the nfsroot filesystem,
> if I interpret the dmesg output below correctly.
> 
> Any idea how to fix the reported BUG?

Yup, patch below should do the trick. It fixes the other user of this
as well.

Thanks,

	tglx
---
Subject: net-8139-rt.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 17 May 2010 10:19:06 +0200

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -246,7 +246,7 @@ static inline int irq_select_affinity(un
 static inline void disable_irq_nosync_lockdep(unsigned int irq)
 {
 	disable_irq_nosync(irq);
-#ifdef CONFIG_LOCKDEP
+#if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PREEMPT_RT)
 	local_irq_disable();
 #endif
 }
@@ -254,7 +254,7 @@ static inline void disable_irq_nosync_lo
 static inline void disable_irq_nosync_lockdep_irqsave(unsigned int irq, unsigned long *flags)
 {
 	disable_irq_nosync(irq);
-#ifdef CONFIG_LOCKDEP
+#if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PREEMPT_RT)
 	local_irq_save(*flags);
 #endif
 }
@@ -262,14 +262,14 @@ static inline void disable_irq_nosync_lo
 static inline void disable_irq_lockdep(unsigned int irq)
 {
 	disable_irq(irq);
-#ifdef CONFIG_LOCKDEP
+#if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PREEMPT_RT)
 	local_irq_disable();
 #endif
 }
 
 static inline void enable_irq_lockdep(unsigned int irq)
 {
-#ifdef CONFIG_LOCKDEP
+#if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PREEMPT_RT)
 	local_irq_enable();
 #endif
 	enable_irq(irq);
@@ -277,7 +277,7 @@ static inline void enable_irq_lockdep(un
 
 static inline void enable_irq_lockdep_irqrestore(unsigned int irq, unsigned long *flags)
 {
-#ifdef CONFIG_LOCKDEP
+#if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PREEMPT_RT)
 	local_irq_restore(*flags);
 #endif
 	enable_irq(irq);
