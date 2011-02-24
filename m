Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab1BXWnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 17:43:16 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39784 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab1BXWnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 17:43:14 -0500
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>,
        aarcange@redhat.com
In-Reply-To: <1298425922-23630-9-git-send-email-andi@firstfloor.org>
References: <1298425922-23630-1-git-send-email-andi@firstfloor.org>
	 <1298425922-23630-9-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 24 Feb 2011 14:43:04 -0800
Message-ID: <1298587384.9138.23.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 17:52 -0800, Andi Kleen wrote:
> @@ -2286,6 +2290,9 @@ void __split_huge_page_pmd(struct mm_struct *mm, pmd_t *pmd)
>  		spin_unlock(&mm->page_table_lock);
>  		return;
>  	}
> +
> +	count_vm_event(THP_SPLIT);
> +
>  	page = pmd_page(*pmd);
>  	VM_BUG_ON(!page_count(page));
>  	get_page(page);

Hey Andi,

Your split counter tracks the split_huge_page_pmd() calls, but misses
plain split_huge_page() calls.  Did you do this on purpose?  Could we
move the counter in to the low-level split function like below?

---

 linux-2.6.git-dave/mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~move-THP_SPLIT mm/huge_memory.c
--- linux-2.6.git/mm/huge_memory.c~move-THP_SPLIT	2011-02-24 14:37:32.825288409 -0800
+++ linux-2.6.git-dave/mm/huge_memory.c	2011-02-24 14:39:01.767939971 -0800
@@ -1342,6 +1342,8 @@ static void __split_huge_page(struct pag
 	BUG_ON(!PageHead(page));
 	BUG_ON(PageTail(page));
 
+	count_vm_event(THP_SPLIT);
+
 	mapcount = 0;
 	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
 		struct vm_area_struct *vma = avc->vma;
@@ -2293,8 +2295,6 @@ void __split_huge_page_pmd(struct mm_str
 		return;
 	}
 
-	count_vm_event(THP_SPLIT);
-
 	page = pmd_page(*pmd);
 	VM_BUG_ON(!page_count(page));
 	get_page(page);

-- Dave

