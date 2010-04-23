Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab0DWVg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:36:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab0DWVgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:36:54 -0400
Date: Fri, 23 Apr 2010 23:35:49 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of
 PageSwapCache  pages
Message-ID: <20100423213549.GV32034@random.random>
References: <20100422184621.0aaaeb5f.kamezawa.hiroyu@jp.fujitsu.com>
 <x2l28c262361004220313q76752366l929a8959cd6d6862@mail.gmail.com>
 <20100422193106.9ffad4ec.kamezawa.hiroyu@jp.fujitsu.com>
 <20100422195153.d91c1c9e.kamezawa.hiroyu@jp.fujitsu.com>
 <1271946226.2100.211.camel@barrios-desktop>
 <1271947206.2100.216.camel@barrios-desktop>
 <20100422154443.GD30306@csn.ul.ie>
 <20100423183135.GT32034@random.random>
 <20100423192311.GC14351@csn.ul.ie>
 <20100423193948.GU32034@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423193948.GU32034@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 09:39:48PM +0200, Andrea Arcangeli wrote:
> On Fri, Apr 23, 2010 at 08:23:12PM +0100, Mel Gorman wrote:
> > On Fri, Apr 23, 2010 at 08:31:35PM +0200, Andrea Arcangeli wrote:
> > > Hi Mel,
> > > 
> > > On Thu, Apr 22, 2010 at 04:44:43PM +0100, Mel Gorman wrote:
> > > > heh, I thought of a similar approach at the same time as you but missed
> > > > this mail until later. However, with this approach I suspect there is a
> > > > possibility that two walkers of the same anon_vma list could livelock if
> > > > two locks on the list are held at the same time. Am still thinking of
> > > > how it could be resolved without introducing new locking.
> > > 
> > > Trying to understand this issue and I've some questions. This
> > > vma_adjust and lock inversion troubles with the anon-vma lock in
> > > rmap_walk are a new issue introduced by the recent anon-vma changes,
> > > right?
> > > 
> > 
> > In a manner of speaking. There was no locking going on but prior to the
> > anon_vma changes, there would have been only one anon_vma lock and the
> > fix would be easier - just take the lock on anon_vma->lock while the
> > VMAs are being updated.
> 
> So it was very much a bug before too and we could miss to find some
> pte mapping the page if vm_start was adjusted?

Well I looked deeper into it myself as I wanted to have this bit (and
other bits) sorted out in aa.git, and definitely this is a bug
introduced by the newest anon-vma changes in 2.6.34-rc so aa.git
cannot be affected as it's using the 2.6.33 anon-vma (and prev) code.

vma_adjust already takes the anon_vma->lock and of course I also
further verified that trying to apply your snippet to vma_adjust
results in immediately deadlock as the very same lock is already taken
in my tree as it's the same anon-vma (simpler). So aa.git will be
immune from these bugs for now.
