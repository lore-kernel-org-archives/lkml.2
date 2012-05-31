Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab2EaCF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 22:05:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9704 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab2EaCEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 22:04:44 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=FNgh0WpkwmMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=2ofPScMfxzHIHhZ8AHYA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=wm-QZEdVbLYoKp6ZOE0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120531020440.476352979@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 30 May 2012 21:28:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/5] ftrace: Synchronize variable setting with breakpoints
References: <20120531012829.160060586@goodmis.org>
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

Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    2 +-
 arch/x86/kernel/ftrace.c      |    6 +++---
 arch/x86/kernel/traps.c       |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

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
index 32ff365..ea9904f 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -168,7 +168,7 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
=20
-int modifying_ftrace_code __read_mostly;
+atomic_t modifying_ftrace_code __read_mostly;
=20
 /*
  * A breakpoint was added to the code address we are about to
@@ -491,11 +491,11 @@ void ftrace_replace_code(int enable)
=20
 void arch_ftrace_update_code(int command)
 {
-	modifying_ftrace_code++;
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
index ff08457..32443ae 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -304,7 +304,8 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_=
regs *regs, long error_co
 {
 #ifdef CONFIG_DYNAMIC_FTRACE
 	/* ftrace must be first, everything else may cause a recursive crash */
-	if (unlikely(modifying_ftrace_code) && ftrace_int3_handler(regs))
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

iQIcBAABAgAGBQJPxtG4AAoJEIy3vGnGbaoAuYwQANMopqtVwvA+UIsy5Q2Jokql
z44yEBQG2jTfQvt7ilnWIjXIIT0lG8FPWHhlGRQb4d/iM+MpiIMSxUrT5qmgosk1
6TbnWsdtoOYO9UuVrq3K45Jeho2orr1XjnJVyxE1r93uaI5G+NoSsapgfHw4r3P5
MvkBcYTFBGtmVI0emLdwc0rOO3YL/pacNQuCp9y8mIPIIgJzd1iiICQUWZv9wZke
c5fDovjr1/kYwroDfxs8WzsuxUMrRW1ilUuPx9gBiJzLyx//Igs6Q87Srft9bCul
by8uZT4yyZJVi54zTtTnNf2LI07OpTzfL0p63idsoAf2Z9qIgrHKpj+Hyry80ZrZ
1dBOYCC+yYFmLosoiW+Em71w8/MqWZY699r3KiEpuFOH4Y+S8L9iTBaoQcb82F5E
Tqi1TiqTGjDawmGB7oqXbtThGbS6beOQcCrTeevgI3gMxCZGKKK4BoRctoYbKVeb
I14bwYhUa3lfzhSeZhEBLuBecHtw2Yd28xgFK2qiSINjVu8mdfGXPvWCZdm3aQ8x
VU6zHJJZAaqZIubuih8VUEgGew3I6za7f5zcQr7Gq+wyasqck8lmuoh8CguDXh7m
w2LRU+YGu1roTzS812iaek5pNkoNEt4GN+IyAzufFN/aWRLEkXzjWZxg/+09ka7n
i3vXMOkQ6pGe61XsooD6
=g9A8
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
