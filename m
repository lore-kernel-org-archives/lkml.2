Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab0KOXdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:33:49 -0500
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:43105 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758803Ab0KOXdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:33:47 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-12.arcor-online.net 3B75226850
Date: Tue, 16 Nov 2010 00:33:43 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: David Rientjes <rientjes@google.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Bodo Eggert <7eggert@web.de>,
        Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <alpine.DEB.2.00.1011141345100.22262@chino.kir.corp.google.com>
Message-ID: <alpine.LNX.2.00.1011152255580.17235@be10.lrz>
References: <20101114133543.E00A.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011141345100.22262@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010, David Rientjes wrote:

> Also, stating that the new heuristic doesn't address CAP_SYS_RESOURCE
> approrpiately isn't a bug report, it's the desired behavior.  I eliminated
> all of the arbitrary heursitics in the old heuristic that we had the
> remove internally as well so that is predictable as possible and achieves
> the oom killer's sole goal: to kill the most memory-hogging task that is
> eligible to allow memory allocations in the current context to succeed.

> CAP_SYS_RESOURCE threads have full control over their oom killing priority
> by /proc/pid/oom_score_adj

, but unless they are written in the last months and designed for linux
and if the author took some time to research each external process 
invocation, they can not be aware of this possibility.

Besides that, if each process is supposed to change the default, the 
default is wrong.

> and need no consideration in the heuristic by
> default since it otherwise allows for the probability that multiple tasks
> will need to be killed when a CAP_SYS_RESOURCE thread uses an egregious
> amount of memory.

If it happens to use an egregious mount of memory, it SHOULD score
enough to get killed.

>> The problem is, DavidR patches don't refrect real world usecase at all
>> and breaking them. He can talk about the userland is wrong. but such
>> excuse doesn't solve real world issue. it makes no sense.
>
> As mentioned just a few minutes ago in another thread, there is no
> userspace breakage with the rewrite and you're only complaining here about
> the deprecation of /proc/pid/oom_adj for a period of two years.  Until
> it's removed in 2012 or later, it maps to the linear scale that
> oom_score_adj uses rather than its old exponential scale that was
> unusable for prioritization because of (1) the extremely low resolution,
> and (2) the arbitrary heuristics that preceeded it.

1) The exponential scale did have a low resolution.

2) The heuristics were developed using much brain power and much
    trial-and-error. You are going back to basics, and some people
    are not convinced that this is better. I googled and I did not
    find a discussion about how and why the new score was designed
    this way.
    looking at the output of:
    cd /proc; for a in [0-9]*; do
      echo `cat $a/oom_score` $a `perl -pes/'\0.*$'// < $a/cmdline`;
    done|grep -v ^0|sort -n |less
    , I 'm not convinced, too.

PS) Mapping an exponential value to a linear score is bad. E.g. A
     oom_adj of 8 should make an 1-MB-process as likely to kill as
     a 256-MB-process with oom_adj=0.

PS2) Because I saw this in your presentation PDF: (@udev-people)
     The -17 score of udevd is wrong, since it will even prevent
     the OOM killer from working correctly if it grows to 100 MB:

     It's default OOM score is 13, while root's shell is at 190
     and some KDE processes are at 200 000. It will not get killed
     under normal circumstances.

     If it udevd grows enough to score 190 as well, it has a bug
     that causes it to eat memory and it needs to be killed. Having
     a -17 oom_adj, it will cause the system to fail instead.
     Considering udevd's size, an adj of -1 or -2 should be enough on
     embedded systems, while desktop systems should not need it.
     If you are worried about udevd getting killed, protect ist using
     a wrapper.
