Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab2AXDI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:08:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36860 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab2AXDI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 22:08:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Jan 2012 12:07:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Arun Sharma <asharma@fb.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Balbir Singh <bsingharora@gmail.com>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
Message-Id: <20120124120704.3f09b206.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4F1E013E.9060009@fb.com>
References: <1326912662-18805-1-git-send-email-asharma@fb.com>
	<20120119114206.653b88bd.kamezawa.hiroyu@jp.fujitsu.com>
	<4F1E013E.9060009@fb.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 16:54:22 -0800
Arun Sharma <asharma@fb.com> wrote:

> On 1/18/12 6:42 PM, KAMEZAWA Hiroyuki wrote:
> >
> > Hmm, then,
> > 1. a new task jumped into this cgroup can see any uncleared data...
> > 2. if a memcg pointer is reused, the information will be leaked.
> 
> You're suggesting mm_match_cgroup() is good enough for accounting 
> purposes, but not usable for cases where its important to get the 
> equality right?
> 

I think there is no 100% solution to check reuse of object.



> > 3. If VM_UNINITALIZED is set, the process can see any data which
> >     was freed by other process which doesn't know VM_UNINITALIZED at all.
> >
> > 4. The process will be able to see file cache data which the it has no
> >     access right if it's accessed by memcg once.
> >
> > 3&  4 seems too danger.
> 
> Yes - these are the risks that I'm hoping we can document, so the 
> cgroups admin can avoid opting-in if not everything running in the 
> cgroup is trusted.
> 

I guess admins/users can't handle that.

> >
> > Isn't it better to have this as per-task rather than per-memcg ?
> > And just allow to reuse pages the page has freed ?
> >
> 
> I'm worrying that the additional complexity of maintaining a per-task 
> page list would be a problem. It might slow down workloads that 
> alloc/free a lot because of the added code. It'll probably touch the 
> kswapd as well (for reclaiming pages from the per-task free lists under 
> low mem conditions).
> 
> Did you have some implementation ideas which would not have the problems 
> above?
> 

If you just want to reduce latency of GFP_ZERO, you may be able to
clear pages by (rate limited) kernel daemon for minimize latency.

But, what I'm not sure is the effect of cpu cache. Now, user process
can expect the page is on cpu cache when it faulted. page-fault
does all prefetching by clearing pages. This helps performance much
in general. So, I think it's limited situation that no-clear-page-at-fault
is good for total applications performance.
You can see reduction of clear_page() cost by removing GFP_ZERO but
what's your application's total performance ? Is it good enough considering
many risks ?


Thanks,
-Kame










