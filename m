Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab2BBUns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:43:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab2BBUnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:43:47 -0500
Date: Thu, 2 Feb 2012 15:43:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] blkcg: unify blkgs for different policies
Message-ID: <20120202204342.GB30258@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <20120202192958.GA1723@redhat.com>
 <20120202203609.GI19837@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202203609.GI19837@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 12:36:09PM -0800, Tejun Heo wrote:
> Hello,
> 
> On Thu, Feb 02, 2012 at 02:29:58PM -0500, Vivek Goyal wrote:
> > On Wed, Feb 01, 2012 at 01:19:05PM -0800, Tejun Heo wrote:
> > 
> > [..]
> > > 
> > > * use unified stats updated under queue lock and drop percpu stats
> > >   which should fix locking / context bug across percpu allocation.
> > 
> > Does that mean that stat updation will happen under queue lock even if
> > there are no throttling rules? That will introduce extra queue lock on
> > fast path those who have throttling compiled in but are not using (common
> > case for distributions).
> 
> No, I don't think extra locking would be necessary at all.  We end up
> grabbing queue_lock anyway.  It's just the matter of where to update
> the stats.

What about bio based drivers? They might have their own internal locking
and not relying on queue lock. And conceptually, we first throttle the
bio, update the stats and then call into driver. So are you planning
to move blk_throtl_bio() call into request function of individual driver
to avoid taking queue lock twice.

In fact even for request based drivers, if bio is being merged onto
existing request on plug, we will not take any queue lock. So I am not
sure how would you avoid extra queue lock for this case.

Thanks
Vivek
