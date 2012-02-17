Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2BQRHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:07:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39018 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2BQRHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:07:21 -0500
Date: Fri, 17 Feb 2012 09:07:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] blkcg: drop unnecessary RCU locking
Message-ID: <20120217170713.GA26575@google.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-3-git-send-email-tj@kernel.org>
 <20120217161958.GB26620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217161958.GB26620@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Fri, Feb 17, 2012 at 11:19:58AM -0500, Vivek Goyal wrote:
> On Thu, Feb 16, 2012 at 02:37:51PM -0800, Tejun Heo wrote:
> > Now that blkg additions / removals are always done under both q and
> > blkcg locks, the only place RCU locking is used is blkg_lookup() for
> > lockless lookup.  This patch drops unncessary RCU locking replacing it
> > with plain blkcg / q locking as necessary.
> > 
> > * blkg_lookup_create() and blkiocg_pre_destroy() already perform
> >   proper locking and don't need RCU.  Dropped.
> 
> But blkg_lookup_create() is called under rcu() to protect blkcg pointer.
> And blkg_lookup() is also happening under same rcu read lock. So I think
> you can't drop rcu from blkg_lookup_create().

Ooh, right.  Will fix.

> >  {
> >  	struct blkio_group *blkg, *new_blkg;
> >  
> > -	WARN_ON_ONCE(!rcu_read_lock_held());
> 
> Don't we want to be called with rcu lock held needed for blkg_lookup()?

We want WARN_ON_ONCE(none of RCU, blkcg and queue lock held).  We can
do it using lockdep macros inside #ifdef CONFIG_LOCKDEP.  It's just a
bit clunky.

Thanks.

-- 
tejun
