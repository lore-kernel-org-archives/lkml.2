Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1BOOak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:30:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab1BOOaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:30:39 -0500
Date: Tue, 15 Feb 2011 09:24:16 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 3/6 v4] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
Message-ID: <20110215142416.GB27296@redhat.com>
References: <4D51ED26.8050809@cn.fujitsu.com>
 <4D539804.9090308@cn.fujitsu.com>
 <20110210192940.GA2600@redhat.com>
 <4D55E07A.8060903@cn.fujitsu.com>
 <20110214165803.GE13097@redhat.com>
 <4D59DCB6.1020900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D59DCB6.1020900@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 09:53:58AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Sat, Feb 12, 2011 at 09:20:58AM +0800, Gui Jianfeng wrote:
> >> Vivek Goyal wrote:
> >>> On Thu, Feb 10, 2011 at 03:47:16PM +0800, Gui Jianfeng wrote:
> >>>> Introduce vdisktime and io weight for CFQ queue scheduling. Currently, io priority
> >>>> maps to a range [100,1000]. It also gets rid of cfq_slice_offset() logic and makes
> >>>> use the same scheduling algorithm as CFQ group does. This helps for CFQ queue and
> >>>> group scheduling on the same service tree.
> >>>>
> >>>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> >>>> ---
> >>>>  block/cfq-iosched.c |  219 +++++++++++++++++++++++++++++++++++++++------------
> >>>>  1 files changed, 167 insertions(+), 52 deletions(-)
> >>>>
> >>>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> >>>> index f3a126e..41cef2e 100644
> >>>> --- a/block/cfq-iosched.c
> >>>> +++ b/block/cfq-iosched.c
> >>>> @@ -39,6 +39,13 @@ static const int cfq_hist_divisor = 4;
> >>>>   */
> >>>>  #define CFQ_IDLE_DELAY		(HZ / 5)
> >>>>  
> >>>> +/* 
> >>>> + * The base boosting value.
> >>>> + */
> >>>> +#define CFQ_BOOST_SYNC_BASE          (HZ / 10)
> >>>> +#define CFQ_BOOST_ASYNC_BASE          (HZ / 25)
> >>>> +
> >>> These are same as cfq_slice_sync and cfq_slice_async. Looking at
> >>> boost logic, this is equivalent of starting a new queue/group as
> >>> if it is being requeued after conuming a full slice. So may be we can divide
> >>> it by some const number say 4 or something like that. This is a minor
> >>> point though as this algorimthm will kind of evolve and we will learn
> >>> what works best.
> >>>
> >>> Secondly, I think you wanted to SYNC vs ASYNC logic seem to be reversed.
> >>> We would like to give ASYNC queues higher boost (Put these farther in 
> >>> tree) and lesser boost to SYNC queues. Looks like above constants will
> >>> do the reverse? 
> >> Hi Vivek,
> >>
> >> Currently, SYNC and ASYNC queues are in different service tree, they don't
> >> impact each other. Here, I Really want use this logic.
> > 
> > Ok, SYNC and ASYNC are on separate service tree so their vtime are not
> > comparable (as of today, down the line one might want to look at those for
> > better workload selection logic).
> > 
> > Anyway, because two are on seprate tree so why should we have separate
> > boosting constants for them? How does it help?
> 
> Here if we are using CFQ_BOOST_SYNC_BASE for both, I think it might boost
> too much for an ASYNC cfqe as compare to others on the same service tree(async).
> So I make charging and boosting follow the same base.

Ok, that makes sense. So as suggested in other mails, lets use a even
smaller base so that freshly backlogged queues get smaller vdisktimes
as compared to existing queues which are using disks for longer time.

Thanks
Vivek
