Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2LHAU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:20:57 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:37789 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab2LHAUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:20:53 -0500
Message-ID: <50C287CE.5070404@linaro.org>
Date: Fri, 07 Dec 2012 16:20:30 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC v2] Support volatile range for anon vma
References: <1351560594-18366-1-git-send-email-minchan@kernel.org> <50AD739A.30804@linaro.org> <50B6E1F9.5010301@linaro.org> <20121204000042.GB20395@bbox> <50BD4A70.9060506@linaro.org> <20121204072207.GA9782@blaptop> <50BE4B64.6000003@linaro.org> <20121205070110.GC9782@blaptop>
In-Reply-To: <20121205070110.GC9782@blaptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120800-7408-0000-0000-00000ADA0B2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 11:01 PM, Minchan Kim wrote:
> Hi John,
>
> On Tue, Dec 04, 2012 at 11:13:40AM -0800, John Stultz wrote:
>>
>> I don't think the problem is when vmas being marked VM_VOLATILE are
>> being merged, its that when we mark the vma as *non-volatile*, and
>> remove the VM_VOLATILE flag we merge the non-volatile vmas with
>> neighboring vmas. So preserving the purged flag during that merge is
>> important. Again, the example I used to trigger this was an
>> alternating pattern of volatile and non volatile vmas, then marking
>> the entire range non-volatile (though sometimes in two overlapping
>> passes).
> If I understand correctly, you mean following as.
>
> chunk1 = mmap(8M)
> chunk2 = chunk1 + 2M;
> chunk3 = chunk2 + 2M
> chunk4 = chunk3 + 2M
>
> madvise(chunk1, 2M, VOLATILE);
> madvise(chunk4, 2M, VOLATILE);
>
> /*
>   * V : volatile vma
>   * N : non volatile vma
>   * So Now vma is VNVN.
>   */
> And chunk4 is purged.
>
> int ret = madvise(chunk1, 8M, NOVOLATILE);
> ASSERT(ret == 1);
> /* And you expect VNVN->N ?*/
>
> Right?

Yes. That's exactly right.

> If so, why should non-volatile function semantic allow it which cross over
> non-volatile areas in a range? I would like to fail such case because
> in case of MADV_REMOVE, it fails in the middle of operation if it encounter
> VM_LOCKED.
>
> What do you think about it?
Right, so I think this issue is maybe a problematic part of the VMA 
based approach.  While marking an area as nonvolatile twice might not 
make a lot of sense, I think userland applications would not appreciate 
the constraint that madvise(VOLATILE/NONVOLATILE) calls be made in 
perfect pairs of identical sizes.

For instance, if a browser has rendered a web page, but the page is so 
large that only a sliding window/view of that page is visible at one 
time, it may want to mark the regions not currently in the view as 
volatile.   So it would be nice (albeit naive) for that application that 
when the view location changed, it would just mark the new region as 
non-volatile, and any region not in the current view as volatile.  This 
would be easier then trying to calculate the diff of the old view region 
boundaries vs the new and modifying only the ranges that changed. 
Granted, doing so might be more efficient, but I'm not sure we can be 
sure every similar case would be more efficient.

So in my mind, double-clearing a flag should be allowed (as well as 
double-setting), as well as allowing for setting/clearing overlapping 
regions.

Aside from if the behavior should be allowed or not, the error mode of 
madvise is problematic as well, since failures can happen mid way 
through the operation, leaving the vmas in the range specified 
inconsistent. Since usually its only advisory, such inconsistent states 
aren't really problematic, and repeating the last action is probably fine.

The problem with NOVOLATILE's  purged state, with vmas, is that if we 
hit an error mid-way through, its hard to figure out what the state of 
the pages are for the range specified. Some of them could have been 
purged and set to non-volatile, while some may not be purged, and still 
left volatile. You can't just repeat the last action and get a sane 
result (as we lose the purged flag state).

With my earlier fallocate implementations, I tried to avoid this by 
making any memory allocations that might be required before making any 
state changes, so there wasn't a chance for a partial failure from 
-ENOMEM.  (It was also simpler because in my own range management code 
there were only volatile ranges,  non-volatility was simply the absence 
of a volatile range. With vmas we have to manage both volatile and 
nonvolatile vmas).  I'm not sure how this could be done with the vma 
method other then by maybe reworking the merge/split logic, but I'm wary 
of mucking with that too much as I know its performance sensitive.

Your thoughts?  Am I just being too set in my way of thinking here?

thanks
-john

