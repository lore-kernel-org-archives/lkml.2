Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605Ab0HMNJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:09:52 -0400
Received: from king.tilera.com ([72.1.168.226]:13968 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761575Ab0HMNJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:09:50 -0400
Message-Id: <201008131309.o7DD9l8F005839@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 13 Aug 2010 08:32:21 -0400
Subject: [PATCH] arch/tile: Fix a couple of issues with the COMPAT code for TILE-Gx.
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 13 Aug 2010 13:09:47.0563 (UTC) FILETIME=[CE2647B0:01CB3AE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, the siginfo preamble wasn't quite right; we need to indicate
that we are padding up to 4 ints of preamble for 64-bit code, and
then for compat mode we need to pad differently, using only 3 ints.

Second, the C ABI requires a save area of two registers, not two
pointers, since in compat mode we have 64-bit registers all of which
we need to save, even though we only have 32-bit VAs.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/abi.h     |    4 +---
 arch/tile/include/asm/siginfo.h  |    4 ++++
 arch/tile/kernel/compat_signal.c |    4 +++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/tile/include/arch/abi.h b/arch/tile/include/arch/abi.h
index da8df5b..8affc76 100644
--- a/arch/tile/include/arch/abi.h
+++ b/arch/tile/include/arch/abi.h
@@ -59,9 +59,7 @@
  * The ABI requires callers to allocate a caller state save area of
  * this many bytes at the bottom of each stack frame.
  */
-#ifdef __tile__
-#define C_ABI_SAVE_AREA_SIZE (2 * __SIZEOF_POINTER__)
-#endif
+#define C_ABI_SAVE_AREA_SIZE (2 * (CHIP_WORD_SIZE() / 8))
 
 /**
  * The operand to an 'info' opcode directing the backtracer to not
diff --git a/arch/tile/include/asm/siginfo.h b/arch/tile/include/asm/siginfo.h
index 0c12d1b..56d661b 100644
--- a/arch/tile/include/asm/siginfo.h
+++ b/arch/tile/include/asm/siginfo.h
@@ -17,6 +17,10 @@
 
 #define __ARCH_SI_TRAPNO
 
+#ifdef __LP64__
+# define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
+#endif
+
 #include <asm-generic/siginfo.h>
 
 /*
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index d5efb21..9c710db 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -56,13 +56,15 @@ struct compat_ucontext {
 	sigset_t	  uc_sigmask;	/* mask last for extensibility */
 };
 
+#define COMPAT_SI_PAD_SIZE	((SI_MAX_SIZE - 3 * sizeof(int)) / sizeof(int))
+
 struct compat_siginfo {
 	int si_signo;
 	int si_errno;
 	int si_code;
 
 	union {
-		int _pad[SI_PAD_SIZE];
+		int _pad[COMPAT_SI_PAD_SIZE];
 
 		/* kill() */
 		struct {
-- 
1.6.5.2

