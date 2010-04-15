Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab0DOXmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:42:00 -0400
Received: from smtp-out.google.com ([74.125.121.35]:43169 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab0DOXlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:41:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=ZdEIvji1UymmL/wrpDskA2LO5stMvycKhPCV7/dHdAu8txDOM72zGDII7MHPIgICR
	qjOVXbvU/0wYQxbevabjw==
MIME-Version: 1.0
In-Reply-To: <20100415233339.GW2493@dastard>
References: <20100415013436.GO2493@dastard>
	 <20100415130212.D16E.A69D9226@jp.fujitsu.com>
	 <20100415131106.D174.A69D9226@jp.fujitsu.com>
	 <64BE60A8-EEF9-4AC6-AF0A-0ED3CB544726@freebsd.org>
	 <20100415093214.GV2493@dastard>
	 <85DB7083-8E78-4884-9E76-5BD803C530EF@freebsd.org>
	 <20100415233339.GW2493@dastard>
Date: Thu, 15 Apr 2010 16:41:44 -0700
Message-ID: <k2hd26f1ae01004151641l371404d9sb0fd36c5d7ff3388@mail.gmail.com>
Subject: Re: [PATCH 1/4] vmscan: delegate pageout io to flusher thread if 
	current is kswapd
From: Suleiman Souhlal <suleiman@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 4:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Apr 15, 2010 at 10:27:09AM -0700, Suleiman Souhlal wrote:
>>
>> On Apr 15, 2010, at 2:32 AM, Dave Chinner wrote:
>>
>> >On Thu, Apr 15, 2010 at 01:05:57AM -0700, Suleiman Souhlal wrote:
>> >>
>> >>On Apr 14, 2010, at 9:11 PM, KOSAKI Motohiro wrote:
>> >>
>> >>>Now, vmscan pageout() is one of IO throuput degression source.
>> >>>Some IO workload makes very much order-0 allocation and reclaim
>> >>>and pageout's 4K IOs are making annoying lots seeks.
>> >>>
>> >>>At least, kswapd can avoid such pageout() because kswapd don't
>> >>>need to consider OOM-Killer situation. that's no risk.
>> >>>
>> >>>Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> >>
>> >>What's your opinion on trying to cluster the writes done by pageout,
>> >>instead of not doing any paging out in kswapd?
>> >
>> >XFS already does this in ->writepage to try to minimise the impact
>> >of the way pageout issues IO. It helps, but it is still not as good
>> >as having all the writeback come from the flusher threads because
>> >it's still pretty much random IO.
>>
>> Doesn't the randomness become irrelevant if you can cluster enough
>> pages?
>
> No. If you are doing full disk seeks between random chunks, then you
> still lose a large amount of throughput. e.g. if the seek time is
> 10ms and your IO time is 10ms for each 4k page, then increasing the
> size ito 64k makes it 10ms seek and 12ms for the IO. We might increase
> throughput but we are still limited to 100 IOs per second. We've
> gone from 400kB/s to 6MB/s, but that's still an order of magnitude
> short of the 100MB/s full size IOs with little in way of seeks
> between them will acheive on the same spindle...

What I meant was that, theoretically speaking, you could increase the
maximum amount of pages that get clustered so that you could get
100MB/s, although it most likely wouldn't be a good idea with the
current patch.

-- Suleiman
