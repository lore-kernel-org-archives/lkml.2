Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1HNQJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:09:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453Ab1HNQJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:58 2011
Message-Id: <20110812210558.241016800@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [70/90] sparc: Use hweight64() in popc emulation.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit d600cbed0fe8fceec04500824f638dfe4996c653 ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/unaligned_64.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -22,6 +22,7 @@
 #include <linux/bitops.h>
 #include <linux/perf_event.h>
 #include <linux/ratelimit.h>
+#include <linux/bitops.h>
 #include <asm/fpumacro.h>
 
 enum direction {
@@ -373,16 +374,11 @@ asmlinkage void kernel_unaligned_trap(st
 	}
 }
 
-static char popc_helper[] = {
-0, 1, 1, 2, 1, 2, 2, 3,
-1, 2, 2, 3, 2, 3, 3, 4, 
-};
-
 int handle_popc(u32 insn, struct pt_regs *regs)
 {
-	u64 value;
-	int ret, i, rd = ((insn >> 25) & 0x1f);
 	int from_kernel = (regs->tstate & TSTATE_PRIV) != 0;
+	int ret, rd = ((insn >> 25) & 0x1f);
+	u64 value;
 	                        
 	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, 0, regs, 0);
 	if (insn & 0x2000) {
@@ -392,10 +388,7 @@ int handle_popc(u32 insn, struct pt_regs
 		maybe_flush_windows(0, insn & 0x1f, rd, from_kernel);
 		value = fetch_reg(insn & 0x1f, regs);
 	}
-	for (ret = 0, i = 0; i < 16; i++) {
-		ret += popc_helper[value & 0xf];
-		value >>= 4;
-	}
+	ret = hweight64(value);
 	if (rd < 16) {
 		if (rd)
 			regs->u_regs[rd] = ret;


