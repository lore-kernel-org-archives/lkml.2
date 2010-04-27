Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab0D0Afe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 20:35:34 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38724 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab0D0Afd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 20:35:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Apr 2010 09:31:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
Message-Id: <20100427093136.4de21a47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4BD63031.6050105@redhat.com>
References: <1272321478-28481-1-git-send-email-mel@csn.ul.ie>
	<1272321478-28481-3-git-send-email-mel@csn.ul.ie>
	<4BD63031.6050105@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 20:30:41 -0400
Rik van Riel <riel@redhat.com> wrote:

> On 04/26/2010 06:37 PM, Mel Gorman wrote:
> 
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 85f203e..bc313a6 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1368,15 +1368,31 @@ static int rmap_walk_anon(struct page *page, int (*rmap_one)(struct page *,
> >   	 * are holding mmap_sem. Users without mmap_sem are required to
> >   	 * take a reference count to prevent the anon_vma disappearing
> >   	 */
> > +retry:
> >   	anon_vma = page_anon_vma(page);
> >   	if (!anon_vma)
> >   		return ret;
> >   	spin_lock(&anon_vma->lock);
> >   	list_for_each_entry(avc,&anon_vma->head, same_anon_vma) {
> >   		struct vm_area_struct *vma = avc->vma;
> > -		unsigned long address = vma_address(page, vma);
> > -		if (address == -EFAULT)
> > -			continue;
> > +		unsigned long address;
> > +
> > +		/*
> > +		 * Guard against deadlocks by not spinning against
> > +		 * vma->anon_vma->lock. If contention is found, release our
> > +		 * lock and try again until VMA list can be traversed without
> > +		 * contention.
> > +		 */
> > +		if (anon_vma != vma->anon_vma) {
> > +			if (!spin_trylock(&vma->anon_vma->lock)) {
> > +				spin_unlock(&anon_vma->lock);
> > +				goto retry;
> > +			}
> > +		}
> 
> If you're part way down the list, surely you'll need to
> unlock multiple anon_vmas here before going to retry?
> 
vma->anon_vma->lock is released after vma_address().

-Kame

