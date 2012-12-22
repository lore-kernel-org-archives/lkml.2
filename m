Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab2LVQCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 11:02:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab2LVQCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 11:02:06 -0500
Date: Sat, 22 Dec 2012 17:02:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>,
        Anithra P Janakiraman <anithra@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/6] uretprobes/x86: hijack return address
Message-ID: <20121222160212.GA18082@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com> <1356088596-17858-2-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356088596-17858-2-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Anton Arapov wrote:
>
> +extern unsigned long
> +arch_uretprobe_hijack_return_addr(unsigned long rp_trampoline_vaddr, struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask = current->utask;
> +	int rasize, ncopied;
> +	unsigned long orig_return_vaddr = 0; /* clear high bits for 32-bit apps */
> +
> +	if (is_ia32_task())
> +		rasize = 4;
> +	else
> +		rasize = 8;
> +
> +	ncopied = copy_from_user(&orig_return_vaddr, (void __user *)regs->sp, rasize);
> +	if (unlikely(ncopied))
> +		return -EFAULT;

Hmm. The caller (added by 3/6) does

	ri->orig_return_vaddr = arch_uretprobe_hijack_return_addr(...);
	if (likely(ri->orig_return_vaddr)) {


> +	ncopied = copy_to_user((void __user *)regs->sp, &rp_trampoline_vaddr, rasize);
> +	if (unlikely(ncopied)) {
> +		if (ncopied != rasize) {
> +			printk(KERN_ERR "uretprobe: return address clobbered: "
> +					"pid=%d, %%sp=%#lx, %%ip=%#lx\n",
> +					current->pid, regs->sp, regs->ip);

OK... perhaps we could try to write rasize - ncopied bytes first, but
this is minor.

> +			utask->doomed = true;

But this looks strange. We set ->doomed = true, but the task continues to run.
I think in this case we should send SIGTRAP right now. We should not wait until
handle_swbp() notices this flag (which btw can never happen). And this also
means ->doomed should die.

> +		return -EFAULT;

Again, NULL or fix the caller.

> + * On x86_32, if a function returns a struct or union, the return
> + * value is copied into an area created by the caller. The address
> + * of this area is passed on the stack as a "hidden" first argument.
> + * When such a function returns, it uses a "ret $4" instruction to pop
> + * not only the return address but also the hidden arg.  To accommodate
> + * such functions, we add 4 bytes of slop when predicting the return
> + * address. See PR #10078.
                   ^^^^^^^^^
I'd wish I knew what this "PR" means ;)


> +#define STRUCT_RETURN_SLOP 4
> +
> +extern unsigned long
> +arch_uretprobe_predict_sp_at_return(struct pt_regs *regs, struct task_struct *tsk)
> +{
> +	if (test_tsk_thread_flag(tsk, TIF_IA32))
> +		return (unsigned long) (regs->sp + 4 + STRUCT_RETURN_SLOP);

Somehow I can't understand the logic behind arch_uretprobe_predict_sp_at_return()
at all... I'll try more. but tsk is always current, I see no point to pass the
argument.

> @@ -60,6 +63,12 @@ struct uprobe_task {
>
>  	unsigned long			xol_vaddr;
>  	unsigned long			vaddr;
> +
> +	/*
> +	 * Unexpected error in probe point handling has left task's
> +	 * text or stack corrupted. Kill task ASAP.
                                    ^^^^^^^^^^^^^^
Exactly, so ...

> +	bool				doomed;

must die, I think.

Oleg.

