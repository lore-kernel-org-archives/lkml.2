Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0DUCxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 22:53:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50590 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab0DUCxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 22:53:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 21 Apr 2010 11:49:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 01/14] mm,migration: Take a reference to the anon_vma
 before migrating
Message-Id: <20100421114920.ae4c45fd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1271797276-31358-2-git-send-email-mel@csn.ul.ie>
References: <1271797276-31358-1-git-send-email-mel@csn.ul.ie>
	<1271797276-31358-2-git-send-email-mel@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 22:01:03 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> rmap_walk_anon() does not use page_lock_anon_vma() for looking up and
> locking an anon_vma and it does not appear to have sufficient locking to
> ensure the anon_vma does not disappear from under it.
> 
> This patch copies an approach used by KSM to take a reference on the
> anon_vma while pages are being migrated.  This should prevent rmap_walk()
> running into nasty surprises later because anon_vma has been freed.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Hmm, a nitpick..


>  static inline struct anon_vma *page_anon_vma(struct page *page)
>  {
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 5938db5..b768a1d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -543,6 +543,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>  	int rcu_locked = 0;
>  	int charge = 0;
>  	struct mem_cgroup *mem = NULL;
> +	struct anon_vma *anon_vma = NULL;
>  
>  	if (!newpage)
>  		return -ENOMEM;
> @@ -599,6 +600,8 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>  	if (PageAnon(page)) {
>  		rcu_read_lock();
>  		rcu_locked = 1;
> +		anon_vma = page_anon_vma(page);
> +		atomic_inc(&anon_vma->migrate_refcount);
>  	}
>  
>  	/*
> @@ -638,6 +641,15 @@ skip_unmap:
>  	if (rc)
>  		remove_migration_ptes(page, page);
>  rcu_unlock:
> +
> +	/* Drop an anon_vma reference if we took one */
> +	if (anon_vma && atomic_dec_and_lock(&anon_vma->migrate_refcount, &anon_vma->lock)) {
> +		int empty = list_empty(&anon_vma->head);
> +		spin_unlock(&anon_vma->lock);
> +		if (empty)
> +			anon_vma_free(anon_vma);
> +	}
> +

Hmm. Can't we move this part to mm/rmap.c ?

	as
		anon_vma_drop_external_reference()
or some.

Thanks,
-Kame

