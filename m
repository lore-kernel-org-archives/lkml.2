Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1LTWin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:38:43 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53621 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1LTWik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:38:40 -0500
MIME-Version: 1.0
In-Reply-To: <tip-3603a2512f9e69dc87914ba922eb4a0812b21cd6@git.kernel.org>
References: <1318533267-18880-2-git-send-email-dzickus@redhat.com>
	<tip-3603a2512f9e69dc87914ba922eb4a0812b21cd6@git.kernel.org>
Date: Tue, 20 Dec 2011 14:38:39 -0800
X-Google-Sender-Auth: OcWQrnl7kH8hLFGWPAjlZZLqqRY
Message-ID: <CAE9FiQWX_2bV1phLCUrEpiPSfo24xWEv3Y+DZnwmi9JJgJHbmQ@mail.gmail.com>
Subject: Re: [tip:x86/debug] x86, reboot: Use NMI instead of REBOOT_VECTOR to
 stop cpus
From: Yinghai Lu <yinghai@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 5:21 AM, tip-bot for Don Zickus
<dzickus@redhat.com> wrote:
> Commit-ID:  3603a2512f9e69dc87914ba922eb4a0812b21cd6
> Gitweb:     http://git.kernel.org/tip/3603a2512f9e69dc87914ba922eb4a0812b21cd6
> Author:     Don Zickus <dzickus@redhat.com>
> AuthorDate: Thu, 13 Oct 2011 15:14:25 -0400
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 5 Dec 2011 12:00:14 +0100
>
> x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus
>
> A recent discussion started talking about the locking on the
> pstore fs and how it relates to the kmsg infrastructure.  We
> noticed it was possible for userspace to r/w to the pstore fs
> (grabbing the locks in the process) and block the panic path
> from r/w to the same fs.
>
> The reason was the cpu with the lock could be doing work while
> the crashing cpu is panic'ing.  Busting those spinlocks might
> cause those cpus to step on each other's data.  Fine, fair
> enough.
>
> It was suggested it would be nice to serialize the panic path
> (ie stop the other cpus) and have only one cpu running.  This
> would allow us to bust the spinlocks and not worry about another
> cpu stepping on the data.
>
> Of course, smp_send_stop() does this in the panic case.
> kmsg_dump() would have to be moved to be called after it.  Easy
> enough.
>
> The only problem is on x86 the smp_send_stop() function calls
> the REBOOT_VECTOR.  Any cpu with irqs disabled (which pstore and
> its backend ERST would do), block this IPI and thus do not stop.
>  This makes it difficult to reliably log data to the pstore fs.
>
> The patch below switches from the REBOOT_VECTOR to NMI (and
> mimics what kdump does).  Switching to NMI allows us to deliver
> the IPI when irqs are disabled, increasing the reliability of
> this function.
>
> However, Andi carefully noted that on some machines this
> approach does not work because of broken BIOSes or whatever.
>
> To help accomodate this, the next couple of patches will run a
> selftest and provide a knob to disable.
>
> V2:
>  uses atomic ops to serialize the cpu that shuts everyone down
> V3:
>  comment cleanup
>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: seiji.aguchi@hds.com
> Cc: vgoyal@redhat.com
> Cc: mjg@redhat.com
> Cc: tony.luck@intel.com
> Cc: gong.chen@intel.com
> Cc: satoru.moriya@hds.com
> Cc: avi@redhat.com
> Cc: Andi Kleen <andi@firstfloor.org>
> Link: http://lkml.kernel.org/r/1318533267-18880-2-git-send-email-dzickus@redhat.com
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/smp.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 57 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 16204dc..e72b175 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -29,6 +29,7 @@
>  #include <asm/mmu_context.h>
>  #include <asm/proto.h>
>  #include <asm/apic.h>
> +#include <asm/nmi.h>
>  /*
>  *     Some notes on x86 processor bugs affecting SMP operation:
>  *
> @@ -148,6 +149,60 @@ void native_send_call_func_ipi(const struct cpumask *mask)
>        free_cpumask_var(allbutself);
>  }
>
> +static atomic_t stopping_cpu = ATOMIC_INIT(-1);
> +
> +static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
> +{
> +       /* We are registered on stopping cpu too, avoid spurious NMI */
> +       if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
> +               return NMI_HANDLED;
> +
> +       stop_this_cpu(NULL);
> +
> +       return NMI_HANDLED;
> +}
> +
> +static void native_nmi_stop_other_cpus(int wait)
> +{
> +       unsigned long flags;
> +       unsigned long timeout;
> +
> +       if (reboot_force)
> +               return;
> +
> +       /*
> +        * Use an own vector here because smp_call_function
> +        * does lots of things not suitable in a panic situation.
> +        */
> +       if (num_online_cpus() > 1) {
> +               /* did someone beat us here? */
> +               if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id() != -1))
> +                       return;
> +
> +               if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
> +                                        NMI_FLAG_FIRST, "smp_stop"))
> +                       /* Note: we ignore failures here */
> +                       return;
> +
> +               /* sync above data before sending NMI */
> +               wmb();
> +
> +               apic->send_IPI_allbutself(NMI_VECTOR);
> +
> +               /*
> +                * Don't wait longer than a second if the caller
> +                * didn't ask us to wait.
> +                */
> +               timeout = USEC_PER_SEC;
> +               while (num_online_cpus() > 1 && (wait || timeout--))
> +                       udelay(1);
> +       }
> +
> +       local_irq_save(flags);
> +       disable_local_APIC();
> +       local_irq_restore(flags);
> +}
> +
>  /*
>  * this function calls the 'stop' function on all other CPUs in the system.
>  */
> @@ -160,7 +215,7 @@ asmlinkage void smp_reboot_interrupt(void)
>        irq_exit();
>  }
>
> -static void native_stop_other_cpus(int wait)
> +static void native_irq_stop_other_cpus(int wait)
>  {
>        unsigned long flags;
>        unsigned long timeout;
> @@ -230,7 +285,7 @@ struct smp_ops smp_ops = {
>        .smp_prepare_cpus       = native_smp_prepare_cpus,
>        .smp_cpus_done          = native_smp_cpus_done,
>
> -       .stop_other_cpus        = native_stop_other_cpus,
> +       .stop_other_cpus        = native_nmi_stop_other_cpus,
>        .smp_send_reschedule    = native_smp_send_reschedule,
>
>        .cpu_up                 = native_cpu_up,

this broke kexec on our intel nehalem, westmere and sandbridge platforms.
system get reset while try to kexec second kernel.

3603a2512f9e69dc87914ba922eb4a0812b21cd6 is the first bad commit
commit 3603a2512f9e69dc87914ba922eb4a0812b21cd6
Author: Don Zickus <dzickus@redhat.com>
Date:   Thu Oct 13 15:14:25 2011 -0400

    x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus

    A recent discussion started talking about the locking on the
    pstore fs and how it relates to the kmsg infrastructure.  We
    noticed it was possible for userspace to r/w to the pstore fs
    (grabbing the locks in the process) and block the panic path
    from r/w to the same fs.

    The reason was the cpu with the lock could be doing work while
    the crashing cpu is panic'ing.  Busting those spinlocks might
    cause those cpus to step on each other's data.  Fine, fair
    enough.

    It was suggested it would be nice to serialize the panic path
    (ie stop the other cpus) and have only one cpu running.  This
    would allow us to bust the spinlocks and not worry about another
    cpu stepping on the data.

    Of course, smp_send_stop() does this in the panic case.
    kmsg_dump() would have to be moved to be called after it.  Easy
    enough.

    The only problem is on x86 the smp_send_stop() function calls
    the REBOOT_VECTOR.  Any cpu with irqs disabled (which pstore and
    its backend ERST would do), block this IPI and thus do not stop.
     This makes it difficult to reliably log data to the pstore fs.

    The patch below switches from the REBOOT_VECTOR to NMI (and
    mimics what kdump does).  Switching to NMI allows us to deliver
    the IPI when irqs are disabled, increasing the reliability of
    this function.

    However, Andi carefully noted that on some machines this
    approach does not work because of broken BIOSes or whatever.

    To help accomodate this, the next couple of patches will run a
    selftest and provide a knob to disable.

    V2:
      uses atomic ops to serialize the cpu that shuts everyone down
    V3:
      comment cleanup

    Signed-off-by: Don Zickus <dzickus@redhat.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Robert Richter <robert.richter@amd.com>
    Cc: seiji.aguchi@hds.com
    Cc: vgoyal@redhat.com
    Cc: mjg@redhat.com
    Cc: tony.luck@intel.com
    Cc: gong.chen@intel.com
    Cc: satoru.moriya@hds.com
    Cc: avi@redhat.com
    Cc: Andi Kleen <andi@firstfloor.org>
    Link:
http://lkml.kernel.org/r/1318533267-18880-2-git-send-email-dzickus@redhat.com
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 47a646e9ead83f34fb0728d88c786c875fab91dd
6f7a6d5ad8ed686199c0dfbc748ee07a0db97cc5 M      arch
