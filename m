Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1AYN4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:56:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:46106 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1AYN4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:56:17 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 12/20] 12: uprobes: get the
 breakpoint address.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101216095936.23751.62727.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095936.23751.62727.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 14:56:21 +0100
Message-ID: <1295963781.28776.1060.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:29 +0530, Srikar Dronamraju wrote:
> On a breakpoint hit, perform a architecture specific calculation to
> return the address where the breakpoint was hit.

And yet all the code added is generic ;-)

> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
> ---
>  include/linux/uprobes.h |    5 +++++
>  kernel/uprobes.c        |   11 +++++++++++
>  2 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index a631c42..ee12b2e 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -154,6 +154,7 @@ extern void uprobe_free_utask(struct task_struct *tsk);
>  
>  struct vm_area_struct;
>  extern void uprobe_mmap(struct vm_area_struct *vma);
> +extern unsigned long uprobes_get_bkpt_addr(struct pt_regs *regs);
>  extern void uprobe_dup_mmap(struct mm_struct *old_mm, struct mm_struct *mm);
>  extern void uprobes_free_xol_area(struct mm_struct *mm);
>  #else /* CONFIG_UPROBES is not defined */
> @@ -173,5 +174,9 @@ static inline void uprobe_dup_mmap(struct mm_struct *old_mm,
>  static inline void uprobe_free_utask(struct task_struct *tsk) {}
>  static inline void uprobe_mmap(struct vm_area_struct *vma) { }
>  static inline void uprobes_free_xol_area(struct mm_struct *mm) {}
> +static inline unsigned long uprobes_get_bkpt_addr(struct pt_regs *regs)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_UPROBES */
>  #endif	/* _LINUX_UPROBES_H */
> diff --git a/kernel/uprobes.c b/kernel/uprobes.c
> index 09e36f6..f486c4f 100644
> --- a/kernel/uprobes.c
> +++ b/kernel/uprobes.c
> @@ -976,6 +976,17 @@ static void xol_free_insn_slot(struct task_struct *tsk, unsigned long slot_addr)
>  						__func__, slot_addr);
>  }
>  
> +/**
> + * uprobes_get_bkpt_addr - compute address of bkpt given post-bkpt regs
> + * @regs: Reflects the saved state of the task after it has hit a breakpoint
> + * instruction.
> + * Return the address of the breakpoint instruction.
> + */
> +unsigned long uprobes_get_bkpt_addr(struct pt_regs *regs)
> +{
> +	return instruction_pointer(regs) - UPROBES_BKPT_INSN_SIZE;
> +}
> +
>  /*
>   * Called with no locks held.
>   * Called in context of a exiting or a exec-ing thread.


