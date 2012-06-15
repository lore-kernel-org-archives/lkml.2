Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2FOPph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:45:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab2FOPpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:45:34 -0400
Date: Fri, 15 Jun 2012 17:43:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/15] uprobes: install_breakpoint() should fail if
	is_swbp_insn() == T
Message-ID: <20120615154331.GA9578@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615154241.GA9524@redhat.com>
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
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/events/uprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 3ccdb29..ec78152 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -693,7 +693,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 			return ret;
 
 		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
-			return -EEXIST;
+			return -ENOTSUPP;
 
 		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, addr);
 		if (ret)
-- 
1.5.5.1

