Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab0IVX6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 19:58:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:50218 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab0IVX6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 19:58:23 -0400
Date: Wed, 22 Sep 2010 23:58:03 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, jbeulich@novell.com, JBeulich@novell.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, akpm@linux-foundation.org, JBeulich@novell.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4C7FB8CA0200007800013F51@vpn.id2.novell.com>
References: <4C7FB8CA0200007800013F51@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, cleanups: Use clear_page/copy_page rather than memset/memcpy
Message-ID: <tip-234bb549eea16ec7d5207ba747fb8dbf489e64c1@git.kernel.org>
Git-Commit-ID: 234bb549eea16ec7d5207ba747fb8dbf489e64c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Sep 2010 23:58:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  234bb549eea16ec7d5207ba747fb8dbf489e64c1
Gitweb:     http://git.kernel.org/tip/234bb549eea16ec7d5207ba747fb8dbf489e64c1
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 2 Sep 2010 13:46:34 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Sep 2010 15:36:49 -0700

x86, cleanups: Use clear_page/copy_page rather than memset/memcpy

When operating on whole pages, use clear_page() and copy_page() in
favor of memset() and memcpy(); after all that's what they are
intended for.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4C7FB8CA0200007800013F51@vpn.id2.novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/machine_kexec_64.c |    4 ++--
 arch/x86/kvm/lapic.c               |    3 +--
 arch/x86/mm/init_32.c              |    4 ++--
 arch/x86/mm/init_64.c              |    2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 035c8c5..b3ea9db 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -36,7 +36,7 @@ static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
 		if (!page)
 			goto out;
 		pud = (pud_t *)page_address(page);
-		memset(pud, 0, PAGE_SIZE);
+		clear_page(pud);
 		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
 	}
 	pud = pud_offset(pgd, addr);
@@ -45,7 +45,7 @@ static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
 		if (!page)
 			goto out;
 		pmd = (pmd_t *)page_address(page);
-		memset(pmd, 0, PAGE_SIZE);
+		clear_page(pmd);
 		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
 	}
 	pmd = pmd_offset(pud, addr);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 77d8c0f..22b06f7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1056,14 +1056,13 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 
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
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index bca7909..558f2d3 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
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
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9a66746..7c48ad4 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -293,7 +293,7 @@ static __ref void *alloc_low_page(unsigned long *phys)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
-	memset(adr, 0, PAGE_SIZE);
+	clear_page(adr);
 	*phys  = pfn * PAGE_SIZE;
 	return adr;
 }
