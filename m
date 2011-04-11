Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1DKVyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:54:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986Ab1DKVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:54:12 -0400
Date: Mon, 11 Apr 2011 14:53:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrey Vagin <avagin@openvz.org>, Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] vmscan: all_unreclaimable() use
 zone->all_unreclaimable as a name
Message-Id: <20110411145324.ca790260.akpm@linux-foundation.org>
In-Reply-To: <20110411143128.0070.A69D9226@jp.fujitsu.com>
References: <20110411142949.006C.A69D9226@jp.fujitsu.com>
	<20110411143128.0070.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 14:30:31 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> all_unreclaimable check in direct reclaim has been introduced at 2.6.19
> by following commit.
> 
> 	2006 Sep 25; commit 408d8544; oom: use unreclaimable info
> 
> And it went through strange history. firstly, following commit broke
> the logic unintentionally.
> 
> 	2008 Apr 29; commit a41f24ea; page allocator: smarter retry of
> 				      costly-order allocations
> 
> Two years later, I've found obvious meaningless code fragment and
> restored original intention by following commit.
> 
> 	2010 Jun 04; commit bb21c7ce; vmscan: fix do_try_to_free_pages()
> 				      return value when priority==0
> 
> But, the logic didn't works when 32bit highmem system goes hibernation
> and Minchan slightly changed the algorithm and fixed it .
> 
> 	2010 Sep 22: commit d1908362: vmscan: check all_unreclaimable
> 				      in direct reclaim path
> 
> But, recently, Andrey Vagin found the new corner case. Look,
> 
> 	struct zone {
> 	  ..
> 	        int                     all_unreclaimable;
> 	  ..
> 	        unsigned long           pages_scanned;
> 	  ..
> 	}
> 
> zone->all_unreclaimable and zone->pages_scanned are neigher atomic
> variables nor protected by lock. Therefore zones can become a state
> of zone->page_scanned=0 and zone->all_unreclaimable=1. In this case,
> current all_unreclaimable() return false even though
> zone->all_unreclaimabe=1.
> 
> Is this ignorable minor issue? No. Unfortunatelly, x86 has very
> small dma zone and it become zone->all_unreclamble=1 easily. and
> if it become all_unreclaimable=1, it never restore all_unreclaimable=0.
> Why? if all_unreclaimable=1, vmscan only try DEF_PRIORITY reclaim and
> a-few-lru-pages>>DEF_PRIORITY always makes 0. that mean no page scan
> at all!
> 
> Eventually, oom-killer never works on such systems. That said, we
> can't use zone->pages_scanned for this purpose. This patch restore
> all_unreclaimable() use zone->all_unreclaimable as old. and in addition,
> to add oom_killer_disabled check to avoid reintroduce the issue of
> commit d1908362.

The above is a nice analysis of the bug and how it came to be
introduced.  But we don't actually have a bug description!  What was
the observeable problem which got fixed?

Such a description will help people understand the importance of the
patch and will help people (eg, distros) who are looking at a user's
bug report and wondering whether your patch will fix it.

