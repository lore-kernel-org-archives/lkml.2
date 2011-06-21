Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab1FUQSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:18:44 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54692 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab1FUQSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BgBQ7bqVTsmnqUy/fnciEpt55VgAitUX5Z0clIsqqN/X3ucudaRjB+DBKxiV9Owh5i
         5u6s1ISCdpOQ8T8WUEyr+aMNc8DFUGsUOIuQoDmj2CeA/xeAi1FNbiafJM2Df73AZgcH
         jtTvEWGYru58SbJUAMNaMCSnIJ7Co8ADl1/W8=
Date: Tue, 21 Jun 2011 18:18:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/4] cgroups: Start a basic rlimit subsystem
Message-ID: <20110621161834.GA3382@somewhere.redhat.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
 <4DFEE9BE.6050501@cn.fujitsu.com>
 <20110620191126.GB1613@somewhere>
 <4E0051B5.1050708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0051B5.1050708@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 04:09:25PM +0800, Li Zefan wrote:
> 03:11, Frederic Weisbecker wrote:
> > On Mon, Jun 20, 2011 at 02:33:34PM +0800, Li Zefan wrote:
> >> Frederic Weisbecker wrote:
> >>> This starts a basic rlimit cgroup subsystem with only the
> >>> equivalent of RLIMIT_NPROC yet. This can be useful to limit
> >>> the global effects of a local fork bomb for example (local
> >>> in term of a cgroup).
> >>>
> >>> The thing is further expandable to host more general resource
> >>> limitations in the scope of a cgroup.
> >>>
> >>
> >> As this subsystem is named "rlimit", I think we should have a bigger
> >> picture about how this subsystem will be.
> >>
> >> For example, which of other RLIMIT_XXX can be make cgroup-aware in
> >> a meaningful way and which can't.
> >>
> >> Another issue is, we can apply the limit of RLIMIT_NPROC as the sum
> >> of the tasks' limit in a cgroup, but some other RLIMIT_XXX can't
> >> work in this way. Take RLIMIT_NICE for example, we can apply this
> >> limit to each of the tasks in the cgroup.
> > 
> > Looking at the other rlimit options, it seems all of them can be applied
> > to a cgroup. They just won't all be implemented the same way.
> > 
> > Those that count and limit a global user resource, like NPROC, can be
> > implemented using the res_counter charge/uncharge that propagate the
> > resource consuming to the parent cgroups.
> > 
> 
> res_counter seems a bit overkill while atomic should be sufficient for
> NPROC? Especially when it affects the fork path.

Agreed. And my first home version of this patchset was not using res_counter
but atomic ops, just because I didn't know res_counter in the beginning :)
So I have that code about ready.

That said res_counter API is still a perfect fit for this: it handles all the
tracking to the parents, the failure path, etc... It may be an overkill for
this subsystem in the implementation level, but not semantically.

Would it make sense to eventually optimize res_counter rather than creating
an ad hoc clone of it that uses atomic ops?

Note it means that instead of having this:

	spin_lock();
	if (counter + val < limit)
		counter += val;
	spin_unlock();

We'll have this:

	if (atomic_add_return(counter, val) >= limit)
		atomic_sub(counter, val)

It is fine for proc counting. But is it fine to have temporary wrong counter
for other users of res_counter? If not we can still use something based on
atomic_cmpxchg() but then I'm not sure it's worth instead of using spinlock.

> 
> Normally we want to make the impact minimal when cgroup is not used,
> so we may treat the root cgroup somewhat special, and one choice is to
> always make it resource unlimited.

Makes sense. But then it would be wiser not to create the rlim.nr_proc file
for the root cgroup. Is that possible with the current API? If not I can extend it
if needed.

> > Other rlimits that are traditionally only process wide can be implemented
> > here as a simple limit applied to all processes in the whole cgroup.
> > 
> > For example RLIMIT_CORE would be a limit in any core dump on
> > the whole cgroup.
> > 
> > RLIMIT_NOFILE would be a limit on the number of files opened by the whole
> > cgroup.
> > 
> > etc...
> > 
> > I think they all need to be treated case by case when/if users come and propose
> > more rlimit options. These don't all necessary need to mirror the setrlimit
> > options. We could pick existing ones but change a bit their semantics to fit
> > more into the cgroups meaning (as a general rule any rlimit.* file must be a
> > cgroup wide limitation), or create new rlimit options if specific needs arise.
> > 
> > There can be another kind of rlimit options that can be cgroup wide but apply
> > per process, in which case we should tweak a bit the name of the rlimit option file.
> > Consider RLIMIT_STACK for example.
> > If we want a cgroup option that applies to the total of stack used by the whole
> > cgroup, the file name would be rlim.stack. If we want that limitation to happen
> > to the whole cgroup but per process, it would be rlim.stack_per_process.
> > 
> 
> Or use a single cgroup interface for different rlimits, since all rlmits can be
> applied per process.

I'm not sure what you mean there.
