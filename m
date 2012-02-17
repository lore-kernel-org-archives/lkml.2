Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab2BQW3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:29:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab2BQW3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:29:14 -0500
Date: Fri, 17 Feb 2012 17:29:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120217222909.GI26620@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217213313.GG26620@redhat.com>
 <20120217220351.GI29414@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217220351.GI29414@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 02:03:51PM -0800, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Fri, Feb 17, 2012 at 04:33:13PM -0500, Vivek Goyal wrote:
> > On Thu, Feb 16, 2012 at 02:37:56PM -0800, Tejun Heo wrote:
> > 
> > [..]
> > > This patch implements bio_associate_current() which associates the
> > > specified bio with %current.  The bio will record the associated ioc
> > > and blkcg at that point and block layer will use the recorded ones
> > > regardless of which task actually ends up issuing the bio.  bio
> > > release puts the associated ioc and blkcg.
> > 
> > How about storing blkcg information in io_context instead of bio. We will
> > have less copies of bio pointers and I think logically it makes sense.
> 
> I don't know.  The problem with that approach is that we introduce a
> persistent state which needs to be kept in sync.  cgroup is a task
> property and the current code just grabs the current cgroup of
> %current and uses it for that bio.  It doesn't matter how the task
> changes its cgroup membership later - we're correct (in a sense) no
> matter what.  If we add cgroup pointer to ioc, we need to keep that in
> sync with task changing cgroup memberships and need to introduce
> synchronization scheme for accessing ioc->blkcg, which is a much
> bigger headache.

Don't we already keep track of task changing cgroup and record that
state in ioc.

blkiocg_attach()
  ioc_cgroup_changed()

I think in ioc_cgroup_changed() we can just drop the reference to previous
blkcg and store reference to new blkcg?

> 
> I think it's better to take an explicit ref now.  If the situation
> changes, it's an implementation detail only known to block layer
> proper anyway, so we should be able to change it without too much
> difficulty.

I am fine with changing it later too.

BTW, this change seems to be completely orthogonal to blkcg cleanup. May
be it is a good idea to split it out in a separate patch series. It has
nothing to do with rcu cleanup in blkcg.

Thanks
Vivek
