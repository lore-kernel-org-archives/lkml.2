Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699Ab2INRni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:43:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35515 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532Ab2INRnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:43:35 -0400
Date: Fri, 14 Sep 2012 10:43:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914174329.GD17747@google.com>
References: <20120913205827.GO7677@google.com>
 <5052E7DF.7040000@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5052E7DF.7040000@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Fri, Sep 14, 2012 at 12:16:31PM +0400, Glauber Costa wrote:
> Can we please keep some key userspace guys CCd?

Yeap, thanks for adding the ccs.

> > 1. cpu and cpuacct
...
> >   Me, working on it.
> I can work on it as well if you want. I dealt with it many times in
> the past, and tried some different approaches, so I am familiar. But
> if you're already doing it, be my guest...

I'm trying something minimal which can serve as basis for the actual
work.  I think I figured it out mostly and will probably post it later
today.  Will squeak if I get stuck.

> >   I'll do the cgroup_freezer.  I'm hoping PeterZ or someone who's
> >   familiar with the code base takes care of cpuset.  Michal, can you
> >   please take care of memcg?
> 
> I think this is a pressing problem, yes, but not the only problem with
> cgroup lock. Even if we restrict its usage to cgroup core, we still can
> call cgroup functions, which will lock. And then we gain nothing.

Can you be a bit more specific?

> And the problem is that people need to lock. cgroup_lock is needed
> because the data you are accessing is protected by it. The way I see it,
> it is incredible how we were able to revive the BKL in the form of
> cgroup_lock after we finally manage to successfully get rid of it!

I wouldn't go as far as comparing it to BKL.

> We should just start to do a more fine grained locking of data, instead
> of "stop the world, cgroup just started!". If we do that, the problem
> you are trying to address here will even cease to exist.

I'd much prefer keeping locking as simple and dumb as possible.  Let's
break it up only as absolutely necessary.

> >   memcg can be handled by memcg people and I can handle cgroup_freezer
> >   and others with help from the authors.  The problematic one is
> >   blkio.  If anyone is interested in working on blkio, please be my
> >   guest.  Vivek?  Glauber?
> 
> I am happy to help where manpower is needed, but I must node I am a bit
> ignorant of block in general.

I think blkcg can definitely make use of more manpower.  ATM, there
are two big things to do.

* Fix hierarchy support.

* Fix handling of writeback.

Both are fairly big chunk of work.

> > 6. Multiple hierarchies
> 
> Do you realize this is the exact same thing I proposed in our last
> round, and you keep screaming saying you wanted something else, right?
>
> The only difference is that the discussion at the time started by a
> forced-comount patch, but that is not the core of the question. For that
> you are proposing to make sense, the controllers need to be comounted,
> and at some point we'll have to enforce it. Be it now or in the future.
> But what to do when they are in fact comounted, I see no difference from
> what you are saying, and what I said.

Maybe I misunderstood you or from still talking about forced co-mounts
more likely you're still misunderstanding.  From what you told PeterZ,
it seemed like you were thinking that this somehow will get rid of
differing hierarchies depending on specific controllers and thus will
help, for example, the optimization issues between cpu and cpuacct.
Going back to the above example,

 Unified tree           Controller Y's view
 controller X's view

      R                          R
     / \                        / \
    A   B                      A   B
   / \
  AA AB

If a task assigned to or resourced tagged with AA, for controller X
it'll map to AA and for controller Y to A, so we would still need
css_set, which actually becomes the primary resource tag and may point
to different subsystem states depending on the specific controller.

If that is the direction we're headed, forcing co-mounts at this point
doesn't make any sense.  We'll make things which are possible today
impossible for quite a while and then restore part of it, which is a
terrible transition plan.  What we need to do is nudging the current
users away from practices which hinder implementation of the final
form and then transition to it gradually.

If you still don't understand, I don't know what more I can do to
help.

> > 7. Misc issues
> > 
> >   * Sort & unique when listing tasks.  Even the documentation says it
> >     doesn't happen but we have a good hunk of code doing it in
> >     cgroup.c.  I'm gonna rip it out at some point.  Again, if you
> >     don't like it, scream.
>
> In all honesty, I never noticed that. ugh

Yeah, tell me about it. :(

Thanks.

-- 
tejun
