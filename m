Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab2KZSLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:11:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47279 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab2KZRDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 056/270] ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels
Date: Mon, 26 Nov 2012 14:55:46 -0200
Message-Id: <1353949160-26803-57-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 846a136881b8f73c1f74250bf6acfaa309cab1f2 upstream.

Michael Olbrich reported that his test program fails when built with
-O2 -mcpu=cortex-a8 -mfpu=neon, and a kernel which supports v6 and v7
CPUs:

volatile int x = 2;
volatile int64_t y = 2;

int main() {
	volatile int a = 0;
	volatile int64_t b = 0;
	while (1) {
		a = (a + x) % (1 << 30);
		b = (b + y) % (1 << 30);
		assert(a == b);
	}
}

and two instances are run.  When built for just v7 CPUs, this program
works fine.  It uses the "vadd.i64 d19, d18, d16" VFP instruction.

It appears that we do not save the high-16 double VFP registers across
context switches when the kernel is built for v6 CPUs.  Fix that.

Tested-By: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/include/asm/vfpmacros.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/vfpmacros.h b/arch/arm/include/asm/vfpmacros.h
index 3d5fc41..bf53047 100644
--- a/arch/arm/include/asm/vfpmacros.h
+++ b/arch/arm/include/asm/vfpmacros.h
@@ -28,7 +28,7 @@
 	ldr	\tmp, =elf_hwcap		    @ may not have MVFR regs
 	ldr	\tmp, [\tmp, #0]
 	tst	\tmp, #HWCAP_VFPv3D16
-	ldceq	p11, cr0, [\base],#32*4		    @ FLDMIAD \base!, {d16-d31}
+	ldceql	p11, cr0, [\base],#32*4		    @ FLDMIAD \base!, {d16-d31}
 	addne	\base, \base, #32*4		    @ step over unused register space
 #else
 	VFPFMRX	\tmp, MVFR0			    @ Media and VFP Feature Register 0
@@ -52,7 +52,7 @@
 	ldr	\tmp, =elf_hwcap		    @ may not have MVFR regs
 	ldr	\tmp, [\tmp, #0]
 	tst	\tmp, #HWCAP_VFPv3D16
-	stceq	p11, cr0, [\base],#32*4		    @ FSTMIAD \base!, {d16-d31}
+	stceql	p11, cr0, [\base],#32*4		    @ FSTMIAD \base!, {d16-d31}
 	addne	\base, \base, #32*4		    @ step over unused register space
 #else
 	VFPFMRX	\tmp, MVFR0			    @ Media and VFP Feature Register 0
-- 
1.7.9.5

