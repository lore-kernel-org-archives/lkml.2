Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab0D2Azh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:55:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:50503 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab0D2AzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:55:10 -0400
Date: Thu, 29 Apr 2010 00:55:01 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de
In-Reply-To: <4BCF30FE020000780003B3B6@vpn.id2.novell.com>
References: <4BCF30FE020000780003B3B6@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Reduce SMP locks table size
Message-ID: <tip-5967ed87ade85a421ef814296c3c7f182b08c225@git.kernel.org>
Git-Commit-ID: 5967ed87ade85a421ef814296c3c7f182b08c225
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Apr 2010 00:55:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5967ed87ade85a421ef814296c3c7f182b08c225
Gitweb:     http://git.kernel.org/tip/5967ed87ade85a421ef814296c3c7f182b08c225
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Wed, 21 Apr 2010 16:08:14 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 28 Apr 2010 17:15:47 -0700

x86-64: Reduce SMP locks table size

Reduce the SMP locks table size by using relative pointers instead of
absolute ones, thus cutting the table size by half.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4BCF30FE020000780003B3B6@vpn.id2.novell.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/alternative-asm.h |    4 +-
 arch/x86/include/asm/alternative.h     |    4 +-
 arch/x86/kernel/alternative.c          |   45 +++++++++++++++++--------------
 3 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index b97f786..a63a68b 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
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
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index b09ec55..714bf24 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
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
 
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1a160d5..9367384 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -194,7 +194,7 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 }
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
-extern u8 *__smp_locks[], *__smp_locks_end[];
+extern s32 __smp_locks[], __smp_locks_end[];
 static void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
@@ -235,37 +235,39 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 
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
