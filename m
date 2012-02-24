Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab2BXKdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:33:04 -0500
Received: from wildebeest.demon.nl ([80.101.103.228]:36062 "EHLO
	gnu.wildebeest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab2BXKdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:33:02 -0500
From: "Mark J. Wielaard" <mjw@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Wielaard <mjw@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
	ARCHITECTURE...),
        Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE... 
	,commit_signer:11/25=44%),
        "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE... 
	,commit_signer:4/25=16%),
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Jan Beulich <jbeulich@suse.com> (commit_signer:6/25=24%),
        Andi Kleen <ak@linux.intel.com> (commit_signer:5/25=20%),
        Frederic Weisbecker <fweisbec@gmail.com> (commit_signer:4/25=16%)
Subject: [PATCH] x86-64: Fix CFI data for common_interrupt
Date: Fri, 24 Feb 2012 11:32:05 +0100
Message-Id: <1330079527-30711-1-git-send-email-mjw@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <4F476B4E0200007800074936@nat28.tlf.novell.com>
References: <4F476B4E0200007800074936@nat28.tlf.novell.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Wielaard <mjw@redhat.com>

Commit eab9e6 "x86-64: Fix CFI data for interrupt frames" introduced
a DW_CFA_def_cfa_expression in the SAVE_ARGS_IRQ macro. To later define
the CFA using a simple register+offset rule both register and offset
need to be supplied. Just using CFI_DEF_CFA_REGISTER leaves the offset
undefined. So use CFI_DEF_CFA with reg+off explicitly at the end of
common_interrupt.

Signed-off-by: Mark Wielaard <mjw@redhat.com>
Acked-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3fe8239..54be36b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -813,7 +813,7 @@ ret_from_intr:
 
 	/* Restore saved previous stack */
 	popq %rsi
-	CFI_DEF_CFA_REGISTER	rsi
+	CFI_DEF_CFA rsi,SS+8-RBP	/* reg/off reset after def_cfa_expr */
 	leaq ARGOFFSET-RBP(%rsi), %rsp
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	RBP-ARGOFFSET
-- 
1.7.7.6

