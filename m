Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab0LINRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:17:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:24918 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab0LINRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:17:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="582104696"
Subject: Re: [RFC]block: change sort order of elv_dispatch_sort
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
In-Reply-To: <4CFF99E3.6020501@fusionio.com>
References: <1291786922.12777.152.camel@sli10-conroe>
	 <4CFF2C1A.1010100@fusionio.com> <1291794643.12777.161.camel@sli10-conroe>
	 <4CFF3B5B.30305@fusionio.com> <1291819169.4150.6.camel@shli-laptop>
	 <4CFF99E3.6020501@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 21:17:00 +0800
Message-ID: <1291900620.2130.8.camel@shli-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 22:44 +0800, Jens Axboe wrote:
> On 2010-12-08 22:39, Shaohua Li wrote:
> > On Wed, 2010-12-08 at 16:01 +0800, Jens Axboe wrote:
> >> On 2010-12-08 15:50, Shaohua Li wrote:
> >>> On Wed, 2010-12-08 at 14:56 +0800, Jens Axboe wrote:
> >>>> On 2010-12-08 13:42, Shaohua Li wrote:
> >>>>> Change the sort order a little bit. Makes requests with sector above boundary
> >>>>> in ascendant order, and requests with sector below boundary in descendant
> >>>>> order. The goal is we have less disk spindle move.
> >>>>> For example, boundary is 7, we add sector 8, 1, 9, 2, 3, 4, 10, 12, 5, 11, 6
> >>>>> In the original sort, the sorted list is:
> >>>>> 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6
> >>>>> the spindle move is 8->12->1->6, total movement is 12*2 sectors
> >>>>> with the new sort, the list is:
> >>>>> 8, 9, 10, 11, 12, 6, 5, 4, 3, 2, 1
> >>>>> the spindle move is 8->12->6->1, total movement is 12*1.5 sectors
> >>>>
> >>>> It was actually done this way on purpose, it's been a while since we
> >>>> have done two way elevators even outside the dispatch list sorting
> >>>> itself.
> >>>>
> >>>> Do you have any results to back this change up? I'd argue that
> >>>> continuing to the end, sweeping back, and reading forwards again will be
> >>>> faster then doing backwards reads usually.
> >>> No, have no data, that is why this is a RFC patch. Part reason is I
> >>> don't know when we dispatch several requests to the list. Appears driver
> >>> only takes one request one time. What kind of test do you suggest?
> >>
> >> Yes that is usually the case, it's mainly meant as a holding point for
> >> dispatch, or for requeue, or for request that don't give sort ordering.
> >> Or on io scheduler switches, for instance.
> >
> > Have a test in a hacked way. I use modified noop iosched, and every time
> > when noop tries to dispatch request, it dispatches all requests in its
> > list. Test does random read. The result is actually quite stable. The
> > changed order always gives slightly better throughput, but the
> > improvement is quite small (<1%)
> 
> First of all I think 1% is too close to call, unless your results are
> REALLY stable. Secondly, a truly random workload is not a good test
> case as requests are going to be all over the map anyway. For something
> more realistic (like your example, but of course not fully contig) it
> would be interesting to see.
Tried a random I/O read with block size range from 4k to 64k, I thought
this is more realistic. The test result for the two different sort
methods still shows slightly difference. I'll give up the patch unless
there is better workload to try.

Thanks,
Shaohua

