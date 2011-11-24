Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab1KXJNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:13:22 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42837 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab1KXJNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:13:19 -0500
Date: Thu, 24 Nov 2011 10:13:12 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] mm: memcg: modify PageCgroupCache non-atomically
Message-ID: <20111124091312.GE6843@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-9-git-send-email-hannes@cmpxchg.org>
 <20111124091328.d28d9f55.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124091328.d28d9f55.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 09:13:28AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 23 Nov 2011 16:42:31 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > From: Johannes Weiner <jweiner@redhat.com>
> > 
> > This bit is protected by lock_page_cgroup(), there is no need for
> > locked operations when setting and clearing it.
> > 
> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> 
> Hm. non-atomic ops for pc->flags seems dangerous.
> How about try to remove PCG_CACHE ? Maybe we can depends on PageAnon(page).
> We see 'page' on memcg->lru now.
> I'm sorry I forgot why we needed PCG_CACHE flag..

The problem is that we charge/uncharged pages that are not fully
rmapped and so PageAnon() is not reliable.  I forgot if there are more
places, but the commit_charge in migration was a prominent one.

I have a patch set that reworks migration so to only commit pages that
are fully rmapped but it clashed with the THP patches and I didn't see
too much value to fix it up.  But I should probably revive it, because
it makes some things simpler.

As I replied to Hugh, it might even work for PCG_CACHE, but it's
definitely dangerous and not worth the complex dependencies it brings
on other parts of the code, so please consider 7/8 and 8/8 dropped.
