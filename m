Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab2EaCFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 22:05:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5264 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab2EaCEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 22:04:43 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=2VaD0yokR-YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=nj7187V4TI-IlNcSTtkA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=0nHABXHUOFMokZV2lFUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120531020441.500105258@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 30 May 2012 21:28:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] x86: Allow nesting of the debug stack IDT setting
References: <20120531012829.160060586@goodmis.org>
Content-Disposition: inline; filename=0004-x86-Allow-nesting-of-the-debug-stack-IDT-setting.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When the NMI handler runs, it checks if it preempted a debug handler
and if that handler is using the debug stack. If it is, it changes the
IDT table not to update the stack, otherwise it will reset the debug
stack and corrupt the debug handler it preempted.

Now that ftrace uses breakpoints to change functions from nops to
callers, many more places may hit a breakpoint. Unfortunately this
includes some of the calls that lockdep performs. Which causes issues
with the debug stack. It too needs to change the debug stack before
tracing (if called from the debug handler).

Allow the debug_stack_set_zero() and debug_stack_reset() to be nested
so that the debug handlers can take advantage of them too.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/common.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 82f29e7..63fc083 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1101,14 +1101,20 @@ int is_debug_stack(unsigned long addr)
 		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
=20
+static DEFINE_PER_CPU(atomic_t, debug_idt_zero);
+
 void debug_stack_set_zero(void)
 {
+	atomic_inc(&__get_cpu_var(debug_idt_zero));
 	load_idt((const struct desc_ptr *)&nmi_idt_descr);
 }
=20
 void debug_stack_reset(void)
 {
-	load_idt((const struct desc_ptr *)&idt_descr);
+	if (WARN_ON(!atomic_read(&__get_cpu_var(debug_idt_zero))))
+		return;
+	if (atomic_dec_and_test(&__get_cpu_var(debug_idt_zero)))
+		load_idt((const struct desc_ptr *)&idt_descr);
 }
=20
 #else	/* CONFIG_X86_64 */
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPxtG5AAoJEIy3vGnGbaoAn5AQAOGi96zwxWoyWx4BxwDdd/bM
tdkvvwG68t39gJCcBSdXZOj64R836k1pxupvb1AyVBmCDPM0DW7oltqraZimEixh
aYrWXiccNpoq3t5pe6YBCh1QD0FX7Hwv6ebuQCCzlqLLcnHBMIcNpWuPmyu6dqU0
cEf/jJG+rXFPnFvy1pd4BMWrAVyA20ywNvw1Bpbin/tDuo+AKKqUbqdvXPCSZq4Q
2LqoY0KzOMctgED4V1+Zp/pQRs1ugND7BwAtQtxWqo3li9SmnYNn5Gc885q4ap2I
sL+BUEF8sf5/+gpGzRJ3KonwT6NLTXl9FpnpcDPC4imC+CJG4JUVdxiveq2epqNh
5d+nk/Vs/4sAR9BzZ3VAia1uXB89ddzOnytzCxZjRX9SqLtrI2WVi+HnXjGP0C7C
dWscIuQcU6aGIIdhuIHXQBoJXTVVdtz29Li+sVfbcwRyonRz1RhEOCmjPU1xG+jl
4sc0Wmk7xUfITmS83LMLEytVkrN7yPB9GCimPMi3vANlp5HBXLMZWG5gtWgw3u7q
HQZ9zwyY75AOJNynfn85ph6//TGZRUbz+Fx3XaeS9/2RS8FfyYNnGLCWbaJ2wmbB
VRlQXUv6flab1OD3zd5q2oIm5m7RBKlUfrpd9g3944LoEh0xoYNhIlAVrw151vEX
HcIGG6eu4yih64ShmUof
=cJeE
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
