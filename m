Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0DUPIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:08:18 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:55984 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0DUPIR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 21 Apr 2010 11:08:17 -0400
Message-Id: <4BCF30FE020000780003B3B6@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 21 Apr 2010 16:08:14 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: reduce SMP locks table size
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... by using relative pointers instead of absolute ones, thus cutting
the table size by half.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/alternative-asm.h |    4 +-
 arch/x86/include/asm/alternative.h     |    4 +-
 arch/x86/kernel/alternative.c          |   45 ++++++++++++++++++---------------
 3 files changed, 29 insertions(+), 24 deletions(-)

--- linux-2.6.34-rc5/arch/x86/include/asm/alternative-asm.h	2010-02-24 19:52:17.000000000 +0100
+++ 2.6.34-rc5-x86_64-smp-locks-reduce-size/arch/x86/include/asm/alternative-asm.h	2010-04-15 11:58:18.000000000 +0200
@@ -6,8 +6,8 @@
 	.macro LOCK_PREFIX
 1:	lock
 	.section .smp_locks,"a"
-	_ASM_ALIGN
-	_ASM_PTR 1b
+	.balign 4
+	.long 1b - .
 	.previous
 	.endm
 #else
--- linux-2.6.34-rc5/arch/x86/include/asm/alternative.h	2010-04-20 16:07:30.000000000 +0200
+++ 2.6.34-rc5-x86_64-smp-locks-reduce-size/arch/x86/include/asm/alternative.h	2010-04-15 11:58:18.000000000 +0200
@@ -30,8 +30,8 @@
 #ifdef CONFIG_SMP
 #define LOCK_PREFIX \
 		".section .smp_locks,\"a\"\n"	\
-		_ASM_ALIGN "\n"			\
-		_ASM_PTR "661f\n" /* address */	\
+		".balign 4\n"			\
+		".long 661f - .\n" /* offset */	\
 		".previous\n"			\
 		"661:\n\tlock; "
 
--- linux-2.6.34-rc5/arch/x86/kernel/alternative.c	2010-04-20 16:07:31.000000000 +0200
+++ 2.6.34-rc5-x86_64-smp-locks-reduce-size/arch/x86/kernel/alternative.c	2010-04-15 11:58:18.000000000 +0200
@@ -194,7 +194,7 @@ static void __init_or_module add_nops(vo
 }
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
-extern u8 *__smp_locks[], *__smp_locks_end[];
+extern s32 __smp_locks[], __smp_locks_end[];
 static void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
@@ -235,37 +235,39 @@ void __init_or_module apply_alternatives
 
 #ifdef CONFIG_SMP
 
-static void alternatives_smp_lock(u8 **start, u8 **end, u8 *text, u8 *text_end)
+static void alternatives_smp_lock(const s32 *start, const s32 *end,
+				  u8 *text, u8 *text_end)
 {
-	u8 **ptr;
+	const s32 *poff;
 
 	mutex_lock(&text_mutex);
-	for (ptr = start; ptr < end; ptr++) {
-		if (*ptr < text)
-			continue;
-		if (*ptr > text_end)
+	for (poff = start; poff < end; poff++) {
+		u8 *ptr = (u8 *)poff + *poff;
+
+		if (!*poff || ptr < text || ptr >= text_end)
 			continue;
 		/* turn DS segment override prefix into lock prefix */
-		text_poke(*ptr, ((unsigned char []){0xf0}), 1);
+		text_poke(ptr, ((unsigned char []){0xf0}), 1);
 	};
 	mutex_unlock(&text_mutex);
 }
 
-static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end)
+static void alternatives_smp_unlock(const s32 *start, const s32 *end,
+				    u8 *text, u8 *text_end)
 {
-	u8 **ptr;
+	const s32 *poff;
 
 	if (noreplace_smp)
 		return;
 
 	mutex_lock(&text_mutex);
-	for (ptr = start; ptr < end; ptr++) {
-		if (*ptr < text)
-			continue;
-		if (*ptr > text_end)
+	for (poff = start; poff < end; poff++) {
+		u8 *ptr = (u8 *)poff + *poff;
+
+		if (!*poff || ptr < text || ptr >= text_end)
 			continue;
 		/* turn lock prefix into DS segment override prefix */
-		text_poke(*ptr, ((unsigned char []){0x3E}), 1);
+		text_poke(ptr, ((unsigned char []){0x3E}), 1);
 	};
 	mutex_unlock(&text_mutex);
 }
@@ -276,8 +278,8 @@ struct smp_alt_module {
 	char		*name;
 
 	/* ptrs to lock prefixes */
-	u8		**locks;
-	u8		**locks_end;
+	const s32	*locks;
+	const s32	*locks_end;
 
 	/* .text segment, needed to avoid patching init code ;) */
 	u8		*text;
@@ -398,16 +400,19 @@ void alternatives_smp_switch(int smp)
 int alternatives_text_reserved(void *start, void *end)
 {
 	struct smp_alt_module *mod;
-	u8 **ptr;
+	const s32 *poff;
 	u8 *text_start = start;
 	u8 *text_end = end;
 
 	list_for_each_entry(mod, &smp_alt_modules, next) {
 		if (mod->text > text_end || mod->text_end < text_start)
 			continue;
-		for (ptr = mod->locks; ptr < mod->locks_end; ptr++)
-			if (text_start <= *ptr && text_end >= *ptr)
+		for (poff = mod->locks; poff < mod->locks_end; poff++) {
+			const u8 *ptr = (const u8 *)poff + *poff;
+
+			if (text_start <= ptr && text_end > ptr)
 				return 1;
+		}
 	}
 
 	return 0;


