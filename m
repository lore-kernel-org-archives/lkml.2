Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab2BXH73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 02:59:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45389 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab2BXH71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 02:59:27 -0500
Date: Fri, 24 Feb 2012 08:59:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] static keys: Introduce 'struct static_key',
 static_key_true()/false() and static_key_slow_[inc|dec]()
Message-ID: <20120224075904.GA12070@elte.hu>
References: <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu>
 <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
 <20120223100205.GD24310@elte.hu>
 <CA+55aFwwV3GsqHue8oUsx-XbvSQXSawJ0w5z=wL8ue=EH4ifzw@mail.gmail.com>
 <20120223223348.GA25513@elte.hu>
 <20120223223933.GA7942@elte.hu>
 <20120224075235.GA4546@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224075235.GA4546@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Resent with a [PATCH] prefix added to the subject line.
  Sorry about the duplicate. ]

* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > So, a modified scheme would be:
> > 
> >         #include <linux/static_key.h>
> > 
> >         struct static_key key = STATIC_KEY_INIT_TRUE;
> > 
> >         if (static_key_false(&key))
> >                 do unlikely code
> >         else
> >                 do likely code
> > 
> > Or:
> > 
> >         if (static_key_true(&key))
> >                 do likely code
> >         else
> >                 do unlikely code
> > 
> > The static key is modified via:
> > 
> >         static_key_slow_inc(&key);
> >         ...
> >         static_key_slow_dec(&key);
> > 
> > Is that API fine? I'll rework the series to such an effect if 
> > everyone agrees.
> 
> I.e. something like the patch below on top of 
> tip:perf/jump-labels.
> 
> Untested - will test it and will refactor the series if 
> everyone's happy.

So, below is the second version of my 'struct static_key' patch, 
with the confusing very_likely()/very_unlikely() method renamed 
to static_key_true()/static_key_false().

Thanks,

	Ingo

-------------------->
>From 25764dffac2414774b65a831733b232d33006884 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 24 Feb 2012 08:31:31 +0100
Subject: [PATCH] static keys: Introduce 'struct static_key', static_key_true()/false() and static_key_slow_[inc|dec]()

So here's a boot tested patch on top of Jason's series that does
all the cleanups I talked about and turns jump labels into a
more intuitive to use facility. It should also address the
various misconceptions and confusions that surround jump labels.

Typical usage scenarios:

        #include <linux/static_key.h>

        struct static_key key = STATIC_KEY_INIT_TRUE;

        if (static_key_false(&key))
                do unlikely code
        else
                do likely code

Or:

        if (static_key_true(&key))
                do likely code
        else
                do unlikely code

The static key is modified via:

        static_key_slow_inc(&key);
        ...
        static_key_slow_dec(&key);

The 'slow' prefix makes it abundantly clear that this is an
expensive operation.

I've updated all in-kernel code to use this everywhere. Note
that I (intentionally) have not pushed through the rename
blindly through to the lowest levels: the actual jump-label
patching arch facility should be named like that, so we want to
decouple jump labels from the static-key facility a bit.

On non-jump-label enabled architectures static keys default to
likely()/unlikely() branches.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: a.p.zijlstra@chello.nl
Cc: mathieu.desnoyers@efficios.com
Cc: davem@davemloft.net
Cc: ddaney.cavm@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20120222085809.GA26397@elte.hu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/Kconfig                          |   29 +++++--
 arch/ia64/include/asm/paravirt.h      |    6 +-
 arch/ia64/kernel/paravirt.c           |    4 +-
 arch/mips/include/asm/jump_label.h    |    2 +-
 arch/powerpc/include/asm/jump_label.h |    2 +-
 arch/s390/include/asm/jump_label.h    |    2 +-
 arch/sparc/include/asm/jump_label.h   |    2 +-
 arch/x86/include/asm/jump_label.h     |    6 +-
 arch/x86/include/asm/paravirt.h       |    6 +-
 arch/x86/kernel/kvm.c                 |    4 +-
 arch/x86/kernel/paravirt.c            |    4 +-
 arch/x86/kvm/mmu_audit.c              |    8 +-
 include/linux/jump_label.h            |  139 +++++++++++++++++++++++---------
 include/linux/netdevice.h             |    4 +-
 include/linux/netfilter.h             |    6 +-
 include/linux/perf_event.h            |   12 ++--
 include/linux/static_key.h            |    1 +
 include/linux/tracepoint.h            |    8 +-
 include/net/sock.h                    |    6 +-
 kernel/events/core.c                  |   16 ++--
 kernel/jump_label.c                   |  128 +++++++++++++++++-------------
 kernel/sched/core.c                   |   18 ++--
 kernel/sched/fair.c                   |    8 +-
 kernel/sched/sched.h                  |   14 ++--
 kernel/tracepoint.c                   |   20 +++---
 net/core/dev.c                        |   24 +++---
 net/core/net-sysfs.c                  |    4 +-
 net/core/sock.c                       |    4 +-
 net/core/sysctl_net_core.c            |    4 +-
 net/ipv4/tcp_memcontrol.c             |    6 +-
 net/netfilter/core.c                  |    6 +-
 31 files changed, 298 insertions(+), 205 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 4f55c73..5b448a7 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -47,18 +47,29 @@ config KPROBES
 	  If in doubt, say "N".
 
 config JUMP_LABEL
-       bool "Optimize trace point call sites"
+       bool "Optimize very unlikely/likely branches"
        depends on HAVE_ARCH_JUMP_LABEL
        help
+         This option enables a transparent branch optimization that
+	 makes certain almost-always-true or almost-always-false branch
+	 conditions even cheaper to execute within the kernel.
+
+	 Certain performance-sensitive kernel code, such as trace points,
+	 scheduler functionality, networking code and KVM have such
+	 branches and include support for this optimization technique.
+
          If it is detected that the compiler has support for "asm goto",
-	 the kernel will compile trace point locations with just a
-	 nop instruction. When trace points are enabled, the nop will
-	 be converted to a jump to the trace function. This technique
-	 lowers overhead and stress on the branch prediction of the
-	 processor.
-
-	 On i386, options added to the compiler flags may increase
-	 the size of the kernel slightly.
+	 the kernel will compile such branches with just a nop
+	 instruction. When the condition flag is toggled to true, the
+	 nop will be converted to a jump instruction to execute the
+	 conditional block of instructions.
+
+	 This technique lowers overhead and stress on the branch prediction
+	 of the processor and generally makes the kernel faster. The update
+	 of the condition is slower, but those are always very rare.
+
+	 ( On 32-bit x86, the necessary options added to the compiler
+	   flags may increase the size of the kernel slightly. )
 
 config OPTPROBES
 	def_bool y
diff --git a/arch/ia64/include/asm/paravirt.h b/arch/ia64/include/asm/paravirt.h
index 32551d3..b149b88 100644
--- a/arch/ia64/include/asm/paravirt.h
+++ b/arch/ia64/include/asm/paravirt.h
@@ -281,9 +281,9 @@ paravirt_init_missing_ticks_accounting(int cpu)
 		pv_time_ops.init_missing_ticks_accounting(cpu);
 }
 
-struct jump_label_key;
-extern struct jump_label_key paravirt_steal_enabled;
-extern struct jump_label_key paravirt_steal_rq_enabled;
+struct static_key;
+extern struct static_key paravirt_steal_enabled;
+extern struct static_key paravirt_steal_rq_enabled;
 
 static inline int
 paravirt_do_steal_accounting(unsigned long *new_itm)
diff --git a/arch/ia64/kernel/paravirt.c b/arch/ia64/kernel/paravirt.c
index 1008682..1b22f6d 100644
--- a/arch/ia64/kernel/paravirt.c
+++ b/arch/ia64/kernel/paravirt.c
@@ -634,8 +634,8 @@ struct pv_irq_ops pv_irq_ops = {
  * pv_time_ops
  * time operations
  */
-struct jump_label_key paravirt_steal_enabled;
-struct jump_label_key paravirt_steal_rq_enabled;
+struct static_key paravirt_steal_enabled;
+struct static_key paravirt_steal_rq_enabled;
 
 static int
 ia64_native_do_steal_accounting(unsigned long *new_itm)
diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
index 1881b31..4d6d77e 100644
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -20,7 +20,7 @@
 #define WORD_INSN ".word"
 #endif
 
-static __always_inline bool arch_static_branch(struct jump_label_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("1:\tnop\n\t"
 		"nop\n\t"
diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/include/asm/jump_label.h
index 938986e..ae098c4 100644
--- a/arch/powerpc/include/asm/jump_label.h
+++ b/arch/powerpc/include/asm/jump_label.h
@@ -17,7 +17,7 @@
 #define JUMP_ENTRY_TYPE		stringify_in_c(FTR_ENTRY_LONG)
 #define JUMP_LABEL_NOP_SIZE	4
 
-static __always_inline bool arch_static_branch(struct jump_label_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("1:\n\t"
 		 "nop\n\t"
diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
index 95a6cf2..6c32190 100644
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -13,7 +13,7 @@
 #define ASM_ALIGN ".balign 4"
 #endif
 
-static __always_inline bool arch_static_branch(struct jump_label_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("0:	brcl 0,0\n"
 		".pushsection __jump_table, \"aw\"\n"
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index fc73a82..5080d16 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -7,7 +7,7 @@
 
 #define JUMP_LABEL_NOP_SIZE 4
 
-static __always_inline bool arch_static_branch(struct jump_label_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key)
 {
 		asm goto("1:\n\t"
 			 "nop\n\t"
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index a32b18c..3a16c14 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -9,12 +9,12 @@
 
 #define JUMP_LABEL_NOP_SIZE 5
 
-#define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+#define STATIC_KEY_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
 
-static __always_inline bool arch_static_branch(struct jump_label_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("1:"
-		JUMP_LABEL_INITIAL_NOP
+		STATIC_KEY_INITIAL_NOP
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a7d2db9..c0180fd 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -230,9 +230,9 @@ static inline unsigned long long paravirt_sched_clock(void)
 	return PVOP_CALL0(unsigned long long, pv_time_ops.sched_clock);
 }
 
-struct jump_label_key;
-extern struct jump_label_key paravirt_steal_enabled;
-extern struct jump_label_key paravirt_steal_rq_enabled;
+struct static_key;
+extern struct static_key paravirt_steal_enabled;
+extern struct static_key paravirt_steal_rq_enabled;
 
 static inline u64 paravirt_steal_clock(int cpu)
 {
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index f0c6fd6..694d801 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -438,9 +438,9 @@ void __init kvm_guest_init(void)
 static __init int activate_jump_labels(void)
 {
 	if (has_steal_clock) {
-		jump_label_inc(&paravirt_steal_enabled);
+		static_key_slow_inc(&paravirt_steal_enabled);
 		if (steal_acc)
-			jump_label_inc(&paravirt_steal_rq_enabled);
+			static_key_slow_inc(&paravirt_steal_rq_enabled);
 	}
 
 	return 0;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index d90272e..ada2f99 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -202,8 +202,8 @@ static void native_flush_tlb_single(unsigned long addr)
 	__native_flush_tlb_single(addr);
 }
 
-struct jump_label_key paravirt_steal_enabled;
-struct jump_label_key paravirt_steal_rq_enabled;
+struct static_key paravirt_steal_enabled;
+struct static_key paravirt_steal_rq_enabled;
 
 static u64 native_steal_clock(int cpu)
 {
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index fe15dcc..ea7b4fd 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -234,7 +234,7 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
 }
 
 static bool mmu_audit;
-static struct jump_label_key mmu_audit_key;
+static struct static_key mmu_audit_key;
 
 static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
@@ -250,7 +250,7 @@ static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 
 static inline void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
-	if (static_branch((&mmu_audit_key)))
+	if (static_key_false((&mmu_audit_key)))
 		__kvm_mmu_audit(vcpu, point);
 }
 
@@ -259,7 +259,7 @@ static void mmu_audit_enable(void)
 	if (mmu_audit)
 		return;
 
-	jump_label_inc(&mmu_audit_key);
+	static_key_slow_inc(&mmu_audit_key);
 	mmu_audit = true;
 }
 
@@ -268,7 +268,7 @@ static void mmu_audit_disable(void)
 	if (!mmu_audit)
 		return;
 
-	jump_label_dec(&mmu_audit_key);
+	static_key_slow_dec(&mmu_audit_key);
 	mmu_audit = false;
 }
 
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index f7c6958..30d0023 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -9,15 +9,15 @@
  *
  * Jump labels provide an interface to generate dynamic branches using
  * self-modifying code. Assuming toolchain and architecture support the result
- * of a "if (static_branch(&key))" statement is a unconditional branch (which
+ * of a "if (static_key_false(&key))" statement is a unconditional branch (which
  * defaults to false - and the true block is placed out of line).
  *
- * However at runtime we can change the 'static' branch target using
- * jump_label_{inc,dec}(). These function as a 'reference' count on the key
+ * However at runtime we can change the branch target using
+ * static_key_slow_{inc,dec}(). These function as a 'reference' count on the key
  * object and for as long as there are references all branches referring to
  * that particular key will point to the (out of line) true block.
  *
- * Since this relies on modifying code the jump_label_{inc,dec}() functions
+ * Since this relies on modifying code the static_key_slow_{inc,dec}() functions
  * must be considered absolute slow paths (machine wide synchronization etc.).
  * OTOH, since the affected branches are unconditional their runtime overhead
  * will be absolutely minimal, esp. in the default (off) case where the total
@@ -26,12 +26,26 @@
  *
  * When the control is directly exposed to userspace it is prudent to delay the
  * decrement to avoid high frequency code modifications which can (and do)
- * cause significant performance degradation. Struct jump_label_key_deferred and
- * jump_label_dec_deferred() provide for this.
+ * cause significant performance degradation. Struct static_key_deferred and
+ * static_key_slow_dec_deferred() provide for this.
  *
  * Lacking toolchain and or architecture support, it falls back to a simple
  * conditional branch.
- */
+ *
+ * struct static_key my_key = STATIC_KEY_INIT_TRUE;
+ *
+ *   if (static_key_true(&my_key)) {
+ *   }
+ *
+ * will result in the true case being in-line and starts the key with a single
+ * reference. Mixing static_key_true() and static_key_false() on the same key is not
+ * allowed.
+ *
+ * Not initializing the key (static data is initialized to 0s anyway) is the
+ * same as using STATIC_KEY_INIT_FALSE and static_key_false() is
+ * equivalent with static_branch().
+ *
+*/
 
 #include <linux/types.h>
 #include <linux/compiler.h>
@@ -39,16 +53,17 @@
 
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 
-struct jump_label_key {
+struct static_key {
 	atomic_t enabled;
+/* Set lsb bit to 1 if branch is default true, 0 ot */
 	struct jump_entry *entries;
 #ifdef CONFIG_MODULES
-	struct jump_label_mod *next;
+	struct static_key_mod *next;
 #endif
 };
 
-struct jump_label_key_deferred {
-	struct jump_label_key key;
+struct static_key_deferred {
+	struct static_key key;
 	unsigned long timeout;
 	struct delayed_work work;
 };
@@ -66,13 +81,34 @@ struct module;
 
 #ifdef HAVE_JUMP_LABEL
 
-#ifdef CONFIG_MODULES
-#define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL, NULL}
-#else
-#define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL}
-#endif
+#define JUMP_LABEL_TRUE_BRANCH 1UL
+
+static
+inline struct jump_entry *jump_label_get_entries(struct static_key *key)
+{
+	return (struct jump_entry *)((unsigned long)key->entries
+						& ~JUMP_LABEL_TRUE_BRANCH);
+}
+
+static inline bool jump_label_get_branch_default(struct static_key *key)
+{
+	if ((unsigned long)key->entries & JUMP_LABEL_TRUE_BRANCH)
+		return true;
+	return false;
+}
+
+static __always_inline bool static_key_false(struct static_key *key)
+{
+	return arch_static_branch(key);
+}
 
-static __always_inline bool static_branch(struct jump_label_key *key)
+static __always_inline bool static_key_true(struct static_key *key)
+{
+	return !static_key_false(key);
+}
+
+/* Deprecated. Please use 'static_key_false() instead. */
+static __always_inline bool static_branch(struct static_key *key)
 {
 	return arch_static_branch(key);
 }
@@ -88,21 +124,24 @@ extern void arch_jump_label_transform(struct jump_entry *entry,
 extern void arch_jump_label_transform_static(struct jump_entry *entry,
 					     enum jump_label_type type);
 extern int jump_label_text_reserved(void *start, void *end);
-extern void jump_label_inc(struct jump_label_key *key);
-extern void jump_label_dec(struct jump_label_key *key);
-extern void jump_label_dec_deferred(struct jump_label_key_deferred *key);
-extern bool jump_label_enabled(struct jump_label_key *key);
+extern void static_key_slow_inc(struct static_key *key);
+extern void static_key_slow_dec(struct static_key *key);
+extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
+extern bool static_key_true(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
-extern void jump_label_rate_limit(struct jump_label_key_deferred *key,
-		unsigned long rl);
+extern void
+jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
+
+#define STATIC_KEY_INIT_TRUE ((struct static_key) \
+	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
+#define STATIC_KEY_INIT_FALSE ((struct static_key) \
+	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
 
 #else  /* !HAVE_JUMP_LABEL */
 
 #include <linux/atomic.h>
 
-#define JUMP_LABEL_INIT {ATOMIC_INIT(0)}
-
-struct jump_label_key {
+struct static_key {
 	atomic_t enabled;
 };
 
@@ -110,30 +149,45 @@ static __always_inline void jump_label_init(void)
 {
 }
 
-struct jump_label_key_deferred {
-	struct jump_label_key  key;
+struct static_key_deferred {
+	struct static_key  key;
 };
 
-static __always_inline bool static_branch(struct jump_label_key *key)
+static __always_inline bool static_key_false(struct static_key *key)
+{
+	if (unlikely(atomic_read(&key->enabled)) > 0)
+		return true;
+	return false;
+}
+
+static __always_inline bool static_key_true(struct static_key *key)
 {
-	if (unlikely(atomic_read(&key->enabled)))
+	if (likely(atomic_read(&key->enabled)) > 0)
 		return true;
 	return false;
 }
 
-static inline void jump_label_inc(struct jump_label_key *key)
+/* Deprecated. Please use 'static_key_false() instead. */
+static __always_inline bool static_branch(struct static_key *key)
+{
+	if (unlikely(atomic_read(&key->enabled)) > 0)
+		return true;
+	return false;
+}
+
+static inline void static_key_slow_inc(struct static_key *key)
 {
 	atomic_inc(&key->enabled);
 }
 
-static inline void jump_label_dec(struct jump_label_key *key)
+static inline void static_key_slow_dec(struct static_key *key)
 {
 	atomic_dec(&key->enabled);
 }
 
-static inline void jump_label_dec_deferred(struct jump_label_key_deferred *key)
+static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
 {
-	jump_label_dec(&key->key);
+	static_key_slow_dec(&key->key);
 }
 
 static inline int jump_label_text_reserved(void *start, void *end)
@@ -144,9 +198,9 @@ static inline int jump_label_text_reserved(void *start, void *end)
 static inline void jump_label_lock(void) {}
 static inline void jump_label_unlock(void) {}
 
-static inline bool jump_label_enabled(struct jump_label_key *key)
+static inline bool static_key_true(struct static_key *key)
 {
-	return !!atomic_read(&key->enabled);
+	return (atomic_read(&key->enabled) > 0);
 }
 
 static inline int jump_label_apply_nops(struct module *mod)
@@ -154,13 +208,20 @@ static inline int jump_label_apply_nops(struct module *mod)
 	return 0;
 }
 
-static inline void jump_label_rate_limit(struct jump_label_key_deferred *key,
+static inline void
+jump_label_rate_limit(struct static_key_deferred *key,
 		unsigned long rl)
 {
 }
+
+#define STATIC_KEY_INIT_TRUE ((struct static_key) \
+		{ .enabled = ATOMIC_INIT(1) })
+#define STATIC_KEY_INIT_FALSE ((struct static_key) \
+		{ .enabled = ATOMIC_INIT(0) })
+
 #endif	/* HAVE_JUMP_LABEL */
 
-#define jump_label_key_enabled	((struct jump_label_key){ .enabled = ATOMIC_INIT(1), })
-#define jump_label_key_disabled	((struct jump_label_key){ .enabled = ATOMIC_INIT(0), })
+#define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
+#define jump_label_enabled static_key_true
 
 #endif	/* _LINUX_JUMP_LABEL_H */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0eac07c..7dfaae7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -214,8 +214,8 @@ enum {
 #include <linux/skbuff.h>
 
 #ifdef CONFIG_RPS
-#include <linux/jump_label.h>
-extern struct jump_label_key rps_needed;
+#include <linux/static_key.h>
+extern struct static_key rps_needed;
 #endif
 
 struct neighbour;
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index b809265..29734be 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -163,13 +163,13 @@ extern struct ctl_path nf_net_ipv4_netfilter_sysctl_path[];
 extern struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 
 #if defined(CONFIG_JUMP_LABEL)
-#include <linux/jump_label.h>
-extern struct jump_label_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
+#include <linux/static_key.h>
+extern struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 static inline bool nf_hooks_active(u_int8_t pf, unsigned int hook)
 {
 	if (__builtin_constant_p(pf) &&
 	    __builtin_constant_p(hook))
-		return static_branch(&nf_hooks_needed[pf][hook]);
+		return static_key_false(&nf_hooks_needed[pf][hook]);
 
 	return !list_empty(&nf_hooks[pf][hook]);
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 412b790..0d21e6f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -514,7 +514,7 @@ struct perf_guest_info_callbacks {
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 #include <linux/atomic.h>
 #include <asm/local.h>
 
@@ -1038,7 +1038,7 @@ static inline int is_software_event(struct perf_event *event)
 	return event->pmu->task_ctx_nr == perf_sw_context;
 }
 
-extern struct jump_label_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
+extern struct static_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, struct pt_regs *, u64);
 
@@ -1066,7 +1066,7 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 {
 	struct pt_regs hot_regs;
 
-	if (static_branch(&perf_swevent_enabled[event_id])) {
+	if (static_key_false(&perf_swevent_enabled[event_id])) {
 		if (!regs) {
 			perf_fetch_caller_regs(&hot_regs);
 			regs = &hot_regs;
@@ -1075,12 +1075,12 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 	}
 }
 
-extern struct jump_label_key_deferred perf_sched_events;
+extern struct static_key_deferred perf_sched_events;
 
 static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
 {
-	if (static_branch(&perf_sched_events.key))
+	if (static_key_false(&perf_sched_events.key))
 		__perf_event_task_sched_in(prev, task);
 }
 
@@ -1089,7 +1089,7 @@ static inline void perf_event_task_sched_out(struct task_struct *prev,
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
-	if (static_branch(&perf_sched_events.key))
+	if (static_key_false(&perf_sched_events.key))
 		__perf_event_task_sched_out(prev, next);
 }
 
diff --git a/include/linux/static_key.h b/include/linux/static_key.h
new file mode 100644
index 0000000..27bd3f8
--- /dev/null
+++ b/include/linux/static_key.h
@@ -0,0 +1 @@
+#include <linux/jump_label.h>
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index fc36da9..bd96ecd 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -17,7 +17,7 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/rcupdate.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 
 struct module;
 struct tracepoint;
@@ -29,7 +29,7 @@ struct tracepoint_func {
 
 struct tracepoint {
 	const char *name;		/* Tracepoint name */
-	struct jump_label_key key;
+	struct static_key key;
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
 	struct tracepoint_func __rcu *funcs;
@@ -145,7 +145,7 @@ static inline void tracepoint_synchronize_unregister(void)
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		if (static_branch(&__tracepoint_##name.key))		\
+		if (static_key_false(&__tracepoint_##name.key))		\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
@@ -188,7 +188,7 @@ static inline void tracepoint_synchronize_unregister(void)
 	__attribute__((section("__tracepoints_strings"))) = #name;	 \
 	struct tracepoint __tracepoint_##name				 \
 	__attribute__((section("__tracepoints"))) =			 \
-		{ __tpstrtab_##name, JUMP_LABEL_INIT, reg, unreg, NULL };\
+		{ __tpstrtab_##name, STATIC_KEY_INIT_FALSE, reg, unreg, NULL };\
 	static struct tracepoint * const __tracepoint_ptr_##name __used	 \
 	__attribute__((section("__tracepoints_ptrs"))) =		 \
 		&__tracepoint_##name;
diff --git a/include/net/sock.h b/include/net/sock.h
index 91c1c8b..dcde2d9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -55,7 +55,7 @@
 #include <linux/uaccess.h>
 #include <linux/memcontrol.h>
 #include <linux/res_counter.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 
 #include <linux/filter.h>
 #include <linux/rculist_nulls.h>
@@ -924,13 +924,13 @@ inline void sk_refcnt_debug_release(const struct sock *sk)
 #endif /* SOCK_REFCNT_DEBUG */
 
 #if defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM) && defined(CONFIG_NET)
-extern struct jump_label_key memcg_socket_limit_enabled;
+extern struct static_key memcg_socket_limit_enabled;
 static inline struct cg_proto *parent_cg_proto(struct proto *proto,
 					       struct cg_proto *cg_proto)
 {
 	return proto->proto_cgroup(parent_mem_cgroup(cg_proto->memcg));
 }
-#define mem_cgroup_sockets_enabled static_branch(&memcg_socket_limit_enabled)
+#define mem_cgroup_sockets_enabled static_key_false(&memcg_socket_limit_enabled)
 #else
 #define mem_cgroup_sockets_enabled 0
 static inline struct cg_proto *parent_cg_proto(struct proto *proto,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7c3b9de..5e0f8bb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -128,7 +128,7 @@ enum event_type_t {
  * perf_sched_events : >0 events exist
  * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
  */
-struct jump_label_key_deferred perf_sched_events __read_mostly;
+struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 
 static atomic_t nr_mmap_events __read_mostly;
@@ -2769,7 +2769,7 @@ static void free_event(struct perf_event *event)
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec_deferred(&perf_sched_events);
+			static_key_slow_dec_deferred(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -2780,7 +2780,7 @@ static void free_event(struct perf_event *event)
 			put_callchain_buffers();
 		if (is_cgroup_event(event)) {
 			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
-			jump_label_dec_deferred(&perf_sched_events);
+			static_key_slow_dec_deferred(&perf_sched_events);
 		}
 	}
 
@@ -4982,7 +4982,7 @@ fail:
 	return err;
 }
 
-struct jump_label_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
+struct static_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 static void sw_perf_event_destroy(struct perf_event *event)
 {
@@ -4990,7 +4990,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 	WARN_ON(event->parent);
 
-	jump_label_dec(&perf_swevent_enabled[event_id]);
+	static_key_slow_dec(&perf_swevent_enabled[event_id]);
 	swevent_hlist_put(event);
 }
 
@@ -5020,7 +5020,7 @@ static int perf_swevent_init(struct perf_event *event)
 		if (err)
 			return err;
 
-		jump_label_inc(&perf_swevent_enabled[event_id]);
+		static_key_slow_inc(&perf_swevent_enabled[event_id]);
 		event->destroy = sw_perf_event_destroy;
 	}
 
@@ -5843,7 +5843,7 @@ done:
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_inc(&perf_sched_events.key);
+			static_key_slow_inc(&perf_sched_events.key);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -6081,7 +6081,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * - that may need work on context switch
 		 */
 		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
-		jump_label_inc(&perf_sched_events.key);
+		static_key_slow_inc(&perf_sched_events.key);
 	}
 
 	/*
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 543782e..1cc32e3 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/err.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 
 #ifdef HAVE_JUMP_LABEL
 
@@ -29,10 +29,11 @@ void jump_label_unlock(void)
 	mutex_unlock(&jump_label_mutex);
 }
 
-bool jump_label_enabled(struct jump_label_key *key)
+bool static_key_true(struct static_key *key)
 {
-	return !!atomic_read(&key->enabled);
+	return (atomic_read(&key->enabled) > 0);
 }
+EXPORT_SYMBOL_GPL(static_key_true);
 
 static int jump_label_cmp(const void *a, const void *b)
 {
@@ -58,22 +59,26 @@ jump_label_sort_entries(struct jump_entry *start, struct jump_entry *stop)
 	sort(start, size, sizeof(struct jump_entry), jump_label_cmp, NULL);
 }
 
-static void jump_label_update(struct jump_label_key *key, int enable);
+static void jump_label_update(struct static_key *key, int enable);
 
-void jump_label_inc(struct jump_label_key *key)
+void static_key_slow_inc(struct static_key *key)
 {
 	if (atomic_inc_not_zero(&key->enabled))
 		return;
 
 	jump_label_lock();
-	if (atomic_read(&key->enabled) == 0)
-		jump_label_update(key, JUMP_LABEL_ENABLE);
+	if (atomic_read(&key->enabled) == 0) {
+		if (!jump_label_get_branch_default(key))
+			jump_label_update(key, JUMP_LABEL_ENABLE);
+		else
+			jump_label_update(key, JUMP_LABEL_DISABLE);
+	}
 	atomic_inc(&key->enabled);
 	jump_label_unlock();
 }
-EXPORT_SYMBOL_GPL(jump_label_inc);
+EXPORT_SYMBOL_GPL(static_key_slow_inc);
 
-static void __jump_label_dec(struct jump_label_key *key,
+static void __static_key_slow_dec(struct static_key *key,
 		unsigned long rate_limit, struct delayed_work *work)
 {
 	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex)) {
@@ -85,32 +90,35 @@ static void __jump_label_dec(struct jump_label_key *key,
 	if (rate_limit) {
 		atomic_inc(&key->enabled);
 		schedule_delayed_work(work, rate_limit);
-	} else
-		jump_label_update(key, JUMP_LABEL_DISABLE);
-
+	} else {
+		if (!jump_label_get_branch_default(key))
+			jump_label_update(key, JUMP_LABEL_DISABLE);
+		else
+			jump_label_update(key, JUMP_LABEL_ENABLE);
+	}
 	jump_label_unlock();
 }
-EXPORT_SYMBOL_GPL(jump_label_dec);
 
 static void jump_label_update_timeout(struct work_struct *work)
 {
-	struct jump_label_key_deferred *key =
-		container_of(work, struct jump_label_key_deferred, work.work);
-	__jump_label_dec(&key->key, 0, NULL);
+	struct static_key_deferred *key =
+		container_of(work, struct static_key_deferred, work.work);
+	__static_key_slow_dec(&key->key, 0, NULL);
 }
 
-void jump_label_dec(struct jump_label_key *key)
+void static_key_slow_dec(struct static_key *key)
 {
-	__jump_label_dec(key, 0, NULL);
+	__static_key_slow_dec(key, 0, NULL);
 }
+EXPORT_SYMBOL_GPL(static_key_slow_dec);
 
-void jump_label_dec_deferred(struct jump_label_key_deferred *key)
+void static_key_slow_dec_deferred(struct static_key_deferred *key)
 {
-	__jump_label_dec(&key->key, key->timeout, &key->work);
+	__static_key_slow_dec(&key->key, key->timeout, &key->work);
 }
+EXPORT_SYMBOL_GPL(static_key_slow_dec_deferred);
 
-
-void jump_label_rate_limit(struct jump_label_key_deferred *key,
+void jump_label_rate_limit(struct static_key_deferred *key,
 		unsigned long rl)
 {
 	key->timeout = rl;
@@ -153,7 +161,7 @@ void __weak __init_or_module arch_jump_label_transform_static(struct jump_entry
 	arch_jump_label_transform(entry, type);	
 }
 
-static void __jump_label_update(struct jump_label_key *key,
+static void __jump_label_update(struct static_key *key,
 				struct jump_entry *entry,
 				struct jump_entry *stop, int enable)
 {
@@ -170,27 +178,40 @@ static void __jump_label_update(struct jump_label_key *key,
 	}
 }
 
+static enum jump_label_type jump_label_type(struct static_key *key)
+{
+	bool true_branch = jump_label_get_branch_default(key);
+	bool state = static_key_true(key);
+
+	if ((!true_branch && state) || (true_branch && !state))
+		return JUMP_LABEL_ENABLE;
+
+	return JUMP_LABEL_DISABLE;
+}
+
 void __init jump_label_init(void)
 {
 	struct jump_entry *iter_start = __start___jump_table;
 	struct jump_entry *iter_stop = __stop___jump_table;
-	struct jump_label_key *key = NULL;
+	struct static_key *key = NULL;
 	struct jump_entry *iter;
 
 	jump_label_lock();
 	jump_label_sort_entries(iter_start, iter_stop);
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		struct jump_label_key *iterk;
+		struct static_key *iterk;
 
-		iterk = (struct jump_label_key *)(unsigned long)iter->key;
-		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
-						 JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+		iterk = (struct static_key *)(unsigned long)iter->key;
+		arch_jump_label_transform_static(iter, jump_label_type(iterk));
 		if (iterk == key)
 			continue;
 
 		key = iterk;
-		key->entries = iter;
+		/*
+		 * Set key->entries to iter, but preserve JUMP_LABEL_TRUE_BRANCH.
+		 */
+		*((unsigned long *)&key->entries) += (unsigned long)iter;
 #ifdef CONFIG_MODULES
 		key->next = NULL;
 #endif
@@ -200,8 +221,8 @@ void __init jump_label_init(void)
 
 #ifdef CONFIG_MODULES
 
-struct jump_label_mod {
-	struct jump_label_mod *next;
+struct static_key_mod {
+	struct static_key_mod *next;
 	struct jump_entry *entries;
 	struct module *mod;
 };
@@ -221,9 +242,9 @@ static int __jump_label_mod_text_reserved(void *start, void *end)
 				start, end);
 }
 
-static void __jump_label_mod_update(struct jump_label_key *key, int enable)
+static void __jump_label_mod_update(struct static_key *key, int enable)
 {
-	struct jump_label_mod *mod = key->next;
+	struct static_key_mod *mod = key->next;
 
 	while (mod) {
 		struct module *m = mod->mod;
@@ -254,11 +275,7 @@ void jump_label_apply_nops(struct module *mod)
 		return;
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		struct jump_label_key *iterk;
-
-		iterk = (struct jump_label_key *)(unsigned long)iter->key;
-		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
-				JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+		arch_jump_label_transform_static(iter, JUMP_LABEL_DISABLE);
 	}
 }
 
@@ -267,8 +284,8 @@ static int jump_label_add_module(struct module *mod)
 	struct jump_entry *iter_start = mod->jump_entries;
 	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
 	struct jump_entry *iter;
-	struct jump_label_key *key = NULL;
-	struct jump_label_mod *jlm;
+	struct static_key *key = NULL;
+	struct static_key_mod *jlm;
 
 	/* if the module doesn't have jump label entries, just return */
 	if (iter_start == iter_stop)
@@ -277,28 +294,30 @@ static int jump_label_add_module(struct module *mod)
 	jump_label_sort_entries(iter_start, iter_stop);
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		if (iter->key == (jump_label_t)(unsigned long)key)
-			continue;
+		struct static_key *iterk;
 
-		key = (struct jump_label_key *)(unsigned long)iter->key;
+		iterk = (struct static_key *)(unsigned long)iter->key;
+		if (iterk == key)
+			continue;
 
+		key = iterk;
 		if (__module_address(iter->key) == mod) {
-			atomic_set(&key->enabled, 0);
-			key->entries = iter;
+			/*
+			 * Set key->entries to iter, but preserve JUMP_LABEL_TRUE_BRANCH.
+			 */
+			*((unsigned long *)&key->entries) += (unsigned long)iter;
 			key->next = NULL;
 			continue;
 		}
-
-		jlm = kzalloc(sizeof(struct jump_label_mod), GFP_KERNEL);
+		jlm = kzalloc(sizeof(struct static_key_mod), GFP_KERNEL);
 		if (!jlm)
 			return -ENOMEM;
-
 		jlm->mod = mod;
 		jlm->entries = iter;
 		jlm->next = key->next;
 		key->next = jlm;
 
-		if (jump_label_enabled(key))
+		if (jump_label_type(key) == JUMP_LABEL_ENABLE)
 			__jump_label_update(key, iter, iter_stop, JUMP_LABEL_ENABLE);
 	}
 
@@ -310,14 +329,14 @@ static void jump_label_del_module(struct module *mod)
 	struct jump_entry *iter_start = mod->jump_entries;
 	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
 	struct jump_entry *iter;
-	struct jump_label_key *key = NULL;
-	struct jump_label_mod *jlm, **prev;
+	struct static_key *key = NULL;
+	struct static_key_mod *jlm, **prev;
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
 		if (iter->key == (jump_label_t)(unsigned long)key)
 			continue;
 
-		key = (struct jump_label_key *)(unsigned long)iter->key;
+		key = (struct static_key *)(unsigned long)iter->key;
 
 		if (__module_address(iter->key) == mod)
 			continue;
@@ -419,9 +438,10 @@ int jump_label_text_reserved(void *start, void *end)
 	return ret;
 }
 
-static void jump_label_update(struct jump_label_key *key, int enable)
+static void jump_label_update(struct static_key *key, int enable)
 {
-	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
+	struct jump_entry *stop = __stop___jump_table;
+	struct jump_entry *entry = jump_label_get_entries(key);
 
 #ifdef CONFIG_MODULES
 	struct module *mod = __module_address((unsigned long)key);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..05fb5df 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -162,13 +162,13 @@ static int sched_feat_show(struct seq_file *m, void *v)
 
 #ifdef HAVE_JUMP_LABEL
 
-#define jump_label_key__true  jump_label_key_enabled
-#define jump_label_key__false jump_label_key_disabled
+#define jump_label_key__true  STATIC_KEY_INIT_TRUE
+#define jump_label_key__false STATIC_KEY_INIT_FALSE
 
 #define SCHED_FEAT(name, enabled)	\
 	jump_label_key__##enabled ,
 
-struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR] = {
+struct static_key sched_feat_keys[__SCHED_FEAT_NR] = {
 #include "features.h"
 };
 
@@ -176,14 +176,14 @@ struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR] = {
 
 static void sched_feat_disable(int i)
 {
-	if (jump_label_enabled(&sched_feat_keys[i]))
-		jump_label_dec(&sched_feat_keys[i]);
+	if (static_key_true(&sched_feat_keys[i]))
+		static_key_slow_dec(&sched_feat_keys[i]);
 }
 
 static void sched_feat_enable(int i)
 {
-	if (!jump_label_enabled(&sched_feat_keys[i]))
-		jump_label_inc(&sched_feat_keys[i]);
+	if (!static_key_true(&sched_feat_keys[i]))
+		static_key_slow_inc(&sched_feat_keys[i]);
 }
 #else
 static void sched_feat_disable(int i) { };
@@ -894,7 +894,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 	delta -= irq_delta;
 #endif
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
-	if (static_branch((&paravirt_steal_rq_enabled))) {
+	if (static_key_false((&paravirt_steal_rq_enabled))) {
 		u64 st;
 
 		steal = paravirt_steal_clock(cpu_of(rq));
@@ -2756,7 +2756,7 @@ void account_idle_time(cputime_t cputime)
 static __always_inline bool steal_account_process_tick(void)
 {
 #ifdef CONFIG_PARAVIRT
-	if (static_branch(&paravirt_steal_enabled)) {
+	if (static_key_false(&paravirt_steal_enabled)) {
 		u64 steal, st = 0;
 
 		steal = paravirt_steal_clock(smp_processor_id());
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c6414f..423547a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1399,20 +1399,20 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 #ifdef CONFIG_CFS_BANDWIDTH
 
 #ifdef HAVE_JUMP_LABEL
-static struct jump_label_key __cfs_bandwidth_used;
+static struct static_key __cfs_bandwidth_used;
 
 static inline bool cfs_bandwidth_used(void)
 {
-	return static_branch(&__cfs_bandwidth_used);
+	return static_key_false(&__cfs_bandwidth_used);
 }
 
 void account_cfs_bandwidth_used(int enabled, int was_enabled)
 {
 	/* only need to count groups transitioning between enabled/!enabled */
 	if (enabled && !was_enabled)
-		jump_label_inc(&__cfs_bandwidth_used);
+		static_key_slow_inc(&__cfs_bandwidth_used);
 	else if (!enabled && was_enabled)
-		jump_label_dec(&__cfs_bandwidth_used);
+		static_key_slow_dec(&__cfs_bandwidth_used);
 }
 #else /* HAVE_JUMP_LABEL */
 static bool cfs_bandwidth_used(void)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 98c0c26..b4cd6d8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -611,7 +611,7 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
 #ifdef CONFIG_SCHED_DEBUG
-# include <linux/jump_label.h>
+# include <linux/static_key.h>
 # define const_debug __read_mostly
 #else
 # define const_debug const
@@ -630,18 +630,18 @@ enum {
 #undef SCHED_FEAT
 
 #if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
-static __always_inline bool static_branch__true(struct jump_label_key *key)
+static __always_inline bool static_branch__true(struct static_key *key)
 {
-	return likely(static_branch(key)); /* Not out of line branch. */
+	return static_key_true(key); /* Not out of line branch. */
 }
 
-static __always_inline bool static_branch__false(struct jump_label_key *key)
+static __always_inline bool static_branch__false(struct static_key *key)
 {
-	return unlikely(static_branch(key)); /* Out of line branch. */
+	return static_key_false(key); /* Out of line branch. */
 }
 
 #define SCHED_FEAT(name, enabled)					\
-static __always_inline bool static_branch_##name(struct jump_label_key *key) \
+static __always_inline bool static_branch_##name(struct static_key *key) \
 {									\
 	return static_branch__##enabled(key);				\
 }
@@ -650,7 +650,7 @@ static __always_inline bool static_branch_##name(struct jump_label_key *key) \
 
 #undef SCHED_FEAT
 
-extern struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR];
+extern struct static_key sched_feat_keys[__SCHED_FEAT_NR];
 #define sched_feat(x) (static_branch_##x(&sched_feat_keys[__SCHED_FEAT_##x]))
 #else /* !(SCHED_DEBUG && HAVE_JUMP_LABEL) */
 #define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index f1539de..5e37c26 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -25,7 +25,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 
 extern struct tracepoint * const __start___tracepoints_ptrs[];
 extern struct tracepoint * const __stop___tracepoints_ptrs[];
@@ -256,9 +256,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 {
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
 
-	if (elem->regfunc && !jump_label_enabled(&elem->key) && active)
+	if (elem->regfunc && !static_key_true(&elem->key) && active)
 		elem->regfunc();
-	else if (elem->unregfunc && jump_label_enabled(&elem->key) && !active)
+	else if (elem->unregfunc && static_key_true(&elem->key) && !active)
 		elem->unregfunc();
 
 	/*
@@ -269,10 +269,10 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
-	if (active && !jump_label_enabled(&elem->key))
-		jump_label_inc(&elem->key);
-	else if (!active && jump_label_enabled(&elem->key))
-		jump_label_dec(&elem->key);
+	if (active && !static_key_true(&elem->key))
+		static_key_slow_inc(&elem->key);
+	else if (!active && static_key_true(&elem->key))
+		static_key_slow_dec(&elem->key);
 }
 
 /*
@@ -283,11 +283,11 @@ static void set_tracepoint(struct tracepoint_entry **entry,
  */
 static void disable_tracepoint(struct tracepoint *elem)
 {
-	if (elem->unregfunc && jump_label_enabled(&elem->key))
+	if (elem->unregfunc && static_key_true(&elem->key))
 		elem->unregfunc();
 
-	if (jump_label_enabled(&elem->key))
-		jump_label_dec(&elem->key);
+	if (static_key_true(&elem->key))
+		static_key_slow_dec(&elem->key);
 	rcu_assign_pointer(elem->funcs, NULL);
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 115dee1..da7ce7f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -134,7 +134,7 @@
 #include <linux/inetdevice.h>
 #include <linux/cpu_rmap.h>
 #include <linux/net_tstamp.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 #include <net/flow_keys.h>
 
 #include "net-sysfs.h"
@@ -1441,11 +1441,11 @@ int call_netdevice_notifiers(unsigned long val, struct net_device *dev)
 }
 EXPORT_SYMBOL(call_netdevice_notifiers);
 
-static struct jump_label_key netstamp_needed __read_mostly;
+static struct static_key netstamp_needed __read_mostly;
 #ifdef HAVE_JUMP_LABEL
-/* We are not allowed to call jump_label_dec() from irq context
+/* We are not allowed to call static_key_slow_dec() from irq context
  * If net_disable_timestamp() is called from irq context, defer the
- * jump_label_dec() calls.
+ * static_key_slow_dec() calls.
  */
 static atomic_t netstamp_needed_deferred;
 #endif
@@ -1457,12 +1457,12 @@ void net_enable_timestamp(void)
 
 	if (deferred) {
 		while (--deferred)
-			jump_label_dec(&netstamp_needed);
+			static_key_slow_dec(&netstamp_needed);
 		return;
 	}
 #endif
 	WARN_ON(in_interrupt());
-	jump_label_inc(&netstamp_needed);
+	static_key_slow_inc(&netstamp_needed);
 }
 EXPORT_SYMBOL(net_enable_timestamp);
 
@@ -1474,19 +1474,19 @@ void net_disable_timestamp(void)
 		return;
 	}
 #endif
-	jump_label_dec(&netstamp_needed);
+	static_key_slow_dec(&netstamp_needed);
 }
 EXPORT_SYMBOL(net_disable_timestamp);
 
 static inline void net_timestamp_set(struct sk_buff *skb)
 {
 	skb->tstamp.tv64 = 0;
-	if (static_branch(&netstamp_needed))
+	if (static_key_false(&netstamp_needed))
 		__net_timestamp(skb);
 }
 
 #define net_timestamp_check(COND, SKB)			\
-	if (static_branch(&netstamp_needed)) {		\
+	if (static_key_false(&netstamp_needed)) {		\
 		if ((COND) && !(SKB)->tstamp.tv64)	\
 			__net_timestamp(SKB);		\
 	}						\
@@ -2660,7 +2660,7 @@ EXPORT_SYMBOL(__skb_get_rxhash);
 struct rps_sock_flow_table __rcu *rps_sock_flow_table __read_mostly;
 EXPORT_SYMBOL(rps_sock_flow_table);
 
-struct jump_label_key rps_needed __read_mostly;
+struct static_key rps_needed __read_mostly;
 
 static struct rps_dev_flow *
 set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
@@ -2945,7 +2945,7 @@ int netif_rx(struct sk_buff *skb)
 
 	trace_netif_rx(skb);
 #ifdef CONFIG_RPS
-	if (static_branch(&rps_needed))	{
+	if (static_key_false(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu;
 
@@ -3309,7 +3309,7 @@ int netif_receive_skb(struct sk_buff *skb)
 		return NET_RX_SUCCESS;
 
 #ifdef CONFIG_RPS
-	if (static_branch(&rps_needed)) {
+	if (static_key_false(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
 		int cpu, ret;
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index a1727cd..4955862 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -608,10 +608,10 @@ static ssize_t store_rps_map(struct netdev_rx_queue *queue,
 	spin_unlock(&rps_map_lock);
 
 	if (map)
-		jump_label_inc(&rps_needed);
+		static_key_slow_inc(&rps_needed);
 	if (old_map) {
 		kfree_rcu(old_map, rcu);
-		jump_label_dec(&rps_needed);
+		static_key_slow_dec(&rps_needed);
 	}
 	free_cpumask_var(mask);
 	return len;
diff --git a/net/core/sock.c b/net/core/sock.c
index 3e81fd2..3a4e581 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -111,7 +111,7 @@
 #include <linux/init.h>
 #include <linux/highmem.h>
 #include <linux/user_namespace.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 #include <linux/memcontrol.h>
 
 #include <asm/uaccess.h>
@@ -184,7 +184,7 @@ void mem_cgroup_sockets_destroy(struct cgroup *cgrp, struct cgroup_subsys *ss)
 static struct lock_class_key af_family_keys[AF_MAX];
 static struct lock_class_key af_family_slock_keys[AF_MAX];
 
-struct jump_label_key memcg_socket_limit_enabled;
+struct static_key memcg_socket_limit_enabled;
 EXPORT_SYMBOL(memcg_socket_limit_enabled);
 
 /*
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index d05559d..0c28508 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -69,9 +69,9 @@ static int rps_sock_flow_sysctl(ctl_table *table, int write,
 		if (sock_table != orig_sock_table) {
 			rcu_assign_pointer(rps_sock_flow_table, sock_table);
 			if (sock_table)
-				jump_label_inc(&rps_needed);
+				static_key_slow_inc(&rps_needed);
 			if (orig_sock_table) {
-				jump_label_dec(&rps_needed);
+				static_key_slow_dec(&rps_needed);
 				synchronize_rcu();
 				vfree(orig_sock_table);
 			}
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index 4997878..602fb30 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -111,7 +111,7 @@ void tcp_destroy_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	val = res_counter_read_u64(&tcp->tcp_memory_allocated, RES_LIMIT);
 
 	if (val != RESOURCE_MAX)
-		jump_label_dec(&memcg_socket_limit_enabled);
+		static_key_slow_dec(&memcg_socket_limit_enabled);
 }
 EXPORT_SYMBOL(tcp_destroy_cgroup);
 
@@ -143,9 +143,9 @@ static int tcp_update_limit(struct mem_cgroup *memcg, u64 val)
 					     net->ipv4.sysctl_tcp_mem[i]);
 
 	if (val == RESOURCE_MAX && old_lim != RESOURCE_MAX)
-		jump_label_dec(&memcg_socket_limit_enabled);
+		static_key_slow_dec(&memcg_socket_limit_enabled);
 	else if (old_lim == RESOURCE_MAX && val != RESOURCE_MAX)
-		jump_label_inc(&memcg_socket_limit_enabled);
+		static_key_slow_inc(&memcg_socket_limit_enabled);
 
 	return 0;
 }
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b4e8ff0..e1b7e05 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -56,7 +56,7 @@ struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS] __read_mostly;
 EXPORT_SYMBOL(nf_hooks);
 
 #if defined(CONFIG_JUMP_LABEL)
-struct jump_label_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
+struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 EXPORT_SYMBOL(nf_hooks_needed);
 #endif
 
@@ -77,7 +77,7 @@ int nf_register_hook(struct nf_hook_ops *reg)
 	list_add_rcu(&reg->list, elem->list.prev);
 	mutex_unlock(&nf_hook_mutex);
 #if defined(CONFIG_JUMP_LABEL)
-	jump_label_inc(&nf_hooks_needed[reg->pf][reg->hooknum]);
+	static_key_slow_inc(&nf_hooks_needed[reg->pf][reg->hooknum]);
 #endif
 	return 0;
 }
@@ -89,7 +89,7 @@ void nf_unregister_hook(struct nf_hook_ops *reg)
 	list_del_rcu(&reg->list);
 	mutex_unlock(&nf_hook_mutex);
 #if defined(CONFIG_JUMP_LABEL)
-	jump_label_dec(&nf_hooks_needed[reg->pf][reg->hooknum]);
+	static_key_slow_dec(&nf_hooks_needed[reg->pf][reg->hooknum]);
 #endif
 	synchronize_net();
 }
