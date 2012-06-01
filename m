Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087Ab2FAPBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:01:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760042Ab2FAPBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:01:00 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=G43a_SsTeYsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=nj7187V4TI-IlNcSTtkA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=O0_M2kAegbz0X_I0SxYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120601150058.256940176@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Jun 2012 10:57:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5 v2] x86: Allow nesting of the debug stack IDT setting
References: <20120601145702.428441016@goodmis.org>
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

[ Used this_cpu_*() over __get_cpu_var() as suggested by H. Peter Anvin ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/common.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 82f29e7..6b9333b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1101,14 +1101,20 @@ int is_debug_stack(unsigned long addr)
 		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
=20
+static DEFINE_PER_CPU(u32, debug_stack_use_ctr);
+
 void debug_stack_set_zero(void)
 {
+	this_cpu_inc(debug_stack_use_ctr);
 	load_idt((const struct desc_ptr *)&nmi_idt_descr);
 }
=20
 void debug_stack_reset(void)
 {
-	load_idt((const struct desc_ptr *)&idt_descr);
+	if (WARN_ON(!this_cpu_read(debug_stack_use_ctr)))
+		return;
+	if (this_cpu_dec_return(debug_stack_use_ctr) =3D=3D 0)
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

iQIcBAABAgAGBQJPyNkqAAoJEIy3vGnGbaoAVxUQAInh1X4AyDLn7M5bCFDFv5kU
azuzmTalBBi6W/nzTCgvuc39tV8RkPt6n9n1KZ3GZQHsav/iQMuqow5L2vff+7iU
nCemdZF8t+DSp83qycyW2EnOLLSgmDi7OHZxnJkq9RJYrucgGnE6qfK3TRMwv7qS
3aQsPGEUEovii8wrib/9VGU6q4xHh1vGIsNoT1HOx3ndXmdj/iQEctqvTULrMSgg
r2gBVQk/9QjUOYuuswiVem0PdR58VPO862BwxQPn45X3WmRmBVC8/JWJoXzHbPpE
vrQrH6BapTqO4a4GtzJnGDyWlw533MYpYRAKnez6G+//6qXfBwRxhXf0YJh1jZ0U
iZtJon8issmq5a2saxzD4aqDbG7CogNHtlygzv78Kx5xk3iVy7/diOx7IBAo5/CO
z1R89/lTMm1LUrK25vtInNz7ehqW/PHWPJ3L9h6HaXlVT2y1CkU16hFle/8HvcsL
trkimTTZ102SAuTsueiV/3hrNBdM0NxoRUHUWKFf5kHR15WI3viYy+Vu4WW/pSh/
pCcCPrdHhOZm8bpV45zqx+QsYA15lFS7yRbLNl34zvDNvE4XCf3qcfwxDlHwfFUZ
KiuK+Pds101cVkEzmxBXvWwVm+Yp4TVRg0DBCGs/CkL7q8/ZI7WIhoEPQr9It2xU
Tu097SFLTmmLcTQtkauR
=Ome7
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
