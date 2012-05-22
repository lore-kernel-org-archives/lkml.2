Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2EVPXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:23:01 -0400
Received: from mail.openrapids.net ([64.15.138.104]:54443 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758847Ab2EVPW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:22:59 -0400
Date: Tue, 22 May 2012 11:22:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: NMI vs #PF clash
Message-ID: <20120522152255.GB25697@Krystal>
References: <4FBB8C40.6080304@redhat.com> <1337693441.13348.36.camel@gandalf.stny.rr.com> <4FBB986F.5030306@redhat.com> <1337695780.13348.41.camel@gandalf.stny.rr.com> <4FBBA094.3090703@redhat.com> <1337696825.13348.44.camel@gandalf.stny.rr.com> <4FBBA4A2.2070501@redhat.com> <1337698229.13348.46.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337698229.13348.46.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2012-05-22 at 17:37 +0300, Avi Kivity wrote:
> > > 
> > > 
> > > Is reading it fast? Then we could do a two reads and only write when
> > > needed.
> > 
> > The upside is 70 cycles on one machine, see d3edefc0035669.
> 
> Thanks
> 
> > 
> > 
> > > 
> > > Something like this pseudo assembly
> > >  
> > > 	mov cr2, rax
> > > 	push rax
> > > 
> > > 	call do_nmi
> > > 
> > > 	pop rax
> > > 	mov cr2, rbx
> > > 	cmp rax, rbx
> > > 	be skip
> > > 	mov rax, cr2
> > > skip:
> > > 
> > 
> > 
> > Yes, provided no exceptions can happen at those points.
> 
> Yes, exceptions can only happen in the do_nmi area. There should not be
> any breakpoints or page faults in the assembly code of the NMI handler.
> 
> Now another NMI may come in at any point here, but it will detect that
> it is nested and return without doing anything (but telling this NMI to
> repeat itself).

That should take care of cr2. Those are faraway memories, but I think we
should be careful about pdg_offset too. If we look at x86-64
vmalloc_fault(), we notice that it uses the current task struct:

        WARN_ON_ONCE(in_nmi()); <--- we should take that as a hint ;)

        /*
         * Copy kernel mappings over when needed. This can also
         * happen within a race in page table update. In the later
         * case just flush:
         */
        pgd = pgd_offset(current->active_mm, address);

x86-32 does not have this problem, since it reads the cr3 register to
get the pgd_addr.

x86-64 using the current task can be an issue if the NMI nests over the
scheduler execution.

A few years ago, I posted this patch
http://www.gossamer-threads.com/lists/linux/kernel/1249694?do=post_view_threaded
that tried to fix this by reading cr3 on x86_64. However, after reports
that it caused some x86_64 machines to fail to boot, I removed this
patch from the LTTng patchset. So there was certainly something I missed
back then.

Just food for thoughts,

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
