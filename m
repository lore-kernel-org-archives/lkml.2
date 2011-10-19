Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1JSV7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:59:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab1JSV67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:58:59 -0400
Date: Wed, 19 Oct 2011 23:54:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/X] uprobes: uprobe_deny_signal: check
	__fatal_signal_pending()
Message-ID: <20111019215402.GH16395@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com> <20111019215139.GA16395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019215139.GA16395@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change uprobe_deny_signal() to check __fatal_signal_pending() along with
xol_was_trapped().

Normally this is not really needed but this is safer. And this makes more
clear the fact that even SIGKILL is handled via UTASK_SSTEP_TRAPPED. Once
again, SIGKILL can be pending because of the core-dumping, we should not
exit with regs->ip pointing to ->xol_vaddr.
---
 kernel/uprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index aa5492a..9e9d4e4 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1335,7 +1335,7 @@ bool uprobe_deny_signal(void)
 		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 		spin_unlock_irq(&tsk->sighand->siglock);
 
-		if (xol_was_trapped(tsk)) {
+		if (__fatal_signal_pending(tsk) || xol_was_trapped(tsk)) {
 			utask->state = UTASK_SSTEP_TRAPPED;
 			set_tsk_thread_flag(tsk, TIF_UPROBE);
 			set_tsk_thread_flag(tsk, TIF_NOTIFY_RESUME);
-- 
1.5.5.1


