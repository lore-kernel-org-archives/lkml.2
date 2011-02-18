Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab1BRKlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:41:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:50749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846Ab1BRKlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:41:18 -0500
Date: Fri, 18 Feb 2011 10:40:54 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ebiederm@xmission.com, garyhade@us.ibm.com, jbeulich@novell.com,
        JBeulich@novell.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, garyhade@us.ibm.com, jbeulich@novell.com,
        JBeulich@novell.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4D5D52C2020000780003272C@vpn.id2.novell.com>
References: <4D5D52C2020000780003272C@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86: Eliminate pointless adjustment attempts in fixup_irqs()
Message-ID: <tip-58bff947e2d164c7e5cbf7f485e4b3d4884befeb@git.kernel.org>
Git-Commit-ID: 58bff947e2d164c7e5cbf7f485e4b3d4884befeb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 10:40:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58bff947e2d164c7e5cbf7f485e4b3d4884befeb
Gitweb:     http://git.kernel.org/tip/58bff947e2d164c7e5cbf7f485e4b3d4884befeb
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 17 Feb 2011 15:54:26 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Feb 2011 08:58:00 +0100

x86: Eliminate pointless adjustment attempts in fixup_irqs()

Not only when an IRQ's affinity equals cpu_online_mask is there
no need to actually try to adjust the affinity, but also when
it's a subset thereof. This particularly avoids adjustment
attempts during system shutdown to any IRQs bound to CPU#0.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Gary Hade <garyhade@us.ibm.com>
LKML-Reference: <4D5D52C2020000780003272C@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 387b6a0..78793ef 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -310,7 +310,7 @@ void fixup_irqs(void)
 		data = &desc->irq_data;
 		affinity = data->affinity;
 		if (!irq_has_action(irq) ||
-		    cpumask_equal(affinity, cpu_online_mask)) {
+		    cpumask_subset(affinity, cpu_online_mask)) {
 			raw_spin_unlock(&desc->lock);
 			continue;
 		}
