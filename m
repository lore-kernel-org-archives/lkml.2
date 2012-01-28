Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2A1QQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 11:16:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38256 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2A1QQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 11:16:28 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=KIx2_XVGiCkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=_busI_Le17HC7A9jns0A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=RnNRQaLChHdyDBiRoMEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120128161626.576232970@goodmis.org>
User-Agent: quilt/0.50-1
Date: Sat, 28 Jan 2012 11:09:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 1/5 v2] x86/jump-label: Use best default nops for inital jump label calls
References: <20120128160925.275163704@goodmis.org>
Content-Disposition: inline; filename=0001-x86-jump-label-Use-best-default-nops-for-inital-jump.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

As specified by H. Peter Anvin, the best nops for x86 without knowing
the running computer is:

32bit:
  0x3e, 0x8d, 0x74, 0x26, 0x00 also known as GENERIC_NOP5_ATOMIC

64bit:
  0x0f, 0x1f, 0x44, 0x00, 0x00  also known as P6_NOP5_ATOMIC

Currently the default nop that is used by jump label is:

 0xe9 0x00 0x00 0x00 0x00

Which is really a 5byte jump to the next position.

It's better to use a real nop than a jmp.

Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/jump_label.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_=
label.h
index a32b18c..7082743 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -3,18 +3,23 @@
=20
 #ifdef __KERNEL__
=20
+#include <linux/stringify.h>
 #include <linux/types.h>
 #include <asm/nops.h>
 #include <asm/asm.h>
=20
 #define JUMP_LABEL_NOP_SIZE 5
=20
-#define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+#ifdef CONFIG_X86_64
+# define JUMP_LABEL_INIT_NOP P6_NOP5_ATOMIC
+#else
+# define JUMP_LABEL_INIT_NOP GENERIC_NOP5_ATOMIC
+#endif
=20
 static __always_inline bool arch_static_branch(struct jump_label_key *key)
 {
 	asm goto("1:"
-		JUMP_LABEL_INITIAL_NOP
+		".byte " __stringify(JUMP_LABEL_INIT_NOP) "\n\t"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPJB9aAAoJEIy3vGnGbaoA8ecQAM2dF4rkIVOIFggK2PspDz4D
SegrJZaOrhnpj1e3kbMsokSZPOwSK2ccNi6Tmmv4X7fSFtNrnD/I4xzfXVP/tZyF
zOEKDJf/31fJ6zKySzPI5iEKi25wnFp+J1F0VIoA9Lf6uPTNBfRnr3XUbDeVseBh
WbVPBL+a+igB1TgkThPkg6z0FLgMW1NBmpyKXiPs1/dqkApMnVycJuT6v8noa9fG
YI8QABi6WLnB03tnNFgQ8eIw98v5cURusF4O59r9V6JXxV+scA16P62VLx1GphmQ
mx6Sehgokl6K+PmkIOarjfT+R5fNwhQs9LOwthVtXPbIDdHrLa0kSdTlLECDa7/l
eLSsFPfaNQ1iacJUzeWP6CS3lsfgUDoMOiMuVSQZ0TlCC9VpwM+HhUZeFXE9UfKo
1BxYBaDSuwt/dtacjguGO5bSOLutzkgMHLYUfQA6Z7/VT6BPlDAOCd1viaWhiN6m
oCskbSr/ZlJaLNzVOw5gs3gHJBzgm2WcnJS3wVNUv7GhsFjKHjHVxXWfHAyboThn
HcglQttO/6Q6hpXuM4byL9+XarVSTtxYNmIxFxjRna0k9ZsZ+FHzrE2SASRE4/tn
A2ECgT75CGHJk+5o3nmIuRGZ2YmrDjlAc8yjgE3q1j1a+TGxIGAgP5A3fAXYc0/U
OfSJM2GKUrBceTRLuQI+
=yAwI
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
