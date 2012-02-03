Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab2BCVon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:44:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab2BCVom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:44:42 -0500
Date: Fri, 3 Feb 2012 16:44:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120203214435.GC12616@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
 <20120203194105.GA12616@redhat.com>
 <20120203205910.GB14209@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203205910.GB14209@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 12:59:10PM -0800, Tejun Heo wrote:
> 
> > [..]
> > > @@ -776,43 +786,49 @@ blkiocg_reset_stats(struct cgroup *cgrou
> > >  #endif
> > >  
> > >  	blkcg = cgroup_to_blkio_cgroup(cgroup);
> > > +	spin_lock(&blkio_list_lock);
> > >  	spin_lock_irq(&blkcg->lock);
> > 
> > Isn't blkcg lock enough to protect against policy registration/deregistration.
> > A policy can not add/delete a group to cgroup list without blkcg list. 
> 
> But pol list can change regardless of that, no?

Ok, looks like now it is needed because blkcg lock will just gurantee that
blkg is around but blkg->pd[plid] can disappear if you are not holding
blkio_list lock (update_root_blkgs).

I am wondering if we should take blkcg->lock if blkg is on blkcg list and
is being modified in place. That way, once we are switching elevator,
we should be able to shoot down the policy data without taking blkio_list
lock.

Thanks
Vivek
