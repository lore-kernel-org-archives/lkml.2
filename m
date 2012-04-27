Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464Ab2D0QUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:20:36 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:51286 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610Ab2D0QUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:20:18 -0400
Date: Fri, 27 Apr 2012 09:20:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Message-ID: <20120427162012.GP27486@google.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-12-git-send-email-tj@kernel.org>
 <x49wr51usxi.fsf@segfault.boston.devel.redhat.com>
 <20120427150217.GK27486@google.com>
 <20120427154033.GJ10579@redhat.com>
 <20120427154502.GM27486@google.com>
 <20120427154841.GA16237@redhat.com>
 <20120427155140.GN27486@google.com>
 <20120427155612.GK10579@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427155612.GK10579@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 27, 2012 at 11:56:12AM -0400, Vivek Goyal wrote:
> > I find allowing unpriv users creating cgroups dumb.  cgroup consumes
> > kernel memory.  Sans using kmemcg, what prevents them from creating
> > gazillion cgroups and consuming all memories?  The idea of allowing
> > cgroups to !priv users is just broken from the get go.
> 
> Well creating a task consumes memory too but we allow unpriv users to
> create tasks. :-)

We have ulimit.

> May be a system wide cgroup limit will make sense?

IMHO, this was one of the larger mistakes cgroup has made.  There are
two ways when building interface for admin stuff like this, you can
either implement and expose the core functionality and let userland
deal with distribution or build things such that the kernel can fully
virtualize and distribute the control to each process.  Both
approaches have their pros and cons but I generally think it's better
to go for the latter for new and extra stuff like cgroup as it is much
simpler and tends to more flexible and adapts better as use cases
develop.

The problem with cgroup is that it's neither the former or the latter.
It's caught somewhere in the middle with its pants down where it does
half-assed job of providing an interface which looks like it could be
made to be directly accessible from !priv processes while not really
being able to handle such usage.

I mean, just think about the case you just raised.  Forget about
memory usage.  What about weights?  If you allow a random user to
create arbitrary number of blkcg groups, [s]he gets 500 extra weight
with each blkcg!  Yeah!

If we support full hierarchy on all controllers, exposing cgroups
directly to !priv users may start to make more sense but I'd much
prefer having resource policy controlled and administered centrally in
userland.  It's a job much better suited for userland.  If such
mechanism would require certain features, sure we can accomodate that
but I think trying to allow !priv users directly to cgroup is stupid
especially at this point, so let's just drop it.

Thanks.

-- 
tejun
