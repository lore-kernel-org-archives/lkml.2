Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab1CRTvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:51:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44469 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab1CRTvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H1fCVeGQcufVv1iJizlemyG622DiQ+NoUsaJT0NWeX+vNoQACRXsxu+WTrnjwSVHWp
         yaENLoU33YaTKbwipj1YoIrJ5YZZZwtqZhZFKZIJni2TwM+SsptdP8wNPstldzcapX2x
         LI+poch8VmguHY6QqzOH0pxAmGXeQrm7HUVng=
Date: Fri, 18 Mar 2011 19:51:41 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: davem@davemloft.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, prasadjoshi124@gmail.com,
        mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 06/22] mm, sparc: add gfp flags variant of pmd
 and pte allocations
Message-ID: <20110318195141.GG4746@prasad-kvm>
References: <20110318194135.GA4746@prasad-kvm>
 <20110318194341.GB4746@prasad-kvm>
 <20110318194600.GC4746@prasad-kvm>
 <20110318194740.GD4746@prasad-kvm>
 <20110318194929.GE4746@prasad-kvm>
 <20110318195035.GF4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318195035.GF4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


32 bit architecture changes
 - Added a new marcos __pmd_alloc_one() which allow caller to pass the gfp_t
   allocation flag. The allocation flag is discarded, as the function
   pmd_alloc_one() does not allocate memory. The code for pte allocation is
   also modified the same way.

64 bit architecture changes
- Added function __pmd_alloc_one() to accept an additional allocation flag
  from caller. Similar to pmd_alloc_one() the function __pmd_alloc_one()
  calls quicklist_alloc() passing the allocation flag.

- pmd_alloc_one() calls __pmd_alloc_one().

- The similar changes are done for pte allocations.

- All these changes help in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/sparc/include/asm/pgalloc_32.h |    5 +++++
 arch/sparc/include/asm/pgalloc_64.h |   17 +++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/pgalloc_32.h b/arch/sparc/include/asm/pgalloc_32.h
index ca2b344..ad68597 100644
--- a/arch/sparc/include/asm/pgalloc_32.h
+++ b/arch/sparc/include/asm/pgalloc_32.h
@@ -41,6 +41,9 @@ BTFIXUPDEF_CALL(void, pgd_set, pgd_t *, pmd_t *)
 BTFIXUPDEF_CALL(pmd_t *, pmd_alloc_one, struct mm_struct *, unsigned long)
 #define pmd_alloc_one(mm, address)	BTFIXUP_CALL(pmd_alloc_one)(mm, address)
 
+BTFIXUPDEF_CALL(pmd_t *, __pmd_alloc_one, struct mm_struct *, unsigned long, gfp_t)
+#define __pmd_alloc_one(mm, address, gfp_mask)	BTFIXUP_CALL(pmd_alloc_one)(mm, address)
+
 BTFIXUPDEF_CALL(void, free_pmd_fast, pmd_t *)
 #define free_pmd_fast(pmd)	BTFIXUP_CALL(free_pmd_fast)(pmd)
 
@@ -57,6 +60,8 @@ BTFIXUPDEF_CALL(pgtable_t , pte_alloc_one, struct mm_struct *, unsigned long)
 #define pte_alloc_one(mm, address)	BTFIXUP_CALL(pte_alloc_one)(mm, address)
 BTFIXUPDEF_CALL(pte_t *, pte_alloc_one_kernel, struct mm_struct *, unsigned long)
 #define pte_alloc_one_kernel(mm, addr)	BTFIXUP_CALL(pte_alloc_one_kernel)(mm, addr)
+BTFIXUPDEF_CALL(pte_t *, __pte_alloc_one_kernel, struct mm_struct *, unsigned long, gfp_t)
+#define __pte_alloc_one_kernel(mm, addr, gfp_mask)	BTFIXUP_CALL(pte_alloc_one_kernel)(mm, addr)
 
 BTFIXUPDEF_CALL(void, free_pte_fast, pte_t *)
 #define pte_free_kernel(mm, pte)	BTFIXUP_CALL(free_pte_fast)(pte)
diff --git a/arch/sparc/include/asm/pgalloc_64.h b/arch/sparc/include/asm/pgalloc_64.h
index 5bdfa2c..a7952a5 100644
--- a/arch/sparc/include/asm/pgalloc_64.h
+++ b/arch/sparc/include/asm/pgalloc_64.h
@@ -26,9 +26,15 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 
 #define pud_populate(MM, PUD, PMD)	pud_set(PUD, PMD)
 
+static inline pmd_t *
+__pmd_alloc_one(struct mm_struct *mm, unsigned long addr, gfp_t gfp_mask)
+{
+	return quicklist_alloc(0, gfp_mask, NULL);
+}
+
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return quicklist_alloc(0, GFP_KERNEL, NULL);
+	return __pmd_alloc_one(mm, addr, GFP_KERNEL);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
@@ -36,10 +42,17 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 	quicklist_free(0, NULL, pmd);
 }
 
+static inline pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address, 
+		gfp_t gfp_mask)
+{
+	return quicklist_alloc(0, gfp_mask, NULL);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return quicklist_alloc(0, GFP_KERNEL, NULL);
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
-- 
1.7.0.4

