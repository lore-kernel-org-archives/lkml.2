Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1BNJZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 04:25:37 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:53457 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1BNJZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 04:25:34 -0500
Date: Sun, 13 Feb 2011 23:03:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/3] Provide control over unmapped pages (v4)
Message-ID: <20110213173336.GC23919@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110125051003.13762.35120.stgit@localhost6.localdomain6>
 <20110125051015.13762.13429.stgit@localhost6.localdomain6>
 <AANLkTikHLw0Qg+odOB-bDtBSB-5UbTJ5ZOM-ZAdMqXgh@mail.gmail.com>
 <AANLkTi=qXsDjN5Jp4m3QMgVnckoAM7uE9_Hzn6CajP+c@mail.gmail.com>
 <AANLkTinfxXc04S9VwQcJ9thFff=cP=icroaiVLkN-GeH@mail.gmail.com>
 <20110128064851.GB5054@balbir.in.ibm.com>
 <AANLkTikw_j0JJVqEsj1xThoashiOARg+8BgcLKrvkV3U@mail.gmail.com>
 <20110128111833.GD5054@balbir.in.ibm.com>
 <AANLkTin4JM6phwy0wuV6fV-i-3UwP_GGmXh1vN=Wz2u=@mail.gmail.com>
 <AANLkTi=hhKJGXwe1OyFsGF9StLJnYFX+QqUpNLXmfVc=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTi=hhKJGXwe1OyFsGF9StLJnYFX+QqUpNLXmfVc=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* MinChan Kim <minchan.kim@gmail.com> [2011-02-10 14:41:44]:

> I don't know why the part of message is deleted only when I send you.
> Maybe it's gmail bug.
> 
> I hope mail sending is successful in this turn. :)
> 
> On Thu, Feb 10, 2011 at 2:33 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> > Sorry for late response.
> >
> > On Fri, Jan 28, 2011 at 8:18 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >> * MinChan Kim <minchan.kim@gmail.com> [2011-01-28 16:24:19]:
> >>
> >>> >
> >>> > But the assumption for LRU order to change happens only if the page
> >>> > cannot be successfully freed, which means it is in some way active..
> >>> > and needs to be moved no?
> >>>
> >>> 1. holded page by someone
> >>> 2. mapped pages
> >>> 3. active pages
> >>>
> >>> 1 is rare so it isn't the problem.
> >>> Of course, in case of 3, we have to activate it so no problem.
> >>> The problem is 2.
> >>>
> >>
> >> 2 is a problem, but due to the size aspects not a big one. Like you
> >> said even lumpy reclaim affects it. May be the reclaim code could
> >> honour may_unmap much earlier.
> >
> > Even if it is, it's a trade-off to get a big contiguous memory. I
> > don't want to add new mess. (In addition, lumpy is weak by compaction
> > as time goes by)
> > What I have in mind for preventing LRU ignore is that put the page
> > into original position instead of head of lru. Maybe it can help the
> > situation both lumpy and your case. But it's another story.
> >
> > How about the idea?
> >
> > I borrow the idea from CFLRU[1]
> > - PCFLRU(Page-Cache First LRU)
> >
> > When we allocates new page for page cache, we adds the page into LRU's tail.
> > When we map the page cache into page table, we rotate the page into LRU's head.
> >
> > So, inactive list's result is following as.
> >
> > M.P : mapped page
> > N.P : none-mapped page
> >
> > HEAD-M.P-M.P-M.P-M.P-N.P-N.P-N.P-N.P-N.P-TAIL
> >
> > Admin can set threshold window size which determines stop reclaiming
> > none-mapped page contiguously.
> >
> > I think it needs some tweak of page cache/page mapping functions but
> > we can use kswapd/direct reclaim without change.
> >
> > Also, it can change page reclaim policy totally but it's just what you
> > want, I think.
> >

I am not sure how this would work, moreover the idea behind
min_unmapped_pages is to keep sufficient unmapped pages around for the
FS metadata and has been working with the existing code for zone
reclaim. What you propose is more drastic re-org of the LRU and I am
not sure I have the apetite for it.

-- 
	Three Cheers,
	Balbir
