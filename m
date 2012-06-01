Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab2FAPBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:01:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104Ab2FAPBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:01:00 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=ZDeSsTiFyf8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=_3j5v2QDHx0zCfXsyTsA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Gxn5iDqHvm2WrrfdGrcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120601150057.491675602@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Jun 2012 10:57:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/5 v2] ftrace: Use breakpoint method to update ftrace caller
References: <20120601145702.428441016@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Use-breakpoint-method-to-update-ftrace-caller.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

On boot up and module load, it is fine to modify the code directly,
without the use of breakpoints. This is because boot up modification
is done before SMP is initialized, thus the modification is serial,
and module load is done before the module executes.

But after that we must use a SMP safe method to modify running code.
Otherwise, if we are running the function tracer and update its
function (by starting off the stack tracer, or perf tracing)
the change of the function called by the ftrace trampoline is done
directly. If this is being executed on another CPU, that CPU may
take a GPF and crash the kernel.

The breakpoint method is used to change the nops at all the functions, but
the change of the ftrace callback handler itself was still using a
direct modification. If tracing was enabled and the function callback
was changed then another CPU could fault if it was currently calling
the original callback. This modification must use the breakpoint method
too.

Note, the direct method is still used for boot up and module load.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |   88 +++++++++++++++++++++++++++++++++++++-----=
----
 1 file changed, 72 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 2407a6d..c3a7cb4 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -100,7 +100,7 @@ static const unsigned char *ftrace_nop_replace(void)
 }
=20
 static int
-ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
+ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
 		   unsigned const char *new_code)
 {
 	unsigned char replaced[MCOUNT_INSN_SIZE];
@@ -141,7 +141,20 @@ int ftrace_make_nop(struct module *mod,
 	old =3D ftrace_call_replace(ip, addr);
 	new =3D ftrace_nop_replace();
=20
-	return ftrace_modify_code(rec->ip, old, new);
+	/*
+	 * On boot up, and when modules are loaded, the MCOUNT_ADDR
+	 * is converted to a nop, and will never become MCOUNT_ADDR
+	 * again. This code is either running before SMP (on boot up)
+	 * or before the code will ever be executed (module load).
+	 * We do not want to use the breakpoint version in this case,
+	 * just modify the code directly.
+	 */
+	if (addr =3D=3D MCOUNT_ADDR)
+		return ftrace_modify_code_direct(rec->ip, old, new);
+
+	/* Normal cases use add_brk_on_nop */
+	WARN_ONCE(1, "invalid use of ftrace_make_nop");
+	return -EINVAL;
 }
=20
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
@@ -152,20 +165,8 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned =
long addr)
 	old =3D ftrace_nop_replace();
 	new =3D ftrace_call_replace(ip, addr);
=20
-	return ftrace_modify_code(rec->ip, old, new);
-}
-
-int ftrace_update_ftrace_func(ftrace_func_t func)
-{
-	unsigned long ip =3D (unsigned long)(&ftrace_call);
-	unsigned char old[MCOUNT_INSN_SIZE], *new;
-	int ret;
-
-	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
-	new =3D ftrace_call_replace(ip, (unsigned long)func);
-	ret =3D ftrace_modify_code(ip, old, new);
-
-	return ret;
+	/* Should only be called when module is loaded */
+	return ftrace_modify_code_direct(rec->ip, old, new);
 }
=20
 /*
@@ -201,6 +202,29 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
  */
 atomic_t modifying_ftrace_code __read_mostly;
=20
+static int
+ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
+		   unsigned const char *new_code);
+
+int ftrace_update_ftrace_func(ftrace_func_t func)
+{
+	unsigned long ip =3D (unsigned long)(&ftrace_call);
+	unsigned char old[MCOUNT_INSN_SIZE], *new;
+	int ret;
+
+	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
+	new =3D ftrace_call_replace(ip, (unsigned long)func);
+
+	/* See comment above by declaration of modifying_ftrace_code */
+	atomic_inc(&modifying_ftrace_code);
+
+	ret =3D ftrace_modify_code(ip, old, new);
+
+	atomic_dec(&modifying_ftrace_code);
+
+	return ret;
+}
+
 /*
  * A breakpoint was added to the code address we are about to
  * modify, and this is the handle that will just skip over it.
@@ -520,6 +544,38 @@ void ftrace_replace_code(int enable)
 	}
 }
=20
+static int
+ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
+		   unsigned const char *new_code)
+{
+	int ret;
+
+	ret =3D add_break(ip, old_code);
+	if (ret)
+		goto out;
+
+	run_sync();
+
+	ret =3D add_update_code(ip, new_code);
+	if (ret)
+		goto fail_update;
+
+	run_sync();
+
+	ret =3D ftrace_write(ip, new_code, 1);
+	if (ret) {
+		ret =3D -EPERM;
+		goto out;
+	}
+	run_sync();
+ out:
+	return ret;
+
+ fail_update:
+	probe_kernel_write((void *)ip, &old_code[0], 1);
+	goto out;
+}
+
 void arch_ftrace_update_code(int command)
 {
 	/* See comment above by declaration of modifying_ftrace_code */
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPyNkpAAoJEIy3vGnGbaoA5xkP/i3/NbGg4tW3L1g5aujlLOty
0fWiRdHJ38esMCGBv3/UyTUHVY7jF9dxAz04+fhGDaIpHOxQVd0bT9GbQbIppIpx
gOLU1BR2wvmd3zO3jnwxcx7NJoxZCoRL7fC0aaVQ+9kw5rGY+8q4pOPHz0VyXJq8
JW+hd+xsUH+wYRnvZ+0hTu1/jcAZW9lsvLaGVGYt/zPdhyUhiSpm6SxZw3Nj3ykA
QebNAZyYLwjTBMYVDpN4gVKtIGZnD4azqli2GHBvGcY0BOtZYs5h8HOWAROy37v2
8pZHYWEKt1rEkbgPLdrshJkkUA4MeUhJohbq2ALqFJuTzYca8THHAFJDgvvIhU9H
87vCsBBNoEBc0d6RcA4HAueX/vh1DD90kcWa5OFpUlxpiKdZ1v3nPy4dyexqCp3B
EFpfbw01ldxTvtKGpjEq+xP0yzWKyRzT7IKxJ3awiUoYHuxiIrktoQjC6mvEsHVZ
FTUGJ+9SdHwP3ueAwN1grjJ+ztRHpa9ajFsCEpwIMWuLutLnfMpamhdPBrLdDVxM
7zpBkCxZyl3tSFZGyDctkpnzMj9oQjdALbCoTgItrKldI+jowCOjczrLrA2SIMf5
tw9qiEX9CXvn64VZZy+bqMSYI5m5lY+wiRSjkKFWSFQQ8fRLXv4dHrjhpd3XwnNS
Q4T9TQ43qa690xAoTpkI
=9pbD
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
