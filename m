Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab2DMRXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:23:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab2DMRXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:23:42 -0400
Date: Fri, 13 Apr 2012 13:23:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 5/8] blkcg: make sure blkg_lookup() returns %NULL if @q
 is bypassing
Message-ID: <20120413172336.GF26383@redhat.com>
References: <1334273380-30233-1-git-send-email-tj@kernel.org>
 <1334273380-30233-6-git-send-email-tj@kernel.org>
 <20120413160053.GE26383@redhat.com>
 <20120413170334.GB12233@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413170334.GB12233@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 10:03:34AM -0700, Tejun Heo wrote:
> Hey,
> 
> On Fri, Apr 13, 2012 at 12:00:53PM -0400, Vivek Goyal wrote:
> > On Thu, Apr 12, 2012 at 04:29:37PM -0700, Tejun Heo wrote:
> > 
> > [..]
> > >   * In bypass mode, only the dispatch FIFO queue of @q is used.  This
> > >   * function makes @q enter bypass mode and drains all requests which were
> > >   * throttled or issued before.  On return, it's guaranteed that no request
> > > - * is being throttled or has ELVPRIV set.
> > > + * is being throttled or has ELVPRIV set and blk_queue_bypass() is %true
> > > + * inside queue or RCU read lock.
> > >   */
> > >  void blk_queue_bypass_start(struct request_queue *q)
> > >  {
> > > @@ -426,6 +427,7 @@ void blk_queue_bypass_start(struct request_queue *q)
> > >  	spin_unlock_irq(q->queue_lock);
> > >  
> > >  	blk_drain_queue(q, false);
> > > +	synchronize_rcu();
> > 
> > I guess this synchronize_rcu() needs some comments here to make it clear
> > what it meant for. IIUC, you are protecting against policy data (stats
> > update) which happen under rcu in throttling code? You want to make sure
> > all these updaters are done before you go ahead with
> > activation/deactivation of a policy.
> > 
> > Well, I am wondering if CFQ is policy being activated/deactivated why
> > should we try to drain other policie's requests. Can't one continue
> > to work without draining all the throttled requests. We probably just
> > need to make sure new groups are not created.
> 
> So, I think synchronization rules like this are something which the
> core should define.  cfq may not use it but the sync rules should
> still be the same for all policies.  In this case, what the core
> provides is "blk_queue_bypass() is guaranteed to be seen as %true
> inside RCU read lock section once this function returns", which in
> turn will guarantee that RCU read-lock protected blkg_lookup() is
> guaranteed to fail once the function returns.  This property makes RCU
> protected blkg_lookup() safe against queue bypassing, which is what we
> want.

I think now synchronize_rcu() has become part of cfq_init_queue()
effectively and that will slow down boot. In the past I had to remove
it.

Thanks
Vivek
