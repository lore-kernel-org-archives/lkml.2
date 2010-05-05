Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab0EESFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:05:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756947Ab0EESFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:05:23 -0400
Date: Wed, 5 May 2010 11:02:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
In-Reply-To: <20100505175311.GU20979@csn.ul.ie>
Message-ID: <alpine.LFD.2.00.1005051058380.27218@i5.linux-foundation.org>
References: <1273065281-13334-1-git-send-email-mel@csn.ul.ie> <1273065281-13334-2-git-send-email-mel@csn.ul.ie> <alpine.LFD.2.00.1005050729000.5478@i5.linux-foundation.org> <20100505145620.GP20979@csn.ul.ie> <alpine.LFD.2.00.1005050815060.5478@i5.linux-foundation.org>
 <20100505175311.GU20979@csn.ul.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 May 2010, Mel Gorman wrote:
> 
> If the same_vma list is properly ordered then maybe something like the
> following is allowed?

Heh. This is the same logic I just sent out. However:

> +	anon_vma = page_rmapping(page);
> +	if (!anon_vma)
> +		return NULL;
> +
> +	spin_lock(&anon_vma->lock);

RCU should guarantee that this spin_lock() is valid, but:

> +	/*
> +	 * Get the oldest anon_vma on the list by depending on the ordering
> +	 * of the same_vma list setup by __page_set_anon_rmap
> +	 */
> +	avc = list_entry(&anon_vma->head, struct anon_vma_chain, same_anon_vma);

We're not guaranteed that the 'anon_vma->head' list is non-empty.

Somebody could have freed the list and the anon_vma and we have a stale 
'page->anon_vma' (that has just not been _released_ yet). 

And shouldn't that be 'list_first_entry'? Or &anon_vma->head.next?

How did that line actually work for you? Or was it just a "it boots", but 
no actual testing of the rmap walk?

			Linus
