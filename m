Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0LAO42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:56:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0LAO41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:56:27 -0500
Date: Wed, 1 Dec 2010 09:55:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101201145556.GE4672@redhat.com>
References: <1291057565.20709.2.camel@marge.simson.net>
 <20101129192033.GA18372@elte.hu>
 <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
 <1291090455.7550.7.camel@marge.simson.net>
 <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com>
 <1291123083.28239.18.camel@marge.simson.net>
 <20101130151749.GE26758@redhat.com>
 <1291137221.28239.70.camel@marge.simson.net>
 <20101130193622.GF26758@redhat.com>
 <1291183068.7466.140.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291183068.7466.140.camel@marge.simson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 06:57:48AM +0100, Mike Galbraith wrote:

[..]
> 
> > - I am doing some testing with the patch and w.r.t. cgroup interface some
> >   things don't seem right.
> > 
> >   I have applied your patch and enabled CONFIG_AUTO_GROUP. Now I boot
> >   into the kernel and open a new ssh connection to the machine. 
> > 
> >   # echo $$
> >     3555
> >   # cat /proc/3555/autogroup
> >     /autogroup-63 nice 0
> > 
> >   IIUC, task 3555 has been moved into an autogroup. Now I mount the cpu
> >   controller and this task is visible in root cgroup.
> > 
> >   # mount -t cgroup -o cpu none /cgroup/cpu
> >   # cat /cgroup/cpu/tasks | grep 3555
> >     3555
> > 
> >   First of all this gives user a wrong impression that task 3555 is in
> >   root cgroup.
> 
> It is in the root cgroup.  It is not in the root autogroup is not
> auto-cgroups group.
> 
> >   Now I create a child group test1 and move the task there and also change
> >   the weight/shares of the cgroup to 10240.
> > 
> >   # mkdir test1
> >   # echo 3555 > test1/tasks
> >   # echo 10240 > test1/cpu.shares
> >   # cat /proc/3555/cgroup
> >     3:cpu:/test1
> >   # cat /proc/3555/autogroup
> >     /autogroup-63 nice 0
> > 
> > So again, user will think that task is in cgroup test1 and is being
> > controlled by the respective weight but that's not the case.
> 
> It is the case here.
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
>  7573 root      20   0  7996  340  256 R   50  0.0   3:35.86 3 pert
>  7572 root      20   0  7996  340  256 R   50  0.0   9:21.68 3 pert
> ...
> marge:/cgroups/test # echo 7572 > tasks
> marge:/cgroups/test # echo 4096 > cpu.shares
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
>  7572 root      20   0  7996  340  256 R   80  0.0  10:06.92 3 pert
>  7573 root      20   0  7996  340  256 R   20  0.0   4:05.80 3 pert
> 
> When you move a task into a cgroup, it still has an autogroup
> association, as all tasks (processes actually) do, but it's not used.

Ok, so I got confused with the fact that after moving a task into a
cgroup it is still associated with an autogroup.

So IIUC, if a task is in root cgroup, then it would not necessarily be driven
by cpu.shares of root cgroup (as task could be in its own autogroup). But
if I move the task into a non-root cgroup, then it will for sure be
subjected to rules imposed by non-root cgroup cpu.shares. That's not too
bad.

Thanks
Vivek
