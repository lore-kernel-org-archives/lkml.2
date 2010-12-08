Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0LHOjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:39:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:15978 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab0LHOjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:39:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,315,1288594800"; 
   d="scan'208";a="685127129"
Subject: Re: [RFC]block: change sort order of elv_dispatch_sort
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
In-Reply-To: <4CFF3B5B.30305@fusionio.com>
References: <1291786922.12777.152.camel@sli10-conroe>
	 <4CFF2C1A.1010100@fusionio.com> <1291794643.12777.161.camel@sli10-conroe>
	 <4CFF3B5B.30305@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 22:39:29 +0800
Message-ID: <1291819169.4150.6.camel@shli-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 16:01 +0800, Jens Axboe wrote:
> On 2010-12-08 15:50, Shaohua Li wrote:
> > On Wed, 2010-12-08 at 14:56 +0800, Jens Axboe wrote:
> >> On 2010-12-08 13:42, Shaohua Li wrote:
> >>> Change the sort order a little bit. Makes requests with sector above boundary
> >>> in ascendant order, and requests with sector below boundary in descendant
> >>> order. The goal is we have less disk spindle move.
> >>> For example, boundary is 7, we add sector 8, 1, 9, 2, 3, 4, 10, 12, 5, 11, 6
> >>> In the original sort, the sorted list is:
> >>> 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6
> >>> the spindle move is 8->12->1->6, total movement is 12*2 sectors
> >>> with the new sort, the list is:
> >>> 8, 9, 10, 11, 12, 6, 5, 4, 3, 2, 1
> >>> the spindle move is 8->12->6->1, total movement is 12*1.5 sectors
> >>
> >> It was actually done this way on purpose, it's been a while since we
> >> have done two way elevators even outside the dispatch list sorting
> >> itself.
> >>
> >> Do you have any results to back this change up? I'd argue that
> >> continuing to the end, sweeping back, and reading forwards again will be
> >> faster then doing backwards reads usually.
> > No, have no data, that is why this is a RFC patch. Part reason is I
> > don't know when we dispatch several requests to the list. Appears driver
> > only takes one request one time. What kind of test do you suggest?
> 
> Yes that is usually the case, it's mainly meant as a holding point for
> dispatch, or for requeue, or for request that don't give sort ordering.
> Or on io scheduler switches, for instance.
Have a test in a hacked way. I use modified noop iosched, and every time
when noop tries to dispatch request, it dispatches all requests in its
list. Test does random read. The result is actually quite stable. The
changed order always gives slightly better throughput, but the
improvement is quite small (<1%)
> > I'm curious why the sweeping back is faster. It definitely needs more
> > spindle move. is there any hardware trick here?
> 
> The idea is that while the initial seek is longer, due to drive prefetch
> serving the latter half request series after the sweep is faster.
> 
> I know that classic OS books mentions this is a good method, but I don't
> think that has been the case for a long time.
Hmm, if this is sequential I/O, then requests already merged. if not,
how could drive know how to do prefetch.

Thanks,
shaohua

