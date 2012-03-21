Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161Ab2CUG4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:56:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39114 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965127Ab2CUG4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:56:49 -0400
Subject: [PATCH 08/16] mm/unicore32: use vm_flags_t for vma flags
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Mar 2012 10:56:46 +0400
Message-ID: <20120321065645.13852.83925.stgit@zurg>
In-Reply-To: <20120321065140.13852.52315.stgit@zurg>
References: <20120321065140.13852.52315.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same magic like in arm: assembler code wants to test VM_EXEC,
but for big-endian we should get upper word for this.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/kernel/asm-offsets.c |    6 +++++-
 arch/unicore32/mm/fault.c           |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/unicore32/kernel/asm-offsets.c b/arch/unicore32/kernel/asm-offsets.c
index ffcbe75..e3199b5 100644
--- a/arch/unicore32/kernel/asm-offsets.c
+++ b/arch/unicore32/kernel/asm-offsets.c
@@ -87,9 +87,13 @@ int main(void)
 	DEFINE(S_FRAME_SIZE,	sizeof(struct pt_regs));
 	BLANK();
 	DEFINE(VMA_VM_MM,	offsetof(struct vm_area_struct, vm_mm));
+#if defined(CONFIG_CPU_BIG_ENDIAN) && (NR_VMA_FLAGS > 32)
+	DEFINE(VMA_VM_FLAGS,	offsetof(struct vm_area_struct, vm_flags) + 4);
+#else
 	DEFINE(VMA_VM_FLAGS,	offsetof(struct vm_area_struct, vm_flags));
+#endif
 	BLANK();
-	DEFINE(VM_EXEC,		VM_EXEC);
+	DEFINE(VM_EXEC,		(__force unsigned int)VM_EXEC);
 	BLANK();
 	DEFINE(PAGE_SZ,		PAGE_SIZE);
 	BLANK();
diff --git a/arch/unicore32/mm/fault.c b/arch/unicore32/mm/fault.c
index 283aa4b..9137996 100644
--- a/arch/unicore32/mm/fault.c
+++ b/arch/unicore32/mm/fault.c
@@ -158,7 +158,7 @@ void do_bad_area(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
  */
 static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
 {
-	unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
+	vm_flags_t mask = VM_READ | VM_WRITE | VM_EXEC;
 
 	if (!(fsr ^ 0x12))	/* write? */
 		mask = VM_WRITE;

