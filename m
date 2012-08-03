Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2HCBWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 21:22:19 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48573 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2HCBWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 21:22:18 -0400
Date: Fri, 3 Aug 2012 06:50:04 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Ignore unsupported instructions in uprobe_mmap
Message-ID: <20120803012004.GA3565@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120728163157.GA22719@redhat.com>
 <20120731064730.GB5087@linux.vnet.ibm.com>
 <20120731124805.GA485@redhat.com>
 <20120802100515.GC5782@linux.vnet.ibm.com>
 <20120802141757.GA5064@redhat.com>
 <20120802165452.GB4268@linux.vnet.ibm.com>
 <20120802175312.GB11933@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120802175312.GB11933@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080301-7282-0000-0000-00000B990CA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-02 19:53:12]:

> On 08/02, Srikar Dronamraju wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> [2012-08-02 16:17:57]:
> >
> > > Forgot to mention...
> > >
> > > On 08/02, Srikar Dronamraju wrote:
> > > >
> > > > While at it, add a missing put_uprobe() in the path where uprobe_mmap()
> > > > races with uprobe_unregister().
> > > > ...
> > > > @@ -1051,8 +1051,10 @@ int uprobe_mmap(struct vm_area_struct *vma)
> > > >  			if (ret == -EEXIST) {
> > > >  				ret = 0;
> > > >
> > > > -				if (!is_swbp_at_addr(vma->vm_mm, vaddr))
> > > > +				if (!is_swbp_at_addr(vma->vm_mm, vaddr)) {
> > > > +					put_uprobe(uprobe);
> > > >  					continue;
> > > > +				}
> > >
> > > Yes, this part looks correct.
> > >
> > > In fact, I think this is not really correct anyway (wrt counter)
> > > but we are going to kill it.
> > >
> > >
> >
> > Are you expecting the counter to be decreased/increased here?
> 
> uprobes_state.count is very wrong, afaics. I'll try to send the fixes
> "soon", after we solve the pending problems (this one + stepping).
> 
> > This is case where the uprobe_mmap() and uprobe_unregister() raced, and
> > by the time install_breakpoint() was called by uprobe_mmap(), there were
> > no consumers.
> 
> Yes, exactly, and this case doesn't look 100% right too,
> 
> > i.e there are no uprobe->consumers and the underlying
> > instruction is still not a breakpoint instruction.
> 
> Yes, but what if it _IS_ "int3" ?

for int3, install_breakpoint returns -ENOTSUPP as install_breakpoint
does an explicit check if the instruction is breakpoint instruction 
and x86 analyse_insn() also returns -ENOTSUPP.

> 
> Yet another reason to move arch_uprobe_analyze_insn/etc to _register.
> 

I am for moving the stuff to _register that avoids us from looking at
these cases.

-- 
Thanks and Regards

