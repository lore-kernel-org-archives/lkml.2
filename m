Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206Ab1ETNig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:38:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:56497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933911Ab1ETNie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:38:34 -0400
Date: Fri, 20 May 2011 13:38:21 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-15bac20bd8a039e9acb274785be82772e1237eed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        daniel.blueman@gmail.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        daniel.blueman@gmail.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110518233157.673130611@sbsiddha-MOBL3.sc.intel.com>
References: <20110518233157.673130611@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Remove duplicate code for saving/restoring RTEs
Git-Commit-ID: 15bac20bd8a039e9acb274785be82772e1237eed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:38:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15bac20bd8a039e9acb274785be82772e1237eed
Gitweb:     http://git.kernel.org/tip/15bac20bd8a039e9acb274785be82772e1237eed
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 18 May 2011 16:31:34 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:40:54 +0200

x86, ioapic: Remove duplicate code for saving/restoring RTEs

Code flow for enabling interrupt-remapping has its own routines
for saving and restoring io-apic RTE's. ioapic suspend/resume
code flow also has similar routines. Remove the duplicate code.

Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/20110518233157.673130611@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |   36 +++++-------------------------------
 1 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 08b794d..4fc544d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2887,37 +2887,11 @@ static int __init io_apic_bug_finalize(void)
 
 late_initcall(io_apic_bug_finalize);
 
-static void suspend_ioapic(int ioapic_id)
+static void resume_ioapic_id(int ioapic_id)
 {
-	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
-	int i;
-
-	if (!saved_data)
-		return;
-
-	for (i = 0; i < nr_ioapic_registers[ioapic_id]; i++)
-		saved_data[i] = ioapic_read_entry(ioapic_id, i);
-}
-
-static int ioapic_suspend(void)
-{
-	int ioapic_id;
-
-	for (ioapic_id = 0; ioapic_id < nr_ioapics; ioapic_id++)
-		suspend_ioapic(ioapic_id);
-
-	return 0;
-}
-
-static void resume_ioapic(int ioapic_id)
-{
-	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
 	unsigned long flags;
 	union IO_APIC_reg_00 reg_00;
-	int i;
 
-	if (!saved_data)
-		return;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(ioapic_id, 0);
@@ -2926,8 +2900,6 @@ static void resume_ioapic(int ioapic_id)
 		io_apic_write(ioapic_id, 0, reg_00.raw);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-	for (i = 0; i < nr_ioapic_registers[ioapic_id]; i++)
-		ioapic_write_entry(ioapic_id, i, saved_data[i]);
 }
 
 static void ioapic_resume(void)
@@ -2935,11 +2907,13 @@ static void ioapic_resume(void)
 	int ioapic_id;
 
 	for (ioapic_id = nr_ioapics - 1; ioapic_id >= 0; ioapic_id--)
-		resume_ioapic(ioapic_id);
+		resume_ioapic_id(ioapic_id);
+
+	restore_ioapic_entries();
 }
 
 static struct syscore_ops ioapic_syscore_ops = {
-	.suspend = ioapic_suspend,
+	.suspend = save_ioapic_entries,
 	.resume = ioapic_resume,
 };
 
