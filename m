Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2BQWvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:51:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab2BQWvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:51:31 -0500
Date: Fri, 17 Feb 2012 17:51:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120217225125.GK26620@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217224103.GN29414@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 02:41:03PM -0800, Tejun Heo wrote:
> On Fri, Feb 17, 2012 at 05:34:20PM -0500, Vivek Goyal wrote:
> > Nope. We make note of task migration and drop cic->cfqq association
> > and establish a new association where new cfqq is part of new cgroup.
> > (ioc_cgroup_changed()).
> 
> Yeah, that's the CHANGED bit thing.  I probably got confused with
> blk-throttle losing blkcg while testing.  Anyways, it would be great
> if we can either remove that altogether.  e.g. compare the cached
> blkg->blkcg and see if it has changed from cfq.  Or add a callback and
> do the shootdown synchronously at least.

I think dropping it lazily has advantage as once the cic->cfqq association
is set, we don't worry about cgroups at all.

Otherwise on every IO, we will end up comparing submitting tasks's
cgroup and cic/cfqq's cgroup.

Also this will create problems, if two threads sharing io context are
in two different cgroups. We will frequently end up changing the
association.

So comparing probably is not a very good idea. Doing something
synchronously might be better if you don't like CGROUP_CHANGED
bit in ioc.

Thanks
Vivek
