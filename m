Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0IFAli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:41:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49806 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0IFAlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:41:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [PATCH 13/14] mm: mempolicy: Check return code of check_range
Cc: kosaki.motohiro@jp.fujitsu.com, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <1283711588-7628-1-git-send-email-segooon@gmail.com>
References: <1283711588-7628-1-git-send-email-segooon@gmail.com>
Message-Id: <20100906093610.C8B5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  6 Sep 2010 09:41:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Vasiliy Kulikov <segooon@gmail.com>
> 
> Function check_range may return ERR_PTR(...). Check for it.

When happen this issue?

afaik, check_range return error when following condition.
 1) mm->mmap->vm_start argument is incorrect
 2) don't have neigher MPOL_MF_STATS, MPOL_MF_MOVE and MPOL_MF_MOVE_ALL

I think both case is not happen in real. Am I overlooking anything?


> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  mm/mempolicy.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index f969da5..b73f02c 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -924,12 +924,15 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
>  	nodemask_t nmask;
>  	LIST_HEAD(pagelist);
>  	int err = 0;
> +	struct vm_area_struct *vma;
>  
>  	nodes_clear(nmask);
>  	node_set(source, nmask);
>  
> -	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
> +	vma = check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
>  			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
> +	if (IS_ERR(vma))
> +		return PTR_ERR(vma);
>  
>  	if (!list_empty(&pagelist))
>  		err = migrate_pages(&pagelist, new_node_page, dest, 0);
> -- 
> 1.7.0.4
> 



