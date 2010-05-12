Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0ELKls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:41:48 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60785 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab0ELKlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:41:47 -0400
Date: Wed, 12 May 2010 16:11:38 +0530
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
Message-ID: <20100512104138.GM7426@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6>
 <20100413183537.GA17538@redhat.com>
 <20100415093506.GA2064@linux.vnet.ibm.com>
 <20100419193139.GA24080@redhat.com>
 <20100420124358.GA20675@linux.vnet.ibm.com>
 <20100420153023.GA9351@redhat.com>
 <20100421065948.GA5440@linux.vnet.ibm.com>
 <20100421160515.GA11321@redhat.com>
 <20100422133154.GA10776@linux.vnet.ibm.com>
 <1273610603.1810.101.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1273610603.1810.101.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-05-11 22:43:23]:

> On Thu, 2010-04-22 at 19:01 +0530, Srikar Dronamraju wrote:
> > * Oleg Nesterov <oleg@redhat.com> [2010-04-21 18:05:15]:
> 
> > > 4. mremap(). What if the application does mremap() and moves the
> > >    memory? After that vaddr of user_bkpt/uprobe no longer matches
> > >    the virtual address of bp. This breaks uprobe_bkpt_notifier(),
> > >    unregister_uprobe(), etc.
> > > 
> > >    Even worse. Say, unregister_uprobe() calls remove_bkpt().
> > >    mremap()+mmap() can be called after ->read_opcode() verifies vaddr
> > >    points to bkpt_insn, but before write_opcode() changes the page.
> > > 
> > 
> > I dont think we handle this case now. I think even munmap of the region
> > where there are probes inserted also can have the same problem.
> > 
> > Are there ways to handle this. 
> > I think taking a write lock on mmap_sem instead of the read lock could
> > handle this problem.
> > 
> > I am copying Mel Gorman and Andrea Arcangeli so that they can provide
> > their inputs on VM and KSM related issues.
> 
> KSM only does anonymous pages, and I thought uprobes was limited to
> MAP_PRIVATE|PROT_EXEC file maps.
> 
> We can't hold mmap_sem (for either read or write -- read would be
> sufficient to serialize against mmap/mremap/munmap) from atomic uprobe
> context, what we can do is validate that there is a INT3 on that
> particular address, a mremap/munmap/munmap+mmap will either end not
> having a pte entry for the address, or not have the INT3.

Did you mean "We can hold mmap_sem?" Else I am not sure if we can
traverse the vma. Infact alloc_page_vma() needs mmap_sem to be acquired.
Please clarify?

> 
> That said, you shouldn't be executing code on maps you're changing, much
> fun can happen if you try, so I don't think we should expend too much
> effort as long as the race will only result in the app crashing and not
> the kernel.
> 

Okay.

--
Thanks and Regards
Srikar
