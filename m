Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab2DTQKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:10:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58248 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2DTQKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:10:10 -0400
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Noonan <steven@uplinklabs.net>, Ben Guthro <ben@guthro.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcus Granado <marcus.granado@citrix.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] fix "perf top" soft lockups under Xen
Date: Sat, 21 Apr 2012 00:11:03 +0800
Message-Id: <1334938265-3844-1-git-send-email-mlin@ss.pku.edu.cn>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: 
- fix compile issues if no CONFIG_SMP, Konrad Rzeszutek Wilk
- move inc_irq_stat after irq_work_run

These 2 patches fixed the "perf top" soft lockups under Xen
reported by Steven at: https://lkml.org/lkml/2012/2/9/506

Both Steven and I tested it and "perf top" works well now.

The soft lockup code path is:

__irq_work_queue
  arch_irq_work_raise
    apic->send_IPI_self(IRQ_WORK_VECTOR);
      apic_send_IPI_self
        __default_send_IPI_shortcut
          __xapic_wait_icr_idle

static inline void __xapic_wait_icr_idle(void)
{
        while (native_apic_mem_read(APIC_ICR) & APIC_ICR_BUSY)
                cpu_relax();
}
The lockup happens at above while looop.

The cause is that Xen has not implemented the APIC IPI interface yet.
Xen has IPI interface: xen_send_IPI_one, but it's only used in
xen_smp_send_reschedule, xen_smp_send_call_function_ipi and
xen_smp_send_call_function_single_ipi, etc.

So we need to implement Xen's APIC IPI interface as Ben's patch does.
And implement Xen's IRQ_WORK_VECTOR handler.

Ben Guthro (1):
      xen: implement apic ipi interface

Lin Ming (1):
      xen: implement IRQ_WORK_VECTOR handler

 arch/x86/include/asm/xen/events.h |    1 +
 arch/x86/xen/enlighten.c          |    9 +++
 arch/x86/xen/smp.c                |  111 +++++++++++++++++++++++++++++++++++-
 arch/x86/xen/smp.h                |   12 ++++
 4 files changed, 129 insertions(+), 4 deletions(-)

