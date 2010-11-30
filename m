Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0K3Tgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:36:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab0K3Tgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:36:48 -0500
Date: Tue, 30 Nov 2010 14:36:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101130193622.GF26758@redhat.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291137221.28239.70.camel@marge.simson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 06:13:41PM +0100, Mike Galbraith wrote:
> On Tue, 2010-11-30 at 10:17 -0500, Vivek Goyal wrote:
> 
> > Hi Mike,
> 
> Hi,
> 
> > I was wonderig if these autogroups can be visible in regular cgroup
> > hierarchy so that once somebody mounts cpu controller, these are visible?
> 
> No, autogroup is not auto-cgroup.  You get zero whistles and zero bells
> with autogroup.  Only dirt simple automated task groups.
> 
> > I was wondering why is a good idea to create a separate interface for
> > autogroups through proc and not try to integrate it with cgroup interface.
> 
> I only put an interface there at all because it was requested, and made
> it a dirt simple 'nice level' interface because there's nothing simpler
> than 'nice'.  The whole autogroup thing is intended for folks who don't
> want to set up cgroups, shares yadayada, so tying it into the cgroups
> interface seems kinda pointless.
> 
> > Without it now any user space tool shall have to either disable the
> > autogroup feature completely or now also worry about /proc interface
> > and there also autogroups are searchable through pid and there is no
> > direct way to access these.
> 
> Maybe I should make it disable itself when you mount big brother.
> 
> > IIUC, these autogroups create flat setup and are at same level as
> > init_task_group and are not children of it. Currently cpu cgroup 
> > is hierarchical by default and any new cgroup is child of init_task_group
> > and that could lead to representation issues.
> 
> Well, it's flat, but autogroup does..
> 	tg = sched_create_group(&init_task_group);
> 
> > Well, will we not get same kind of latency boost if we make these autogroups
> > children of root? If yes, then hierarchical representation issue of autogroup
> > will be a moot point.
> 
> No problem then.
> 
> > We already have /proc/<pid>/cgroup interface which points to tasks's
> > cgroup. We probably can avoid creating /proc/<pid>/autgroup if there
> > is an associated cgroup which appears in cgroup hierachy and then user
> > can change the weight of group through cgroup interface (instead of
> > introducing another interface).
> 
> That's possible (for someone familiar with cgroups;), but I don't see
> any reason for a wedding.

Few things.

- This /proc/<pid>/autogroup is good for doing this single thing but when
  I start thinking of possible extensions of it down the line, it creates
  issues. 

- Once we have some kind of uppper limit support in cpu controller, these
  autogroups are beyond control. If you want to impose some kind of 
  limits on them then you shall have to extend parallel interface
  /proc/<pid>/autogroup to also speicify upper limit (like nice levels).

- Similiarly if this autgroup notion is extended to other cgroup
  controllers, then you shall have to again extend /proc/<pid>/autogroup
  to be able to specify these additional parameters.

- If there is a monitoring tool which is monitoring the system for
  resource usage by the groups, then I think these autogroups are beyond
  reach and any stats exported by cgroup interface will not be available.
  (though right now I can't see any stats being exported by cgroup files
   in cpu controller but other controllers like block and memory do.).

- I am doing some testing with the patch and w.r.t. cgroup interface some
  things don't seem right.

  I have applied your patch and enabled CONFIG_AUTO_GROUP. Now I boot
  into the kernel and open a new ssh connection to the machine. 

  # echo $$
    3555
  # cat /proc/3555/autogroup
    /autogroup-63 nice 0

  IIUC, task 3555 has been moved into an autogroup. Now I mount the cpu
  controller and this task is visible in root cgroup.

  # mount -t cgroup -o cpu none /cgroup/cpu
  # cat /cgroup/cpu/tasks | grep 3555
    3555

  First of all this gives user a wrong impression that task 3555 is in
  root cgroup.

  Now I create a child group test1 and move the task there and also change
  the weight/shares of the cgroup to 10240.

  # mkdir test1
  # echo 3555 > test1/tasks
  # echo 10240 > test1/cpu.shares
  # cat /proc/3555/cgroup
    3:cpu:/test1
  # cat /proc/3555/autogroup
    /autogroup-63 nice 0

So again, user will think that task is in cgroup test1 and is being
controlled by the respective weight but that's not the case.

Even if we prevent autogroup task from being visible in cpu controller
root group, then comes the question what happens if cpu and some other
controller is comounted. Say cpuset. Now in that case will task be 
visible in root group task file and can one operate on that. Now showing
up there does not make much sense as task should still be controllable
by other controllers and its policies.

So yes, creating a /proc/<pid>/autogroup is dirt cheap and makes the life
easier in terms of implementation of this patch and it should work well.
But it is also a new user interface which does not sound too extensible and
does not seem to cooperate well with cgroup interface.

It also introduces this new notion of niceness for task groups which is sort
of equivalent to cpu.shares in cpu controller. First of all why should we
not stick to shares notion even for autogroup. Even if we introduce the notion
of niceness for groups, IMHO, it should be through cgroup interface instead of
group niceness for autogroup and shares/weights for cgroup despite the
fact that in the background they do similar things.

I think above concerns can possibly be reason enough to think about about
the wedding.

Thanks
Vivek
