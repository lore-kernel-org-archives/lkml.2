Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab2BQSIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:08:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab2BQSIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:08:05 -0500
Date: Fri, 17 Feb 2012 13:08:00 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] blkcg: drop unnecessary RCU locking
Message-ID: <20120217180800.GE26620@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-3-git-send-email-tj@kernel.org>
 <20120217164749.GC26620@redhat.com>
 <20120217171113.GB26575@google.com>
 <20120217172857.GD26620@redhat.com>
 <20120217174304.GC29414@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217174304.GC29414@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 09:43:04AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 17, 2012 at 12:28:57PM -0500, Vivek Goyal wrote:
> > I am kind of confused that what are the semantics of calling
> > blkg_lookup_create(). Given the fact that it traverses the
> > blkcg->blkg_list which is rcu protected, so either we should have
> > rcu read lock held or we should have blkcg->lock held.
> 
> Modifying blkgs require both blkcg and queue locks,

> so read access can be done holding any lock.

This is the point I am not getting. How blkg_lookup() is safe just
under queue lock. What stops freeing up blkg associated with other
queues. I thought caller needs to hold rcu_read_lock() also to
make sure it can safely compare blkg->q == q and return the blkg
belonging to the queue in question.

> > 
> > Can pre_destroy() and blkio_policy_parse_and_set() make progress in
> > parallel for same cgroup(blkcg) but different queue.
> > 
> > If yes, blkg_lookup() might be doing blkg->q == q check and pre_destroy
> > might delete that group and free it up.
> 
> And that's why __blkg_release() is RCU free'ing blkgs, no?

Yes. And you are not holding rcu_read_lock() while doing blkg_lookup()
in blkio_policy_parse_and_set(). Just queue lock will not be enough?

Thanks
Vivek
