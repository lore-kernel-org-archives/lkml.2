Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab1CYMwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:52:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33718 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab1CYMwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:52:18 -0400
Date: Fri, 25 Mar 2011 13:52:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20110325125210.GA3052@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
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

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Namhyung Kim (2):
      vsprintf: Introduce %pB format specifier
      x86, dumpstack: Use %pB format specifier for stack trace

Sergey Senozhatsky (1):
      lockdep: Remove unused 'factor' variable from lockdep_stats_show()

Steven Rostedt (2):
      WARN_ON_SMP(): Allow use in if() statements on UP
      futex: Fix WARN_ON() test for UP


 arch/x86/kernel/dumpstack.c |    2 +-
 include/asm-generic/bug.h   |   28 ++++++++++++++++++++++++++-
 include/linux/kallsyms.h    |    7 ++++++
 kernel/futex.c              |    4 +-
 kernel/kallsyms.c           |   44 ++++++++++++++++++++++++++++++++++++++++--
 kernel/lockdep_proc.c       |    9 +-------
 lib/vsprintf.c              |    7 +++++-
 7 files changed, 85 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 999e279..24d0479 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -27,7 +27,7 @@ static int die_counter;
 
 void printk_address(unsigned long address, int reliable)
 {
-	printk(" [<%p>] %s%pS\n", (void *) address,
+	printk(" [<%p>] %s%pB\n", (void *) address,
 			reliable ? "" : "? ", (void *) address);
 }
 
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index c2c9ba0..f2d2faf 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -165,10 +165,36 @@ extern void warn_slowpath_null(const char *file, const int line);
 #define WARN_ON_RATELIMIT(condition, state)			\
 		WARN_ON((condition) && __ratelimit(state))
 
+/*
+ * WARN_ON_SMP() is for cases that the warning is either
+ * meaningless for !SMP or may even cause failures.
+ * This is usually used for cases that we have
+ * WARN_ON(!spin_is_locked(&lock)) checks, as spin_is_locked()
+ * returns 0 for uniprocessor settings.
+ * It can also be used with values that are only defined
+ * on SMP:
+ *
+ * struct foo {
+ *  [...]
+ * #ifdef CONFIG_SMP
+ *	int bar;
+ * #endif
+ * };
+ *
+ * void func(struct foo *zoot)
+ * {
+ *	WARN_ON_SMP(!zoot->bar);
+ *
+ * For CONFIG_SMP, WARN_ON_SMP() should act the same as WARN_ON(),
+ * and should be a nop and return false for uniprocessor.
+ *
+ * if (WARN_ON_SMP(x)) returns true only when CONFIG_SMP is set
+ * and x is true.
+ */
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
 #else
-# define WARN_ON_SMP(x)			do { } while (0)
+# define WARN_ON_SMP(x)			({0;})
 #endif
 
 #endif
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index d8e9b3d..0df513b 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -36,6 +36,7 @@ const char *kallsyms_lookup(unsigned long addr,
 
 /* Look up a kernel symbol and return it in a text buffer. */
 extern int sprint_symbol(char *buffer, unsigned long address);
+extern int sprint_backtrace(char *buffer, unsigned long address);
 
 /* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
@@ -79,6 +80,12 @@ static inline int sprint_symbol(char *buffer, unsigned long addr)
 	return 0;
 }
 
+static inline int sprint_backtrace(char *buffer, unsigned long addr)
+{
+	*buffer = '\0';
+	return 0;
+}
+
 static inline int lookup_symbol_name(unsigned long addr, char *symname)
 {
 	return -ERANGE;
diff --git a/kernel/futex.c b/kernel/futex.c
index bda4157..823aae3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -782,8 +782,8 @@ static void __unqueue_futex(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
 
-	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
-			|| plist_node_empty(&q->list)))
+	if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))
+	    || WARN_ON(plist_node_empty(&q->list)))
 		return;
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f6d091..59e8799 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -342,13 +342,15 @@ int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
 }
 
 /* Look up a kernel symbol and return it in a text buffer. */
-int sprint_symbol(char *buffer, unsigned long address)
+static int __sprint_symbol(char *buffer, unsigned long address,
+			   int symbol_offset)
 {
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
 	int len;
 
+	address += symbol_offset;
 	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
 	if (!name)
 		return sprintf(buffer, "0x%lx", address);
@@ -357,17 +359,53 @@ int sprint_symbol(char *buffer, unsigned long address)
 		strcpy(buffer, name);
 	len = strlen(buffer);
 	buffer += len;
+	offset -= symbol_offset;
 
 	if (modname)
-		len += sprintf(buffer, "+%#lx/%#lx [%s]",
-						offset, size, modname);
+		len += sprintf(buffer, "+%#lx/%#lx [%s]", offset, size, modname);
 	else
 		len += sprintf(buffer, "+%#lx/%#lx", offset, size);
 
 	return len;
 }
+
+/**
+ * sprint_symbol - Look up a kernel symbol and return it in a text buffer
+ * @buffer: buffer to be stored
+ * @address: address to lookup
+ *
+ * This function looks up a kernel symbol with @address and stores its name,
+ * offset, size and module name to @buffer if possible. If no symbol was found,
+ * just saves its @address as is.
+ *
+ * This function returns the number of bytes stored in @buffer.
+ */
+int sprint_symbol(char *buffer, unsigned long address)
+{
+	return __sprint_symbol(buffer, address, 0);
+}
+
 EXPORT_SYMBOL_GPL(sprint_symbol);
 
+/**
+ * sprint_backtrace - Look up a backtrace symbol and return it in a text buffer
+ * @buffer: buffer to be stored
+ * @address: address to lookup
+ *
+ * This function is for stack backtrace and does the same thing as
+ * sprint_symbol() but with modified/decreased @address. If there is a
+ * tail-call to the function marked "noreturn", gcc optimized out code after
+ * the call so that the stack-saved return address could point outside of the
+ * caller. This function ensures that kallsyms will find the original caller
+ * by decreasing @address.
+ *
+ * This function returns the number of bytes stored in @buffer.
+ */
+int sprint_backtrace(char *buffer, unsigned long address)
+{
+	return __sprint_symbol(buffer, address, -1);
+}
+
 /* Look up a kernel symbol and print it to the kernel messages. */
 void __print_symbol(const char *fmt, unsigned long address)
 {
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 1969d2f..71edd2f 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -225,7 +225,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 		      nr_irq_read_safe = 0, nr_irq_read_unsafe = 0,
 		      nr_softirq_read_safe = 0, nr_softirq_read_unsafe = 0,
 		      nr_hardirq_read_safe = 0, nr_hardirq_read_unsafe = 0,
-		      sum_forward_deps = 0, factor = 0;
+		      sum_forward_deps = 0;
 
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
 
@@ -283,13 +283,6 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			nr_hardirq_unsafe * nr_hardirq_safe +
 			nr_list_entries);
 
-	/*
-	 * Estimated factor between direct and indirect
-	 * dependencies:
-	 */
-	if (nr_list_entries)
-		factor = sum_forward_deps / nr_list_entries;
-
 #ifdef CONFIG_PROVE_LOCKING
 	seq_printf(m, " dependency chains:             %11lu [max: %lu]\n",
 			nr_lock_chains, MAX_LOCKDEP_CHAINS);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d3023df..d9e01fc 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -574,7 +574,9 @@ char *symbol_string(char *buf, char *end, void *ptr,
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	if (ext != 'f' && ext != 's')
+	if (ext == 'B')
+		sprint_backtrace(sym, value);
+	else if (ext != 'f' && ext != 's')
 		sprint_symbol(sym, value);
 	else
 		kallsyms_lookup(value, NULL, NULL, NULL, sym);
@@ -949,6 +951,7 @@ int kptr_restrict = 1;
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
  * - 's' For symbolic direct pointers without offset
+ * - 'B' For backtraced symbolic direct pointers with offset
  * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
  * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
  * - 'M' For a 6-byte MAC address, it prints the address in the
@@ -1008,6 +1011,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		/* Fallthrough */
 	case 'S':
 	case 's':
+	case 'B':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 	case 'r':
@@ -1279,6 +1283,7 @@ qualifier:
  * %ps output the name of a text symbol without offset
  * %pF output the name of a function pointer with its offset
  * %pf output the name of a function pointer without its offset
+ * %pB output the name of a backtrace symbol with its offset
  * %pR output the address range in a struct resource with decoded flags
  * %pr output the address range in a struct resource with raw flags
  * %pM output a 6-byte MAC address with colons
