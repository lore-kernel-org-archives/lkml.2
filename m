Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2A0UVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:21:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46619 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2A0UUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:20:33 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=wcQlBHUnL4YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=3FE5NN9oZHMokVY65lcA:9 a=1sAMe7k-Kh3K-lDYjicA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=xZiNC2BR8LZ9ivHRNIUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120127202032.323768805@goodmis.org>
User-Agent: quilt/0.50-1
Date: Fri, 27 Jan 2012 15:14:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/5] jump labels/x86: Use etiher 5 byte or 2 byte jumps
References: <20120127201442.080360013@goodmis.org>
Content-Disposition: inline; filename=0005-jump-labels-x86-Use-etiher-5-byte-or-2-byte-jumps.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Have the jump labels add a "jmp" in the assembly instead
of a default nop. This will cause the assembler to put in
either a 2 byte or 5 byte jmp depending on where the target
lable is.

Then at compile time, the update_jump_label code will replace
the jmps with either 2 or 5 byte nops.

On boot up, the code can be examined to see if the jump label
uses either a 2 or 5 byte nop and replace it.

By allowing the jump labels to be 2 bytes, it speeds up the
nops, not only 2 byte nops are faster than 5 byte nops, but also
because it saves on cache foot print.

   text    data     bss     dec     hex filename
13403667 3666856 2998272 20068795 13239bb ../nobackup/mxtest/vmlinux-old
13398536 3666856 2998272 20063664 13225b0 ../nobackup/mxtest/vmlinux-new

Converting the current v3.2 trace points saved 5,131 bytes.
As more places use jump labels, this will have a bigger savings.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig                  |    1 +
 arch/x86/include/asm/jump_label.h |    2 +-
 arch/x86/kernel/jump_label.c      |   86 ++++++++++++++++++++++++++++-----=
---
 3 files changed, 69 insertions(+), 20 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index efb4294..b5004c1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -61,6 +61,7 @@ config X86
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
 	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_BUILD_TIME_JUMP_LABEL
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_=
label.h
index cefcfd3..bde5323 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -19,7 +19,7 @@
 static __always_inline bool arch_static_branch(struct jump_label_key *key)
 {
 	asm goto("1:"
-		".byte " __stringify(JUMP_LABEL_INIT_NOP) "\n\t"
+		"jmp %l[l_yes]\n"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 44f2528..8abd2a3 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -16,12 +16,21 @@
=20
 #ifdef HAVE_JUMP_LABEL
=20
+static unsigned char nop_short[] =3D { P6_NOP2 };
+
+/* These are the nops added at compile time */
+static unsigned char default_nop[] =3D { JUMP_LABEL_INIT_NOP };
+
 union jump_code_union {
 	char code[JUMP_LABEL_NOP_SIZE];
 	struct {
 		char jump;
 		int offset;
-	} __attribute__((packed));
+	} __packed;
+	struct {
+		char jump_short;
+		char offset_short;
+	} __packed;
 };
=20
 static void __jump_label_transform(struct jump_entry *entry,
@@ -30,18 +39,33 @@ static void __jump_label_transform(struct jump_entry *e=
ntry,
 				   int init)
 {
 	union jump_code_union code;
+	unsigned char nop;
+	unsigned char op;
+	unsigned size;
+	void *ip =3D (void *)entry->code;
 	const unsigned char *ideal_nop =3D ideal_nops[NOP_ATOMIC5];
=20
-	if (type =3D=3D JUMP_LABEL_ENABLE) {
-		/*
-		 * We are enabling this jump label. If it is not a nop
-		 * then something must have gone wrong.
-		 */
-		BUG_ON(memcmp((void *)entry->code, ideal_nop, 5) !=3D 0);
+	/* Use probe_kernel_read()? */
+	op =3D *(unsigned char *)ip;
+	nop =3D ideal_nops[NOP_ATOMIC5][0];
=20
-		code.jump =3D 0xe9;
-		code.offset =3D entry->target -
-				(entry->code + JUMP_LABEL_NOP_SIZE);
+	if (type =3D=3D JUMP_LABEL_ENABLE) {
+		if (memcmp(ip, nop_short, 2) =3D=3D 0) {
+			size =3D 2;
+			code.jump_short =3D 0xeb;
+			code.offset =3D entry->target - (entry->code + 2);
+			/* Check for overflow ? */
+		} else if (memcmp(ip, ideal_nop, 5) =3D=3D 0) {
+			size =3D JUMP_LABEL_NOP_SIZE;
+			code.jump =3D 0xe9;
+			code.offset =3D entry->target - (entry->code + size);
+		} else
+			/*
+			 * The location is not a nop that we were expecting,
+			 * something went wrong. Crash the box, as something could be
+			 * corrupting the kernel.
+			 */
+			BUG();
 	} else {
 		/*
 		 * We are disabling this jump label. If it is not what
@@ -50,18 +74,44 @@ static void __jump_label_transform(struct jump_entry *e=
ntry,
 		 * are converting the default nop to the ideal nop.
 		 */
 		if (init) {
-			unsigned char default_nop[] =3D { JUMP_LABEL_INIT_NOP };
-			BUG_ON(memcmp((void *)entry->code, default_nop, 5) !=3D 0);
-		} else {
+			/* Ignore short nops, we do not change them */
+			if (memcmp(ip, nop_short, 2) =3D=3D 0)
+				return;
+
+			/* We are initializing from the default nop */
+			BUG_ON(memcmp(ip, default_nop, 5) !=3D 0);
+
+			/* Set to the ideal nop */
+			size =3D JUMP_LABEL_NOP_SIZE;
+			memcpy(&code, ideal_nops[NOP_ATOMIC5], size);
+
+		} else if (op =3D=3D 0xe9) {
+			/* Replace a 5 byte jmp */
+
+			/* Make sure this is what we expected it to be */
 			code.jump =3D 0xe9;
 			code.offset =3D entry->target -
 				(entry->code + JUMP_LABEL_NOP_SIZE);
-			BUG_ON(memcmp((void *)entry->code, &code, 5) !=3D 0);
-		}
-		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
+			BUG_ON(memcmp(ip, &code, 5) !=3D 0);
+
+			size =3D JUMP_LABEL_NOP_SIZE;
+			memcpy(&code, ideal_nops[NOP_ATOMIC5], size);
+		} else if (op =3D=3D 0xeb) {
+			/* Replace a 2 byte jmp */
+
+			/* Had better be a 2 byte jmp */
+			code.jump_short =3D 0xeb;
+			code.offset =3D entry->target - (entry->code + 2);
+			BUG_ON(memcmp(ip, &code, 2) !=3D 0);
+
+			size =3D 2;
+			memcpy(&code, nop_short, size);
+		} else
+			/* The code was not what we expected!  */
+			BUG();
 	}
=20
-	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+	(*poker)(ip, &code, size);
 }
=20
 void arch_jump_label_transform(struct jump_entry *entry,
@@ -88,7 +138,6 @@ void arch_jump_label_transform_static(struct jump_entry =
*entry,
 	 * If it is not, then we need to update the nop to the ideal nop.
 	 */
 	if (!once) {
-		unsigned char default_nop[] =3D { JUMP_LABEL_INIT_NOP };
 		const unsigned char *ideal_nop =3D ideal_nops[NOP_ATOMIC5];
 		once++;
 		if (memcmp(ideal_nop, default_nop, 5) !=3D 0)
@@ -97,5 +146,4 @@ void arch_jump_label_transform_static(struct jump_entry =
*entry,
 	if (update)
 		__jump_label_transform(entry, type, text_poke_early, 1);
 }
-
 #endif
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPIwcQAAoJEIy3vGnGbaoAPjUQAK1eOjNR9bQ7OsvWVka2xKtc
2D7WTH5EEPdcqIKv7vq6x4dO+DwaouRD972wmfi1zwqZ/a8s0k6LmzFQrt44JW1F
znFqImOBCJLzZTwt0RlwlJ31nyeoKM1O6fHH+7kQvfSby4/gwidbAcwHpL3oNu+r
cac/5BH0N+8LjUQSlukqXFmob7ic0uebTZvvr3jOAhFJ+CX12EZnGax1OoeqfTls
97xTugxszCwVNdl3BO+uICyt84n03fgfk9OaTJempu+Ran0aeXza0E7AZRdbvvYb
N7AXBjPeJJSXXTh7sQ5Y4sk41hjuplJZn9P+FxWue2yy2BPk2HZ/d3nVh9NeN+yG
UpfIN4Ar0OAsVJVzwbhhDfQFBaF8kkhnLwbv0VhpwC7GkIqF71QlzxgG//WfilTi
sWMMkHXOtSqMFlm7VBQuWig/Z1iGH0s4h6Sp1NWVmSETqnFd4LHBhoXAWPkfCN5l
xrdTg0xRkbq32OzeY23JPGhCvHMRRlV5+aSniiV8GL7xMxhs4tCkfJv6hkmHKauK
6v1WZ0A6zFQHtMgJ5WIywRUqqth23sorzUleeIA6JkoPCow0mF5FN9l5flV8AqvN
WQ7XxpdVMK64sdflu0LINdQ8eSPNGW7WU32Ts0xoTpkTySX0wGJEnMC63OlqGnc7
8hV2VcN4Np49iFy0oI4l
=/HuT
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
