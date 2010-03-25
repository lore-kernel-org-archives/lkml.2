Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab0CYJ7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:59:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37536 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0CYJ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:59:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped anonymous pages
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100325184123.e3e3b009.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100325092131.GK2024@csn.ul.ie> <20100325184123.e3e3b009.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20100325185200.6C8C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 25 Mar 2010 18:59:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Kosaki-san,
> > > > 
> > > >  IIUC, the race in memory-hotunplug was fixed by this patch [2/11].
> > > > 
> > > >  But, this behavior of unmap_and_move() requires access to _freed_
> > > >  objects (spinlock). Even if it's safe because of SLAB_DESTROY_BY_RCU,
> > > >  it't not good habit in general.
> > > > 
> > > >  After direct compaction, page-migration will be one of "core" code of
> > > >  memory management. Then, I agree to patch [1/11] as our direction for
> > > >  keeping sanity and showing direction to more updates. Maybe adding
> > > >  refcnt and removing RCU in futuer is good.
> > > 
> > > But Christoph seems oppose to remove SLAB_DESTROY_BY_RCU. then refcount
> > > is meaningless now.
> > 
> > Christoph is opposed to removing it because of cache-hotness issues more
> > so than use-after-free concerns. The refcount is needed with or without
> > SLAB_DESTROY_BY_RCU.
> > 
> 
> I wonder a code which the easiest to be read will be like following.
> ==
> 
>         if (PageAnon(page)) {
>                 struct anon_vma anon = page_lock_anon_vma(page);
> 		/* to take this lock, this page must be mapped. */
> 		if (!anon_vma)
> 			goto uncharge;
> 		increase refcnt
> 		page_unlock_anon_vma(anon);
>         }
> 	....
> ==

This seems very good and acceptable to me. This refcnt usage
obviously reduce rcu-lock holding time.

I still think no refcount doesn't cause any disaster. but I agree
this is forward step patch.

thanks.


> and
> ==
> void anon_vma_free(struct anon_vma *anon)
> {
> 	/*
> 	 * To increase refcnt of anon-vma, anon_vma->lock should be held by
> 	 * page_lock_anon_vma(). It means anon_vma has a "mapped" page.
> 	 * If this anon is freed by unmap or exit, all pages under this anon
> 	 * must be unmapped. Then, just checking refcnt without lock is ok.
> 	 */
> 	if (check refcnt > 0)
> 		return do nothing
> 	kmem_cache_free(anon);
> }
> ==
> 
> Then, rcu_read_lock can be removed in clean way.
> 
> Thanks,
> -Kame
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



