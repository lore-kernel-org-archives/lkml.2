Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab2JSDJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:09:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:51828 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491Ab2JSCsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 01/76] ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels
Date: Thu, 18 Oct 2012 19:46:25 -0700
Message-Id: <20121019024350.304313762@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/vfpmacros.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


