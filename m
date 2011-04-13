Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab1DMSsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:48:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27491 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab1DMSsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:48:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=aBA0Xs90wJ3zkef9uk8ioRQaRjMfmzN7aOdTIzmaxGO1pi1iO40L8a6Nv9SmCxeP4V
         3StqaT5ho4ij85vAkGiA==
Date: Wed, 13 Apr 2011 11:48:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrey Vagin <avagin@openvz.org>, Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] vmscan: all_unreclaimable() use zone->all_unreclaimable
 as a name
In-Reply-To: <20110411143128.0070.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104131148030.5563@chino.kir.corp.google.com>
References: <20110411142949.006C.A69D9226@jp.fujitsu.com> <20110411143128.0070.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, KOSAKI Motohiro wrote:

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
> 
> Reported-by: Andrey Vagin <avagin@openvz.org>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>

Seems like it should be a candidate for stable inclusion as well, nice 
catch.
