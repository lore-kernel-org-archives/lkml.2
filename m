Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab2EAB20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 21:28:26 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:19109 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756838Ab2EAB2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 21:28:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQFAEU7n095LbQl/2dsb2JhbABEr2aCf4EIggkBAQQBOhwjBQsIAxguFCUDIROICAS6NBOQfASVfYlbhmiCeg
Date: Tue, 1 May 2012 11:28:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
Message-ID: <20120501012804.GS7015@dastard>
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org>
 <1335289787-11089-3-git-send-email-john.stultz@linaro.org>
 <20120427003953.GC9541@dastard>
 <4F9ABA74.8040404@linux.vnet.ibm.com>
 <20120428013628.GJ9541@dastard>
 <4F9EFF04.4040308@linaro.org>
 <20120501000815.GQ7015@dastard>
 <4F9F3254.8040107@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9F3254.8040107@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 05:46:12PM -0700, John Stultz wrote:
> On 04/30/2012 05:08 PM, Dave Chinner wrote:
> >On Mon, Apr 30, 2012 at 02:07:16PM -0700, John Stultz wrote:
> >>On 04/27/2012 06:36 PM, Dave Chinner wrote:
> >>So if the overhead is too great for marking and unmarking pages,
> >>applications will be less likely to "help out".  :)
> >Devil's Advocate: If the benefit of managing caches in such a manner
> >is this marginal, then why add the complexity to the kernel?
> >
> I'm not saying the benefit is marginal. When we are resource
> constrained (no swap) and we need to free memory, having regions
> pre-marked by applications is a great benefit, as we can immediately
> take those marked volatile ranges (as opposed to memory notifiers,
> where we request applications to free memory themselves). 

This isn't a performance problem - this is a "avoid a hard fail"
problem. OOM tends to be fatal, and when you get to those situations
performance is already compromised. Once again, resiliency in low
memory situations is more important that absolute performance

> Being
> able to free chunks of application memory, rather then killing the
> application provides a better experience/overall system performance.

Exactly. The choice you are making here is better resiliency at an
edge case vs hard fail. The result is better overall behaviour, but
what you are trying to solve is not a performance problem. Hence
making the argument that performance is critical or no-one will use
it is, IMO, way off the mark. Developer's will use it, otherwise it
is their application that will get killed by the OS rather than the
competing app that uses the interface and allows the kernel to
shrink it's memory usage.....

> However, if applications feel the marking and unmarking is too
> costly, they are less likely to mark the freeable ranges as
> volatile.

Tracking ranges is not going to be a performance problem. For
real filesystems, it's the hole punching to guarantee data security
that will cause performance issues. In the case you are most
interested in (tmpfs) there is no hole punching overhead when
freeing ranges, so the only overhead is the range tracking. That's
code you are writing, so I don't see how it would end up unfit for
your purpose. :)

> So only if no consideration for performance is given,  in that case
> there'd be no benefit to adding the interface.

I did not say that no consideration should be given to performance,
just that data safety comes first. For your specific application on
tmpfs, data safety comes for free due to the nature of the tmpfs
implementation. However, that data safety needs to be explicit in
the API, not a result of an undocumented side effect of a specific
implementation. For real filesystems there will be overhead as a
result of fulfilling the data safety requirement, but solving those
performance issues is the responsibility of the filesystem
developers, not you....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
