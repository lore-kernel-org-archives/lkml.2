Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab2GMVWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:22:09 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:33590 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab2GMVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:20:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hirokazu Takata <takata@linux-m32r.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] m32r: Fix 'fix breakage from "m32r: use generic ptrace_resume code"' fallout
Date: Fri, 13 Jul 2012 23:20:24 +0200
Message-Id: <1342214427-17607-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1342214427-17607-1-git-send-email-geert@linux-m68k.org>
References: <1342214427-17607-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit acdc0d5ef9dd74534fe8df77a2056fa1d911abe5 ('m32r: fix breakage from
"m32r: use generic ptrace_resume code"') tried to fix commit
e34112e3966fc466ced2698e6c196bb50b1ee20e ("m32r: use generic ptrace_resume
code") by returning values in a function returning void, causing:

arch/m32r/kernel/ptrace.c: In function 'user_enable_single_step':
arch/m32r/kernel/ptrace.c:594:3: warning: 'return' with a value, in function returning void [enabled by default]
arch/m32r/kernel/ptrace.c:598:3: warning: 'return' with a value, in function returning void [enabled by default]
arch/m32r/kernel/ptrace.c:601:3: warning: 'return' with a value, in function returning void [enabled by default]
arch/m32r/kernel/ptrace.c:604:2: warning: 'return' with a value, in function returning void [enabled by default]

Remove the unneeded return values.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
--
Is this the correct fix? There's no way to propagate failures
---
 arch/m32r/kernel/ptrace.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/m32r/kernel/ptrace.c b/arch/m32r/kernel/ptrace.c
index 4c03361..51f5e9a 100644
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -591,17 +591,16 @@ void user_enable_single_step(struct task_struct *child)
 
 	if (access_process_vm(child, pc&~3, &insn, sizeof(insn), 0)
 	    != sizeof(insn))
-		return -EIO;
+		return;
 
 	compute_next_pc(insn, pc, &next_pc, child);
 	if (next_pc & 0x80000000)
-		return -EIO;
+		return;
 
 	if (embed_debug_trap(child, next_pc))
-		return -EIO;
+		return;
 
 	invalidate_cache();
-	return 0;
 }
 
 void user_disable_single_step(struct task_struct *child)
-- 
1.7.0.4

