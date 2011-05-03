Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab1ECIXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 04:23:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51989 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1ECIX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 04:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UJMzVJl88raSHit2Ie3tSIASiNLEborMwVLqH/McKcW1E+Ewi/IcclKfgVO9U33Gh0
         JdEfFWrdcHhRCIw7zmDCz3hYBxYp/uEJIosNU1/vM2W/hqcZDihYIORhTrCZtOIFf/gq
         3cEMKMpMU40xccfiX/880zVzNz2AtwMpjPSAY=
Date: Tue, 3 May 2011 10:23:21 +0200
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
Message-ID: <20110503082321.GA6556@htj.dyndns.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304405071.3828.11.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 03, 2011 at 02:44:31PM +0800, Shaohua Li wrote:
> > As I've said several times already, I really don't like this magic
> > being done in the completion path.  Can't you detect the condition on
> > issue of the second/following flush and append it to the running list?
>
> hmm, don't understand it. blk_flush_complete_seq is called when the
> second flush is issued. or do you mean do this when the second flush is
> issued to disk? but when the second flush is issued the first flush is
> already finished.

Ah, okay, my bad.  That's the next sequence logic, so the right place.
Still, please do the followings.

* Put it in a separate patch.

* Preferably, detect the actual condition (back to back flush) rather
  than the queueability test unless it's too complicated.

* Please make pending/running paths look more symmetrical.

> > If you already have tried that but this way still seems better, can
> > you please explain why?
> > 
> > Also, this is a separate logic.  Please put it in a separate patch.
> > The first patch should implement queue holding while flushing, which
> > should remove the regression, right?
>
> ok. holding queue has no performance gain in my test, but it reduced a
> lot of request requeue.

No, holding the queue should remove the regression completely.  Please
read on.

> > Hmmm... why do you need separate ->flush_exclusive_running?  Doesn't
> > pending_idx != running_idx already have the same information?
>
> when pending_idx != running_idx, flush request is added into queue tail,
> but this doesn't mean flush request is dispatched to disk. there might
> be other requests in the queue head, which we should dispatch. And flush
> request might be reqeueud. Just checking pending_idx != running_idx will
> cause queue hang because we thought flush is dispatched and then hold
> the queue, but actually flush isn't dispatched yet, the queue should
> dispatch other normal requests.

Don't hold elv_next_request().  Hold ->elevator_dispatch_fn().

Thanks.

-- 
tejun
