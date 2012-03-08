Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab2CHWWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:22:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15050 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758820Ab2CHWWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:22:03 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=EQrbfHX8H6cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=_busI_Le17HC7A9jns0A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=IlIHHVnFY4zYrncXXyQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120308222201.165735678@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 08 Mar 2012 17:17:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 1/7] x86/jump-label: Use best default nops for inital jump label calls
References: <20120308221730.807074710@goodmis.org>
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
index 3a16c14..64507f3 100644
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
-#define STATIC_KEY_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+#ifdef CONFIG_X86_64
+# define STATIC_KEY_INIT_NOP P6_NOP5_ATOMIC
+#else
+# define STATIC_KEY_INIT_NOP GENERIC_NOP5_ATOMIC
+#endif
=20
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("1:"
-		STATIC_KEY_INITIAL_NOP
+		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
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

iQIcBAABAgAGBQJPWTEJAAoJEIy3vGnGbaoA7qsP/Avfv57Pt4iHFxZxigIbKdlL
258/7hz/uU+b+VrTVWkF8u515VeD6ZAF5zW/62n2lzFjyeXT3ZAHCALXTWrlit9W
hIUNOYYB2iUagrCMYftMw4w4Ivh3wMLMdbg68i1o617zdU9dhr/ycC5g1pjOIu+Y
G3H25UPVLeXLspEjyqJIdjozIGJB0a4fYI4LTCiaP0ERb4KU5tXb2GqURcjsiZ5J
w6VCU5xTdG2Gz4SkliCKKkzXXv8/CEFDfZOarT4BKGYOfFrhPjuB/Xxn7UExuAul
NrKVQ6U9dEQxM6Hymf8RoAe7WDuVHxiGmjsZYIEaMsRoOUlnlA2h2L5Z9HND0lX2
X937Pdd0I1POya7usi/g9yP/86NwoW2igcYSXkxpiLgM5Pq+tMJzFTi6rGEc2SuL
ctO1vyt7EU4dPcWTurFh70DBFJLwhnuMKgugcX4kjDSTrxMNVmX4Z8tMOvtOvKVU
vWab14mnomD8pB8UnRwR5yzwMGV5B/TXCWxgLRfkbxrCdma5AXI+sbkw9m45cFDx
wYbXJIjXknguz3FiwFj/DqGuZjV2UUaGVgkdAnvoYHpmq49jerhlig5jPNYBjVWM
GvyBS3LoNbQLgOYk8SgjYlolUgvbZrbrR82GyKaTP3TwNKcg2ARuX4B9iFlIOKZy
tc/BYFrtNJpw2lQG+afD
=XFGu
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
