Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab1FPMMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:12:49 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38073 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab1FPMMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:12:46 -0400
Date: Thu, 16 Jun 2011 17:34:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 13/22] 13: uprobes: Handing int3 and
 singlestep exception.
Message-ID: <20110616120442.GA4093@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607130051.28590.68088.sendpatchset@localhost6.localdomain6>
 <1308225141.13240.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1308225141.13240.25.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +cleanup_ret:
> > +       if (u) {
> > +               down_read(&mm->mmap_sem);
> > +               if (!set_orig_insn(current, u, probept, true))
> 
> we try to undo the probe? That doesn't make any sense. I thought you
> meant to return to userspace, let it re-take the trap and try again
> until you do manage to allocate the user resource.

I meant removing the probe itself
https://lkml.org/lkml/2011/4/21/279

We could try reseting and retrying the trap. Just that we might end up
looping under memory pressure.

> 
> This behaviour makes probes totally unreliable under memory pressure. 

Under memory pressure we could be unreliable.

> 
> > +                       atomic_dec(&mm->uprobes_count);
> > +               up_read(&mm->mmap_sem);
> > +               put_uprobe(u);
> > +       } else {
> > +       /*TODO Return SIGTRAP signal */
> > +       }
> > +       if (utask) {
> > +               utask->active_uprobe = NULL;
> > +               utask->state = UTASK_RUNNING;
> > +       }
> > +       set_instruction_pointer(regs, probept);
> > +} 
> 
> Also, there's a scary amount of TODO in there...

All of those deal with delaying the signals. I am working on it at this
moment. 

-- 
Thanks and Regards
Srikar
