Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab1CRUJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:09:46 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54840 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab1CRUJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h6NtFuro5mheMQ/tsMNcxBqvKkQjleG6XoqRWheviiKSPHgIB8FQ9MdMUubKrAXN3k
         TVnGLxEA4Nomd+wTFawgG1oRYL6GccNCRvKSvNWt+4I/pG3dJHXwobHsR5S/ZX7NU8RZ
         Q0zHQ7cay3uq4XdnrRU/k2mleBg5iyIbCt9fk=
Date: Fri, 18 Mar 2011 20:10:21 +0000
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: rth@twiddle.net, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        prasadjoshi124@gmail.com, mitra@kqinfotech.com
Subject: Re: [RFC][PATCH v3 22/22] mm, alpha: add gfp flags variant of pmd
 and pte allocations
Message-ID: <20110318201021.GW4746@prasad-kvm>
References: <20110318200045.GM4746@prasad-kvm>
 <20110318200150.GN4746@prasad-kvm>
 <20110318200254.GO4746@prasad-kvm>
 <20110318200401.GP4746@prasad-kvm>
 <20110318200452.GQ4746@prasad-kvm>
 <20110318200547.GR4746@prasad-kvm>
 <20110318200638.GS4746@prasad-kvm>
 <20110318200731.GT4746@prasad-kvm>
 <20110318200825.GU4746@prasad-kvm>
 <20110318200922.GV4746@prasad-kvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318200922.GV4746@prasad-kvm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - Added __pmd_alloc_one, __pte_alloc_one_kernel to allocate pages using specified GFP flag
 - changed pmd_alloc_one, pte_alloc_one_kernel to call these newly added function using GFP_KERNEL
 - helps in fixing the Bug 30702

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
---
 arch/alpha/include/asm/pgalloc.h |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/include/asm/pgalloc.h b/arch/alpha/include/asm/pgalloc.h
index bc2a0da..81281ac 100644
--- a/arch/alpha/include/asm/pgalloc.h
+++ b/arch/alpha/include/asm/pgalloc.h
@@ -38,10 +38,15 @@ pgd_free(struct mm_struct *mm, pgd_t *pgd)
 }
 
 static inline pmd_t *
+__pmd_alloc_one(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
+{
+	return (pmd_t *)__get_free_page(gfp_mask | __GFP_ZERO);
+}
+
+static inline pmd_t *
 pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *ret = (pmd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
-	return ret;
+	return __pmd_alloc_one(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }
 
 static inline void
@@ -51,10 +56,15 @@ pmd_free(struct mm_struct *mm, pmd_t *pmd)
 }
 
 static inline pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address, gfp_t gfp_mask)
+{
+	return (pte_t *)__get_free_page(gfp_mask | __GFP_ZERO);
+}
+
+static inline pte_t *
 pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
-	return pte;
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }
 
 static inline void
-- 
1.7.0.4

