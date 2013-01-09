Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842Ab3AIVHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:07:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:43090 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933699Ab3AIUkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 078/123] sparc64: Fix unrolled AES 256-bit key loops.
Date: Wed,  9 Jan 2013 12:35:17 -0800
Message-Id: <20130109201508.618975741@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 9f28ffc03e93343ac04874fda9edb7affea45165 ]

The basic scheme of the block mode assembler is that we start by
enabling the FPU, loading the key into the floating point registers,
then iterate calling the encrypt/decrypt routine for each block.

For the 256-bit key cases, we run short on registers in the unrolled
loops.

So the {ENCRYPT,DECRYPT}_256_2() macros reload the key registers that
get clobbered.

The unrolled macros, {ENCRYPT,DECRYPT}_256(), are not mindful of this.

So if we have a mix of multi-block and single-block calls, the
single-block unrolled 256-bit encrypt/decrypt can run with some
of the key registers clobbered.

Handle this by always explicitly loading those registers before using
the non-unrolled 256-bit macro.

This was discovered thanks to all of the new test cases added by
Jussi Kivilinna.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/crypto/aes_asm.S |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/arch/sparc/crypto/aes_asm.S
+++ b/arch/sparc/crypto/aes_asm.S
@@ -1024,7 +1024,11 @@ ENTRY(aes_sparc64_ecb_encrypt_256)
 	 add		%o2, 0x20, %o2
 	brlz,pt		%o3, 11f
 	 nop
-10:	ldx		[%o1 + 0x00], %g3
+10:	ldd		[%o0 + 0xd0], %f56
+	ldd		[%o0 + 0xd8], %f58
+	ldd		[%o0 + 0xe0], %f60
+	ldd		[%o0 + 0xe8], %f62
+	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
@@ -1128,9 +1132,9 @@ ENTRY(aes_sparc64_ecb_decrypt_256)
 	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 - 0x10], %g1
 	subcc		%o3, 0x10, %o3
+	ldx		[%o0 - 0x08], %g2
 	be		10f
-	 ldx		[%o0 - 0x08], %g2
-	sub		%o0, 0xf0, %o0
+	 sub		%o0, 0xf0, %o0
 1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	ldx		[%o1 + 0x10], %o4
@@ -1154,7 +1158,11 @@ ENTRY(aes_sparc64_ecb_decrypt_256)
 	 add		%o2, 0x20, %o2
 	brlz,pt		%o3, 11f
 	 nop
-10:	ldx		[%o1 + 0x00], %g3
+10:	ldd		[%o0 + 0x18], %f56
+	ldd		[%o0 + 0x10], %f58
+	ldd		[%o0 + 0x08], %f60
+	ldd		[%o0 + 0x00], %f62
+	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
@@ -1511,11 +1519,11 @@ ENTRY(aes_sparc64_ctr_crypt_256)
 	 add		%o2, 0x20, %o2
 	brlz,pt		%o3, 11f
 	 nop
-	ldd		[%o0 + 0xd0], %f56
+10:	ldd		[%o0 + 0xd0], %f56
 	ldd		[%o0 + 0xd8], %f58
 	ldd		[%o0 + 0xe0], %f60
 	ldd		[%o0 + 0xe8], %f62
-10:	xor		%g1, %g3, %o5
+	xor		%g1, %g3, %o5
 	MOVXTOD_O5_F0
 	xor		%g2, %g7, %o5
 	MOVXTOD_O5_F2


