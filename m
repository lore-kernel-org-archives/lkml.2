Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2J1Xcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:32:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42229 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757044Ab2J1X2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:30 -0400
Message-Id: <20121028231545.597376247@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:04 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Michael Olbrich <m.olbrich@pengutronix.de>
Subject: [ 028/105] ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/include/asm/vfpmacros.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/vfpmacros.h b/arch/arm/include/asm/vfpmacros.h
index a7aadbd..6a6f1e4 100644
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


