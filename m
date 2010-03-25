Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0CYJJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:09:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35485 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab0CYJJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:09:37 -0400
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
In-Reply-To: <20100325180221.e1d9bae7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100325083235.GF2024@csn.ul.ie> <20100325180221.e1d9bae7.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20100325180726.6C89.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 25 Mar 2010 18:09:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 25 Mar 2010 08:32:35 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > On Thu, Mar 25, 2010 at 11:49:23AM +0900, KOSAKI Motohiro wrote:
> > > > On Fri, Mar 19, 2010 at 03:21:41PM +0900, KOSAKI Motohiro wrote: 
> > > Hmmm...
> > > I haven't understand your mention because I guess I was wrong.
> > > 
> > > probably my last question was unclear. I mean,
> > > 
> > > 1) If we still need SLAB_DESTROY_BY_RCU, why do we need to add refcount?
> > >     Which difference is exist between normal page migration and compaction?
> > 
> > The processes typically calling migration today own the page they are moving
> > and is not going to exit unexpectedly during migration.
> > 
> > > 2) If we added refcount, which race will solve?
> > > 
> > 
> > The process exiting and the last anon_vma being dropped while compaction
> > is running. This can be reliably triggered with compaction.
> > 
> > > IOW, Is this patch fix old issue or compaction specific issue?
> > > 
> > 
> > Strictly speaking, it's an old issue but in practice it's impossible to
> > trigger because the process migrating always owns the page. Compaction
> > moves pages belonging to arbitrary processes.
> > 
> Kosaki-san,
> 
>  IIUC, the race in memory-hotunplug was fixed by this patch [2/11].
> 
>  But, this behavior of unmap_and_move() requires access to _freed_
>  objects (spinlock). Even if it's safe because of SLAB_DESTROY_BY_RCU,
>  it't not good habit in general.
> 
>  After direct compaction, page-migration will be one of "core" code of
>  memory management. Then, I agree to patch [1/11] as our direction for
>  keeping sanity and showing direction to more updates. Maybe adding
>  refcnt and removing RCU in futuer is good.

But Christoph seems oppose to remove SLAB_DESTROY_BY_RCU. then refcount
is meaningless now. I agree you if we will remove SLAB_DESTROY_BY_RCU
in the future.

refcount is easy understanding than rcu trick.


>  IMHO, pushing this patch [2/11] as "BUGFIX" independent of this set and
>  adding anon_vma->refcnt [1/11] and [3/11] in 1st Direct-compaction patch
>  series  to show the direction will makse sense.
>  (I think merging 1/11 and 3/11 will be okay...)

agreed.

> 
> Thanks,
> -Kame
> 
> 



