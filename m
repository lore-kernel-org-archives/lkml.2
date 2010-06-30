Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab0F3Pzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:55:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab0F3Pzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:55:33 -0400
Date: Wed, 30 Jun 2010 17:55:06 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm] rmap: add exclusive page to private anon_vma on
 swapin
Message-ID: <20100630155506.GV16195@random.random>
References: <20100630113710.3b376e6a@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630113710.3b376e6a@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 11:37:10AM -0400, Rik van Riel wrote:
> @@ -2714,10 +2715,11 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
>  		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
>  		flags &= ~FAULT_FLAG_WRITE;
> +		exclusive = 1;
>  	}

Agreed. it's something I considered doing too but I deferred until I
figure out all the mess with ksm-copy. I'll test your patch but it
should make no practical difference to my workload.

I also had a patch in my queue that changes this path which I deferred
as well for now.

====
Subject: set VM_FAULT_WRITE in do_swap_page

From: Andrea Arcangeli <aarcange@redhat.com>

Set the flag if do_swap_page is decowing the page the same way do_wp_page would
too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/memory.c b/mm/memory.c
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2673,6 +2686,7 @@ static int do_swap_page(struct mm_struct
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		flags &= ~FAULT_FLAG_WRITE;
+		ret |= VM_FAULT_WRITE;
 	}
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
