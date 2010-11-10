Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab0KJShX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:37:23 -0500
Received: from smtp.outflux.net ([198.145.64.163]:44728 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab0KJShU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:37:20 -0500
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/4] x86: call verify_cpu during 32bit CPU startup
Date: Wed, 10 Nov 2010 10:35:53 -0800
Message-Id: <1289414154-7829-4-git-send-email-kees.cook@canonical.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289414154-7829-1-git-send-email-kees.cook@canonical.com>
References: <1289414154-7829-1-git-send-email-kees.cook@canonical.com>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The XD_DISABLE-clearing side-effect needs to happen for both 32bit
and 64bit, but the 32bit init routines were not calling verify_cpu()
yet. This adds that call to gain the side-effect.

The longmode/SSE tests being performed in verify_cpu() need to happen very
early for 64bit but not for 32bit. Instead of including it in two places
for 32bit, we can just include it once in arch/x86/kernel/head_32.S.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
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

