Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab0JYQ7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:59:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58910 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab0JYQ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:59:42 -0400
Message-ID: <4CC5B75C.2050400@kernel.org>
Date: Mon, 25 Oct 2010 09:59:08 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, ioapic: Don't map ioapic regs two times
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-12-git-send-email-yinghai@kernel.org> <4CC5B682.7030009@kernel.org>
In-Reply-To: <4CC5B682.7030009@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Normal path: When mptable or madt is used, and ioapic address is correct,
We already set mapping in mp_register_ioapic().

So only set_fixmap for dummy case.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3980,11 +3980,11 @@ fake_ioapic_page:
 #endif
 			ioapic_phys = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
 			ioapic_phys = __pa(ioapic_phys);
+			set_fixmap_nocache(idx, ioapic_phys);
+			apic_printk(APIC_VERBOSE, "mapped dummy IOAPIC to %08lx (%08lx)\n",
+				__fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),
+				ioapic_phys);
 		}
-		set_fixmap_nocache(idx, ioapic_phys);
-		apic_printk(APIC_VERBOSE, "mapped IOAPIC to %08lx (%08lx)\n",
-			__fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),
-			ioapic_phys);
 		idx++;
 
 		ioapic_res->start = ioapic_phys;
