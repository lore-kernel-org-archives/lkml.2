Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321Ab2D0TfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:35:10 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42342 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760569Ab2D0TfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:35:08 -0400
Message-ID: <4F9AF4A8.40901@linaro.org>
Date: Fri, 27 Apr 2012 12:34:00 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] Range tree implementation
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org> <1335289787-11089-2-git-send-email-john.stultz@linaro.org> <CAO6Zf6Bn7dHoXj=MN2dG8JynvxoAYjNZq3NqC3tWzO115T6uhA@mail.gmail.com> <4F982424.9000603@linaro.org> <CAO6Zf6CsQTHAVP14xi_sOr0iik_rKWeuqT4R_04X6xamEh4c_w@mail.gmail.com>
In-Reply-To: <CAO6Zf6CsQTHAVP14xi_sOr0iik_rKWeuqT4R_04X6xamEh4c_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042719-1780-0000-0000-0000051D213A
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000273; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00134609; UDB=6.00031483; UTC=2012-04-27
 19:35:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 03:00 AM, Dmitry Adamushko wrote:
>>> [ ... ]
>>>
>>> Almost everything is common rb_tree-handling code that can be found in
>>> any place where rb-trees are used (hard-coded for flexibility,
>>> performance or whatever other reasons). So my feeling is that it
>>> should not be different here.
>>>
>> Sorry, not sure I quite understand what you're suggesting. Are you saying it
>> doesn't make sense to have a generic range tree implementation, since really
>> its just a small shim over the rbtree code?  So instead range-tree users
>> should just implment them themselves?
> Exactly. It's not much different from other rbtree
> search-insert-delete implementations out there.
>
> What are the generic use cases that we want to support with this interface?

Well, Andrew really wants to see posix file locking to reuse something 
like this (which is the whole reason I split it out separately). And 
Aneesh has similar range management needs for his hugetlb region tracking.

> Is the current notion of the 'overlapping range' as taken by
> range_tree_in_range() common enough? What if another use-case requires
> _only_ the ranges that are strictly inside the [ start, end ] range?
> In this case, we might be better off sticking to the same
> 'implement-your-own-search' approach taken by the generic rbtree
> interface.
Or we could extend the interface for more specific requests?

So its true that the range-tree construct is a pretty thin layer over 
the rbtree code, but even so, we've had a few places in the kernel where 
folks basically are duplicating the same logic over and over again, so 
it might make sense to consolidate the obvious use cases, even just to 
avoid some of the simpler bugs that can happen with rbtree logic (for 
instance, I sent a simple fix to an rbtree related thinko in Rafael's 
recent userspace wakelock api earlier this week).

Anther example is the timerqueue structure I added earlier, which again 
is a thin shim over the rbtree, but allows a few different users to 
share code for quick insert ordered list behavior.

So yea, even though its fairly thin, I think it still has value for reuse.

thanks
-john

