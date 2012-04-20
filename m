Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab2DTQ06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:26:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35329 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2DTQ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:26:56 -0400
Date: Fri, 20 Apr 2012 12:21:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Noonan <steven@uplinklabs.net>, Ben Guthro <ben@guthro.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcus Granado <marcus.granado@citrix.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] fix "perf top" soft lockups under Xen
Message-ID: <20120420162134.GB28366@phenom.dumpdata.com>
References: <1334938265-3844-1-git-send-email-mlin@ss.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334938265-3844-1-git-send-email-mlin@ss.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F918E3E.00AF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 12:11:03AM +0800, Lin Ming wrote:
> v2: 
> - fix compile issues if no CONFIG_SMP, Konrad Rzeszutek Wilk
> - move inc_irq_stat after irq_work_run

They look good to me (and they work nicely - thanks!)
so putting in the 3.5  queue.

> 
> These 2 patches fixed the "perf top" soft lockups under Xen
> reported by Steven at: https://lkml.org/lkml/2012/2/9/506
> 
> Both Steven and I tested it and "perf top" works well now.
> 
> The soft lockup code path is:
> 
> __irq_work_queue
>   arch_irq_work_raise
>     apic->send_IPI_self(IRQ_WORK_VECTOR);
>       apic_send_IPI_self
>         __default_send_IPI_shortcut
>           __xapic_wait_icr_idle
> 
> static inline void __xapic_wait_icr_idle(void)
> {
>         while (native_apic_mem_read(APIC_ICR) & APIC_ICR_BUSY)
>                 cpu_relax();
> }
> The lockup happens at above while looop.
> 
> The cause is that Xen has not implemented the APIC IPI interface yet.
> Xen has IPI interface: xen_send_IPI_one, but it's only used in
> xen_smp_send_reschedule, xen_smp_send_call_function_ipi and
> xen_smp_send_call_function_single_ipi, etc.
> 
> So we need to implement Xen's APIC IPI interface as Ben's patch does.
> And implement Xen's IRQ_WORK_VECTOR handler.
> 
> Ben Guthro (1):
>       xen: implement apic ipi interface
> 
> Lin Ming (1):
>       xen: implement IRQ_WORK_VECTOR handler
> 
>  arch/x86/include/asm/xen/events.h |    1 +
>  arch/x86/xen/enlighten.c          |    9 +++
>  arch/x86/xen/smp.c                |  111 +++++++++++++++++++++++++++++++++++-
>  arch/x86/xen/smp.h                |   12 ++++
>  4 files changed, 129 insertions(+), 4 deletions(-)
