Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342Ab2HITOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:14:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52966 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2HITOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:14:20 -0400
Message-ID: <50240B77.2060204@linaro.org>
Date: Thu, 09 Aug 2012 12:11:51 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
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
        Mike Hommey <mh@glandium.org>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] [RFC] Add volatile range management code
References: <1343447832-7182-1-git-send-email-john.stultz@linaro.org> <1343447832-7182-2-git-send-email-john.stultz@linaro.org> <CANN689HWYO5DD_p7yY39ethcFu_JO9hudMcDHd=K8FUfhpHZOg@mail.gmail.com>
In-Reply-To: <CANN689HWYO5DD_p7yY39ethcFu_JO9hudMcDHd=K8FUfhpHZOg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080919-7282-0000-0000-00000BD1BC6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 02:46 AM, Michel Lespinasse wrote:
> On Fri, Jul 27, 2012 at 8:57 PM, John Stultz <john.stultz@linaro.org> wrote:
>> v5:
>> * Drop intervaltree for prio_tree usage per Michel &
>>    Dmitry's suggestions.
> Actually, I believe the ranges you need to track are non-overlapping, correct ?
Correct.  Any overlapping range is coalesced.

> If that is the case, a simple rbtree, sorted by start-of-range
> address, would work best.
> (I am trying to remove prio_tree users... :)

Sigh.  Sure.  Although I've blown with the wind on a number of different 
approaches for storing the ranges. I'm not particularly passionate about 
it, but the continual conflicting suggestions are a slight frustration.  :)


>> +       /* First, find any existing intervals that overlap */
>> +       prio_tree_iter_init(&iter, root, start, end);
> Note that prio tree iterations take intervals as [start; last] not [start; end[
> So if you want to stick with prio trees, you would have to use end-1 here.
Thanks!  I think I hit this off-by-one issue in my testing, but fixed it 
on the backend  w/ :

     modify_range(&inode->i_data, start, end-1, &mark_nonvolatile_page);

Clearly fixing it at the start instead of papering over it is better.


>> +       node = prio_tree_next(&iter);
>> +       while (node) {
> I'm confused, I don't think you ever expect more than one range to
> match, do you ???

So yea.  If you already have two ranges (0-5),(10-15) and then add range 
(0-20) we need to coalesce the two existing ranges into the new one.


> This is far from a complete code review, but I just wanted to point
> out a couple details that jumped to me first. I am afraid I am missing
> some of the background about how the feature is to be used to really
> dig into the rest of the changes at this point :/

Well, I really appreciate any feedback here.

thanks
-john

