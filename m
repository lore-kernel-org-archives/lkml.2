Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab2EaVF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 17:05:28 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33798 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758096Ab2EaVF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 17:05:27 -0400
Message-ID: <4FC7DCD7.6020800@linaro.org>
Date: Thu, 31 May 2012 14:04:23 -0700
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
References: <1337973456-19533-1-git-send-email-john.stultz@linaro.org> <1337973456-19533-3-git-send-email-john.stultz@linaro.org> <20120531204806.GB16338@quack.suse.cz>
In-Reply-To: <20120531204806.GB16338@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053121-1976-0000-0000-00000DB6DCD4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 01:48 PM, Jan Kara wrote:
> On Fri 25-05-12 12:17:34, John Stultz wrote:
>> I suspect range-tree isn't a totally accurate name, but I
>> couldn't quite make out the difference between range trees
>> and interval trees, so I just picked one to call it. Do
>> let me know if you have a better name.
>    Well, interval tree is a data structure for tracking a set of
> possibly overlapping intervals. Range tree is a data structure tracking
> points allowing for fast queries on a set of points contained in a given
> range (gets useful and interesting when dimension>  1). Your data structure
> is neither so it would be good to have a different name. OTOH there are so
> many data structures that it's hard to find a reasonable unused name ;)

Although I'm not sure your interval tree description doesn't match what 
I'm trying to provide. Could you clarify why that doesn't match?

>> +/**
>> + * range_tree_next_in_range - Return the next range in a range_tree still
>> + *                            contained within a specified range.
>    'within' isn't really correct, right? It should rather be 'intersecting'.

That is more clear, thanks for the suggestion!

>
>> + * @root: range_tree root
>> + * @start: range start
>> + * @end: range end
>> + *
>> + */
>> +struct range_tree_node *range_tree_next_in_range(struct range_tree_node *node,
>> +							u64 start, u64 end)
>> +{
>> +	struct rb_node *next;
>> +	struct range_tree_node *candidate;
>> +	if (!node)
>> +		return NULL;
>> +	next = rb_next(&node->rb);
>> +	if (!next)
>> +		return NULL;
>> +
>> +	candidate = container_of(next, struct range_tree_node, rb);
>> +
>> +	if ((candidate->start>  end) || (candidate->end<  start))
>> +		return NULL;
>> +
>> +	return candidate;
>> +}
>> +
>> +/**
>> + * range_tree_add - Add a node to a range tree
>> + * @root: range tree to be added to
>> + * @node: range_tree_node to be added
>> + *
>> + * Adds a node to the range tree.
>    I think you should document here that the added range must not intersect
> with any other range in the tree.

So for my usage in the volatile range code, I don't want intersecting or 
overlapping ranges added, but I didn't feel it was necessary to add this 
restriction to my rangetree code as well, since someone might want to 
store overlapping ranges.

thanks for the review!
-john


