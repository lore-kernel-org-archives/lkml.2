Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab0CRAsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 20:48:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37871 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0CRAsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 20:48:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped anonymous pages
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100317115133.GG12388@csn.ul.ie>
References: <20100317104734.4C8E.A69D9226@jp.fujitsu.com> <20100317115133.GG12388@csn.ul.ie>
Message-Id: <20100318094720.872F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 18 Mar 2010 09:48:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +		/*
> > > +		 * If the page has no mappings any more, just bail. An
> > > +		 * unmapped anon page is likely to be freed soon but worse,
> > > +		 * it's possible its anon_vma disappeared between when
> > > +		 * the page was isolated and when we reached here while
> > > +		 * the RCU lock was not held
> > > +		 */
> > > +		if (!page_mapcount(page)) {
> > > +			rcu_read_unlock();
> > > +			goto uncharge;
> > > +		}
> > 
> > I haven't understand what prevent this check. Why don't we need following scenario?
> > 
> >  1. Page isolated for migration
> >  2. Passed this if (!page_mapcount(page)) check
> >  3. Process exits
> >  4. page_mapcount(page) drops to zero so anon_vma was no longer reliable
> > 
> > Traditionally, page migration logic is, it can touch garbarge of anon_vma, but
> > SLAB_DESTROY_BY_RCU prevent any disaster. Is this broken concept?
> 
> The check is made within the RCU read lock. If the count is positive at
> that point but goes to zero due to a process exiting, the anon_vma will
> still be valid until rcu_read_unlock() is called.

Thank you!

then, this logic depend on SLAB_DESTROY_BY_RCU, not refcount.
So, I think we don't need your [1/11] patch.

Am I missing something?


