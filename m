Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab2BQWjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:39:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54583 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab2BQWjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:39:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.216.195 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Fri, 17 Feb 2012 14:38:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120217223859.GM29414@google.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217213313.GG26620@redhat.com>
 <20120217220351.GI29414@google.com>
 <20120217222909.GI26620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217222909.GI26620@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 17, 2012 at 05:29:09PM -0500, Vivek Goyal wrote:
> Don't we already keep track of task changing cgroup and record that
> state in ioc.
> 
> blkiocg_attach()
>   ioc_cgroup_changed()
> 
> I think in ioc_cgroup_changed() we can just drop the reference to previous
> blkcg and store reference to new blkcg?

Hmmm.... right, we have that; then, why doesn't cgroup change take
effect w/ cfq?  Maybe it actually works and I confused it with
stacking failure.  Will test again later.

But, anyways, ioc isn't keeping track of blkcg.  The changed thing is
necessary only because cfq is caching the relationship as associated
cfqqs.  I think it would be better if cfq can just compare the current
blkcg without requiring the async notification (or at least do it
synchronously).  The current way of handling it is kinda nasty.

> BTW, this change seems to be completely orthogonal to blkcg cleanup. May
> be it is a good idea to split it out in a separate patch series. It has
> nothing to do with rcu cleanup in blkcg.

At first, it required the locking update because I was determining
blkg association on bio issue and then passing it down.  That didn't
work with cfq caching the association, so it no longer has dependency.
It should can be a separate patchset.  This whole lot is gonna go in
as long sequential series of patches so I'm splitting them just so
that each posting isn't too huge at this point.

Thanks.

-- 
tejun
