Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0ELOYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:24:46 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37231 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab0ELOYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:24:45 -0400
Date: Wed, 12 May 2010 19:54:37 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20100512142437.GO7426@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100415093506.GA2064@linux.vnet.ibm.com>
 <20100419193139.GA24080@redhat.com>
 <20100420124358.GA20675@linux.vnet.ibm.com>
 <20100420153023.GA9351@redhat.com>
 <20100421065948.GA5440@linux.vnet.ibm.com>
 <20100421160515.GA11321@redhat.com>
 <20100422133154.GA10776@linux.vnet.ibm.com>
 <1273610603.1810.101.camel@laptop>
 <20100512104138.GM7426@linux.vnet.ibm.com>
 <1273662751.1626.35.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1273662751.1626.35.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-05-12 13:12:31]:

> On Wed, 2010-05-12 at 16:11 +0530, Srikar Dronamraju wrote:
> > > We can't hold mmap_sem (for either read or write -- read would be
> > > sufficient to serialize against mmap/mremap/munmap) from atomic uprobe
> > > context, what we can do is validate that there is a INT3 on that
> > > particular address, a mremap/munmap/munmap+mmap will either end not
> > > having a pte entry for the address, or not have the INT3.
> > 
> > Did you mean "We can hold mmap_sem?" Else I am not sure if we can
> > traverse the vma. Infact alloc_page_vma() needs mmap_sem to be acquired.
> > Please clarify? 
> 
> OK, so maybe I misunderstood, this is from the INT3 trap handler, right?


If I am right, the initial comment was both from the unregister_uprobe()
-> write_opcode() context  and uprobe_bkpt_notifier context.

[ snipping relevant part of Oleg's mail from where the conversation started ]
---------------------------------------------------------------------
> > 4. mremap(). What if the application does mremap() and moves the                                                                      
> >    memory? After that vaddr of user_bkpt/uprobe no longer matches                                                                     
> >    the virtual address of bp. This breaks uprobe_bkpt_notifier(),                                                                     
> >    unregister_uprobe(), etc.                                                                                                          
> >                                                                                                                                       
> >    Even worse. Say, unregister_uprobe() calls remove_bkpt().                                                                          
> >    mremap()+mmap() can be called after ->read_opcode() verifies
> >    vaddr                                                                 
> >    points to bkpt_insn, but before write_opcode() changes the page.     
---------------------------------------------------------------------

But yes, if the mmap/mremap/munmap can happen between validating the
int3 and removal of the breakpoint in the unregister_uprobe path, then
it can as well happen between the breakpoint hit and the time uprobes
does the fixups to continue execution after running the handler and
single-stepping. 

I agree with you that we shouldnt bother about mmap/mremap/munmap of the
executable code. Probably we could document the same.

> 
> We can _not_ take a sleeping lock from trap context. Why would you want
> the vma anyway?

Yes, we dont look at the vma in trap context at all. If we need to allocate a
slot in the xol_vma then we set the TIF_UPROBE do the stuff in task
context.

--
Thanks and Regards
Srikar
> 
