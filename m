Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1HMLtB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 07:49:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58561 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751270Ab1HMLs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 07:48:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+8YkYJp7K81o8lBTNRC/5KwMn9N8GAIo9hCuOWR/
	4+psPc3AbM0SMn
Subject: Re: [ANNOUNCE] 3.0.1-rt11
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1313232790.25267.7.camel@twins>
References: <1313232790.25267.7.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 13:48:54 +0200
Message-ID: <1313236135.4486.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-13 at 12:53 +0200, Peter Zijlstra wrote:
> Whee, I can skip release announcements too!
> 
> So no the subject ain't no mistake its not, 3.0.1-rt11 is there for the
> grabs.
> 
> Changes include (including the missing -rt10):
> 
>   - hrtimer fix that should make RT_GROUP work again
>   - RCU fixes that should make the RCU stalls go away

Oh goodie, I was just looking at some of those.

coverdale:/abuild/mike/linux-3.0-rt/:[1]# wget http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt11.tar.bz2
--2011-08-13 13:38:13--  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt11.tar.bz2
Resolving www.kernel.org... 130.239.17.5, 199.6.1.165, 2001:6b0:e:4017:1994:313:1:0, ...
Connecting to www.kernel.org|130.239.17.5|:80... connected.
HTTP request sent, awaiting response... 404 Not Found
2011-08-13 13:38:13 ERROR 404: Not Found.

Aw poo.  Darn mirrors.

This (not-signed-off-by, etc) patchlet gets -rt9 booting gripe free on
UV100 box.  Well, gripe free unless you turn on spinlock debugging that
is.  I haven't found where uvhub_lock and queue_lock are initialized.

[   24.640574] BUG: spinlock bad magic on CPU#29, init/235
[   24.640580]  lock: ffff8813ffc0b008, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[   24.640587] Pid: 235, comm: init Not tainted 3.0.1-rt9 #3


---
 arch/x86/include/asm/uv/uv_bau.h   |   10 +++++-----
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 +++---
 arch/x86/platform/uv/tlb_uv.c      |    2 +-
 arch/x86/platform/uv/uv_time.c     |   21 +++++++++++++--------
 4 files changed, 22 insertions(+), 17 deletions(-)

Index: linux-3.0-rt/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linux-3.0-rt.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linux-3.0-rt/arch/x86/include/asm/uv/uv_bau.h
@@ -508,7 +508,7 @@ struct bau_control {
 	unsigned short		uvhub_quiesce;
 	short			socket_acknowledge_count[DEST_Q_SIZE];
 	cycles_t		send_message;
-	spinlock_t		uvhub_lock;
+	raw_spinlock_t		uvhub_lock;
 	spinlock_t		queue_lock;
 	/* tunables */
 	int			max_concurr;
@@ -664,15 +664,15 @@ static inline int atom_asr(short i, stru
  * to be lowered below the current 'v'.  atomic_add_unless can only stop
  * on equal.
  */
-static inline int atomic_inc_unless_ge(spinlock_t *lock, atomic_t *v, int u)
+static inline int atomic_inc_unless_ge(raw_spinlock_t *lock, atomic_t *v, int u)
 {
-	spin_lock(lock);
+	raw_spin_lock(lock);
 	if (atomic_read(v) >= u) {
-		spin_unlock(lock);
+		raw_spin_unlock(lock);
 		return 0;
 	}
 	atomic_inc(v);
-	spin_unlock(lock);
+	raw_spin_unlock(lock);
 	return 1;
 }
 
Index: linux-3.0-rt/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux-3.0-rt.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux-3.0-rt/arch/x86/platform/uv/tlb_uv.c
@@ -712,7 +712,7 @@ static void record_send_stats(cycles_t t
  */
 static void uv1_throttle(struct bau_control *hmaster, struct ptc_stats *stat)
 {
-	spinlock_t *lock = &hmaster->uvhub_lock;
+	raw_spinlock_t *lock = &hmaster->uvhub_lock;
 	atomic_t *v;
 
 	v = &hmaster->active_descriptor_count;
Index: linux-3.0-rt/arch/x86/platform/uv/uv_time.c
===================================================================
--- linux-3.0-rt.orig/arch/x86/platform/uv/uv_time.c
+++ linux-3.0-rt/arch/x86/platform/uv/uv_time.c
@@ -58,7 +58,7 @@ static DEFINE_PER_CPU(struct clock_event
 
 /* There is one of these allocated per node */
 struct uv_rtc_timer_head {
-	spinlock_t	lock;
+	raw_spinlock_t	lock;
 	/* next cpu waiting for timer, local node relative: */
 	int		next_cpu;
 	/* number of cpus on this node: */
@@ -178,7 +178,7 @@ static __init int uv_rtc_allocate_timers
 				uv_rtc_deallocate_timers();
 				return -ENOMEM;
 			}
-			spin_lock_init(&head->lock);
+			raw_spin_lock_init(&head->lock);
 			head->ncpus = uv_blade_nr_possible_cpus(bid);
 			head->next_cpu = -1;
 			blade_info[bid] = head;
@@ -232,7 +232,7 @@ static int uv_rtc_set_timer(int cpu, u64
 	unsigned long flags;
 	int next_cpu;
 
-	spin_lock_irqsave(&head->lock, flags);
+	raw_spin_lock_irqsave(&head->lock, flags);
 
 	next_cpu = head->next_cpu;
 	*t = expires;
@@ -244,12 +244,12 @@ static int uv_rtc_set_timer(int cpu, u64
 		if (uv_setup_intr(cpu, expires)) {
 			*t = ULLONG_MAX;
 			uv_rtc_find_next_timer(head, pnode);
-			spin_unlock_irqrestore(&head->lock, flags);
+			raw_spin_unlock_irqrestore(&head->lock, flags);
 			return -ETIME;
 		}
 	}
 
-	spin_unlock_irqrestore(&head->lock, flags);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
 	return 0;
 }
 
@@ -268,7 +268,7 @@ static int uv_rtc_unset_timer(int cpu, i
 	unsigned long flags;
 	int rc = 0;
 
-	spin_lock_irqsave(&head->lock, flags);
+	raw_spin_lock_irqsave(&head->lock, flags);
 
 	if ((head->next_cpu == bcpu && uv_read_rtc(NULL) >= *t) || force)
 		rc = 1;
@@ -280,7 +280,7 @@ static int uv_rtc_unset_timer(int cpu, i
 			uv_rtc_find_next_timer(head, pnode);
 	}
 
-	spin_unlock_irqrestore(&head->lock, flags);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
 
 	return rc;
 }
@@ -300,13 +300,18 @@ static int uv_rtc_unset_timer(int cpu, i
 static cycle_t uv_read_rtc(struct clocksource *cs)
 {
 	unsigned long offset;
+	cycle_t cycles;
 
+	preempt_disable();
 	if (uv_get_min_hub_revision_id() == 1)
 		offset = 0;
 	else
 		offset = (uv_blade_processor_id() * L1_CACHE_BYTES) % PAGE_SIZE;
 
-	return (cycle_t)uv_read_local_mmr(UVH_RTC | offset);
+	cycles = (cycle_t)uv_read_local_mmr(UVH_RTC | offset);
+	__preempt_enable_no_resched();
+
+	return cycles;
 }
 
 /*
Index: linux-3.0-rt/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux-3.0-rt.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux-3.0-rt/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -56,7 +56,7 @@ int uv_min_hub_revision_id;
 EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
 unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
-static DEFINE_SPINLOCK(uv_nmi_lock);
+static DEFINE_RAW_SPINLOCK(uv_nmi_lock);
 
 static struct apic apic_x2apic_uv_x;
 
@@ -713,10 +713,10 @@ int uv_handle_nmi(struct notifier_block
 	 * Use a lock so only one cpu prints at a time.
 	 * This prevents intermixed output.
 	 */
-	spin_lock(&uv_nmi_lock);
+	raw_spin_lock(&uv_nmi_lock);
 	pr_info("UV NMI stack dump cpu %u:\n", smp_processor_id());
 	dump_stack();
-	spin_unlock(&uv_nmi_lock);
+	raw_spin_unlock(&uv_nmi_lock);
 
 	return NOTIFY_STOP;
 }


