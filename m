Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab2JFJpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 05:45:31 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47349 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab2JFJp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 05:45:29 -0400
Date: Sat, 6 Oct 2012 15:15:28 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes: Introduce uprobe_copy_insn()
Message-ID: <20121006094528.GC9145@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120930194119.GA11278@redhat.com>
 <20120930194217.GA11340@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120930194217.GA11340@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100609-2876-0000-0000-000000C6A81D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-30 21:42:17]:

> Preparation. Extract the copy_insn/arch_uprobe_analyze_insn code
> from install_breakpoint() into the new helper, uprobe_copy_insn().
> 
> And move uprobe->flags defines from uprobes.h to uprobes.c, nobody
> else can use them anyway.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  include/linux/uprobes.h |   10 --------
>  kernel/events/uprobes.c |   60 ++++++++++++++++++++++++++++++++---------------
>  2 files changed, 41 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index 18d839d..2459457 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -35,16 +35,6 @@ struct inode;
>  # include <asm/uprobes.h>
>  #endif
> 
> -/* flags that denote/change uprobes behaviour */
> -
> -/* Have a copy of original instruction */
> -#define UPROBE_COPY_INSN	0x1
> -
> -/* Dont run handlers when first register/ last unregister in progress*/
> -#define UPROBE_RUN_HANDLER	0x2
> -/* Can skip singlestep */
> -#define UPROBE_SKIP_SSTEP	0x4
> -
>  struct uprobe_consumer {
>  	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
>  	/*
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index a81080f..5c0c1b0 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -78,6 +78,13 @@ static struct mutex uprobes_mmap_mutex[UPROBES_HASH_SZ];
>   */
>  static atomic_t uprobe_events = ATOMIC_INIT(0);
> 
> +/* Have a copy of original instruction */
> +#define UPROBE_COPY_INSN	0x1
> +/* Dont run handlers when first register/ last unregister in progress*/
> +#define UPROBE_RUN_HANDLER	0x2
> +/* Can skip singlestep */
> +#define UPROBE_SKIP_SSTEP	0x4
> +
>  struct uprobe {
>  	struct rb_node		rb_node;	/* node in the rb tree */
>  	atomic_t		ref;
> @@ -563,6 +570,37 @@ static int copy_insn(struct uprobe *uprobe, struct file *filp)
>  	return __copy_insn(mapping, filp, uprobe->arch.insn, bytes, uprobe->offset);
>  }
> 
> +static int uprobe_copy_insn(struct uprobe *uprobe, struct file *file,
> +				struct mm_struct *mm, unsigned long vaddr)
> +{
> +	int ret = 0;
> +
> +	if (uprobe->flags & UPROBE_COPY_INSN)
> +		return ret;
> +
> +	ret = copy_insn(uprobe, file);
> +	if (ret)
> +		goto out;
> +
> +	ret = -ENOTSUPP;
> +	if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
> +		goto out;
> +
> +	ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
> +	if (ret)
> +		goto out;
> +
> +	/* write_opcode() assumes we don't cross page boundary */
> +	BUG_ON((uprobe->offset & ~PAGE_MASK) +
> +			UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
> +
> +	smp_wmb(); /* pairs with rmb() in find_active_uprobe() */
> +	uprobe->flags |= UPROBE_COPY_INSN;
> +	ret = 0;
> + out:
> +	return ret;
> +}
> +

2 nits: 
 why do we need to reset ret before out label? I think its redudant.
 arch_uprobe_analyze_insn() should have set it to 0 already. No?

blank line above out:

Currently only extern functions start with uprobe_ but we already have
copy_insn, and __copy_insn, So can think of any names for
uprobe_copy_insn. Not sure test_and_copy_insn() is a good alternative.

-- 
thanks and regards
Srikar

