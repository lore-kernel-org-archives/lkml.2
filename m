Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab2CHWXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:23:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32396 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866Ab2CHWWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:22:06 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=EB_sN3kKrrEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=11smRfc0_RqT7KlUWkcA:9 a=FVOi8EMSOumZeX7OIcUA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=WvK51otAl-gxMTe3qdYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120308222202.828095205@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 08 Mar 2012 17:17:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 6/7] x86/jump lables: Show where and what was wrong on errors
References: <20120308221730.807074710@goodmis.org>
Content-Disposition: inline; filename=0006-x86-jump-lables-Show-where-and-what-was-wrong-on-err.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When modifying text sections for jump labels, a paranoid check is
performed. If the check fails, the system "bugs". But why it failed
is not shown.

The BUG_ON()s in the jump label update code is replaced with bug_at(ip).
This is a function that will show what pointer failed, and what was
at the location of the failure that made jump label panic.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/jump_label.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index d426da6..9bae2c9 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -32,6 +32,18 @@ union jump_code_union {
 	} __packed;
 };
=20
+static void bug_at(unsigned char *ip, int line)
+{
+	/*
+	 * The location is not an op that we were expecting.
+	 * Something went wrong. Crash the box, as something could be
+	 * corrupting the kernel.
+	 */
+	printk("Unexpected op at %pS [%p] (%02x %02x %02x %02x %02x) %s:%d\n",
+	       ip, ip, ip[0], ip[1], ip[2], ip[3], ip[4], __FILE__, line);
+	BUG();
+}
+
 static void __jump_label_transform(struct jump_entry *entry,
 				   enum jump_label_type type,
 				   void *(*poker)(void *, const void *, size_t),
@@ -59,12 +71,7 @@ static void __jump_label_transform(struct jump_entry *en=
try,
 			code.jump =3D 0xe9;
 			code.offset =3D entry->target - (entry->code + size);
 		} else
-			/*
-			 * The location is not a nop that we were expecting,
-			 * something went wrong. Crash the box, as something could be
-			 * corrupting the kernel.
-			 */
-			BUG();
+			bug_at(ip, __LINE__);
 	} else {
 		/*
 		 * We are disabling this jump label. If it is not what
@@ -78,7 +85,8 @@ static void __jump_label_transform(struct jump_entry *ent=
ry,
 				return;
=20
 			/* We are initializing from the default nop */
-			BUG_ON(memcmp(ip, default_nop, 5) !=3D 0);
+			if (unlikely(memcmp(ip, default_nop, 5) !=3D 0))
+				bug_at(ip, __LINE__);
=20
 			/* Set to the ideal nop */
 			size =3D JUMP_LABEL_NOP_SIZE;
@@ -91,7 +99,9 @@ static void __jump_label_transform(struct jump_entry *ent=
ry,
 			code.jump =3D 0xe9;
 			code.offset =3D entry->target -
 				(entry->code + JUMP_LABEL_NOP_SIZE);
-			BUG_ON(memcmp(ip, &code, 5) !=3D 0);
+
+			if (unlikely(memcmp(ip, &code, 5) !=3D 0))
+				bug_at(ip, __LINE__);
=20
 			size =3D JUMP_LABEL_NOP_SIZE;
 			memcpy(&code, ideal_nops[NOP_ATOMIC5], size);
@@ -101,13 +111,14 @@ static void __jump_label_transform(struct jump_entry =
*entry,
 			/* Had better be a 2 byte jmp */
 			code.jump_short =3D 0xeb;
 			code.offset =3D entry->target - (entry->code + 2);
-			BUG_ON(memcmp(ip, &code, 2) !=3D 0);
+			if (unlikely(memcmp(ip, &code, 2) !=3D 0))
+				bug_at(ip, __LINE__);
=20
 			size =3D 2;
 			memcpy(&code, nop_short, size);
 		} else
 			/* The code was not what we expected!  */
-			BUG();
+			bug_at(ip, __LINE__);
 	}
=20
 	(*poker)(ip, &code, size);
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPWTEKAAoJEIy3vGnGbaoALFoQANpwwTiHmy16Gtyt1lvSbYLY
nVkP4LCJTCCkMBxf1GJxCtP3sLq35pk9we5B0G2QlBqMVLvWwdqev+blU6nuBLAw
xN8eTL0cUTdKbVmqUG3x6OihV1aJDY8IFMDntDOrGVXE3NZzJMBIqvJfgBk90pzj
4FJfSNuzOHrN5pjybOPbTWjopGuLRnH+egOYpyGxq8q2rEjgWiEgAz1McbJUI4NZ
fASNKi/Lk2Vyy04AcMf5Rx3WbBqKSOuD09x5srbW+NWZR7a5bdVMcUu5BhAY31hs
5XGsy9NkI0kT4rNQoQUZO98C/85z95VgYTUY2E5g6YNFZXMS8w7QoDKtzuI4pQWW
sG6QiUe7afL5UHBZzj1aW+/qbX/4QUabNEfz3a5lzjrp4wBwcVAgVM7El6GNtFlc
m/Ob2JGks4fz5Et1faEmsuxD1gogKViUJt9dYVtfkUkzH0BXUiHvu5tURisM9K8l
3ZOOILKIUtk3feS3d3odogZRI1qpQf1OeBTBFyEalbd8krDfSRnd0uM9Qf+QpkRp
t550st9LcY10FodzsbMHOL3GRrS+ttOOuoN1wnNi9/b2msB5ABBpPLJOXubBB7Ur
GVL3SQNObPpWQFT3jZVEZDWAnUZ+jJpRSZVzrRbh5KxT+4EBMrq9k6QrTxNYIORl
HmoA6uLElBwPAviAgqwi
=DQ2V
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
