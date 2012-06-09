Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898Ab2FICEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 22:04:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761474Ab2FICEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 22:04:20 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=U78-E78mrI8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=07d9gI8wAAAA:8 a=oGMlB6cnAAAA:8 a=nAMRfH6E0Nx2vwST17cA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=lfZixy9hqe77tuiEhB4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120609020418.786753367@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 22:02:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3 v2] x86: Remove cmpxchg from i386 NMI nesting code
References: <20120609020257.248773533@goodmis.org>
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

Thanks to H. Peter Anvin for suggesting to use this_cpu_dec_and_return()
instead of local_dec_and_test(&__get_cpu_var()).

Link: http://lwn.net/Articles/484932/

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/nmi.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index a0b2f84..a15a888 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -365,8 +365,9 @@ static __kprobes void default_do_nmi(struct pt_regs *re=
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
@@ -383,13 +384,20 @@ static __kprobes void default_do_nmi(struct pt_regs *=
regs)
  * If an NMI hits a breakpoint that executes an iret, another
  * NMI can preempt it. We do not want to allow this new NMI
  * to run, but we want to execute it when the first one finishes.
- * We set the state to "latched", and the first NMI will perform
- * an cmpxchg on the state, and if it doesn't successfully
- * reset the state to "not running" it will restart the next
- * NMI.
+ * We set the state to "latched", and the exit of the first NMI will
+ * perform a dec_return, if the result is zero (NOT_RUNNING), then
+ * it will simply exit the NMI handler. If not, the dec_return
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
@@ -397,18 +405,17 @@ static DEFINE_PER_CPU(enum nmi_states, nmi_state);
=20
 #define nmi_nesting_preprocess(regs)					\
 	do {								\
-		if (__get_cpu_var(nmi_state) !=3D NMI_NOT_RUNNING) {	\
-			__get_cpu_var(nmi_state) =3D NMI_LATCHED;		\
+		if (this_cpu_read(nmi_state) !=3D NMI_NOT_RUNNING) {	\
+			this_cpu_write(nmi_state, NMI_LATCHED);		\
 			return;						\
 		}							\
-	nmi_restart:							\
-		__get_cpu_var(nmi_state) =3D NMI_EXECUTING;		\
-	} while (0)
+		this_cpu_write(nmi_state, NMI_EXECUTING);		\
+	} while (0);							\
+	nmi_restart:
=20
 #define nmi_nesting_postprocess()					\
 	do {								\
-		if (cmpxchg(&__get_cpu_var(nmi_state),			\
-		    NMI_EXECUTING, NMI_NOT_RUNNING) !=3D NMI_EXECUTING)	\
+		if (this_cpu_dec_return(nmi_state))			\
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

iQIcBAABAgAGBQJP0q8iAAoJEIy3vGnGbaoAZ/0P/ijMzftogoSfqw2OcQ67Szh4
zXLE9Gn9SLFd+wuL4k+Z1wp+ANl7BE57ARNh5W2ZiNC0oxsdiaA4e/aKsqdwNl/s
92WSRZJYt8XB/3ejLzX514gbXL/Ci6IwLPusfFNADq/0EXKOkQv4FLEoJmLwJBa4
AYWfMsk3O0lsDvpGR6RkoXbnyyVvTzOZHzNLR/tqN/KNNvt7EC/4gJq3OI5bqEyj
NbLo4DyQhvfVejg6G1mFKQ3/wJWXwjVlJyAzJ2P9YBbprTjW2CCgePo7lvdQEsnV
VLZBxEvw4eGi/GAkKu+UcKp/Uq/yL8/2/covrRIHeZ2UsDnnKtxu16tCte6mUjIX
wSND/SuipHnl3KZKL4GE80Jw6TFhFJ1dIw40Wkr+IBKKwiowcyLVL03Q3arafHQl
C3GcpAc9kBuNFsxs9EEAt8/NAlFPbSV/p2VZzZIrb7M7ox7nNdu04Nip2kmYn8RZ
7gcDCEAdIrO5Opk40MFEqbkbgxO+CSax/7sY/hCfILZ3/TKi3f31iU+mERD5O2Pl
6EHWJhFmYOj//WmXJ6LyhFKz9mgMvwZxcqOK0zI3Pe2kzR3dsYHPB69mtZGBBfCo
1T1O7lXC9zRFWCAYUEzfqs4m/irHdpBeV6R6ApsnNRO4b8S7QGXN9U8GKdKidcPp
BGUAoRCwnCq/HJoAk0oQ
=6zjU
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
