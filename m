Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2L2Amj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 19:42:39 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58808 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab2L2Amg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 19:42:36 -0500
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Herbert <therbert@google.com>
In-Reply-To: <50DCA206.6010802@redhat.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	 <20121221185147.4ae48ab5@annuminas.surriel.com>
	 <20121221185613.1f4c9523@annuminas.surriel.com>
	 <20121222033339.GF27621@home.goodmis.org> <50D52E0C.6000103@redhat.com>
	 <1356549008.20133.20856.camel@edumazet-glaptop> <50DB5531.90500@redhat.com>
	 <CANN689HeTk0jNJb4sF_0t714MvFnU0vLw0=JeXYRUwMx8GDnXQ@mail.gmail.com>
	 <1356618448.30414.948.camel@edumazet-glaptop> <50DC5CC0.6010003@redhat.com>
	 <1356634150.30414.1268.camel@edumazet-glaptop>
	 <50DCA206.6010802@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Dec 2012 16:42:32 -0800
Message-ID: <1356741752.21409.1518.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-27 at 14:31 -0500, Rik van Riel wrote:
> to use a bigger/smaller one.
> 
> I guess we want a larger value.
> 
> With your hashed lock approach, we can get away with
> larger values - they will not penalize other locks
> the same way a single value per cpu might have.

Then, we absolutely want to detect hash collisions to clear the (wrong)
estimation or else we might 'pollute' a spinlock with a delay of a very
slow spinlock.

In my tests, the mm zone lock can be held for very long for example...

[  657.439995] cpu 18 lock ffff88067fffeb40 delay 6906
[  657.444855] ------------[ cut here ]------------
[  657.444859] WARNING: at arch/x86/kernel/smp.c:170
ticket_spin_lock_wait+0xf9/0x100()
[  657.444860] Hardware name: TBG,ICH10
[  657.444861] Modules linked in: msr cpuid genrtc mlx4_en ib_uverbs
mlx4_ib ib_sa ib_mad ib_core mlx4_core e1000e bnx2x libcrc32c mdio ipv6
[  657.444871] Pid: 24942, comm: hotplug Tainted: G        W
3.8.0-smp-DEV #31
[  657.444872] Call Trace:
[  657.444876]  [<ffffffff8108634f>] warn_slowpath_common+0x7f/0xc0
[  657.444878]  [<ffffffff810863aa>] warn_slowpath_null+0x1a/0x20
[  657.444881]  [<ffffffff81070089>] ticket_spin_lock_wait+0xf9/0x100
[  657.444885]  [<ffffffff815ad58f>] _raw_spin_lock_irqsave+0x2f/0x40
[  657.444887]  [<ffffffff8113f5d0>] release_pages+0x160/0x220
[  657.444891]  [<ffffffff8116cffe>] free_pages_and_swap_cache+0x9e/0xc0
[  657.444893]  [<ffffffff8107f8a8>] ? flush_tlb_mm_range+0x48/0x220
[  657.444896]  [<ffffffff81158ee7>] tlb_flush_mmu+0x67/0xb0
[  657.444898]  [<ffffffff81158f4c>] tlb_finish_mmu+0x1c/0x50
[  657.444900]  [<ffffffff81163346>] exit_mmap+0xf6/0x170
[  657.444903]  [<ffffffff81083737>] mmput+0x47/0xf0
[  657.444906]  [<ffffffff8108baed>] do_exit+0x24d/0xa20
[  657.444908]  [<ffffffff810986af>] ? recalc_sigpending+0x1f/0x60
[  657.444910]  [<ffffffff81098db7>] ? __set_task_blocked+0x37/0x80
[  657.444913]  [<ffffffff8108c354>] do_group_exit+0x44/0xa0
[  657.444915]  [<ffffffff8108c3c7>] sys_exit_group+0x17/0x20
[  657.444918]  [<ffffffff815b68a5>] sysenter_dispatch+0x7/0x1a
[  657.444920] ---[ end trace a460fe18a5578dda ]---

My current function looks like :

 /*
+ * Wait on a congested ticket spinlock.
+ */
+#define MIN_SPINLOCK_DELAY 1
+#define MAX_SPINLOCK_DELAY 10000
+#define DELAY_HASH_SHIFT 6
+struct delay_entry {
+       u32 hash;
+       u32 delay;
+};
+static DEFINE_PER_CPU(struct delay_entry [1 << DELAY_HASH_SHIFT], spinlock_delay) = {
+       [0 ... (1 << DELAY_HASH_SHIFT) - 1] = {
+               .hash = 0,
+               .delay = MIN_SPINLOCK_DELAY,
+       },
+};
+static DEFINE_PER_CPU(u16, maxdelay);
+
+void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
+{
+       u32 hash = hash32_ptr(lock);
+       u32 slot = hash_32(hash, DELAY_HASH_SHIFT);
+       struct delay_entry *ent = &__get_cpu_var(spinlock_delay[slot]);
+       u32 delay = (ent->hash == hash) ? ent->delay : MIN_SPINLOCK_DELAY;
+
+       for (;;) {
+               u32 loops = delay * (__ticket_t)(inc.tail - inc.head);
+
+               loops -= delay >> 1;
+               while (loops--)
+                       cpu_relax();
+
+               inc.head = ACCESS_ONCE(lock->tickets.head);
+
+               if (inc.head == inc.tail) {
+                       /* Decrease the delay, since we may have overslept. */
+                       if (delay > MIN_SPINLOCK_DELAY)
+                               delay--;
+                       break;
+               }
+
+               /*
+                * The lock is still busy, the delay was not long enough.
+                * Going through here 2.7 times will, on average, cancel
+                * out the decrement above. Using a non-integer number
+                * gets rid of performance artifacts and reduces oversleeping.
+                */
+               if (delay < MAX_SPINLOCK_DELAY &&
+                   (!(inc.head & 3) == 0 || (inc.head & 7) == 1))
+                       delay++;
+       }
+       if (__this_cpu_read(maxdelay) < delay) {
+               pr_err("cpu %d lock %p delay %d\n", smp_processor_id(), lock, delay);
+               __this_cpu_write(maxdelay, delay);
+               WARN_ON(1);
+       }
+       ent->hash = hash;
+       ent->delay = delay;
+}
+


