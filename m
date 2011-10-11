Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1JKNkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:40:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49154 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab1JKNkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:40:35 -0400
Date: Tue, 11 Oct 2011 15:40:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm00@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, "Daniel J. Walsh" <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Aditya Kali <adityakali@google.com>,
        Oleg Nesterov <oleg@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Tim Hockin <thockin@hockin.org>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
Message-ID: <20111011134022.GA16777@somewhere.redhat.com>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <20111004150111.e9337268.akpm00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004150111.e9337268.akpm00@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 03:01:11PM -0700, Andrew Morton wrote:
> On Mon,  3 Oct 2011 21:07:02 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi Andrew,
> > 
> > This contains minor changes, mostly documentation and changelog
> > updates, off-case build fix, and a code optimization in
> > res_counter_common_ancestor().
> 
> I'd normally duck a patch series like this when we're at -rc8 and ask
> for it to be resent late in -rc1.  But I was feeling frisky so I
> grabbed this lot for a bit of testing and will sit on it until -rc1.
> 
> I'm still not convinced that the kernel has a burning need for a "task
> counter subsystem".  Someone convince me that we should merge this!

(Adding more people in Cc with whom I discussed this and who got
nice insights about the issues and the needs).

In practice we need it for Lxc to secure containers. Since you wrote
me that email last week I've tried to think more about another
solution to protect containers against forkbomb by reusing an exisiting
feature instead of pushing a new subsystem and ABI.

So I've been thinking about using user namespaces. The idea is
to create the container with a process forked with CLONE_NEWUSER
such that its NR_PROC rlimit only applies to it and its children.
This way we can have our per container limitation given we have
one namespace per container.

But discussing this with other people, this doesn't work anymore
as soon as we want to contain privilege processes or multi-user
applications. Privilege processes can spawn new users at will
and with multi-user we can't anymore have a global limit over
the container.

As far as I explored the issue, discussing this with lxc guys,
having that limit per cgroup is the only thing that seem to
work in any case.

But if somebody finds another way to solve that with existing
features or something more simple, I'll be happy to drop this
patchset.

> 
> > It's hard to put some statistic numbers while testing this feature
> > given that the result is rather binary: we launch a forkbomb and
> > either we stop and kill it or the system become unresponsive.
> >     
> > Meanwhile, one can find a testsuite at this address:
> > https://tglx.de/~fweisbec/task_counter_test.tar.gz
> 
> I do think that we should merge tests like this into the main tree.  So
> I can do "cd tests ; make ; ./run-tests".  The first step is for some hero
> to propose the (simple!) framework and to drop a first test in there.

I can do that. Some general tools/test/ directory that can host this one
and more.

> > It performs several checks to ensure the interface and the behaviour
> > are reliable after common events like moving tasks around over cgroups
> > in a hierarchy, forking inside, etc.. It also launches a forkbomb,
> > tries to stop and kill it. So beware, don't run it on a system that
> > is doing serious things.
> 
> Good stuff, that.  Then, when people propose additions or fix bugs, I can
> whine at them for not updating the test suite.
> 
> > Ensure you have CGROUP_TASK_COUNTER set
> > before, or it may compress the Ten Plagues in your MBR and
> > inflate the whole after your next reboot.
> 
> That problem would need to be fixed.  Either probe for the feature
> up-front, or don't build the test at all if CONFIG_CGROUP_TASK_COUNTER=n.
> 

Agreed. The simplest is to try to mount this subsystem and just give
up the test if we can't.

Will fix.

Thanks.
