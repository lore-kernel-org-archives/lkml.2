Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab0KOXud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:50:33 -0500
Received: from smtp-out.google.com ([216.239.44.51]:36033 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853Ab0KOXub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:50:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=LzEvxaoFxqiJG/by/dzzlYJAjPH2frW5Sxes8gEhiSp4vc4fo+oSF+bbubX+oqCJnk
         NijjOX592utNsh1PxufA==
Date: Mon, 15 Nov 2010 15:50:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bodo Eggert <7eggert@gmx.de>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Bodo Eggert <7eggert@web.de>,
        Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <alpine.LNX.2.00.1011152255580.17235@be10.lrz>
Message-ID: <alpine.DEB.2.00.1011151537580.29081@chino.kir.corp.google.com>
References: <20101114133543.E00A.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011141345100.22262@chino.kir.corp.google.com> <alpine.LNX.2.00.1011152255580.17235@be10.lrz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010, Bodo Eggert wrote:

> > CAP_SYS_RESOURCE threads have full control over their oom killing priority
> > by /proc/pid/oom_score_adj
> 
> , but unless they are written in the last months and designed for linux
> and if the author took some time to research each external process invocation,
> they can not be aware of this possibility.
> 

You're clearly wrong, CAP_SYS_RESOURCE has been required to modify oom_adj 
for over five years (as long as the git history).  8fb4fc68, merged into 
2.6.20, allowed tasks to raise their own oom_adj but not decrease it.  
That is unchanged by the rewrite.

> Besides that, if each process is supposed to change the default, the default
> is wrong.
> 

That doesn't make any sense, if want to protect a thread from the oom 
killer you're going to need to modify oom_score_adj, the kernel can't know 
what you perceive as being vital.  Having CAP_SYS_RESOURCE alone does not 
imply that, it only allows unbounded access to resources.  That's 
completely orthogonal to the goal of the oom killer heuristic, which is to 
find the most memory-hogging task to kill.

> 1) The exponential scale did have a low resolution.
> 
> 2) The heuristics were developed using much brain power and much
>    trial-and-error. You are going back to basics, and some people
>    are not convinced that this is better. I googled and I did not
>    find a discussion about how and why the new score was designed
>    this way.
>    looking at the output of:
>    cd /proc; for a in [0-9]*; do
>      echo `cat $a/oom_score` $a `perl -pes/'\0.*$'// < $a/cmdline`;
>    done|grep -v ^0|sort -n |less
>    , I 'm not convinced, too.
> 

The old heuristics were a mixture of arbitrary values that didn't adjust 
scores based on a unit and would often cause the incorrect task to be 
targeted because there was no clear goal being achieved.  The new 
heuristic has a solid goal: to identify and kill the most memory-hogging 
task that is eligible given the context in which the oom occurs.  If you 
disagree with that goal and want any of the old heursitics reintroduced, 
please show that it makes sense in the oom killer.

> PS) Mapping an exponential value to a linear score is bad. E.g. A
>     oom_adj of 8 should make an 1-MB-process as likely to kill as
>     a 256-MB-process with oom_adj=0.
> 

To show that, you would have to show that an application that exists today 
uses an oom_adj for something other than polarization and is based on a 
calculation of allowable memory usage.  It simply doesn't exist.

> PS2) Because I saw this in your presentation PDF: (@udev-people)
>     The -17 score of udevd is wrong, since it will even prevent
>     the OOM killer from working correctly if it grows to 100 MB:
> 

Threads with CAP_SYS_RESOURCE are free to lower the oom_score_adj of any 
thread they deem fit and that includes applications that lower its own 
oom_score_adj.  The kernel isn't going to prohibit users from setting 
their own oom_score_adj.
