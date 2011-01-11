Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1AKVnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:43:14 -0500
Received: from smtp-out.google.com ([216.239.44.51]:13165 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1AKVnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:43:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Q7EGpX+vADWpnN9oQilObbK2wHRdgw2v8PeA7XlCIGqmG9xCkiOAmiPZwOO2vWkcmz
         6hcbKc/7d0RuEV/nxGHQ==
Date: Tue, 11 Jan 2011 13:43:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: linux-kernel@vger.kernel.org
cc: mm-commits@vger.kernel.org, akpm@linux-foundation.org, hughd@google.com,
        mel@csn.ul.ie
Subject: Re: + mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
 added to -mm tree
In-Reply-To: <201101112046.p0BKk2Js005902@imap1.linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1101111341590.7551@chino.kir.corp.google.com>
References: <201101112046.p0BKk2Js005902@imap1.linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011, akpm@linux-foundation.org wrote:

> diff -puN mm/page_alloc.c~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix mm/page_alloc.c
> --- a/mm/page_alloc.c~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix
> +++ a/mm/page_alloc.c
> @@ -1815,15 +1815,15 @@ __alloc_pages_direct_compact(gfp_t gfp_m
>  	int migratetype, unsigned long *did_some_progress)
>  {
>  	struct page *page;
> -	struct task_struct *p = current;
> +	struct task_struct *tsk = current;
>  
>  	if (!order || compaction_deferred(preferred_zone))
>  		return NULL;
>  
> -	p->flags |= PF_MEMALLOC;
> +	tsk->flags |= PF_MEMALLOC;
>  	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
>  								nodemask);
> -	p->flags &= ~PF_MEMALLOC;
> +	tsk->flags &= ~PF_MEMALLOC;
>  	if (*did_some_progress != COMPACT_SKIPPED) {
>  
>  		/* Page migration frees to the PCP lists but we want merging */

This could be done for all of the page allocator functions in 
mm/page_alloc.c, I think it would be inconsistent and slightly harder to 
read if it were done in only one.
