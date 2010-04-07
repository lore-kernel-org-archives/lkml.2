Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0DGAGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:06:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932085Ab0DGAGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:06:18 -0400
Date: Tue, 6 Apr 2010 17:05:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 03/14] mm: Share the anon_vma ref counts between KSM and
 page migration
Message-Id: <20100406170528.ecb30941.akpm@linux-foundation.org>
In-Reply-To: <1270224168-14775-4-git-send-email-mel@csn.ul.ie>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
	<1270224168-14775-4-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Apr 2010 17:02:37 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> For clarity of review, KSM and page migration have separate refcounts on
> the anon_vma. While clear, this is a waste of memory. This patch gets
> KSM and page migration to share their toys in a spirit of harmony.
> 
> ...
>
> @@ -26,11 +26,17 @@
>   */
>  struct anon_vma {
>  	spinlock_t lock;	/* Serialize access to vma list */
> -#ifdef CONFIG_KSM
> -	atomic_t ksm_refcount;
> -#endif
> -#ifdef CONFIG_MIGRATION
> -	atomic_t migrate_refcount;
> +#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
> +
> +	/*
> +	 * The external_refcount is taken by either KSM or page migration
> +	 * to take a reference to an anon_vma when there is no
> +	 * guarantee that the vma of page tables will exist for
> +	 * the duration of the operation. A caller that takes
> +	 * the reference is responsible for clearing up the
> +	 * anon_vma if they are the last user on release
> +	 */
> +	atomic_t external_refcount;
>  #endif

hah.

> @@ -653,7 +653,7 @@ skip_unmap:
>  rcu_unlock:
>  
>  	/* Drop an anon_vma reference if we took one */
> -	if (anon_vma && atomic_dec_and_lock(&anon_vma->migrate_refcount, &anon_vma->lock)) {
> +	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->lock)) {
>  		int empty = list_empty(&anon_vma->head);
>  		spin_unlock(&anon_vma->lock);
>  		if (empty)

So we now _do_ test ksm_refcount.  Perhaps that fixed a bug added in [1/14]

> diff --git a/mm/rmap.c b/mm/rmap.c
> index 578d0fe..af35b75 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -248,8 +248,7 @@ static void anon_vma_unlink(struct anon_vma_chain *anon_vma_chain)
>  	list_del(&anon_vma_chain->same_anon_vma);
>  
>  	/* We must garbage collect the anon_vma if it's empty */
> -	empty = list_empty(&anon_vma->head) && !ksm_refcount(anon_vma) &&
> -					!migrate_refcount(anon_vma);
> +	empty = list_empty(&anon_vma->head) && !anonvma_external_refcount(anon_vma);
>  	spin_unlock(&anon_vma->lock);
>  
>  	if (empty)
> @@ -273,8 +272,7 @@ static void anon_vma_ctor(void *data)
>  	struct anon_vma *anon_vma = data;
>  
>  	spin_lock_init(&anon_vma->lock);
> -	ksm_refcount_init(anon_vma);
> -	migrate_refcount_init(anon_vma);
> +	anonvma_external_refcount_init(anon_vma);

What a mouthful.  Can we do s/external_//g?
