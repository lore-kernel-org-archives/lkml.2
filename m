Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2AaVhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 16:37:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab2AaVhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 16:37:19 -0500
Date: Tue, 31 Jan 2012 16:37:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, ebiederm@xmission.com,
        kexec-list <kexec@lists.infradead.org>
Subject: Re: [PATCH] x86, kdump, ioapic: Fix kdump race with migrating irq
Message-ID: <20120131213713.GC4378@redhat.com>
References: <1328045114-4489-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328045114-4489-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 04:25:14PM -0500, Don Zickus wrote:
> A customer of ours noticed when their machine crashed, kdump did not
> work but hung instead.  Using their firmware dumping solution they
> grabbed a vmcore and decoded the stacks on the cpus.  What they
> noticed seemed to be a rare deadlock with the ioapic_lock.
> 
>  CPU4:
>  machine_crash_shutdown
>  -> machine_ops.crash_shutdown
>     -> native_machine_crash_shutdown
>        -> kdump_nmi_shootdown_cpus ------> Send NMI to other CPUs
>        -> disable_IO_APIC
>           -> clear_IO_APIC
>              -> clear_IO_APIC_pin
>                 -> ioapic_read_entry
>                    -> spin_lock_irqsave(&ioapic_lock, flags)
>                    ---Infinite loop here---
> 
>  CPU0:
>  do_IRQ
>  -> handle_irq
>     -> handle_edge_irq
>         -> ack_apic_edge
>            -> move_native_irq
>                -> mask_IO_APIC_irq
>                   -> mask_IO_APIC_irq_desc
>                      -> spin_lock_irqsave(&ioapic_lock, flags)
>                      ---Receive NMI here after getting spinlock---
>                         -> nmi
>                            -> do_nmi
>                               -> crash_nmi_callback
>                               ---Infinite loop here---
> 
> The problem is that although kdump tries to shutdown minimal hardware,
> it still needs to disable the IO APIC.  This requires spinlocks which
> may be held by another cpu.  This other cpu is being held infinitely in
> an NMI context by kdump in order to serialize the crashing path.  Instant
> deadlock.
> 
> I attempted to resolve this by busting the spinlock in the kdump case only.
> My justification was that kdump has already stopped the other cpus and it
> is only clearing the io apic which shouldn't cause harm when overwriting
> what the other cpu was doing.
> 
> I tested this by loading a dummy module that grabs the ioapic_lock and then
> on another cpu, run 'echo c > /proc/sysrq-trigger'.  The deadlock was detected
> and fixed with the patch below.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Sounds reasonable to me. 

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
