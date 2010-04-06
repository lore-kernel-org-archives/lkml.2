Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0DFIx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:53:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48186 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab0DFIxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:53:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
Cc: kosaki.motohiro@jp.fujitsu.com, Borislav Petkov <bp@alien8.de>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic> <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
Message-Id: <20100406173754.7E5A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Apr 2010 17:53:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I think this is likely due to the new scalable anon_vma linking by Rik. 
> Nothing else I can imagine should have introduced anything like it.
> 
> Rik: the picures have the information, but you need to look at several to 
> see both the oops and the backtrace. Here's a condensed version:
> 
>  shrink_all_memory ->
>    do_try_to_free_pages ->
>      shrink_zone ->
>        shrink_inactive_list ->
>          shrink_page_list ->
>            page_referenced
> 
> where page_referenced() oopses due page_referenced_anon() as per 
> Borislav's description below.
> 
> Added all the usual suspects to the Cc list. Left the full report appended 
> so that the new people don't have to search for it on lkml.

Today, I've reviewed this patch carefully. but I haven't found any bug.

1) anon_vma->list is alwasys protected anon_vma->lock.
2) If anyone forget to take lock, list_add() and/or list_del() never
   assign to NULL.

then, NULL mean either three possibility.

 a) we see uninitialized data
 b) we see after freed data
 c) we see memory corruption by another bug

but (a) can't happen because 

	static inline void __list_add()
	{
	        next->prev = new;
	        new->next = next;
	        new->prev = prev;
	        prev->next = new;  (*)
	}

If uninitialized var is linked to avc list, new->next was already !NULL.

(b) is also impossible. SLAB_DESTROY_BY_RCU delay the page for anon_vma 
freeing until next rcu period. It mean rcu_read_lock()+page_mapped() 
can see kfree()ed page. but it is safe. noone corrupt it.

now I doubt (c) ;-)



Also, I've runned stress workload with shrink_all_memory() today. but
I couldn't reproduce the issue. hmm..  (perhaps I'm no lucky guy. 
I'm frequently fail to reproduce)

I'll continue to work.


