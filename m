Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0L3Tuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:50:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39057 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0L3TuU (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 30 Dec 2010 14:50:20 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        <hpa@zytor.com>, Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/8] xen/mmu: Introduce IDENTITY_FRAME_BIT
Date: Thu, 30 Dec 2010 14:48:36 -0500
Message-Id: <1293738517-7287-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We tack on the IDENTITY_FRAME_BIT on all PFNs which have been
elected during the E820 parsing to be identity mapping.

This way, in case a freak occurs such that pfn_to_mfn(pfn)==pfn
for non-identity PFNs we can guard against that and not consider
it a 1-1 mapping.

Also this will allows us to leverage this and tack on _PAGE_IOMAP
on any page that has IDENTITY_FRAME_BIT set (see:
"xen/mmu: Set _PAGE_IOMAP if PFN is in identity P2M.").

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    6 +++++-
 arch/x86/xen/mmu.c              |   11 ++++++++---
 arch/x86/xen/setup.c            |    2 +-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index be671f6..a1e4ce8 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -30,6 +30,7 @@ typedef struct xpaddr {
 /**** MACHINE <-> PHYSICAL CONVERSION MACROS ****/
 #define INVALID_P2M_ENTRY	(~0UL)
 #define FOREIGN_FRAME_BIT	(1UL<<31)
+#define IDENTITY_FRAME_BIT	(1UL<<30)
 #define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
 
 /* Maximum amount of memory we can handle in a domain in pages */
@@ -52,9 +53,12 @@ static inline unsigned long pfn_to_mfn(unsigned long pfn)
 
 	mfn = get_phys_to_machine(pfn);
 
-	if (mfn != INVALID_P2M_ENTRY)
+	if (mfn != INVALID_P2M_ENTRY) {
 		mfn &= ~FOREIGN_FRAME_BIT;
 
+		if (mfn & IDENTITY_FRAME_BIT)
+			mfn &= ~IDENTITY_FRAME_BIT;
+	}
 	return mfn;
 }
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index d98bd43..d470435 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -425,10 +425,10 @@ unsigned long get_phys_to_machine(unsigned long pfn)
 	 * would be wrong.
 	 */
 	if (p2m_top[topidx] == p2m_mid_identity)
-		return pfn;
+		return pfn | IDENTITY_FRAME_BIT;
 
 	if (p2m_top[topidx][mididx] == p2m_identity)
-		return pfn;
+		return pfn | IDENTITY_FRAME_BIT;
 
 	return p2m_top[topidx][mididx][idx];
 }
@@ -546,7 +546,7 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	/* For sparse holes were the p2m leaf has real PFN along with
 	 * PCI holes, stick in the PFN as the MFN value.
 	 */
-	if (pfn == mfn) {
+	if (mfn != INVALID_P2M_ENTRY && (mfn & IDENTITY_FRAME_BIT)) {
 		if (p2m_top[topidx] == p2m_mid_identity)
 			return 1;
 		if (p2m_top[topidx][mididx] == p2m_identity)
@@ -2834,7 +2834,12 @@ static int p2m_dump_show(struct seq_file *m, void *v)
 		} else if (p2m_top[topidx][mididx] == p2m_identity) {
 			lvl = 1; type = TYPE_IDENTITY;
 		} else if (p2m_top[topidx][mididx][idx] == pfn) {
+			lvl = 2; type = TYPE_PFN;
+		} else if (p2m_top[topidx][mididx][idx] ==
+					(pfn | IDENTITY_FRAME_BIT)) {
 			lvl = 2; type = TYPE_IDENTITY;
+		} else if (p2m_top[topidx][mididx][idx] != pfn) {
+			lvl = 2; type = TYPE_PFN;
 		} else if (p2m_top[topidx] == NULL) {
 			lvl = 0; type = TYPE_UNKN;
 		} else if (p2m_top[topidx][mididx] == NULL) {
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 643b3fc..35b3b4d 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -168,7 +168,7 @@ static unsigned long __init xen_set_identity(const struct e820map *e820)
 		}
 
 		for (pfn = PFN_UP(last); pfn < PFN_DOWN(end); pfn++)
-			__set_phys_to_machine(pfn, pfn);
+			__set_phys_to_machine(pfn, pfn | IDENTITY_FRAME_BIT);
 		identity += pfn - PFN_UP(last);
 
 		last = end;
-- 
1.7.1

