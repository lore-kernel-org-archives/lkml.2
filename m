Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab1KQV5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:57:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37228 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab1KQV5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:57:37 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>, David Rientjes <rientjes@google.com>
Subject: [PATCH v2 2/2] hugetlb: Provide safer dummy values for HPAGE_MASK and HPAGE_SIZE
Date: Thu, 17 Nov 2011 13:57:30 -0800
Message-Id: <1321567050-13197-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

It was pointed out by David Rientjes that the dummy values for
HPAGE_MASK and HPAGE_SIZE are quite unsafe.  It they are inadvertently
used with !CONFIG_HUGETLB_PAGE, compilation would succeed, but the
resulting code would surly not do anything sensible.

Place BUG() in the these dummy definitions, as we do in similar
circumstances in other places, so any abuse can be easily detected.

Since the only sane place to use these symbols when
!CONFIG_HUGETLB_PAGE is on dead code paths, the BUG() cause any actual
code to be emitted by the compiler.

Cc: David Rientjes <rientjes@google.com>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/linux/hugetlb.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 380451c..3ed6dbd 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -111,8 +111,9 @@ static inline void copy_huge_page(struct page *dst, struct page *src)
 #define hugetlb_change_protection(vma, address, end, newprot)
 
 #ifndef HPAGE_MASK
-#define HPAGE_MASK	PAGE_MASK		/* Keep the compiler happy */
-#define HPAGE_SIZE	PAGE_SIZE
+/* Keep the compiler happy with some dummy (but BUGgy) values */
+#define HPAGE_MASK	({BUG(); 0; })
+#define HPAGE_SIZE	({BUG(); 0; })
 #define HPAGE_SHIFT	({BUG(); 0; })
 #endif
 
-- 
1.7.2.3

