Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab0JZCzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:55:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab0JZCzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:55:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 28/43] MN10300: Use the [ID]PTEL2 registers rather than
 [ID]PTEL for TLB control
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:55:31 +0100
Message-ID: <20101026025531.23512.84445.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Use the [ID]PTEL2 registers rather than [ID]PTEL for TLB control as the bits
are a more suitable layout.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/cpu-regs.h |   19 +++++-----
 arch/mn10300/include/asm/pgtable.h  |   66 +++++++++++++++++++----------------
 arch/mn10300/mm/tlb-mn10300.S       |   27 ++++++++++----
 3 files changed, 65 insertions(+), 47 deletions(-)


diff --git a/arch/mn10300/include/asm/cpu-regs.h b/arch/mn10300/include/asm/cpu-regs.h
index 00e306c..90ed4a3 100644
--- a/arch/mn10300/include/asm/cpu-regs.h
+++ b/arch/mn10300/include/asm/cpu-regs.h
@@ -252,14 +252,6 @@ asm(" .am33_2\n");
 #define xPTEL_PS_4Mb		0x00000c00	/* - 4Mb page */
 #define xPTEL_PPN		0xfffff006	/* physical page number */
 
-#define xPTEL_V_BIT		0	/* bit numbers corresponding to above masks */
-#define xPTEL_UNUSED1_BIT	1
-#define xPTEL_UNUSED2_BIT	2
-#define xPTEL_C_BIT		3
-#define xPTEL_PV_BIT		4
-#define xPTEL_D_BIT		5
-#define xPTEL_G_BIT		9
-
 #define IPTEU			__SYSREG(0xc00000a4, u32)	/* instruction TLB virtual addr */
 #define DPTEU			__SYSREG(0xc00000b4, u32)	/* data TLB virtual addr */
 #define xPTEU_VPN		0xfffffc00	/* virtual page number */
@@ -283,7 +275,16 @@ asm(" .am33_2\n");
 #define xPTEL2_PS_128Kb		0x00000100	/* - 128Kb page */
 #define xPTEL2_PS_1Kb		0x00000200	/* - 1Kb page */
 #define xPTEL2_PS_4Mb		0x00000300	/* - 4Mb page */
-#define xPTEL2_PPN		0xfffffc00	/* physical page number */
+#define xPTEL2_CWT		0x00000400	/* cacheable write-through */
+#define xPTEL2_UNUSED1		0x00000800	/* unused bit (broadcast mask) */
+#define xPTEL2_PPN		0xfffff000	/* physical page number */
+
+#define xPTEL2_V_BIT		0	/* bit numbers corresponding to above masks */
+#define xPTEL2_C_BIT		1
+#define xPTEL2_PV_BIT		2
+#define xPTEL2_D_BIT		3
+#define xPTEL2_G_BIT		7
+#define xPTEL2_UNUSED1_BIT	11
 
 #define MMUFCR			__SYSREGC(0xc000009c, u32)	/* MMU exception cause */
 #define MMUFCR_IFC		__SYSREGC(0xc000009c, u16)	/* MMU instruction excep cause */
diff --git a/arch/mn10300/include/asm/pgtable.h b/arch/mn10300/include/asm/pgtable.h
index 16d8857..93c3294 100644
--- a/arch/mn10300/include/asm/pgtable.h
+++ b/arch/mn10300/include/asm/pgtable.h
@@ -98,38 +98,44 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pte_t kernel_vmalloc_ptes[(VMALLOC_END - VMALLOC_START) / PAGE_SIZE];
 #endif
 
-/* IPTEL/DPTEL bit assignments */
-#define _PAGE_BIT_VALID		xPTEL_V_BIT
-#define _PAGE_BIT_ACCESSED	xPTEL_UNUSED1_BIT	/* mustn't be loaded into IPTEL/DPTEL */
-#define _PAGE_BIT_NX		xPTEL_UNUSED2_BIT	/* mustn't be loaded into IPTEL/DPTEL */
-#define _PAGE_BIT_CACHE		xPTEL_C_BIT
-#define _PAGE_BIT_PRESENT	xPTEL_PV_BIT
-#define _PAGE_BIT_DIRTY		xPTEL_D_BIT
-#define _PAGE_BIT_GLOBAL	xPTEL_G_BIT
-
-#define _PAGE_VALID		xPTEL_V
-#define _PAGE_ACCESSED		xPTEL_UNUSED1
-#define _PAGE_NX		xPTEL_UNUSED2		/* no-execute bit */
-#define _PAGE_CACHE		xPTEL_C
-#define _PAGE_PRESENT		xPTEL_PV
-#define _PAGE_DIRTY		xPTEL_D
-#define _PAGE_PROT		xPTEL_PR
-#define _PAGE_PROT_RKNU		xPTEL_PR_ROK
-#define _PAGE_PROT_WKNU		xPTEL_PR_RWK
-#define _PAGE_PROT_RKRU		xPTEL_PR_ROK_ROU
-#define _PAGE_PROT_WKRU		xPTEL_PR_RWK_ROU
-#define _PAGE_PROT_WKWU		xPTEL_PR_RWK_RWU
-#define _PAGE_GLOBAL		xPTEL_G
-#define _PAGE_PSE		xPTEL_PS_4Mb		/* 4MB page */
-
-#define _PAGE_FILE		xPTEL_UNUSED1_BIT	/* set:pagecache unset:swap */
-
-#define __PAGE_PROT_UWAUX	0x040
-#define __PAGE_PROT_USER	0x080
-#define __PAGE_PROT_WRITE	0x100
+/* IPTEL2/DPTEL2 bit assignments */
+#define _PAGE_BIT_VALID		xPTEL2_V_BIT
+#define _PAGE_BIT_CACHE		xPTEL2_C_BIT
+#define _PAGE_BIT_PRESENT	xPTEL2_PV_BIT
+#define _PAGE_BIT_DIRTY		xPTEL2_D_BIT
+#define _PAGE_BIT_GLOBAL	xPTEL2_G_BIT
+#define _PAGE_BIT_ACCESSED	xPTEL2_UNUSED1_BIT	/* mustn't be loaded into IPTEL2/DPTEL2 */
+
+#define _PAGE_VALID		xPTEL2_V
+#define _PAGE_CACHE		xPTEL2_C
+#define _PAGE_PRESENT		xPTEL2_PV
+#define _PAGE_DIRTY		xPTEL2_D
+#define _PAGE_PROT		xPTEL2_PR
+#define _PAGE_PROT_RKNU		xPTEL2_PR_ROK
+#define _PAGE_PROT_WKNU		xPTEL2_PR_RWK
+#define _PAGE_PROT_RKRU		xPTEL2_PR_ROK_ROU
+#define _PAGE_PROT_WKRU		xPTEL2_PR_RWK_ROU
+#define _PAGE_PROT_WKWU		xPTEL2_PR_RWK_RWU
+#define _PAGE_GLOBAL		xPTEL2_G
+#define _PAGE_PS_MASK		xPTEL2_PS
+#define _PAGE_PS_4Kb		xPTEL2_PS_4Kb
+#define _PAGE_PS_128Kb		xPTEL2_PS_128Kb
+#define _PAGE_PS_1Kb		xPTEL2_PS_1Kb
+#define _PAGE_PS_4Mb		xPTEL2_PS_4Mb
+#define _PAGE_PSE		xPTEL2_PS_4Mb		/* 4MB page */
+#define _PAGE_CACHE_WT		xPTEL2_CWT
+#define _PAGE_ACCESSED		xPTEL2_UNUSED1
+#define _PAGE_NX		0			/* no-execute bit */
+
+/* If _PAGE_VALID is clear, we use these: */
+#define _PAGE_FILE		xPTEL2_C	/* set:pagecache unset:swap */
+#define _PAGE_PROTNONE		0x000		/* If not present */
+
+#define __PAGE_PROT_UWAUX	0x010
+#define __PAGE_PROT_USER	0x020
+#define __PAGE_PROT_WRITE	0x040
 
 #define _PAGE_PRESENTV		(_PAGE_PRESENT|_PAGE_VALID)
-#define _PAGE_PROTNONE		0x000	/* If not present */
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/mn10300/mm/tlb-mn10300.S b/arch/mn10300/mm/tlb-mn10300.S
index ccf6229..b994017 100644
--- a/arch/mn10300/mm/tlb-mn10300.S
+++ b/arch/mn10300/mm/tlb-mn10300.S
@@ -61,10 +61,16 @@ ENTRY(itlb_miss)
 	btst	_PAGE_VALID,d2
 	beq	itlb_miss_fault		# jump if doesn't point to a page
 					# (might be a swap id)
+#if	((_PAGE_ACCESSED & 0xffffff00) == 0)
 	bset	_PAGE_ACCESSED,(0,a2)
-	and	~(xPTEL_UNUSED1|xPTEL_UNUSED2),d2
+#elif	((_PAGE_ACCESSED & 0xffff00ff) == 0)
+	bset	+(_PAGE_ACCESSED >> 8),(1,a2)
+#else
+#error	"_PAGE_ACCESSED value is out of range"
+#endif
+	and	~xPTEL2_UNUSED1,d2
 itlb_miss_set:
-	mov	d2,(IPTEL)		# change the TLB
+	mov	d2,(IPTEL2)		# change the TLB
 #ifdef CONFIG_GDBSTUB
 	movm	(sp),[d2,d3,a2]
 #endif
@@ -118,10 +124,16 @@ ENTRY(dtlb_miss)
 	btst	_PAGE_VALID,d2
 	beq	dtlb_miss_fault		# jump if doesn't point to a page
 					# (might be a swap id)
+#if	((_PAGE_ACCESSED & 0xffffff00) == 0)
 	bset	_PAGE_ACCESSED,(0,a2)
-	and	~(xPTEL_UNUSED1|xPTEL_UNUSED2),d2
+#elif	((_PAGE_ACCESSED & 0xffff00ff) == 0)
+	bset	+(_PAGE_ACCESSED >> 8),(1,a2)
+#else
+#error	"_PAGE_ACCESSED value is out of range"
+#endif
+	and	~xPTEL2_UNUSED1,d2
 dtlb_miss_set:
-	mov	d2,(DPTEL)		# change the TLB
+	mov	d2,(DPTEL2)		# change the TLB
 #ifdef CONFIG_GDBSTUB
 	movm	(sp),[d2,d3,a2]
 #endif
@@ -156,13 +168,12 @@ ENTRY(itlb_aerror)
 	or	0x00010000,d1			# it's an instruction fetch
 
 	# determine the page address
-	mov	(IPTEU),a2
-	mov	a2,d0
+	mov	(IPTEU),d0
 	and	PAGE_MASK,d0
 	mov	d0,(12,sp)
 
 	clr	d0
-	mov	d0,(IPTEL)
+	mov	d0,(IPTEL2)
 
 	or	EPSW_IE,epsw
 	mov	fp,d0
@@ -199,7 +210,7 @@ ENTRY(dtlb_aerror)
 	mov	d0,(12,sp)
 
 	clr	d0
-	mov	d0,(DPTEL)
+	mov	d0,(DPTEL2)
 
 	or	EPSW_IE,epsw
 	mov	fp,d0

