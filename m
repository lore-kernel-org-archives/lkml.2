Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2DZRh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:37:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21123 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab2DZRhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:37:20 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=EAJcLXQM5IkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=pBgNJTDty4BEqmi_3asA:9 a=I1fl_e9JkFtPGZxwJIwA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=-aEXmc7a7OzAvmog:21 a=GLl71HU-3Bqfvk6I:21 a=YCwHSAhOWFgIBAavTAMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426173717.060120642@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 26 Apr 2012 13:34:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2 v2] ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine
References: <20120426173404.666092637@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-x86-Have-arch-x86_64-use-breakpoints-instead-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

This method changes x86 to add a breakpoint to the mcount locations
instead of calling stop machine.

Now that iret can be handled by NMIs, we perform the following to
update code:

1) Add a breakpoint to all locations that will be modified

2) Sync all cores

3) Update all locations to be either a nop or call (except breakpoint
   op)

4) Sync all cores

5) Remove the breakpoint with the new code.

6) Sync all cores

[
  Added updates that Masami suggested:
   Use unlikely(modifying_ftrace_code) in int3 trap to keep kprobes efficie=
nt.
   Don't use NOTIFY_* in ftrace handler in int3 as it is not a notifier.
]

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    3 +
 arch/x86/kernel/ftrace.c      |  342 +++++++++++++++++++++++++++++++++++++=
++++
 arch/x86/kernel/traps.c       |    8 +-
 include/linux/ftrace.h        |    6 +
 4 files changed, 358 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 268c783..18d9005 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -34,6 +34,7 @@
=20
 #ifndef __ASSEMBLY__
 extern void mcount(void);
+extern int modifying_ftrace_code;
=20
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
@@ -50,6 +51,8 @@ struct dyn_arch_ftrace {
 	/* No extra data needed for x86 */
 };
=20
+int ftrace_int3_handler(struct pt_regs *regs);
+
 #endif /*  CONFIG_DYNAMIC_FTRACE */
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index c9a281f..80af347 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/kprobes.h>
=20
 #include <trace/syscall.h>
=20
@@ -334,6 +335,347 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
=20
+int modifying_ftrace_code __read_mostly;
+
+/*
+ * A breakpoint was added to the code address we are about to
+ * modify, and this is the handle that will just skip over it.
+ * We are either changing a nop into a trace call, or a trace
+ * call to a nop. While the change is taking place, we treat
+ * it just like it was a nop.
+ */
+int ftrace_int3_handler(struct pt_regs *regs)
+{
+	if (WARN_ON_ONCE(!regs))
+		return 0;
+
+	if (!ftrace_location(regs->ip - 1))
+		return 0;
+
+	regs->ip +=3D MCOUNT_INSN_SIZE - 1;
+
+	return 1;
+}
+
+static int ftrace_write(unsigned long ip, const char *val, int size)
+{
+	/*
+	 * On x86_64, kernel text mappings are mapped read-only with
+	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
+	 * of the kernel text mapping to modify the kernel text.
+	 *
+	 * For 32bit kernels, these mappings are same and we can use
+	 * kernel identity mapping to modify code.
+	 */
+	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
+		ip =3D (unsigned long)__va(__pa(ip));
+
+	return probe_kernel_write((void *)ip, val, size);
+}
+
+static int add_break(unsigned long ip, const char *old)
+{
+	unsigned char replaced[MCOUNT_INSN_SIZE];
+	unsigned char brk =3D BREAKPOINT_INSTRUCTION;
+
+	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* Make sure it is what we expect it to be */
+	if (memcmp(replaced, old, MCOUNT_INSN_SIZE) !=3D 0)
+		return -EINVAL;
+
+	if (ftrace_write(ip, &brk, 1))
+		return -EPERM;
+
+	return 0;
+}
+
+static int add_brk_on_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned const char *old;
+	unsigned long ip =3D rec->ip;
+
+	old =3D ftrace_call_replace(ip, addr);
+
+	return add_break(rec->ip, old);
+}
+
+
+static int add_brk_on_nop(struct dyn_ftrace *rec)
+{
+	unsigned const char *old;
+
+	old =3D ftrace_nop_replace();
+
+	return add_break(rec->ip, old);
+}
+
+static int add_breakpoints(struct dyn_ftrace *rec, int enable)
+{
+	unsigned long ftrace_addr;
+	int ret;
+
+	ret =3D ftrace_test_record(rec, enable);
+
+	ftrace_addr =3D (unsigned long)FTRACE_ADDR;
+
+	switch (ret) {
+	case FTRACE_UPDATE_IGNORE:
+		return 0;
+
+	case FTRACE_UPDATE_MAKE_CALL:
+		/* converting nop to call */
+		return add_brk_on_nop(rec);
+
+	case FTRACE_UPDATE_MAKE_NOP:
+		/* converting a call to a nop */
+		return add_brk_on_call(rec, ftrace_addr);
+	}
+	return 0;
+}
+
+/*
+ * On error, we need to remove breakpoints. This needs to
+ * be done caefully. If the address does not currently have a
+ * breakpoint, we know we are done. Otherwise, we look at the
+ * remaining 4 bytes of the instruction. If it matches a nop
+ * we replace the breakpoint with the nop. Otherwise we replace
+ * it with the call instruction.
+ */
+static int remove_breakpoint(struct dyn_ftrace *rec)
+{
+	unsigned char ins[MCOUNT_INSN_SIZE];
+	unsigned char brk =3D BREAKPOINT_INSTRUCTION;
+	const unsigned char *nop;
+	unsigned long ftrace_addr;
+	unsigned long ip =3D rec->ip;
+
+	/* If we fail the read, just give up */
+	if (probe_kernel_read(ins, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* If this does not have a breakpoint, we are done */
+	if (ins[0] !=3D brk)
+		return -1;
+
+	nop =3D ftrace_nop_replace();
+
+	/*
+	 * If the last 4 bytes of the instruction do not match
+	 * a nop, then we assume that this is a call to ftrace_addr.
+	 */
+	if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) !=3D 0) {
+		/*
+		 * For extra paranoidism, we check if the breakpoint is on
+		 * a call that would actually jump to the ftrace_addr.
+		 * If not, don't touch the breakpoint, we make just create
+		 * a disaster.
+		 */
+		ftrace_addr =3D (unsigned long)FTRACE_ADDR;
+		nop =3D ftrace_call_replace(ip, ftrace_addr);
+
+		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) !=3D 0)
+			return -EINVAL;
+	}
+
+	return probe_kernel_write((void *)ip, &nop[0], 1);
+}
+
+static int add_update_code(unsigned long ip, unsigned const char *new)
+{
+	/* skip breakpoint */
+	ip++;
+	new++;
+	if (ftrace_write(ip, new, MCOUNT_INSN_SIZE - 1))
+		return -EPERM;
+	return 0;
+}
+
+static int add_update_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long ip =3D rec->ip;
+	unsigned const char *new;
+
+	new =3D ftrace_call_replace(ip, addr);
+	return add_update_code(ip, new);
+}
+
+static int add_update_nop(struct dyn_ftrace *rec)
+{
+	unsigned long ip =3D rec->ip;
+	unsigned const char *new;
+
+	new =3D ftrace_nop_replace();
+	return add_update_code(ip, new);
+}
+
+static int add_update(struct dyn_ftrace *rec, int enable)
+{
+	unsigned long ftrace_addr;
+	int ret;
+
+	ret =3D ftrace_test_record(rec, enable);
+
+	ftrace_addr =3D (unsigned long)FTRACE_ADDR;
+
+	switch (ret) {
+	case FTRACE_UPDATE_IGNORE:
+		return 0;
+
+	case FTRACE_UPDATE_MAKE_CALL:
+		/* converting nop to call */
+		return add_update_call(rec, ftrace_addr);
+
+	case FTRACE_UPDATE_MAKE_NOP:
+		/* converting a call to a nop */
+		return add_update_nop(rec);
+	}
+
+	return 0;
+}
+
+static int finish_update_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long ip =3D rec->ip;
+	unsigned const char *new;
+
+	new =3D ftrace_call_replace(ip, addr);
+
+	if (ftrace_write(ip, new, 1))
+		return -EPERM;
+
+	return 0;
+}
+
+static int finish_update_nop(struct dyn_ftrace *rec)
+{
+	unsigned long ip =3D rec->ip;
+	unsigned const char *new;
+
+	new =3D ftrace_nop_replace();
+
+	if (ftrace_write(ip, new, 1))
+		return -EPERM;
+	return 0;
+}
+
+static int finish_update(struct dyn_ftrace *rec, int enable)
+{
+	unsigned long ftrace_addr;
+	int ret;
+
+	ret =3D ftrace_update_record(rec, enable);
+
+	ftrace_addr =3D (unsigned long)FTRACE_ADDR;
+
+	switch (ret) {
+	case FTRACE_UPDATE_IGNORE:
+		return 0;
+
+	case FTRACE_UPDATE_MAKE_CALL:
+		/* converting nop to call */
+		return finish_update_call(rec, ftrace_addr);
+
+	case FTRACE_UPDATE_MAKE_NOP:
+		/* converting a call to a nop */
+		return finish_update_nop(rec);
+	}
+
+	return 0;
+}
+
+static void do_sync_core(void *data)
+{
+	sync_core();
+}
+
+static void run_sync(void)
+{
+	int enable_irqs =3D irqs_disabled();
+
+	/* We may be called with interrupts disbled (on bootup). */
+	if (enable_irqs)
+		local_irq_enable();
+	on_each_cpu(do_sync_core, NULL, 1);
+	if (enable_irqs)
+		local_irq_disable();
+}
+
+static void ftrace_replace_code(int enable)
+{
+	struct ftrace_rec_iter *iter;
+	struct dyn_ftrace *rec;
+	const char *report =3D "adding breakpoints";
+	int count =3D 0;
+	int ret;
+
+	for_ftrace_rec_iter(iter) {
+		rec =3D ftrace_rec_iter_record(iter);
+
+		ret =3D add_breakpoints(rec, enable);
+		if (ret)
+			goto remove_breakpoints;
+		count++;
+	}
+
+	run_sync();
+
+	report =3D "updating code";
+
+	for_ftrace_rec_iter(iter) {
+		rec =3D ftrace_rec_iter_record(iter);
+
+		ret =3D add_update(rec, enable);
+		if (ret)
+			goto remove_breakpoints;
+	}
+
+	run_sync();
+
+	report =3D "removing breakpoints";
+
+	for_ftrace_rec_iter(iter) {
+		rec =3D ftrace_rec_iter_record(iter);
+
+		ret =3D finish_update(rec, enable);
+		if (ret)
+			goto remove_breakpoints;
+	}
+
+	run_sync();
+
+	return;
+
+ remove_breakpoints:
+	ftrace_bug(ret, rec ? rec->ip : 0);
+	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
+	for_ftrace_rec_iter(iter) {
+		rec =3D ftrace_rec_iter_record(iter);
+		remove_breakpoint(rec);
+	}
+}
+
+void arch_ftrace_update_code(int command)
+{
+	modifying_ftrace_code++;
+
+	if (command & FTRACE_UPDATE_CALLS)
+		ftrace_replace_code(1);
+	else if (command & FTRACE_DISABLE_CALLS)
+		ftrace_replace_code(0);
+
+	if (command & FTRACE_UPDATE_TRACE_FUNC)
+		ftrace_update_ftrace_func(ftrace_trace_function);
+
+	if (command & FTRACE_START_FUNC_RET)
+		ftrace_enable_ftrace_graph_caller();
+	else if (command & FTRACE_STOP_FUNC_RET)
+		ftrace_disable_ftrace_graph_caller();
+
+	modifying_ftrace_code--;
+}
+
 int __init ftrace_dyn_arch_init(void *data)
 {
 	/* The return code is retured via data */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ff9281f1..92d5756 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -50,6 +50,7 @@
 #include <asm/processor.h>
 #include <asm/debugreg.h>
 #include <linux/atomic.h>
+#include <asm/ftrace.h>
 #include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
@@ -303,8 +304,13 @@ gp_in_kernel:
 }
=20
 /* May run on IST stack. */
-dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
+dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long er=
ror_code)
 {
+#ifdef CONFIG_DYNAMIC_FTRACE
+	/* ftrace must be first, everything else may cause a recursive crash */
+	if (unlikely(modifying_ftrace_code) && ftrace_int3_handler(regs))
+		return;
+#endif
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) =3D=3D NOTIFY_STOP)
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 72a6cab..0b55903 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -286,6 +286,12 @@ struct ftrace_rec_iter *ftrace_rec_iter_start(void);
 struct ftrace_rec_iter *ftrace_rec_iter_next(struct ftrace_rec_iter *iter);
 struct dyn_ftrace *ftrace_rec_iter_record(struct ftrace_rec_iter *iter);
=20
+#define for_ftrace_rec_iter(iter)		\
+	for (iter =3D ftrace_rec_iter_start();	\
+	     iter;				\
+	     iter =3D ftrace_rec_iter_next(iter))
+
+
 int ftrace_update_record(struct dyn_ftrace *rec, int enable);
 int ftrace_test_record(struct dyn_ftrace *rec, int enable);
 void ftrace_run_stop_machine(int command);
--=20
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmYfNAAoJEIy3vGnGbaoA+VcP/06ZVYJ89o8kHqtX4MyA2TU7
EuPad8q+QG6SOFwWoZ0e+7bfLDOmYEOUPIWnfgohnTYmcj7UkBWP5Sqzs+OhdayS
+qF18Wrk7FkfhhLroKWBasOeqyTBNbVtsKcSJCTRk+IhR6VukPrXz2jVahtvZ4Lt
kTvS254MzfgnoUlCOZ8tZfPZ/nvzTIUsyiGFUfbmYz3MWTq2wDlh8/C144px8ORb
8F79SeqIylYPqSQHAx7Bjo8UG9XkSmFb76HOm2LSyoH1X6wgYJgoUPBeaYgFuBuj
Wum6OMOi7eEgP9VyG8QXE5aTPHz+68T7H/Xj2YDLt+//Tn97koUfs+unsgpt4c/i
AQum0qFLF098/o8rImmftFCG0Q9Z+8Lap0xtM/4hD1nJI4tOIHeCZFqZPhFepdzX
2NIgQ97V0KZH/ZrOTDgANnsQh/Tm+sZ5a8Rr+XN47gJOITWSj+ru3uKo1kgU/Td0
W4tOQPa7qIQXPmpLR1OnF97UouUTT6VILIhY6nlaeUOYYsXrlV131SfBiwRUrXn9
Dvb3H9TBW5FF44Z8QZrUI3MW9bLh7s2pgVnl4rclbfR0hjFnKX57/SyLObMN8KqG
DfRjxodTUERtsNJdlNXJkFRUG9E0BjuboMEbGr1IJ/+Xfoqce5XrfQ6RNwpDyIkr
wfxmFVWejWdYPjk9AVpo
=t4Mz
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
