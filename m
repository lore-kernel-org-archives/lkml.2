Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab2JFSwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:52:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab2JFSwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:52:37 -0400
Date: Sat, 6 Oct 2012 20:53:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] uprobes: Fix handle_swbp() vs unregister() +
	register() race
Message-ID: <20121006185337.GA14697@redhat.com>
References: <20120930194119.GA11278@redhat.com> <20120930194211.GA11333@redhat.com> <20121006093311.GB9145@linux.vnet.ibm.com> <20121006172531.GB9819@redhat.com> <20121006173719.GA9143@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121006173719.GA9143@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06, Srikar Dronamraju wrote:
>
> >
> > for the future changes... (say, we can remove bp if consumers do not
> > want to trace this task). Not sure it makes sense to change it right
> > now.
> >
> > So. Should I leave this patch as is? Or do you want me to move this
> > check into handler_chain() and make it return "bool restart"?
>
> Lets keep it as is for now.
>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks...

But I am starting to think that I misunderstood your comment, you
did not suggest to add this check into skip_sstep() as I wrongly
thought.

And yes, I agree it would be more clean to move it out from
find_active_uprobe() and avoid put_uprobe && clear_swbp....

So how about v2 below?

------------------------------------------------------------------------------
[PATCH 4/7] uprobes: Fix handle_swbp() vs unregister() + register() race

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

Add the additional !UPROBE_COPY_INSN check into handle_swbp(),
if this flag is not set we simply restart as if the new uprobe was
not inserted yet. This is not very nice, we need barriers, but we
will remove this hack when we change uprobe_register().

Note: with or without this patch install_breakpoint() can race with
itself, yet another reson to kill UPROBE_COPY_INSN altogether. And
even the usage of uprobe->flags is not safe. See the next patches.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/events/uprobes.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index cfa22c4..dbbca3a 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -596,6 +596,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 		BUG_ON((uprobe->offset & ~PAGE_MASK) +
 				UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
 
+		smp_wmb(); /* pairs with rmb() in find_active_uprobe() */
 		uprobe->flags |= UPROBE_COPY_INSN;
 	}
 
@@ -1436,6 +1437,14 @@ static void handle_swbp(struct pt_regs *regs)
 		}
 		return;
 	}
+	/*
+	 * TODO: move copy_insn/etc into _register and remove this hack.
+	 * After we hit the bp, _unregister + _register can install the
+	 * new and not-yet-analyzed uprobe at the same address, restart.
+	 */
+	smp_rmb(); /* pairs with wmb() in install_breakpoint() */
+	if (unlikely(!(uprobe->flags & UPROBE_COPY_INSN)))
+		goto restart;
 
 	utask = current->utask;
 	if (!utask) {
-- 
1.5.5.1


