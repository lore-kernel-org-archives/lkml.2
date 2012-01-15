Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2AOOEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 09:04:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:36590 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753258Ab2AOOEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 09:04:51 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+qFRFNde+qUd6P475WZTCoC0lasX/G1rhAcWIGEb
	tWPewe7zplfjsr
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
From: Mike Galbraith <efault@gmx.de>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1326635168.6352.88.camel@marge.simson.net>
References: <20111108191149.GA7236@sgi.com>
	 <1326635168.6352.88.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Jan 2012 15:04:40 +0100
Message-ID: <1326636280.6352.98.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-15 at 14:46 +0100, Mike Galbraith wrote:
> On Tue, 2011-11-08 at 13:11 -0600, Dimitri Sivanich wrote:
> > Resending this.
> > 
> > 
> > Allow manual override of the tick_do_timer_cpu.
> 
> Bigger button below.
> 
> > While not necessarily harmful, doing jiffies updates on an application cpu
> > does cause some extra overhead that HPC benchmarking people notice.  They
> > prefer to have OS activity isolated to certain cpus.  They like reproducibility
> > of results, and having jiffies updates bouncing around introduces variability.
> 
> 
> > +#ifdef CONFIG_NO_HZ
> > +	/* nohz mode not supported */
> > +	if (tick_nohz_enabled)
> > +		return -EINVAL;
> > +#endif
> 
> Uhuh, we have something in common, your HPC folks don't like NO_HZ
> because it makes loads of jitter, my RT jitter test proggy hates it to
> pieces for the same reason.  I can't just config it out like you though.
> 
> Aside: how come your HPC folks aren't griping about (SGI monster) boxen
> ticking all at the same time?  That makes my 64 core box jitter plenty.

P.S.

Using SGI and RT in the same message reminded me.  I have the below in
my 3.0-rt tree, and 32 core UV100 box works fine.  Wish I had a UV2 to
try out, the old (allegedly single digit s/n) UV1 is kinda slow.
Anyway, this patch is against mainline + preempt_rt FWIW.

rt,UV: rt conversion

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 arch/x86/include/asm/uv/uv_bau.h   |   12 ++++++------
 arch/x86/kernel/apic/x2apic_uv_x.c |    6 +++---
 arch/x86/platform/uv/tlb_uv.c      |   18 +++++++++---------
 arch/x86/platform/uv/uv_time.c     |   21 +++++++++++++--------
 4 files changed, 31 insertions(+), 26 deletions(-)

--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -518,8 +518,8 @@ struct bau_control {
 	unsigned short		uvhub_quiesce;
 	short			socket_acknowledge_count[DEST_Q_SIZE];
 	cycles_t		send_message;
-	spinlock_t		uvhub_lock;
-	spinlock_t		queue_lock;
+	raw_spinlock_t		uvhub_lock;
+	raw_spinlock_t		queue_lock;
 	/* tunables */
 	int			max_concurr;
 	int			max_concurr_const;
@@ -670,15 +670,15 @@ static inline int atom_asr(short i, stru
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
 
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -56,7 +56,7 @@ int uv_min_hub_revision_id;
 EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
 unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
-static DEFINE_SPINLOCK(uv_nmi_lock);
+static DEFINE_RAW_SPINLOCK(uv_nmi_lock);
 
 static struct apic apic_x2apic_uv_x;
 
@@ -707,10 +707,10 @@ int uv_handle_nmi(unsigned int reason, s
 	 * Use a lock so only one cpu prints at a time.
 	 * This prevents intermixed output.
 	 */
-	spin_lock(&uv_nmi_lock);
+	raw_spin_lock(&uv_nmi_lock);
 	pr_info("UV NMI stack dump cpu %u:\n", smp_processor_id());
 	dump_stack();
-	spin_unlock(&uv_nmi_lock);
+	raw_spin_unlock(&uv_nmi_lock);
 
 	return NMI_HANDLED;
 }
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -39,7 +39,7 @@ static int timeout_base_ns[] = {
 static int timeout_us;
 static int nobau;
 static int baudisabled;
-static spinlock_t disable_lock;
+static raw_spinlock_t disable_lock;
 static cycles_t congested_cycles;
 
 /* tunables: */
@@ -608,9 +608,9 @@ static void destination_plugged(struct b
 
 		quiesce_local_uvhub(hmaster);
 
-		spin_lock(&hmaster->queue_lock);
+		raw_spin_lock(&hmaster->queue_lock);
 		reset_with_ipi(&bau_desc->distribution, bcp);
-		spin_unlock(&hmaster->queue_lock);
+		raw_spin_unlock(&hmaster->queue_lock);
 
 		end_uvhub_quiesce(hmaster);
 
@@ -630,9 +630,9 @@ static void destination_timeout(struct b
 
 		quiesce_local_uvhub(hmaster);
 
-		spin_lock(&hmaster->queue_lock);
+		raw_spin_lock(&hmaster->queue_lock);
 		reset_with_ipi(&bau_desc->distribution, bcp);
-		spin_unlock(&hmaster->queue_lock);
+		raw_spin_unlock(&hmaster->queue_lock);
 
 		end_uvhub_quiesce(hmaster);
 
@@ -649,7 +649,7 @@ static void disable_for_congestion(struc
 					struct ptc_stats *stat)
 {
 	/* let only one cpu do this disabling */
-	spin_lock(&disable_lock);
+	raw_spin_lock(&disable_lock);
 
 	if (!baudisabled && bcp->period_requests &&
 	    ((bcp->period_time / bcp->period_requests) > congested_cycles)) {
@@ -668,7 +668,7 @@ static void disable_for_congestion(struc
 		}
 	}
 
-	spin_unlock(&disable_lock);
+	raw_spin_unlock(&disable_lock);
 }
 
 static void count_max_concurr(int stat, struct bau_control *bcp,
@@ -717,7 +717,7 @@ static void record_send_stats(cycles_t t
  */
 static void uv1_throttle(struct bau_control *hmaster, struct ptc_stats *stat)
 {
-	spinlock_t *lock = &hmaster->uvhub_lock;
+	raw_spinlock_t *lock = &hmaster->uvhub_lock;
 	atomic_t *v;
 
 	v = &hmaster->active_descriptor_count;
@@ -1835,7 +1835,7 @@ static int __init uv_bau_init(void)
 	}
 
 	nuvhubs = uv_num_possible_blades();
-	spin_lock_init(&disable_lock);
+	raw_spin_lock_init(&disable_lock);
 	congested_cycles = usec_2_cycles(congested_respns_us);
 
 	uv_base_pnode = 0x7fffffff;
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
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
 
+	migrate_disable();
 	if (uv_get_min_hub_revision_id() == 1)
 		offset = 0;
 	else
 		offset = (uv_blade_processor_id() * L1_CACHE_BYTES) % PAGE_SIZE;
 
-	return (cycle_t)uv_read_local_mmr(UVH_RTC | offset);
+	cycles = (cycle_t)uv_read_local_mmr(UVH_RTC | offset);
+	migrate_enable();
+
+	return cycles;
 }
 
 /*


