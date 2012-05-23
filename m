Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839Ab2EWLqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:46:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab2EWLqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:46:31 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix NULL ptr deref when walking hugepages
Date: Wed, 23 May 2012 07:46:21 -0400
Message-Id: <1337773581-14372-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1337757643-18302-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:20:43AM +0200, Sasha Levin wrote:
> A missing vlidation of the value returned by find_vma() could cause a NULL ptr
> dereference when walking the pagetable.
> 
> This is triggerable from usermode by a simple user by trying to read a
> page info out of /proc/pid/pagemap which doesn't exist.
> 
> Introduced by commit 025c5b24 ("thp: optimize away unnecessary page table
> locking").
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  fs/proc/task_mmu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 3e564f0..885830b 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -820,7 +820,7 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  
>  	/* find the first VMA at or above 'addr' */
>  	vma = find_vma(walk->mm, addr);
> -	if (pmd_trans_huge_lock(pmd, vma) == 1) {
> +	if (vma && pmd_trans_huge_lock(pmd, vma) == 1) {
>  		for (; addr != end; addr += PAGE_SIZE) {
>  			unsigned long offset;
>  
> -- 

Thank you. I have no objection.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
