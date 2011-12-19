Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1LST3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:29:43 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34925 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1LST3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:29:39 -0500
Date: Mon, 19 Dec 2011 11:29:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Daney <ddaney.cavm@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] mm: Fix BUILD_BUG assertion in
 pmdp_clear_flush_young()
In-Reply-To: <1324316288-2367-1-git-send-email-ddaney.cavm@gmail.com>
Message-ID: <alpine.DEB.2.00.1112191125320.19949@chino.kir.corp.google.com>
References: <20111217152253.1aedda0936cd5d1d98be5e76@canb.auug.org.au> <1324316288-2367-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> It has been reported that when building for sh:
> 
>     mm/pgtable-generic.c: In function 'pmdp_clear_flush_young':
>     mm/pgtable-generic.c:76: error: call to '__build_bug_failed' declared with attribute error: BUILD_BUG failed
> 
> Adding some ugle #ifdeffery will probably fix this issue.
> 

It won't, CONFIG_HUGETLB_PAGE has nothing at all to do with this.

> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
> 
> This is completely untested, but may be the best fix for this.  Linus
> and others have expressed a dislike for using BUG() to detect what
> should be dead code paths at runtime, but it seems to be the state of
> the art here.
> 

The problem here is that HPAGE_PMD_MASK is being referenced without 
CONFIG_TRANSPARENT_HUGEPAGE.  pmdp_clear_flush_young() is only applicable 
with that config option enabled.  So rather than trying to minimize lines 
captured under an #ifdef by placing the BUG() directly in the function for 
asm-generic, you'll need to wrap pmd_clear_flush_young() with 
#ifdef CONFIG_TRANSPARENT_HUGEPAGE and define its equivalent for 
CONFIG_TRANSPARENT_HUGEPAGE=n that breaks the build if not enabled.

>  mm/pgtable-generic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index eb663fb..73784c8 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -70,7 +70,7 @@ int pmdp_clear_flush_young(struct vm_area_struct *vma,
>  			   unsigned long address, pmd_t *pmdp)
>  {
>  	int young;
> -#ifndef CONFIG_TRANSPARENT_HUGEPAGE
> +#if !defined(CONFIG_HUGETLB_PAGE) || !defined(CONFIG_TRANSPARENT_HUGEPAGE)
>  	BUG();
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
