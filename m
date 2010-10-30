Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0J3IhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 04:37:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:45843 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab0J3IhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 04:37:14 -0400
Date: Sat, 30 Oct 2010 08:36:54 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, rja@sgi.com, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, rja@sgi.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <4CCBD511.40607@kernel.org>
References: <4CCBD511.40607@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Check irq_remapped instead of remapping_enabled in destroy_irq()
Message-ID: <tip-7b79462a20826a7269322113c68ca78d5f67c0bd@git.kernel.org>
Git-Commit-ID: 7b79462a20826a7269322113c68ca78d5f67c0bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Oct 2010 08:36:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b79462a20826a7269322113c68ca78d5f67c0bd
Gitweb:     http://git.kernel.org/tip/7b79462a20826a7269322113c68ca78d5f67c0bd
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 30 Oct 2010 01:19:29 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 30 Oct 2010 10:28:31 +0200

x86: Check irq_remapped instead of remapping_enabled in destroy_irq()

Russ Anderson reported:
| There is a regression that is causing a NULL pointer dereference
| in free_irte when shutting down xpc. git bisect narrowed it down
| to git commit d585d06(intr_remap: Simplify the code further), which
| changed free_irte(). Reverse applying the patch fixes the problem.

We need to use irq_remapped() for each irq instead of checking only
intr_remapping_enabled as there might be non remapped irqs even when
remapping is enabled.

[ tglx: use cfg instead of retrieving it again. Massaged changelog ]

Reported-bisected-and-tested-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <4CCBD511.40607@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0929191..7cc0a72 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3109,7 +3109,7 @@ void destroy_irq(unsigned int irq)
 
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
 
-	if (intr_remapping_enabled)
+	if (irq_remapped(cfg))
 		free_irte(irq);
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq, cfg);
