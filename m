Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab1A0N4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:56:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:40627 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1A0N4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:56:17 -0500
Subject: Re: One (possible) x86 get_user_pages bug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Xiaowei Yang <xiaowei.yang@huawei.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Jan Beulich <JBeulich@novell.com>,
        Kenneth Lee <liguozhu@huawei.com>, wangzhenguo@huawei.com,
        linqaingmin <linqiangmin@huawei.com>, fanhenglong@huawei.com,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        Kaushik Barde <kbarde@huawei.com>
In-Reply-To: <4D416D9A.9010603@huawei.com>
References: <4D416D9A.9010603@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 14:56:58 +0100
Message-ID: <1296136618.15234.187.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 21:05 +0800, Xiaowei Yang wrote:
> 
> However, from the comments embedded in gup.c, it seems deliberate to 
> avoid the lock in the fast path. The question is: if so, how to avoid 
> the above scenario? 

Something like the below comes to mind... but I must say I haven't fully
considered the problem yet..

---
 arch/x86/mm/gup.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index dbe34b9..6527933 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -89,10 +89,11 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
 		}
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
-		get_page(page);
-		SetPageReferenced(page);
-		pages[*nr] = page;
-		(*nr)++;
+		if (get_page_unless_zero(page)) {
+			SetPageReferenced(page);
+			pages[*nr] = page;
+			(*nr)++;
+		}
 
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
 	pte_unmap(ptep - 1);

