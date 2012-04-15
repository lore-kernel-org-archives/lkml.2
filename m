Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2DOGJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 02:09:31 -0400
Received: from [124.207.24.138] ([124.207.24.138]:38369 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2DOGJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 02:09:29 -0400
From: Lin Ming <mlin@ss.pku.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Noonan <steven@uplinklabs.net>, Ben Guthro <ben@guthro.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcus Granado <marcus.granado@citrix.com>, xen-devel@lists.xen.org
Subject: 
Date: Sun, 15 Apr 2012 14:09:30 +0800
Message-Id: <1334470172-3861-1-git-send-email-mlin@ss.pku.edu.cn>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

These 2 patches try to fix the "perf top" soft lockups under Xen
reported by Steven at: https://lkml.org/lkml/2012/2/9/506

I tested it with 3.4-rc2 and "perf top" works well now.

Steven,
Could you please help to test it too?

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
 arch/x86/xen/enlighten.c          |    7 ++
 arch/x86/xen/smp.c                |  111 +++++++++++++++++++++++++++++++++++-
 arch/x86/xen/smp.h                |   12 ++++
 4 files changed, 127 insertions(+), 4 deletions(-)

Any comment is appreciated.
Lin Ming

