Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1JAGoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 02:44:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46234 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1JAGoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 02:44:08 -0400
Subject: Re: big picture UDP/IP performance question re 2.6.18 -> 2.6.32
From: Eric Dumazet <eric.dumazet@gmail.com>
To: starlight@binnacle.cx
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <6.2.5.6.2.20111001012019.05c05b80@flumedata.com>
References: <6.2.5.6.2.20111001012019.05c05b80@flumedata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Oct 2011 08:44:02 +0200
Message-ID: <1317451442.3802.18.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 01 octobre 2011 à 01:30 -0400, starlight@binnacle.cx a écrit :
> Hello,
> 
> I'm hoping someone can provide a brief big-picture
> perspective on the dramatic UDP/IP multicast
> receive performance reduction from 2.6.18 to
> 2.6.32 that I just benchmarked.
> 
> Have helped out in the past, mainly by identifying
> a bug in hugepage handling and providing a solid
> testcase that helped in quickly identifying and
> correcting the problem.
> 
> Have a very-high-volume UDP multicast receiver
> application.  Just finished benchmarking latest RH
> variant of 2.6.18 against latest RH 2.6.32 and
> vanilla 2.6.32.27 on the same 12 core Opteron
> 6174 processor system, one CPU.
> 
> Application reads on 250 sockets with large socket
> buffer maximums.  Zero data loss.  Four Intel
> 'e1000e' 82571 gigabit NICs, or two Intel 'igb'
> 82571 gigabit NICs or two Intel 82599 10 gigabit
> NICs.  Results similar on all.
> 
> With 2.6.18, system CPU is reported in
> /proc/<pid>/stat as 25% of total.  With 2.6.32,
> system consumption is 45% with the same exact data
> playback test.  Jiffy count for user CPU is same
> for both kernels, but .32 system CPU is double
> .18 system CPU.
> 
> Overall maximum performance capacity is reduced in
> proportion to the increased system overhead.
> 
> ------
> 
> My question is why is the performance significantly
> worse in the more recent kernels?  Apparently
> network performance is worse for TCP by about the
> same amount--double the system overhead for the
> same amount of work.
> 
> http://www.phoronix.com/scan.php?page=article&item=linux_2612_2637&num=6
> 
> Is there any chance that network performance will
> improve in future kernels?  Or is the situation
> a permanent trade-off for security, reliability
> or scalability reasons?
> 

CC netdev

Since you have 2.6.32, you could use perf tool and provide us a
performance report.

In my experience, I have the exact opposite : performance greatly
improved in recent kernels. Unless you compile your kernel to include
new features that might reduce performance (namespaces, cgroup, ...)

It can vary a lot depending on many parameters, like cpu affinities,
device parameters (coalescing, interrupt mitigation...).

You cant expect switching from 2.6.18 to 2.6.32 and have exactly same
system behavior.

If your app is performance sensitive, you'll have to make some analysis
to find out what needs to be tuned.

One known problem of old kernels and UDP is that they was no memory
accouting, so an application could easily consume all kernel memory and
crash the machine.

So in 2.6.25, Hideo Aoki added memory limiting to UDP, slowing down a
lot of UDP operations because of added socket locking, both on transmit
and receive path.

If your application is multithreaded and use a single socket, you can
hit lock contention since 2.6.25.

Step by step, we tried to remove part of the scalability problems
introduced in 2.6.25

In 2.6.35, we speedup receive path a bit (avoiding backlog processing)

In 2.6.39, transmit path became lockless again, thanks to Herbert Xu.

I advise you to try a recent kernel if you need UDP performance, 2.6.32
is quite old

Multicast is quite a stress for process scheduler, so we experimented a
way to group all wakeups at the end of softirq handler.

Work is in progress in this area : Peter Zijlstra named this "delayed
wakeup". A further idea would be to be able to delegate the wakeups to
another cpu, since I suspect you have one CPU busy in softirq
processing, and other cpus are ile.



