Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0KISP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:15:29 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46623 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab0KISP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:15:26 -0500
Date: Tue, 9 Nov 2010 10:15:25 -0800
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86: call verify_cpu during 32bit CPU startup
Message-ID: <20101109181525.GH5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109181157.GE5876@outflux.net>
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
index bcece91..fdaea52 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -314,6 +314,10 @@ ENTRY(startup_32_smp)
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
@@ -609,6 +613,8 @@ ignore_int:
 #endif
 	iret
 
+#include "verify_cpu.S"
+
 	__REFDATA
 .align 4
 ENTRY(initial_code)
diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
index ccb4136..5644b4b 100644
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
1.7.2.3


-- 
Kees Cook
Ubuntu Security Team
