Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2DNNRF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 09:17:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:60371 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2DNNRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 09:17:04 -0400
Message-ID: <1334409396.2528.100.camel@twins>
Subject: Re: [RFC 0/6] uprobes: kill uprobes_srcu/uprobe_srcu_id
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Date: Sat, 14 Apr 2012 15:16:36 +0200
In-Reply-To: <20120405222024.GA19154@redhat.com>
References: <20120405222024.GA19154@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 00:20 +0200, Oleg Nesterov wrote:
> Hello.
> 
> Not for inclusion yet, only for the early review.
> 
> I didn't even try to test these changes, and I am not expert
> in this area. And even _if_ this code is correct, I need to
> re-split these changes anyway, update the changelogs, etc.
> 
> Questions:
> 
> 	- does it make sense?

Maybe, upside is reclaiming that int from task_struct, downside is that
down_write :/ It would be very good not to have to do that. Nor do I
really see how that works.

> 	- can it work or I missed something "in general" ?

So we insert in the rb-tree before we take mmap_sem, this means we can
hit a non-uprobe int3 and still find a uprobe there, no?

> Why:
> 
> 	- It would be nice to remove a member from task_struct.
> 
> 	- Afaics, the usage of uprobes_srcu does not look right,
> 	  at least in theory, see 6/6.
> 
> 	  The comment above delete_uprobe() says:
> 
> 	  	The current unregistering thread waits till all
> 	  	other threads have hit a breakpoint, to acquire
> 	  	the uprobes_treelock before the uprobe is removed
> 	  	from the rbtree.
> 
> 	  but synchronize_srcu() can only help if a thread which
> 	  have hit the breakpoint has already called srcu_read_lock().
> 	  It can't synchronize with read_lock "in future", and there
> 	  is a small window.
> 
> 	  We could probably add another synchronize_sched() before
> 	  synchronize_srcu(), but this doesn't look very nice and

Right, I think that all was written with the assumption that sync_srcu
implied a sync_rcu, which of course we've recently wrecked.


