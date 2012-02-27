Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2B0RqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:46:22 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64561 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2B0RqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:46:19 -0500
Date: Mon, 27 Feb 2012 18:46:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        linux-kernel@vger.kernel.org, Paul Menage <paul@paulmenage.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120227174610.GC30232@somewhere.redhat.com>
References: <20120221211938.GE12236@google.com>
 <20120222154501.GA1693@somewhere.redhat.com>
 <20120222182207.GC32694@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222182207.GC32694@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:22:07AM -0800, Tejun Heo wrote:
> Hey, Frederic.
> 
> On Wed, Feb 22, 2012 at 04:45:04PM +0100, Frederic Weisbecker wrote:
> > > A related limitation is that as different subsystems don't know which
> > > hierarchies they'll end up on, they can't cooperate.  Wouldn't it make
> > > more sense if task counter is a separate thing watching the resources
> > > and triggers different actions as conifgured - be it failing forks or
> > > freezing?
> > 
> > For this particular example, I think we'd better have a file in which
> > a task can poll and get woken up when the task limit has been reached.
> > Then that task can decide to freeze or whatever.
> 
> Yes, that may be a solution but to "guarantee" that the limit is never
> breached, we need to stop it first somehow.  Probably making freezing
> the default behavior with userland notifier (inotify event should
> suffice) should do, which we can't do now. :(

The limit can't be breached because forks are rejected once we reached the
limit given by the user.

With this rejection, another task can take control of this and freeze the
cgroup.

> 
> > > 1. We're screwed anyway.  Just don't worry about it and continue down
> > >    on this path.  Can't get much worse, right?
> > > 
> > >    This approach has the apparent advantage of not having to do
> > >    anything and is probably most likely to be taken.  This isn't ideal
> > >    but hey nothing is. :P
> > 
> > Thing is we have an ABI now and it has been there for a while now. Aren't
> > we stuck with it? I'm no big fan of that multiple hierarchies thing either
> > but now I fear we have to support it.
> 
> Well, yes and no.  While maintaining userland ABI is very important,
> its importance isn't infinite and there are different types of
> userland ABIs.  We definitely don't want to screw with syscalls.  We
> should keep userland visible dynamic files which are used by common
> usertools stable at almost all costs.  When it comes over to system
> interface which is used mostly by base system tools, it can be a bit
> flexible.  If the ABI in question is an optional thing, we probably
> can be slightly more flexible.

But cgroups falls into the general purpose category to me. Not something
that was used only by a finite circle of a few well known and defined tools.

> We of course can't change things drastically.  It should be done
> carefully with rather long deprecation period, but it can be done and
> in fact isn't too uncommon.  Stuff under /sysfs tends to be somewhat
> volatile and sysfs itself went through several ABI incompatible
> iterations.
> 
> So, we can transition in baby steps.  e.g. we can first implement
> proper nesting behavior without changing the default behavior and then
> the base system can be updated to mount and control all subsystems by
> default (with configuration opt-outs) so that the hierarchy reflects
> pstree, effectively driving people away from multiple hierarchies and
> we can implement new features assuming the new structure.  After a few
> years, the kernel can start whining about non-start hierarchies and
> then eventually remove the support.  It's a long process but
> definitely doable.

Well, if we can I'll be glad.

> 
> > > 2. Make it more flexible (and likely more complex, unfortunately).
> > >    Allow the utility type subsystems to be used in multiple
> > >    hierarchies.  The easiest and probably dirtiest way to achieve that
> > >    would be embedding them into cgroup core.
> > > 
> > >    Thinking about doing this depresses me and it's not like I have a
> > >    cheerful personality to begin with. :(
> > 
> > Another solution is to support a class of multi-bindable subsystems as in
> > this old patch from Paul:
> > 
> > 	https://lkml.org/lkml/2009/7/1/578
> 
> Heh, yeah, this would be closer to the proper way to achieve
> multi-attach but I can't help feeling that this just buries ourselves
> deeper into s*it and we're already knee-deep.  If multiple hierarchies
> is an essential feature, maybe, but, if it's not, and I'm extremely
> skeptical that it is, why the hell would we want to go that way?

I don't know, it just depend what will happen on these multiple
hierarchies.

> 
> > It sounds to me more healthy to iterate only over subsystems in fork/exit.
> > We probably don't want to add a new iteration over cgroups themselves
> > on these fast path.
> 
> Hmmm?  Don't follow why this is relevant.

If you make something a cgroup core feature instead of a subsystem and you
need to do something on these cgroups during forks, then you need to
iterate over these as well as the subsystems.

Typically adding some more loop on fork is not considered very welcome.

> 
> Thanks.
> 
> -- 
> tejun
