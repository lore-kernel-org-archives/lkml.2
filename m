Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0CYKQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:16:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58724 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab0CYKQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:16:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 25 Mar 2010 19:12:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped
 anonymous pages
Message-Id: <20100325191229.8e3d2ba1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100325185200.6C8C.A69D9226@jp.fujitsu.com>
References: <20100325092131.GK2024@csn.ul.ie>
	<20100325184123.e3e3b009.kamezawa.hiroyu@jp.fujitsu.com>
	<20100325185200.6C8C.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 18:59:25 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > > > Kosaki-san,
> > > > > 
> > > > >  IIUC, the race in memory-hotunplug was fixed by this patch [2/11].
> > > > > 
> > > > >  But, this behavior of unmap_and_move() requires access to _freed_
> > > > >  objects (spinlock). Even if it's safe because of SLAB_DESTROY_BY_RCU,
> > > > >  it't not good habit in general.
> > > > > 
> > > > >  After direct compaction, page-migration will be one of "core" code of
> > > > >  memory management. Then, I agree to patch [1/11] as our direction for
> > > > >  keeping sanity and showing direction to more updates. Maybe adding
> > > > >  refcnt and removing RCU in futuer is good.
> > > > 
> > > > But Christoph seems oppose to remove SLAB_DESTROY_BY_RCU. then refcount
> > > > is meaningless now.
> > > 
> > > Christoph is opposed to removing it because of cache-hotness issues more
> > > so than use-after-free concerns. The refcount is needed with or without
> > > SLAB_DESTROY_BY_RCU.
> > > 
> > 
> > I wonder a code which the easiest to be read will be like following.
> > ==
> > 
> >         if (PageAnon(page)) {
> >                 struct anon_vma anon = page_lock_anon_vma(page);
> > 		/* to take this lock, this page must be mapped. */
> > 		if (!anon_vma)
> > 			goto uncharge;
> > 		increase refcnt
> > 		page_unlock_anon_vma(anon);
> >         }
> > 	....
> > ==
> 
> This seems very good and acceptable to me. This refcnt usage
> obviously reduce rcu-lock holding time.
> 
> I still think no refcount doesn't cause any disaster. but I agree
> this is forward step patch.
> 

BTW, by above change and the change in patch [2/11], 
"A page turnd to be SwapCache and free unmapped but not freed"
page will be never migrated.

Mel, could you change the check as this ??

	if (PageAnon(page)) {
		rcu_read_lock();
		if (!page_mapcount(page)) {
			rcu_read_unlock();
			if (!PageSwapCache(page))
				goto uncharge;
			/* unmapped swap cache can be migrated */
		} else {
			...
		}
	.....
	} else 


Thx,
-Kame


