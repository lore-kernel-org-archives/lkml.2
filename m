Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2HSDBM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:60723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab2HSC5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415457"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, jeremy@goop.org
Subject: [PATCH 52/74] x86, lto, paravirt: Don't rely on local assembler labels
Date: Sat, 18 Aug 2012 19:56:48 -0700
Message-Id: <1345345030-22211-53-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The paravirt patching code assumes that it can reference a
local assembler label between two different top level assembler
statements. This does not work with some experimental gcc builds,
where the assembler code may end up in different assembler files.

Replace it with extern / global /asm linkage labels.

This also removes one redundant copy of the macro.

Cc: jeremy@goop.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/paravirt_types.h |    9 +++++----
 arch/x86/kernel/paravirt.c            |    5 -----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 4f262bc..6a464ba 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -385,10 +385,11 @@ extern struct pv_lock_ops pv_lock_ops;
 	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
 
 /* Simple instruction patching code. */
-#define DEF_NATIVE(ops, name, code) 					\
-	extern const char start_##ops##_##name[] __visible, 		\
-			  end_##ops##_##name[] __visible;		\
-	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
+#define NATIVE_LABEL(a,x,b) "\n\t.globl " a #x "_" #b "\n" a #x "_" #b ":\n\t"
+
+#define DEF_NATIVE(ops, name, code)					\
+	__visible extern const char start_##ops##_##name[], end_##ops##_##name[];	\
+	asm(NATIVE_LABEL("start_", ops, name) code NATIVE_LABEL("end_", ops, name))
 
 unsigned paravirt_patch_nop(void);
 unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 17fff18..947255e 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -62,11 +62,6 @@ void __init default_banner(void)
 	       pv_info.name);
 }
 
-/* Simple instruction patching code. */
-#define DEF_NATIVE(ops, name, code)					\
-	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
-	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
-
 /* Undefined instruction for dealing with missing ops pointers. */
 static const unsigned char ud2a[] = { 0x0f, 0x0b };
 
-- 
1.7.7.6

