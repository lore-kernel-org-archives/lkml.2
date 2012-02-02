Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab2BBUzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:55:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab2BBUzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:55:37 -0500
Date: Thu, 2 Feb 2012 15:55:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] blkcg: let blkio_group point to blkio_cgroup
 directly
Message-ID: <20120202205532.GD1723@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-2-git-send-email-tj@kernel.org>
 <20120202200318.GB1723@redhat.com>
 <20120202203352.GG19837@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202203352.GG19837@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 12:33:52PM -0800, Tejun Heo wrote:
> Hello,
> 
> On Thu, Feb 02, 2012 at 03:03:18PM -0500, Vivek Goyal wrote:
> > > +static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
> > > +{
> > > +	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
> > > +
> > >  	if (blkcg != &blkio_root_cgroup)
> > >  		kfree(blkcg);
> > 
> > What makes sure that all the blkg are gone and they have dropped their
> > reference to blkcg? IIUC, pre-destroy will just make sure to decouple
> > blkg from request queue as well as blkcg list and also drop joint cgroup
> > and request queue reference.
> > 
> > But there could well be some IO queued in the group which might have
> > its own reference and will be dropped later when IO completes. So at
> > the time of blkiocg_destroy() it is not guranteed that there are
> > no reference holders to blkcg?
> 
> Yeah, and that would wait till all css refs held by blkgs are gone,
> right?

Ok, I missed that. So ->destroy() is not called till all the css refs
are gone. So directory removal will wait for all the pending IO in the
group to finish.

I have some minor concerns here. A low prio group might not be able to
dispatch IO for quite some amount of time. Especially with CFQ, in presence of
sync IO, async IO can be starved for a very long time. So if some task
dumped bunch of low prio IO and exited and now we are removing the cgroup,
this task might have to wait for significant amount of time. (I am worried
about "hung task waited for 120 seconds kind of messages").

Also it is little unintutive to the user that why rmdir should be delayed.

Anyway, this is not a very strong concern. Just something to keep in mind.

Thanks
Vivek
