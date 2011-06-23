Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab1FWNaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:30:08 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60197 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab1FWNaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tLtxFHJRDMyawrl2QKevLqUfkU6HQYokudblwbrQvwPYcMIXuk5SVs67Z9wYDj4cXp
         D1YH23K7qLfsE47Nan7h2jTaKB691E4u5dqp44G5V99q0prFlQB+bb/39+1sghfFtWxw
         umPxIS8V7VyKvlPntA6+P5nTBG8RFYPYl/8RQ=
Date: Thu, 23 Jun 2011 15:30:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Menage <menage@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/4] cgroups: Start a basic rlimit subsystem
Message-ID: <20110623132957.GA8058@somewhere.redhat.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
 <BANLkTineKOcQDzMrCdmizOhUGz+cViTomA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTineKOcQDzMrCdmizOhUGz+cViTomA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:08:26AM -0700, Paul Menage wrote:
> Hi Frederick,
> 
> On Sun, Jun 19, 2011 at 4:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > This starts a basic rlimit cgroup subsystem with only the
> > equivalent of RLIMIT_NPROC yet. This can be useful to limit
> > the global effects of a local fork bomb for example (local
> > in term of a cgroup).
> 
> My general thoughts on this are:
> 
> - do we really want an "rlimit" subsystem rather than grouping things
> functionally? We definitely shouldn't just stuff things in here
> because they happen to be controlled via setrlimit currently. Also,
> some limits might fit more appropriately in other subsystems. (E.g.
> max locked memory should be a memcg field, and real-time priority
> should be in the cpu subsystem if it's not already subsumed by
> existing functionality). Grouping "rlimit" things together in a single
> subsystem reduces flexibility, since you can't then mount them on
> separate hierarchies. (This is actually related to one of my regrets
> about the original implementation of cgroups - the cpuset subsystem
> should have been split into a "cpunode" subsystem and a "memnode"
> subsystem, since the two parts of cpusets had no requirement to be
> located together - they were only linked since before cgroups there
> was no way to mount them separately).
> 
> A lot of the rlimit values are more for the benefit of the process (to
> prevent runaways) rather than for resource isolation - data segment
> size, file size, stack size, pending signals, virtual memory limits
> fall into that category, i think - they're all resource usage that
> falls under existing cgroup resource limits, such as
> memory.limit_in_bytes.

Yeah I all agree with you. To mimic rlmit inside a cgroup subsystem
would be a bad thing given we already have subsystems where some of
the rlimit options can fit and moreover your message made me read
again the part about hierarchies in cgroup documentation. I
eventually understood the idea/point of building parallel hierarchies with
different subsystems mounted in it, and thus eventually I understand
your point about the problem on flexibility implied by an everything-rlimit
subsystem.

> Task count is a little blurry in this regard - the main resources that
> you can consume with a fork bomb are CPU cycles and memory, both of
> which are already isolated by existing subsystems, so arguably there
> shouldn't be a need to control the number of tasks itself. But I'm
> prepared to believe that there are still bits of the kernel that have
> arbitrary machine-wide limits that can be hit simply by forking a
> massive number of processes, even if they're not using much memory or
> CPU cycles.

Yeah I've just asked Johannes Weiner about that and he told me
can't use memory limits for that as these don't handle kernel
memory.

> So for this case, I'd suggest that the best option is to have a
> numtasks subsystem with "count" and "limit" files. Future rlimit
> options can go in their own subsystems or be attached to existing
> subsystems if that makes sense.

Agreed about future rlimit options, but building a single purpose
numtask subsystem looks a bit strange. Just because it looks too much
single purpose. OTOH I can't figure out any other kind of future
limitation that should fit aside in a very similar topic, enough
that we wouldn't care about seperating both for flexibility.

So I guess I'm going to take that way.

Thanks!
