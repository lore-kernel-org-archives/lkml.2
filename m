Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab2DOGPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 02:15:40 -0400
Received: from [124.207.24.138] ([124.207.24.138]:38467 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2DOGPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 02:15:39 -0400
MIME-Version: 1.0
Date: Sun, 15 Apr 2012 14:14:57 +0800
Message-ID: <CAF1ivSZqe54_gAQNZW_teiApObkXsC5iu04Siy1OEnm9M9AcUA@mail.gmail.com>
Subject: Re: [PATCH 0/2] fix "perf top" soft lockups under Xen
From: Lin Ming <mlin@ss.pku.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Noonan <steven@uplinklabs.net>,
        Marcus Granado <marcus.granado@citrix.com>, xen-devel@lists.xen.org,
        Ben Guthro <ben@guthro.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Forgot mail subject, add it)

On Sun, Apr 15, 2012 at 2:09 PM, Lin Ming <mlin@ss.pku.edu.cn> wrote:
> Hi all,
>
> These 2 patches try to fix the "perf top" soft lockups under Xen
> reported by Steven at: https://lkml.org/lkml/2012/2/9/506
>
> I tested it with 3.4-rc2 and "perf top" works well now.
>
> Steven,
> Could you please help to test it too?
>
> The soft lockup code path is:
>
> __irq_work_queue
>  arch_irq_work_raise
>    apic->send_IPI_self(IRQ_WORK_VECTOR);
>      apic_send_IPI_self
>        __default_send_IPI_shortcut
>          __xapic_wait_icr_idle
>
> static inline void __xapic_wait_icr_idle(void)
> {
>        while (native_apic_mem_read(APIC_ICR) & APIC_ICR_BUSY)
>                cpu_relax();
> }
>
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
>      xen: implement apic ipi interface
>
> Lin Ming (1):
>      xen: implement IRQ_WORK_VECTOR handler
>
>  arch/x86/include/asm/xen/events.h |    1 +
>  arch/x86/xen/enlighten.c          |    7 ++
>  arch/x86/xen/smp.c                |  111 +++++++++++++++++++++++++++++++++++-
>  arch/x86/xen/smp.h                |   12 ++++
>  4 files changed, 127 insertions(+), 4 deletions(-)
>
> Any comment is appreciated.
> Lin Ming
