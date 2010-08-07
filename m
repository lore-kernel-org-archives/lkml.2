Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761884Ab0HGCR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:17:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37310 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab0HGCQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:16:46 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/10] x86, ioapic: only print mapping for ioapic in right place
Date: Fri,  6 Aug 2010 19:15:43 -0700
Message-Id: <1281147343-18389-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
References: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when mapping does happen.

And only map ioapic address one time when mp_register_ioapic() is called.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4dc0084..badf10e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4192,11 +4192,11 @@ fake_ioapic_page:
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
@@ -4278,6 +4278,9 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	mp_ioapics[idx].apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
+	apic_printk(APIC_VERBOSE, "mapped IOAPIC to %08lx (%08x)\n",
+			__fix_to_virt(FIX_IO_APIC_BASE_0 + idx) + (address & ~PAGE_MASK),
+			address);
 	mp_ioapics[idx].apicid = io_apic_unique_id(id);
 	mp_ioapics[idx].apicver = io_apic_get_version(idx);
 
-- 
1.6.4.2

