Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0IOMrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:47:33 -0400
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:52337 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454Ab0IOMrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:47:32 -0400
Date: Wed, 15 Sep 2010 13:47:12 +0100
From: Colin Watson <cjwatson@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86-64: fix mapping updates across pmd boundary
Message-ID: <20100915124712.GP21862@riva.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Originating-Smarthost02-IP: [82.69.40.219]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Dell Precision M4500 booted in UEFI mode shows the following warning
at boot:

[    0.040003] init_memory_mapping: 00000000bb5df000-00000000bb637000
[    0.046182] EFI: ioremap of 0xBB5DF000 failed!

The range in question corresponds to an entry in the UEFI memory map,
which is always aligned on 4096-byte pages but not necessarily any more
than that.  init_memory_mapping passes the start address to
kernel_physical_mapping_init which passes it on to phys_pud_update, etc.
phys_pud_init takes care that if the address crosses a pud boundary then
it's set to the start of the pud, but phys_pmd_init simply increased the
address by PMD_SIZE, which in this case meant that it would jump from
0xbb600000 to 0xbb7df000 and immediately stop since that was after the
end address, not setting any of the remaining pte entries.

Bringing phys_pmd_init into line with phys_pud_init fixes this.

Signed-off-by: Colin Watson <cjwatson@canonical.com>
---
 arch/x86/mm/init_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9a66746..2f386de 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -368,7 +368,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 
 	int i = pmd_index(address);
 
-	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
+	for (; i < PTRS_PER_PMD;
+	     i++, address = (address & PMD_MASK) + PMD_SIZE) {
 		unsigned long pte_phys;
 		pmd_t *pmd = pmd_page + pmd_index(address);
 		pte_t *pte;
-- 
1.7.1
