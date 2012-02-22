Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2BVI6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:58:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47355 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab2BVI6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:58:37 -0500
Date: Wed, 22 Feb 2012 09:58:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] static keys: Introduce 'struct static_key',
 very_[un]likely(), static_key_slow_[inc|dec]()
Message-ID: <20120222085809.GA26397@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222081855.GB25318@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So here's a boot tested patch on top of Jason's series that does 
all the cleanups I talked about and turns jump labels into a 
more intuitive to use facility. It should also address the 
various misconceptions and confusions that surround jump labels.

Typical usage scenarios:

        #include <linux/static_key.h>

        struct static_key key = STATIC_KEY_INIT_TRUE;



        if (very_unlikely(&key))
                do unlikely code
        else
                do likely code

Or:

        if (very_likely(&key))
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

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
---
 Documentation/jump-label.txt          |   38 ++++++++---------
 arch/ia64/include/asm/paravirt.h      |    6 +-
 arch/ia64/kernel/paravirt.c           |    4 -
 arch/mips/include/asm/jump_label.h    |    2 
 arch/powerpc/include/asm/jump_label.h |    2 
 arch/s390/include/asm/jump_label.h    |    2 
 arch/sparc/include/asm/jump_label.h   |    2 
 arch/x86/include/asm/jump_label.h     |    6 +-
 arch/x86/include/asm/paravirt.h       |    6 +-
 arch/x86/kernel/kvm.c                 |    4 -
 arch/x86/kernel/paravirt.c            |    4 -
 arch/x86/kvm/mmu_audit.c              |    6 +-
 include/linux/jump_label.h            |   76 +++++++++++++++++-----------------
 include/linux/netdevice.h             |    4 -
 include/linux/netfilter.h             |    4 -
 include/linux/perf_api.h              |    2 
 include/linux/perf_event.h            |    6 +-
 include/linux/static_key.h            |    1 
 include/linux/tracepoint.h            |    6 +-
 include/net/sock.h                    |    4 -
 kernel/events/core.c                  |   16 +++----
 kernel/jump_label.c                   |   72 ++++++++++++++++----------------
 kernel/sched/core.c                   |   14 +++---
 kernel/sched/fair.c                   |    6 +-
 kernel/sched/sched.h                  |   10 ++--
 kernel/tracepoint.c                   |   20 ++++----
 net/core/dev.c                        |   16 +++----
 net/core/net-sysfs.c                  |    4 -
 net/core/sock.c                       |    4 -
 net/core/sysctl_net_core.c            |    4 -
 net/ipv4/tcp_memcontrol.c             |    6 +-
 net/netfilter/core.c                  |    6 +-
 32 files changed, 182 insertions(+), 181 deletions(-)

Index: linux/Documentation/jump-label.txt
===================================================================
--- linux.orig/Documentation/jump-label.txt
+++ linux/Documentation/jump-label.txt
@@ -32,7 +32,7 @@ the branch site to change the branch dir
 
 For example, if we have a simple branch that is disabled by default:
 
-	if (very_unlikely(&jump_key))
+	if (very_unlikely(&key))
 		printk("I am the true branch\n");
 
 Thus, by default the 'printk' will not be emitted. And the code generated will
@@ -48,58 +48,58 @@ basically 'free'. That is the basic trad
 
 In order to use a jump label you much first define a key:
 
-	struct jump_label_key jump_key;
+	struct static_key key;
 
 Which is initialized as:
 
-	struct jump_label_key jump_key = JUMP_LABEL_INIT_TRUE;
+	struct static_key key = STATIC_KEY_INIT_TRUE;
 
 or:
 
-	struct jump_label_Key jump_key = JUMP_LABEL_INIT_FALSE;
+	struct static_key key = STATIC_KEY_INIT_FALSE;
 
 If the key is not initialized, it is default false. The
-'struct jump_label_key', must be a 'global'. That is, it can't be allocated on
+'struct static_key', must be a 'global'. That is, it can't be allocated on
 the stack or dynamically allocated at run-time.
 
 The key is then used in code as:
 
-        if (very_unlikely(&jump_key))
+        if (very_unlikely(&key))
                 do unlikely code
         else
                 do likely code
 
 Or:
 
-        if (very_likely(&jump_key))
+        if (very_likely(&key))
                 do likely code
         else
                 do unlikely code
 
-A key that is initialized via 'JUMP_LABEL_INIT_FALSE', must be used in a
+A key that is initialized via 'STATIC_KEY_INIT_FALSE', must be used in a
 'very_unlikely()' construct. Likewise, a key initialized via
-'JUMP_LABEL_INIT_TRUE' must be used in a 'very_likely()' construct.
+'STATIC_KEY_INIT_TRUE' must be used in a 'very_likely()' construct.
 A single key can be used in many branches, but all the branches must match
 the way that the key has been initialized.
 
 The branch(es) can then be switched via:
 
-            jump_label_inc(&jump_key);
-            jump_label_dec(&jump_key);
+            static_key_slow_inc(&key);
+            static_key_slow_dec(&key);
 
-Thus, 'jump_label_inc()' means 'make the branch true', and
-'jump_label_dec()' means 'make the the branch false' with appropriate reference
-counting. For example, if the key is initialized true, a jump_label_dec(), will
-switch the branch to false. And a subsequent jump_label_inc(), will change
+Thus, 'static_key_slow_inc()' means 'make the branch true', and
+'static_key_slow_dec()' means 'make the the branch false' with appropriate reference
+counting. For example, if the key is initialized true, a static_key_slow_dec(), will
+switch the branch to false. And a subsequent static_key_slow_inc(), will change
 the branch back to true. Likewise, if the key is initialized false, a
-'jump_label_inc()', will change the branch to true. And then a
-'jump_label_dec()', will again make the branch false.
+'static_key_slow_inc()', will change the branch to true. And then a
+'static_key_slow_dec()', will again make the branch false.
 
 An example usage in the kernel is the implementation of tracepoints:
 
         static inline void trace_##name(proto)                          \
         {                                                               \
-                if (very_unlikely(&__tracepoint_##name.key))  		\
+                if (very_unlikely(&__tracepoint_##name.key))		\
                         __DO_TRACE(&__tracepoint_##name,                \
                                 TP_PROTO(data_proto),                   \
                                 TP_ARGS(data_args),                     \
@@ -122,7 +122,7 @@ simply fall back to a traditional, load,
 
 * #define JUMP_LABEL_NOP_SIZE, see: arch/x86/include/asm/jump_label.h
 
-* __always_inline bool arch_static_branch(struct jump_label_key *key), see:
+* __always_inline bool arch_static_branch(struct static_key *key), see:
 					arch/x86/include/asm/jump_label.h
 
 * void arch_jump_label_transform(struct jump_entry *entry, enum jump_label_type type),
Index: linux/arch/ia64/include/asm/paravirt.h
===================================================================
--- linux.orig/arch/ia64/include/asm/paravirt.h
+++ linux/arch/ia64/include/asm/paravirt.h
@@ -281,9 +281,9 @@ paravirt_init_missing_ticks_accounting(i
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
Index: linux/arch/ia64/kernel/paravirt.c
===================================================================
--- linux.orig/arch/ia64/kernel/paravirt.c
+++ linux/arch/ia64/kernel/paravirt.c
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
Index: linux/arch/mips/include/asm/jump_label.h
===================================================================
--- linux.orig/arch/mips/include/asm/jump_label.h
+++ linux/arch/mips/include/asm/jump_label.h
@@ -20,7 +20,7 @@
 #define WORD_INSN ".word"
 #endif
 
-static __always_inline bool arch_static_branch(struct jump_label_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("1:\tnop\n\t"
 		"nop\n\t"
Index: linux/arch/powerpc/include/asm/jump_label.h
===================================================================
--- linux.orig/arch/powerpc/include/asm/jump_label.h
+++ linux/arch/powerpc/include/asm/jump_label.h
@@ -17,7 +17,7 @@
 #define JUMP_ENTRY_TYPE		stringify_in_c(FTR_ENTRY_LONG)
 #define JUMP_LABEL_NOP_SIZE	4
 
-static __always_inline bool arch_static_branch(struct jump_label_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("1:\n\t"
 		 "nop\n\t"
Index: linux/arch/s390/include/asm/jump_label.h
===================================================================
--- linux.orig/arch/s390/include/asm/jump_label.h
+++ linux/arch/s390/include/asm/jump_label.h
@@ -13,7 +13,7 @@
 #define ASM_ALIGN ".balign 4"
 #endif
 
-static __always_inline bool arch_static_branch(struct jump_label_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("0:	brcl 0,0\n"
 		".pushsection __jump_table, \"aw\"\n"
Index: linux/arch/sparc/include/asm/jump_label.h
===================================================================
--- linux.orig/arch/sparc/include/asm/jump_label.h
+++ linux/arch/sparc/include/asm/jump_label.h
@@ -7,7 +7,7 @@
 
 #define JUMP_LABEL_NOP_SIZE 4
 
-static __always_inline bool arch_static_branch(struct jump_label_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key)
 {
 		asm goto("1:\n\t"
 			 "nop\n\t"
Index: linux/arch/x86/include/asm/jump_label.h
===================================================================
--- linux.orig/arch/x86/include/asm/jump_label.h
+++ linux/arch/x86/include/asm/jump_label.h
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
Index: linux/arch/x86/include/asm/paravirt.h
===================================================================
--- linux.orig/arch/x86/include/asm/paravirt.h
+++ linux/arch/x86/include/asm/paravirt.h
@@ -230,9 +230,9 @@ static inline unsigned long long paravir
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
Index: linux/arch/x86/kernel/kvm.c
===================================================================
--- linux.orig/arch/x86/kernel/kvm.c
+++ linux/arch/x86/kernel/kvm.c
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
Index: linux/arch/x86/kernel/paravirt.c
===================================================================
--- linux.orig/arch/x86/kernel/paravirt.c
+++ linux/arch/x86/kernel/paravirt.c
@@ -202,8 +202,8 @@ static void native_flush_tlb_single(unsi
 	__native_flush_tlb_single(addr);
 }
 
-struct jump_label_key paravirt_steal_enabled;
-struct jump_label_key paravirt_steal_rq_enabled;
+struct static_key paravirt_steal_enabled;
+struct static_key paravirt_steal_rq_enabled;
 
 static u64 native_steal_clock(int cpu)
 {
Index: linux/arch/x86/kvm/mmu_audit.c
===================================================================
--- linux.orig/arch/x86/kvm/mmu_audit.c
+++ linux/arch/x86/kvm/mmu_audit.c
@@ -234,7 +234,7 @@ static void audit_vcpu_spte(struct kvm_v
 }
 
 static bool mmu_audit;
-static struct jump_label_key mmu_audit_key;
+static struct static_key mmu_audit_key;
 
 static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
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
 
Index: linux/include/linux/jump_label.h
===================================================================
--- linux.orig/include/linux/jump_label.h
+++ linux/include/linux/jump_label.h
@@ -13,11 +13,11 @@
  * defaults to false - and the true block is placed out of line).
  *
  * However at runtime we can change the branch target using
- * jump_label_{inc,dec}(). These function as a 'reference' count on the key
+ * static_key_slow_{inc,dec}(). These function as a 'reference' count on the key
  * object and for as long as there are references all branches referring to
  * that particular key will point to the (out of line) true block.
  *
- * Since this relies on modifying code the jump_label_{inc,dec}() functions
+ * Since this relies on modifying code the static_key_slow_{inc,dec}() functions
  * must be considered absolute slow paths (machine wide synchronization etc.).
  * OTOH, since the affected branches are unconditional their runtime overhead
  * will be absolutely minimal, esp. in the default (off) case where the total
@@ -26,13 +26,13 @@
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
  *
- * struct jump_label_key my_key = JUMP_LABEL_INIT_TRUE;
+ * struct static_key my_key = STATIC_KEY_INIT_TRUE;
  *
  *   if (very_likely(&my_key)) {
  *   }
@@ -42,7 +42,7 @@
  * allowed.
  *
  * Not initializing the key (static data is initialized to 0s anyway) is the
- * same as using JUMP_LABEL_INIT_FALSE and very_unlikely() is
+ * same as using STATIC_KEY_INIT_FALSE and very_unlikely() is
  * equivalent with static_branch().
  *
 */
@@ -53,17 +53,17 @@
 
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 
-struct jump_label_key {
+struct static_key {
 	atomic_t enabled;
 /* Set lsb bit to 1 if branch is default true, 0 ot */
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
@@ -84,31 +84,31 @@ struct module;
 #define JUMP_LABEL_TRUE_BRANCH 1UL
 
 static
-inline struct jump_entry *jump_label_get_entries(struct jump_label_key *key)
+inline struct jump_entry *jump_label_get_entries(struct static_key *key)
 {
 	return (struct jump_entry *)((unsigned long)key->entries
 						& ~JUMP_LABEL_TRUE_BRANCH);
 }
 
-static inline bool jump_label_get_branch_default(struct jump_label_key *key)
+static inline bool jump_label_get_branch_default(struct static_key *key)
 {
 	if ((unsigned long)key->entries & JUMP_LABEL_TRUE_BRANCH)
 		return true;
 	return false;
 }
 
-static __always_inline bool very_unlikely(struct jump_label_key *key)
+static __always_inline bool very_unlikely(struct static_key *key)
 {
 	return arch_static_branch(key);
 }
 
-static __always_inline bool very_likely(struct jump_label_key *key)
+static __always_inline bool very_likely(struct static_key *key)
 {
 	return !very_unlikely(key);
 }
 
 /* Deprecated. Please use 'very_unlikely() instead. */
-static __always_inline bool static_branch(struct jump_label_key *key)
+static __always_inline bool static_branch(struct static_key *key)
 {
 	return arch_static_branch(key);
 }
@@ -124,24 +124,24 @@ extern void arch_jump_label_transform(st
 extern void arch_jump_label_transform_static(struct jump_entry *entry,
 					     enum jump_label_type type);
 extern int jump_label_text_reserved(void *start, void *end);
-extern void jump_label_inc(struct jump_label_key *key);
-extern void jump_label_dec(struct jump_label_key *key);
-extern void jump_label_dec_deferred(struct jump_label_key_deferred *key);
-extern bool jump_label_true(struct jump_label_key *key);
+extern void static_key_slow_inc(struct static_key *key);
+extern void static_key_slow_dec(struct static_key *key);
+extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
+extern bool static_key_true(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 extern void
-jump_label_rate_limit(struct jump_label_key_deferred *key, unsigned long rl);
+jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
 
-#define JUMP_LABEL_INIT_TRUE ((struct jump_label_key) \
+#define STATIC_KEY_INIT_TRUE ((struct static_key) \
 	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
-#define JUMP_LABEL_INIT_FALSE ((struct jump_label_key) \
+#define STATIC_KEY_INIT_FALSE ((struct static_key) \
 	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
 
 #else  /* !HAVE_JUMP_LABEL */
 
 #include <linux/atomic.h>
 
-struct jump_label_key {
+struct static_key {
 	atomic_t enabled;
 };
 
@@ -149,18 +149,18 @@ static __always_inline void jump_label_i
 {
 }
 
-struct jump_label_key_deferred {
-	struct jump_label_key  key;
+struct static_key_deferred {
+	struct static_key  key;
 };
 
-static __always_inline bool very_unlikely(struct jump_label_key *key)
+static __always_inline bool very_unlikely(struct static_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)) > 0)
 		return true;
 	return false;
 }
 
-static __always_inline bool very_likely(struct jump_label_key *key)
+static __always_inline bool very_likely(struct static_key *key)
 {
 	if (likely(atomic_read(&key->enabled)) > 0)
 		return true;
@@ -168,26 +168,26 @@ static __always_inline bool very_likely(
 }
 
 /* Deprecated. Please use 'very_unlikely() instead. */
-static __always_inline bool static_branch(struct jump_label_key *key)
+static __always_inline bool static_branch(struct static_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)) > 0)
 		return true;
 	return false;
 }
 
-static inline void jump_label_inc(struct jump_label_key *key)
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
@@ -198,7 +198,7 @@ static inline int jump_label_text_reserv
 static inline void jump_label_lock(void) {}
 static inline void jump_label_unlock(void) {}
 
-static inline bool jump_label_true(struct jump_label_key *key)
+static inline bool static_key_true(struct static_key *key)
 {
 	return (atomic_read(&key->enabled) > 0);
 }
@@ -209,19 +209,19 @@ static inline int jump_label_apply_nops(
 }
 
 static inline void
-jump_label_rate_limit(struct jump_label_key_deferred *key,
+jump_label_rate_limit(struct static_key_deferred *key,
 		unsigned long rl)
 {
 }
 
-#define JUMP_LABEL_INIT_TRUE ((struct jump_label_key) \
+#define STATIC_KEY_INIT_TRUE ((struct static_key) \
 		{ .enabled = ATOMIC_INIT(1) })
-#define JUMP_LABEL_INIT_FALSE ((struct jump_label_key) \
+#define STATIC_KEY_INIT_FALSE ((struct static_key) \
 		{ .enabled = ATOMIC_INIT(0) })
 
 #endif	/* HAVE_JUMP_LABEL */
 
-#define JUMP_LABEL_INIT JUMP_LABEL_INIT_FALSE
-#define jump_label_enabled jump_label_true
+#define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
+#define jump_label_enabled static_key_true
 
 #endif	/* _LINUX_JUMP_LABEL_H */
Index: linux/include/linux/netdevice.h
===================================================================
--- linux.orig/include/linux/netdevice.h
+++ linux/include/linux/netdevice.h
@@ -214,8 +214,8 @@ enum {
 #include <linux/skbuff.h>
 
 #ifdef CONFIG_RPS
-#include <linux/jump_label.h>
-extern struct jump_label_key rps_needed;
+#include <linux/static_key.h>
+extern struct static_key rps_needed;
 #endif
 
 struct neighbour;
Index: linux/include/linux/netfilter.h
===================================================================
--- linux.orig/include/linux/netfilter.h
+++ linux/include/linux/netfilter.h
@@ -163,8 +163,8 @@ extern struct ctl_path nf_net_ipv4_netfi
 extern struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 
 #if defined(CONFIG_JUMP_LABEL)
-#include <linux/jump_label.h>
-extern struct jump_label_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
+#include <linux/static_key.h>
+extern struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 static inline bool nf_hooks_active(u_int8_t pf, unsigned int hook)
 {
 	if (__builtin_constant_p(pf) &&
Index: linux/include/linux/perf_api.h
===================================================================
--- linux.orig/include/linux/perf_api.h
+++ linux/include/linux/perf_api.h
@@ -29,7 +29,7 @@ static inline void perf_fetch_caller_reg
 	perf_arch_fetch_caller_regs(regs, ((unsigned long)__builtin_return_address(0)));
 }
 
-extern struct jump_label_key perf_swevent_enabled[];
+extern struct static_key perf_swevent_enabled[];
 
 static __always_inline void
 perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
Index: linux/include/linux/perf_event.h
===================================================================
--- linux.orig/include/linux/perf_event.h
+++ linux/include/linux/perf_event.h
@@ -514,7 +514,7 @@ struct perf_guest_info_callbacks {
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 #include <linux/atomic.h>
 #include <asm/local.h>
 
@@ -1038,7 +1038,7 @@ static inline int is_software_event(stru
 	return event->pmu->task_ctx_nr == perf_sw_context;
 }
 
-extern struct jump_label_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
+extern struct static_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, struct pt_regs *, u64);
 
@@ -1075,7 +1075,7 @@ perf_sw_event(u32 event_id, u64 nr, stru
 	}
 }
 
-extern struct jump_label_key_deferred perf_sched_events;
+extern struct static_key_deferred perf_sched_events;
 
 static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
Index: linux/include/linux/static_key.h
===================================================================
--- /dev/null
+++ linux/include/linux/static_key.h
@@ -0,0 +1 @@
+#include <linux/jump_label.h>
Index: linux/include/linux/tracepoint.h
===================================================================
--- linux.orig/include/linux/tracepoint.h
+++ linux/include/linux/tracepoint.h
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
@@ -188,7 +188,7 @@ static inline void tracepoint_synchroniz
 	__attribute__((section("__tracepoints_strings"))) = #name;	 \
 	struct tracepoint __tracepoint_##name				 \
 	__attribute__((section("__tracepoints"))) =			 \
-		{ __tpstrtab_##name, JUMP_LABEL_INIT_FALSE, reg, unreg, NULL };\
+		{ __tpstrtab_##name, STATIC_KEY_INIT_FALSE, reg, unreg, NULL };\
 	static struct tracepoint * const __tracepoint_ptr_##name __used	 \
 	__attribute__((section("__tracepoints_ptrs"))) =		 \
 		&__tracepoint_##name;
Index: linux/include/net/sock.h
===================================================================
--- linux.orig/include/net/sock.h
+++ linux/include/net/sock.h
@@ -55,7 +55,7 @@
 #include <linux/uaccess.h>
 #include <linux/memcontrol.h>
 #include <linux/res_counter.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 
 #include <linux/filter.h>
 #include <linux/rculist_nulls.h>
@@ -924,7 +924,7 @@ inline void sk_refcnt_debug_release(cons
 #endif /* SOCK_REFCNT_DEBUG */
 
 #if defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM) && defined(CONFIG_NET)
-extern struct jump_label_key memcg_socket_limit_enabled;
+extern struct static_key memcg_socket_limit_enabled;
 static inline struct cg_proto *parent_cg_proto(struct proto *proto,
 					       struct cg_proto *cg_proto)
 {
Index: linux/kernel/events/core.c
===================================================================
--- linux.orig/kernel/events/core.c
+++ linux/kernel/events/core.c
@@ -128,7 +128,7 @@ enum event_type_t {
  * perf_sched_events : >0 events exist
  * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
  */
-struct jump_label_key_deferred perf_sched_events __read_mostly;
+struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 
 static atomic_t nr_mmap_events __read_mostly;
@@ -2769,7 +2769,7 @@ static void free_event(struct perf_event
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec_deferred(&perf_sched_events);
+			static_key_slow_dec_deferred(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -2780,7 +2780,7 @@ static void free_event(struct perf_event
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
@@ -4990,7 +4990,7 @@ static void sw_perf_event_destroy(struct
 
 	WARN_ON(event->parent);
 
-	jump_label_dec(&perf_swevent_enabled[event_id]);
+	static_key_slow_dec(&perf_swevent_enabled[event_id]);
 	swevent_hlist_put(event);
 }
 
@@ -5020,7 +5020,7 @@ static int perf_swevent_init(struct perf
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
Index: linux/kernel/jump_label.c
===================================================================
--- linux.orig/kernel/jump_label.c
+++ linux/kernel/jump_label.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/err.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 
 #ifdef HAVE_JUMP_LABEL
 
@@ -29,11 +29,11 @@ void jump_label_unlock(void)
 	mutex_unlock(&jump_label_mutex);
 }
 
-bool jump_label_true(struct jump_label_key *key)
+bool static_key_true(struct static_key *key)
 {
 	return (atomic_read(&key->enabled) > 0);
 }
-EXPORT_SYMBOL_GPL(jump_label_true);
+EXPORT_SYMBOL_GPL(static_key_true);
 
 static int jump_label_cmp(const void *a, const void *b)
 {
@@ -59,9 +59,9 @@ jump_label_sort_entries(struct jump_entr
 	sort(start, size, sizeof(struct jump_entry), jump_label_cmp, NULL);
 }
 
-static void jump_label_update(struct jump_label_key *key, int enable);
+static void jump_label_update(struct static_key *key, int enable);
 
-void jump_label_inc(struct jump_label_key *key)
+void static_key_slow_inc(struct static_key *key)
 {
 	if (atomic_inc_not_zero(&key->enabled))
 		return;
@@ -76,9 +76,9 @@ void jump_label_inc(struct jump_label_ke
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
@@ -101,24 +101,24 @@ static void __jump_label_dec(struct jump
 
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
-EXPORT_SYMBOL_GPL(jump_label_dec);
+EXPORT_SYMBOL_GPL(static_key_slow_dec);
 
-void jump_label_dec_deferred(struct jump_label_key_deferred *key)
+void static_key_slow_dec_deferred(struct static_key_deferred *key)
 {
-	__jump_label_dec(&key->key, key->timeout, &key->work);
+	__static_key_slow_dec(&key->key, key->timeout, &key->work);
 }
-EXPORT_SYMBOL_GPL(jump_label_dec_deferred);
+EXPORT_SYMBOL_GPL(static_key_slow_dec_deferred);
 
-void jump_label_rate_limit(struct jump_label_key_deferred *key,
+void jump_label_rate_limit(struct static_key_deferred *key,
 		unsigned long rl)
 {
 	key->timeout = rl;
@@ -161,7 +161,7 @@ void __weak __init_or_module arch_jump_l
 	arch_jump_label_transform(entry, type);	
 }
 
-static void __jump_label_update(struct jump_label_key *key,
+static void __jump_label_update(struct static_key *key,
 				struct jump_entry *entry,
 				struct jump_entry *stop, int enable)
 {
@@ -178,10 +178,10 @@ static void __jump_label_update(struct j
 	}
 }
 
-static enum jump_label_type jump_label_type(struct jump_label_key *key)
+static enum jump_label_type jump_label_type(struct static_key *key)
 {
 	bool true_branch = jump_label_get_branch_default(key);
-	bool state = jump_label_true(key);
+	bool state = static_key_true(key);
 
 	if ((!true_branch && state) || (true_branch && !state))
 		return JUMP_LABEL_ENABLE;
@@ -193,16 +193,16 @@ void __init jump_label_init(void)
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
+		iterk = (struct static_key *)(unsigned long)iter->key;
 		arch_jump_label_transform_static(iter, jump_label_type(iterk));
 		if (iterk == key)
 			continue;
@@ -221,8 +221,8 @@ void __init jump_label_init(void)
 
 #ifdef CONFIG_MODULES
 
-struct jump_label_mod {
-	struct jump_label_mod *next;
+struct static_key_mod {
+	struct static_key_mod *next;
 	struct jump_entry *entries;
 	struct module *mod;
 };
@@ -242,9 +242,9 @@ static int __jump_label_mod_text_reserve
 				start, end);
 }
 
-static void __jump_label_mod_update(struct jump_label_key *key, int enable)
+static void __jump_label_mod_update(struct static_key *key, int enable)
 {
-	struct jump_label_mod *mod = key->next;
+	struct static_key_mod *mod = key->next;
 
 	while (mod) {
 		struct module *m = mod->mod;
@@ -284,8 +284,8 @@ static int jump_label_add_module(struct 
 	struct jump_entry *iter_start = mod->jump_entries;
 	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
 	struct jump_entry *iter;
-	struct jump_label_key *key = NULL;
-	struct jump_label_mod *jlm;
+	struct static_key *key = NULL;
+	struct static_key_mod *jlm;
 
 	/* if the module doesn't have jump label entries, just return */
 	if (iter_start == iter_stop)
@@ -294,9 +294,9 @@ static int jump_label_add_module(struct 
 	jump_label_sort_entries(iter_start, iter_stop);
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		struct jump_label_key *iterk;
+		struct static_key *iterk;
 
-		iterk = (struct jump_label_key *)(unsigned long)iter->key;
+		iterk = (struct static_key *)(unsigned long)iter->key;
 		if (iterk == key)
 			continue;
 
@@ -309,7 +309,7 @@ static int jump_label_add_module(struct 
 			key->next = NULL;
 			continue;
 		}
-		jlm = kzalloc(sizeof(struct jump_label_mod), GFP_KERNEL);
+		jlm = kzalloc(sizeof(struct static_key_mod), GFP_KERNEL);
 		if (!jlm)
 			return -ENOMEM;
 		jlm->mod = mod;
@@ -329,14 +329,14 @@ static void jump_label_del_module(struct
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
@@ -438,7 +438,7 @@ int jump_label_text_reserved(void *start
 	return ret;
 }
 
-static void jump_label_update(struct jump_label_key *key, int enable)
+static void jump_label_update(struct static_key *key, int enable)
 {
 	struct jump_entry *stop = __stop___jump_table;
 	struct jump_entry *entry = jump_label_get_entries(key);
Index: linux/kernel/sched/core.c
===================================================================
--- linux.orig/kernel/sched/core.c
+++ linux/kernel/sched/core.c
@@ -162,13 +162,13 @@ static int sched_feat_show(struct seq_fi
 
 #ifdef HAVE_JUMP_LABEL
 
-#define jump_label_key__true  JUMP_LABEL_INIT_TRUE
-#define jump_label_key__false JUMP_LABEL_INIT_FALSE
+#define jump_label_key__true  STATIC_KEY_INIT_TRUE
+#define jump_label_key__false STATIC_KEY_INIT_FALSE
 
 #define SCHED_FEAT(name, enabled)	\
 	jump_label_key__##enabled ,
 
-struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR] = {
+struct static_key sched_feat_keys[__SCHED_FEAT_NR] = {
 #include "features.h"
 };
 
@@ -176,14 +176,14 @@ struct jump_label_key sched_feat_keys[__
 
 static void sched_feat_disable(int i)
 {
-	if (jump_label_true(&sched_feat_keys[i]))
-		jump_label_dec(&sched_feat_keys[i]);
+	if (static_key_true(&sched_feat_keys[i]))
+		static_key_slow_dec(&sched_feat_keys[i]);
 }
 
 static void sched_feat_enable(int i)
 {
-	if (!jump_label_true(&sched_feat_keys[i]))
-		jump_label_inc(&sched_feat_keys[i]);
+	if (!static_key_true(&sched_feat_keys[i]))
+		static_key_slow_inc(&sched_feat_keys[i]);
 }
 #else
 static void sched_feat_disable(int i) { };
Index: linux/kernel/sched/fair.c
===================================================================
--- linux.orig/kernel/sched/fair.c
+++ linux/kernel/sched/fair.c
@@ -1399,7 +1399,7 @@ entity_tick(struct cfs_rq *cfs_rq, struc
 #ifdef CONFIG_CFS_BANDWIDTH
 
 #ifdef HAVE_JUMP_LABEL
-static struct jump_label_key __cfs_bandwidth_used;
+static struct static_key __cfs_bandwidth_used;
 
 static inline bool cfs_bandwidth_used(void)
 {
@@ -1410,9 +1410,9 @@ void account_cfs_bandwidth_used(int enab
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
Index: linux/kernel/sched/sched.h
===================================================================
--- linux.orig/kernel/sched/sched.h
+++ linux/kernel/sched/sched.h
@@ -611,7 +611,7 @@ static inline void __set_task_cpu(struct
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
 	return very_likely(key); /* Not out of line branch. */
 }
 
-static __always_inline bool static_branch__false(struct jump_label_key *key)
+static __always_inline bool static_branch__false(struct static_key *key)
 {
 	return very_unlikely(key); /* Out of line branch. */
 }
 
 #define SCHED_FEAT(name, enabled)					\
-static __always_inline bool static_branch_##name(struct jump_label_key *key) \
+static __always_inline bool static_branch_##name(struct static_key *key) \
 {									\
 	return static_branch__##enabled(key);				\
 }
@@ -650,7 +650,7 @@ static __always_inline bool static_branc
 
 #undef SCHED_FEAT
 
-extern struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR];
+extern struct static_key sched_feat_keys[__SCHED_FEAT_NR];
 #define sched_feat(x) (static_branch_##x(&sched_feat_keys[__SCHED_FEAT_##x]))
 #else /* !(SCHED_DEBUG && HAVE_JUMP_LABEL) */
 #define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
Index: linux/kernel/tracepoint.c
===================================================================
--- linux.orig/kernel/tracepoint.c
+++ linux/kernel/tracepoint.c
@@ -25,7 +25,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 
 extern struct tracepoint * const __start___tracepoints_ptrs[];
 extern struct tracepoint * const __stop___tracepoints_ptrs[];
@@ -256,9 +256,9 @@ static void set_tracepoint(struct tracep
 {
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
 
-	if (elem->regfunc && !jump_label_true(&elem->key) && active)
+	if (elem->regfunc && !static_key_true(&elem->key) && active)
 		elem->regfunc();
-	else if (elem->unregfunc && jump_label_true(&elem->key) && !active)
+	else if (elem->unregfunc && static_key_true(&elem->key) && !active)
 		elem->unregfunc();
 
 	/*
@@ -269,10 +269,10 @@ static void set_tracepoint(struct tracep
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
-	if (active && !jump_label_true(&elem->key))
-		jump_label_inc(&elem->key);
-	else if (!active && jump_label_true(&elem->key))
-		jump_label_dec(&elem->key);
+	if (active && !static_key_true(&elem->key))
+		static_key_slow_inc(&elem->key);
+	else if (!active && static_key_true(&elem->key))
+		static_key_slow_dec(&elem->key);
 }
 
 /*
@@ -283,11 +283,11 @@ static void set_tracepoint(struct tracep
  */
 static void disable_tracepoint(struct tracepoint *elem)
 {
-	if (elem->unregfunc && jump_label_true(&elem->key))
+	if (elem->unregfunc && static_key_true(&elem->key))
 		elem->unregfunc();
 
-	if (jump_label_true(&elem->key))
-		jump_label_dec(&elem->key);
+	if (static_key_true(&elem->key))
+		static_key_slow_dec(&elem->key);
 	rcu_assign_pointer(elem->funcs, NULL);
 }
 
Index: linux/net/core/dev.c
===================================================================
--- linux.orig/net/core/dev.c
+++ linux/net/core/dev.c
@@ -134,7 +134,7 @@
 #include <linux/inetdevice.h>
 #include <linux/cpu_rmap.h>
 #include <linux/net_tstamp.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 #include <net/flow_keys.h>
 
 #include "net-sysfs.h"
@@ -1441,11 +1441,11 @@ int call_netdevice_notifiers(unsigned lo
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
 
@@ -1474,7 +1474,7 @@ void net_disable_timestamp(void)
 		return;
 	}
 #endif
-	jump_label_dec(&netstamp_needed);
+	static_key_slow_dec(&netstamp_needed);
 }
 EXPORT_SYMBOL(net_disable_timestamp);
 
@@ -2660,7 +2660,7 @@ EXPORT_SYMBOL(__skb_get_rxhash);
 struct rps_sock_flow_table __rcu *rps_sock_flow_table __read_mostly;
 EXPORT_SYMBOL(rps_sock_flow_table);
 
-struct jump_label_key rps_needed __read_mostly;
+struct static_key rps_needed __read_mostly;
 
 static struct rps_dev_flow *
 set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
Index: linux/net/core/net-sysfs.c
===================================================================
--- linux.orig/net/core/net-sysfs.c
+++ linux/net/core/net-sysfs.c
@@ -608,10 +608,10 @@ static ssize_t store_rps_map(struct netd
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
Index: linux/net/core/sock.c
===================================================================
--- linux.orig/net/core/sock.c
+++ linux/net/core/sock.c
@@ -111,7 +111,7 @@
 #include <linux/init.h>
 #include <linux/highmem.h>
 #include <linux/user_namespace.h>
-#include <linux/jump_label.h>
+#include <linux/static_key.h>
 #include <linux/memcontrol.h>
 
 #include <asm/uaccess.h>
@@ -184,7 +184,7 @@ void mem_cgroup_sockets_destroy(struct c
 static struct lock_class_key af_family_keys[AF_MAX];
 static struct lock_class_key af_family_slock_keys[AF_MAX];
 
-struct jump_label_key memcg_socket_limit_enabled;
+struct static_key memcg_socket_limit_enabled;
 EXPORT_SYMBOL(memcg_socket_limit_enabled);
 
 /*
Index: linux/net/core/sysctl_net_core.c
===================================================================
--- linux.orig/net/core/sysctl_net_core.c
+++ linux/net/core/sysctl_net_core.c
@@ -69,9 +69,9 @@ static int rps_sock_flow_sysctl(ctl_tabl
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
Index: linux/net/ipv4/tcp_memcontrol.c
===================================================================
--- linux.orig/net/ipv4/tcp_memcontrol.c
+++ linux/net/ipv4/tcp_memcontrol.c
@@ -111,7 +111,7 @@ void tcp_destroy_cgroup(struct cgroup *c
 	val = res_counter_read_u64(&tcp->tcp_memory_allocated, RES_LIMIT);
 
 	if (val != RESOURCE_MAX)
-		jump_label_dec(&memcg_socket_limit_enabled);
+		static_key_slow_dec(&memcg_socket_limit_enabled);
 }
 EXPORT_SYMBOL(tcp_destroy_cgroup);
 
@@ -143,9 +143,9 @@ static int tcp_update_limit(struct mem_c
 					     net->ipv4.sysctl_tcp_mem[i]);
 
 	if (val == RESOURCE_MAX && old_lim != RESOURCE_MAX)
-		jump_label_dec(&memcg_socket_limit_enabled);
+		static_key_slow_dec(&memcg_socket_limit_enabled);
 	else if (old_lim == RESOURCE_MAX && val != RESOURCE_MAX)
-		jump_label_inc(&memcg_socket_limit_enabled);
+		static_key_slow_inc(&memcg_socket_limit_enabled);
 
 	return 0;
 }
Index: linux/net/netfilter/core.c
===================================================================
--- linux.orig/net/netfilter/core.c
+++ linux/net/netfilter/core.c
@@ -56,7 +56,7 @@ struct list_head nf_hooks[NFPROTO_NUMPRO
 EXPORT_SYMBOL(nf_hooks);
 
 #if defined(CONFIG_JUMP_LABEL)
-struct jump_label_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
+struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 EXPORT_SYMBOL(nf_hooks_needed);
 #endif
 
@@ -77,7 +77,7 @@ int nf_register_hook(struct nf_hook_ops 
 	list_add_rcu(&reg->list, elem->list.prev);
 	mutex_unlock(&nf_hook_mutex);
 #if defined(CONFIG_JUMP_LABEL)
-	jump_label_inc(&nf_hooks_needed[reg->pf][reg->hooknum]);
+	static_key_slow_inc(&nf_hooks_needed[reg->pf][reg->hooknum]);
 #endif
 	return 0;
 }
@@ -89,7 +89,7 @@ void nf_unregister_hook(struct nf_hook_o
 	list_del_rcu(&reg->list);
 	mutex_unlock(&nf_hook_mutex);
 #if defined(CONFIG_JUMP_LABEL)
-	jump_label_dec(&nf_hooks_needed[reg->pf][reg->hooknum]);
+	static_key_slow_dec(&nf_hooks_needed[reg->pf][reg->hooknum]);
 #endif
 	synchronize_net();
 }
