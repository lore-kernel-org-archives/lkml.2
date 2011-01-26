Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1AZRDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:03:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39451 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab1AZRDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:03:36 -0500
Date: Wed, 26 Jan 2011 22:26:45 +0530
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
Message-ID: <20110126165645.GP19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095817.23751.76989.sendpatchset@localhost6.localdomain6>
 <1295957744.28776.722.camel@laptop>
 <20110126075558.GB19725@linux.vnet.ibm.com>
 <1296036708.28776.1138.camel@laptop>
 <20110126153036.GN19725@linux.vnet.ibm.com>
 <1296056756.28776.1247.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1296056756.28776.1247.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-26 16:45:56]:

> On Wed, 2011-01-26 at 21:00 +0530, Srikar Dronamraju wrote:
> > * Peter Zijlstra <peterz@infradead.org> [2011-01-26 11:11:48]:
> > 
> > > On Wed, 2011-01-26 at 13:25 +0530, Srikar Dronamraju wrote:
> > > > 
> > > > > > +
> > > > > > +               list_add(&mm->uprobes_list, &tmp_list);
> > > > > > +               mm->uprobes_vaddr = vma->vm_start + offset;
> > > > > > +       }
> > > > > > +       spin_unlock(&mapping->i_mmap_lock);
> > > > > 
> > > > > Both this and unregister are racy, what is to say:
> > > > >  - the vma didn't get removed from the mm
> > > > >  - no new matching vma got added
> > > > > 
> > > > 
> > > > register_uprobe, unregister_uprobe, uprobe_mmap are all synchronized by
> > > > uprobes_mutex. So I dont see one unregister_uprobe getting thro when
> > > > another register_uprobe is working with a vma.
> > > > 
> > > > If I am missing something elementary, please explain a bit more.
> > > 
> > > afaict you're not holding the mmap_sem, so userspace can simply unmap
> > > the vma.
> > 
> > When we do the actual insert/remove of the breakpoint we hold the
> > mmap_sem. During the actual insertion/removal, if the vma for the
> > specific inode is not found, we just come out without doing the
> > actual insertion/deletion.
> 
> Right, but then install_uprobe() should:
> 
>  - lookup the vma relating to the address you stored,

We already do this thro get_user_pages in write_opcode().

>  - validate that the vma is indeed a map of the right inode

We can add a check in write_opcode( we need to pass the inode to
write_opcode).

>  - validate that the offset of the probe corresponds with the stored
> address

I am not clear on this. We would have derived the address from the
offset. So is that we check for
 (vaddr == vma->vm_start + uprobe->offset)

> 
> Otherwise you can race with unmap/map and end up installing the probe in
> a random location.
> 
> Also, I think the whole thing goes funny if someone maps the same text
> twice ;-)

I am not sure if we can map the same text twice. If something like
this is possible then we would have 2 addresses for each function.
So how does the linker know which address to jump to out of the 2 or
multiple matching addresses. What would be the usecases for same
text being mapped multiple times and both being executable?

-- 
Thanks and Regards
Srikar
