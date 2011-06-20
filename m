Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab1FTTLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:11:44 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51398 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab1FTTLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:11:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dq3iHO6nior+eLnkqdyerGxPWmlxFinXB+qWubmYIsc/sV71D67eQJqFqWhFOSV6zu
         v7NKDsTyccHioFmRend3pf4/9bV5+S+VXmSst5R4Vd+vOsSSo4cxTuvHbcNTS3Z2D73e
         gsPcLYglDCyH8ROTqVoQTZe9Kr6PiTLX/EWyQ=
Date: Mon, 20 Jun 2011 21:11:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/4] cgroups: Start a basic rlimit subsystem
Message-ID: <20110620191126.GB1613@somewhere>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
 <4DFEE9BE.6050501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFEE9BE.6050501@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 02:33:34PM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > This starts a basic rlimit cgroup subsystem with only the
> > equivalent of RLIMIT_NPROC yet. This can be useful to limit
> > the global effects of a local fork bomb for example (local
> > in term of a cgroup).
> > 
> > The thing is further expandable to host more general resource
> > limitations in the scope of a cgroup.
> > 
> 
> As this subsystem is named "rlimit", I think we should have a bigger
> picture about how this subsystem will be.
> 
> For example, which of other RLIMIT_XXX can be make cgroup-aware in
> a meaningful way and which can't.
> 
> Another issue is, we can apply the limit of RLIMIT_NPROC as the sum
> of the tasks' limit in a cgroup, but some other RLIMIT_XXX can't
> work in this way. Take RLIMIT_NICE for example, we can apply this
> limit to each of the tasks in the cgroup.

Looking at the other rlimit options, it seems all of them can be applied
to a cgroup. They just won't all be implemented the same way.

Those that count and limit a global user resource, like NPROC, can be
implemented using the res_counter charge/uncharge that propagate the
resource consuming to the parent cgroups.

Other rlimits that are traditionally only process wide can be implemented
here as a simple limit applied to all processes in the whole cgroup.

For example RLIMIT_CORE would be a limit in any core dump on
the whole cgroup.

RLIMIT_NOFILE would be a limit on the number of files opened by the whole
cgroup.

etc...

I think they all need to be treated case by case when/if users come and propose
more rlimit options. These don't all necessary need to mirror the setrlimit
options. We could pick existing ones but change a bit their semantics to fit
more into the cgroups meaning (as a general rule any rlimit.* file must be a
cgroup wide limitation), or create new rlimit options if specific needs arise.

There can be another kind of rlimit options that can be cgroup wide but apply
per process, in which case we should tweak a bit the name of the rlimit option file.
Consider RLIMIT_STACK for example.
If we want a cgroup option that applies to the total of stack used by the whole
cgroup, the file name would be rlim.stack. If we want that limitation to happen
to the whole cgroup but per process, it would be rlim.stack_per_process.
