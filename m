Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1K1TyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:54:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34960 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab1K1TyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:54:13 -0500
Message-ID: <1322510018.2921.161.camel@twins>
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
Date: Mon, 28 Nov 2011 20:53:38 +0100
In-Reply-To: <20111128190655.GC4602@redhat.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111128190614.GA4602@redhat.com> <20111128190655.GC4602@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 20:06 +0100, Oleg Nesterov wrote:
> +void uprobe_switch_to(struct task_struct *curr)
> +{
> +       struct uprobe_task *utask = curr->utask;
> +       struct pt_regs *regs = task_pt_regs(curr);
> +
> +       if (!utask || utask->state != UTASK_SSTEP)
> +               return;
> +
> +       if (!(regs->flags & X86_EFLAGS_TF))
> +               return;
> +
> +       set_xol_ip(regs);
> +} 

> void __weak set_xol_ip(struct pt_regs *regs)
>  {
> +       int cpu = smp_processor_id();
> +       struct uprobe_task *utask = current->utask;
> +       struct uprobe *uprobe = utask->active_uprobe;
> +
> +       memcpy(uprobe_xol_slots[cpu], uprobe->insn, MAX_UINSN_BYTES);
> +
> +       utask->xol_vaddr = fix_to_virt(UPROBE_XOL_FIRST_PAGE)
> +                               + UPROBES_XOL_SLOT_BYTES * cpu;
> +       set_instruction_pointer(regs, utask->xol_vaddr);
>  }

So uprobe_switch_to() will always reset the IP to the start of the slot?
That sounds wrong, things like the RIP relative stuff needs multiple
instructions.


