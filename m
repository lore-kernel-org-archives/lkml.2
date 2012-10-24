Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2JXNAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:00:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56724 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab2JXNAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:00:48 -0400
Date: Wed, 24 Oct 2012 05:59:24 -0700
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Message-ID: <tip-94777fc51b3ad85ff9f705ddf7cdd0eb3bbad5a6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, joerg.roedel@amd.com,
        sivanich@sgi.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joerg.roedel@amd.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, sivanich@sgi.com
In-Reply-To: <20121016125021.GA22935@sgi.com>
References: <20121016125021.GA22935@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/irq/ioapic:
  Check for valid irq_cfg pointer in smp_irq_move_cleanup_interrupt
Git-Commit-ID: 94777fc51b3ad85ff9f705ddf7cdd0eb3bbad5a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 05:59:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94777fc51b3ad85ff9f705ddf7cdd0eb3bbad5a6
Gitweb:     http://git.kernel.org/tip/94777fc51b3ad85ff9f705ddf7cdd0eb3bbad5a6
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Tue, 16 Oct 2012 07:50:21 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 12:53:51 +0200

x86/irq/ioapic: Check for valid irq_cfg pointer in smp_irq_move_cleanup_interrupt

Posting this patch to fix an issue concerning sparse irq's that
I raised a while back.  There was discussion about adding
refcounting to sparse irqs (to fix other potential race
conditions), but that does not appear to have been addressed
yet.  This covers the only issue of this type that I've
encountered in this area.

A NULL pointer dereference can occur in
smp_irq_move_cleanup_interrupt() if we haven't yet setup the
irq_cfg pointer in the irq_desc.irq_data.chip_data.

In create_irq_nr() there is a window where we have set
vector_irq in __assign_irq_vector(), but not yet called
irq_set_chip_data() to set the irq_cfg pointer.

Should an IRQ_MOVE_CLEANUP_VECTOR hit the cpu in question during
this time, smp_irq_move_cleanup_interrupt() will attempt to
process the aforementioned irq, but panic when accessing
irq_cfg.

Only continue processing the irq if irq_cfg is non-NULL.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/20121016125021.GA22935@sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c265593..1817fa9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2257,6 +2257,9 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 			continue;
 
 		cfg = irq_cfg(irq);
+		if (!cfg)
+			continue;
+
 		raw_spin_lock(&desc->lock);
 
 		/*
