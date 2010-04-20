Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab0DTC4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 22:56:33 -0400
Received: from smtp-out.google.com ([74.125.121.35]:19057 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0DTC4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 22:56:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=DrtaFZ95HpS7TBMfwp3FazFdl5o6FY7NdzHxioLEDgHnDniEYJEjPG3nnwlie4cP/
	Bp7psPfUOHb3bKrhYBRWQ==
MIME-Version: 1.0
In-Reply-To: <20100415103053.GA5336@cmpxchg.org>
References: <64BE60A8-EEF9-4AC6-AF0A-0ED3CB544726@freebsd.org>
	 <20100415171142.D192.A69D9226@jp.fujitsu.com>
	 <20100415172215.D19B.A69D9226@jp.fujitsu.com>
	 <20100415103053.GA5336@cmpxchg.org>
Date: Mon, 19 Apr 2010 19:56:27 -0700
Message-ID: <u2i604427e01004191956zc0a40b06t6689041af6156b78@mail.gmail.com>
Subject: Re: [PATCH 1/4] vmscan: delegate pageout io to flusher thread if 
	current is kswapd
From: Ying Han <yinghan@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Suleiman Souhlal <ssouhlal@freebsd.org>,
       Dave Chinner <david@fromorbit.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, suleiman@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 3:30 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Thu, Apr 15, 2010 at 05:26:27PM +0900, KOSAKI Motohiro wrote:
>> Cc to Johannes
>>
>> > >
>> > > On Apr 14, 2010, at 9:11 PM, KOSAKI Motohiro wrote:
>> > >
>> > > > Now, vmscan pageout() is one of IO throuput degression source.
>> > > > Some IO workload makes very much order-0 allocation and reclaim
>> > > > and pageout's 4K IOs are making annoying lots seeks.
>> > > >
>> > > > At least, kswapd can avoid such pageout() because kswapd don't
>> > > > need to consider OOM-Killer situation. that's no risk.
>> > > >
>> > > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > >
>> > > What's your opinion on trying to cluster the writes done by pageout,
>> > > instead of not doing any paging out in kswapd?
>> > > Something along these lines:
>> >
>> > Interesting.
>> > So, I'd like to review your patch carefully. can you please give me one
>> > day? :)
>>
>> Hannes, if my remember is correct, you tried similar swap-cluster IO
>> long time ago. now I can't remember why we didn't merged such patch.
>> Do you remember anything?
>
> Oh, quite vividly in fact :)  For a lot of swap loads the LRU order
> diverged heavily from swap slot order and readaround was a waste of
> time.
>
> Of course, the patch looked good, too, but it did not match reality
> that well.
>
> I guess 'how about this patch?' won't get us as far as 'how about
> those numbers/graphs of several real-life workloads?  oh and here
> is the patch...'.

Hannes,

We recently ran into this problem while running some experiments on
ext4 filesystem. We experienced the scenario where we are writing a
large file or just opening a large file with limited memory allocation
(using containers), and the process got OOMed. The memory assigned to
the container is reasonably large, and the OOM can not be reproduced
on ext2 with the same configurations.

Later we figured this might be due to the delayed block allocation
from ext4. Vmscan sends a single page to ext4->writepage(), then ext4
punts if the block is DA'ed and re-dirties the page. On the other
hand, the flusher thread use ext4->writepages() which does include the
block allocation.

We looked at the OOM log under ext4, all pages within the container
were in inactive list and either Dirty or WriteBack. Also, the zones
are all marked as "all_unreclaimable" which indicates the reclaim path
has scanned the LRU quite lot times without making progress. If the
delayed block allocation is the cause for pageout() not being able to
flush dirty pages and then triggers OOMs, should we signal the fs to
force write out dirty pages under memory pressure?

--Ying

>
>> > >      Cluster writes to disk due to memory pressure.
>> > >
>> > >      Write out logically adjacent pages to the one we're paging out
>> > >      so that we may get better IOs in these situations:
>> > >      These pages are likely to be contiguous on disk to the one we're
>> > >      writing out, so they should get merged into a single disk IO.
>> > >
>> > >      Signed-off-by: Suleiman Souhlal <suleiman@google.com>
>
> For random IO, LRU order will have nothing to do with mapping/disk order.
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
