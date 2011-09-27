Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1I0M43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:56:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:55909 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1I0M42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:56:28 -0400
Subject: Re: [PATCH v5 3.1.0-rc4-tip 18/26]   uprobes: slot allocation.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 27 Sep 2011 14:55:23 +0200
In-Reply-To: <20110920120335.25326.50673.sendpatchset@srdronam.in.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
	 <20110920120335.25326.50673.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317128124.15383.56.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 17:33 +0530, Srikar Dronamraju wrote:
> +static unsigned long xol_take_insn_slot(struct uprobes_xol_area *area)
> +{
> +       unsigned long slot_addr, flags;
> +       int slot_nr;
> +
> +       do {
> +               spin_lock_irqsave(&area->slot_lock, flags);
> +               slot_nr = find_first_zero_bit(area->bitmap, UINSNS_PER_PAGE);
> +               if (slot_nr < UINSNS_PER_PAGE) {
> +                       __set_bit(slot_nr, area->bitmap);
> +                       slot_addr = area->vaddr +
> +                                       (slot_nr * UPROBES_XOL_SLOT_BYTES);
> +                       atomic_inc(&area->slot_count);
> +               }
> +               spin_unlock_irqrestore(&area->slot_lock, flags);
> +               if (slot_nr >= UINSNS_PER_PAGE)
> +                       xol_wait_event(area);
> +
> +       } while (slot_nr >= UINSNS_PER_PAGE);
> +
> +       return slot_addr;
> +}

> +static void xol_free_insn_slot(struct task_struct *tsk)
> +{
> +       struct uprobes_xol_area *area;
> +       unsigned long vma_end;
> +       unsigned long slot_addr;
> +
> +       if (!tsk->mm || !tsk->mm->uprobes_xol_area || !tsk->utask)
> +               return;
> +
> +       slot_addr = tsk->utask->xol_vaddr;
> +
> +       if (unlikely(!slot_addr || IS_ERR_VALUE(slot_addr)))
> +               return;
> +
> +       area = tsk->mm->uprobes_xol_area;
> +       vma_end = area->vaddr + PAGE_SIZE;
> +       if (area->vaddr <= slot_addr && slot_addr < vma_end) {
> +               int slot_nr;
> +               unsigned long offset = slot_addr - area->vaddr;
> +               unsigned long flags;
> +
> +               slot_nr = offset / UPROBES_XOL_SLOT_BYTES;
> +               if (slot_nr >= UINSNS_PER_PAGE)
> +                       return;
> +
> +               spin_lock_irqsave(&area->slot_lock, flags);
> +               __clear_bit(slot_nr, area->bitmap);
> +               spin_unlock_irqrestore(&area->slot_lock, flags);
> +               atomic_dec(&area->slot_count);
> +               if (waitqueue_active(&area->wq))
> +                       wake_up(&area->wq);
> +               tsk->utask->xol_vaddr = 0;
> +       }
> +} 

So if you want to keep that slot_lock, you might as well make
->slot_count a normal integer.
