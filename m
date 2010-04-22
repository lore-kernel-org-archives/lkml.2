Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0DVNcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:32:09 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41706 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab0DVNcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:32:05 -0400
Date: Thu, 22 Apr 2010 19:01:54 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
Message-ID: <20100422133154.GA10776@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6>
 <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6>
 <20100413183537.GA17538@redhat.com>
 <20100415093506.GA2064@linux.vnet.ibm.com>
 <20100419193139.GA24080@redhat.com>
 <20100420124358.GA20675@linux.vnet.ibm.com>
 <20100420153023.GA9351@redhat.com>
 <20100421065948.GA5440@linux.vnet.ibm.com>
 <20100421160515.GA11321@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100421160515.GA11321@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2010-04-21 18:05:15]:

> On 04/21, Srikar Dronamraju wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> [2010-04-20 17:30:23]:
> >
> > > I must have missed something. But I do not see where do we use
> > > uprobe_process->tg_leader. We never read it, apart from
> > > BUG_ON(uproc->tg_leader != tg_leader). No?
> >
> > static int free_uprocess(struct uprobe_process *uproc)
> > {
> > 	....
> > 	put_pid(uproc->tg_leader);
> >         uproc->tg_leader = NULL;
> >
> > }
> 
> Yes, yes, I see it does get/put pid. But where do we actually use
> uproc->tg_leader? Why it is needed at all?

uproc->tg_leader was used to validate looked up uproc belongs to the
process.  It was used to check if the uproc belonged to the process for
which we are currently trying to register/unregister uprobes.

Since we want to share the uproc with process that share the same mm, I
agree that its better off we remove the tg_leader.

> 
> > > Also the declarations don't look nice... Probably I missed something,
> > > but why the code uses "void *" instead of "user_bkpt_xol_area *" for
> > > xol_area everywhere?
> > >
> > > OK, even if "void *" makes sense for uproc->uprobe_process,
>                                          ^^^^^^^^^^^^^^^^^^^^^
> I meant uprobe_process->xol_area
> 
> > why
> > > xol_alloc_area/xol_get_insn_slot/etc do not use "user_bkpt_xol_area *" ?
> > >
> >
> > user_bkpt_xol_area isn't exposed. This provides flexibility in changing
> > the algorithm for more efficient slot allocation. Currently we allocate
> > slots from just one page. Later on we could end-up having to allocate
> > from more than contiguous pages. There was some discussion about
> > allocating slots from TLS.  So there is more than one reason that
> > user_bkpt_xol can change. We could expose the struct and not access the
> > fields directly but that would be hard to enforce.
> 
> Still can't understand... Yes, we shouldn't expose the details, but we
> can just add "struct user_bkpt_xol_area;" into include file.
> 
> OK, this is minor.

Okay, I will add the forward declaration in the include file and update
the function prototypes accordingly.

> 
> > > > If the utask has to be allocated, then uprobes has to search
> > > > for the probepoint again in task context.
> > > > 	I dont think it would be an issue to search for the probepoint a
> > > > second time in the task context.
> > >
> > > Agreed. Although we need the new TIF_ bit for tracehook_notify_resume(),
> > > it can't trust "if (current->utask...)" checks.
> >
> > But do we need a new TIF bit? Can we just reuse the TIF_NOTIFY_RESUME
> > flag that we use now?
> 
> Probably not... But somehow tracehook_notify_resume/uprobe_notify_resume
> should know we hit the bp and we need to allocate utask. Yes,
> tracehook_notify_resume() can always call uprobe_notify_resume()
> unconditionally, and uprobe_notify_resume() can notice the
> "find_probept() && !current->utask" case, but probably it is better to
> make this more explicit. And of course, the new bit should be set along
> with TIF_NOTIFY_RESUME.
> 
> Or. Instead of TIF_ bit, we can use something like
> 
> 	#define UTASK_PLEASE_ALLOCATE_ME ((struct uprobe_task *)1)
> 
> uprobe_bkpt_notifier() sets current->utask = UTASK_PLEASE_ALLOCATE_ME,
> then tracehook_notify_resume/uprobe_notify_resume check this case.
> 
> I dunno, please do what you think right.
> 

Yeah, since tracehook_notify_resume() is in fast path, its worth adding
a new TIF flag.

> 
> OK, the last questions:
> 
> 1. Can't multiple write_opcode()'s race with each other?

All callers of write_opcodes should have taken uproc->mutex. 
If there are other users of write_opcode, we will have to add a way to
synchronize this. 

> 
>    Say, pre_ssout() calls remove_bkpt() lockless. can't it race
>    with register_uprobe() which may write to the same page?

That's a bug, I will fix it. remove_bkpt() clearly says it needs to be
called with uproc->mutex held.

> 
>    And, without uses_xol_strategy() there are more racy callers
>    of write_opcode()... Probably something else.

Okay. 

> 
> 2. Can't write_opcode() conflict with ksm doing replace_page() ?

I dont think so. 
If uprobes runs on hosts, it would be calling replace_page() on text
pages. KSM for now works on anonymous pages. Even the replaced page we
add still belongs to the text VMA.

If uprobes runs on guest, KSM should be taking care of cases where
similar pages are inserted/deleted 

> 
> 3. mprotect(). write_opcode() checks !VM_WRITE. This is correct,
>    otherwise we can race with the user-space writing to the same
>    page.
> 
>    But suppose that the application does mprotect(PROT_WRITE) after
>    register_uprobe() installs the bp, now unregister_uprobe/etc can't
>    restore the original insn?
> 

I still need to verify this. I shall get back to you on this.
However are there applications that mprotect(PROT_WRITE) text pages?


> 4. mremap(). What if the application does mremap() and moves the
>    memory? After that vaddr of user_bkpt/uprobe no longer matches
>    the virtual address of bp. This breaks uprobe_bkpt_notifier(),
>    unregister_uprobe(), etc.
> 
>    Even worse. Say, unregister_uprobe() calls remove_bkpt().
>    mremap()+mmap() can be called after ->read_opcode() verifies vaddr
>    points to bkpt_insn, but before write_opcode() changes the page.
> 

I dont think we handle this case now. I think even munmap of the region
where there are probes inserted also can have the same problem.

Are there ways to handle this. 
I think taking a write lock on mmap_sem instead of the read lock could
handle this problem.

I am copying Mel Gorman and Andrea Arcangeli so that they can provide
their inputs on VM and KSM related issues.

--
Thanks and Regards
Srikar
> 
