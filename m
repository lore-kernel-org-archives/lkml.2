Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab1DLBET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 21:04:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48241 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1DLBES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 21:04:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] vmscan: all_unreclaimable() use zone->all_unreclaimable as a name
Cc: kosaki.motohiro@jp.fujitsu.com, Andrey Vagin <avagin@openvz.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110411145324.ca790260.akpm@linux-foundation.org>
References: <20110411143128.0070.A69D9226@jp.fujitsu.com> <20110411145324.ca790260.akpm@linux-foundation.org>
Message-Id: <20110412100417.43F2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 12 Apr 2011 10:04:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > zone->all_unreclaimable and zone->pages_scanned are neigher atomic
> > variables nor protected by lock. Therefore zones can become a state
> > of zone->page_scanned=0 and zone->all_unreclaimable=1. In this case,
> > current all_unreclaimable() return false even though
> > zone->all_unreclaimabe=1.
> > 
> > Is this ignorable minor issue? No. Unfortunatelly, x86 has very
> > small dma zone and it become zone->all_unreclamble=1 easily. and
> > if it become all_unreclaimable=1, it never restore all_unreclaimable=0.
> > Why? if all_unreclaimable=1, vmscan only try DEF_PRIORITY reclaim and
> > a-few-lru-pages>>DEF_PRIORITY always makes 0. that mean no page scan
> > at all!
> > 
> > Eventually, oom-killer never works on such systems. That said, we
> > can't use zone->pages_scanned for this purpose. This patch restore
> > all_unreclaimable() use zone->all_unreclaimable as old. and in addition,
> > to add oom_killer_disabled check to avoid reintroduce the issue of
> > commit d1908362.
> 
> The above is a nice analysis of the bug and how it came to be
> introduced.  But we don't actually have a bug description!  What was
> the observeable problem which got fixed?

The above says "Eventually, oom-killer never works". Is this no enough?
The above says
  1) current logic have a race
  2) x86 increase a chance of the race by dma zone
  3) if race is happen, oom killer don't work

> 
> Such a description will help people understand the importance of the
> patch and will help people (eg, distros) who are looking at a user's
> bug report and wondering whether your patch will fix it.
> 



