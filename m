Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1FPLxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:53:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34089 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab1FPLxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:53:11 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 13/22] 13: uprobes: Handing int3 and
 singlestep exception.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20110607130051.28590.68088.sendpatchset@localhost6.localdomain6>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607130051.28590.68088.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Jun 2011 13:52:21 +0200
Message-ID: <1308225141.13240.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 18:30 +0530, Srikar Dronamraju wrote:
> +void uprobe_notify_resume(struct pt_regs *regs)
> +{
> +       struct vm_area_struct *vma;
> +       struct uprobe_task *utask;
> +       struct mm_struct *mm;
> +       struct uprobe *u = NULL;
> +       unsigned long probept;
> +
> +       utask = current->utask;
> +       mm = current->mm;
> +       if (!utask || utask->state == UTASK_BP_HIT) {
> +               probept = get_uprobe_bkpt_addr(regs);
> +               down_read(&mm->mmap_sem);
> +               vma = find_vma(mm, probept);
> +               if (vma && valid_vma(vma))
> +                       u = find_uprobe(vma->vm_file->f_mapping->host,
> +                                       probept - vma->vm_start +
> +                                       (vma->vm_pgoff << PAGE_SHIFT));
> +               up_read(&mm->mmap_sem);
> +               if (!u)
> +                       goto cleanup_ret;
> +               if (!utask) {
> +                       utask = add_utask();
> +                       if (!utask)
> +                               goto cleanup_ret;

So if we fail to allocate task state,..

> +               }
> +               /* TODO Start queueing signals. */
> +               utask->active_uprobe = u;
> +               handler_chain(u, regs);
> +               utask->state = UTASK_SSTEP;
> +               if (!pre_ssout(u, regs, probept))
> +                       user_enable_single_step(current);
> +               else
> +                       goto cleanup_ret;
> +       } else if (utask->state == UTASK_SSTEP) {
> +               u = utask->active_uprobe;
> +               if (sstep_complete(u, regs)) {
> +                       put_uprobe(u);
> +                       utask->active_uprobe = NULL;
> +                       utask->state = UTASK_RUNNING;
> +                       user_disable_single_step(current);
> +                       xol_free_insn_slot(current);
> +
> +                       /* TODO Stop queueing signals. */
> +               }
> +       }
> +       return;
> +
> +cleanup_ret:
> +       if (u) {
> +               down_read(&mm->mmap_sem);
> +               if (!set_orig_insn(current, u, probept, true))

we try to undo the probe? That doesn't make any sense. I thought you
meant to return to userspace, let it re-take the trap and try again
until you do manage to allocate the user resource.

This behaviour makes probes totally unreliable under memory pressure. 

> +                       atomic_dec(&mm->uprobes_count);
> +               up_read(&mm->mmap_sem);
> +               put_uprobe(u);
> +       } else {
> +       /*TODO Return SIGTRAP signal */
> +       }
> +       if (utask) {
> +               utask->active_uprobe = NULL;
> +               utask->state = UTASK_RUNNING;
> +       }
> +       set_instruction_pointer(regs, probept);
> +} 

Also, there's a scary amount of TODO in there...
