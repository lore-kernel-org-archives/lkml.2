Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab1DMQ5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:57:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39261 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757436Ab1DMQ5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:57:05 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+5E5hn1WW5w2KsDKJE3Z0ZeCYwz39CXramGj7VmI
	RwWaDWyjpeSowv
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
From: Mike Galbraith <efault@gmx.de>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
References: <1302170153.12304.31.camel@marge.simson.net>
	 <4DA50430.8020701@cn.fujitsu.com>
	 <1302664313.7407.29.camel@marge.simson.net>
	 <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 18:56:59 +0200
Message-ID: <1302713819.7448.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 15:16 +0200, Paul Menage wrote:
> On Wed, Apr 13, 2011 at 5:11 AM, Mike Galbraith <efault@gmx.de> wrote:
> > If the user _does_ that rmdir(), it's more or less back to square one.
> > RCU grace periods should not impact userland, but if you try to do
> > create/attach/detach/destroy, you run into the same bottleneck, as does
> > any asynchronous GC, though that's not such a poke in the eye.  I tried
> > a straight forward move to schedule_work(), and it seems to work just
> > fine.  rmdir() no longer takes ~30ms on my box, but closer to 20us.
> 
> > +       /*
> > +        * Release the subsystem state objects.
> > +        */
> > +       for_each_subsys(cgrp->root, ss)
> > +               ss->destroy(ss, cgrp);
> > +
> > +       cgrp->root->number_of_cgroups--;
> > +       mutex_unlock(&cgroup_mutex);
> > +
> > +       /*
> > +        * Drop the active superblock reference that we took when we
> > +        * created the cgroup
> > +        */
> > +       deactivate_super(cgrp->root->sb);
> > +
> > +       /*
> > +        * if we're getting rid of the cgroup, refcount should ensure
> > +        * that there are no pidlists left.
> > +        */
> > +       BUG_ON(!list_empty(&cgrp->pidlists));
> > +
> > +       kfree(cgrp);
> 
> We might want to punt this through RCU again, in case the subsystem
> destroy() callbacks left anything around that was previously depending
> on the RCU barrier.
> 
> Also, I'd be concerned that subsystems might get confused by the fact
> that a new group called 'foo' could be created before the old 'foo'
> has been cleaned up? (And do any subsystems rely on being able to
> access the cgroup dentry up until the point when destroy() is called?

Yeah, I already have head scratching sessions planned for these, why I
used 'seems' to work fine, and Not-signed-off-by: :)

	-Mike

