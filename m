Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2DEWV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:21:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab2DEWVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:21:25 -0400
Date: Fri, 6 Apr 2012 00:20:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: [RFC 0/6] uprobes: kill uprobes_srcu/uprobe_srcu_id
Message-ID: <20120405222024.GA19154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Not for inclusion yet, only for the early review.

I didn't even try to test these changes, and I am not expert
in this area. And even _if_ this code is correct, I need to
re-split these changes anyway, update the changelogs, etc.

Questions:

	- does it make sense?

	- can it work or I missed something "in general" ?

Why:

	- It would be nice to remove a member from task_struct.

	- Afaics, the usage of uprobes_srcu does not look right,
	  at least in theory, see 6/6.

	  The comment above delete_uprobe() says:

	  	The current unregistering thread waits till all
	  	other threads have hit a breakpoint, to acquire
	  	the uprobes_treelock before the uprobe is removed
	  	from the rbtree.

	  but synchronize_srcu() can only help if a thread which
	  have hit the breakpoint has already called srcu_read_lock().
	  It can't synchronize with read_lock "in future", and there
	  is a small window.

	  We could probably add another synchronize_sched() before
	  synchronize_srcu(), but this doesn't look very nice and

	- I am not sure yet, but perhaps with these changes we can
	  also kill mm->uprobes_state.count.

Any review is very much appreciated.

Oleg.

 include/linux/sched.h   |    1 -
 kernel/events/uprobes.c |  117 ++++++++++++++++++++++++++++++-----------------
 2 files changed, 75 insertions(+), 43 deletions(-)

