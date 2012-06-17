Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab2FQSXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:23:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50143 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757965Ab2FQSWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:16 -0400
Message-Id: <20120617175943.904220408@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mathias Krause <minipli@googlemail.com>,
        Daniel <garkein@mailueberfall.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 18/69] crypto: aesni-intel - fix unaligned cbc decrypt for x86-32
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/crypto/aesni-intel_asm.S |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index be6d9e3..3470624 100644
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


