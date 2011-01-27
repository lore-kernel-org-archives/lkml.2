Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1A0KIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:08:41 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41976 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab1A0KIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:08:40 -0500
Date: Thu, 27 Jan 2011 15:31:57 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 5/20]  5: Uprobes:
 register/unregister probes.
Message-ID: <20110127100157.GS19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095817.23751.76989.sendpatchset@localhost6.localdomain6>
 <1295957744.28776.722.camel@laptop>
 <20110126075558.GB19725@linux.vnet.ibm.com>
 <1296036708.28776.1138.camel@laptop>
 <20110126153036.GN19725@linux.vnet.ibm.com>
 <1296056756.28776.1247.camel@laptop>
 <20110126165645.GP19725@linux.vnet.ibm.com>
 <1296061949.28776.1343.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1296061949.28776.1343.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-26 18:12:29]:

> On Wed, 2011-01-26 at 22:26 +0530, Srikar Dronamraju wrote:
> 
> > >  - lookup the vma relating to the address you stored,
> > 
> > We already do this thro get_user_pages in write_opcode().
> 
> Ah, I didn't read that far..
> 
> > >  - validate that the vma is indeed a map of the right inode
> > 
> > We can add a check in write_opcode( we need to pass the inode to
> > write_opcode).
> 
> sure..
> 
> > >  - validate that the offset of the probe corresponds with the stored
> > > address
> > 
> > I am not clear on this. We would have derived the address from the
> > offset. So is that we check for
> >  (vaddr == vma->vm_start + uprobe->offset)
> 
> Sure, but the vma might have changed since you computed the offset -)

If the vma has changed then it would fail the 2nd validation i.e vma
corresponds to the uprobe inode right. If the vma was unmapped and
mapped back at the same place, then I guess we are okay to probe.

> 
> > > 
> > > Otherwise you can race with unmap/map and end up installing the probe in
> > > a random location.
> > > 
> > > Also, I think the whole thing goes funny if someone maps the same text
> > > twice ;-)
> > 
> > I am not sure if we can map the same text twice. If something like
> > this is possible then we would have 2 addresses for each function.
> > So how does the linker know which address to jump to out of the 2 or
> > multiple matching addresses. What would be the usecases for same
> > text being mapped multiple times and both being executable?
> 
> You can, if only to wreck your thing, you can call mmap() as often as
> you like (until your virtual memory space runs out) and get many many
> mapping of the same file.
> 
> It doesn't need to make sense to the linker, all it needs to do is
> confuse your code ;-)

Currently if there are multiple mappings of the same executable
code, only one mapped area would have the breakpoint inserted.

If the code were to execute from some other mapping, then it would
work as if there are no probes.  However if the code from the
mapping that had the breakpoint executes then we would see the
probes.

If we want to insert breakpoints in each of the maps then we
would have to extend mm->uprobes_vaddr.

Do you have any other ideas to tackle this?
Infact do you think we should be handling this case?

-- 
Thanks and Regards
Srikar
