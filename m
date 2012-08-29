Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab2H2RH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:07:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab2H2RHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:07:24 -0400
Date: Wed, 29 Aug 2012 13:07:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120829170711.GC12504@redhat.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829165006.GB20312@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 09:50:06AM -0700, Kent Overstreet wrote:

[..]
> > The problem is that majority of device mapper code assumes that if we 
> > submit a bio, that bio will be finished in a finite time. The commit 
> > d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1 in 2.6.22 broke this assumption.
> > 
> > I suggest - instead of writing workarounds for this current->bio_list 
> > misbehavior, why not remove current->bio_list at all? We could revert 
> > d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1, allocate a per-device workqueue, 
> > test stack usage in generic_make_request, and if it is too high (more than 
> > half of the stack used, or so), put the bio to the target device's 
> > blockqueue.
> > 
> > That could be simpler than allocating per-bioset workqueue and it also 
> > solves more problems (possible deadlocks in dm).
> 
> It certainly would be simpler, but honestly the potential for
> performance regressions scares me (and bcache at least is used on fast
> enough devices where it's going to matter). Also it's not so much the
> performance overhead - we can just measure that - it's that if we're
> just using the workqueue code the scheduler's getting involved and we
> can't just measure what the effects of that are going to be in
> production.

Are workqueues not getting involved already in your solution of punting
to rescuer thread. In the proposal above also, workers get involved
only if stack depth is too deep. So for normal stack usage performance
should not be impacted.

Performance aside, punting submission to per device worker in case of deep
stack usage sounds cleaner solution to me.

Thanks
Vivek
