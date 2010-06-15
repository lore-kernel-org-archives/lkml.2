Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750870Ab0FOEJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 00:09:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab0FOEJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 00:09:06 -0400
Message-ID: <4C16FCAE.4050607@redhat.com>
Date: Tue, 15 Jun 2010 00:08:14 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Chinner <david@fromorbit.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>	<1276514273-27693-12-git-send-email-mel@csn.ul.ie>	<20100614231144.GG6590@dastard>	<20100614162143.04783749.akpm@linux-foundation.org>	<20100615003943.GK6590@dastard>	<4C16D46D.3020302@redhat.com> <20100614184544.32b1c371.akpm@linux-foundation.org>
In-Reply-To: <20100614184544.32b1c371.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 09:45 PM, Andrew Morton wrote:
> On Mon, 14 Jun 2010 21:16:29 -0400 Rik van Riel<riel@redhat.com>  wrote:
>
>> Would it be hard to add a "please flush this file"
>> way to call the filesystem flushing threads?
>
> Passing the igrab()bed inode into the flusher threads would fix the
> iput_final() problems, as long as the alloc_pages() caller never blocks
> indefinitely waiting for the work which the flusher threads are doing.
>
> Otherwise we get (very hard-to-hit) deadlocks where the alloc_pages()
> caller holds VFS locks and is waiting for the flusher threads while all
> the flusher threads are stuck under iput_final() waiting for those VFS
> locks.
>
> That's fixable by not using igrab()/iput().  You can use lock_page() to
> pin the address_space.  Pass the address of the locked page across to
> the flusher threads so they don't try to lock it a second time, or just
> use trylocking on that writeback path or whatever.

Any thread that does not have __GFP_FS set in its gfp_mask
cannot wait for the flusher to complete. This is regardless
of the mechanism used to kick the flusher.

Then again, those threads cannot call ->writepage today
either, so we should be fine keeping that behaviour.

Threads that do have __GFP_FS in their gfp_mask can wait
for the flusher in various ways.  Maybe the lock_page()
method can be simplified by having the flusher thread
unlock the page the moment it gets it, and then run the
normal flusher code?

The pageout code (in shrink_page_list) already unlocks
the page anyway before putting it back on the relevant
LRU list.  It would be easy enough to skip that unlock
and let the flusher thread take care of it.

-- 
All rights reversed
