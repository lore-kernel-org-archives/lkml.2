Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2G3MCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:02:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47107 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2G3MCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:02:03 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 11/11] ARM: Get rid of .LCcralign local label usage in alignment_trap macro
Date: Mon, 30 Jul 2012 04:58:20 -0700
Message-Id: <1343649500-18491-11-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120730115719.GA5742@lizard>
References: <20120730115719.GA5742@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the code more izolated.

The downside of this is that we now have an additional branch and the
code itself is 8 bytes longer. But on the bright side, this new layout
can be more cache friendly since cr_alignment address might be already
in the cache line (not that I measured anything, it's just fun to think
about it).

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/kernel/entry-armv.S     |    2 --
 arch/arm/kernel/entry-header.S   |    6 +++++-
 arch/arm/kernel/kgdb_fiq_entry.S |    3 ---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 6aeb9b8..6b04ab5 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -266,8 +266,6 @@ __pabt_svc:
 ENDPROC(__pabt_svc)
 
 	.align	5
-.LCcralign:
-	.word	cr_alignment
 #ifdef MULTI_DABORT
 .LCprocfns:
 	.word	processor
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index c3c09ac..5a05e7f 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -38,9 +38,13 @@
 
 	.macro	alignment_trap, rtemp
 #ifdef CONFIG_ALIGNMENT_TRAP
-	ldr	\rtemp, .LCcralign
+	ldr	\rtemp, 1f
 	ldr	\rtemp, [\rtemp]
 	mcr	p15, 0, \rtemp, c1, c0
+	b	2f
+1:
+	.word	cr_alignment
+2:
 #endif
 	.endm
 
diff --git a/arch/arm/kernel/kgdb_fiq_entry.S b/arch/arm/kernel/kgdb_fiq_entry.S
index 7be3726..e7c05fc 100644
--- a/arch/arm/kernel/kgdb_fiq_entry.S
+++ b/arch/arm/kernel/kgdb_fiq_entry.S
@@ -18,9 +18,6 @@
 
 	.text
 
-@ This is needed for usr_entry/alignment_trap
-.LCcralign:
-	.long	cr_alignment
 .LCdohandle:
 	.long	kgdb_fiq_do_handle
 
-- 
1.7.10.4

