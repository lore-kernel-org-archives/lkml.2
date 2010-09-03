Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0ICVHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:07:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542Ab0ICVHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:07:19 -0400
Date: Fri, 3 Sep 2010 14:06:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>, Ying Han <yinghan@google.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no
 swap system
Message-Id: <20100903140649.09dee316.akpm@linux-foundation.org>
In-Reply-To: <1283096628-4450-1-git-send-email-minchan.kim@gmail.com>
References: <1283096628-4450-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 00:43:48 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Ying Han reported that backing aging of anon pages in no swap system
> causes unnecessary TLB flush.
> 
> When I sent a patch(69c8548175), I wanted this patch but Rik pointed out
> and allowed aging of anon pages to give a chance to promote from inactive
> to active LRU.
> 
> It has a two problem.
> 
> 1) non-swap system
> 
> Never make sense to age anon pages.
> 
> 2) swap configured but still doesn't swapon
> 
> It doesn't make sense to age anon pages until swap-on time.
> But it's arguable. If we have aged anon pages by swapon, VM have moved
> anon pages from active to inactive. And in the time swapon by admin,
> the VM can't reclaim hot pages so we can protect hot pages swapout.
> 
> But let's think about it. When does swap-on happen? It depends on admin.
> we can't expect it. Nonetheless, we have done aging of anon pages to
> protect hot pages swapout. It means we lost run time overhead when
> below high watermark but gain hot page swap-[in/out] overhead when VM
> decide swapout. Is it true? Let's think more detail.
> We don't promote anon pages in case of non-swap system. So even though
> VM does aging of anon pages, the pages would be in inactive LRU for a long
> time. It means many of pages in there would mark access bit again. So access
> bit hot/code separation would be pointless.
> 
> This patch prevents unnecessary anon pages demotion in not-swapon and
> non-configured swap system. Of course, it could make side effect that
> hot anon pages could swap out when admin does swap on.
> But I think sooner or later it would be steady state. 
> So it's not a big problem.
> We could lose someting but gain more thing(TLB flush and unnecessary 
> function call to demote anon pages). 
> 
> I used total_swap_pages because we want to age anon pages 
> even though swap full happens.

We don't have any quantitative data on the effect of these excess tlb
flushes, which makes it difficult to decide which kernel versions
should receive this patch.

Help?
