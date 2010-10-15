Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0JOUL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:11:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab0JOUKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:10:40 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=c-iajO6-n_4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=enOvQawGAAAA:8 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=meVymXHHAAAA:8 a=nDo3GkDlcchujGXVEJ4A:9 a=LHNmAR8Ys2TyTDSEY10A:7 a=6zndwQZ14lxm57RVJyBt58UhIbYA:4 a=bkT6KWdcy0IA:10 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101015201037.703989993@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 15 Oct 2010 16:09:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, David Miller <davem@davemloft.net>,
        David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 8/9] jump label: Make arch_jump_label_text_poke_early() optional
References: <20101015200949.134732894@goodmis.org>
Content-Disposition: inline; filename=0008-jump-label-Make-arch_jump_label_text_poke_early-opti.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>

For the forthcoming MIPS jump label support,
arch_jump_label_text_poke_early() is unneeded as the MIPS NOP
instruction is already optimal.

Supply a default implementation that does nothing.  Flag x86 and SPARC
as having arch_jump_label_text_poke_early().

Cc: Jason Baron <jbaron@redhat.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: David Daney <ddaney@caviumnetworks.com>
LKML-Reference: <1286218615-24011-2-git-send-email-ddaney@caviumnetworks.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
index 382cd23..c3562cf 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -22,7 +22,13 @@ extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
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
1.7.1


