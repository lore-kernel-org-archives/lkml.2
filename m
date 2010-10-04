Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab0JDS5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:57:08 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19548 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab0JDS5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:57:06 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, jbaron@redhat.com
Cc: David Daney <ddaney@caviumnetworks.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH v2 1/2] jump label: Make arch_jump_label_text_poke_early() optional
Date: Mon,  4 Oct 2010 11:56:54 -0700
Message-Id: <1286218615-24011-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286218615-24011-1-git-send-email-ddaney@caviumnetworks.com>
References: <1286218615-24011-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 04 Oct 2010 18:57:10.0123 (UTC) FILETIME=[F2C38BB0:01CB63F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the forthcoming MIPS jump label support,
arch_jump_label_text_poke_early() is unneeded as the MIPS NOP
instruction is already optimal.

Supply a default implementation that does nothing.  Flag x86 and SPARC
as having arch_jump_label_text_poke_early().

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: David Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/jump_label.h |    1 +
 arch/x86/include/asm/jump_label.h   |    1 +
 include/linux/jump_label.h          |    6 ++++++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index 62e66d7..9aa82d7 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <asm/system.h>
 
+#define HAVE_ARCH_JUMP_LABEL_TEXT_POKE_EARLY
 #define JUMP_LABEL_NOP_SIZE 4
 
 #define JUMP_LABEL(key, label)					\
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index f52d42e..169cfd8 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <asm/nops.h>
 
+#define HAVE_ARCH_JUMP_LABEL_TEXT_POKE_EARLY
 #define JUMP_LABEL_NOP_SIZE 5
 
 # define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index b72cd9f..e98ad3a 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -20,7 +20,13 @@ extern struct jump_entry __stop___jump_table[];
 
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
+
+#ifdef HAVE_ARCH_JUMP_LABEL_TEXT_POKE_EARLY
 extern void arch_jump_label_text_poke_early(jump_label_t addr);
+#else
+static inline void arch_jump_label_text_poke_early(jump_label_t addr) {}
+#endif
+
 extern void jump_label_update(unsigned long key, enum jump_label_type type);
 extern void jump_label_apply_nops(struct module *mod);
 extern int jump_label_text_reserved(void *start, void *end);
-- 
1.7.2.2

