Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1DLBXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 21:23:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947Ab1DLBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 21:23:39 -0400
Date: Mon, 11 Apr 2011 18:26:06 -0700
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
Message-Id: <20110411182606.016f9486.akpm@linux-foundation.org>
In-Reply-To: <20110412100417.43F2.A69D9226@jp.fujitsu.com>
References: <20110411143128.0070.A69D9226@jp.fujitsu.com>
	<20110411145324.ca790260.akpm@linux-foundation.org>
	<20110412100417.43F2.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 10:04:15 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> > > zone->all_unreclaimable and zone->pages_scanned are neigher atomic
> > > variables nor protected by lock. Therefore zones can become a state
> > > of zone->page_scanned=0 and zone->all_unreclaimable=1. In this case,
> > > current all_unreclaimable() return false even though
> > > zone->all_unreclaimabe=1.
> > > 
> > > Is this ignorable minor issue? No. Unfortunatelly, x86 has very
> > > small dma zone and it become zone->all_unreclamble=1 easily. and
> > > if it become all_unreclaimable=1, it never restore all_unreclaimable=0.
> > > Why? if all_unreclaimable=1, vmscan only try DEF_PRIORITY reclaim and
> > > a-few-lru-pages>>DEF_PRIORITY always makes 0. that mean no page scan
> > > at all!
> > > 
> > > Eventually, oom-killer never works on such systems. That said, we
> > > can't use zone->pages_scanned for this purpose. This patch restore
> > > all_unreclaimable() use zone->all_unreclaimable as old. and in addition,
> > > to add oom_killer_disabled check to avoid reintroduce the issue of
> > > commit d1908362.
> > 
> > The above is a nice analysis of the bug and how it came to be
> > introduced.  But we don't actually have a bug description!  What was
> > the observeable problem which got fixed?
> 
> The above says "Eventually, oom-killer never works". Is this no enough?
> The above says
>   1) current logic have a race
>   2) x86 increase a chance of the race by dma zone
>   3) if race is happen, oom killer don't work

And the system hangs up, so it's a local DoS and I guess we should
backport the fix into -stable.  I added this:

: This resulted in the kernel hanging up when executing a loop of the form
: 
: 1. fork
: 2. mmap
: 3. touch memory
: 4. read memory
: 5. munmmap
: 
: as described in
: http://www.gossamer-threads.com/lists/linux/kernel/1348725#1348725

And the problems which the other patches in this series address are
pretty deadly as well.  Should we backport everything?


