Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab1I2WUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:20:13 -0400
Received: from claw.goop.org ([74.207.240.146]:42993 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab1I2WUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:20:11 -0400
Message-ID: <4E84EF17.8040609@goop.org>
Date: Thu, 29 Sep 2011 15:20:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Jump Label initialization
References: <4E83D49C.9080809@goop.org> <1317281879.22384.1.camel@twins>
In-Reply-To: <1317281879.22384.1.camel@twins>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2011 12:37 AM, Peter Zijlstra wrote:
> On Wed, 2011-09-28 at 19:14 -0700, Jeremy Fitzhardinge wrote:
>> Hi all,
>>
>> I'm trying to use the jump label machinery as part of the pv ticketlock
>> work I'm doing on x86.
>>
>> The problem I'm having at the moment is that I do my spinlock setup in
>> smp_prepare_boot_cpu(), which happens before jump_label_init() gets
>> called, and so the latter goes and nops out all my enabled jump label key.
>>
>> I'm experimenting at the moment with a patch to allow
>> jump_label_enable() to be called fairly early, and have that be
>> respected by jump_label_init().  I'm doing this by replacing
>> arch_jump_label_poke_text_early() with
>> arch_jump_label_transform_early(), which shares most of its code with
>> its non-early variant, except that it expects to run in a pre-SMP
>> environment.
>>
>> Does this seem plausible? (I haven't tested it yet.)
>>
>> The x86, mips and sparc patches are fairly simple; I forgot to look at
>> powerpc, and I didn't fully investigate s390.
>>
>> While my current use-case is x86-specific, it seems generally useful to
>> make the jump_label machinery available as early as possible. I wonder
>> if you have any suggestions about how to handle this?
> I also remember talking to Jason about a way to initialize a jump label
> enabled, instead of the default disabled.
>
> So yeah, I think your stuff would be useful..
>

Here's what I have, which appears to work on x86.  The non-x86
architecture changes are completely untested.

But I still question whether the _early variant is necessary at all.  If
it were, then jump_label_enable() should use when called early as well.

    J

diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
index 6001610..ddc9a65 100644
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -20,8 +20,8 @@
 
 #define J_RANGE_MASK ((1ul << 28) - 1)
 
-void arch_jump_label_transform(struct jump_entry *e,
-			       enum jump_label_type type)
+static void __jump_label_transform(struct jump_entry *e,
+				   enum jump_label_type type)
 {
 	union mips_instruction insn;
 	union mips_instruction *insn_p =
@@ -40,15 +40,28 @@ void arch_jump_label_transform(struct jump_entry *e,
 		insn.word = 0; /* nop */
 	}
 
-	get_online_cpus();
-	mutex_lock(&text_mutex);
 	*insn_p = insn;
 
 	flush_icache_range((unsigned long)insn_p,
 			   (unsigned long)insn_p + sizeof(*insn_p));
+}
+
+void arch_jump_label_transform(struct jump_entry *e,
+			       enum jump_label_type type)
+{
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+
+	__jump_label_tranform(e, type);
 
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
 
+void __init arch_jump_label_transform_early(struct jump_entry *e,
+					    enum jump_label_type type)
+{
+	__jump_label_tranform(e, type);
+}
+
 #endif /* HAVE_JUMP_LABEL */
diff --git a/arch/powerpc/kernel/jump_label.c b/arch/powerpc/kernel/jump_label.c
index 368d158..20c82fb 100644
--- a/arch/powerpc/kernel/jump_label.c
+++ b/arch/powerpc/kernel/jump_label.c
@@ -21,3 +21,9 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	else
 		patch_instruction(addr, PPC_INST_NOP);
 }
+
+void __init arch_jump_label_transform_early(struct jump_entry *entry,
+					    enum jump_label_type type)
+{
+	arch_jump_label_transform(entry, type);
+}
diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index 44cc06b..6001228 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -18,23 +18,12 @@ struct insn {
 } __packed;
 
 struct insn_args {
-	unsigned long *target;
-	struct insn *insn;
-	ssize_t size;
+	struct jump_entry *entry;
+	enum jump_label_type type;
 };
 
-static int __arch_jump_label_transform(void *data)
-{
-	struct insn_args *args = data;
-	int rc;
-
-	rc = probe_kernel_write(args->target, args->insn, args->size);
-	WARN_ON_ONCE(rc < 0);
-	return 0;
-}
-
-void arch_jump_label_transform(struct jump_entry *entry,
-			       enum jump_label_type type)
+static void __jump_label_transform(struct jump_entry *entry,
+				   enum jump_label_type type)
 {
 	struct insn_args args;
 	struct insn insn;
@@ -49,11 +38,33 @@ void arch_jump_label_transform(struct jump_entry *entry,
 		insn.offset = 0;
 	}
 
-	args.target = (void *) entry->code;
-	args.insn = &insn;
-	args.size = JUMP_LABEL_NOP_SIZE;
+	rc = probe_kernel_write(entry->code, &insn, JUMP_LABEL_NOP_SIZE);
+	WARN_ON_ONCE(rc < 0);
+}
+
+static int __sm_arch_jump_label_transform(void *data)
+{
+	struct insn_args *args = data;
+
+	__jump_label_transform(args->entry, args->type);
+	return 0;
+}
 
-	stop_machine(__arch_jump_label_transform, &args, NULL);
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type type)
+{
+	struct insn_args args;
+
+	args.entry = entry;
+	args.type = type;
+
+	stop_machine(__sm_arch_jump_label_transform, &args, NULL);
+}
+
+void __init arch_jump_label_transform_early(struct jump_entry *entry,
+					    enum jump_label_type type)
+{
+	__jump_label_transform(entry, type);
 }
 
 #endif
diff --git a/arch/sparc/kernel/jump_label.c b/arch/sparc/kernel/jump_label.c
index ea2dafc..d3dad25 100644
--- a/arch/sparc/kernel/jump_label.c
+++ b/arch/sparc/kernel/jump_label.c
@@ -8,8 +8,8 @@
 
 #ifdef HAVE_JUMP_LABEL
 
-void arch_jump_label_transform(struct jump_entry *entry,
-			       enum jump_label_type type)
+static void __jump_label_transform(struct jump_entry *entry,
+				   enum jump_label_type type)
 {
 	u32 val;
 	u32 *insn = (u32 *) (unsigned long) entry->code;
@@ -28,20 +28,26 @@ void arch_jump_label_transform(struct jump_entry *entry,
 		val = 0x01000000;
 	}
 
-	get_online_cpus();
-	mutex_lock(&text_mutex);
 	*insn = val;
 	flushi(insn);
+}
+
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type type)
+{
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+
+	__jump_label_transform(entry, type);
+
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
 
-void arch_jump_label_text_poke_early(jump_label_t addr)
+void __init arch_jump_label_transform_early(struct jump_entry *entry,
+					    enum jump_label_type type)
 {
-	u32 *insn_p = (u32 *) (unsigned long) addr;
-
-	*insn_p = 0x01000000;
-	flushi(insn_p);
+	__jump_label_transform(entry, type);
 }
 
 #endif
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 3fee346..0887b59 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -24,8 +24,9 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
-void arch_jump_label_transform(struct jump_entry *entry,
-			       enum jump_label_type type)
+static void __jump_label_transform(struct jump_entry *entry,
+				   enum jump_label_type type,
+				   void *(*poker)(void *, const void *, size_t))
 {
 	union jump_code_union code;
 
@@ -35,17 +36,24 @@ void arch_jump_label_transform(struct jump_entry *entry,
 				(entry->code + JUMP_LABEL_NOP_SIZE);
 	} else
 		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
+
+	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+}
+
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type type)
+{
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+	__jump_label_transform(entry, type, text_poke_smp);
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
 
-void arch_jump_label_text_poke_early(jump_label_t addr)
+void __init arch_jump_label_transform_early(struct jump_entry *entry,
+					    enum jump_label_type type)
 {
-	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
-			JUMP_LABEL_NOP_SIZE);
+	__jump_label_transform(entry, type, text_poke_early);
 }
 
 #endif
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 66f23dc..c8fb1b3 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -28,9 +28,9 @@ struct module;
 #ifdef HAVE_JUMP_LABEL
 
 #ifdef CONFIG_MODULES
-#define JUMP_LABEL_INIT {{ 0 }, NULL, NULL}
+#define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL, NULL}
 #else
-#define JUMP_LABEL_INIT {{ 0 }, NULL}
+#define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL}
 #endif
 
 static __always_inline bool static_branch(struct jump_label_key *key)
@@ -45,7 +45,8 @@ extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
-extern void arch_jump_label_text_poke_early(jump_label_t addr);
+extern void arch_jump_label_transform_early(struct jump_entry *entry,
+				 enum jump_label_type type);
 extern int jump_label_text_reserved(void *start, void *end);
 extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index a8ce450..3010bcf 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -121,13 +121,6 @@ static void __jump_label_update(struct jump_label_key *key,
 	}
 }
 
-/*
- * Not all archs need this.
- */
-void __weak arch_jump_label_text_poke_early(jump_label_t addr)
-{
-}
-
 static __init int jump_label_init(void)
 {
 	struct jump_entry *iter_start = __start___jump_table;
@@ -139,12 +132,15 @@ static __init int jump_label_init(void)
 	jump_label_sort_entries(iter_start, iter_stop);
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		arch_jump_label_text_poke_early(iter->code);
-		if (iter->key == (jump_label_t)(unsigned long)key)
+		struct jump_label_key *iterk;
+
+		iterk = (struct jump_label_key *)(unsigned long)iter->key;
+		arch_jump_label_transform_early(iter, jump_label_enabled(iterk) ?
+						JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+		if (iterk == key)
 			continue;
 
-		key = (struct jump_label_key *)(unsigned long)iter->key;
-		atomic_set(&key->enabled, 0);
+		key = iterk;
 		key->entries = iter;
 #ifdef CONFIG_MODULES
 		key->next = NULL;
@@ -212,7 +208,7 @@ void jump_label_apply_nops(struct module *mod)
 		return;
 
 	for (iter = iter_start; iter < iter_stop; iter++)
-		arch_jump_label_text_poke_early(iter->code);
+		arch_jump_label_transform(iter, JUMP_LABEL_DISABLE);
 }
 
 static int jump_label_add_module(struct module *mod)

	J

