Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2FNX75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:59:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab2FNX7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:54 -0400
Message-Id: <20120614235625.064975651@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel <garkein@mailueberfall.de>,
        Mathias Krause <minipli@googlemail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 13/42] crypto: aesni-intel - fix unaligned cbc decrypt for x86-32
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 7c8d51848a88aafdb68f42b6b650c83485ea2f84 upstream.

The 32 bit variant of cbc(aes) decrypt is using instructions requiring
128 bit aligned memory locations but fails to ensure this constraint in
the code. Fix this by loading the data into intermediate registers with
load unaligned instructions.

This fixes reported general protection faults related to aesni.

References: https://bugzilla.kernel.org/show_bug.cgi?id=43223
Reported-by: Daniel <garkein@mailueberfall.de>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/crypto/aesni-intel_asm.S |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2460,10 +2460,12 @@ ENTRY(aesni_cbc_dec)
 	pxor IN3, STATE4
 	movaps IN4, IV
 #else
-	pxor (INP), STATE2
-	pxor 0x10(INP), STATE3
 	pxor IN1, STATE4
 	movaps IN2, IV
+	movups (INP), IN1
+	pxor IN1, STATE2
+	movups 0x10(INP), IN2
+	pxor IN2, STATE3
 #endif
 	movups STATE1, (OUTP)
 	movups STATE2, 0x10(OUTP)


