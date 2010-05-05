Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003Ab0EECJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:09:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:36926 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932993Ab0EECJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:09:02 -0400
Date: Wed, 5 May 2010 02:08:29 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-7-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-7-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, ioapic: Fix io_apic_redir_entries to return the number of entries.
Message-ID: <tip-4b6b19a1c7302477653d799a53d48063dd53d555@git.kernel.org>
Git-Commit-ID: 4b6b19a1c7302477653d799a53d48063dd53d555
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:08:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b6b19a1c7302477653d799a53d48063dd53d555
Gitweb:     http://git.kernel.org/tip/4b6b19a1c7302477653d799a53d48063dd53d555
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:08 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:34:48 -0700

x86, ioapic: Fix io_apic_redir_entries to return the number of entries.

io_apic_redir_entries has a huge conceptual bug.  It returns the maximum
redirection entry not the number of redirection entries.  Which simply
does not match what the name of the function.  This just caught me
and it caught  Feng Tang, and  Len Brown when they wrote sfi_parse_ioapic.

Modify io_apic_redir_entries to actually return the number of redirection
entries, and fix the callers so that they properly handle receiving the
number of the number of redirection table entries, instead of the
number of redirection table entries less one.

While the usage in sfi.c does not show up in this patch it is fixed
by virtue of the fact that io_apic_redir_entries now has the semantics
sfi_parse_ioapic most reasonably expects.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-7-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/io_apic.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 73ec928..0a053e6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3855,7 +3855,11 @@ int __init io_apic_get_redir_entries (int ioapic)
 	reg_01.raw = io_apic_read(ioapic, 1);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
-	return reg_01.bits.entries;
+	/* The register returns the maximum index redir index
+	 * supported, which is one less than the total number of redir
+	 * entries.
+	 */
+	return reg_01.bits.entries + 1;
 }
 
 void __init probe_nr_irqs_gsi(void)
@@ -3871,7 +3875,7 @@ void __init probe_nr_irqs_gsi(void)
 
 		nr = 0;
 		for (idx = 0; idx < nr_ioapics; idx++)
-			nr += io_apic_get_redir_entries(idx) + 1;
+			nr += io_apic_get_redir_entries(idx);
 
 		if (nr > nr_irqs_gsi)
 			nr_irqs_gsi = nr;
@@ -4306,7 +4310,7 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 */
 	mp_gsi_routing[idx].gsi_base = gsi_base;
 	mp_gsi_routing[idx].gsi_end = gsi_base +
-	    io_apic_get_redir_entries(idx);
+	    io_apic_get_redir_entries(idx) - 1;
 
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
 	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
