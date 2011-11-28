Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1K1PAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:00:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:55661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1K1PAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:00:15 -0500
Message-ID: <1322492384.2921.143.camel@twins>
Subject: Re: [PATCH v7 3.2-rc2 4/30] uprobes: Define hooks for mmap/munmap.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
Date: Mon, 28 Nov 2011 15:59:44 +0100
In-Reply-To: <20111124134742.GH28065@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110723.10512.66282.sendpatchset@srdronam.in.ibm.com>
	 <1322071812.14799.87.camel@twins>
	 <20111124134742.GH28065@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 19:17 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2011-11-23 19:10:12]:
> 
> > On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> > > +                       ret = install_breakpoint(vma->vm_mm, uprobe);
> > > +                       if (ret == -EEXIST) {
> > > +                               atomic_inc(&vma->vm_mm->mm_uprobes_count);
> > > +                               ret = 0;
> > > +                       } 
> > 
> > Aren't you double counting that probe position here? The one that raced
> > you to inserting it will also have incremented that counter, no?
> > 
> 
> No we arent.
> Because register_uprobe can never race with mmap_uprobe and register
> before mmap_uprobe registers .(Once we start mmap_region,
> register_uprobe waits for the read_lock of mmap_sem.)
> 
> And we badly need this for mmap_uprobe case.  Because when we do mremap,
> or vma_adjust(), we do a munmap_uprobe() followed by mmap_uprobe() which
> would have decremented the count but not removed it. So when we do a
> mmap_uprobe, we need to increment the count. 

Ok, so I didn't parse that properly last time around.. but it still
doesn't make sense, why would munmap_uprobe() decrement the count but
not uninstall the probe?

install_breakpoint() returning -EEXIST on two different conditions
doesn't help either.

So what I think you're doing is that you're optimizing the unmap case
since the memory is going to be thrown out fixing up the instruction is
a waste of time, but this leads to the asymmetry observed above. But you
fail to mention this in both the changelog or a comment near that
-EEXIST branch in mmap_uprobe.

Worse, you don't explain how the other -EEXIST (!consumers) thing
interacts here, and I just gave up trying to figure that out since it
made my head hurt.

Also, your whole series of patches is still utter crap, the splitup
doesn't work at all, I need to constantly search back and forth between
patches in order to figure out wtf is happening, and your changelogs
only seem to add confusion if anything at all.

Also, you seem to have stuck a whole bunch of random patches at the end
that fix various things without folding them back in to make the series
saner/smaller.

I've now reverted to simply applying all patches and reading the end
result and using git-blame to figure out what patch something came
from :-(

