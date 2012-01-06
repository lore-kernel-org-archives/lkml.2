Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2AFGVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:21:30 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51862 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2AFGV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:21:28 -0500
Date: Fri, 6 Jan 2012 11:44:07 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v8 3.2.0-rc5 1/9] uprobes: Install and remove
 breakpoints.
Message-ID: <20120106061407.GC14946@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111216122756.2085.95791.sendpatchset@srdronam.in.ibm.com>
 <20111216122808.2085.76986.sendpatchset@srdronam.in.ibm.com>
 <1325695788.2697.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1325695788.2697.3.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12010606-5518-0000-0000-000001602F46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-01-04 17:49:48]:

> On Fri, 2011-12-16 at 17:58 +0530, Srikar Dronamraju wrote:
> > +static void __unregister_uprobe(struct uprobe *uprobe)
> > +{
> > +       if (!register_for_each_vma(uprobe, false))
> > +               delete_uprobe(uprobe);
> > +
> > +       /* TODO : cant unregister? schedule a worker thread */
> > +} 
> 
> I was about to suggest we merge it, but we really can't with a hole that
> size..
> 

On failure of unregister due to low memory condition:
	- uprobe is left in the rbtree.  So subsequent probe hits can
	  still refer the nodes.

	- UPROBES_RUN_HANDLER flag still gets reset unconditionally. So
	  handlers will not run on subsequent probe hits that correspond
	  to this uprobe.

	- consumers for the uprobe is NULL, so mmap_uprobe will not
	  insert new breakpoints which correspond to this uprobe until
	  or unless another consumer gets added for the same probe.

	- If a new consumer gets added for this probe, we reuse the
	  uprobe struct.
	
So in the highly unlikely case of uprobes not being able to unregister
cleanly because of low memory conditions, existing tasks that have this
probe in their address space will incur an extra cost of handling
exceptions.

However scheduling a kworker thread (or removing the underlying
breakpoint if we detect the probe doesnt have UPROBES_RUN_HANDLER flag
set) will reduce this overhead. 

Since we are looking at an extra overhead and no change in behaviour,
should this be a reason to stop merging this feature?

-- 
Thanks and Regards
Srikar

