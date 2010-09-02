Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0IBMqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 08:46:38 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:51974 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0IBMqh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Thu, 2 Sep 2010 08:46:37 -0400
Message-Id: <4C7FB8CA0200007800013F51@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 02 Sep 2010 13:46:34 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use clear_page()/copy_page() in favor of
	 memset()/memcpy() on whole pages
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After all that's what they are intended for.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
 arch/x86/kernel/machine_kexec_64.c |    4 ++--
 arch/x86/kvm/lapic.c               |    3 +--
 arch/x86/mm/init_32.c              |    4 ++--
 arch/x86/mm/init_64.c              |    2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

--- linux-2.6.36-rc3/arch/x86/kernel/machine_kexec_64.c
+++ 2.6.36-rc3-x86-use-clear_page/arch/x86/kernel/machine_kexec_64.c
@@ -36,7 +36,7 @@ static int init_one_level2_page(struct k
 		if (!page)
 			goto out;
 		pud = (pud_t *)page_address(page);
-		memset(pud, 0, PAGE_SIZE);
+		clear_page(pud);
 		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
 	}
 	pud = pud_offset(pgd, addr);
@@ -45,7 +45,7 @@ static int init_one_level2_page(struct k
 		if (!page)
 			goto out;
 		pmd = (pmd_t *)page_address(page);
-		memset(pmd, 0, PAGE_SIZE);
+		clear_page(pmd);
 		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
 	}
 	pmd = pmd_offset(pud, addr);
--- linux-2.6.36-rc3/arch/x86/kvm/lapic.c
+++ 2.6.36-rc3-x86-use-clear_page/arch/x86/kvm/lapic.c
@@ -1056,14 +1056,13 @@ int kvm_create_lapic(struct kvm_vcpu *vc
 
 	vcpu->arch.apic = apic;
 
-	apic->regs_page = alloc_page(GFP_KERNEL);
+	apic->regs_page = alloc_page(GFP_KERNEL|__GFP_ZERO);
 	if (apic->regs_page == NULL) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
 		goto nomem_free_apic;
 	}
 	apic->regs = page_address(apic->regs_page);
-	memset(apic->regs, 0, PAGE_SIZE);
 	apic->vcpu = vcpu;
 
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
--- linux-2.6.36-rc3/arch/x86/mm/init_32.c
+++ 2.6.36-rc3-x86-use-clear_page/arch/x86/mm/init_32.c
@@ -67,7 +67,7 @@ static __init void *alloc_low_page(void)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = __va(pfn * PAGE_SIZE);
-	memset(adr, 0, PAGE_SIZE);
+	clear_page(adr);
 	return adr;
 }
 
@@ -558,7 +558,7 @@ char swsusp_pg_dir[PAGE_SIZE]
 
 static inline void save_pg_dir(void)
 {
-	memcpy(swsusp_pg_dir, swapper_pg_dir, PAGE_SIZE);
+	copy_page(swsusp_pg_dir, swapper_pg_dir);
 }
 #else /* !CONFIG_ACPI_SLEEP */
 static inline void save_pg_dir(void)
--- linux-2.6.36-rc3/arch/x86/mm/init_64.c
+++ 2.6.36-rc3-x86-use-clear_page/arch/x86/mm/init_64.c
@@ -293,7 +293,7 @@ static __ref void *alloc_low_page(unsign
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
-	memset(adr, 0, PAGE_SIZE);
+	clear_page(adr);
 	*phys  = pfn * PAGE_SIZE;
 	return adr;
 }



