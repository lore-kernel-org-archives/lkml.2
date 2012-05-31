Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2EaXM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 19:12:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:41107 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab2EaXM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 19:12:26 -0400
Message-ID: <4FC7FAD0.9010701@linaro.org>
Date: Thu, 31 May 2012 16:12:16 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>
Subject: Re: [PATCH 2/4] [RFC] Range tree implementation
References: <1337973456-19533-1-git-send-email-john.stultz@linaro.org> <1337973456-19533-3-git-send-email-john.stultz@linaro.org> <20120531204806.GB16338@quack.suse.cz> <4FC7DCD7.6020800@linaro.org> <20120531223559.GB19050@quack.suse.cz>
In-Reply-To: <20120531223559.GB19050@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053123-7408-0000-0000-0000057BA58A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 03:35 PM, Jan Kara wrote:
> On Thu 31-05-12 14:04:23, John Stultz wrote:
>> On 05/31/2012 01:48 PM, Jan Kara wrote:
>>> On Fri 25-05-12 12:17:34, John Stultz wrote:
>>>> I suspect range-tree isn't a totally accurate name, but I
>>>> couldn't quite make out the difference between range trees
>>>> and interval trees, so I just picked one to call it. Do
>>>> let me know if you have a better name.
>>>    Well, interval tree is a data structure for tracking a set of
>>> possibly overlapping intervals. Range tree is a data structure tracking
>>> points allowing for fast queries on a set of points contained in a given
>>> range (gets useful and interesting when dimension>   1). Your data structure
>>> is neither so it would be good to have a different name. OTOH there are so
>>> many data structures that it's hard to find a reasonable unused name ;)
>> Although I'm not sure your interval tree description doesn't match
>> what I'm trying to provide. Could you clarify why that doesn't
>> match?
>    Wikipedia has a good description of Interval trees:
>    http://en.wikipedia.org/wiki/Interval_tree
>
>    For example they are tertiary trees.
So roughly the naive approach listed in the wikipedia link is what I'm 
using here.
I'm fine renaming it to interval_tree, but if you really think it should 
be something else,  by all means let me know.

>>>> +
>>>> +/**
>>>> + * range_tree_add - Add a node to a range tree
>>>> + * @root: range tree to be added to
>>>> + * @node: range_tree_node to be added
>>>> + *
>>>> + * Adds a node to the range tree.
>>>    I think you should document here that the added range must not intersect
>>> with any other range in the tree.
>> So for my usage in the volatile range code, I don't want
>> intersecting or overlapping ranges added, but I didn't feel it was
>> necessary to add this restriction to my rangetree code as well,
>> since someone might want to store overlapping ranges.
>    Ok, but then you should define where an interval that is intersecting
> other intervals ends up sorted...
Ah. I see the issue you're concerned about!

Since the ranges are sorted by starting value, you could have a set of 
values: (0,5),(0,100),(0,50) and since they have the same start value, 
they could be connected adjacently in any way possible in the tree.  
Thus, the current search function wouldn't necessarily handle searching 
for (25,30) properly.  Since if it hit (0,5) first, it would move right, 
where as (0,100) could reasonably be left of (0,5).

Thanks for pointing this out. While I didn't want to needlessly add the 
restriction that added ranges didn't intersect,  it seems by focusing on 
my usage where it didn't intersect, I in effect encoded that restriction 
into the search.  I'll go ahead and clarify this restriction in the 
comment and if folks want to extend the code to handle overlapping 
intervals, we can re-implement the logic then.

thanks
-john

