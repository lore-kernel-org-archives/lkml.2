Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2BQR3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:29:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab2BQR3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:29:02 -0500
Date: Fri, 17 Feb 2012 12:28:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] blkcg: drop unnecessary RCU locking
Message-ID: <20120217172857.GD26620@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-3-git-send-email-tj@kernel.org>
 <20120217164749.GC26620@redhat.com>
 <20120217171113.GB26575@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217171113.GB26575@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 09:11:13AM -0800, Tejun Heo wrote:
> On Fri, Feb 17, 2012 at 11:47:49AM -0500, Vivek Goyal wrote:
> > So now in some cases we call blkg_lookup_create() with both queue and rcu
> > read lock held (cfq_lookup_create_cfqg()) and in this case hold only queue
> > lock.
> 
> So, this should be okay.  It's currently not because blkg_alloc() is
> broken due to percpu allocation but other than that calling both w/
> and w/o RCU read lock should be fine.
> 
> > blkg_lookup_create() calls blkg_lookup() which expects a rcu_read_lock()
> > to be held and we will be travesing that list without rcu_read_lock()
> > held. Isn't that a problem?
> 
> No, why would it be a problem?

I am kind of confused that what are the semantics of calling
blkg_lookup_create(). Given the fact that it traverses the
blkcg->blkg_list which is rcu protected, so either we should have
rcu read lock held or we should have blkcg->lock held.

So there might not be any problem, just that looking at the code
I am not very clear abou the locking sematics of blkg_lookup(). May
be some documentation will help that it should be called with 
what locks in what situation. Specifically, when should it be called
with rcu_read_lock() held.

> 
> > We might be examining a blkg belonging to a different queue and it
> > might be being freed parallely.
> 
> How?

Can pre_destroy() and blkio_policy_parse_and_set() make progress in
parallel for same cgroup(blkcg) but different queue.

If yes, blkg_lookup() might be doing blkg->q == q check and pre_destroy
might delete that group and free it up.

Thanks
Vivek
