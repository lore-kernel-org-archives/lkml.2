Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2BUVVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:21:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44510 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2BUVVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:21:10 -0500
Date: Tue, 21 Feb 2012 13:21:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120221212106.GF12236@google.com>
References: <20120221211938.GE12236@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221211938.GE12236@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, forgot to cc hch.  Cc'ing him and quoting whole message.

On Tue, Feb 21, 2012 at 01:19:38PM -0800, Tejun Heo wrote:
> Hello, guys.
> 
> I've been thinking about multiple hierarchy support in cgroup for a
> while, especially after Frederic's pending task counter patchset.
> This is a write up of what I've been thinking.  I don't know what to
> do yet and simply continuing the current situation definitely is an
> option, so please read on and throw in your 20 Won (or whatever amount
> in whatever currency you want).
> 
> * The problems.
> 
> The support for multiple process hierarchies always struck me as
> rather strange.  If you forget about the current cgroup controllers
> and their implementations, the *only* reason to support multiple
> hierarchies is if you want to apply resource limits based on different
> orthogonal categorizations.
> 
> Documentation/cgroups.txt seems to be written with this consideration
> on mind.  It's giving an example of applying limits accoring to two
> orthogonal categorizations - user groups (profressors, students...)
> and applications (WWW, NFS...).  While it may sound like a valid use
> case, I'm very skeptical how useful or common mixing such orthogonal
> categorizations in a single setup would be.
> 
> If support for multiple hierarchies comes for free, at least in terms
> of features, maybe it can be better but of course it isn't so.  Any
> given cgroup subsystem (or controller) can only be applied to a single
> hierarchy, which makes sense for a lot of things - what would two
> different limits on the same resource from different hierarchies mean?
> But, there also are things which can be used and useful in all
> hierarchies - e.g. cgroup freezer and task counter.
> 
> While the current cgroup implementation and conventions can probably
> allow admins and engineers to tailor cgroup configuration for a
> specific setup, it is very difficult to use in generic and automated
> way.  I mean, who owns the freezer or task counter?  If they're
> mounted on their own hierarchies, how should they be structured?
> Should the different hierarchies be structured such that they are
> projections of one unified hierarchy so that those generic mechanisms
> can be applied uniformly?  If so, why do we need multiple hierarchies
> at all?
> 
> A related limitation is that as different subsystems don't know which
> hierarchies they'll end up on, they can't cooperate.  Wouldn't it make
> more sense if task counter is a separate thing watching the resources
> and triggers different actions as conifgured - be it failing forks or
> freezing?
> 
> And yet another oddity is how cgroup handles nested cgroups - some
> care about nesting but others just treat both internal and leaf nodes
> equally.  They don't care about the topology at all.  This, too, can
> be fine if you approach things subsys by subsys and use them in
> different ways but if you try to combine them in generic way you get
> sucked into the lala land of whatevers.
> 
> The following is a "best practices" document on using cgroups.
> 
>   http://www.freedesktop.org/wiki/Software/systemd/PaxControlGroups
> 
> To me, it seems to demonstrate the rather ugly situation that the
> current cgroup is providing.  Everyone should tip-toe around cgroup
> hierarchies and nobody has full knowledge or control over them.
> e.g. base system management (e.g. systemd) can't use freezer or task
> counter as someone else might want to use it for different hierarchy
> layout.
> 
> It seems to me that cgroup interface is too complicated and inflexible
> at the same time to be useful in generic manner.  Sure, it can be
> useful for setups individually crafted by engineers and admins to
> match specific sites or applications but as soon as you try to do
> something automatic and generic with it, there just are too many
> different scenarios and limitations to consider.
> 
> 
> * So, what to do?
> 
> Heh, I don't know.  IIRC, last year at LinuxCon Japan, I heard
> Christoph saying that the biggest problem w/ cgroup was that it was
> building completely separate hierarchies out of the traditional
> process hierarchies.  After thinking about this stuff for a while, I
> fully agree with him.  I think this whole thing should have been a
> layer over the process tree like sessions or program groups.
> 
> Unfortunately, that ship sailed long ago and we gotta make do with
> what we have on our collective hands.  Here are some paths that we can
> take.
> 
> 1. We're screwed anyway.  Just don't worry about it and continue down
>    on this path.  Can't get much worse, right?
> 
>    This approach has the apparent advantage of not having to do
>    anything and is probably most likely to be taken.  This isn't ideal
>    but hey nothing is. :P
> 
> 2. Make it more flexible (and likely more complex, unfortunately).
>    Allow the utility type subsystems to be used in multiple
>    hierarchies.  The easiest and probably dirtiest way to achieve that
>    would be embedding them into cgroup core.
> 
>    Thinking about doing this depresses me and it's not like I have a
>    cheerful personality to begin with. :(
> 
> 3. Head towards single hierarchy with the pie-in-the-sky goal of
>    merging things into process hierarchy in some distant future.
> 
>    The first step would be herding people to use a unified hierarchy
>    (ie. all subsystems mounted on a single cgroup tree) which is
>    controlled by single entity in userland (be it systemd or cgroupd,
>    cgroup-kit or whatever); however, even if we exclude supporting
>    orthogonal categorizations, there are good number of non-trivial
>    hurdles to clear before this can be realized.
> 
>    Most importantly, we would need to clean up how nesting is handled
>    across different subsystems.  Handling internal and leaf nodes as
>    equals simply can't work.  Membership should be recursive, and for
>    subsystems which can't support proper nesting, the right thing to
>    do would be somehow ensuring that only single node in the path from
>    root to leaf is active for the controller.  We may even have to
>    introduce an alternative of operation to support this (yuck).
> 
>    This path would require the most amount of work and we would be
>    excluding a feature - support for multiple orthogonal
>    categorizations - which has been available till now, probably
>    through deprecation process spanning years; however, this at least
>    gives us hope that we may reach sanity in the end, how distant that
>    end may be.  Oh, hope. :)
> 
> So, I mean, I don't know.  What do other people think?  Is this a
> unnecessary worry?  Are people generally happy with the way things
> are?  Lennart, Kay, what do you guys think?
> 
> Thanks.
> 
> --
> tejun

-- 
tejun
