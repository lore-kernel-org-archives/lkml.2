Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab2JBSks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:40:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab2JBSko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:40:44 -0400
Date: Tue, 2 Oct 2012 20:42:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] uprobes: Fix handle_swbp() vs unregister() +
	register() race
Message-ID: <20121002184210.GA24199@redhat.com>
References: <20120930194119.GA11278@redhat.com> <20120930194211.GA11333@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120930194211.GA11333@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Oleg Nesterov wrote:
>
> +	if (uprobe && unlikely(!(uprobe->flags & UPROBE_COPY_INSN))) {
> +		uprobe = NULL;
> +		*is_swbp = 0;
> +	}

OOPS. this obvioulsy needs put_uprobe(uprobe). I updated this patch
in my tree.

-------------------------------------------------------------------
[PATCH] uprobes: Fix handle_swbp() vs unregister() + register() race

Strictly speaking this race was added by me in 56bb4cf6. However
I think that this bug is just another indication that we should
move copy_insn/uprobe_analyze_insn code from install_breakpoint()
to uprobe_register(), there are a lot of other reasons for that.
Until then, add a hack to close the race.

A task can hit uprobe U1, but before it calls find_uprobe() this
uprobe can be unregistered *AND* another uprobe U2 can be added to
uprobes_tree at the same inode/offset. In this case handle_swbp()
will use the not-fully-initialized U2, in particular its arch.insn
for xol.

Add the additional !UPROBE_COPY_INSN check into find_active_uprobe,
if this flag is not set we simply restart as if the new uprobe was
not inserted yet. This is not very nice, we need barriers, but we
will remove this hack when we change uprobe_register().

Note: with or without this patch install_breakpoint() can race with
itself, yet another reson to kill UPROBE_COPY_INSN altogether. And
even the usage of uprobe->flags is not safe. See the next patches.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 6058231..5c77137 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -596,6 +596,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 		BUG_ON((uprobe->offset & ~PAGE_MASK) +
 				UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
 
+		smp_wmb(); /* pairs with rmb() in find_active_uprobe() */
 		uprobe->flags |= UPROBE_COPY_INSN;
 	}
 
@@ -1391,6 +1392,17 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 	if (!uprobe && test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags))
 		mmf_recalc_uprobes(mm);
 	up_read(&mm->mmap_sem);
+	/*
+	 * TODO: move copy_insn/etc into _register and remove this hack.
+	 * After we hit the bp, _unregister + _register can install the
+	 * new and not-yet-analyzed uprobe at the same address, restart.
+	 */
+	smp_rmb(); /* pairs with wmb() in install_breakpoint() */
+	if (uprobe && unlikely(!(uprobe->flags & UPROBE_COPY_INSN))) {
+		put_uprobe(uprobe);
+		uprobe = NULL;
+		*is_swbp = 0;
+	}
 
 	return uprobe;
 }
-- 
1.5.5.1


