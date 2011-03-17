Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1CQCbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:31:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60399 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1CQCbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:31:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D81727A.3010800@jp.fujitsu.com>
Date: Thu, 17 Mar 2011 11:31:22 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Lock the new THP when collapsing pages
References: <4D817234.9070106@jp.fujitsu.com>
In-Reply-To: <4D817234.9070106@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When collapsing pages, if the new THP is poisoned before it is
mapped to the APL, memory_failure() can do nothing except setting
the poison flag to the new THP, because it is not locked and not
mapped yet.

So lock the new THP to make sure that memory_failure() could
run after the poisoned new THP is mapped to APL successfully.
This can make sure the poisoned THP will give the smallest impact
to the system by killing the APL instead of panicking the system.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 mm/huge_memory.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 113e35c..e02f687 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1869,6 +1869,12 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 */
 	anon_vma_unlock(vma->anon_vma);
 
+	/*
+	 * Lock the new THP to block memory_failure until it is
+	 * mapped to the process.
+	 */
+	lock_page_nosync(new_page);
+
 	__collapse_huge_page_copy(pte, new_page, vma, address, ptl);
 	pte_unmap(pte);
 	__SetPageUptodate(new_page);
@@ -1900,6 +1906,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	*hpage = NULL;
 #endif
 	khugepaged_pages_collapsed++;
+	unlock_page(new_page);
 out_up_write:
 	up_write(&mm->mmap_sem);
 	return;
-- 
1.7.1


