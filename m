Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0FSFxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 01:53:23 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43287 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab0FSFxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 01:53:21 -0400
Date: Fri, 18 Jun 2010 22:52:59 -0700
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Alexander Potashev <aspotashev@gmail.com>,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86: call verify_cpu during 32bit CPU startup
Message-ID: <20100619055259.GU24749@outflux.net>
References: <20100619055010.GR24749@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619055010.GR24749@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The XD_DISABLE-clearing side-effect needs to happen on 32bit CPU
start-up as well.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/kernel/head_32.S    |    6 ++++++
 arch/x86/kernel/verify_cpu.S |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 37c3d4b..0dec923 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -309,6 +309,10 @@ ENTRY(startup_32_smp)
 	subl $0x80000001, %eax
 	cmpl $(0x8000ffff-0x80000001), %eax
 	ja 6f
+
+	/* Clear bogus XD_DISABLE bits */
+	call verify_cpu
+
 	mov $0x80000001, %eax
 	cpuid
 	/* Execute Disable bit supported? */
@@ -604,6 +608,8 @@ ignore_int:
 #endif
 	iret
 
+#include "verify_cpu.S"
+
 	__REFDATA
 .align 4
 ENTRY(initial_code)
diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
index d6a0be6..29a6357 100644
--- a/arch/x86/kernel/verify_cpu.S
+++ b/arch/x86/kernel/verify_cpu.S
@@ -19,6 +19,7 @@
  *
  *	arch/x86_64/boot/compressed/head_64.S: Boot cpu verification
  *	arch/x86_64/kernel/trampoline_64.S: secondary processor verfication
+ *	arch/x86_64/kernel/head_32.S: processor startup
  *
  *	verify_cpu, returns the status of longmode and SSE in register %eax.
  *		0: Success    1: Failure
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
