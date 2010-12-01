Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab0LAF5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 00:57:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34727 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752615Ab0LAF5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 00:57:53 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ZoKNZiggZaIM2GF5o31BFnOQeI6iZsoxTxSjSHN
	fZhIlIc9CA/6b6
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101130193622.GF26758@redhat.com>
References: <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
	 <1291052268.32004.171.camel@laptop>
	 <1291057565.20709.2.camel@marge.simson.net>
	 <20101129192033.GA18372@elte.hu>
	 <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
	 <1291090455.7550.7.camel@marge.simson.net>
	 <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com>
	 <1291123083.28239.18.camel@marge.simson.net>
	 <20101130151749.GE26758@redhat.com>
	 <1291137221.28239.70.camel@marge.simson.net>
	 <20101130193622.GF26758@redhat.com>
Content-Type: text/plain
Date: Wed, 01 Dec 2010 06:57:48 +0100
Message-Id: <1291183068.7466.140.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 14:36 -0500, Vivek Goyal wrote:

> Few things.
> 
> - This /proc/<pid>/autogroup is good for doing this single thing but when
>   I start thinking of possible extensions of it down the line, it creates
>   issues. 
> 
> - Once we have some kind of uppper limit support in cpu controller, these
>   autogroups are beyond control. If you want to impose some kind of 
>   limits on them then you shall have to extend parallel interface
>   /proc/<pid>/autogroup to also speicify upper limit (like nice levels).
> 
> - Similiarly if this autgroup notion is extended to other cgroup
>   controllers, then you shall have to again extend /proc/<pid>/autogroup
>   to be able to specify these additional parameters.

Yes, if it evolves, it's interface will need to evolve as well.  It
could have been a directory containing buttons, knobs and statistics,
but KISS won.

> - If there is a monitoring tool which is monitoring the system for
>   resource usage by the groups, then I think these autogroups are beyond
>   reach and any stats exported by cgroup interface will not be available.
>   (though right now I can't see any stats being exported by cgroup files
>    in cpu controller but other controllers like block and memory do.).

If you're manually assigning bandwidth et al from userland, there's not
much point to in-kernel automation is there?

If I had married the two, the first thing that would have happened is
gripes about things appearing and disappearing in cgroups directories,
resulting in mayhem and confusion for scripts and tools.

> - I am doing some testing with the patch and w.r.t. cgroup interface some
>   things don't seem right.
> 
>   I have applied your patch and enabled CONFIG_AUTO_GROUP. Now I boot
>   into the kernel and open a new ssh connection to the machine. 
> 
>   # echo $$
>     3555
>   # cat /proc/3555/autogroup
>     /autogroup-63 nice 0
> 
>   IIUC, task 3555 has been moved into an autogroup. Now I mount the cpu
>   controller and this task is visible in root cgroup.
> 
>   # mount -t cgroup -o cpu none /cgroup/cpu
>   # cat /cgroup/cpu/tasks | grep 3555
>     3555
> 
>   First of all this gives user a wrong impression that task 3555 is in
>   root cgroup.

It is in the root cgroup.  It is not in the root autogroup is not
auto-cgroups group.

>   Now I create a child group test1 and move the task there and also change
>   the weight/shares of the cgroup to 10240.
> 
>   # mkdir test1
>   # echo 3555 > test1/tasks
>   # echo 10240 > test1/cpu.shares
>   # cat /proc/3555/cgroup
>     3:cpu:/test1
>   # cat /proc/3555/autogroup
>     /autogroup-63 nice 0
> 
> So again, user will think that task is in cgroup test1 and is being
> controlled by the respective weight but that's not the case.

It is the case here.

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 7573 root      20   0  7996  340  256 R   50  0.0   3:35.86 3 pert
 7572 root      20   0  7996  340  256 R   50  0.0   9:21.68 3 pert
...
marge:/cgroups/test # echo 7572 > tasks
marge:/cgroups/test # echo 4096 > cpu.shares

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 7572 root      20   0  7996  340  256 R   80  0.0  10:06.92 3 pert
 7573 root      20   0  7996  340  256 R   20  0.0   4:05.80 3 pert

When you move a task into a cgroup, it still has an autogroup
association, as all tasks (processes actually) do, but it's not used.

> Even if we prevent autogroup task from being visible in cpu controller
> root group, then comes the question what happens if cpu and some other
> controller is comounted. Say cpuset. Now in that case will task be 
> visible in root group task file and can one operate on that. Now showing
> up there does not make much sense as task should still be controllable
> by other controllers and its policies.

The user has to specifically ask for it in his config, can turn it on or
off on the fly or at boot..

> So yes, creating a /proc/<pid>/autogroup is dirt cheap and makes the life
> easier in terms of implementation of this patch and it should work well.
> But it is also a new user interface which does not sound too extensible and
> does not seem to cooperate well with cgroup interface

..it has a different mission, with different users being targeted, so
why does it need to hold hands?

> It also introduces this new notion of niceness for task groups which is sort
> of equivalent to cpu.shares in cpu controller. First of all why should we
> not stick to shares notion even for autogroup. Even if we introduce the notion
> of niceness for groups, IMHO, it should be through cgroup interface instead of
> group niceness for autogroup and shares/weights for cgroup despite the
> fact that in the background they do similar things.

IMHO, cgroups should have been 'nice' from the start, but the folks who
wrote it did what they thought best.  I like nice a lot better than
shares, so I used nice.

> I think above concerns can possibly be reason enough to think about about
> the wedding.

Perhaps in future, they'll get married, and perhaps they should, but in
the here and now, I think they have similar but not identical missions.
If you turn on one, turn off the other.  Maybe that should be automated.

Systemd thingy may make autogroup short lived anyway.  I had a query
from an embedded guy (hm, which I spaced) suggesting autogroup may be
quite nice for handheld stuff though, so who knows.

	-Mike

