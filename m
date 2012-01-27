Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2A0UUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:20:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38731 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2A0UUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:20:33 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=JUnBAsaWkkkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=_busI_Le17HC7A9jns0A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=B-OzTqk91sMgi8NFp0kA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120127202030.887128048@goodmis.org>
User-Agent: quilt/0.50-1
Date: Fri, 27 Jan 2012 15:14:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 1/5] x86/jump-label: Use best default nops for inital jump label calls
References: <20120127201442.080360013@goodmis.org>
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
  0x3e, 0x8d, 0x74, 0x26, 0x00

64bit:
  0x0f, 0x1f, 0x44, 0x00, 0x00  also known as P6_NOP5

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
index a32b18c..cefcfd3 100644
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
+# define JUMP_LABEL_INIT_NOP P6_NOP5
+#else
+# define JUMP_LABEL_INIT_NOP 0x3e, 0x8d, 0x74, 0x26, 0x00
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

iQIcBAABAgAGBQJPIwcOAAoJEIy3vGnGbaoACm4P/Ru+Ldphf+2KlJ4uBeyLG1/c
GzMRmxbh2jSQuTejVHFbN40jSQ1Nn2tkHbJvgP7HSrY5uEfwDZERPZBswH5UWVUx
mtSXronjFUWQxNZ8ImVoc/Gap3Lc9jsgsZ20WYuPhOJjZOjk8Onbt88HB1MXW1nD
Do8SCistDV1iVB9PHeJ0QONeHlP1HpfJ9yDHrE3WIw2Sk6Iy48tStGcQI2RJPh2m
+8Pr5tCjpHqyzMtiLSmuXReNuHRBNhPXb5sWnH01NcKVH5j3J7Q8QA+EawVhTSLj
MgVMYvEZR4+xuhXV+FT23qs+pL9swC94hOI6Lhz0zEHVJPENz/6fDX5WnW0WqBpf
qb/wJ21eAoc7yPI4tYmB6BfCdI4J3ugXTBnveG1T3cn465nsNxZ5eItQQIMMwZ1O
p4WofPuyT+Ckp10YBuakj6TSQ5NVERDVyr2wkw+Q71ynBBF9TAnAsdfFa44s32r8
oaC0thjA8Hc71Bci1BqCCP6KsnShiGHhMB/FR8NJ6M0xYnt6in+csrHE9HVsVhBw
0itUGvCYx2GLxOUaaKhctucEIBeQD82rY5te3wbwf2NbS/HJfdxBdden+FrZTGOg
0B/uaIobYxHLN+/4YNySYHSR8D9W631E/BdJmNOYf0ocvKCmBp1nPHgxzNlpks3G
cd+O7MJg3hWGLkwcdkC8
=M8jp
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
