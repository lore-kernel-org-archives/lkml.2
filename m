Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2KTPRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:17:19 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:60204 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab2KTPRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:17:13 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2012 10:17:12 EST
From: Daniel Kiper <daniel.kiper@oracle.com>
To: andrew.cooper3@citrix.com, ebiederm@xmission.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v2 02/11] x86/kexec: Add extra pointers to transition page table PGD, PUD, PMD and PTE
Date: Tue, 20 Nov 2012 16:04:44 +0100
Message-Id: <1353423893-23125-3-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.395697
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some implementations (e.g. Xen PVOPS) could not use part of identity page table
to construct transition page table. It means that they require separate PUDs,
PMDs and PTEs for virtual and physical (identity) mapping. To satisfy that
requirement add extra pointer to PGD, PUD, PMD and PTE and align existing code.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/include/asm/kexec.h       |   10 +++++++---
 arch/x86/kernel/machine_kexec_64.c |   12 ++++++------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 317ff17..3cf5600 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -157,9 +157,13 @@ struct kimage_arch {
 };
 #else
 struct kimage_arch {
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
+	pgd_t *pgd;
+	pud_t *pud0;
+	pud_t *pud1;
+	pmd_t *pmd0;
+	pmd_t *pmd1;
+	pte_t *pte0;
+	pte_t *pte1;
 };
 #endif
 
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index b3ea9db..976e54b 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -137,9 +137,9 @@ out:
 
 static void free_transition_pgtable(struct kimage *image)
 {
-	free_page((unsigned long)image->arch.pud);
-	free_page((unsigned long)image->arch.pmd);
-	free_page((unsigned long)image->arch.pte);
+	free_page((unsigned long)image->arch.pud0);
+	free_page((unsigned long)image->arch.pmd0);
+	free_page((unsigned long)image->arch.pte0);
 }
 
 static int init_transition_pgtable(struct kimage *image, pgd_t *pgd)
@@ -157,7 +157,7 @@ static int init_transition_pgtable(struct kimage *image, pgd_t *pgd)
 		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
 		if (!pud)
 			goto err;
-		image->arch.pud = pud;
+		image->arch.pud0 = pud;
 		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
 	}
 	pud = pud_offset(pgd, vaddr);
@@ -165,7 +165,7 @@ static int init_transition_pgtable(struct kimage *image, pgd_t *pgd)
 		pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
 		if (!pmd)
 			goto err;
-		image->arch.pmd = pmd;
+		image->arch.pmd0 = pmd;
 		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
 	}
 	pmd = pmd_offset(pud, vaddr);
@@ -173,7 +173,7 @@ static int init_transition_pgtable(struct kimage *image, pgd_t *pgd)
 		pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
 		if (!pte)
 			goto err;
-		image->arch.pte = pte;
+		image->arch.pte0 = pte;
 		set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
 	}
 	pte = pte_offset_kernel(pmd, vaddr);
-- 
1.5.6.5

