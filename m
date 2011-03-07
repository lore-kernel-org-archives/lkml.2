Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1CGB1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 20:27:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:17469 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab1CGB12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 20:27:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,273,1297065600"; 
   d="scan'208";a="894418088"
Subject: Re: [PATCH]cfq-iosched: give busy sync queue no dispatch limit
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
In-Reply-To: <20110304164052.GA5466@redhat.com>
References: <1299225689.2337.4.camel@sli10-conroe>
	 <20110304164052.GA5466@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 09:23:37 +0800
Message-ID: <1299461017.2337.13.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-05 at 00:40 +0800, Vivek Goyal wrote:
> On Fri, Mar 04, 2011 at 04:01:29PM +0800, Shaohua Li wrote:
> 
> [..]
> > @@ -2412,15 +2418,31 @@ static bool cfq_may_dispatch(struct cfq_
> >  			return false;
> >  
> >  		/*
> > +		 * If there is only one sync queue, and its think time is
> > +		 * small, we can ignore async queue here and give the sync
> > +		 * queue no dispatch limit. The reason is a sync queue can
> > +		 * preempt async queue, limiting the sync queue doesn't make
> > +		 * sense. This is useful for aiostress test.
> > +		 */
> > +		if (cfq_cfqq_sync(cfqq) && cfqd->busy_sync_queues == 1) {
> > +			struct cfq_io_context *cic = RQ_CIC(cfqq->next_rq);
> > +
> > +			if (sample_valid(cic->ttime_samples) &&
> > +				cic->ttime_mean < cfqd->cfq_slice_idle)
> > +				promote_sync = true;
> > +		}
> 
> What's the relation of think time here? Or why should we check for think
> time being small. To me it does not make a difference in this case.
> 
> We have a request in existing queue and we figure out that this is the
> only sync queue in the system to we let it dispatch more than quantum.
> Thinktime should not even matter.
The reason in my mind is if think time is small, sync queue will keep
preempting async queue, so limit is meaningless. if think time is big,
there is less preempt. I'm afraid to go too far way in the less preempt
case and starve async too much.

Thanks,
Shaohua

