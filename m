Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2FRIxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:53:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40434 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2FRIxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:53:03 -0400
Date: Mon, 18 Jun 2012 01:52:42 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-c1914a0936f79ed0236f670122e06e36e4d332ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154331.GA9578@redhat.com>
References: <20120615154331.GA9578@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Install_breakpoint()
  should fail if is_swbp_insn() == T
Git-Commit-ID: c1914a0936f79ed0236f670122e06e36e4d332ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 01:52:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1914a0936f79ed0236f670122e06e36e4d332ee
Gitweb:     http://git.kernel.org/tip/c1914a0936f79ed0236f670122e06e36e4d332ee
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:43 +0200

uprobes: Install_breakpoint() should fail if is_swbp_insn() == T

install_breakpoint() returns -EEXIST if is_swbp_insn(orig_insn)
== T, the caller treats this code as success.

This is doubly wrong. The successful return should set
UPROBE_COPY_INSN, but the real problem is that it shouldn't
succeed. If the probed insn is int3 the application should get
SIGTRAP, this won't happen with uprobe.

Probably we can fix this, we can add the UPROBE_SHARED_BP flag
and teach handle_swbp/set_orig_insn to handle this case
correctly. But this needs some complications and we have other
insns which can't be probed, lets make a simple fix for now.

I think this needs a cleanup. UPROBE_COPY_INSN should die,
copy_insn() should be called by alloc_uprobe().
arch_uprobe_analyze_insn() depends on ->mm (ia32_compat) but it
is called only once.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120615154331.GA9578@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
