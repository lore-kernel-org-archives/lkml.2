Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174Ab2JXTmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:42:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40376 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933818Ab2JXTmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:42:12 -0400
Date: Wed, 24 Oct 2012 12:42:07 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linbao.zhang@hp.com,
        "Eric W. Biederman" <ebiederm@xmission.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/3] x86, ioapic: Teach mp_register_ioapic to compute a
 global gsi_end
Message-ID: <20121024194207.GD3120@elie.Belkin>
References: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com>
 <20121024182546.GB3338@elie.Belkin>
 <1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com>
 <20121024194114.GC3120@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024194114.GC3120@elie.Belkin>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 30 Mar 2010 01:07:10 -0700

commit 5777372af5c929b8f3c706ed7b295b7279537c88 upstream.

Add the global variable gsi_end and teach mp_register_ioapic
to keep it uptodate as we add more ioapics into the system.

ioapics can only be added early in boot so the code that
runs later can treat gsi_end as a constant.

Remove the have hacks in sfi.c to second guess mp_register_ioapic
by keeping t's own running total of how many gsi's have been seen,
and instead use the gsi_end.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-9-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 arch/x86/include/asm/io_apic.h | 1 +
 arch/x86/kernel/apic/io_apic.c | 6 ++++++
 arch/x86/kernel/sfi.c          | 4 +---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 5f61f6e0ffdd..c145253f34fa 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -186,6 +186,7 @@ struct mp_ioapic_gsi{
 	int gsi_end;
 };
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
+extern u32 gsi_end;
 int mp_find_ioapic(int gsi);
 int mp_find_ioapic_pin(int ioapic, int gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8928d9785eb4..7a5087640599 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -90,6 +90,9 @@ int nr_ioapics;
 /* IO APIC gsi routing info */
 struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
 
+/* The last gsi number used */
+u32 gsi_end;
+
 /* MP IRQ source entries */
 struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
@@ -4284,6 +4287,9 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	mp_gsi_routing[idx].gsi_end = gsi_base +
 	    io_apic_get_redir_entries(idx);
 
+	if (mp_gsi_routing[idx].gsi_end > gsi_end)
+		gsi_end = mp_gsi_routing[idx].gsi_end;
+
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
 	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
 	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
diff --git a/arch/x86/kernel/sfi.c b/arch/x86/kernel/sfi.c
index 34e099382651..7ded57896c0a 100644
--- a/arch/x86/kernel/sfi.c
+++ b/arch/x86/kernel/sfi.c
@@ -81,7 +81,6 @@ static int __init sfi_parse_cpus(struct sfi_table_header *table)
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_IO_APIC
-static u32 gsi_base;
 
 static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 {
@@ -94,8 +93,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 	pentry = (struct sfi_apic_table_entry *)sb->pentry;
 
 	for (i = 0; i < num; i++) {
-		mp_register_ioapic(i, pentry->phys_addr, gsi_base);
-		gsi_base += io_apic_get_redir_entries(i);
+		mp_register_ioapic(i, pentry->phys_addr, gsi_end + 1);
 		pentry++;
 	}
 
-- 
1.8.0

