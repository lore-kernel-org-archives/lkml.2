Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2JIPee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:34:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55698 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2JIPec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:34:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 2/3] ARM: assabet: fix bogus warning in get_assabet_scr (again)
Date: Tue,  9 Oct 2012 17:34:20 +0200
Message-Id: <1349796861-31164-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349796861-31164-1-git-send-email-arnd@arndb.de>
References: <1349796861-31164-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Q8A2fTn+v1QVqF503evPEDgk2PK5aLIl5DZMso2hcVb
 QQolQAkRxrqGyGJtOBmkIzM6TjS/T7AbVE/ZUsQo+X98qDYg2A
 o31OLRFLhQPV9rETMvwG3X2wV7aQR5nXl2gR4+5fdbgYYpe5Mg
 SfFpRqXyrIHitj/pFzcIPXLuCMn2aqYxGAn2+ijbcpD1M31s90
 i9NYoCct2BFXaYst2Za+kKbzKLLZUSZnEMIrJ8ULRCpt3FkwlF
 gJvZCowYvSj9X4w9k1pAIwWPnS4REUfpTzJFSKW/XE4aLVdpAg
 6BuJHMCdUPNcvPYUcNsLZPOWYeU8aY+9kTEsNxBgWQri5yabop
 JEuQ79g+8CkEI21jeir6z8I8aCoS3QjH3lbAMqKFCk4x4Ub5CR
 mVGlpgLPJztDeCLeFfMTwaeNvptKr05CzE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell fixed this bogus warning before in 2f3eca8b4f "Shut up gcc
warning in assabet.c", but apparently gcc has become smarter (or dumber)
since 2005, and the same warning came up again.

This uses the uninitialized_var() macro to convince gcc that the
variable is actually being initialized. 100 times in fact.

Without this patch, building assabet_defconfig results in:

arch/arm/mach-sa1100/assabet.c: In function 'fixup_assabet':
arch/arm/mach-sa1100/assabet.c:397:6: warning: 'scr' may be used uninitialized in this function [-Wuninitialized]
arch/arm/mach-sa1100/assabet.c:389:16: note: 'scr' was declared here

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mach-sa1100/assabet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
index e1ccda6..6a7ad3c 100644
--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -388,7 +388,7 @@ static void __init map_sa1100_gpio_regs( void )
  */
 static void __init get_assabet_scr(void)
 {
-	unsigned long scr, i;
+	unsigned long uninitialized_var(scr), i;
 
 	GPDR |= 0x3fc;			/* Configure GPIO 9:2 as outputs */
 	GPSR = 0x3fc;			/* Write 0xFF to GPIO 9:2 */
-- 
1.7.10

