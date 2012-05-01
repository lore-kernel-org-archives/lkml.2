Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2EAAqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:46:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37376 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2EAAqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:46:21 -0400
Message-ID: <4F9F3254.8040107@linaro.org>
Date: Mon, 30 Apr 2012 17:46:12 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org> <1335289787-11089-3-git-send-email-john.stultz@linaro.org> <20120427003953.GC9541@dastard> <4F9ABA74.8040404@linux.vnet.ibm.com> <20120428013628.GJ9541@dastard> <4F9EFF04.4040308@linaro.org> <20120501000815.GQ7015@dastard>
In-Reply-To: <20120501000815.GQ7015@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050100-4242-0000-0000-000001812333
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 05:08 PM, Dave Chinner wrote:
> On Mon, Apr 30, 2012 at 02:07:16PM -0700, John Stultz wrote:
>> On 04/27/2012 06:36 PM, Dave Chinner wrote:
>>> That's my concern - that persistent filesystems will have different
>>> behaviour to in-memory filesystems. They *must* be consistent in
>>> behaviour w.r.t. to stale data exposure, otherwise we are in a world
>>> of pain when applications start to use this. Quite frankly, I don't
>>> care about performance of VOLATILE ranges, but I care greatly
>>> about ensuring filesystems don't expose stale data to user
>>> applications....
>>>
>> I think we're in agreement with the rest of this email, but I do
>> want to stress that the performance of volatile ranges will become
>> more ciritical, as in order for folks to effectively use them, they
>> need to be able to mark and unmark ranges any time they're not using
>> the data.
> Performance is far less important than data security. Make it safe
> first, then optimise performance. As it is, the initial target of
> tmpfs - by it's very nature of returning zeros for regions not
> backed by pages - is safe w.r.t. stale data exposure, so it will not
> be slowed down by using an fallocate "best effort" hole-punching
> interface.  The performance of other filesystems is something that
> the relevant filesystem developers can worry about....

Again, I think we're quite in agreement about the issue of stale data.  
I just want to make sure you understand that the marking and unmarking 
paths will need to be fast if they are to attract users.


>> So if the overhead is too great for marking and unmarking pages,
>> applications will be less likely to "help out".  :)
> Devil's Advocate: If the benefit of managing caches in such a manner
> is this marginal, then why add the complexity to the kernel?
>
I'm not saying the benefit is marginal. When we are resource constrained 
(no swap) and we need to free memory, having regions pre-marked by 
applications is a great benefit, as we can immediately take those marked 
volatile ranges (as opposed to memory notifiers, where we request 
applications to free memory themselves).  Being able to free chunks of 
application memory, rather then killing the application provides a 
better experience/overall system performance.  However, if applications 
feel the marking and unmarking is too costly, they are less likely to 
mark the freeable ranges as volatile.

So only if no consideration for performance is given,  in that case 
there'd be no benefit to adding the interface.

thanks
-john





