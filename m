Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab0FJBe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:34:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44576 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab0FJBe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:34:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Jun 2010 10:29:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
Message-Id: <20100610102959.ccbcfb32.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100610011035.GG5650@csn.ul.ie>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
	<20100609115211.435a45f7.kamezawa.hiroyu@jp.fujitsu.com>
	<20100609095200.GA5650@csn.ul.ie>
	<20100610093842.6a038ab0.kamezawa.hiroyu@jp.fujitsu.com>
	<20100610011035.GG5650@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 02:10:35 +0100
Mel Gorman <mel@csn.ul.ie> wrote:
> >   # mount -t cgroup none /cgroups -o memory
> >   # mkdir /cgroups/A
> >   # echo $$ > /cgroups/A
> >   # echo 300M > /cgroups/memory.limit_in_bytes
> >   # make -j 8 or make -j 16
> > 
> 
> That sort of scenario would be barely pushed by kernbench. For a single
> kernel build, it's about 250-400M depending on the .config but it's still
> a bit unreliable. Critically, it's not the sort of workload that would have
> lots of long-lived mappings that would hurt a workload a lot if it was being
> paged out.

You're right. An excuse for me is that my concern is usually the amount of
swap-out and OOM at rapid/heavy pressure comes because it's visible to
users easily. So, I use short-lived process test.

> Maybe it would be reasonable as a starting point but we'd have to be
> very careful of the stack usage figures? I'm leaning towards this
> approach to start with.
> 
> I'm preparing another release that takes my two most important patches
> about reclaim but also reduces usage in page relcaim (a combination of
> two previously released series). In combination, it might be ok for the
> memcg paths to reclaim pages from a stack perspective although the IO
> pattern might still blow.

sounds nice.

> > > I'm not sure how a flusher thread would work just within a cgroup. It
> > > would have to do a lot of searching to find the pages it needs
> > > considering that it's looking at inodes rather than pages.
> > > 
> >
> > yes. So, I(we) need some way for coloring inode for selectable writeback.
> > But people in this area are very nervous about performance (me too ;), I've
> > not found the answer yet.
> > 
> 
> I worry that too much targetting of writing back a specific inode would
> have other consequences.

I personally think this(writeback scheduling) is a job for I/O cgroup.
So, I guess what memcg can do is dirty-ratio-limiting, at most. The user has to
set well-balanced combination of memory+I/O cgroup.
Sorry for wrong mixture of story.


> > Okay, I'll consider about how to kick kswapd via memcg or flusher-for-memcg.
> > Please go ahead as you want. I love good I/O pattern, too.
> > 
> 
> For the moment, I'm strongly leaning towards allowing memcg to write
> back pages. The IO pattern might not be great, but it would be in line
> with current behaviour. The critical question is really "is it possible
> to overflow the stack?".
> 

Because I don't use XFS, I don't have relaiable answer, now. But, at least,
memcg's memory reclaim will never be called as top of do_select(), which
uses 1000 bytes. 

We have to consider long-term fix for I/O patterns under memmcg but
please global-reclaim-update-first. We did in that way when splitting LRU
to ANON and FILE. I don't want to make memcg as a burden for updating
vmscan.c better. 

Thanks,
-Kame

