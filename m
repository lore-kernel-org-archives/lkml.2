Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab2FHN4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:56:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab2FHN4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:56:08 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=DFkgMk6I51EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=07d9gI8wAAAA:8 a=nAMRfH6E0Nx2vwST17cA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Hi0X-oMu9HDfWbqaTbAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120608135603.699156773@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 09:52:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
References: <20120608135200.371649691@goodmis.org>
Content-Disposition: inline; filename=0002-x86-Remove-cmpxchg-from-i386-NMI-nesting-code.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

I've been informed by someone on LWN called 'slashdot' that
some i386 machines do not support a true cmpxchg. The cmpxchg
used by the i386 NMI nesting code must be a true cmpxchg as
disabling interrupts will not work for NMIs (which is the work
around for i386s that do not have a true cmpxchg).

This 'slashdot' character also suggested a fix to the issue.
As the state of the nesting NMIs goes as follows:

  NOT_RUNNING -> EXECUTING
  EXECUTING   -> NOT_RUNNING
  EXECUTING   -> LATCHED
  LATCHED     -> EXECUTING

Having these states as enum values of:

  NOT_RUNNING =3D 0
  EXECUTING   =3D 1
  LATCHED     =3D 2

Instead of a cmpxchg to make EXECUTING -> NOT_RUNNING a
dec_and_test() would work as well. If the dec_and_test brings
the state to NOT_RUNNING, that is the same as a cmpxchg
succeeding to change EXECUTING to NOT_RUNNING. If a nested NMI
were to come in and change it to LATCHED, the dec_and_test() would
convert the state to EXECUTING (what we want it to be in such a
case anyway).

I asked 'slashdot' to post this as a patch, but it never came to
be. I decided to do the work instead.

Link: http://lwn.net/Articles/484932/

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/nmi.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index a0b2f84..43cce77 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -28,6 +28,7 @@
 #include <asm/mach_traps.h>
 #include <asm/nmi.h>
 #include <asm/x86_init.h>
+#include <asm/local.h>
=20
 struct nmi_desc {
 	spinlock_t lock;
@@ -365,8 +366,9 @@ static __kprobes void default_do_nmi(struct pt_regs *re=
gs)
 #ifdef CONFIG_X86_32
 /*
  * For i386, NMIs use the same stack as the kernel, and we can
- * add a workaround to the iret problem in C. Simply have 3 states
- * the NMI can be in.
+ * add a workaround to the iret problem in C (preventing nested
+ * NMIs if an NMI takes a trap). Simply have 3 states the NMI
+ * can be in:
  *
  *  1) not running
  *  2) executing
@@ -383,32 +385,39 @@ static __kprobes void default_do_nmi(struct pt_regs *=
regs)
  * If an NMI hits a breakpoint that executes an iret, another
  * NMI can preempt it. We do not want to allow this new NMI
  * to run, but we want to execute it when the first one finishes.
- * We set the state to "latched", and the first NMI will perform
- * an cmpxchg on the state, and if it doesn't successfully
- * reset the state to "not running" it will restart the next
- * NMI.
+ * We set the state to "latched", and the exit of the first NMI will
+ * perform a dec_and_test, if the result is zero (NOT_RUNNING), then
+ * it will simply exit the NMI handler. If not, the dec_and_test
+ * would have set the state to NMI_EXECUTING (what we want it to
+ * be when we are running). In this case, we simply jump back
+ * to rerun the NMI handler again, and restart the 'latched' NMI.
+ *
+ * No trap (breakpoint or page fault) should be hit before nmi_restart,
+ * thus there is no race between the first check of state for NOT_RUNNING
+ * and setting it to NMI_EXECUTING. The HW will prevent nested NMIs
+ * at this point.
  */
 enum nmi_states {
-	NMI_NOT_RUNNING,
+	NMI_NOT_RUNNING =3D 0,
 	NMI_EXECUTING,
 	NMI_LATCHED,
 };
-static DEFINE_PER_CPU(enum nmi_states, nmi_state);
+static DEFINE_PER_CPU(local_t, nmi_state);
=20
 #define nmi_nesting_preprocess(regs)					\
 	do {								\
-		if (__get_cpu_var(nmi_state) !=3D NMI_NOT_RUNNING) {	\
-			__get_cpu_var(nmi_state) =3D NMI_LATCHED;		\
+		local_t *__state =3D &__get_cpu_var(nmi_state);		\
+		if (local_read(__state) !=3D NMI_NOT_RUNNING) {		\
+			local_set(__state, NMI_LATCHED);		\
 			return;						\
 		}							\
-	nmi_restart:							\
-		__get_cpu_var(nmi_state) =3D NMI_EXECUTING;		\
-	} while (0)
+		local_set(__state, NMI_EXECUTING);			\
+	} while (0);							\
+	nmi_restart:
=20
 #define nmi_nesting_postprocess()					\
 	do {								\
-		if (cmpxchg(&__get_cpu_var(nmi_state),			\
-		    NMI_EXECUTING, NMI_NOT_RUNNING) !=3D NMI_EXECUTING)	\
+		if (!local_dec_and_test(&__get_cpu_var(nmi_state)))	\
 			goto nmi_restart;				\
 	} while (0)
 #else /* x86_64 */
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP0gRzAAoJEIy3vGnGbaoAJOcP/03eQE0V/XeVS7Bv+hAMJyrl
4eOu9YTDMIZxPfSrCJONf7KEP67aUUkUecQTDmNYCusHDE2og4hf3R5qZtDE5OK8
b6gY2b9CnVyz4vnREnNQdYDjrBhlANkIBJ3imWn9xs6QBwrDfJeJBL6IcC1YUlH4
C0MBKU9VOnfnTQeTtx3FnbjMftBvTHEEu8JkwTe2D3VDhhQgSihZYfh8nBYQdmVg
L74QXb/9NEFRfcoteGHvmomybQ8q6/CAEHT/BtjFc9d7Oxxy0WtB1ors6IGbKJ7x
Mi7Xs8dZ8dBozgpU+RGpYeWxarE+E135gTUQG3KswI7G1PDuctaJW876PZYxC+e/
wAuWiUfosvSJILAvdY1TYgkqOC8R2tOtJ2+mNWQz/kfffDGogl0KjRSvgDEdhupc
j9Muujd32GNJX/Q1WIe0hFE6TsG41JjOtT705qye5XRgxSX80FlzjQttmiNdXoOb
IU0Gj9bk1sk9UysQW9t2TzujsHEgpZVEE4aBCg4BCVGbNquxdkhKjQyCmjf64+TM
XZ6DWna5Gsc04Ms2vPKTzu75QcpCR6H85cfAkyCtJmHL3KlIzUlP/G82x8N207ix
muKBcfxapNgLMv7Dna7xRJJxDVdp2CnZS7Vgv6wIaSGRqYnYIfZwiXgNM9wkqAJv
eyV67Yu9Uo+oqweUTAIA
=6G3d
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
