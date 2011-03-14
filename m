Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1CNIJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 04:09:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22733 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab1CNIJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 04:09:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=hQDiLGjc487qRz6VktNIEHLkiPKHtTUirBLgzgnmBxOYNGTV57EOM+vkAg4RIAMBiA
         WzVxgoGU0EfkJkJ7NZOA==
Date: Mon, 14 Mar 2011 01:08:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] thp+memcg-numa: fix BUG at include/linux/mm.h:370!
Message-ID: <alpine.LSU.2.00.1103140059510.1661@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

THP's collapse_huge_page() has an understandable but ugly difference
in when its huge page is allocated: inside if NUMA but outside if not.
It's hardly surprising that the memcg failure path forgot that, freeing
the page in the non-NUMA case, then hitting a VM_BUG_ON in get_page()
(or even worse, using the freed page).

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/huge_memory.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- 2.6.38-rc8/mm/huge_memory.c	2011-03-08 09:27:16.000000000 -0800
+++ linux/mm/huge_memory.c	2011-03-13 18:26:21.000000000 -0700
@@ -1762,6 +1762,10 @@ static void collapse_huge_page(struct mm
 #ifndef CONFIG_NUMA
 	VM_BUG_ON(!*hpage);
 	new_page = *hpage;
+	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
+		up_read(&mm->mmap_sem);
+		return;
+	}
 #else
 	VM_BUG_ON(*hpage);
 	/*
@@ -1781,12 +1785,12 @@ static void collapse_huge_page(struct mm
 		*hpage = ERR_PTR(-ENOMEM);
 		return;
 	}
-#endif
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 		up_read(&mm->mmap_sem);
 		put_page(new_page);
 		return;
 	}
+#endif
 
 	/* after allocating the hugepage upgrade to mmap_sem write mode */
 	up_read(&mm->mmap_sem);
