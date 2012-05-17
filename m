Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab2EQVJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:09:13 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:34052 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab2EQVJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:09:10 -0400
Date: Thu, 17 May 2012 23:08:49 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: "nai.xia" <nai.xia@gmail.com>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] refault distance-based file cache sizing
Message-ID: <20120517210849.GE1800@cmpxchg.org>
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
 <4FB33A4E.1010208@gmail.com>
 <20120516065132.GC1769@cmpxchg.org>
 <4FB3A416.9010703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB3A416.9010703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 08:56:54PM +0800, nai.xia wrote:
> On 2012/05/16 14:51, Johannes Weiner wrote:
> >There may have been improvements from clock-pro, but it's hard to get
> >code merged that does not behave as expected in theory with nobody
> >understanding what's going on.

Damn, that sounded way harsher and arrogant than I wanted it to sound.
And it's only based on what I gathered from the discussions on the
list archives.  Sorry :(

> OK, I assume that you do aware that the system you constructed with
> this simple and understandable idea looks like a so called "feedback
> system"? Or in other words, I think theoretically the refault-distance
> of a page before and after your algorithm is applied is not the same.
> And this changed refault-distance pattern is then feed as input into
> your algorithm. A feedback system may be hard(and may be simple) to
> analyze but may also work well magically.

I'm with you on that, but I can't see an alternative in this case.  We
can't predict future page accesses very well, so we have to take
speculative shots and be considerate about the consequences.

And BECAUSE we may get it wrong, the algorithm does not rely on the
decisions it makes to be correct.  For example, it does not activate
pages based on refault distance, but requires the refaulted page to
win the race against an actual active page.  Likewise, pages are not
evicted from the active list directly, instead they get a chance at
re-activation when challenged.
