Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1HISd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:33:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab1HISd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:33:56 -0400
Date: Tue, 9 Aug 2011 14:33:47 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>,
        dm-devel@redhat.com
Subject: Re: block: properly handle flush/fua requests in
 blk_insert_cloned_request
Message-ID: <20110809183345.GB13293@redhat.com>
References: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
 <20110809153826.GB23842@htj.dyndns.org>
 <x49liv2eg34.fsf@segfault.boston.devel.redhat.com>
 <20110809161334.GC23842@htj.dyndns.org>
 <20110809174347.GA13293@redhat.com>
 <20110809175110.GE23842@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809175110.GE23842@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09 2011 at  1:51pm -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Tue, Aug 09, 2011 at 01:43:47PM -0400, Mike Snitzer wrote:
> > [cc'ing dm-devel]
> > 
> > All of these issues have come to light because DM was not setting
> > flush_flags based on the underlying device(s).  Now fixed in v3.1-rc1:
> > ed8b752 dm table: set flush capability based on underlying devices
> > 
> > Given that commit, and that request-based DM is beneath the elevator, it
> > seems any additional effort to have DM flushes re-enter the flush
> > machinary is unnecessary.
> 
> Hmmm... what if the underlying devices have different featureset?  Use
> the lowest common denominator?

Yes, for DM, if any device in the stack requires FLUSH/FUA then
the upper request_queue's flush_flags will be set to reflect that.

Bio-based DM _could_ end up issuing a flush to a device that doesn't
need the flush.  But once the bio emerges from the bottom of the
bio-based stack it'll get handed to the flush mechanism where it'll be
dropped.

Bio-based DM may stack ontop of request-based DM (think LVM ontop of
mpath device).  Request-based DM may _not_ stack on bio-based DM.

Request-based DM, the cause of all this discussion, is only used for the
multipath target and I'm not aware of any plans to provide more complex
stacking via request-based DM.  Doing so would require splitting a
request that spans target boundaries, etc.

So we're left with request-based DM only allowing a single target,
meaning: even if request-based DM were stacked a couple times the
flush_flags would still reflect the underlying physical device's queue.

> The flush mechanism is designed to
> deal with stacking by going through flush at each level.  Stacking
> queue can simply export support for both REQ_FLUSH and FUA and the
> lower lever queue will decompose them according to the capability
> supported by the actual device.
> 
> IIUC, what's broken here is some insert functions aren't using
> ELEVATOR_INSERT_FLUSH when needed and there are some issues due to the
> special nature of the stacked requests which I think should be fixed.

OK, conceptually pure, just seems the fixes are multiplying.
