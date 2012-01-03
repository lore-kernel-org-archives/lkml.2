Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab2ACWij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:38:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab2ACWic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:38:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:35 2012
Message-Id: <20120103223035.368276354@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [48/67] sparc32: Correct the return value of memcpy.
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit a52312b88c8103e965979a79a07f6b34af82ca4b ]

Properly return the original destination buffer pointer.

Signed-off-by: David S. Miller <davem@davemloft.net>
Tested-by: Kjetil Oftedal <oftedal@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/lib/memcpy.S |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/arch/sparc/lib/memcpy.S
+++ b/arch/sparc/lib/memcpy.S
@@ -13,14 +13,6 @@
 	.align	4;		\
 x:
 
-
-/* In kernel these functions don't return a value.
- * One should use macros in asm/string.h for that purpose.
- * We return 0, so that bugs are more apparent.
- */
-#define SETUP_RETL
-#define RETL_INSN	clr	%o0
-
 /* Both these macros have to start with exactly the same insn */
 #define MOVE_BIGCHUNK(src, dst, offset, t0, t1, t2, t3, t4, t5, t6, t7) \
 	ldd	[%src + (offset) + 0x00], %t0; \
@@ -154,7 +146,7 @@ FUNC(__memmove)
 #endif
 FUNC(memmove)
 	cmp		%o0, %o1
-	SETUP_RETL
+	mov		%o0, %g7
 	bleu		9f
 	 sub		%o0, %o1, %o4
 
@@ -178,7 +170,7 @@ FUNC(memmove)
 	 sub		%o0, 1, %o0
 
 	retl
-	 RETL_INSN
+	 mov		%g7, %o0
 
 /* NOTE: This code is executed just for the cases,
          where %src (=%o1) & 3 is != 0.
@@ -212,7 +204,7 @@ FUNC(memmove)
 FUNC(memcpy)	/* %o0=dst %o1=src %o2=len */
 
 	sub		%o0, %o1, %o4
-	SETUP_RETL
+	mov		%o0, %g7
 9:
 	andcc		%o4, 3, %o5
 0:
@@ -308,7 +300,7 @@ FUNC(memcpy)	/* %o0=dst %o1=src %o2=len
 	stb		%g2, [%o0]
 1:
 	retl
- 	 RETL_INSN
+	 mov		%g7, %o0
 
 82:	/* ldd_std */
 	MOVE_BIGALIGNCHUNK(o1, o0, 0x00, o2, o3, o4, o5, g2, g3, g4, g5)
@@ -373,7 +365,7 @@ FUNC(memcpy)	/* %o0=dst %o1=src %o2=len
 	stb		%g2, [%o0]
 1:
 	retl
- 	 RETL_INSN
+	 mov		%g7, %o0
 
 86:	/* non_aligned */
 	cmp		%o2, 6
@@ -498,7 +490,7 @@ FUNC(memcpy)	/* %o0=dst %o1=src %o2=len
 	stb		%g2, [%i0 + 4]
 1:
 	ret
-	 restore	%g0, %g0, %o0
+	 restore	%g7, %g0, %o0
 
 88:	/* short_end */
 
@@ -529,7 +521,7 @@ FUNC(memcpy)	/* %o0=dst %o1=src %o2=len
 	stb		%g2, [%o0]
 1:
 	retl
- 	 RETL_INSN
+	 mov		%g7, %o0
 
 90:	/* short_aligned_end */
 	bne		88b


