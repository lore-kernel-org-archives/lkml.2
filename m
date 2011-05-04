Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1EDGUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 02:20:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:12552 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab1EDGUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 02:20:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="430105168"
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <20110503082321.GA6556@htj.dyndns.org>
References: <1303202686.3981.216.camel@sli10-conroe>
	 <20110422233204.GB1576@mtj.dyndns.org>
	 <20110425013328.GA17315@sli10-conroe.sh.intel.com>
	 <20110425085827.GB17734@mtj.dyndns.org>
	 <20110425091311.GC17734@mtj.dyndns.org>
	 <1303778790.3981.283.camel@sli10-conroe>
	 <20110426104843.GB878@htj.dyndns.org>
	 <1303977055.3981.587.camel@sli10-conroe>
	 <20110430143758.GK29280@htj.dyndns.org>
	 <1304405071.3828.11.camel@sli10-conroe>
	 <20110503082321.GA6556@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 14:20:14 +0800
Message-ID: <1304490014.3828.14.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 16:23 +0800, Tejun Heo wrote:
> Hello,
> 
> On Tue, May 03, 2011 at 02:44:31PM +0800, Shaohua Li wrote:
> > > As I've said several times already, I really don't like this magic
> > > being done in the completion path.  Can't you detect the condition on
> > > issue of the second/following flush and append it to the running list?
> >
> > hmm, don't understand it. blk_flush_complete_seq is called when the
> > second flush is issued. or do you mean do this when the second flush is
> > issued to disk? but when the second flush is issued the first flush is
> > already finished.
> 
> Ah, okay, my bad.  That's the next sequence logic, so the right place.
> Still, please do the followings.
> 
> * Put it in a separate patch.
> 
> * Preferably, detect the actual condition (back to back flush) rather
>   than the queueability test unless it's too complicated.
> 
> * Please make pending/running paths look more symmetrical.
I retested, and appears just holding queue is already good enough. After
holding queue, merging back to back flush hasn't too much benefit. So
I'll not pursue do the back-to-back merge. I'll post my latest patches
out soon.

> > > If you already have tried that but this way still seems better, can
> > > you please explain why?
> > > 
> > > Also, this is a separate logic.  Please put it in a separate patch.
> > > The first patch should implement queue holding while flushing, which
> > > should remove the regression, right?
> >
> > ok. holding queue has no performance gain in my test, but it reduced a
> > lot of request requeue.
> 
> No, holding the queue should remove the regression completely.  Please
> read on.
> 
> > > Hmmm... why do you need separate ->flush_exclusive_running?  Doesn't
> > > pending_idx != running_idx already have the same information?
> >
> > when pending_idx != running_idx, flush request is added into queue tail,
> > but this doesn't mean flush request is dispatched to disk. there might
> > be other requests in the queue head, which we should dispatch. And flush
> > request might be reqeueud. Just checking pending_idx != running_idx will
> > cause queue hang because we thought flush is dispatched and then hold
> > the queue, but actually flush isn't dispatched yet, the queue should
> > dispatch other normal requests.
> 
> Don't hold elv_next_request().  Hold ->elevator_dispatch_fn().
ok, this works.

Thanks,
Shaohua

