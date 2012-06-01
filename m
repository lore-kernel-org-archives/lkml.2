Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064Ab2FAPBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:01:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760026Ab2FAPA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:00:59 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=LjOMv784c-EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=vDm1LqwhJgpIRRgchEAA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=uh3O409hqRQxPDgrY7wA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120601150057.120690432@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Jun 2012 10:57:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/5 v2] ftrace: Synchronize variable setting with breakpoints
References: <20120601145702.428441016@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Synchronize-variable-setting-with-breakpoints.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When the function tracer starts modifying the code via breakpoints
it sets a variable (modifying_ftrace_code) to inform the breakpoint
handler to call the ftrace int3 code.

But there's no synchronization between setting this code and the
handler, thus it is possible for the handler to be called on another
CPU before it sees the variable. This will cause a kernel crash as
the int3 handler will not know what to do with it.

I originally added smp_mb()'s to force the visibility of the variable
but H. Peter Anvin suggested that I just make it atomic.

[ Added comments as suggested by Peter Zijlstra ]

Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    2 +-
 arch/x86/kernel/ftrace.c      |   38 +++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/traps.c       |    8 ++++++--
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 18d9005..b0767bc 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -34,7 +34,7 @@
=20
 #ifndef __ASSEMBLY__
 extern void mcount(void);
-extern int modifying_ftrace_code;
+extern atomic_t modifying_ftrace_code;
=20
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 32ff365..2407a6d 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -168,7 +168,38 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
=20
-int modifying_ftrace_code __read_mostly;
+/*
+ * The modifying_ftrace_code is used to tell the breakpoint
+ * handler to call ftrace_int3_handler(). If it fails to
+ * call this handler for a breakpoint added by ftrace, then
+ * the kernel may crash.
+ *
+ * As atomic_writes on x86 do not need a barrier, we do not
+ * need to add smp_mb()s for this to work. It is also considered
+ * that we can not read the modifying_ftrace_code before
+ * executing the breakpoint. That would be quite remarkable if
+ * it could do that. Here's the flow that is required:
+ *
+ *   CPU-0                          CPU-1
+ *
+ * atomic_inc(mfc);
+ * write int3s
+ *				<trap-int3> // implicit (r)mb
+ *				if (atomic_read(mfc))
+ *					call ftrace_int3_handler()
+ *
+ * Then when we are finished:
+ *
+ * atomic_dec(mfc);
+ *
+ * If we hit a breakpoint that was not set by ftrace, it does not
+ * matter if ftrace_int3_handler() is called or not. It will
+ * simply be ignored. But it is crucial that a ftrace nop/caller
+ * breakpoint is handled. No other user should ever place a
+ * breakpoint on an ftrace nop/caller location. It must only
+ * be done by this code.
+ */
+atomic_t modifying_ftrace_code __read_mostly;
=20
 /*
  * A breakpoint was added to the code address we are about to
@@ -491,11 +522,12 @@ void ftrace_replace_code(int enable)
=20
 void arch_ftrace_update_code(int command)
 {
-	modifying_ftrace_code++;
+	/* See comment above by declaration of modifying_ftrace_code */
+	atomic_inc(&modifying_ftrace_code);
=20
 	ftrace_modify_all_code(command);
=20
-	modifying_ftrace_code--;
+	atomic_dec(&modifying_ftrace_code);
 }
=20
 int __init ftrace_dyn_arch_init(void *data)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ff08457..05b31d9 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -303,8 +303,12 @@ gp_in_kernel:
 dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long er=
ror_code)
 {
 #ifdef CONFIG_DYNAMIC_FTRACE
-	/* ftrace must be first, everything else may cause a recursive crash */
-	if (unlikely(modifying_ftrace_code) && ftrace_int3_handler(regs))
+	/*
+	 * ftrace must be first, everything else may cause a recursive crash.
+	 * See note by declaration of modifying_ftrace_code in ftrace.c
+	 */
+	if (unlikely(atomic_read(&modifying_ftrace_code)) &&
+	    ftrace_int3_handler(regs))
 		return;
 #endif
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPyNkpAAoJEIy3vGnGbaoAcQcP/2ZLi9PC9wTQ6DBJuJ4YdF+/
OFdGtUDgpS4Pg9UoPxqQkRsB8vN8AJVEQNXGAKGIGbHR/obE1mSA7eO71CgbwvUu
hPpqpA1dV30jyWCD1PBb83Xz8hZ1BSUNsfc9fz5CbF51AkJtv3I3rxrBhf0admoW
VDOm2QnkoZFhkxsoYrA5S/fttN/03lkpWK9WMrAqNuv7DoXcOP1NIzGSXC/yO2JQ
VVdhA+dNEVRMyaY5nu5U1JCTK+nwxVFTgqkcKFg4RyvHNpst8yEqMx9Q2fx7Q18G
YI+DGyJ+Ucx/tISaTut3BI5Pb34Nx75m5iixcbAAhlQHk3PpL/WY+gt+bJ433MiY
KC50WyUM4dofZUeuIU8QjemBUFymqjbMDwzXf3mHtRhPY2xck9F4CMptSWaXLbgX
/0J5sZ1J6mNrQiBZiyqAZDG7sPXePcIhIfjalx9hOfpSAqQUOwy+eiDWYXKN0YRI
1u9MDZFCu2r1o9c9mUJxu0orupI/PBxC4OnVOdgPA4Ox1JHLyBwiqxtoBcGiaaU5
oGGUicKuIr28bh24a/J3aSG8iLbf+aKWkY6LipqPFqnxmEXF9xXBYpmO8xhm1xAe
RA9MVVPcK611zl03tazat1KJhswis/bAbqNAKvj7Ksk3WpkD8ASUA2t/dc8HaPb1
4pw5dB2w+/4T/JLdiFr3
=e2U9
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
