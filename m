Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030337Ab2GKWFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:05:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:35509 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030306Ab2GKWFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:05:21 -0400
Message-Id: <20120711215612.055300422@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 11 Jul 2012 22:05:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        RT-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <cbe@osadl.org>
Subject: [patch RT 5/7] slab: Prevent local lock deadlock
References: <20120711214552.036760674@linutronix.de>
Content-Disposition: inline; filename=slab-fix-local-lock-wreckage.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On RT we avoid the cross cpu function calls and take the per cpu local
locks instead. Now the code missed that taking the local lock on the
cpu which runs the code must use the proper local lock functions and
not a simple spin_lock(). Otherwise it deadlocks later when trying to
acquire the local lock with the proper function.

Reported-and-tested-by: Chris Pringle <chris.pringle@miranda.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 mm/slab.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

Index: linux-stable-rt/mm/slab.c
===================================================================
--- linux-stable-rt.orig/mm/slab.c
+++ linux-stable-rt/mm/slab.c
@@ -743,8 +743,26 @@ slab_on_each_cpu(void (*func)(void *arg,
 {
 	unsigned int i;
 
+	get_cpu_light();
 	for_each_online_cpu(i)
 		func(arg, i);
+	put_cpu_light();
+}
+
+static void lock_slab_on(unsigned int cpu)
+{
+	if (cpu == smp_processor_id())
+		local_lock_irq(slab_lock);
+	else
+		local_spin_lock_irq(slab_lock, &per_cpu(slab_lock, cpu).lock);
+}
+
+static void unlock_slab_on(unsigned int cpu)
+{
+	if (cpu == smp_processor_id())
+		local_unlock_irq(slab_lock);
+	else
+		local_spin_unlock_irq(slab_lock, &per_cpu(slab_lock, cpu).lock);
 }
 #endif
 
@@ -2692,10 +2710,10 @@ static void do_drain(void *arg, int cpu)
 {
 	LIST_HEAD(tmp);
 
-	spin_lock_irq(&per_cpu(slab_lock, cpu).lock);
+	lock_slab_on(cpu);
 	__do_drain(arg, cpu);
 	list_splice_init(&per_cpu(slab_free_list, cpu), &tmp);
-	spin_unlock_irq(&per_cpu(slab_lock, cpu).lock);
+	unlock_slab_on(cpu);
 	free_delayed(&tmp);
 }
 #endif
@@ -4163,9 +4181,9 @@ static void do_ccupdate_local(void *info
 #else
 static void do_ccupdate_local(void *info, int cpu)
 {
-	spin_lock_irq(&per_cpu(slab_lock, cpu).lock);
+	lock_slab_on(cpu);
 	__do_ccupdate_local(info, cpu);
-	spin_unlock_irq(&per_cpu(slab_lock, cpu).lock);
+	unlock_slab_on(cpu);
 }
 #endif
 


