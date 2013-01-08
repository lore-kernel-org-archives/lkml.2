Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3AHQVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:21:54 -0500
Received: from smtp-out11.han.skanova.net ([195.67.226.200]:38697 "EHLO
	smtp-out11.han.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756502Ab3AHQVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:21:53 -0500
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2013 11:21:52 EST
Message-ID: <21264295.1104761357661734261.JavaMail.defaultUser@defaultHost>
Date: Tue, 8 Jan 2013 17:15:34 +0100 (CET)
From: "larsson.leif@telia.com" <larsson.leif@telia.com>
To: linux-kernel@vger.kernel.org
Subject: Availability issues during kernel load and kernel error handling
MIME-Version: 1.0
Content-Type: text/plain;charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Mailer: CP Presentation Server
X-clientstamp: [20.133.1.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I send this mail as information/suggestion for improvements of Linux 
kernel. I have identified and solved the problem below some years ago. 
I think that it would be great if the changes could be part of generic 
distributions in the future as the affects availability when using 
Linux in embedded system:

1. PROBLEM: The low level kernel functions exit(), panic(), poweroff() 
and halt() are implemented with endless loops.
2. DESCRIPTION: When a problem occurs during kernel initialisation or 
during operation where the functions are called, the only way to resume 
operation is to power off and on the unit. This works when the unit is 
in places with personnel, but installed at remote locations it is a 
problem.
3. KEYWORDS: exit(), halt(), panic(), poweroff(), error()
4. KERNEL VERSION: 2.4.20 to at least 2.6.9 
5. OUTPUT: -
6. EXAMPLE: Give command "halt" alt. "shutdown -h" at prompt or 
introduce a problem during boot process like checksum error of packed 
kernel load image.
7. ENVIRONMENT: All
8. WORKAROUND: In our system, activation of board whatchdog that 
reboots the unit as the CPU reset pin wasn't routed to a curcuit that 
could be written from CPU.
My changes in arch/ppc/boot/common/misc-common.c:

void reset_eb860(void)
{
#ifdef CONFIG_EB860
    puts("\n Rebooting in 5 seconds \n");
    *(unsigned char *) EB860_REG_WDT_CTL    |=  0x09;
    *(unsigned char *) EB860_REG_WDT_CTL    &= ~0x60;
    *(unsigned char *) EB860_REG_CTRL_STAT1 |=  EB860_TR_WDG | 
EB860_EN_WDG;
#else
        puts("EB860 HW watchdog reboot not available! \n");
#endif
}

void exit(void)
{
    puts("exit \n");
    reset_eb860();
    while(1);
}

9. SUGGESTION: Make it possible to configure alternative error 
resolving behavior instead of waiting for power-off in endless loops. 
This could be make a core dump and then wait a configurable time before 
calling restart() or just directly call restart().
10: CODING EXAMPLES: from linux-2.6.9 distribution.
arch/ppc/boot/common/misc-common.c

void exit(void)
{
    puts("exit\n");
    while(1);
}

void error(char *x)
{
    puts("\n\n");
    puts(x);
    puts("\n\n -- System halted");

    while(1);    /* Halt */
}

from linux-2.6.9/arch/kernel/exit.c

asmlinkage NORET_TYPE void do_exit(long code)
{
    struct task_struct *tsk = current;

    profile_task_exit(tsk);

    if (unlikely(in_interrupt()))
        panic("Aiee, killing interrupt handler!");
    if (unlikely(!tsk->pid))
        panic("Attempted to kill the idle task!");
    if (unlikely(tsk->pid == 1))
        panic("Attempted to kill init!");
    if (tsk->io_context)
        exit_io_context();
    tsk->flags |= PF_EXITING;
    del_timer_sync(&tsk->real_timer);

    if (unlikely(in_atomic()))
        printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
                current->comm, current->pid,
                preempt_count());

    if (unlikely(current->ptrace & PT_TRACE_EXIT)) {
        current->ptrace_message = code;
        ptrace_notify((PTRACE_EVENT_EXIT << 8) | SIGTRAP);
    }

    acct_process(code);
    __exit_mm(tsk);

    exit_sem(tsk);
    __exit_files(tsk);
    __exit_fs(tsk);
    exit_namespace(tsk);
    exit_thread();

    if (tsk->signal->leader)
        disassociate_ctty(1);

    module_put(tsk->thread_info->exec_domain->module);
    if (tsk->binfmt)
        module_put(tsk->binfmt->module);

    tsk->exit_code = code;
    exit_notify(tsk);
#ifdef CONFIG_NUMA
    mpol_free(tsk->mempolicy);
    tsk->mempolicy = NULL;
#endif
    schedule();
    BUG();
    /* Avoid "noreturn function does return".  */
    for (;;) ;
}

Have also seen an issue where the kernel code loaded into RAM was 
affected by a random memory error that resulted in hang-up of a unit. 
The problem is that there isn't any board supported supervision that 
can reboot a unit from the time where the unit is powered on until the 
kernel has enabled the timer interrupt handler. When the timer 
interrupt is operational, a SW watchdog can be used to monitor that the 
kernel and applications doesn't get stuck or enter eternal loops. To 
solve this boot issue, an external timer relay is triggered by power 
on. If the unit boots correctly to run level 0, an output signal is 
used to deactivate the timer relay. If not deactivated, the relay 
triggers a power off - on reset.

Best regards,
Leif Larsson

