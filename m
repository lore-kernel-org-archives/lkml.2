Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2L3Prh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 10:47:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab2L3Prc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 10:47:32 -0500
Date: Sun, 30 Dec 2012 16:47:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] uprobes/x86: Change __skip_sstep() to actually skip
	the whole insn
Message-ID: <20121230154719.GA28510@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121230154657.GA28488@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__skip_sstep() doesn't update regs->ip. Currently this is correct
but only "by accident" and it doesn't skip the whole insn. Change
it to advance ->ip by the length of the detected 0x66*0x90 sequence.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index c71025b..4e33a35 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -680,8 +680,11 @@ static bool __skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		if (auprobe->insn[i] == 0x66)
 			continue;
 
-		if (auprobe->insn[i] == 0x90)
+		if (auprobe->insn[i] == 0x90) {
+			regs->ip = uprobe_get_swbp_addr(regs);
+			regs->ip += i + 1;
 			return true;
+		}
 
 		break;
 	}
-- 
1.5.5.1

