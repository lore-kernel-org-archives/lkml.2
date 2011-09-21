Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1IUSvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:51:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:58841 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1IUSu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:50:58 -0400
Subject: Re: rt14: strace ->  migrate_disable_atomic imbalance
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, mingo <mingo@redhat.com>
Date: Wed, 21 Sep 2011 20:50:37 +0200
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net> <1315930430.5977.21.camel@twins>
	 <1316600230.6628.6.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316631037.24750.39.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 19:01 +0200, Peter Zijlstra wrote:
> On Wed, 2011-09-21 at 12:17 +0200, Mike Galbraith wrote:
> > [  144.212272] ------------[ cut here ]------------
> > [  144.212280] WARNING: at kernel/sched.c:6152 migrate_disable+0x1b6/0x200()
> > [  144.212282] Hardware name: MS-7502
> > [  144.212283] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfsd lockd parport_pc parport nfs_acl auth_rpcgss sunrpc bridge ipv6 stp cpufreq_conservative microcode cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf nls_iso8859_1 nls_cp437 vfat fat fuse ext3 jbd dm_mod usbmouse usb_storage usbhid snd_hda_codec_realtek usb_libusual uas sr_mod cdrom hid snd_hda_intel e1000e snd_hda_codec kvm_intel snd_hwdep sg snd_pcm kvm i2c_i801 snd_timer snd firewire_ohci firewire_core soundcore snd_page_alloc crc_itu_t button ext4 mbcache jbd2 crc16 uhci_hcd sd_mod ehci_hcd usbcore rtc_cmos ahci libahci libata scsi_mod fan processor thermal
> > [  144.212317] Pid: 6215, comm: strace Not tainted 3.0.4-rt14 #2052
> > [  144.212319] Call Trace:
> > [  144.212323]  [<ffffffff8104662f>] warn_slowpath_common+0x7f/0xc0
> > [  144.212326]  [<ffffffff8104668a>] warn_slowpath_null+0x1a/0x20
> > [  144.212328]  [<ffffffff8103f606>] migrate_disable+0x1b6/0x200
> > [  144.212331]  [<ffffffff8105a2a8>] ptrace_stop+0x128/0x240
> > [  144.212334]  [<ffffffff81057b9b>] ? recalc_sigpending+0x1b/0x50
> > [  144.212337]  [<ffffffff8105b6f1>] get_signal_to_deliver+0x211/0x530
> > [  144.212340]  [<ffffffff81001835>] do_signal+0x75/0x7a0
> > [  144.212342]  [<ffffffff8105ae68>] ? kill_pid_info+0x58/0x80
> > [  144.212344]  [<ffffffff8105c34c>] ? sys_kill+0xac/0x1e0
> > [  144.212347]  [<ffffffff81001fe5>] do_notify_resume+0x65/0x80
> > [  144.212350]  [<ffffffff8135978b>] int_signal+0x12/0x17
> > [  144.212352] ---[ end trace 0000000000000002 ]---
> 
> 
> Right, that's because of 
> 53da1d9456fe7f87a920a78fdbdcf1225d197cb7, I think we simply want a full
> revert of that for -rt.

This also made me stare at the trainwreck called wait_task_inactive(),
how about something like the below, it survives a boot and simple
strace.

I'm not particularly keen on always enabling preempt notifiers, but
seeing that pretty much world+dog already has them enabled...

Also, less LOC is always better, right ;-)

---
 arch/ia64/kvm/Kconfig    |    1 -
 arch/powerpc/kvm/Kconfig |    1 -
 arch/s390/kvm/Kconfig    |    1 -
 arch/tile/kvm/Kconfig    |    1 -
 arch/x86/kvm/Kconfig     |    1 -
 include/linux/kvm_host.h |    2 -
 include/linux/preempt.h  |    4 -
 include/linux/sched.h    |    2 -
 init/Kconfig             |    3 -
 kernel/sched.c           |  163 ++++++++++++++++++----------------------------
 10 files changed, 64 insertions(+), 115 deletions(-)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index 9806e55..02b36ca 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	depends on HAVE_KVM && MODULES && EXPERIMENTAL
 	# for device assignment:
 	depends on PCI
-	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
 	select KVM_APIC_ARCHITECTURE
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 78133de..0bcd5a8 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -18,7 +18,6 @@ if VIRTUALIZATION
 
 config KVM
 	bool
-	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 
 config KVM_BOOK3S_HANDLER
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index a216341..7ff8d54 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -19,7 +19,6 @@ config KVM
 	def_tristate y
 	prompt "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM && EXPERIMENTAL
-	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
 	  Support hosting paravirtualized guest machines using the SIE
diff --git a/arch/tile/kvm/Kconfig b/arch/tile/kvm/Kconfig
index 669fcdb..6a936d1 100644
--- a/arch/tile/kvm/Kconfig
+++ b/arch/tile/kvm/Kconfig
@@ -19,7 +19,6 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM && MODULES && EXPERIMENTAL
-	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
 	  Support hosting paravirtualized guest machines.
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ff5790d..d82150a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -24,7 +24,6 @@ config KVM
 	depends on PCI
 	# for TASKSTATS/TASK_DELAY_ACCT:
 	depends on NET
-	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eabb21a..a9343b8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -111,9 +111,7 @@ enum {
 
 struct kvm_vcpu {
 	struct kvm *kvm;
-#ifdef CONFIG_PREEMPT_NOTIFIERS
 	struct preempt_notifier preempt_notifier;
-#endif
 	int cpu;
 	int vcpu_id;
 	int srcu_idx;
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 58969b2..7ca8968 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -101,8 +101,6 @@ do { \
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-
 struct preempt_notifier;
 
 /**
@@ -147,6 +145,4 @@ static inline void preempt_notifier_init(struct preempt_notifier *notifier,
 	notifier->ops = ops;
 }
 
-#endif
-
 #endif /* __LINUX_PREEMPT_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e54c890..64fc7c7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1236,10 +1236,8 @@ struct task_struct {
 	struct sched_entity se;
 	struct sched_rt_entity rt;
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
 	struct hlist_head preempt_notifiers;
-#endif
 
 	/*
 	 * fpu_counter contains the number of consecutive context switches
diff --git a/init/Kconfig b/init/Kconfig
index d19b3a7..c1c411c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1403,9 +1403,6 @@ config STOP_MACHINE
 
 source "block/Kconfig"
 
-config PREEMPT_NOTIFIERS
-	bool
-
 config PADATA
 	depends on SMP
 	bool
diff --git a/kernel/sched.c b/kernel/sched.c
index db143fd..b38ab2e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2387,6 +2387,38 @@ struct migration_arg {
 
 static int migration_cpu_stop(void *data);
 
+struct wait_task_inactive_blocked {
+	struct preempt_notifier notifier;
+	struct task_struct *waiter;
+};
+
+static void wait_task_inactive_sched_in(struct preempt_notifier *n, int cpu)
+{
+	/* Dummy, could be called when preempted before sleeping */
+}
+
+static void wait_task_inactive_sched_out(struct preempt_notifier *n,
+		struct task_struct *next)
+{
+	struct task_struct *p;
+	struct wait_task_inactive_blocked *blocked = 
+		container_of(n, struct wait_task_inactive_blocked, notifier);
+
+	if (current->on_rq) /* we're not inactive yet */
+		return;
+
+	hlist_del(&n->link);
+
+	p = ACCESS_ONCE(blocked->waiter);
+	blocked->waiter = NULL;
+	wake_up_process(p);
+}
+
+static struct preempt_ops wait_task_inactive_ops = {
+	.sched_in = wait_task_inactive_sched_in,
+	.sched_out = wait_task_inactive_sched_out,
+};
+
 /*
  * wait_task_inactive - wait for a thread to unschedule.
  *
@@ -2405,93 +2437,45 @@ static int migration_cpu_stop(void *data);
  */
 unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 {
+	unsigned long ncsw = 0;
 	unsigned long flags;
-	int running, on_rq;
-	unsigned long ncsw;
 	struct rq *rq;
 
-	for (;;) {
-		/*
-		 * We do the initial early heuristics without holding
-		 * any task-queue locks at all. We'll only try to get
-		 * the runqueue lock when things look like they will
-		 * work out!
-		 */
-		rq = task_rq(p);
-
-		/*
-		 * If the task is actively running on another CPU
-		 * still, just relax and busy-wait without holding
-		 * any locks.
-		 *
-		 * NOTE! Since we don't hold any locks, it's not
-		 * even sure that "rq" stays as the right runqueue!
-		 * But we don't care, since "task_running()" will
-		 * return false if the runqueue has changed and p
-		 * is actually now running somewhere else!
-		 */
-		while (task_running(rq, p)) {
-			if (match_state && unlikely(p->state != match_state))
-				return 0;
-			cpu_relax();
-		}
-
-		/*
-		 * Ok, time to look more closely! We need the rq
-		 * lock now, to be *sure*. If we're wrong, we'll
-		 * just go back and repeat.
-		 */
-		rq = task_rq_lock(p, &flags);
-		trace_sched_wait_task(p);
-		running = task_running(rq, p);
-		on_rq = p->on_rq;
-		ncsw = 0;
-		if (!match_state || p->state == match_state)
-			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
-		task_rq_unlock(rq, p, &flags);
-
-		/*
-		 * If it changed from the expected state, bail out now.
-		 */
-		if (unlikely(!ncsw))
-			break;
+	struct wait_task_inactive_blocked blocked = {
+		.notifier = {
+			.ops = &wait_task_inactive_ops,
+		},
+		.waiter = current,
+	};
 
-		/*
-		 * Was it really running after all now that we
-		 * checked with the proper locks actually held?
-		 *
-		 * Oops. Go back and try again..
-		 */
-		if (unlikely(running)) {
-			cpu_relax();
-			continue;
-		}
+	rq = task_rq_lock(p, &flags);
+	if (!task_running(rq, p))
+		goto done;
 
-		/*
-		 * It's not enough that it's not actively running,
-		 * it must be off the runqueue _entirely_, and not
-		 * preempted!
-		 *
-		 * So if it was still runnable (but just not actively
-		 * running right now), it's preempted, and we should
-		 * yield - it could be a while.
-		 */
-		if (unlikely(on_rq)) {
-			ktime_t to = ktime_set(0, NSEC_PER_SEC/HZ);
+	if (match_state && unlikely(p->state != match_state))
+		goto unlock;
 
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_hrtimeout(&to, HRTIMER_MODE_REL);
-			continue;
-		}
+	hlist_add_head(&blocked.notifier.link, &p->preempt_notifiers);
+	task_rq_unlock(rq, p, &flags);
 
-		/*
-		 * Ahh, all good. It wasn't running, and it wasn't
-		 * runnable, which means that it will never become
-		 * running in the future either. We're all done!
-		 */
-		break;
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!blocked.waiter)
+			break;
+		schedule();
 	}
+	__set_current_state(TASK_RUNNING);
 
+	/*
+	 * Serializes against the completion of the previously observed context
+	 * switch.
+	 */
+	rq = task_rq_lock(p, &flags);
+done:
+	if (!match_state || p->state == match_state)
+		ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
+unlock:
+	task_rq_unlock(rq, p, &flags);
 	return ncsw;
 }
 
@@ -2967,10 +2951,7 @@ static void __sched_fork(struct task_struct *p)
 #endif
 
 	INIT_LIST_HEAD(&p->rt.run_list);
-
-#ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
-#endif
 }
 
 /*
@@ -3084,8 +3065,6 @@ void wake_up_new_task(struct task_struct *p)
 	task_rq_unlock(rq, p, &flags);
 }
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-
 /**
  * preempt_notifier_register - tell me when current is being preempted & rescheduled
  * @notifier: notifier struct to register
@@ -3122,26 +3101,12 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
 				 struct task_struct *next)
 {
 	struct preempt_notifier *notifier;
-	struct hlist_node *node;
+	struct hlist_node *node, *n;
 
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
+	hlist_for_each_entry_safe(notifier, node, n, &curr->preempt_notifiers, link)
 		notifier->ops->sched_out(notifier, next);
 }
 
-#else /* !CONFIG_PREEMPT_NOTIFIERS */
-
-static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
-{
-}
-
-static void
-fire_sched_out_preempt_notifiers(struct task_struct *curr,
-				 struct task_struct *next)
-{
-}
-
-#endif /* CONFIG_PREEMPT_NOTIFIERS */
-
 /**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch

