Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2DSJZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:25:09 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51197 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab2DSJZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:25:08 -0400
Date: Thu, 19 Apr 2012 11:24:51 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/3] x86, extable: Cleanup fixup_exception
Message-ID: <20120419092451.GB29542@aftab>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <20120419092255.GA29542@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419092255.GA29542@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 74643bebf6b592f179974caa033f2f095d28bb74 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@alien8.de>
Date: Sat, 31 Mar 2012 16:29:03 +0200
Subject: [PATCH 1/3] x86, extable: Cleanup fixup_exception

And especially, fork out the CONFIG_PNPBIOS lump into its own function
and salvage a tab by inverting error code checking.

No functionality change.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/mm/extable.c |   33 ++++++++++++++++++---------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 1fb85dbe390a..08aecb0d3132 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -2,13 +2,10 @@
 #include <linux/spinlock.h>
 #include <asm/uaccess.h>
 
-
-int fixup_exception(struct pt_regs *regs)
+static void pnp_bios_is_crap(unsigned long cs)
 {
-	const struct exception_table_entry *fixup;
-
 #ifdef CONFIG_PNPBIOS
-	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs))) {
+	if (unlikely(SEGMENT_IS_PNP_CODE(cs))) {
 		extern u32 pnp_bios_fault_eip, pnp_bios_fault_esp;
 		extern u32 pnp_bios_is_utter_crap;
 		pnp_bios_is_utter_crap = 1;
@@ -20,18 +17,24 @@ int fixup_exception(struct pt_regs *regs)
 		panic("do_trap: can't hit this");
 	}
 #endif
+}
+
+int fixup_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *fixup;
+
+	pnp_bios_is_crap(regs->cs);
 
 	fixup = search_exception_tables(regs->ip);
-	if (fixup) {
-		/* If fixup is less than 16, it means uaccess error */
-		if (fixup->fixup < 16) {
-			current_thread_info()->uaccess_err = 1;
-			regs->ip += fixup->fixup;
-			return 1;
-		}
-		regs->ip = fixup->fixup;
+	if (!fixup)
+		return 0;
+
+	/* If fixup is less than 16, it means uaccess error */
+	if (fixup->fixup < 16) {
+		current_thread_info()->uaccess_err = 1;
+		regs->ip += fixup->fixup;
 		return 1;
 	}
-
-	return 0;
+	regs->ip = fixup->fixup;
+	return 1;
 }
-- 
1.7.5.3.401.gfb674

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
