Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1BCVgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:36:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935Ab1BCVgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:36:43 -0500
Date: Thu, 3 Feb 2011 13:36:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rohit Seth <rohit.seth@intel.com>
Subject: Re: [PATCH] Huge TLB: Potential NULL deref in
 arch/x86/mm/hugetlbpage.c:huge_pmd_share()
Message-Id: <20110203133624.cd353dd6.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1102032214350.1369@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102032142580.15101@swampdragon.chaosbits.net>
	<20110203130150.7031c61f.akpm@linux-foundation.org>
	<alpine.LNX.2.00.1102032214350.1369@swampdragon.chaosbits.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 22:17:53 +0100 (CET)
Jesper Juhl <jj@chaosbits.net> wrote:

> Document that NULL deref will never happen post find_vma() in 
> huge_pmd_share().
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  hugetlbpage.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
> index 069ce7c..7dd2d5f 100644
> --- a/arch/x86/mm/hugetlbpage.c
> +++ b/arch/x86/mm/hugetlbpage.c
> @@ -61,6 +61,11 @@ static int vma_shareable(struct vm_area_struct *vma, unsigned long addr)
>  static void huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
>  {
>  	struct vm_area_struct *vma = find_vma(mm, addr);
> +	/*
> +	 * There is no potential NULL deref here. mmap_sem is held and
> +	 * caller knows that the virtual address at `addr' is within a
> +	 * vma, so find_vma() will never return NULL here.
> +	 */
>  	struct address_space *mapping = vma->vm_file->f_mapping;
>  	pgoff_t idx = ((addr - vma->vm_start) >> PAGE_SHIFT) +
>  			vma->vm_pgoff;

Not really.

That mmap_sem is held and that `addr' refers to a known-to-be-present
VMA are part of huge_pmd_share()'s interface.  They are preconditions
which must be satisfied before the function can be used.

So they should be documented as such, in the function's documentation. 
In fact they're the *most important* thing to document about the
function because they are subtle and unobvious from the implementation
and from the function signature and name.

>From an understandability/maintainability POV the code is crap.  It's yet
another example of kernel developers' liking for pointing machine guns
at each other's feet.

Really, some poor schmuck needs to go in and reverse-engineer all the
secret interface requirements and document them.  But we shouldn't let
a chance go by - a nice kerneldoc description for huge_pmd_share()
would be appreciated.  One which documents both the explicit and the
implicit calling conventions.

