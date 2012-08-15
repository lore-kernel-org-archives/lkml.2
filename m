Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab2HOUAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:00:39 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63152 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab2HOTwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 151/165] random: make 'add_interrupt_randomness()' do something sane
Date: Wed, 15 Aug 2012 15:48:15 -0400
Message-ID: <1345060109-9187-152-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 775f4b297b780601e61787b766f306ed3e1d23eb upstream.

We've been moving away from add_interrupt_randomness() for various
reasons: it's too expensive to do on every interrupt, and flooding the
CPU with interrupts could theoretically cause bogus floods of entropy
from a somewhat externally controllable source.

This solves both problems by limiting the actual randomness addition
to just once a second or after 64 interrupts, whicever comes first.
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
[PG: minor adjustment required since .34 doesn't have f9e4989eb8
 which renames "status" to "random" in kernel/irq/handle.c ]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/random.c     | 103 ++++++++++++++++++++++++++++++++++++++--------
 drivers/mfd/ab3100-core.c |   2 -
 include/linux/random.h    |   2 +-
 kernel/irq/handle.c       |   7 ++--
 4 files changed, 90 insertions(+), 24 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1b3544d..a104af3 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -127,18 +127,14 @@
  *
  * 	void add_input_randomness(unsigned int type, unsigned int code,
  *                                unsigned int value);
- * 	void add_interrupt_randomness(int irq);
+ *	void add_interrupt_randomness(int irq, int irq_flags);
  *
  * add_input_randomness() uses the input layer interrupt timing, as well as
  * the event type information from the hardware.
  *
- * add_interrupt_randomness() uses the inter-interrupt timing as random
- * inputs to the entropy pool.  Note that not all interrupts are good
- * sources of randomness!  For example, the timer interrupts is not a
- * good choice, because the periodicity of the interrupts is too
- * regular, and hence predictable to an attacker.  Disk interrupts are
- * a better measure, since the timing of the disk interrupts are more
- * unpredictable.
+ * add_interrupt_randomness() uses the interrupt timing as random
+ * inputs to the entropy pool. Using the cycle counters and the irq source
+ * as inputs, it feeds the randomness roughly once a second.
  *
  * All of these routines try to estimate how many bits of randomness a
  * particular randomness source.  They do this by keeping track of the
@@ -241,6 +237,7 @@
 #include <linux/percpu.h>
 #include <linux/cryptohash.h>
 #include <linux/fips.h>
+#include <linux/ptrace.h>
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 # include <linux/irq.h>
@@ -249,6 +246,7 @@
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>
+#include <asm/irq_regs.h>
 #include <asm/io.h>
 
 /*
@@ -414,7 +412,9 @@ struct entropy_store {
 	spinlock_t lock;
 	unsigned add_ptr;
 	int entropy_count;
+	int entropy_total;
 	int input_rotate;
+	unsigned int initialized:1;
 	__u8 last_data[EXTRACT_SIZE];
 };
 
@@ -447,6 +447,10 @@ static struct entropy_store nonblocking_pool = {
 	.pool = nonblocking_pool_data
 };
 
+static __u32 const twist_table[8] = {
+	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
+	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
+
 /*
  * This function adds bytes into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
@@ -460,9 +464,6 @@ static struct entropy_store nonblocking_pool = {
 static void mix_pool_bytes_extract(struct entropy_store *r, const void *in,
 				   int nbytes, __u8 out[64])
 {
-	static __u32 const twist_table[8] = {
-		0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
-		0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
 	unsigned long i, j, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
@@ -521,6 +522,36 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in, int bytes)
        mix_pool_bytes_extract(r, in, bytes, NULL);
 }
 
+struct fast_pool {
+	__u32		pool[4];
+	unsigned long	last;
+	unsigned short	count;
+	unsigned char	rotate;
+	unsigned char	last_timer_intr;
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
@@ -544,6 +575,12 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
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
@@ -693,17 +730,48 @@ void add_input_randomness(unsigned int type, unsigned int code,
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
-void add_interrupt_randomness(int irq)
+static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
+
+void add_interrupt_randomness(int irq, int irq_flags)
 {
-	struct timer_rand_state *state;
+	struct entropy_store	*r;
+	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
+	struct pt_regs		*regs = get_irq_regs();
+	unsigned long		now = jiffies;
+	__u32			input[4], cycles = get_cycles();
+
+	input[0] = cycles ^ jiffies;
+	input[1] = irq;
+	if (regs) {
+		__u64 ip = instruction_pointer(regs);
+		input[2] = ip;
+		input[3] = ip >> 32;
+	}
 
-	state = get_timer_rand_state(irq);
+	fast_mix(fast_pool, input, sizeof(input));
 
-	if (state == NULL)
+	if ((fast_pool->count & 1023) &&
+	    !time_after(now, fast_pool->last + HZ))
 		return;
 
-	DEBUG_ENT("irq event %d\n", irq);
-	add_timer_randomness(state, 0x100 + irq);
+	fast_pool->last = now;
+
+	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
+	mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
+	/*
+	 * If we don't have a valid cycle counter, and we see
+	 * back-to-back timer interrupts, then skip giving credit for
+	 * any entropy.
+	 */
+	if (cycles == 0) {
+		if (irq_flags & __IRQF_TIMER) {
+			if (fast_pool->last_timer_intr)
+				return;
+			fast_pool->last_timer_intr = 1;
+		} else
+			fast_pool->last_timer_intr = 0;
+	}
+	credit_entropy_bits(r, 1);
 }
 
 #ifdef CONFIG_BLOCK
@@ -964,6 +1032,7 @@ static void init_std_data(struct entropy_store *r)
 
 	spin_lock_irqsave(&r->lock, flags);
 	r->entropy_count = 0;
+	r->entropy_total = 0;
 	spin_unlock_irqrestore(&r->lock, flags);
 
 	now = ktime_get_real();
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 4267a4d..2a193dc 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -378,8 +378,6 @@ static irqreturn_t ab3100_irq_handler(int irq, void *data)
 	u32 fatevent;
 	int err;
 
-	add_interrupt_randomness(irq);
-
 	err = ab3100_get_register_page_interruptible(ab3100, AB3100_EVENTA1,
 				       event_regs, 3);
 	if (err)
diff --git a/include/linux/random.h b/include/linux/random.h
index 0bf2936..8a85602 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -48,7 +48,7 @@ extern void rand_initialize_irq(int irq);
 
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
-extern void add_interrupt_randomness(int irq);
+extern void add_interrupt_randomness(int irq, int irq_flags);
 
 extern void get_random_bytes(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 76d5a67..86bcf10 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -368,7 +368,7 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
 irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 {
 	irqreturn_t ret, retval = IRQ_NONE;
-	unsigned int status = 0;
+	unsigned int flags = 0;
 
 	if (!(action->flags & IRQF_DISABLED))
 		local_irq_enable_in_hardirq();
@@ -411,7 +411,7 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 
 			/* Fall through to add to randomness */
 		case IRQ_HANDLED:
-			status |= action->flags;
+			flags |= action->flags;
 			break;
 
 		default:
@@ -422,8 +422,7 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 		action = action->next;
 	} while (action);
 
-	if (status & IRQF_SAMPLE_RANDOM)
-		add_interrupt_randomness(irq);
+	add_interrupt_randomness(irq, flags);
 	local_irq_disable();
 
 	return retval;
-- 
1.7.12.rc2

