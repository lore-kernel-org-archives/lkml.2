Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab2BOA3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 19:29:20 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:36568 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab2BOA3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 19:29:19 -0500
Message-ID: <1329265750.2340.17.camel@work-vm>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: John Stultz <john.stultz@linaro.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Date: Tue, 14 Feb 2012 16:29:10 -0800
In-Reply-To: <20120214235106.GL7479@dastard>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	 <1328832993-23228-2-git-send-email-john.stultz@linaro.org>
	 <20120214051659.GH14132@dastard> <1329198932.2753.62.camel@work-vm>
	 <20120214235106.GL7479@dastard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021500-4242-0000-0000-000000C61132
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 10:51 +1100, Dave Chinner wrote:
> Given that it is a single state bit per page (volatile/non volatile)
> you could just use a radix tree tag for keeping the state. Changing
> the state isn't a performance critical operation, and tagging large
> ranges isn't that expensive (e.g. we do that in the writeback code),
> so I'm not sure the overhead of a separate tree is necessary here....

Hrm. I'll look into this.

> That doesn't help with the reclaim side of things, but I would have
> thought that such functioanlity would be better integrated into the
> VM page cache/lru scanning code than adding a shrinker to shrink the
> page cache additionally on top of what the VM has already done
> before calling the shrinkers. I'm not sure what is best here,
> though...

Yea. My previous version did eviction from shmem_writepage(), I believe
much as you suggest here, but the concern with that is that you could
have a larger volatile range that was for the most part recently in use,
but one idle page causes the entire thing to be evicted first. Using
least-recently-marked-volatile order seems more natural for the use case
(although Dimitry and others have already pointed out that the
inheritance from the coalescing of neighboring ranges results in a
similar issue).

But I'm open to other ideas and arguments.

Thanks again for the feedback!
-john

