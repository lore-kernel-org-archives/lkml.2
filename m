Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab3AIXKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 18:10:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36352 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178Ab3AIXKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 18:10:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, rusty@rustcorp.com.au, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, masami.hiramatsu.pt@hitachi.com,
        jbaron@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 2/5] jump label: constify lookup functions
Date: Wed,  9 Jan 2013 18:09:17 -0500
Message-Id: <1357772960-4436-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the parameters of all the lookup and the bookkeeping functions which
should be const to const.

For example, jump_label_text_reserved() doesn't modify the memory it works on,
it just checks whether there are any jump labels there.

Note I couldn't test the non-x86 architectures, but the changes are rather
trivial.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/arm/include/asm/jump_label.h     |  2 +-
 arch/arm/kernel/jump_label.c          |  6 +++---
 arch/mips/include/asm/jump_label.h    |  2 +-
 arch/mips/kernel/jump_label.c         |  2 +-
 arch/powerpc/include/asm/jump_label.h |  2 +-
 arch/powerpc/kernel/jump_label.c      |  2 +-
 arch/s390/include/asm/jump_label.h    |  2 +-
 arch/s390/kernel/jump_label.c         |  8 ++++----
 arch/sparc/include/asm/jump_label.h   |  2 +-
 arch/sparc/kernel/jump_label.c        |  2 +-
 arch/x86/include/asm/jump_label.h     |  2 +-
 arch/x86/kernel/jump_label.c          |  6 +++---
 include/linux/jump_label.h            | 24 ++++++++++++------------
 kernel/jump_label.c                   | 27 +++++++++++++++------------
 14 files changed, 46 insertions(+), 43 deletions(-)

diff --git a/arch/arm/include/asm/jump_label.h b/arch/arm/include/asm/jump_label.h
index bfc198c..f4ee633 100644
--- a/arch/arm/include/asm/jump_label.h
+++ b/arch/arm/include/asm/jump_label.h
@@ -14,7 +14,7 @@
 #define JUMP_LABEL_NOP	"nop"
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 	asm goto("1:\n\t"
 		 JUMP_LABEL_NOP "\n\t"
diff --git a/arch/arm/kernel/jump_label.c b/arch/arm/kernel/jump_label.c
index 4ce4f78..9686fce 100644
--- a/arch/arm/kernel/jump_label.c
+++ b/arch/arm/kernel/jump_label.c
@@ -6,7 +6,7 @@
 
 #ifdef HAVE_JUMP_LABEL
 
-static void __arch_jump_label_transform(struct jump_entry *entry,
+static void __arch_jump_label_transform(const struct jump_entry *entry,
 					enum jump_label_type type,
 					bool is_static)
 {
@@ -24,13 +24,13 @@ static void __arch_jump_label_transform(struct jump_entry *entry,
 		patch_text(addr, insn);
 }
 
-void arch_jump_label_transform(struct jump_entry *entry,
+void arch_jump_label_transform(const struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	__arch_jump_label_transform(entry, type, false);
 }
 
-void arch_jump_label_transform_static(struct jump_entry *entry,
+void arch_jump_label_transform_static(const struct jump_entry *entry,
 				      enum jump_label_type type)
 {
 	__arch_jump_label_transform(entry, type, true);
diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
index 4d6d77e..a95ddf5 100644
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -20,7 +20,7 @@
 #define WORD_INSN ".word"
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 	asm goto("1:\tnop\n\t"
 		"nop\n\t"
diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
index 6001610..bfba488 100644
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -20,7 +20,7 @@
 
 #define J_RANGE_MASK ((1ul << 28) - 1)
 
-void arch_jump_label_transform(struct jump_entry *e,
+void arch_jump_label_transform(const struct jump_entry *e,
 			       enum jump_label_type type)
 {
 	union mips_instruction insn;
diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/include/asm/jump_label.h
index ae098c4..c00b303 100644
--- a/arch/powerpc/include/asm/jump_label.h
+++ b/arch/powerpc/include/asm/jump_label.h
@@ -17,7 +17,7 @@
 #define JUMP_ENTRY_TYPE		stringify_in_c(FTR_ENTRY_LONG)
 #define JUMP_LABEL_NOP_SIZE	4
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 	asm goto("1:\n\t"
 		 "nop\n\t"
diff --git a/arch/powerpc/kernel/jump_label.c b/arch/powerpc/kernel/jump_label.c
index a1ed8a8..f9626ec 100644
--- a/arch/powerpc/kernel/jump_label.c
+++ b/arch/powerpc/kernel/jump_label.c
@@ -12,7 +12,7 @@
 #include <asm/code-patching.h>
 
 #ifdef HAVE_JUMP_LABEL
-void arch_jump_label_transform(struct jump_entry *entry,
+void arch_jump_label_transform(const struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	u32 *addr = (u32 *)(unsigned long)entry->code;
diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
index 6c32190..96adb78 100644
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -13,7 +13,7 @@
 #define ASM_ALIGN ".balign 4"
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 	asm goto("0:	brcl 0,0\n"
 		".pushsection __jump_table, \"aw\"\n"
diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index b987ab2..85fa643 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -22,7 +22,7 @@ struct insn_args {
 	enum jump_label_type type;
 };
 
-static void __jump_label_transform(struct jump_entry *entry,
+static void __jump_label_transform(const struct jump_entry *entry,
 				   enum jump_label_type type)
 {
 	struct insn insn;
@@ -44,13 +44,13 @@ static void __jump_label_transform(struct jump_entry *entry,
 
 static int __sm_arch_jump_label_transform(void *data)
 {
-	struct insn_args *args = data;
+	const struct insn_args *args = data;
 
 	__jump_label_transform(args->entry, args->type);
 	return 0;
 }
 
-void arch_jump_label_transform(struct jump_entry *entry,
+void arch_jump_label_transform(const struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	struct insn_args args;
@@ -61,7 +61,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	stop_machine(__sm_arch_jump_label_transform, &args, NULL);
 }
 
-void arch_jump_label_transform_static(struct jump_entry *entry,
+void arch_jump_label_transform_static(const struct jump_entry *entry,
 				      enum jump_label_type type)
 {
 	__jump_label_transform(entry, type);
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index 5080d16..44cb914 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -7,7 +7,7 @@
 
 #define JUMP_LABEL_NOP_SIZE 4
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 		asm goto("1:\n\t"
 			 "nop\n\t"
diff --git a/arch/sparc/kernel/jump_label.c b/arch/sparc/kernel/jump_label.c
index 48565c1..231c10e 100644
--- a/arch/sparc/kernel/jump_label.c
+++ b/arch/sparc/kernel/jump_label.c
@@ -10,7 +10,7 @@
 
 #ifdef HAVE_JUMP_LABEL
 
-void arch_jump_label_transform(struct jump_entry *entry,
+void arch_jump_label_transform(const struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	u32 val;
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 3a16c14..6b6e976 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -11,7 +11,7 @@
 
 #define STATIC_KEY_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(const struct static_key *key)
 {
 	asm goto("1:"
 		STATIC_KEY_INITIAL_NOP
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 2889b3d..a7d2c5a 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -24,7 +24,7 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
-static void __jump_label_transform(struct jump_entry *entry,
+static void __jump_label_transform(const struct jump_entry *entry,
 				   enum jump_label_type type,
 				   void *(*poker)(void *, const void *, size_t))
 {
@@ -40,7 +40,7 @@ static void __jump_label_transform(struct jump_entry *entry,
 	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
 }
 
-void arch_jump_label_transform(struct jump_entry *entry,
+void arch_jump_label_transform(const struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	get_online_cpus();
@@ -50,7 +50,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	put_online_cpus();
 }
 
-__init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
+__init_or_module void arch_jump_label_transform_static(const struct jump_entry *entry,
 				      enum jump_label_type type)
 {
 	__jump_label_transform(entry, type, text_poke_early);
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 0976fc4..7c33d29 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -89,19 +89,19 @@ inline struct jump_entry *jump_label_get_entries(struct static_key *key)
 						& ~JUMP_LABEL_TRUE_BRANCH);
 }
 
-static inline bool jump_label_get_branch_default(struct static_key *key)
+static inline bool jump_label_get_branch_default(const struct static_key *key)
 {
 	if ((unsigned long)key->entries & JUMP_LABEL_TRUE_BRANCH)
 		return true;
 	return false;
 }
 
-static __always_inline bool static_key_false(struct static_key *key)
+static __always_inline bool static_key_false(const struct static_key *key)
 {
 	return arch_static_branch(key);
 }
 
-static __always_inline bool static_key_true(struct static_key *key)
+static __always_inline bool static_key_true(const struct static_key *key)
 {
 	return !static_key_false(key);
 }
@@ -112,15 +112,15 @@ extern struct jump_entry __stop___jump_table[];
 extern void jump_label_init(void);
 extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
-extern void arch_jump_label_transform(struct jump_entry *entry,
+extern void arch_jump_label_transform(const struct jump_entry *entry,
 				      enum jump_label_type type);
-extern void arch_jump_label_transform_static(struct jump_entry *entry,
+extern void arch_jump_label_transform_static(const struct jump_entry *entry,
 					     enum jump_label_type type);
-extern int jump_label_text_reserved(void *start, void *end);
+extern int jump_label_text_reserved(const void *start, const void *end);
 extern void static_key_slow_inc(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
 extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
-extern void jump_label_apply_nops(struct module *mod);
+extern void jump_label_apply_nops(const struct module *mod);
 extern void
 jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
 
@@ -145,14 +145,14 @@ struct static_key_deferred {
 	struct static_key  key;
 };
 
-static __always_inline bool static_key_false(struct static_key *key)
+static __always_inline bool static_key_false(const struct static_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)) > 0)
 		return true;
 	return false;
 }
 
-static __always_inline bool static_key_true(struct static_key *key)
+static __always_inline bool static_key_true(const struct static_key *key)
 {
 	if (likely(atomic_read(&key->enabled)) > 0)
 		return true;
@@ -174,7 +174,7 @@ static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
 	static_key_slow_dec(&key->key);
 }
 
-static inline int jump_label_text_reserved(void *start, void *end)
+static inline int jump_label_text_reserved(const void *start, const void *end)
 {
 	return 0;
 }
@@ -182,7 +182,7 @@ static inline int jump_label_text_reserved(void *start, void *end)
 static inline void jump_label_lock(void) {}
 static inline void jump_label_unlock(void) {}
 
-static inline int jump_label_apply_nops(struct module *mod)
+static inline int jump_label_apply_nops(const struct module *mod)
 {
 	return 0;
 }
@@ -203,7 +203,7 @@ jump_label_rate_limit(struct static_key_deferred *key,
 #define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
 #define jump_label_enabled static_key_enabled
 
-static inline bool static_key_enabled(struct static_key *key)
+static inline bool static_key_enabled(const struct static_key *key)
 {
 	return (atomic_read(&key->enabled) > 0);
 }
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 60f48fa..ba2fa54 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -120,7 +120,8 @@ void jump_label_rate_limit(struct static_key_deferred *key,
 }
 EXPORT_SYMBOL_GPL(jump_label_rate_limit);
 
-static int addr_conflict(struct jump_entry *entry, void *start, void *end)
+static int addr_conflict(const struct jump_entry *entry,
+			const void *start, const void *end)
 {
 	if (entry->code <= (unsigned long)end &&
 		entry->code + JUMP_LABEL_NOP_SIZE > (unsigned long)start)
@@ -130,7 +131,8 @@ static int addr_conflict(struct jump_entry *entry, void *start, void *end)
 }
 
 static int __jump_label_text_reserved(struct jump_entry *iter_start,
-		struct jump_entry *iter_stop, void *start, void *end)
+		struct jump_entry *iter_stop,
+		const void *start, const void *end)
 {
 	struct jump_entry *iter;
 
@@ -150,7 +152,7 @@ static int __jump_label_text_reserved(struct jump_entry *iter_start,
  * running code can override this to make the non-live update case
  * cheaper.
  */
-void __weak __init_or_module arch_jump_label_transform_static(struct jump_entry *entry,
+void __weak __init_or_module arch_jump_label_transform_static(const struct jump_entry *entry,
 					    enum jump_label_type type)
 {
 	arch_jump_label_transform(entry, type);	
@@ -173,7 +175,7 @@ static void __jump_label_update(struct static_key *key,
 	}
 }
 
-static enum jump_label_type jump_label_type(struct static_key *key)
+static enum jump_label_type jump_label_type(const struct static_key *key)
 {
 	bool true_branch = jump_label_get_branch_default(key);
 	bool state = static_key_enabled(key);
@@ -219,10 +221,11 @@ void __init jump_label_init(void)
 struct static_key_mod {
 	struct static_key_mod *next;
 	struct jump_entry *entries;
-	struct module *mod;
+	const struct module *mod;
 };
 
-static int __jump_label_mod_text_reserved(void *start, void *end)
+static int __jump_label_mod_text_reserved(const void *start,
+						const void *end)
 {
 	struct module *mod;
 
@@ -242,7 +245,7 @@ static void __jump_label_mod_update(struct static_key *key, int enable)
 	struct static_key_mod *mod = key->next;
 
 	while (mod) {
-		struct module *m = mod->mod;
+		const struct module *m = mod->mod;
 
 		__jump_label_update(key, mod->entries,
 				    m->jump_entries + m->num_jump_entries,
@@ -259,7 +262,7 @@ static void __jump_label_mod_update(struct static_key *key, int enable)
  * loads patch these with arch_get_jump_label_nop(), which is specified by
  * the arch specific jump label code.
  */
-void jump_label_apply_nops(struct module *mod)
+void jump_label_apply_nops(const struct module *mod)
 {
 	struct jump_entry *iter_start = mod->jump_entries;
 	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
@@ -274,7 +277,7 @@ void jump_label_apply_nops(struct module *mod)
 	}
 }
 
-static int jump_label_add_module(struct module *mod)
+static int jump_label_add_module(const struct module *mod)
 {
 	struct jump_entry *iter_start = mod->jump_entries;
 	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
@@ -319,7 +322,7 @@ static int jump_label_add_module(struct module *mod)
 	return 0;
 }
 
-static void jump_label_del_module(struct module *mod)
+static void jump_label_del_module(const struct module *mod)
 {
 	struct jump_entry *iter_start = mod->jump_entries;
 	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
@@ -351,7 +354,7 @@ static void jump_label_del_module(struct module *mod)
 	}
 }
 
-static void jump_label_invalidate_module_init(struct module *mod)
+static void jump_label_invalidate_module_init(const struct module *mod)
 {
 	struct jump_entry *iter_start = mod->jump_entries;
 	struct jump_entry *iter_stop = iter_start + mod->num_jump_entries;
@@ -419,7 +422,7 @@ early_initcall(jump_label_init_module);
  *
  * returns 1 if there is an overlap, 0 otherwise
  */
-int jump_label_text_reserved(void *start, void *end)
+int jump_label_text_reserved(const void *start, const void *end)
 {
 	int ret = __jump_label_text_reserved(__start___jump_table,
 			__stop___jump_table, start, end);
-- 
1.8.1

