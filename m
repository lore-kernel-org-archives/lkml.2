Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309Ab2JAXD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:28 -0400
Received: from 1wt.eu ([62.212.114.60]:35655 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933266Ab2JAXDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:22 -0400
Message-Id: <20121001225201.421810660@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Steffen Rumler <steffen.rumler.ext@nsn.com>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 090/180] powerpc: Fix kernel panic during kernel module load
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Rumler <steffen.rumler.ext@nsn.com>

commit 3c75296562f43e6fbc6cddd3de948a7b3e4e9bcf upstream.

This fixes a problem which can causes kernel oopses while loading
a kernel module.

According to the PowerPC EABI specification, GPR r11 is assigned
the dedicated function to point to the previous stack frame.
In the powerpc-specific kernel module loader, do_plt_call()
(in arch/powerpc/kernel/module_32.c), GPR r11 is also used
to generate trampoline code.

This combination crashes the kernel, in the case where the compiler
chooses to use a helper function for saving GPRs on entry, and the
module loader has placed the .init.text section far away from the
.text section, meaning that it has to generate a trampoline for
functions in the .init.text section to call the GPR save helper.
Because the trampoline trashes r11, references to the stack frame
using r11 can cause an oops.

The fix just uses GPR r12 instead of GPR r11 for generating the
trampoline code.  According to the statements from Freescale, this is
safe from an EABI perspective.

I've tested the fix for kernel 2.6.33 on MPC8541.

Signed-off-by: Steffen Rumler <steffen.rumler.ext@nsn.com>
[paulus@samba.org: reworded the description]
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/powerpc/kernel/module_32.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/module_32.c b/arch/powerpc/kernel/module_32.c
index f832773..449a7e0 100644
--- a/arch/powerpc/kernel/module_32.c
+++ b/arch/powerpc/kernel/module_32.c
@@ -187,8 +187,8 @@ int apply_relocate(Elf32_Shdr *sechdrs,
 
 static inline int entry_matches(struct ppc_plt_entry *entry, Elf32_Addr val)
 {
-	if (entry->jump[0] == 0x3d600000 + ((val + 0x8000) >> 16)
-	    && entry->jump[1] == 0x396b0000 + (val & 0xffff))
+	if (entry->jump[0] == 0x3d800000 + ((val + 0x8000) >> 16)
+	    && entry->jump[1] == 0x398c0000 + (val & 0xffff))
 		return 1;
 	return 0;
 }
@@ -215,10 +215,9 @@ static uint32_t do_plt_call(void *location,
 		entry++;
 	}
 
-	/* Stolen from Paul Mackerras as well... */
-	entry->jump[0] = 0x3d600000+((val+0x8000)>>16);	/* lis r11,sym@ha */
-	entry->jump[1] = 0x396b0000 + (val&0xffff);	/* addi r11,r11,sym@l*/
-	entry->jump[2] = 0x7d6903a6;			/* mtctr r11 */
+	entry->jump[0] = 0x3d800000+((val+0x8000)>>16); /* lis r12,sym@ha */
+	entry->jump[1] = 0x398c0000 + (val&0xffff);     /* addi r12,r12,sym@l*/
+	entry->jump[2] = 0x7d8903a6;                    /* mtctr r12 */
 	entry->jump[3] = 0x4e800420;			/* bctr */
 
 	DEBUGP("Initialized plt for 0x%x at %p\n", val, entry);
-- 
1.7.2.1.45.g54fbc



