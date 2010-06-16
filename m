Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab0FPAo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 20:44:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50848 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940Ab0FPAo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 20:44:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Jun 2010 09:39:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
Message-Id: <20100616093958.00673123.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C181AFD.5060503@redhat.com>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
	<1276514273-27693-13-git-send-email-mel@csn.ul.ie>
	<4C16A567.4080000@redhat.com>
	<20100615114510.GE26788@csn.ul.ie>
	<4C17815A.8080402@redhat.com>
	<20100615135928.GK26788@csn.ul.ie>
	<4C178868.2010002@redhat.com>
	<20100615141601.GL26788@csn.ul.ie>
	<20100616091755.7121c7d3.kamezawa.hiroyu@jp.fujitsu.com>
	<4C181AFD.5060503@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 20:29:49 -0400
Rik van Riel <riel@redhat.com> wrote:

> On 06/15/2010 08:17 PM, KAMEZAWA Hiroyuki wrote:
> > On Tue, 15 Jun 2010 15:16:01 +0100
> > Mel Gorman<mel@csn.ul.ie>  wrote:
> 
> >> But in turn, where is mem_cgroup_hierarchical_reclaim called from direct
> >> reclaim? It appears to be only called from the fault path or as a result
> >> of the memcg changing size.
> >>
> > yes. It's only called from
> > 	- page fault
> > 	- add_to_page_cache()
> >
> > I think we'll see no stack problem. Now, memcg doesn't wakeup kswapd for
> > reclaiming memory, it needs direct writeback.
> 
> Of course, a memcg page fault could still be triggered
> from copy_to_user or copy_from_user, with a fairly
> arbitrary stack frame above...
> 

Hmm. But I don't expect copy_from/to_user is called in very deep stack.

Should I prepare a thread for reclaiming memcg pages ?
Because we shouldn't limit kswapd's cpu time by CFS cgroup, waking up
kswapd just because "a memcg hit limits" isn't fun. 

Hmm, or do you recommend no-dirty-page-writeback when a memcg hits limit ?
Maybe we'll see much swaps.

I want to go with this for a while, changing memcg's behavior will took
some amounts of time, there are only a few developpers.

Thanks,
-Kame

