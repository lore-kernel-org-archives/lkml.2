Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab2CHWYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:24:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab2CHWWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:22:04 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=fFp8cbBnl2YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=3FE5NN9oZHMokVY65lcA:9 a=ioj0HhELp7ngitVBJFYA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=_fgJd9Nek6bGOc8U_-4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120308222202.525768259@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 08 Mar 2012 17:17:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 5/7] x86/jump labels: Use etiher 5 byte or 2 byte jumps
References: <20120308221730.807074710@goodmis.org>
Content-Disposition: inline; filename=0005-x86-jump-labels-Use-etiher-5-byte-or-2-byte-jumps.patch
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
 arch/x86/include/asm/jump_label.h |    7 +++-
 arch/x86/kernel/jump_label.c      |   85 ++++++++++++++++++++++++++++-----=
---
 3 files changed, 73 insertions(+), 20 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..5ad80a2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -67,6 +67,7 @@ config X86
 	select HAVE_USER_RETURN_NOTIFIER
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_BUILD_TIME_JUMP_LABEL
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_=
label.h
index 64507f3..615adb4 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -10,6 +10,11 @@
=20
 #define JUMP_LABEL_NOP_SIZE 5
=20
+/*
+ * The STATIC_KEY_INIT_NOP must match the nops used in
+ * scripts/update_jump_label.c. Otherwise the boot time checks
+ * will fail and trigger a BUG() on boot up.
+ */
 #ifdef CONFIG_X86_64
 # define STATIC_KEY_INIT_NOP P6_NOP5_ATOMIC
 #else
@@ -19,7 +24,7 @@
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("1:"
-		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
+		"jmp %l[l_yes]\n"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index aaf88c9..d426da6 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -16,12 +16,20 @@
=20
 #ifdef HAVE_JUMP_LABEL
=20
+/* These are the nops added at compile time */
+static const unsigned char nop_short[] =3D { P6_NOP2 };
+static const unsigned char default_nop[] =3D { STATIC_KEY_INIT_NOP };
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
@@ -30,18 +38,33 @@ static void __jump_label_transform(struct jump_entry *e=
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
@@ -50,18 +73,44 @@ static void __jump_label_transform(struct jump_entry *e=
ntry,
 		 * are converting the default nop to the ideal nop.
 		 */
 		if (init) {
-			const unsigned char default_nop[] =3D { STATIC_KEY_INIT_NOP };
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
@@ -88,7 +137,6 @@ __init_or_module void arch_jump_label_transform_static(s=
truct jump_entry *entry,
 	 * If it is not, then we need to update the nop to the ideal nop.
 	 */
 	if (!once) {
-		const unsigned char default_nop[] =3D { STATIC_KEY_INIT_NOP };
 		const unsigned char *ideal_nop =3D ideal_nops[NOP_ATOMIC5];
 		once++;
 		if (memcmp(ideal_nop, default_nop, 5) !=3D 0)
@@ -97,5 +145,4 @@ __init_or_module void arch_jump_label_transform_static(s=
truct jump_entry *entry,
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

iQIbBAABAgAGBQJPWTEKAAoJEIy3vGnGbaoAnWwP+PX2gQ93TCa4Kz7N85yKKVH0
xjnv8pJvNOBckwhn1I+KQSZGJpUMc67CCs4DNbsEfQBvhkdz5sebjHnL8z7PmtuF
BTdQO++Cr68j5JX/wgN55xabxEzTyZj3ZHtLlKly7riVDNk3b6gi9e6Kly1dxsI+
87KO1nZjMZuCoifjFYcoZm5UuKegOGk474seZaeuDKhyF3h+wob24QIADa04dWy9
P/vlftiADCAREVWKi9taJGoyQe0Njk5ir6ZeOv9cNZSDyN0gBrt6UiCCDqe5glOO
l7Mf3g9QXMi8UnLTzLSzmsg6zbQFBQl50Rpnw/Mg6SSei/ayYtJl/Xd1TL6PjGrT
wPHAsQd4lHANbrnkPPF9tMJuI800L2mZHxdx7sENDziDDpPT8qcsSF/l8dS5e7Bd
rIxv4jZxkscEYhIt+faDQKUZ6Sk6QNif9gtcEIgMhi6n1qkffZovPcbQZtxjV/zR
glXZU7VkJN4uNCdTcPcfVJ4x4uSSscbNSMcyiiu58DM+B6duhbWlZ9VZ7oGJm991
T/8YaaMwKiENWDpGniJqlim+QG4RCBnEu/ITMaqi0vFIju3mMw8NjGNMBPfhsT1g
UGxwt+G7hkTE/2tZaGmm6G4GxJ0ZiDvj9VVIH2fdq9Xax4qBF5spwfOHQWled9Jh
UOIdIUqxsO39pj2enZM=
=UyoM
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
