Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab1LAFmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 00:42:24 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43856 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1LAFmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 00:42:23 -0500
Date: Thu, 1 Dec 2011 11:10:18 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>, tulasidhard@gmail.com
Subject: Re: [PATCH v7 3.2-rc2 4/30] uprobes: Define hooks for mmap/munmap.
Message-ID: <20111201054018.GC18380@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111118110723.10512.66282.sendpatchset@srdronam.in.ibm.com>
 <1322071812.14799.87.camel@twins>
 <20111124134742.GH28065@linux.vnet.ibm.com>
 <1322492384.2921.143.camel@twins>
 <20111129083322.GD13445@linux.vnet.ibm.com>
 <1322567326.2921.226.camel@twins>
 <20111129162237.GA18380@linux.vnet.ibm.com>
 <1322655933.2921.271.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322655933.2921.271.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11120105-6078-0000-0000-0000051C0E48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The rules that I am using are: 
> > 
> > mmap_uprobe() increments the count if 
> >         - it successfully adds a breakpoint.
> >         - it not add a breakpoint, but sees that there is a underlying
> >           breakpoint (via a read_opcode call).
> > 
> > munmap_uprobe() decrements the count if 
> >         - it sees a underlying breakpoint,  (via  a read_opcode call)
> >         - Subsequent unregister_uprobe wouldnt find the breakpoint
> >           unless a mmap_uprobe kicks in, since the old vma would be
> >           dropped just after munmap_uprobe.
> > 
> > register_uprobe increments the count if:
> >         - it successfully adds a breakpoint.
> > 
> > unregister_uprobe decrements the count if:
> >         - it sees a underlying breakpoint and removes successfully. 
> >                         (via a read_opcode call)
> >         - Subsequent munmap_uprobe wouldnt find the breakpoint
> >           since there is no underlying breakpoint after the
> >           breakpoint removal. 
> 
> The problem I'm having is that such stuff isn't included in the patch
> set.
> 
> We've got both comments in the C language and Changelog in our patch
> system, yet you consistently fail to use either to convey useful
> information on non-trivial bits like this.
> 

Agree, I will put this as part of comments.

> This leaves the reviewer wondering if you've actually considered stuff
> properly, then me actually finding bugs in there does of course
> undermine that even further.
> 
> What I really would like is for this patch set not to have such subtle
> stuff at all, esp. at first. Once its in and its been used a bit we can
> start optimizing and add subtle crap like this.

We actually started the discussion of why we increment the count in
mmap_uprobe() in EEXIST case (and read_opcode()). It exists for two
reasons.
	- To handle fork case (that I wrote in another mail).
	- To handle mremap.(the case where we are discussing now)

I would contend that removing the breakpoint in munmap doesnt amount to
optimization. Since the start of unmap(), there cannot be another
remove_breakpoint called for the vma,vaddr tuple, until the vma is
cleaned up, or the subsequent mmap() is done. So the case of accounting
for an already decremented count should never occur.

I was following the general convention being used within the kernel to not
bother about the area that we are going to unmap. For example: If a ptraced
area were to be unmapped or remapped, I dont see the breakpoint being
removed and added back. Also if a ptrace process is exitting, we dont go
about removing the installed breakpoints.

Also we would still need the check for EEXIST and read_opcode for handling
the fork() case. So even if we add extra line to remove the actual
breakpoint in munmap, It doesnt make the code any more simpler.

-- 
Thanks and Regards
Srikar

