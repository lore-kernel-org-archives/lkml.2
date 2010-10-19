Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab0JSH2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:28:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:48384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760Ab0JSH2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:28:52 -0400
Date: Tue, 19 Oct 2010 07:28:35 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4CBCB274.7010108@kernel.org>
References: <4CBCB274.7010108@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: ioapic: Call free_irte only if interrupt remapping enabled
Message-ID: <tip-9717967c4b704ce344c954afb5bb160aa9c01c34@git.kernel.org>
Git-Commit-ID: 9717967c4b704ce344c954afb5bb160aa9c01c34
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Oct 2010 07:28:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9717967c4b704ce344c954afb5bb160aa9c01c34
Gitweb:     http://git.kernel.org/tip/9717967c4b704ce344c954afb5bb160aa9c01c34
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 18 Oct 2010 13:47:48 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 19 Oct 2010 09:25:33 +0200

x86: ioapic: Call free_irte only if interrupt remapping enabled

On a system that support intr-rempping when booting with "intremap=off"

[  177.895501] BUG: unable to handle kernel NULL pointer dereference at 00000000000000f8
[  177.913316] IP: [<ffffffff8145fc18>] free_irte+0x47/0xc0
...
[  178.173326] Call Trace:
[  178.173574]  [<ffffffff810515b4>] destroy_irq+0x3a/0x75
[  178.192934]  [<ffffffff81051834>] arch_teardown_msi_irq+0xe/0x10
[  178.193418]  [<ffffffff81458dc3>] arch_teardown_msi_irqs+0x56/0x7f
[  178.213021]  [<ffffffff81458e79>] free_msi_irqs+0x8d/0xeb

Call free_irte only when interrupt remapping is enabled.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4CBCB274.7010108@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/apic/io_apic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 20e47e0..8ae808d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3109,7 +3109,8 @@ void destroy_irq(unsigned int irq)
 
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
 
-	free_irte(irq);
+	if (intr_remapping_enabled)
+		free_irte(irq);
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq, cfg);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
