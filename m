Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab1KXOOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 09:14:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:42822 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1KXOOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:14:08 -0500
Message-ID: <1322144017.2921.57.camel@twins>
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
Date: Thu, 24 Nov 2011 15:13:37 +0100
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

Still doesn't make any sense. Since you don't increment on success, one
has to assume install_breakpoint() will cause an increment. Therefore,
when we encounter -EEXIST we'll already have accounted for this
mm,inode,offset combination.

But I'll have another look at it, maybe I'm missing something
obvious :-)

> And we badly need this for mmap_uprobe case.  Because when we do mremap,
> or vma_adjust(), we do a munmap_uprobe() followed by mmap_uprobe() which
> would have decremented the count but not removed it. So when we do a
> mmap_uprobe, we need to increment the count. 

Well I see why the count needs to be correct, that's not the issue.
