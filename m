Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2E3RAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:00:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab2E3RAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:00:13 -0400
Date: Wed, 30 May 2012 18:58:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] uprobes: install_breakpoint() should fail if
	is_swbp_insn() == T
Message-ID: <20120530165816.GA8085@redhat.com>
References: <20120530165757.GA8077@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530165757.GA8077@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

install_breakpoint() returns -EEXIST if is_swbp_insn(orig_insn) == T,
the caller treats this code as success.

This is doubly wrong. The successful return should set UPROBE_COPY_INSN,
but the real problem is that it shouldn't succeed. If the probed insn is
int3 the application should get SIGTRAP, this won't happen with uprobe.

Probably we can fix this, we can add the UPROBE_SHARED_BP flag and teach
handle_swbp/set_orig_insn to handle this case correctly. But this needs
some complications and we have other insns which can't be probed, lets
make a simple fix for now.

I think this needs a cleanup. UPROBE_COPY_INSN should die, copy_insn()
should be called by alloc_uprobe(). arch_uprobe_analyze_insn() depends
on ->mm (ia32_compat) but it is called only once.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 8c5e043..1593b43 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -704,7 +704,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 			return ret;
 
 		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
-			return -EEXIST;
+			return -ENOTSUPP;
 
 		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm);
 		if (ret)
-- 
1.5.5.1


