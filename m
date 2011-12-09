Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab1LIPfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:35:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1LIPfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:35:39 -0500
Date: Fri, 9 Dec 2011 16:30:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111209153009.GA20865@redhat.com>
References: <20111206181026.GO29781@moon> <20111207185343.GA3209@redhat.com> <20111207190340.GP21678@moon> <20111208163535.GA25023@redhat.com> <20111208212853.GO21678@moon> <20111208135430.00730308.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208135430.00730308.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08, Andrew Morton wrote:
>
> On Fri, 9 Dec 2011 01:28:53 +0400
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
> > On Thu, Dec 08, 2011 at 05:35:35PM +0100, Oleg Nesterov wrote:
> > ...
> > >
> > > However, ->children list is not rcu-safe, this means that even
> > > list_for_each() itself is not safe. Either you need tasklist or
> > > we can probably make it rcu-safe...
> > >
> >
> > Andrew, Oleg, does the below one look more less fine? Note the
> > tasklist_lock is back and it worries me a bit since I imagine
> > one could be endlessly reading some /proc/<pid>/children file
> > increasing contention over this lock on the whole system
> > (regardless the fact that it's take for read only).
>
> It is a potential problem, from the lock-hold point of view and
> also it can cause large scheduling latencies.  What's involved in
> making ->children an rcu-protected list?

At first glance, this doesn't look trivial... forget_original_parent()
abuses ->sibling.

But yes, it is not really nice to hold tasklist_lock here. May be
we can change this code so that every iteration records the reported
task_struct and then tries to continue. This means we should verify
that ->real_parent is still the same under tasklist, but at least
this way we do not hold it throughout.

> > From: Cyrill Gorcunov <gorcunov@openvz.org>
> > Subject: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v4
> >
> > There is no easy way to make a reverse parent->children chain
> > from arbitrary <pid> (while parent pid is provided in "PPid"
> > field of /proc/<pid>/status).
> >
> > So instead of walking over all pids in the system to figure out which
> > children a task have -- we add explicit /proc/<pid>/children entry,
> > because kernel already has this kind of information but it is not
> > yet exported. This is a first level children, not the whole process
> > tree, neither the process threads are identified with this interface.
>
> The changelog doesn't explain why we want the patch, so there's no
> reason to merge it!  Something to do with c/r, yes?
>
> If so, I guess the feature could/should be configurable.  Probably with
> a CONFIG_PROC_CHILDREN which is selected by CONFIG_CHECKPOINT_RESTORE.
> Which is all getting a bit over the top, but I suppose we must do it.

Heh. This is the rare case when I personally like the new feature ;)
I mean, it looks "obviously useful" to me. If nothing else, it can
help to debug the problems. Probably the tools like pstree can use it.

Personally I'd even prefer /proc/pid/children/ directory (like
/proc/pid/task), but I guess this needs much more complications.

Oleg.

