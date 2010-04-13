Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab0DMNcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 09:32:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:61594 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab0DMNcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PbmuloHoYOM4fi2JoxHjOjzLazT/xJEjm/fH27x285ce3BFRm/ytn36lkkAmAnhB/b
         ce/GCBevMyah6Zw9H6mDpY8kUI3cT7CMra0ruxGjnoVMc7p8oKxE0XDvIv5QKDHGQhQn
         QE/UTtHuzsCqFzs2ntm4xzGRUilhyOTBiIddk=
MIME-Version: 1.0
In-Reply-To: <1268236874-7877-3-git-send-email-will.deacon@arm.com>
References: <1268236874-7877-1-git-send-email-will.deacon@arm.com>
	 <1268236874-7877-2-git-send-email-will.deacon@arm.com>
	 <1268236874-7877-3-git-send-email-will.deacon@arm.com>
Date: Tue, 13 Apr 2010 15:32:51 +0200
Message-ID: <h2mc62985531004130632kd086ffe9o16edafc359fa0e2@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] ARM: hw-breakpoint: add ARM backend for the 
	hw-breakpoint framework
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(WARNING: I've browsed the ARMv7 breakpoints implementation
but I may have an erratic/incomplete understanding, then parts
of this review might make little sense)


2010/3/10 Will Deacon <will.deacon@arm.com>:
> The hw-breakpoint framework in the kernel requires architecture-specific
> support in order to install, remove, validate and manage hardware
> breakpoints.
>
> This patch adds preliminary support for this framework to the ARM
> architecture, but restricts the number of watchpoints to a single resource
> to get around the fact that the Data Fault Address Register is unpredictable
> when a watchpoint debug exception is taken.


What do you mean here by unpredictable? It would be a pity to limit the
resources to one register.



> +}
> +
> +/* Determine number of WRP registers available. */
> +static int get_num_wrps(void)
> +{
> +       /*
> +        * FIXME: When a watchpoint fires, the only way to work out which
> +        * watchpoint it was is by disassembling the faulting instruction
> +        * and working out the address of the memory access.



Doh! That must explain the problem with DFAR...
That's really not convenient :-(



> +        *
> +        * Furthermore, we can only do this if the watchpoint was precise
> +        * since imprecise watchpoints prevent us from calculating register
> +        * based addresses.
> +        *
> +        * For the time being, we only report 1 watchpoint register so we
> +        * always know which watchpoint fired. In the future we can either
> +        * add a disassembler and address generation emulator, or we can
> +        * insert a check to see if the DFAR is set on watchpoint exception
> +        * entry [the ARM ARM states that the DFAR is UNPREDICTABLE, but
> +        * experience shows that it is set on some implementations].


Ok...



> +/*
> + * Install a perf counter breakpoint.
> + */
> +int arch_install_hw_breakpoint(struct perf_event *bp)
> +{
> +       struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> +       struct perf_event **slot, **slots;
> +       int i, max_slots, ctrl_base, val_base, ret = 0;
> +
> +       /* Ensure that we are in monitor mode and halting mode is disabled. */
> +       ret = enable_monitor_mode();
> +       if (ret)
> +               goto out;
> +
> +       if (info->type == ARM_BREAKPOINT_EXECUTE) {
> +               /* Breakpoint */
> +               ctrl_base = ARM_BASE_BCR;
> +               val_base = ARM_BASE_BVR;
> +               slots = __get_cpu_var(bp_on_reg);
> +               max_slots = core_num_brps;
> +       } else {
> +               /* Watchpoint */
> +               ctrl_base = ARM_BASE_WCR;
> +               val_base = ARM_BASE_WVR;
> +               slots = __get_cpu_var(wp_on_reg);
> +               max_slots = core_num_wrps;
> +       }
> +
> +       for (i = 0; i < max_slots; ++i) {
> +               slot = &slots[i];
> +
> +               if (!*slot) {
> +                       *slot = bp;
> +                       break;
> +               }
> +       }
> +
> +       if (WARN_ONCE(i == max_slots, "Can't find any breakpoint slot")) {
> +               ret = -EBUSY;
> +               goto out;
> +       }
> +
> +       /* Setup the address register. */
> +       write_wb_reg(val_base + i, info->address);
> +
> +       /* Setup the control register. */
> +       write_wb_reg(ctrl_base + i, (info->type << 3) |
> +                       (info->privilege << 1) | (info->len << 5) | 1);



Ok, alternatively, why not having the control register in the arch
breakpoint structure:

u32   __reserved : 19,
        len             :  7,
        type           :  2,
        privilege      :  2,
        enabled      :  1;

It will avoid you to play with bitwise operations that may scale into dirty
and error prone as you may support more features from the control register
(link, mask, etc...).

So in the future if you want to support more things, you can just split out
the __reserved field into the features it has, depending on the ARM versions.

Ah and it will make ptrace support easier: the user writes into the val/ctrl
fields directly as if they were the true registers, then you can just validate
the fields you want without bitwise ops.



> +/*
> + * Validate the arch-specific HW Breakpoint register settings.
> + */
> +int arch_validate_hwbkpt_settings(struct perf_event *bp,
> +                                 struct task_struct *tsk)
> +{
> +       struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> +       int ret = 0;
> +       u32 alignment_mask = 0x3;
> +
> +       /* Build the arch_hw_breakpoint. */
> +       ret = arch_build_bp_info(bp);
> +       if (ret)
> +               goto out;
> +
> +       /* Check address alignment. */
> +       if (info->len == ARM_BREAKPOINT_LEN_8)
> +               alignment_mask = 0x7;
> +       if (info->address & alignment_mask) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +       /* Check that the virtual address is in the proper range. */
> +       if (tsk) {
> +               if (!(info->privilege & ARM_BREAKPOINT_USER)) {
> +                       ret = -EFAULT;
> +                       goto out;
> +               }
> +       } else {
> +               if (!(info->privilege & ARM_BREAKPOINT_SUPER)) {
> +                       ret = -EFAULT;
> +                       goto out;
> +               }
> +       }


You seem to make a wrong assumption here.
This is not because the breakpoint is task-bound that we don't
want it to trigger on the kernel. We may want to trigger breakpoints
on tasklist_lock accesses from a given task.

The only case for which we don't want it to trigger on the kernel
is for ptrace breakpoints.

I guess I should remove this tsk parameter as it makes the things
only confusing. We should simply create ptrace breakpoints with
bp->attr.exclude_kernel set to 1.

Because when bp->attr.exclude_kernel is set to 1, then it truly makes sense
to think about user and supervisor privileges, just to avoid to filter the
event in the software level. Note we do this filtering on software level,
but it going to be less costly if done from hardware.

Even if you don't support ptrace right now, we can define a kernel exluded
breakpoint from perf syscall.

(Note for myself: set exclude_kernel to ptrace breakpoints in x86)


> +/*
> + * Release the user breakpoints used by ptrace.
> + */
> +void flush_ptrace_hw_breakpoint(struct task_struct *tsk)
> +{
> +       int i;
> +       struct thread_struct *t = &tsk->thread;
> +
> +       for (i = 0; i < HBP_NUM; i++) {
> +               unregister_hw_breakpoint(t->debug.hbp[i]);
> +               t->debug.hbp[i] = NULL;
> +       }
> +}


Do you actually support ptrace breakpoints?



> +
> +void hw_breakpoint_pmu_unthrottle(struct perf_event *bp)
> +{
> +       /* TODO */
> +}


We don't need this callback anymore, it has been removed because
of ptrace corner cases...


Thanks!
