Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002Ab1LPXHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:07:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760967Ab1LPXGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:06:17 -0500
X-Authority-Analysis: v=2.0 cv=FIuZNpUs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=bM37YEM8B4YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=nVI_mnzzUJ0xBcMVdE8A:9 a=2R4oPsScBZbIOtX69w8A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=QfYkzsUzQcflfgbi5xEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111216230615.988116473@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 16 Dec 2011 17:59:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 4/6] x86: Keep current stack in NMI breakpoints
References: <20111216225906.481643317@goodmis.org>
Content-Disposition: inline; filename=0004-x86-Keep-current-stack-in-NMI-breakpoints.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

We want to allow NMI handlers to have breakpoints to be able to
remove stop_machine from ftrace, kprobes and jump_labels. But if
an NMI interrupts a current breakpoint, and then it triggers a
breakpoint itself, it will switch to the breakpoint stack and
corrupt the data on it for the breakpoint processing that it
interrupted.

Instead, have the NMI check if it interrupted breakpoint processing
by checking if the stack that is currently used is a breakpoint
stack. If it is, then load a special IDT that changes the IST
for the debug exception to keep the same stack in kernel context.
When the NMI is done, it puts it back.

This way, if the NMI does trigger a breakpoint, it will keep
using the same stack and not stomp on the breakpoint data for
the breakpoint it interrupted.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/desc.h      |   12 ++++++++++++
 arch/x86/include/asm/processor.h |    6 ++++++
 arch/x86/kernel/cpu/common.c     |   22 ++++++++++++++++++++++
 arch/x86/kernel/head_64.S        |    4 ++++
 arch/x86/kernel/nmi.c            |   15 +++++++++++++++
 arch/x86/kernel/traps.c          |    6 ++++++
 6 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 41935fa..e95822d 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -35,6 +35,8 @@ static inline void fill_ldt(struct desc_struct *desc, con=
st struct user_desc *in
=20
 extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
+extern struct desc_ptr nmi_idt_descr;
+extern gate_desc nmi_idt_table[];
=20
 struct gdt_page {
 	struct desc_struct gdt[GDT_ENTRIES];
@@ -307,6 +309,16 @@ static inline void set_desc_limit(struct desc_struct *=
desc, unsigned long limit)
 	desc->limit =3D (limit >> 16) & 0xf;
 }
=20
+#ifdef CONFIG_X86_64
+static inline void set_nmi_gate(int gate, void *addr)
+{
+	gate_desc s;
+
+	pack_gate(&s, GATE_INTERRUPT, (unsigned long)addr, 0, 0, __KERNEL_CS);
+	write_idt_entry(nmi_idt_table, gate, &s);
+}
+#endif
+
 static inline void _set_gate(int gate, unsigned type, void *addr,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/proces=
sor.h
index b650435..d748d1f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -402,6 +402,9 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
 extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
+int is_debug_stack(unsigned long addr);
+void zero_debug_stack(void);
+void reset_debug_stack(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
@@ -416,6 +419,9 @@ struct stack_canary {
 };
 DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
+static inline int is_debug_stack(unsigned long addr) { return 0; }
+static inline void zero_debug_stack(void) { }
+static inline void reset_debug_stack(void) { }
 #endif	/* X86_64 */
=20
 extern unsigned int xstate_size;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index aa003b1..98faeff 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1026,6 +1026,8 @@ __setup("clearcpuid=3D", setup_disablecpuid);
=20
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr =3D { NR_VECTORS * 16 - 1, (unsigned long) idt_t=
able };
+struct desc_ptr nmi_idt_descr =3D { NR_VECTORS * 16 - 1,
+				    (unsigned long) nmi_idt_table };
=20
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);
@@ -1090,6 +1092,24 @@ unsigned long kernel_eflags;
  */
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
=20
+static DEFINE_PER_CPU(unsigned long, debug_stack_addr);
+
+int is_debug_stack(unsigned long addr)
+{
+	return addr <=3D __get_cpu_var(debug_stack_addr) &&
+		addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ);
+}
+
+void zero_debug_stack(void)
+{
+	load_idt((const struct desc_ptr *)&nmi_idt_descr);
+}
+
+void reset_debug_stack(void)
+{
+	load_idt((const struct desc_ptr *)&idt_descr);
+}
+
 #else	/* CONFIG_X86_64 */
=20
 DEFINE_PER_CPU(struct task_struct *, current_task) =3D &init_task;
@@ -1208,6 +1228,8 @@ void __cpuinit cpu_init(void)
 			estacks +=3D exception_stack_sizes[v];
 			oist->ist[v] =3D t->x86_tss.ist[v] =3D
 					(unsigned long)estacks;
+			if (v =3D=3D DEBUG_STACK - 1)
+				per_cpu(debug_stack_addr, cpu) =3D (unsigned long)estacks;
 		}
 	}
=20
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index e11e394..40f4eb3 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -417,6 +417,10 @@ ENTRY(phys_base)
 ENTRY(idt_table)
 	.skip IDT_ENTRIES * 16
=20
+	.align L1_CACHE_BYTES
+ENTRY(nmi_idt_table)
+	.skip IDT_ENTRIES * 16
+
 	__PAGE_ALIGNED_BSS
 	.align PAGE_SIZE
 ENTRY(empty_zero_page)
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index b9c8628..fb86773 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -407,6 +407,18 @@ static notrace __kprobes void default_do_nmi(struct pt=
_regs *regs)
 dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
+	int update_debug_stack =3D 0;
+
+	/*
+	 * If we interrupted a breakpoint, it is possible that
+	 * the nmi handler will have breakpoints too. We need to
+	 * change the IDT such that breakpoints that happen here
+	 * continue to use the NMI stack.
+	 */
+	if (unlikely(is_debug_stack(regs->sp))) {
+		zero_debug_stack();
+		update_debug_stack =3D 1;
+	}
 	nmi_enter();
=20
 	inc_irq_stat(__nmi_count);
@@ -415,6 +427,9 @@ do_nmi(struct pt_regs *regs, long error_code)
 		default_do_nmi(regs);
=20
 	nmi_exit();
+
+	if (unlikely(update_debug_stack))
+		reset_debug_stack();
 }
=20
 void stop_nmi(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a8e3eb8..a93c5ca 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -723,4 +723,10 @@ void __init trap_init(void)
 	cpu_init();
=20
 	x86_init.irqs.trap_init();
+
+#ifdef CONFIG_X86_64
+	memcpy(&nmi_idt_table, &idt_table, IDT_ENTRIES * 16);
+	set_nmi_gate(1, &debug);
+	set_nmi_gate(3, &int3);
+#endif
 }
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO687oAAoJEIy3vGnGbaoA37kP/3Cj65+9hjeBSN/zUSVKvTmW
uoYVC5xrA2D4ZxtnAPN/9KSuOfRiugKvD70tG2v2SeRHSteNhA4wRJ4n7a8UZxzr
gPOx9r3D63WZKf0AWTrwcfHnP23Rod8VPGD1gVbK4QTMufxn/NaAoioTNpYl9SXN
y1fU5gDHC9hmQdn22336OsAXFqlPeofmiJ3atcbdG8Ex93PE5LhwsXmpXoEwurah
daQVcaNOpfR0f55ILjKSK+9yj34rVwarizhzxTJzr52lmLS0I2HHjAEAK3Ktp2V2
uxMN788rUdRFKq7N3VUhNnIsV9Urbjr5d9HRLPvUT/GYV1HSQBR6KHgGvpO3Nveq
wuL9CXPFB1ELX1XEL73N+7pDGTIuCK7PONpJAkbLtOEvnz790Wkz25vHsfIH/rF9
6/6Zx8BLJ+Bpul/A7WMwUM7zlN6L5/tIB9GbRi0CxA5n6Wzt7sIjXqoQSD13Bzep
T+6sSwr7t6bklognHB9euDaa7WlZNk47TYUdxFaWyNLWj07gw/UtbwIl+iOY9Yd/
vyCsoF1UtIQJyywvbD0FnJIjg6VDBGVUsKvJp9jcmPkvwh0fy5/O3Jq6jlT1qbT7
PNgwIKn2tN3QtpkMNXLuQyrcUeku6QXxcx24q0+1Ltey5v3hgQPhwz/RFf1HW88V
ddLD/m8Mdi6+G8c63aRv
=KFlO
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
