Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0FOBRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:17:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab0FOBRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:17:31 -0400
Message-ID: <4C16D46D.3020302@redhat.com>
Date: Mon, 14 Jun 2010 21:16:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-12-git-send-email-mel@csn.ul.ie> <20100614231144.GG6590@dastard> <20100614162143.04783749.akpm@linux-foundation.org> <20100615003943.GK6590@dastard>
In-Reply-To: <20100615003943.GK6590@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 08:39 PM, Dave Chinner wrote:
> On Mon, Jun 14, 2010 at 04:21:43PM -0700, Andrew Morton wrote:

>> But then, this all really should be done at the block layer so other
>> io-submitting-paths can benefit from it.
>
> That was what we did in the past with really, really deep IO
> scheduler queues. That leads to IO latency and OOM problems because
> we could lock gigabytes of memory away under IO and take minutes to
> clean it.
>
> Besides, there really isn't the right context in the block layer to
> be able to queue and prioritise large amounts of IO without
> significant penalties to some higher layer operation.

Can we kick flushing for the whole inode at once from
vmscan.c?

That way we should:
1) ensure that the page we want is written to disk, and
2) we flush out related pages at the same time, getting
    a decent IO pattern

Chances are that if we want to evict one page from a
file, we'll also want to evict other pages from that
same file.  In fact, chances are a good number of them
will live nearby on the LRU list.

Does this make sense?

Would it be hard to add a "please flush this file"
way to call the filesystem flushing threads?

-- 
All rights reversed
