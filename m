Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1CNRcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:32:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53101 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1CNRcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:32:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=cIn8ePQji/sgnI0A4V7LwyxD+1vl/RBe5hs7s207hBv8rqb8j1rEeZOCzvIj9TjH8l
         wCowYjuxVaaYyVE4hUXebQWYLr7539Bs2qSimnQTVAj1PsHGSMh8V8d+x/hPCd4GGMQn
         yd4xRbauWUg+ThyX0taVFDVnCf/0p95cgHEIE=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 17:32:00 +0000
Message-ID: <AANLkTi=_nh6k03=1FX9rO4KAQ1MbfCvGPT-0t0AURHCe@mail.gmail.com>
Subject: [RFC][PATCH v2 03/23] (avr32) __vmalloc: add gfp flags variant of pte
 and pmd allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__vmalloc: propagating GFP allocation flag.

- adds functions to allow caller to pass the GFP flag for memory allocation
- helps in fixing the Bug 30702 (__vmalloc(GFP_NOFS) can callback
		  file system evict_inode).

Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
---
Chnagelog:
arch/avr32/include/asm/pgalloc.h |    8 +++++++-
1 files changed, 7 insertions(+), 1 deletions(-)
---
diff --git a/arch/avr32/include/asm/pgalloc.h b/arch/avr32/include/asm/pgalloc.h
index bc7e8ae..cb88080 100644
--- a/arch/avr32/include/asm/pgalloc.h
+++ b/arch/avr32/include/asm/pgalloc.h
@@ -51,10 +51,16 @@ static inline void pgd_free(struct mm_struct *mm,
pgd_t *pgd)
 	quicklist_free(QUICK_PGD, NULL, pgd);
 }

+static inline pte_t *__pte_alloc_one_kernel(struct mm_struct *mm,
+					  unsigned long address, gfp_t gfp_mask)
+{
+	return quicklist_alloc(QUICK_PT, gfp_mask, NULL);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return quicklist_alloc(QUICK_PT, GFP_KERNEL | __GFP_REPEAT, NULL);
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }

 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
