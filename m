Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab0JXBFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:05:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48337 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630Ab0JXBF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:05:27 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/15] x86, ioapic: Only print mapping for ioapic in right place
Date: Sat, 23 Oct 2010 18:02:25 -0700
Message-Id: <1287882149-29275-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When mapping does happen.

And only map ioapic address one time when mp_register_ioapic() is called.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0579b3b..1853494 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3980,11 +3980,11 @@ fake_ioapic_page:
 #endif
 			ioapic_phys = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
 			ioapic_phys = __pa(ioapic_phys);
+			set_fixmap_nocache(idx, ioapic_phys);
+			apic_printk(APIC_VERBOSE, "mapped IOAPIC to %08lx (%08lx)\n",
+				__fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),
+				ioapic_phys);
 		}
-		set_fixmap_nocache(idx, ioapic_phys);
-		apic_printk(APIC_VERBOSE, "mapped IOAPIC to %08lx (%08lx)\n",
-			__fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),
-			ioapic_phys);
 		idx++;
 
 		ioapic_res->start = ioapic_phys;
@@ -4068,6 +4068,9 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	mp_ioapics[idx].apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
+	apic_printk(APIC_VERBOSE, "mapped IOAPIC to %08lx (%08x)\n",
+			__fix_to_virt(FIX_IO_APIC_BASE_0 + idx) + (address & ~PAGE_MASK),
+			address);
 	mp_ioapics[idx].apicid = io_apic_unique_id(id);
 	mp_ioapics[idx].apicver = io_apic_get_version(idx);
 
-- 
1.7.1

