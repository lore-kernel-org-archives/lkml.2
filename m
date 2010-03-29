Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0C2Kwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:52:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:47134 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755252Ab0C2Kwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:52:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+bJeoFqoOb+Zv7WZMz3D5jvEhw9ILbvtKMPDgeHy
	JB9AyVJj7Qc5RD
Subject: Re: scheduler bug: process running since 5124095h
From: Mike Galbraith <efault@gmx.de>
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <4BAF1802.8070002@gmail.com>
References: <4BADD408.8080609@gmail.com>  <4BAF1802.8070002@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 12:52:40 +0200
Message-Id: <1269859960.6844.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-28 at 11:49 +0300, Török Edwin wrote:
> On 03/27/2010 11:46 AM, Török Edwin wrote:
> > Hi Ingo, Peter,
> > 
> > top has just shown me this:
> > PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> > 
> >                                                                  6524
> > edwin     20   0  228m  10m 8116 R    2  0.3  5124095h gkrellm
> > 
> > Now obviously that process is not running since 5124095h!
> > It looks like some overflow to me, the time in nanoseconds would be
> > approx 0xFFFFFE1D2D476000, which is approx. minus 34 minutes.
> > Thats about consistent with the uptime, but I don't know why it became
> > negative:
> >  11:45:48 up 42 min,  9 users,  load average: 0.56, 0.25, 0.19
> > 
> > I've attached the cfs-debug-info.sh output.
> > 
> > This happens when using Linux 2.6.33 (actually glisse's drm-radeon tree
> > which is based on 2.6.33), its the first time I noticed this.
> > 
> > I don't know what caused it, the last things I did was:
> 
> I have a simple way to reproduce this:
> 1. Boot the system, run top, confirm everything is normal
> 2. Run latencytop, and quit (I used version 0.5)
> 3. Run top, see 5124095h in the TIME column

Indeed, and I don't even have CONFIG_LATENCYTOP set.  It bisected to...

761b1d26df542fd5eb348837351e4d2f3bc7bffe is the first bad commit
commit 761b1d26df542fd5eb348837351e4d2f3bc7bffe
Author: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date:   Thu Nov 12 13:33:45 2009 +0900

    sched: Fix granularity of task_u/stime()
    
    Originally task_s/utime() were designed to return clock_t but
    later changed to return cputime_t by following commit:
    
      commit efe567fc8281661524ffa75477a7c4ca9b466c63
      Author: Christian Borntraeger <borntraeger@de.ibm.com>
      Date:   Thu Aug 23 15:18:02 2007 +0200
    
    It only changed the type of return value, but not the
    implementation. As the result the granularity of task_s/utime()
    is still that of clock_t, not that of cputime_t.
    
    So using task_s/utime() in __exit_signal() makes values
    accumulated to the signal struct to be rounded and coarse
    grained.
    
    This patch removes casts to clock_t in task_u/stime(), to keep
    granularity of cputime_t over the calculation.
    
    v2:
      Use div_u64() to avoid error "undefined reference to `__udivdi3`"
      on some 32bit systems.
    
    Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
    Acked-by: Peter Zijlstra <peterz@infradead.org>
    Cc: xiyou.wangcong@gmail.com
    Cc: Spencer Candland <spencer@bluehost.com>
    Cc: Oleg Nesterov <oleg@redhat.com>
    Cc: Stanislaw Gruszka <sgruszka@redhat.com>
    LKML-Reference: <4AFB9029.9000208@jp.fujitsu.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 9b4e832857ee9694807de86be7d88bbbc2223c50 a78e66f0b8356005c3b963de64b38269147e47e0 M	kernel
git bisect start
# good: [7f5e918e62cbc9ac27c2f47d3c3dd4b86f67ff0e] Linux 2.6.32.9
git bisect good 7f5e918e62cbc9ac27c2f47d3c3dd4b86f67ff0e
# bad: [baac35c4155a8aa826c70acee6553368ca5243a2] security: fix error return path in ima_inode_alloc
git bisect bad baac35c4155a8aa826c70acee6553368ca5243a2
# bad: [baac35c4155a8aa826c70acee6553368ca5243a2] security: fix error return path in ima_inode_alloc
git bisect bad baac35c4155a8aa826c70acee6553368ca5243a2
# bad: [baac35c4155a8aa826c70acee6553368ca5243a2] security: fix error return path in ima_inode_alloc
git bisect bad baac35c4155a8aa826c70acee6553368ca5243a2
# good: [22763c5cf3690a681551162c15d34d935308c8d7] Linux 2.6.32
git bisect good 22763c5cf3690a681551162c15d34d935308c8d7
# bad: [5f1141eb352ea79d849920039503e40dd623fffa] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6
git bisect bad 5f1141eb352ea79d849920039503e40dd623fffa
# bad: [d7fc02c7bae7b1cf69269992cf880a43a350cdaa] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6
git bisect bad d7fc02c7bae7b1cf69269992cf880a43a350cdaa
# good: [cfb3f91af49dff9b50de6929dc4de06100c4cfa8] ixgbe: handle parameters for tx and rx EITR, no div0
git bisect good cfb3f91af49dff9b50de6929dc4de06100c4cfa8
# good: [c3fa27d1367fac63ac8533d6f20ea851d0d70a10] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good c3fa27d1367fac63ac8533d6f20ea851d0d70a10
# good: [86e1d57e4f24ca27ce813bdc2afaac4adafcbaf4] Merge branch 'topic/hda' into for-linus
git bisect good 86e1d57e4f24ca27ce813bdc2afaac4adafcbaf4
# good: [8f56874bd7e8bee73ed6a1cf80dcec2753616262] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6
git bisect good 8f56874bd7e8bee73ed6a1cf80dcec2753616262
# bad: [c2ed69cdc9da49a8d2d7b4212fd225abf902ceaa] Merge branch 'x86-cleanups-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad c2ed69cdc9da49a8d2d7b4212fd225abf902ceaa
# bad: [897e81bea1fcfcd2c5cdb720c9efdb25da9ff374] Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 897e81bea1fcfcd2c5cdb720c9efdb25da9ff374
# bad: [fe3bcfe1f6c1fc4ea7706ac2d05e579fd9092682] sched: More generic WAKE_AFFINE vs select_idle_sibling()
git bisect bad fe3bcfe1f6c1fc4ea7706ac2d05e579fd9092682
# good: [e2c880630438f80b474378d5487b511b07665051] cpumask: Simplify sched_rt.c
git bisect good e2c880630438f80b474378d5487b511b07665051
# good: [d8c80ce091f6ead6710bc71b58f2c32e5bf855e4] sched, no_hz: Remove unused rq->last_tick_seen field
git bisect good d8c80ce091f6ead6710bc71b58f2c32e5bf855e4
# good: [ffd44db5f02af32bcc25a8eb5981bf02a141cdab] sched: Make sure task has correct sched_class after policy change
git bisect good ffd44db5f02af32bcc25a8eb5981bf02a141cdab
# bad: [a50bde5130f65733142b32975616427d0ea50856] sched: Cleanup select_task_rq_fair()
git bisect bad a50bde5130f65733142b32975616427d0ea50856
# bad: [761b1d26df542fd5eb348837351e4d2f3bc7bffe] sched: Fix granularity of task_u/stime()
git bisect bad 761b1d26df542fd5eb348837351e4d2f3bc7bffe


