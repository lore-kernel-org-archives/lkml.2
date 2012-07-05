Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2GESNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:13:40 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37007 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab2GESMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:12:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 01/10] random: make 'add_interrupt_randomness()' do something sane
Date: Thu,  5 Jul 2012 14:12:04 -0400
Message-Id: <1341511933-11169-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341511933-11169-1-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been moving away from add_interrupt_randomness() for various
reasons: it's too expensive to do on every interrupt, and flooding the
CPU with interrupts could theoretically cause bogus floods of entropy
from a somewhat externally controllable source.

This solves both problems by limiting the actual randomness addition
to just once a second or after 128 interrupts, whicever comes first.
During that time, the interrupt cycle data is buffered up in a per-cpu
pool.  Also, we make sure the the nonblocking pool used by urandom is
initialized before we start feeding the normal input pool.  This
assures that /dev/urandom is returning unpredictable data as soon as
possible.

(Based on an original patch by Linus, but significantly modified by
tytso.)

Tested-by: Eric Wustrow <ewust@umich.edu>
Reported-by: Eric Wustrow <ewust@umich.edu>
Reported-by: Nadia Heninger <nadiah@cs.ucsd.edu>
Reported-by: Zakir Durumeric <zakir@umich.edu>
Reported-by: J. Alex Halderman <jhalderm@umich.edu>.
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
---
 drivers/char/random.c     | 85 ++++++++++++++++++++++++++++++++++++++---------
 drivers/mfd/ab3100-core.c |  2 --
 kernel/irq/handle.c       |  3 +-
 3 files changed, 71 insertions(+), 19 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 4ec04a7..53b3e85 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -133,13 +133,9 @@
  * add_input_randomness() uses the input layer interrupt timing, as well as
  * the event type information from the hardware.
  *
- * add_interrupt_randomness() uses the inter-interrupt timing as random
- * inputs to the entropy pool.  Note that not all interrupts are good
- * sources of randomness!  For example, the timer interrupts is not a
- * good choice, because the periodicity of the interrupts is too
- * regular, and hence predictable to an attacker.  Network Interface
- * Controller interrupts are a better measure, since the timing of the
- * NIC interrupts are more unpredictable.
+ * add_interrupt_randomness() uses the interrupt timing as random
+ * inputs to the entropy pool. Using the cycle counters and the irq source
+ * as inputs, it feeds the randomness roughly once a second.
  *
  * add_disk_randomness() uses what amounts to the seek time of block
  * layer request events, on a per-disk_devt basis, as input to the
@@ -256,6 +252,8 @@
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>
+#include <asm/irq_regs.h>
+#include <asm/ptrace.h>
 #include <asm/io.h>
 
 /*
@@ -421,7 +419,9 @@ struct entropy_store {
 	spinlock_t lock;
 	unsigned add_ptr;
 	int entropy_count;
+	int entropy_total;
 	int input_rotate;
+	unsigned int initialized:1;
 	__u8 last_data[EXTRACT_SIZE];
 };
 
@@ -454,6 +454,10 @@ static struct entropy_store nonblocking_pool = {
 	.pool = nonblocking_pool_data
 };
 
+static __u32 const twist_table[8] = {
+	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
+	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
+
 /*
  * This function adds bytes into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
@@ -467,9 +471,6 @@ static struct entropy_store nonblocking_pool = {
 static void mix_pool_bytes_extract(struct entropy_store *r, const void *in,
 				   int nbytes, __u8 out[64])
 {
-	static __u32 const twist_table[8] = {
-		0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
-		0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
 	unsigned long i, j, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
@@ -528,6 +529,35 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in, int bytes)
        mix_pool_bytes_extract(r, in, bytes, NULL);
 }
 
+struct fast_pool {
+	__u32		pool[4];
+	unsigned long	last;
+	unsigned short	count;
+	unsigned short	rotate;
+};
+
+/*
+ * This is a fast mixing routine used by the interrupt randomness
+ * collector.  It's hardcoded for an 128 bit pool and assumes that any
+ * locks that might be needed are taken by the caller.
+ */
+static void fast_mix(struct fast_pool *f, const void *in, int nbytes)
+{
+	const char	*bytes = in;
+	__u32		w;
+	unsigned	i = f->count;
+	unsigned	input_rotate = f->rotate;
+
+	while (nbytes--) {
+		w = rol32(*bytes++, input_rotate & 31) ^ f->pool[i & 3] ^
+			f->pool[(i + 1) & 3];
+		f->pool[i & 3] = (w >> 3) ^ twist_table[w & 7];
+		input_rotate += (i++ & 3) ? 7 : 14;
+	}
+	f->count = i;
+	f->rotate = input_rotate;
+}
+
 /*
  * Credit (or debit) the entropy store with n bits of entropy
  */
@@ -551,6 +581,12 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 		entropy_count = r->poolinfo->POOLBITS;
 	r->entropy_count = entropy_count;
 
+	if (!r->initialized && nbits > 0) {
+		r->entropy_total += nbits;
+		if (r->entropy_total > 128)
+			r->initialized = 1;
+	}
+
 	/* should we wake readers? */
 	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
 		wake_up_interruptible(&random_read_wait);
@@ -700,17 +736,35 @@ void add_input_randomness(unsigned int type, unsigned int code,
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
+static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
+
 void add_interrupt_randomness(int irq)
 {
-	struct timer_rand_state *state;
+	struct entropy_store	*r;
+	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
+	struct pt_regs		*regs = get_irq_regs();
+	unsigned long		now = jiffies;
+	__u32			input[4];
+
+	input[0] = get_cycles() ^ jiffies;
+	input[1] = irq;
+	if (regs) {
+		__u64 ip = instruction_pointer(regs);
+		input[2] = ip;
+		input[3] = ip >> 32;
+	}
 
-	state = get_timer_rand_state(irq);
+	fast_mix(fast_pool, input, sizeof(input));
 
-	if (state == NULL)
+	if ((fast_pool->count & 255) &&
+	    !time_after(now, fast_pool->last + HZ))
 		return;
 
-	DEBUG_ENT("irq event %d\n", irq);
-	add_timer_randomness(state, 0x100 + irq);
+	fast_pool->last = now;
+
+	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
+	mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
+	credit_entropy_bits(r, 1);
 }
 
 #ifdef CONFIG_BLOCK
@@ -971,6 +1025,7 @@ static void init_std_data(struct entropy_store *r)
 
 	spin_lock_irqsave(&r->lock, flags);
 	r->entropy_count = 0;
+	r->entropy_total = 0;
 	spin_unlock_irqrestore(&r->lock, flags);
 
 	now = ktime_get_real();
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 1efad20..9522d6b 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -409,8 +409,6 @@ static irqreturn_t ab3100_irq_handler(int irq, void *data)
 	u32 fatevent;
 	int err;
 
-	add_interrupt_randomness(irq);
-
 	err = ab3100_get_register_page_interruptible(ab3100, AB3100_EVENTA1,
 				       event_regs, 3);
 	if (err)
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index bdb1803..8270db0 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -172,8 +172,7 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 		action = action->next;
 	} while (action);
 
-	if (random & IRQF_SAMPLE_RANDOM)
-		add_interrupt_randomness(irq);
+	add_interrupt_randomness(irq);
 
 	if (!noirqdebug)
 		note_interrupt(irq, desc, retval);
-- 
1.7.11.1.108.gb129051

