Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab0FQAfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0FQAfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:35:02 -0400
Message-ID: <4C196D81.8090700@redhat.com>
Date: Wed, 16 Jun 2010 20:34:09 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 05/12] vmscan: kill prev_priority completely
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>	<1276514273-27693-6-git-send-email-mel@csn.ul.ie>	<20100616163709.1e0f6b56.akpm@linux-foundation.org>	<4C196219.6000901@redhat.com> <20100616171847.71703d1a.akpm@linux-foundation.org>
In-Reply-To: <20100616171847.71703d1a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 08:18 PM, Andrew Morton wrote:
> On Wed, 16 Jun 2010 19:45:29 -0400
> Rik van Riel<riel@redhat.com>  wrote:
>
>> On 06/16/2010 07:37 PM, Andrew Morton wrote:
>>
>>> This would have been badder in earlier days when we were using the
>>> scanning priority to decide when to start unmapping pte-mapped pages -
>>> page reclaim would have been recirculating large blobs of mapped pages
>>> around the LRU until the priority had built to the level where we
>>> started to unmap them.
>>>
>>> However that priority-based decision got removed and right now I don't
>>> recall what it got replaced with.  Aren't we now unmapping pages way
>>> too early and suffering an increased major&minor fault rate?  Worried.
>>
>> We keep a different set of statistics to decide whether to
>> reclaim only page cache pages, or both page cache and
>> anonymous pages. The function get_scan_ratio parses those
>> statistics.
>
> I wasn't talking about anon-vs-file.  I was referring to mapped-file
> versus not-mapped file.  If the code sees a mapped page come off the
> tail of the LRU it'll just unmap and reclaim the thing.  This policy
> caused awful amounts of paging activity when someone started doing lots
> of read() activity, which is why the VM was changed to value mapped
> pagecache higher than unmapped pagecache.  Did this biasing get
> retained and if so, how?

It changed a little, but we still have it:

1) we do not deactivate active file pages if the active file
    list is smaller than the inactive file list - this protects
    the working set from streaming IO

2) we keep mapped referenced executable pages on the active file
    list if they got accessed while on the active list, while
    other file pages get deactivated unconditionally

> Does thrash-avoidance actually still work?

I suspect it does, but I have not actually tested that code
in years :)

>> I do not believe prev_priority will be very useful here, since
>> we'd like to start out with small scans whenever possible.
>
> Why?

For one, memory sizes today are a lot larger than they were
when 2.6.0 came out.

Secondly, we now know more exactly what is on each LRU list.
That should greatly reduce unnecessary turnover of the list.

For example, if we know there is no swap space available, we
will not bother scanning the anon LRU lists.

If we know there is not enough file cache left to get us up
to the zone high water mark, we will not bother scanning the
few remaining file pages.

Because of those simple checks (in get_scan_priority), I do
not expect that we will have to scan through all of memory
as frequently as we had to do in 2.6.0.

Furthermore, we unconditionally deactivate most active pages
and have a working used-once scheme for pages on the anon
lists.  This should also contribute to a reduction in the
number of pages that get scanned.

>> In that case, the prev_priority logic may have introduced the
>> kind of behavioural bug you describe above...
>>
>>> And one has to wonder: if we're making these incorrect decisions based
>>> upon a bogus view of the current scanning difficulty, why are these
>>> various priority-based thresholding heuristics even in there?  Are they
>>> doing anything useful?
>>
>> The prev_priority code was useful when we had filesystem and
>> swap backed pages mixed on the same LRU list.
>
> No, stop saying swap! ;)
>
> It's all to do with mapped pagecache versus unmapped pagecache.  "ytf
> does my browser get paged out all the time".

We have other measures in place now to protect the working set
on the file LRU lists (see above).  We are able to have those
measures in the kernel because we no longer have mixed LRU
lists.

-- 
All rights reversed
