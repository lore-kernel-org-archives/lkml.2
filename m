Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2GRWm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:42:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8344 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab2GRWj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:39:59 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=0H48k7OL8AoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=UZRvmTwgAAAA:8 a=0usFPS_H11ZFgFd2w40A:9 a=Zh68SRI7RUMA:10 a=F6qNFXbwvZAA:10 a=jeBq3FmKZ4MA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120718223957.856443728@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 18 Jul 2012 18:39:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 05/12] slab: Prevent local lock deadlock
References: <20120718223910.898476857@goodmis.org>
Content-Disposition: inline; filename=0005-slab-Prevent-local-lock-deadlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

On RT we avoid the cross cpu function calls and take the per cpu local
locks instead. Now the code missed that taking the local lock on the
cpu which runs the code must use the proper local lock functions and
not a simple spin_lock(). Otherwise it deadlocks later when trying to
acquire the local lock with the proper function.

Reported-and-tested-by: Chris Pringle <chris.pringle@miranda.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/slab.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 5251b99..827e2d6 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -737,8 +737,26 @@ slab_on_each_cpu(void (*func)(void *arg, int this_cpu), void *arg)
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
 
@@ -2625,10 +2643,10 @@ static void do_drain(void *arg, int cpu)
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
@@ -4099,9 +4117,9 @@ static void do_ccupdate_local(void *info)
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
 
-- 
1.7.10.4


