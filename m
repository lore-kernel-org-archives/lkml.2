Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab1K3MMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 07:12:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34928 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab1K3MMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 07:12:34 -0500
Message-ID: <1322655112.2921.267.camel@twins>
Subject: Re: [PATCH 2/5] uprobes: introduce uprobe_switch_to()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        Stephen Wilson <wilsons@start.ca>
Date: Wed, 30 Nov 2011 13:11:52 +0100
In-Reply-To: <20111129171822.GA28234@redhat.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111128190614.GA4602@redhat.com> <20111128190655.GC4602@redhat.com>
	 <1322510018.2921.161.camel@twins> <20111129171822.GA28234@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 18:18 +0100, Oleg Nesterov wrote:
> On 11/28, Peter Zijlstra wrote:
> >
> > On Mon, 2011-11-28 at 20:06 +0100, Oleg Nesterov wrote:
> > > +void uprobe_switch_to(struct task_struct *curr)
> > > +{
> > > +       struct uprobe_task *utask = curr->utask;
> > > +       struct pt_regs *regs = task_pt_regs(curr);
> > > +
> > > +       if (!utask || utask->state != UTASK_SSTEP)
> > > +               return;
> > > +
> > > +       if (!(regs->flags & X86_EFLAGS_TF))
> > > +               return;
> > > +
> > > +       set_xol_ip(regs);
> > > +}
> >
> > > void __weak set_xol_ip(struct pt_regs *regs)
> > >  {
> > > +       int cpu = smp_processor_id();
> > > +       struct uprobe_task *utask = current->utask;
> > > +       struct uprobe *uprobe = utask->active_uprobe;
> > > +
> > > +       memcpy(uprobe_xol_slots[cpu], uprobe->insn, MAX_UINSN_BYTES);
> > > +
> > > +       utask->xol_vaddr = fix_to_virt(UPROBE_XOL_FIRST_PAGE)
> > > +                               + UPROBES_XOL_SLOT_BYTES * cpu;
> > > +       set_instruction_pointer(regs, utask->xol_vaddr);
> > >  }
> >
> > So uprobe_switch_to() will always reset the IP to the start of the slot?
> > That sounds wrong, things like the RIP relative stuff needs multiple
> > instructions.
> 
> Hmm. Could you explain? Especially the "multiple instructions" part.
> 
> In any case we should reset the IP to the start of the slot.
> 
> But yes, I'm afraid this is too simple. Before this patches pre_xol()
> is called when we already know ->xol_vaddr. But afaics x86 doesn't use
> this info (post_xol() does). So this looks equally correct or wrong.
> 
> But perhaps we need another arch-dependent hook which takes ->xol_vaddr
> into account instead of simple memcpy(), to handle the RIP relative
> case.
> 
> Or I misunderstood?

Suppose you need multiple instructions to replace the one you patched
out, for example because the instruction was RIP relative (the effect
relied on the IP the instruction is at, eg. short jumps instead of
absolute jumps).

One way to translate these instructions is something like

  push eax
  mov eax, $previous_ip
  $ins eax+offset
  pop eax

Also, the thing Srikar mentioned is boosted probes, in that case you
forgo the whole single step thing and rewrite the probe as:

  $ins
  jmp $next_insn

Now in the former case you still single step so the context switch hook
can function as proposed (triggered off of TIF_SINGLESTEP). However if
you get preempted after the mov you want to continue with the $ins, not
restart at push. So uprobe_switch_to() will have to preserve the
relative offset within the slot.

On the second example there's no singlestepping left, so we need to
create a new TIF flag, when you first set up the probe you toggle that
flag and on the first context switch where the IP is outside of the slot
you clear it. But still you need to maintain relative offset within the
slot when you move it around.


