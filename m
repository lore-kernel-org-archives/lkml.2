Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871Ab2D0RVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:21:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760225Ab2D0RVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:21:19 -0400
Date: Fri, 27 Apr 2012 13:21:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Message-ID: <20120427172110.GM10579@redhat.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-12-git-send-email-tj@kernel.org>
 <x49wr51usxi.fsf@segfault.boston.devel.redhat.com>
 <20120427150217.GK27486@google.com>
 <20120427154033.GJ10579@redhat.com>
 <20120427154502.GM27486@google.com>
 <20120427154841.GA16237@redhat.com>
 <20120427155140.GN27486@google.com>
 <20120427155612.GK10579@redhat.com>
 <20120427162012.GP27486@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427162012.GP27486@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 09:20:12AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Fri, Apr 27, 2012 at 11:56:12AM -0400, Vivek Goyal wrote:
> > > I find allowing unpriv users creating cgroups dumb.  cgroup consumes
> > > kernel memory.  Sans using kmemcg, what prevents them from creating
> > > gazillion cgroups and consuming all memories?  The idea of allowing
> > > cgroups to !priv users is just broken from the get go.
> > 
> > Well creating a task consumes memory too but we allow unpriv users to
> > create tasks. :-)
> 
> We have ulimit.
> 
> > May be a system wide cgroup limit will make sense?
> 
> IMHO, this was one of the larger mistakes cgroup has made.  There are
> two ways when building interface for admin stuff like this, you can
> either implement and expose the core functionality and let userland
> deal with distribution or build things such that the kernel can fully
> virtualize and distribute the control to each process.  Both
> approaches have their pros and cons but I generally think it's better
> to go for the latter for new and extra stuff like cgroup as it is much
> simpler and tends to more flexible and adapts better as use cases
> develop.
> 
> The problem with cgroup is that it's neither the former or the latter.
> It's caught somewhere in the middle with its pants down where it does
> half-assed job of providing an interface which looks like it could be
> made to be directly accessible from !priv processes while not really
> being able to handle such usage.
> 
> I mean, just think about the case you just raised.  Forget about
> memory usage.  What about weights?  If you allow a random user to
> create arbitrary number of blkcg groups, [s]he gets 500 extra weight
> with each blkcg!  Yeah!

This is a concern only with flat hierarhcy. With full hierarchcal
it becomes a non-issue like cpu controller.

> 
> If we support full hierarchy on all controllers, exposing cgroups
> directly to !priv users may start to make more sense but I'd much
> prefer having resource policy controlled and administered centrally in
> userland.  It's a job much better suited for userland.  If such
> mechanism would require certain features, sure we can accomodate that
> but I think trying to allow !priv users directly to cgroup is stupid
> especially at this point, so let's just drop it.

For non-priviliged users, something along the lines of per session
cpu autogroup might make sense.  But even then if some IO is submitted
from that autoblkgroup, kernel can't claim that memory till IO is
completed.

So per cgroup number of request will probably be a problem even if
kenrel managed those completely.

So are you planning to put a patch in kernel to disallow cgroup creation
for non-priviliged users?

I am CCing Daniel Berrange (libvirt), who create cgroups for virtual
machines and containers. Just in case he is relying on creating cgroups
in unprivliged mode.

Thanks
Vivek
