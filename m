Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0CYJGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:06:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35349 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab0CYJGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:06:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 25 Mar 2010 18:02:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped
 anonymous pages
Message-Id: <20100325180221.e1d9bae7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100325083235.GF2024@csn.ul.ie>
References: <20100319152103.876F.A69D9226@jp.fujitsu.com>
	<20100319085949.GQ12388@csn.ul.ie>
	<20100325095349.944E.A69D9226@jp.fujitsu.com>
	<20100325083235.GF2024@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 08:32:35 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> On Thu, Mar 25, 2010 at 11:49:23AM +0900, KOSAKI Motohiro wrote:
> > > On Fri, Mar 19, 2010 at 03:21:41PM +0900, KOSAKI Motohiro wrote: 
> > Hmmm...
> > I haven't understand your mention because I guess I was wrong.
> > 
> > probably my last question was unclear. I mean,
> > 
> > 1) If we still need SLAB_DESTROY_BY_RCU, why do we need to add refcount?
> >     Which difference is exist between normal page migration and compaction?
> 
> The processes typically calling migration today own the page they are moving
> and is not going to exit unexpectedly during migration.
> 
> > 2) If we added refcount, which race will solve?
> > 
> 
> The process exiting and the last anon_vma being dropped while compaction
> is running. This can be reliably triggered with compaction.
> 
> > IOW, Is this patch fix old issue or compaction specific issue?
> > 
> 
> Strictly speaking, it's an old issue but in practice it's impossible to
> trigger because the process migrating always owns the page. Compaction
> moves pages belonging to arbitrary processes.
> 
Kosaki-san,

 IIUC, the race in memory-hotunplug was fixed by this patch [2/11].

 But, this behavior of unmap_and_move() requires access to _freed_
 objects (spinlock). Even if it's safe because of SLAB_DESTROY_BY_RCU,
 it't not good habit in general.

 After direct compaction, page-migration will be one of "core" code of
 memory management. Then, I agree to patch [1/11] as our direction for
 keeping sanity and showing direction to more updates. Maybe adding
 refcnt and removing RCU in futuer is good.

 IMHO, pushing this patch [2/11] as "BUGFIX" independent of this set and
 adding anon_vma->refcnt [1/11] and [3/11] in 1st Direct-compaction patch
 series  to show the direction will makse sense.
 (I think merging 1/11 and 3/11 will be okay...)

Thanks,
-Kame


