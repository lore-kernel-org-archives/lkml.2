Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab2DMUzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:55:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab2DMUzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:55:09 -0400
Date: Fri, 13 Apr 2012 16:55:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 07/11] blkcg: make request_queue bypassing on allocation
Message-ID: <20120413205501.GL26383@redhat.com>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
 <1334347895-6268-8-git-send-email-tj@kernel.org>
 <20120413203205.GI26383@redhat.com>
 <20120413203726.GE12233@google.com>
 <20120413204446.GK26383@redhat.com>
 <20120413204710.GF12233@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413204710.GF12233@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 01:47:10PM -0700, Tejun Heo wrote:
> On Fri, Apr 13, 2012 at 04:44:46PM -0400, Vivek Goyal wrote:
> > On Fri, Apr 13, 2012 at 01:37:26PM -0700, Tejun Heo wrote:
> > 
> > [..]
> > > blk_cleanup_queue() doesn't use blk_queue_bypass_start() to enter
> > > bypass mode.
> > 
> > Oh now elevator_exit() has been moved into blk_release_queue(). But
> > problem will still be there, isn't it? During driver init, most likely driver
> > is holding last reference of the queue and blk_release_queue() will be called
> > in the context of blk_cleanup_queue() causing the overhead?
> 
> Hmmm?  blk_cleanup_queue() will put the queue into bypassing mode
> without going through synchronize_rcu() and all the following
> bypassing operations just inc/decs bypass_depth without any draining
> operation.

Ok, this is non-obivirious part. The very reason you could do the
optimzation of synchronize_rcu(), was the fact that either somebody
has already called synchronize_rcu() (first caller of blk_bypass_start())
or we know that it is not needed (as we are instanciating queue and no
IO could be going on).

But neither seems to be the case here. So to make sure that blkg_lookup()
under rcu will see the updated value of queue flag (bypass), are we
relying on the fact that caller should see the DEAD flag and not go
ahead with blkg_lookup()?  If yes, atleast it is not obivious.

Thanks
Vivek
