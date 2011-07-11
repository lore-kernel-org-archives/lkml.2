Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1GKO1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:27:05 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37410 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1GKO1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:27:04 -0400
Date: Mon, 11 Jul 2011 16:26:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] cgroups: New max number of tasks subsystem (was:
 cgroups rlim subsystem)
Message-ID: <20110711142653.GA4109@somewhere.redhat.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 04:14:59PM +0200, Frederic Weisbecker wrote:
> Hi all,
> 
> Changes in this release are:
> 
> * switch from general rlim subsystem to self-contained max number of tasks
> subsystem
> 
> * Don't use subsys->fork() callback but a static call to avoid cgroups
> complications.
> 
> * When moving a task accross cgroups, don't charge/uncharge the common
> ancestors, to fix race against concurrent forks.
> To fix that, Paul proposed a res_counter_move_charge() that do
> all in once. But we need to be able to cancel the attachment in case
> a following subsystem refuses the attachment itself. Thus the charge
> and uncharge still need to be seperate. More specifically, we can
> only uncharge the old cgroup once we are sure of the attachment. Because
> we can't cancel that uncharge later due to possible forks in the middle.

Ah and following Li's suggestion, the root cgroup is not touched anymore.
Considering this feature is to isolate a bit cgroups local impact from
the rest of the system, we don't need to limit in the global scope.
And we already have ways to do it.

So we avoid the overhead of this subsystem for the trivial (only one
cgroup, root) case. Although I believe that cgroups are more and more used
and the trivial case is moving toward using more cgroups :) 

Also Li suggested I use atomic ops rather than res counter. I'm still
not sure I can really do that as it exposes the counters with possibly
temporary overloaded values in the fail case.

Thanks.

> 
> Thanks.
> 
> Frederic Weisbecker (7):
>   cgroups: Add res_counter_write_u64() API
>   cgroups: New resource counter inheritance API
>   cgroups: Add previous cgroup in can_attach_task/attach_task callbacks
>   cgroups: New cancel_attach_task subsystem callback
>   cgroups: Ability to stop res charge propagation on bounded ancestor
>   cgroups: Add res counter common ancestor searching
>   cgroups: Add a max number of tasks subsystem
> 
>  block/blk-cgroup.c            |   10 ++-
>  include/linux/cgroup.h        |   15 +++-
>  include/linux/cgroup_subsys.h |    8 ++
>  include/linux/res_counter.h   |   12 +++
>  init/Kconfig                  |    7 ++
>  kernel/Makefile               |    1 +
>  kernel/cgroup.c               |   25 ++++--
>  kernel/cgroup_freezer.c       |    3 +-
>  kernel/cgroup_max_tasks.c     |  176 +++++++++++++++++++++++++++++++++++++++++
>  kernel/cpuset.c               |    6 +-
>  kernel/events/core.c          |    5 +-
>  kernel/fork.c                 |    4 +
>  kernel/res_counter.c          |   88 ++++++++++++++++++---
>  kernel/sched.c                |    6 +-
>  14 files changed, 335 insertions(+), 31 deletions(-)
>  create mode 100644 kernel/cgroup_max_tasks.c
> 
> -- 
> 1.7.5.4
> 
