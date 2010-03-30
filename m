Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0C3ILl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:11:41 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36241 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab0C3IHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:07:22 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-acpi@vger.kernel.org, Iranna D Ankad <iranna.ankad@in.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 07/15] x86 ioapic: Fix io_apic_redir_entries to return the number of entries.
Date: Tue, 30 Mar 2010 01:07:08 -0700
Message-Id: <1269936436-7039-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1oci6qlmr.fsf_-_@fess.ebiederm.org>
References: <m1oci6qlmr.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, trenn@suse.de, suresh.b.siddha@intel.com, len.brown@intel.com, tony.luck@intel.com, fenghua.yu@intel.com, linux-acpi@vger.kernel.org, iranna.ankad@in.ibm.com, garyhade@us.ibm.com, protasnb@gmail.com, ebiederm@xmission.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

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
---
 arch/x86/kernel/apic/io_apic.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 54ba1f7..7e139bb 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3846,7 +3846,11 @@ int __init io_apic_get_redir_entries (int ioapic)
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
@@ -3862,7 +3866,7 @@ void __init probe_nr_irqs_gsi(void)
 
 		nr = 0;
 		for (idx = 0; idx < nr_ioapics; idx++)
-			nr += io_apic_get_redir_entries(idx) + 1;
+			nr += io_apic_get_redir_entries(idx);
 
 		if (nr > nr_irqs_gsi)
 			nr_irqs_gsi = nr;
@@ -4297,7 +4301,7 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 */
 	mp_gsi_routing[idx].gsi_base = gsi_base;
 	mp_gsi_routing[idx].gsi_end = gsi_base +
-	    io_apic_get_redir_entries(idx);
+	    io_apic_get_redir_entries(idx) - 1;
 
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
 	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
-- 
1.6.5.2.143.g8cc62

