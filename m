Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab2EaCFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 22:05:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32384 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab2EaCEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 22:04:42 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=MB_uwNNlbDQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=_3j5v2QDHx0zCfXsyTsA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=BxN2F3qqrlqGi2bepLYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120531020440.839498007@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 30 May 2012 21:28:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/5] ftrace: Use breakpoint method to update ftrace caller
References: <20120531012829.160060586@goodmis.org>
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

This has been done to change the nops at all the functions, but
the change of the ftrace callback handler itself was still using a
direct modification. If tracing was enabled and the function callback
was changed then another CPU could fault if it was currently calling
the original callback. This modification must use the breakpoint method
too.

Note, the direct method is still used for boot up and module load.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |   65 ++++++++++++++++++++++++++++++++++++++++++=
----
 1 file changed, 60 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index ea9904f..0d50ee2 100644
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
@@ -152,9 +165,16 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned =
long addr)
 	old =3D ftrace_nop_replace();
 	new =3D ftrace_call_replace(ip, addr);
=20
-	return ftrace_modify_code(rec->ip, old, new);
+	/* Should only be called when module is loaded */
+	return ftrace_modify_code_direct(rec->ip, old, new);
 }
=20
+atomic_t modifying_ftrace_code __read_mostly;
+
+static int
+ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
+		   unsigned const char *new_code);
+
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip =3D (unsigned long)(&ftrace_call);
@@ -163,13 +183,16 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
=20
 	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
 	new =3D ftrace_call_replace(ip, (unsigned long)func);
+
+	atomic_inc(&modifying_ftrace_code);
+
 	ret =3D ftrace_modify_code(ip, old, new);
=20
+	atomic_dec(&modifying_ftrace_code);
+
 	return ret;
 }
=20
-atomic_t modifying_ftrace_code __read_mostly;
-
 /*
  * A breakpoint was added to the code address we are about to
  * modify, and this is the handle that will just skip over it.
@@ -489,6 +512,38 @@ void ftrace_replace_code(int enable)
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
 	atomic_inc(&modifying_ftrace_code);
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPxtG4AAoJEIy3vGnGbaoADVoP/23n8e0aUpW21dO8ypBLnG6c
s4sTe96AUS/VQ4PZQjUqMmPIqdsdIQHeAgRD7n/I6diE/E3EIoC/eateRK5wfZva
VynxmtJU9EbnD1DMuhjQmLVK4CdXNrnZpwWX8qeXjxvRVHVYjZxVlbHOatoGqG8M
+LIqKEFMCiGuU5ZXwJnDMx5WoA/ZRElMdHD/CAyiFrcZbGS3TSXRgcn/j8fHsfMu
yuBN8tuZA/xY9bYZ86eyPN9yjgKSEvYKiI5K8s+qHqZUVKazqpb3ImDClC8rEvxy
7PtrBBTmdX/bsOA2lBpHsGu28X2NKH3Kv3vBk0JGnG3u289s+/CERQZ5AfDGwb2l
f4vgYSGN7t7lal9lG8seYlULntIVX/XsJWs24+CEm6TKS5ODBX8V6l/dDO4WKSjv
w0oafyLpnJLQBKNCbcRry/Lsr3vBCmE7AVY/1ufJMeFiPNXu5OISm8HwC4vkkRfO
VAJTpG41Y+oSna0qpTH767zfLyFUDmteDLzb8+jUmFu/+i0j4U7I5B9kwHTxIq9g
y2Gf/ud10Hg4snIfAgVveY4pd7q8T9aBzvDPYr/HIilzN3UjKBbIbeHSGBO67JIK
RL03vCQqQ+djkFHNwAzGJyds+kuSDU24/HsJMH1Wb5Q9lOuAAxRD52MC4PDbSPSq
WaSuLxYqv2NjsP2reo/s
=CIz9
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
