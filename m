Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0H3JZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:25:57 -0400
Received: from mx.ij.cx ([212.13.201.15]:60606 "EHLO wes.ijneb.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754906Ab0H3JZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:25:55 -0400
Date: Mon, 30 Aug 2010 10:25:53 +0100 (BST)
From: Mark Hills <mark@pogo.org.uk>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: cgroup: rmdir() does not complete
In-Reply-To: <20100827102507.dc3a5ac6.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LNX.2.01.1008301013340.4381@fgnk.ybpnyqbznva>
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz> <20100827102507.dc3a5ac6.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SA-Exim-Connect-IP: 82.28.218.61
X-SA-Exim-Mail-From: mark@pogo.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010, KAMEZAWA Hiroyuki wrote:

> On Thu, 26 Aug 2010 16:51:55 +0100 (BST)
> Mark Hills <mark@pogo.org.uk> wrote:
> 
> > I am experiencing hung tasks when trying to rmdir() on a cgroup. One task 
> > spins, others queue up behind it with the following:
> > 
> >   INFO: task soaked-cgroup:27257 blocked for more than 120 seconds.
> >   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >   soaked-cgrou D ffff8800058157c0     0 27257  29411 0x00000000
> >   ffff88004ffffdd8 0000000000000086 ffff88004ffffda8 ffff88004ffffeb8
> >   0000000000000010 ffff880119813780 ffff88004ffffd48 ffff88004fffffd8
> >   ffff88004fffffd8 000000000000f9b0 00000000000157c0 ffff880137693268
> >   Call Trace:
> >   [<ffffffff81115edb>] ? mntput_no_expire+0x24/0xe7
> >   [<ffffffff81427acd>] __mutex_lock_common+0x14d/0x1b4
> >   [<ffffffff81108a7c>] ? path_put+0x1d/0x22
> >   [<ffffffff81427b48>] __mutex_lock_slowpath+0x14/0x16
> >   [<ffffffff81427c4f>] mutex_lock+0x31/0x4b
> >   [<ffffffff8110bdf8>] do_rmdir+0x74/0x102
> >   [<ffffffff8110bebd>] sys_rmdir+0x11/0x13
> >   [<ffffffff81009b02>] system_call_fastpath+0x16/0x1b
> > 
> > Kernel is from Fedora, 2.6.33.6. In all cases the cgroup contains no 
> > tasks.
> > 
> > Commit ec64f5 ("fix frequent -EBUSY at rmdir") adds a busy wait loop to 
> > the rmdir. It looks like what I am seeing here and indicates that some 
> > cgroup subsystem is busy, indefinitely.
> > 
> 
> Hmm. really spin ? sleeping-forever-no-wake-up ?

It sleeps in D state, but enters interruptable state periodically which is 
why my attention was drawn to that loop.

> > I have not worked out how to reproduce it quickly. My only way is to 
> > complete a 'dd' command in the cgroup, but then the problem is so rare it 
> > is slow progress.
> > 
> please show how-to-reproduce in your way.

I use a C program which creates a container and places itself in the 
container, then forks a dd process.

But it seems you found an easier test case; I hope to test that soon.

> And what cgroup is mounted ? memory cgroup only ?

Quite a few: memory, blkio, cpuacct, cpuset.

Until I can get a more reproducable test case (see my previous mail), I 
can't really reduce this.

> > Documentation/cgroup.memory.txt describes how force_empty can be required 
> > in some cases. 
> 
> Ah, maybe that's wrong text. rmdir() calls force-empty automatically.
> 
> > Does this mean that with the patch above, these cases will 
> > now spin on rmdir(), instead of returning -EBUSY? How can produce a 
> > reliable test case requiring memory.force_empty to be used, to test this?
> > 
> 
> Hmm. I'm not sure fedora-kernel has other (its own) featrues than stock kernel.
> I'm grad if you can check it can happen in stock kernel, 2.6.35.
> 
> > Or is it likely to be some other cause, and how best to find it?
> > 
> 
> At the first look, above mutex is the mutex in do_rmdir(), not kernel/cgroup.c
> Then, rmdir doesn't seem to reach cgroup code...

Interesting, I checked for that but not sure how I missed it. There is 
clearly a mutex lock in do_rmdir() in fs/namei.c.

> Do you do another operation on the directory while rmdir is called ?

In one case I did an 'ls -l' on the filesystem which coencided with a lock 
up, but I was not able to reproduce this.

-- 
Mark
